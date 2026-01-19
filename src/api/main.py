from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Dict, Any
import json
import os
from datetime import datetime

app = FastAPI(title="AGENTIK™ API", description="Local-first agent orchestration platform")

# Enable CORS for web UI
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Local-first, so allow all for development
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount static files
static_dir = os.path.join(os.path.dirname(__file__), "..", "web")
if os.path.exists(static_dir):
    app.mount("/static", StaticFiles(directory=static_dir), name="static")

# Data storage (local JSON files)
DATA_DIR = os.path.join(os.path.dirname(__file__), "..", "data")
os.makedirs(DATA_DIR, exist_ok=True)

AGENTS_FILE = os.path.join(DATA_DIR, "agents.json")
WORKFLOWS_FILE = os.path.join(DATA_DIR, "workflows.json")

# Pydantic models
class Agent(BaseModel):
    id: str
    name: str
    description: str
    type: str
    config: Dict[str, Any] = {}

class Workflow(BaseModel):
    id: str
    name: str
    description: str
    agents: List[str]  # Agent IDs
    steps: List[Dict[str, Any]] = []
    status: str = "pending"
    created_at: str = None

class WorkflowExecution(BaseModel):
    workflow_id: str
    inputs: Dict[str, Any] = {}

# Helper functions
def load_agents() -> List[Agent]:
    if os.path.exists(AGENTS_FILE):
        with open(AGENTS_FILE, 'r') as f:
            data = json.load(f)
            return [Agent(**agent) for agent in data]
    return []

def save_agents(agents: List[Agent]):
    with open(AGENTS_FILE, 'w') as f:
        json.dump([agent.dict() for agent in agents], f, indent=2)

def load_workflows() -> List[Workflow]:
    if os.path.exists(WORKFLOWS_FILE):
        with open(WORKFLOWS_FILE, 'r') as f:
            data = json.load(f)
            return [Workflow(**wf) for wf in data]
    return []

def save_workflows(workflows: List[Workflow]):
    with open(WORKFLOWS_FILE, 'w') as f:
        json.dump([wf.dict() for wf in workflows], f, indent=2)

# API endpoints
@app.get("/")
async def root():
    return {"message": "AGENTIK™ API - Local-first agent orchestration", "version": "0.1.0"}

@app.get("/agents", response_model=List[Agent])
async def get_agents():
    return load_agents()

@app.post("/agents", response_model=Agent)
async def create_agent(agent: Agent):
    agents = load_agents()
    if any(a.id == agent.id for a in agents):
        raise HTTPException(status_code=400, detail="Agent with this ID already exists")
    agents.append(agent)
    save_agents(agents)
    return agent

@app.get("/agents/{agent_id}", response_model=Agent)
async def get_agent(agent_id: str):
    agents = load_agents()
    agent = next((a for a in agents if a.id == agent_id), None)
    if not agent:
        raise HTTPException(status_code=404, detail="Agent not found")
    return agent

@app.get("/workflows", response_model=List[Workflow])
async def get_workflows():
    return load_workflows()

@app.post("/workflows", response_model=Workflow)
async def create_workflow(workflow: Workflow):
    workflows = load_workflows()
    if any(w.id == workflow.id for w in workflows):
        raise HTTPException(status_code=400, detail="Workflow with this ID already exists")

    workflow.created_at = datetime.now().isoformat()
    workflows.append(workflow)
    save_workflows(workflows)
    return workflow

@app.get("/workflows/{workflow_id}", response_model=Workflow)
async def get_workflow(workflow_id: str):
    workflows = load_workflows()
    workflow = next((w for w in workflows if w.id == workflow_id), None)
    if not workflow:
        raise HTTPException(status_code=404, detail="Workflow not found")
    return workflow

@app.post("/workflows/{workflow_id}/execute")
async def execute_workflow(workflow_id: str, execution: WorkflowExecution):
    workflows = load_workflows()
    workflow = next((w for w in workflows if w.id == workflow_id), None)
    if not workflow:
        raise HTTPException(status_code=404, detail="Workflow not found")

    # Simple execution logic (placeholder)
    # In a real implementation, this would orchestrate the agents
    result = {
        "workflow_id": workflow_id,
        "status": "executed",
        "timestamp": datetime.now().isoformat(),
        "inputs": execution.inputs,
        "outputs": {"message": f"Workflow {workflow.name} executed successfully"}
    }

    # Update workflow status
    workflow.status = "completed"
    save_workflows(workflows)

    return result

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
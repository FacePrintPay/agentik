from abc import ABC, abstractmethod
from typing import Dict, Any, Optional
import logging

logger = logging.getLogger(__name__)

class BaseAgent(ABC):
    """Base class for all agents in AGENTIK™"""

    def __init__(self, agent_id: str, config: Dict[str, Any] = None):
        self.agent_id = agent_id
        self.config = config or {}
        self.logger = logging.getLogger(f"{__name__}.{self.__class__.__name__}")

    @abstractmethod
    async def initialize(self) -> bool:
        """Initialize the agent. Return True if successful."""
        pass

    @abstractmethod
    async def execute(self, inputs: Dict[str, Any]) -> Dict[str, Any]:
        """Execute the agent's main logic. Return outputs."""
        pass

    @abstractmethod
    async def cleanup(self) -> bool:
        """Clean up resources. Return True if successful."""
        pass

    def get_info(self) -> Dict[str, Any]:
        """Get agent information."""
        return {
            "id": self.agent_id,
            "type": self.__class__.__name__,
            "config": self.config
        }

class TaskRunnerAgent(BaseAgent):
    """Simple agent that runs predefined tasks"""

    async def initialize(self) -> bool:
        self.logger.info(f"Initializing TaskRunnerAgent {self.agent_id}")
        return True

    async def execute(self, inputs: Dict[str, Any]) -> Dict[str, Any]:
        task = inputs.get("task", "echo 'Hello from AGENTIK™'")
        self.logger.info(f"Executing task: {task}")

        # Simple task execution (in real implementation, use subprocess or similar)
        if task.startswith("echo "):
            output = task[5:]  # Remove "echo "
        else:
            output = f"Executed: {task}"

        return {
            "output": output,
            "timestamp": inputs.get("timestamp", "unknown")
        }

    async def cleanup(self) -> bool:
        self.logger.info(f"Cleaning up TaskRunnerAgent {self.agent_id}")
        return True

class DataProcessorAgent(BaseAgent):
    """Agent that processes data (e.g., text analysis, simple calculations)"""

    async def initialize(self) -> bool:
        self.logger.info(f"Initializing DataProcessorAgent {self.agent_id}")
        return True

    async def execute(self, inputs: Dict[str, Any]) -> Dict[str, Any]:
        data = inputs.get("data", "")
        operation = inputs.get("operation", "count_words")

        self.logger.info(f"Processing data with operation: {operation}")

        if operation == "count_words":
            word_count = len(data.split()) if data else 0
            result = {"word_count": word_count}
        elif operation == "uppercase":
            result = {"processed_data": data.upper()}
        elif operation == "lowercase":
            result = {"processed_data": data.lower()}
        else:
            result = {"error": f"Unknown operation: {operation}"}

        return result

    async def cleanup(self) -> bool:
        self.logger.info(f"Cleaning up DataProcessorAgent {self.agent_id}")
        return True

# Agent registry
AGENT_CLASSES = {
    "TaskRunnerAgent": TaskRunnerAgent,
    "DataProcessorAgent": DataProcessorAgent,
}
#!/usr/bin/env python3
"""
AGENTIK™ Server Runner
Starts the FastAPI backend server for the local-first agent orchestration platform.
"""

import uvicorn
import sys
import os

# Add src to path so we can import our modules
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'src'))

def main():
    print("🌍 Starting AGENTIK™ Server...")
    print("Local-first agent orchestration platform")
    print("")

    # Import after path setup
    from api.main import app

    print("🚀 Server starting on http://localhost:8000")
    print("📊 API docs available at http://localhost:8000/docs")
    print("🖥️  Dashboard available at http://localhost:8000/static/dashboard.html")
    print("")
    print("Press Ctrl+C to stop the server")
    print("")

    uvicorn.run(
        "api.main:app",
        host="0.0.0.0",
        port=8000,
        reload=True,  # Enable auto-reload for development
        log_level="info"
    )

if __name__ == "__main__":
    main()
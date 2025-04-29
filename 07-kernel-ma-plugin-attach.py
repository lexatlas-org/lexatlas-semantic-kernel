# main.py
import asyncio
import os
from pathlib import Path
from agent_utils import (
    get_agent_by_name,
    get_project_client,
    get_root_dir,
    list_all_files_in_folder,
    upload_files_create_vector_store_return_tool,
)

from azure.ai.projects.models import FunctionTool, RequiredFunctionToolCall, SubmitToolOutputsAction, ToolOutput
from plugins.user_functions import user_functions
functions = FunctionTool(functions=user_functions)

ROOT_DIR = get_root_dir()

async def main():
    client = get_project_client()

    agent_retriever = await get_agent_by_name(client, 'ComplianceChecker')


    client.agents.update_agent(
        agent_id=agent_retriever.id, 
        tools=functions.definitions,
        tool_resources=functions.resources

    )   

if __name__ == "__main__":
    asyncio.run(main())

 
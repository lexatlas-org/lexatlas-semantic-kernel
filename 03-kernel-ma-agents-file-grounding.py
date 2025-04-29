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

ROOT_DIR = get_root_dir()

async def main():
    client = get_project_client()

    agent_retriever = await get_agent_by_name(client, 'RegulationRetriever')

    file_paths = list_all_files_in_folder(ROOT_DIR / "dataset/v2/regulations")
 
    vector_store_name = "vector_store_regulations"

    file_search_tool = upload_files_create_vector_store_return_tool(
        client=client,
        file_paths=file_paths,
        vector_store_name=vector_store_name,
    )

    client.agents.update_agent(
        agent_id=agent_retriever.id, 
        tools=file_search_tool.definitions, 
        tool_resources=file_search_tool.resources
    )   

if __name__ == "__main__":
    asyncio.run(main())

 
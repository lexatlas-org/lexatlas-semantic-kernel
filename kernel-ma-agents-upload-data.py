# main.py
import asyncio
from agent_utils import (
    get_agent_by_id,
    get_project_client,
    get_root_dir,
    upload_files_create_vector_store_return_tool,
    # upload_multiple_files_and_create_vector_store,
)
from config import agents_config  # (Still imported for future use)

ROOT_DIR = get_root_dir()

async def main():
    client = get_project_client()

    agent_id = "asst_tkcxfBRgzYP1rhMIHmU64qFH"  # Replace with your actual agent ID
    agent = get_agent_by_id(client, agent_id)

    print(f"Running agent: {agent.name} with ID: {agent.id}")

    # with client:  # Important: use async context
    file_paths = [
        ROOT_DIR / "prompts" / "docs" / "regulations" / "doc01.txt",
        ROOT_DIR / "prompts" / "docs" / "regulations" / "doc02.txt",
    ]
        
    vector_store_name = "my_vector_store"

    file_search_tool = upload_files_create_vector_store_return_tool(
        client=client,
        file_paths=file_paths,
        vector_store_name=vector_store_name,
    )

    client.agents.update_agent(
        agent_id=agent.id, 
        tools=file_search_tool.definitions, 
        tool_resources=file_search_tool.resources
    )   

if __name__ == "__main__":
    asyncio.run(main())

 
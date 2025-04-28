# main.py
import asyncio
from agent_utils import (
    get_project_client,
    get_root_dir,
    upload_multiple_files_and_create_vector_store,
)
from config import agents_config  # (Still imported for future use)

ROOT_DIR = get_root_dir()

async def main():
    client = get_project_client()

    # agent = client.agents.create_agent(
    #     model="gpt-4o-mini",
    #     name="my-agent",
    #     instructions="You are a helpful agent",
    #     # tools=file_search_tool.definitions,
    #     # tool_resources=file_search_tool.resources,
    # )
    # agent.update()
    # client.agents.update_agent(agent.id, agent)

    with client:  # Important: use async context
        file_paths = [
            ROOT_DIR / "prompts" / "docs" / "regulations" / "doc01.txt",
            ROOT_DIR / "prompts" / "docs" / "regulations" / "doc02.txt",
        ]
        
        vector_store_name = "my_vector_store"

        vector_store = await upload_multiple_files_and_create_vector_store(
            client=client,
            file_paths=file_paths,
            vector_store_name=vector_store_name,
        )

        print(f"Vector Store '{vector_store.name}' created with ID: {vector_store.id}")

if __name__ == "__main__":
    asyncio.run(main())

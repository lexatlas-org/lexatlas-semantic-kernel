# main.py
import asyncio
import time
from agent_utils import (
    get_project_client,
    create_agent_and_thread,
    read_file_content,
)
from config import agents_config  # Import agents_config from config.py

async def main():
    client = get_project_client()

    with client:
        for agent_info in agents_config:
            print(f"Creating agent: {agent_info['name']} with model: {agent_info['model']}")
            
            # Read the instructions from file
            instructions_content = read_file_content(agent_info['instructions'])

            # Create agent and thread
            agent, thread = await create_agent_and_thread(
                client,
                model_name=agent_info['model'],
                agent_name=agent_info['name'],
                instructions=instructions_content
            )

            print(f"Agent '{agent['name']}' created successfully.")
            print(f"Thread ID: {thread.id} created successfully.")
            time.sleep(5)

if __name__ == "__main__":
    asyncio.run(main())
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
        agent_list = client.agents.list_agents()
        if agent_list.data:
            for agent in agent_list.data:
                 print(f"Agent Name: {agent.name} \t\t Agent ID:{agent.id}")

if __name__ == "__main__":
    asyncio.run(main())


    
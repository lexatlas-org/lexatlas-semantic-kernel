# main.py
import asyncio
import time
from agent_utils import (
    display_responses,
    get_project_client,
    get_agent_by_id,
    get_root_dir,
    read_all_files_and_join
)
from config import agents_config  # Import agents_config from config.py


projects = read_all_files_and_join(get_root_dir() / "prompts/docs/projects")
project =  """
            Document ID: doc_001
            Title: New York Renewable Energy Siting Law §94-c
            Summary: Projects building renewable energy facilities over 25 MW must obtain a permit from the Office of Renewable Energy Siting (ORES) before construction begins. Failure to secure approval results in regulatory noncompliance.
            """

async def main():
    client = get_project_client()

    with client:
        for agent_config in agents_config:
            if agent_config['name'] != "ClassifierAgent":
                continue

            agent = get_agent_by_id(client, agent_config["id"])
            if agent is None:
                continue

            print(f"Running agent: {agent_config['name']} with ID: {agent.id}")

            if agent_config['name'] == "ClassifierAgent":
                # user_query = project 
                user_query =  projects 
            elif agent_config['name'] == "RegulationRetriever":
                user_query = project


            thread = client.agents.create_thread()

            message = client.agents.create_message(
                thread_id=thread.id,
                role="user",
                content=user_query,
            )

            run = client.agents.create_and_process_run(thread_id=thread.id, agent_id=agent.id)

            messages = client.agents.list_messages(thread_id=thread.id)
            display_responses(messages)


if __name__ == "__main__":
    asyncio.run(main())


    
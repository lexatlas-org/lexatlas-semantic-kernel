# main.py
import asyncio
import time
from agent_utils import (
    extract_responses,
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

    # -------------------------------------------------------------------------
    #  Phase 1 - Classify Projects
    agent_id = "asst_tluMzunuZZ21J1R35fFwCvj0"  # ClassifierAgent
    agent_classifier = get_agent_by_id(client, agent_id)

    thread_classifier = client.agents.create_thread()

    message_classifier = client.agents.create_message(
        thread_id=thread_classifier.id,
        role="user",
        content=project,
    )

    run = client.agents.create_and_process_run(thread_id=thread_classifier.id, agent_id=agent_classifier.id)

    messages_classifier = client.agents.list_messages(thread_id=thread_classifier.id)
    projects_classified = extract_responses(messages_classifier)
    print("Classified Projects:", projects_classified)

    # -------------------------------------------------------------------------
    # Phase 2 - Retrieve Project Information
    agent_id = "asst_tkcxfBRgzYP1rhMIHmU64qFH"  # RegulationRetriever
    agent_retriever = get_agent_by_id(client, agent_id)
    thread_retriever = client.agents.create_thread()
    message_retriever = client.agents.create_message(
        thread_id=thread_retriever.id,
        role="user",
        content= f"""
            Projects: {project} 
            
            Classifier Outputs: {projects_classified} 
            Please provide the relevant information for the projects.""",
    )
    run = client.agents.create_and_process_run(thread_id=thread_retriever.id, agent_id=agent_retriever.id)
    messages_retriever = client.agents.list_messages(thread_id=thread_retriever.id)
    project_info = extract_responses(messages_retriever)
    print("\n\n\nProject Information:", project_info)

  

if __name__ == "__main__":
    asyncio.run(main())


    
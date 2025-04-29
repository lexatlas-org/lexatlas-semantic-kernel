import asyncio
import os
from pathlib import Path

from dotenv import load_dotenv
from agent_utils import (
    get_azure_agent_by_name,
    get_root_dir,
    read_all_files_and_join
)
from azure.identity.aio import DefaultAzureCredential
from azure.ai.projects import AIProjectClient

from semantic_kernel.agents import AzureAIAgent, AgentGroupChat
from semantic_kernel.contents import TextContent
from semantic_kernel.contents.chat_message_content import ChatMessageContent
from semantic_kernel.contents.utils.author_role import AuthorRole
from semantic_kernel.agents.strategies import SequentialSelectionStrategy, DefaultTerminationStrategy

# Load environment variables
DIR_ROOT = Path(__file__).parent
load_dotenv(dotenv_path=DIR_ROOT / ".env", override=True)

# Load example project
projects = read_all_files_and_join(get_root_dir() / "dataset/v1/projects")

project = """
    Document ID: doc_001
    Title: New York Renewable Energy Siting Law §94-c
    Summary: Projects building renewable energy facilities over 25 MW must obtain a permit from the Office of Renewable Energy Siting (ORES) before construction begins. Failure to secure approval results in regulatory noncompliance.
"""

async def main():
    # Initialize Azure credential and AI project client
    credential = DefaultAzureCredential()
    project_client = AIProjectClient.from_connection_string(
        conn_str=os.environ.get("AZURE_AI_AGENT_PROJECT_CONNECTION_STRING"),
        credential=credential
    )

    async with credential, AzureAIAgent.create_client(credential=credential) as client:
        # Phase 0 - Setup agents
        print("\n[Setup] Loading agents...")

        agent_classifier = await get_azure_agent_by_name(client, 'ClassifierAgent')
        agent_retriever = await get_azure_agent_by_name(client, 'RegulationRetriever')
        agent_checker = await get_azure_agent_by_name(client, 'ComplianceChecker')
        agent_reporter = await get_azure_agent_by_name(client, 'ReportGenerator')

        agents = [agent_classifier, agent_retriever, agent_checker, agent_reporter]

        # Phase 1 - Create conversation thread and user message
        print("\n[Thread] Creating conversation thread and sending user message...")

        thread = await client.agents.create_thread()
        await client.agents.create_message(
            thread_id=thread.id,
            role="user",
            content=f"""
                    Please complete the following steps:

                    1. Classify the project.
                    2. If the classification result shows "state" as "unsupported", immediately stop further processing and inform the user.
                    3. Retrieve regulatory information.
                    4. Check compliance.
                    5. Generate a final report.

                    Additional Instructions:
                    - If an agent fails or returns no data, attempt one retry. If still unsuccessful, escalate the issue or flag it to the user.
                    - Always ensure complete and consistent data is passed between agents.

                    Project:
                    {project}

            """
        )

        # Phase 2 - Create AgentGroupChat
        print("\n[Chat] Setting up Agent Group Chat...")

        group_chat = AgentGroupChat(
            agents=agents,
            selection_strategy=SequentialSelectionStrategy(initial_agent=agent_classifier),
            termination_strategy=DefaultTerminationStrategy(maximum_iterations=len(agents))
        )

        # Send user message into group chat context
        user_message = ChatMessageContent(
            role=AuthorRole.USER,
            items=[TextContent(text=project)]
        )
        await group_chat.add_chat_message(user_message)

        # Phase 3 - Run the multi-agent conversation
        print("\n[Chat] Running the conversation among agents...\n")

        async for content in group_chat.invoke():
            print(f"# Agent ({content.name or '*'}) says: {content.content}")

if __name__ == "__main__":
    asyncio.run(main())

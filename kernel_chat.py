# group_kernel.py

from pathlib import Path
from dotenv import load_dotenv
from semantic_kernel.agents import AgentGroupChat, AzureAIAgent
from semantic_kernel.agents.strategies import SequentialSelectionStrategy, DefaultTerminationStrategy
from semantic_kernel.contents import ChatHistory

from azure.identity.aio import DefaultAzureCredential

from agent_utils import get_azure_agent_by_name  # <-- your custom function

# Load environment
DIR_ROOT = Path(__file__).parent
load_dotenv(dotenv_path=DIR_ROOT / ".env", override=True)

async def setup_group_chat():
    """Initializes Azure credentials and a multi-agent group chat."""
    credential = DefaultAzureCredential()

    # Create Azure agent client (outside of async context manager)
    client = AzureAIAgent.create_client(credential=credential)

    # Retrieve agents
    agent_classifier = await get_azure_agent_by_name(client, "ClassifierAgent")
    agent_retriever = await get_azure_agent_by_name(client, "RegulationRetriever")
    agent_checker = await get_azure_agent_by_name(client, "ComplianceChecker")
    agent_reporter = await get_azure_agent_by_name(client, "ReportGenerator")

    agents = [agent_classifier, agent_retriever, agent_checker, agent_reporter]

    # Create group chat instance
    group_chat = AgentGroupChat(
        agents=agents,
        selection_strategy=SequentialSelectionStrategy(initial_agent=agent_classifier),
        termination_strategy=DefaultTerminationStrategy(maximum_iterations=len(agents))
    )

    return group_chat, client, credential

def create_chat_history():
    """Creates a new chat history instance."""
    return ChatHistory()

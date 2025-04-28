# main.py
import asyncio
from pathlib import Path
from agent_utils import (
    get_project_client,
    create_agent_and_thread,
    read_file_content,
)

DIR_ROOT = Path(__file__).parent


agents = [
    {'name': 'ClassifierAgent',      'model':'gpt-35-turbo', 'instructions':f"{DIR_ROOT}/prompts/1_ClassifierAgentPrompt.txt"},
    {'name': 'RegulationRetriever',  'model':'gpt-35-turbo', 'instructions':f"{DIR_ROOT}/prompts/2_RegulationRetrieverAgentPrompt.txt"},
    {'name': 'ComplianceChecker',    'model':'gpt-4o-mini', 'instructions':f"{DIR_ROOT}/prompts/3_ComplianceCheckerAgentPrompt.txt"},
    {'name': 'ReportGenerator',      'model':'gpt-4o', 'instructions':f"{DIR_ROOT}/prompts/4_ReportGeneratorAgentPrompt.txt"},
]
# print(agents)


client = get_project_client()
for agent in agents:
    print(f"Creating agent: {agent['name']} with model: {agent['model']}")
    instructions = read_file_content(Path(agent['instructions']))

    agent, thread = await create_agent_and_thread(
        client,
        model_name="gpt-4o-mini",
        agent_name="my-test-agent",
        instructions="You are a very friendly assistant."
    )

    print(f"Agent {agent['name']} created successfully.")
    print(f"Thread {thread['id']} created successfully.")



# main.py
import asyncio
from pathlib import Path
import time
from agent_utils import (
    get_project_client,
    create_agent_and_thread,
    read_file_content,
)

DIR_ROOT = Path(__file__).parent

agents_config = [
    {'name': 'ClassifierAgent',      'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/1_ClassifierAgentPrompt.txt"},
    {'name': 'RegulationRetriever',  'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/2_RegulationRetrieverAgentPrompt.txt"},
    {'name': 'ComplianceChecker',    'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/3_ComplianceCheckerAgentPrompt.txt"},
    {'name': 'ReportGenerator',      'model': 'gpt-4o-mini', 'instructions': DIR_ROOT / "prompts/4_ReportGeneratorAgentPrompt.txt"},
]

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

            print(f"Agent '{agent_info['name']}' created successfully.")
            print(f"Thread ID: {thread.id} created successfully.")
            time.sleep(5)

if __name__ == "__main__":
    asyncio.run(main())

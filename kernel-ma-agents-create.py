# main.py

agents = [
    {'name': 'ClassifierAgent',      'model':'gpt-35-turbo', 'instructions':"You are a classifier agent."},
    {'name': 'RegulationRetriever',  'model':'gpt-35-turbo', 'instructions':"You are a classifier agent."},
    {'name': 'ComplianceChecker',    'model':'gpt-4o-mini', 'instructions':"You are a classifier agent."},
    {'name': 'ReportGenerator',      'model':'gpt-4o', 'instructions':"You are a classifier agent."},
]
# print(agents)

for agent in agents:
    print(f"Creating agent: {agent['name']} with model: {agent['model']}")
    # Here you would typically call a function to create the agent using the specified model and instructions
    # For example:
    # create_agent(agent['name'], agent['model'], agent['instructions'])

# import asyncio
# from agent_utils import (
#     get_project_client,
#     create_agent_and_thread,
# )

# async def main():
#     client = get_project_client()

#     with client:
#         agent, thread = await create_agent_and_thread(
#             client,
#             model_name="gpt-4o-mini",
#             agent_name="my-test-agent",
#             instructions="You are a very friendly assistant."
#         )

#         # query = "Create a bar chart for: Apples=50, Bananas=80, Cherries=40"
#         # messages = await run_query(client, agent, thread, query)
        
#         # display_responses(messages)
#         # handle_images(client, messages)
#         # handle_files(client, messages)

#         # Optional: Delete the agent when done
#         # await client.agents.delete_agent(agent.id)

# if __name__ == "__main__":
#     asyncio.run(main())

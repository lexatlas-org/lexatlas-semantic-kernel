# main.py

import asyncio
from agent_utils import (
    get_project_client,
    create_agent_and_thread,
    run_query,
    display_responses,
    handle_images,
    handle_files,
)

async def main():
    client = get_project_client()

    with client:
        agent, thread = await create_agent_and_thread(
            client,
            model_name="gpt-4o-mini",
            agent_name="my-test-agent",
            instructions="You are a very friendly assistant."
        )

        # query = "Create a bar chart for: Apples=50, Bananas=80, Cherries=40"
        # messages = await run_query(client, agent, thread, query)
        
        # display_responses(messages)
        # handle_images(client, messages)
        # handle_files(client, messages)

        # Optional: Delete the agent when done
        # await client.agents.delete_agent(agent.id)

if __name__ == "__main__":
    asyncio.run(main())

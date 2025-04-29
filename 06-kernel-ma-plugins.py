import asyncio
import os
import requests
from typing import Annotated
from dotenv import load_dotenv

from semantic_kernel.agents import ChatCompletionAgent, ChatHistoryAgentThread
from semantic_kernel.connectors.ai.open_ai import OpenAIChatCompletion
from semantic_kernel.functions import kernel_function
from openai import AsyncOpenAI

# Load environment variables
load_dotenv()
SERPAPI_SEARCH_API_KEY = os.environ.get("SERPAPI_SEARCH_API_KEY")
SERPAPI_SEARCH_ENDPOINT = "https://serpapi.com/search"

# Define the Compliance Plugin
class CompliancePlugin:
    """Plugin to retrieve legal and regulatory compliance data using SerpApi Google Search"""

    @kernel_function(description="Check legal or regulatory compliance based on a project description.")
    def check_compliance(self, query: Annotated[str, "User's project description or legal query"]) -> Annotated[str, "Returns search-based legal insights or regulatory information"]:
        params = {
            "engine": "google",
            "q": query,
            "hl": "en",
            "gl": "us",
            "api_key": SERPAPI_SEARCH_API_KEY
        }

        response = requests.get(SERPAPI_SEARCH_ENDPOINT, params=params)
        if response.status_code == 200:
            results = response.json().get("organic_results", [])
            formatted = "\n".join(
                f"- {r.get('title')}: {r.get('link')}" for r in results[:5]
            )
            return formatted if formatted else "No relevant results found."
        else:
            return f"Error: HTTP {response.status_code}"

# Setup OpenAI client
client = AsyncOpenAI(
    api_key=os.environ.get("GITHUB_TOKEN"), 
    base_url="https://models.inference.ai.azure.com/",
)

# Define the AI completion service
chat_completion_service = OpenAIChatCompletion(
    ai_model_id="gpt-4o-mini",
    async_client=client,
)

# Create the Agent using the CompliancePlugin
agent = ChatCompletionAgent(
    service=chat_completion_service,
    plugins=[CompliancePlugin()],
    name="LexAgent",
    instructions="You are a helpful legal AI agent that uses web data to check for compliance and regulations based on user-submitted projects.",
)

# Main async function to run the agent
async def main():
    thread: ChatHistoryAgentThread | None = None

    user_inputs = [
        "We want to open a waste processing facility in Texas. What environmental regulations might apply?"
    ]

    for user_input in user_inputs:
        print(f"# User: {user_input}\n")
        first_chunk = True
        async for response in agent.invoke_stream(messages=user_input, thread=thread):
            if first_chunk:
                print(f"# {response.name}: ", end="", flush=True)
                first_chunk = False
            print(f"{response}", end="", flush=True)
            thread = response.thread
        print()

    await thread.delete() if thread else None

if __name__ == "__main__":
    asyncio.run(main())
# import os
# import asyncio
# from pathlib import Path

# import chainlit as cl
# from dotenv import load_dotenv
# import json

# from typing import Optional

# from semantic_kernel.agents import AgentGroupChat, AzureAIAgent
# from semantic_kernel.agents.strategies import SequentialSelectionStrategy, DefaultTerminationStrategy
# from semantic_kernel.contents import TextContent
# from semantic_kernel.contents.chat_message_content import ChatMessageContent
# from semantic_kernel.contents.utils.author_role import AuthorRole

# from azure.ai.projects import AIProjectClient
# from azure.identity.aio import DefaultAzureCredential

# from agent_utils import get_azure_agent_by_name  # <-- your custom function

# # Load environment variables
# DIR_ROOT = Path(__file__).parent
# load_dotenv(dotenv_path=DIR_ROOT / ".env", override=True)


# @cl.on_chat_start
# async def on_chat_start():
#     # Initialize Azure credentials
#     credential = DefaultAzureCredential()
#     cl.user_session.set("azure_credential", credential)

#     # Create persistent Azure Agent client (do not use async with)
#     client = AzureAIAgent.create_client(credential=credential)
#     cl.user_session.set("azure_agent_client", client)

#     # Load Azure agents
#     agent_classifier = await get_azure_agent_by_name(client, "ClassifierAgent")
#     agent_retriever = await get_azure_agent_by_name(client, "RegulationRetriever")
#     agent_checker = await get_azure_agent_by_name(client, "ComplianceChecker")
#     agent_reporter = await get_azure_agent_by_name(client, "ReportGenerator")

#     agents = [agent_classifier, agent_retriever, agent_checker, agent_reporter]

#     # Create multi-agent group chat
#     group_chat = AgentGroupChat(
#         agents=agents,
#         selection_strategy=SequentialSelectionStrategy(initial_agent=agent_classifier),
#         termination_strategy=DefaultTerminationStrategy(maximum_iterations=len(agents))
#     )

#     # Store in session
#     cl.user_session.set("group_chat", group_chat)
#     cl.user_session.set("chat_history", [])

#     # Inform user
#     await cl.Message(content=" Agent group initialized. Please start sending your project description.").send()


# @cl.on_message
# async def on_message(message: cl.Message):
#     group_chat = cl.user_session.get("group_chat")  # type: Optional[AgentGroupChat]

#     if group_chat is None:
#         await cl.Message(content=" Error: Agent group is not initialized. Please restart the chat.").send()
#         return

#     # Add user message
#     user_message = ChatMessageContent(
#         role=AuthorRole.USER,
#         items=[TextContent(text=message.content)]
#     )
#     await group_chat.add_chat_message(user_message)

#     chainlit_message = cl.Message(content="")

#     async for content in group_chat.invoke():
#         agent_name = content.name or "Agent"
#         raw = content.content or ""
#         formatted_output = ""

#         try:
#             # --- ClassifierAgent: Markdown table ---
#             if agent_name == "ClassifierAgent" and "| Document ID" in raw:
#                 formatted_output = f"###  Project Classification\n\n{raw}"

#             # --- RegulationRetriever: Markdown regulation table with optional note ---
#             elif agent_name == "RegulationRetriever" and "| Title" in raw:
#                 formatted_output = f"###  Relevant Regulations\n\n{raw}"

#             elif agent_name == "ComplianceChecker":
#                 if "**Compliance Status:** No issues detected" in raw:
#                     formatted_output = f"### Compliance Check\n\n{raw}"
#                 elif "| Risk or Issue" in raw:
#                     formatted_output = f"###  Compliance Issues\n\n{raw}"
#                 else:
#                     formatted_output = f"###  Compliance Output\n\n{raw}"

#             # --- ReportGenerator: Final legal report ---
#             elif agent_name == "ReportGenerator" and "# Final Legal Advisory Report" in raw:
#                 formatted_output = raw  # already complete Markdown

#             # --- Fallback for unknown agent outputs ---
#             else:
#                 formatted_output = f"###  {agent_name}\n\n{raw}"

#         except Exception as e:
#             formatted_output = f"###  {agent_name} Output Error\n\n Could not format output.\n\n**Error:** {str(e)}\n\n**Raw Output:**\n```\n{raw}\n```"

#         await chainlit_message.stream_token(f"\n\n{formatted_output}")

#     await chainlit_message.send()



# @cl.on_chat_end
# async def on_chat_end():
#     # Clean up resources at end of chat
#     client = cl.user_session.get("azure_agent_client")
#     credential = cl.user_session.get("azure_credential")

#     if client:
#         await client.close()

#     if credential:
#         await credential.close()

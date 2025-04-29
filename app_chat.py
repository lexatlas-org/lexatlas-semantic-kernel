# app_group_chat.py (with resume support)

import chainlit as cl
from semantic_kernel.contents import TextContent
from semantic_kernel.contents.chat_message_content import ChatMessageContent
from semantic_kernel.contents.utils.author_role import AuthorRole

from kernel_chat import setup_group_chat  # reused kernel setup
from chainlit.types import ThreadDict
from typing import Optional


USER_DATABASE = {
    "admin": {"password": "admin", "role": "admin", "email": "admin@example.com"},
    "john": {"password": "johnpass", "role": "user", "email": "john@example.com"},
}

@cl.password_auth_callback
def auth_callback(username: str, password: str) -> Optional[cl.User]:
    user_info = USER_DATABASE.get(username)
    if user_info and user_info["password"] == password:
        return cl.User(
            identifier=username,
            metadata={
                "role": user_info["role"],
                "email": user_info["email"],
                "provider": "credentials"
            }
        )
    return None     
    
@cl.on_chat_start
async def on_chat_start():
    group_chat, client, credential = await setup_group_chat()

    cl.user_session.set("group_chat", group_chat)
    cl.user_session.set("azure_agent_client", client)
    cl.user_session.set("azure_credential", credential)
    cl.user_session.set("chat_history", [])

    await cl.Message(content=" Agent group initialized. Please start sending your project description.").send()


@cl.on_chat_resume
async def on_chat_resume(thread: ThreadDict):
    group_chat, client, credential = await setup_group_chat()

    cl.user_session.set("group_chat", group_chat)
    cl.user_session.set("azure_agent_client", client)
    cl.user_session.set("azure_credential", credential)

    # Rebuild chat history
    for step in thread["steps"]:
        if step["type"] == "user_message":
            user_msg = ChatMessageContent(
                role=AuthorRole.USER,
                items=[TextContent(text=step["output"])]
            )
            await group_chat.add_chat_message(user_msg)
        elif step["type"] == "assistant_message":
            assistant_msg = ChatMessageContent(
                role=AuthorRole.ASSISTANT,
                items=[TextContent(text=step["output"])]
            )
            await group_chat.add_chat_message(assistant_msg)

    cl.user_session.set("chat_history", thread["steps"])


@cl.on_message
async def on_message(message: cl.Message):
    group_chat = cl.user_session.get("group_chat")

    if group_chat is None:
        await cl.Message(content=" Error: Agent group is not initialized. Please restart the chat.").send()
        return

    user_message = ChatMessageContent(
        role=AuthorRole.USER,
        items=[TextContent(text=message.content)]
    )
    await group_chat.add_chat_message(user_message)

    chainlit_message = cl.Message(content="")

    async for content in group_chat.invoke():
        agent_name = content.name or "Agent"
        raw = content.content or ""
        formatted_output = f"---\n### {agent_name}\n\n{raw}"

        await chainlit_message.stream_token(f"\n\n{formatted_output}")

    await chainlit_message.send()


@cl.on_chat_end
async def on_chat_end():
    client = cl.user_session.get("azure_agent_client")
    credential = cl.user_session.get("azure_credential")

    if client:
        await client.close()
    if credential:
        await credential.close()

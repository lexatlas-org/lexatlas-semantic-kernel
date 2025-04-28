# app.py
from pathlib import Path
import chainlit as cl
from dotenv import load_dotenv
from kernel import setup_kernel, create_chat_history, request_settings
from semantic_kernel.connectors.ai.open_ai import OpenAIChatCompletion
from semantic_kernel.contents import ChatHistory
import semantic_kernel as sk
from typing import Optional
from chainlit.types import ThreadDict


# Environment setup
DIR_ROOT = Path(__file__).parent
load_dotenv(dotenv_path=f"{DIR_ROOT}/.env")

@cl.password_auth_callback
def auth_callback(username: str, password: str) -> Optional[cl.User]:
    """Basic username and password authentication."""
    if (username, password) == ("admin", "admin"):
        return cl.User(
            identifier="admin",
            metadata={"role": "admin", "provider": "credentials"}
        )
    else:
        return None

@cl.on_chat_resume
async def on_chat_resume(thread: ThreadDict):
    kernel, ai_service = setup_kernel()
    cl.user_session.set("kernel", kernel)
    cl.user_session.set("ai_service", ai_service)
    chat_history = create_chat_history()
    for step in thread["steps"]:
        if step["type"] == "user_message":
            chat_history.add_user_message(step["output"])
        elif step["type"] == "assistant_message":
            chat_history.add_assistant_message(step["output"])
    cl.user_session.set("chat_history", chat_history)


@cl.on_chat_start
async def on_chat_start():
    kernel, ai_service = setup_kernel()

    # Attach Chainlit's filter (optional if needed)
    sk_filter = cl.SemanticKernelFilter(kernel=kernel)

    # Save objects into the Chainlit user session
    cl.user_session.set("kernel", kernel)
    cl.user_session.set("ai_service", ai_service)
    cl.user_session.set("chat_history", create_chat_history())

@cl.on_message
async def on_message(message: cl.Message):
    kernel = cl.user_session.get("kernel")  # type: sk.Kernel
    ai_service = cl.user_session.get("ai_service")  # type: OpenAIChatCompletion
    chat_history = cl.user_session.get("chat_history")  # type: ChatHistory

    # Add user's message to chat history
    chat_history.add_user_message(message.content)

    # Create a Chainlit message for streaming the response
    answer = cl.Message(content="")

    async for msg in ai_service.get_streaming_chat_message_content(
        chat_history=chat_history,
        user_input=message.content,
        settings=request_settings,
        kernel=kernel,
    ):
        if msg.content:
            await answer.stream_token(msg.content)

    # Save assistant's full message
    chat_history.add_assistant_message(answer.content)

    # Send final answer
    await answer.send()

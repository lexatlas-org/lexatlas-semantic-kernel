# kernel.py
from pathlib import Path
import semantic_kernel as sk
from semantic_kernel.connectors.ai import FunctionChoiceBehavior
from semantic_kernel.connectors.ai.open_ai import (
    OpenAIChatCompletion,
    OpenAIChatPromptExecutionSettings,
)
from semantic_kernel.contents import ChatHistory

DIR_ROOT = Path(__file__).parent.parent.parent

# Create request settings once
request_settings = OpenAIChatPromptExecutionSettings(
    function_choice_behavior=FunctionChoiceBehavior.Auto(filters={"excluded_plugins": ["ChatBot"]})
)

def setup_kernel():
    """Initializes the Semantic Kernel and AI service."""
    kernel = sk.Kernel()

    ai_service = OpenAIChatCompletion(
        service_id="default",
        ai_model_id="gpt-4o",
        env_file_path=f'{DIR_ROOT}/.env'
    )

    kernel.add_service(ai_service)

    return kernel, ai_service

def create_chat_history():
    """Creates a new chat history instance."""
    return ChatHistory()

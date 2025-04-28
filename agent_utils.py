# agent_utils.py

import os
from pathlib import Path
from dotenv import load_dotenv
from azure.ai.projects import AIProjectClient
from azure.identity import DefaultAzureCredential
from IPython.display import display, Image

# ========== Load Environment ==========
DIR_ROOT = Path(__file__).parent
load_dotenv(dotenv_path=DIR_ROOT / ".env", override=True)

# ========== Client Setup ==========
def get_project_client(connection_string: str = None) -> AIProjectClient:
    credential = DefaultAzureCredential()
    conn_str = connection_string or os.getenv("PROJECT_CONNECTION_STRING", "")
    return AIProjectClient.from_connection_string(credential=credential, conn_str=conn_str)

# ========== Agent Management ==========
async def create_agent_and_thread(
    client: AIProjectClient,
    model_name: str = "gpt-4o-mini",
    agent_name: str = "default-agent",
    instructions: str = "You are a helpful assistant."
):
    agent = client.agents.create_agent(
        model=model_name,
        name=agent_name,
        instructions=instructions,
    )
    thread = client.agents.create_thread()
    return agent, thread

# ========== Agent Execution ==========
async def run_query(
    client: AIProjectClient,
    agent,
    thread,
    query: str
):
    client.agents.create_message(thread.id, "user", query)
    client.agents.create_and_process_run(thread.id, agent.id)
    return client.agents.list_messages(thread.id)

# ========== Display Responses ==========
def display_responses(messages):
    print("Assistant Response:")
    for msg in messages:
        if getattr(msg, 'role', '') == "assistant":
            content = getattr(msg, 'content', '')
            if isinstance(content, list):
                for part in content:
                    if getattr(part, 'type', '') == "text":
                        print(part.text.value)
            elif isinstance(content, str):
                print(content)

# ========== Handle Images ==========
def handle_images(client: AIProjectClient, messages, save_dir: Path = Path("./images")):
    save_dir.mkdir(parents=True, exist_ok=True)
    for msg in messages:
        if hasattr(msg, 'image_contents'):
            for img in msg.image_contents:
                file_id = img.image_file.file_id
                file_name = save_dir / f"{file_id}_image.png"
                client.agents.save_file(file_id, str(file_name))
                print(f"Image saved: {file_name}")
                display(Image(str(file_name)))

# ========== Handle Files ==========
def handle_files(client: AIProjectClient, messages, save_dir: Path = Path("./files")):
    save_dir.mkdir(parents=True, exist_ok=True)
    for msg in messages:
        if hasattr(msg, 'file_path_annotations'):
            for item in msg.file_path_annotations:
                file_name = save_dir / Path(item.text).name
                file_id = item.file_path.file_id
                client.agents.save_file(file_id, str(file_name))
                print(f"File saved: {file_name} (Type: {item.type})")

# agent_utils.py

import json
import os
from pathlib import Path
from dotenv import load_dotenv
from azure.ai.projects import AIProjectClient
from azure.identity import DefaultAzureCredential
from IPython.display import display, Image
from azure.ai.projects.models import FileSearchTool, OpenAIFile, VectorStore

from config import agents_config  

# ========== Load Environment ==========
DIR_ROOT = Path(__file__).parent
load_dotenv(dotenv_path=DIR_ROOT / ".env", override=True)

def get_root_dir() -> Path:
    return DIR_ROOT

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
# def display_responses(messages):
#     print("Assistant Response:")
#     for msg in messages:
#         if getattr(msg, 'role', '') == "assistant":
#             content = getattr(msg, 'content', '')
#             if isinstance(content, list):
#                 for part in content:
#                     if getattr(part, 'type', '') == "text":
#                         print(part.text.value)
#             elif isinstance(content, str):
#                 print(content)


def extract_responses(messages: dict):
    extracted_responses = []

    if not messages or 'data' not in messages:
        return extracted_responses

    for msg in messages['data']:
        if msg.get('role') == "assistant":
            content = msg.get('content', [])
            if isinstance(content, list):
                for part in content:
                    if part.get('type') == "text":
                        text_value = part.get('text', {}).get('value', '')
                        try:
                            parsed = json.loads(text_value)
                            pretty_text = json.dumps(parsed, indent=4)
                            extracted_responses.append(pretty_text)
                        except json.JSONDecodeError:
                            extracted_responses.append(text_value)
            elif isinstance(content, str):
                extracted_responses.append(content)

    return extracted_responses


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


# ========== Read and Return File Content ==========
def read_file_content(file_path: Path) -> str:
    if not file_path.exists():
        raise FileNotFoundError(f"The file {file_path} does not exist.")
    with file_path.open("r", encoding="utf-8") as file:
        return file.read()
    
# ========== Get Agent by ID ==========
def get_agent_by_id(client: AIProjectClient, agent_id: str):
    try:
        agent = client.agents.get_agent(agent_id)
        return agent
    except Exception as e:
        print(f"Error retrieving agent with ID {agent_id}: {e}")
        return None
    
# ========== Read All Files and Join Content ==========
def read_all_files_and_join(directory: Path) -> str:
    if not directory.is_dir():
        raise NotADirectoryError(f"{directory} is not a valid directory.")
    
    content = []
    for file_path in directory.glob("**/*"):
        if file_path.is_file():
            try:
                with file_path.open("r", encoding="utf-8") as file:
                    content.append(file.read())
            except Exception as e:
                print(f"Error reading file {file_path}: {e}")
    
    return "\n".join(content)


# ========== Upload Files and Create FileSearchTool ==========
def upload_files_create_vector_store_return_tool(client, file_paths: list[str], vector_store_name: str):
    if not file_paths:
        raise ValueError("file_paths list is empty!")

    file_ids = []

    for path in file_paths:
        print(f"Uploading file: {path}...")
        file = client.agents.upload_file_and_poll(file_path=path, purpose="assistants")
        file_ids.append(file.id)
        print(f"Uploaded: {file.id}")

    print("\nCreating empty vector store...")
    vector_store = client.agents.create_vector_store_and_poll(
        data_sources=[],  # Important: Create empty first
        name=vector_store_name
    )
    print(f"Created vector store: {vector_store.name} (ID: {vector_store.id})")

    print("\nAdding files to vector store...")
    vector_store_file_batch = client.agents.create_vector_store_file_batch_and_poll(
        vector_store_id=vector_store.id,
        file_ids=file_ids
    )
    print(f"Created file batch: {vector_store_file_batch.id}")

    print("\nSetting up FileSearchTool...")
    file_search_tool = FileSearchTool(vector_store_ids=[vector_store.id])

    return file_search_tool

# ========== List All Files in Folder ==========
def list_all_files_in_folder(folder_path: Path) -> list[str]:
    if not folder_path.is_dir():
        raise NotADirectoryError(f"{folder_path} is not a valid directory.")
    
    return [str(file.resolve()) for file in folder_path.glob("**/*") if file.is_file()]


# ========== Get Agent by Name ==========
def get_agent_by_name(client: AIProjectClient, agent_name: str):
    try:
        for agent in agents_config:
            if agent['name'] == agent_name:
                return get_agent_by_id(client, agent['id'])
        print(f"No agent found with the name {agent_name}.")
        return None
    except Exception as e:
        print(f"Error retrieving agent with name {agent_name}: {e}")
        return None
import os
import time
from azure.ai.projects import AIProjectClient
from azure.identity import DefaultAzureCredential
from azure.ai.projects.models import FunctionTool, RequiredFunctionToolCall, SubmitToolOutputsAction, ToolOutput
from plugins.user_functions import user_functions


def get_project_client() -> AIProjectClient:
    """Initialize the AIProjectClient with Azure credentials."""
    return AIProjectClient.from_connection_string(
        credential=DefaultAzureCredential(),
        conn_str=os.environ["PROJECT_CONNECTION_STRING"]
    )


def create_agent(client: AIProjectClient, functions: FunctionTool):
    """Create an agent with defined tools."""
    agent = client.agents.create_agent(
        model="gpt-4o-mini",
        name="my-assistant",
        instructions="You are a helpful assistant",
        tools=functions.definitions,
    )
    print(f"Created agent, ID: {agent.id}")
    return agent


def create_thread_and_message(client: AIProjectClient, thread_content: str):
    """Create a thread and post an initial message."""
    thread = client.agents.create_thread()
    print(f"Created thread, ID: {thread.id}")

    message = client.agents.create_message(
        thread_id=thread.id,
        role="user",
        content=thread_content,
    )
    print(f"Created message, ID: {message.id}")
    return thread, message


def handle_tool_calls(client, thread_id, run, functions):
    """Process and execute required tool calls."""
    tool_calls = run.required_action.submit_tool_outputs.tool_calls
    tool_outputs = []

    if not tool_calls:
        print("No tool calls provided - cancelling run")
        client.agents.cancel_run(thread_id=thread_id, run_id=run.id)
        return []

    for tool_call in tool_calls:
        if isinstance(tool_call, RequiredFunctionToolCall):
            try:
                print(f"Executing tool call: {tool_call}")
                output = functions.execute(tool_call)
                tool_outputs.append(
                    ToolOutput(
                        tool_call_id=tool_call.id,
                        output=output,
                    )
                )
            except Exception as e:
                print(f"Error executing tool_call {tool_call.id}: {e}")
    return tool_outputs


def wait_for_run_completion(client, thread_id, agent_id, run, functions):
    """Poll the run until completion and handle tool interactions."""
    while run.status in ["queued", "in_progress", "requires_action"]:
        time.sleep(1)
        run = client.agents.get_run(thread_id=thread_id, run_id=run.id)

        if run.status == "requires_action" and isinstance(run.required_action, SubmitToolOutputsAction):
            tool_outputs = handle_tool_calls(client, thread_id, run, functions)
            if tool_outputs:
                client.agents.submit_tool_outputs_to_run(
                    thread_id=thread_id,
                    run_id=run.id,
                    tool_outputs=tool_outputs
                )

        print(f"Current run status: {run.status}")

    return run


def main():
    project_client = get_project_client()
    functions = FunctionTool(functions=user_functions)

    with project_client:
        agent = create_agent(project_client, functions)
        thread, _ = create_thread_and_message(project_client, "Buscar informacion sobre Law §94-c")

        run = project_client.agents.create_run(thread_id=thread.id, agent_id=agent.id)
        print(f"Created run, ID: {run.id}")

        run = wait_for_run_completion(project_client, thread.id, agent.id, run, functions)
        print(f"Run completed with status: {run.status}")

        project_client.agents.delete_agent(agent.id)
        print("Deleted agent")

        messages = project_client.agents.list_messages(thread_id=thread.id)
        print(f"Messages: {messages}")


if __name__ == "__main__":
    main()

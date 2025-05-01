# 03 - Agent Setup and Automation Tutorial

This tutorial describes how to automatically create and configure multiple AI agents using predefined prompt instructions and model settings. These agents are used to evaluate legal and regulatory scenarios using various GPT models in a structured, testable workflow. It also includes how to **ground agents with documents** using vector stores.

---

## Purpose

This setup enables:

- Automated creation and registration of AI agents  
- Assignment of model + prompt configuration per agent (e.g., GPT-4o, GPT-4o-mini)  
- Evaluation of how different models perform on classification, retrieval, compliance, and reporting tasks  
- File-grounded reasoning via vector stores and document search tools  

---

## 1. Agent Configuration

Agents are defined in `config.py` using the following structure:

```python
agents_config = [
    {'name': 'ClassifierAgent',      'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/v2/1_ClassifierAgentPrompt.md"},
    {'name': 'RegulationRetriever',  'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/v2/2_RegulationRetrieverAgentPrompt.md"},
    {'name': 'ComplianceChecker',    'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/v2/3_ComplianceCheckerAgentPrompt.md"},
    {'name': 'ReportGenerator',      'model': 'gpt-4o',       'instructions': DIR_ROOT / "prompts/v2/4_ReportGeneratorAgentPrompt.md"},
]
```

Each includes:

- `name`: agent name  
- `model`: deployed OpenAI model  
- `instructions`: system prompt  

---

## 2. Create All Agents

Run the script below to register your agents:

```bash
python 01-kernel-ma-agents-create.py
```

This will:

- Load `agents_config`  
- Read prompt files  
- Deploy each agent to your Azure AI Project  

---

## 3. Grounding Agents with File Search (Vector Store)

To enable document-grounded retrieval for agents like `RegulationRetriever`:

### a. Add your files

Place `.pdf`, `.md`, or `.txt` files under:

```
dataset/v2/regulations/
```

### b. Run the file-grounding script

```bash
python 03-kernel-ma-agents-file-grounding.py
```

This will:

- Upload documents to Azure  
- Create a **vector store**  
- Attach a **file search tool** to the `RegulationRetriever` agent  

This allows the agent to retrieve answers from your actual legal content instead of relying only on general LLM knowledge.

---

## 4. List Existing Agents

To confirm successful creation:

```bash
python 02-kernel-ma-agents-list.py
```

This will list all agents currently registered in your Azure AI Project.

---

## 5. Run a Full Evaluation Pipeline

To test how the agents work in sequence:

```bash
python 04-kernel-ma-agents-test.py
```

This script runs a linear evaluation pipeline:

1. `ClassifierAgent` – Identifies the type of project  
2. `RegulationRetriever` – Retrieves applicable laws and regulations  
3. `ComplianceChecker` – Evaluates legal compliance  
4. `ReportGenerator` – Summarizes the result in a legal-technical report  

> **Note:**  
> This script turned out to be a very effective strategy for **focusing development efforts on each agent’s functionality in isolation**.  
> It allows for a complete evaluation loop **without adding the complexity of a full orchestration layer** like AgentGroupChat or custom planners. This simplifies debugging and makes it easier to iterate and improve agent behavior independently.

---

## 6. Optional: Group Chat Mode

To simulate multi-agent collaboration in a single thread:

```bash
python 05-kernel-ma-group-chat.py
```

This uses `AgentGroupChat` from Semantic Kernel along with `SequentialSelectionStrategy` and `DefaultTerminationStrategy` to coordinate agent execution in a conversational loop.

> **Note:**  
> This script has been especially useful for **exploring advanced functionalities** such as **plugin integration**, **tool invocation**, and **function calling** between agents — all without requiring a frontend.  
> It allowed us to **test and validate orchestration strategies and multi-agent behavior** in a pure backend setup, before introducing UI components like **Chainlit**.

---

## Benefits of This Architecture

- **Repeatable Testing** – Run identical workflows across models or datasets  
- **Grounded Knowledge** – Agents use regulatory files via vector search  
- **Flexible Configuration** – Easily swap prompts, models, or add tools  
- **Simplified Evaluation** – Focus on agent behavior before orchestration  
- **Rich Integration** – Supports plugins, web access, file tools, and more  

# 03 - Agent Setup and Automation Tutorial

This tutorial describes how to automatically create and configure multiple AI agents using predefined prompt instructions and model settings. These agents are then used to evaluate legal and regulatory scenarios using various GPT models in a structured, testable workflow.

---

## Purpose

The goal of this setup is to:

- Automate the creation of AI agents.
- Assign custom prompt instructions and models (e.g., GPT-4o, GPT-4o-mini) to each agent.
- Enable systematic testing of how different models perform across legal classification, regulation retrieval, compliance analysis, and reporting tasks.
- Support grid-based evaluation of agent responses under consistent conditions.

---

## Agent Configuration

Agents are configured in `config.py` using the following structure:

```python
agents_config = [
    {'name': 'ClassifierAgent',      'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/v2/1_ClassifierAgentPrompt.md"},
    {'name': 'RegulationRetriever',  'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/v2/2_RegulationRetrieverAgentPrompt.md"},
    {'name': 'ComplianceChecker',    'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/v2/3_ComplianceCheckerAgentPrompt.md"},
    {'name': 'ReportGenerator',      'model': 'gpt-4o',       'instructions': DIR_ROOT / "prompts/v2/4_ReportGeneratorAgentPrompt.md"},
]
```

Each agent is defined by:

- A unique **name**.
- The **model** used for inference.
- A path to the **instruction file** that defines its behavior and role.

---

## Step-by-Step Instructions

### 1. Create All Agents

Run the following script to create agents in Azure AI Studio:

```bash
python 01-kernel-ma-agents-create.py
```

This will:

- Read `agents_config`
- Load prompt instructions from disk
- Deploy agents using `AIProjectClient`

Agents are created only once unless deleted manually.

---

### 2. List Existing Agents

To confirm which agents exist:

```bash
python 02-kernel-ma-agents-list.py
```

This script prints all registered agent names and IDs.

---

### 3. Run a Complete Evaluation Workflow

To test the agents sequentially:

```bash
python 04-kernel-ma-agents-test.py
```

This runs a pipeline:

1. **ClassifierAgent** – Classifies the type of project.
2. **RegulationRetriever** – Retrieves relevant legal or regulatory info.
3. **ComplianceChecker** – Assesses compliance risks.
4. **ReportGenerator** – Creates a final legal-technical report.

Each agent operates on the outputs of the previous one.

---

### 4. Optional: Run All Agents in Group Chat

To simulate a multi-agent collaborative workflow:

```bash
python 05-kernel-ma-group-chat.py
```

This uses `AgentGroupChat` from Semantic Kernel to chain agents together automatically with retry and termination strategies.

---

## Advantages of This Architecture

- **Reproducible testing**: Swap models, prompts, or agents easily to evaluate performance.
- **Comparative grid evaluation**: Analyze how different models behave with identical instructions and data.
- **Separation of concerns**: Each agent has a single responsibility and can be independently maintained.
- **Interoperability**: Supports integration with OpenAI, Azure OpenAI, plugins, and file tools.

 
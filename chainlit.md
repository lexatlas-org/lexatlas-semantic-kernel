## LexAtlas: AI-Powered Legal Assistant for U.S. Regulations

**LexAtlas** is an intelligent, multi-agent legal assistant designed to help users understand which U.S. state-level laws and regulations apply to their projects. It identifies legal risks, recommends next steps, and generates clear legal-technical summaries based on natural language input.

LexAtlas is a submission for the [Microsoft AI Agents Hackathon](https://microsoft.github.io/AI_Agents_Hackathon/), showcasing how multi-agent AI systems can simplify legal compliance in complex, regulated environments.

---

### What LexAtlas Does

Users can describe their project—such as an energy deployment, infrastructure plan, or environmental initiative—in natural language. LexAtlas will:

- Identify the project type and its U.S. jurisdiction.
- Retrieve relevant laws and regulations.
- Assess legal or compliance risks.
- Generate a human-readable legal summary.

The system is especially suited for early-stage planning when legal clarity is needed before contacting regulators or legal counsel.

---

### Example

**User Input:**

> We're planning a carbon capture project in Wyoming using DAC technology.

**LexAtlas Output:**

> Based on the input, this is a Wyoming-based industrial emissions project involving Direct Air Capture.  
> Under the Wyoming Environmental Quality Act, carbon capture requires authorization from the Department of Environmental Quality (DEQ), Section 35-11.  
> This project may qualify for incentives under the Wyoming Carbon Capture Program if geologic storage conditions are met.  
> We recommend contacting the DEQ’s Division of Air Quality for pre-permitting consultation.

---

### System Architecture Overview

LexAtlas is built using a modular, multi-agent AI architecture orchestrated by **Azure AI Agent SDK** and **Semantic Kernel**, deployed with **Chainlit** as a front-end interface.

#### Key Components

| Layer                     | Technology                                      | Purpose                                                             |
|---------------------------|--------------------------------------------------|---------------------------------------------------------------------|
| Frontend UI               | Chainlit                                         | Chat interface for users to interact with the AI assistant          |
| Language Model            | Azure OpenAI (GPT-4o)                            | Natural language understanding, classification, summarization       |
| Multi-Agent System        | Azure AI Agent SDK + Semantic Kernel            | Manages task delegation between specialized agents                  |
| Agent Roles               | Classifier, Retriever, Compliance Checker, Reporter | Each agent has a distinct role in processing legal queries         |
| Regulation Retrieval      | Azure AI Search + Azure SQL (or mock DB)        | Finds relevant state-level laws and structured legal data           |
| Memory Context            | Azure Agent Thread Storage (mocked for now)     | Retains prior interactions for continuity and follow-up             |
| Backend Integration       | Python + asyncio + Chainlit                     | Orchestrates user input, agent execution, and streaming responses   |
| Authentication            | Chainlit password-based login                   | Protects access for demo purposes                                   |

---

### Agent Flow

1. **Classifier Agent**  
   Determines the project type and jurisdiction based on user input.

2. **Regulation Retriever Agent**  
   Queries a semantic search index and structured database to find relevant legal texts.

3. **Compliance Checker Agent**  
   Analyzes retrieved content and checks for likely legal risks or non-compliance issues.

4. **Report Generator Agent**  
   Summarizes all findings into a clear, user-friendly report suitable for sharing or review.

All agents are orchestrated sequentially using Semantic Kernel's `AgentGroupChat` and strategy interfaces, with support for parallelism and iteration if expanded.

---

### Hackathon Development Strategy

The system was developed using a staged approach:

- **Phase 1:** Proof of concept with basic GPT-4o integration and roundtrip message flow.
- **Phase 2:** Core agent logic with project classification and legal retrieval using mock data.
- **Phase 3:** Memory integration, multi-turn follow-up, and UI polish via Chainlit.

This allowed for progressive testing and validation across each layer of functionality.

---

### How to Use

1. Launch the Chainlit web app.
2. Log in with demo credentials if required.
3. Describe your project in plain language (e.g., location, technology, purpose).
4. Receive a legal summary, list of relevant laws, and risk assessment instantly.

No legal or technical expertise is needed to use LexAtlas. The system is designed to be accessible and actionable for both technical and non-technical users.

---

### Disclaimer

LexAtlas is an experimental legal assistant and does not provide certified legal advice. It is intended as a decision support tool. For critical legal decisions, consult a licensed attorney.
 
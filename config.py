from pathlib import Path

DIR_ROOT = Path(__file__).parent

# agents_config = [
#     {'name': 'ClassifierAgent',      'model': 'gpt-35-turbo-16k',  'instructions': DIR_ROOT / "prompts/v1/1_ClassifierAgentPrompt.txt"},
#     {'name': 'RegulationRetriever',  'model': 'gpt-35-turbo-16k',  'instructions': DIR_ROOT / "prompts/v1/2_RegulationRetrieverAgentPrompt.txt"},
#     {'name': 'ComplianceChecker',    'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/v1/3_ComplianceCheckerAgentPrompt.txt"},
#     {'name': 'ReportGenerator',      'model': 'gpt-4o', 'instructions': DIR_ROOT / "prompts/v1/4_ReportGeneratorAgentPrompt.txt"},
# ]

agents_config = [
    {'name': 'ClassifierAgent',      'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/v1/1_ClassifierAgentPrompt.txt"},
    {'name': 'RegulationRetriever',  'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/v1/2_RegulationRetrieverAgentPrompt.txt"},
    {'name': 'ComplianceChecker',    'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/v1/3_ComplianceCheckerAgentPrompt.txt"},
    {'name': 'ReportGenerator',      'model': 'gpt-4o', 'instructions': DIR_ROOT / "prompts/v1/4_ReportGeneratorAgentPrompt.txt"},
]


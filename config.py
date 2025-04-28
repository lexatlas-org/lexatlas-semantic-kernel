from pathlib import Path

DIR_ROOT = Path(__file__).parent

agents_config = [
    {'name': 'ClassifierAgent',      'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/1_ClassifierAgentPrompt.txt"},
    {'name': 'RegulationRetriever',  'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/2_RegulationRetrieverAgentPrompt.txt"},
    {'name': 'ComplianceChecker',    'model': 'gpt-4o-mini',  'instructions': DIR_ROOT / "prompts/3_ComplianceCheckerAgentPrompt.txt"},
    {'name': 'ReportGenerator',      'model': 'gpt-4o-mini', 'instructions': DIR_ROOT / "prompts/4_ReportGeneratorAgentPrompt.txt"},
]
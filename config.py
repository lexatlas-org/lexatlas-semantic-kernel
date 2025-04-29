from pathlib import Path

DIR_ROOT = Path(__file__).parent

agents_config = [
    {'name': 'ClassifierAgent',      'model': 'gpt-35-turbo-16k', 'id':'asst_tluMzunuZZ21J1R35fFwCvj0',  'instructions': DIR_ROOT / "prompts/v1/1_ClassifierAgentPrompt.txt"},
    {'name': 'RegulationRetriever',  'model': 'gpt-35-turbo-16k', 'id':'asst_tkcxfBRgzYP1rhMIHmU64qFH',  'instructions': DIR_ROOT / "prompts/v1/2_RegulationRetrieverAgentPrompt.txt"},
    {'name': 'ComplianceChecker',    'model': 'gpt-4o-mini', 'id':'asst_J4Jd3AnKXehfs3kDVr82ozml',  'instructions': DIR_ROOT / "prompts/v1/3_ComplianceCheckerAgentPrompt.txt"},
    {'name': 'ReportGenerator',      'model': 'gpt-4o', 'id':'asst_I6mQbFBD1m3RMNhWh3BNklU8', 'instructions': DIR_ROOT / "prompts/v1/4_ReportGeneratorAgentPrompt.txt"},
]


# agents_config = [
#     {'name': 'ClassifierAgent',      'model': 'gpt-4o-mini', 'id':'asst_tluMzunuZZ21J1R35fFwCvj0',  'instructions': DIR_ROOT / "prompts/1_ClassifierAgentPrompt.txt"},
#     {'name': 'RegulationRetriever',  'model': 'gpt-4o-mini', 'id':'asst_tkcxfBRgzYP1rhMIHmU64qFH',  'instructions': DIR_ROOT / "prompts/2_RegulationRetrieverAgentPrompt.txt"},
#     {'name': 'ComplianceChecker',    'model': 'gpt-4o-mini', 'id':'asst_J4Jd3AnKXehfs3kDVr82ozml',  'instructions': DIR_ROOT / "prompts/3_ComplianceCheckerAgentPrompt.txt"},
#     {'name': 'ReportGenerator',      'model': 'gpt-4o-mini', 'id':'asst_I6mQbFBD1m3RMNhWh3BNklU8', 'instructions': DIR_ROOT / "prompts/4_ReportGeneratorAgentPrompt.txt"},
# ]
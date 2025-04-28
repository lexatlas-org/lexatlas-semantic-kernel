- see https://docs.google.com/document/d/15TRF5v7e72QL0wb4B-RuZz81HKFV2ZbnvQ26zjeaHmY/edit?tab=t.0
- see https://docs.google.com/document/d/1Nt_QjXWAjPtz8n-g4WEuFqk9-L3hxi5nEcPEp1K-J7Y/edit?tab=t.0 


| Agent Name           | Model                                          | Temp. | Top P | Reasoning                                                                                   |
|----------------------|-------------------------------------------------|-------|-------|--------------------------------------------------------------------------------------------|
| ClassifierAgent       | gpt-35-turbo                                   | 0.2   | 0.6   | Needs deterministic classification. Lower values ensure consistent state/project detection. |
| RegulationRetriever  | gpt-35-turbo + text-embedding-ada-002           | 0.3   | 0.7   | Balances clarity and mild reasoning. Slight variability helps interpret legal phrasing.     |
| ComplianceChecker     | gpt-4o-mini                                    | 0.4   | 0.75  | Involves legal reasoning and checklist synthesis; moderate diversity helps surface edge cases. |
| ReportGenerator      | gpt-4o                                          | 0.5   | 0.9   | Needs expressive, human-like summaries. Slightly creative while remaining professional.    |
| Orchestration Layer  | Internal/system                                | 0.0   | 0.5   | Must behave deterministically, managing task order and memory without variation.            |

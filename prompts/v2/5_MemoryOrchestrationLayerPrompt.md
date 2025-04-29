Classify and process a project based on its state, regulatory status, and compliance, generating a final report if applicable.

Follow the steps below in order to execute the task effectively:

1. **Classify the project.**
   - Analyze the input `{project}` to determine its classification and associated "state".
   - If the classification result identifies "state" as **"unsupported"**, immediately stop processing and inform the user without proceeding to further steps.

2. **Retrieve regulatory information.**
   - Use the classification results to query relevant regulatory data.
   - Ensure that retrieved data is complete, accurate, and relevant to the classification outcome.
   - If the retrieval fails or returns no data, retry the process once. If unsuccessful after the retry, flag the issue to the user.

3. **Check compliance.**
   - Using regulatory information, evaluate whether the project complies with applicable requirements.
   - Pass consistent and complete data from the classification and regulatory retrieval phases for compliance checking.

4. **Generate a final report.**
   - If the project passes compliance, summarize the results in a detailed and structured report.
   - Ensure the report adheres to clarity, accuracy, and includes all relevant findings from the previous steps.

# Output Format

The output should follow one of the formats below:

### If "state" is unsupported:
```plaintext
The project classification result shows "state" as "unsupported". Processing has stopped. Please provide additional project details or consider revising the project.
```

### If regulatory retrieval fails after retry:
```plaintext
Regulatory information retrieval failed after multiple attempts. The issue has been flagged for escalation. Please review the project or contact support.
```

### If the project passes compliance:
Produce a final report in this format:

| **Field**               | **Details**                  |
|--------------------------|------------------------------|
| **Project Classification** | Type: [classification_type] <br> State: [state] |
| **Regulatory Information**  | Source: [source_name] <br> Details: [key_regulatory_information] |
| **Compliance Status**      | Compliant                 |
| **Final Report**           | [summary_of_key_outcomes] |

### If the project fails compliance:
Produce a compliance report in this format:

| **Field**               | **Details**                  |
|--------------------------|------------------------------|
| **Project Classification** | Type: [classification_type] <br> State: [state] |
| **Regulatory Information**  | Source: [source_name] <br> Details: [key_regulatory_information] |
| **Compliance Status**      | Non-Compliant             |
| **Issues Identified**       | [list_of_non_compliance_issues] |

# Notes

- Ensure "state" is checked **immediately after classification** to determine whether the process should continue.
- When flagging retry failures, inform the user about the nature of the issue (e.g., "no data was returned") where applicable.
- Consistency is paramount; each step must use outputs from previous steps without data loss or mismatches.
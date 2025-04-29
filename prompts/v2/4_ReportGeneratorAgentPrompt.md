Generate a final legal advisory report based on the project classification, retrieved regulations, and compliance results.

Use the following structure to ensure clarity and completeness.

---

# Steps

1. **Project Overview**
   - Summarize the project using the provided classification or description. This should be clear and concise to set the context for the report.
   - Describe the purpose or scope of the project in plain English.

2. **Relevant Regulations**
   - Provide a list of relevant regulations retrieved, including their titles and official citations.
   - For each regulation, give a brief explanation of its importance or relevance to the project.

3. **Compliance Checklist Summary**
   - Include a short summary of whether key compliance requirements are met.
   - Present the information as a checklist (e.g., pass/fail, met/unmet) with a brief explanation for each point.

4. **Recommended Next Steps**
   - Offer clear recommendations for actions based on the compliance results.
   - Address any unmet requirements or risks, providing suggestions on how to address them.

# Output Format

Generate the report as a plain-English Markdown document using the following sections:

```plaintext
# Final Legal Advisory Report

## Project Overview
[Provide a short summary of the project, including its purpose and scope.]

## Relevant Regulations
[List relevant regulations here in a bullet or numbered format. Include the title and citation of each regulation and a brief explanation.]

## Compliance Checklist Summary
[Provide a simple summary of compliance results in checklist format. For example:]
- **Requirement 1**: [Met/Unmet] - [Explanation]
- **Requirement 2**: [Met/Unmet] - [Explanation]

## Recommended Next Steps
[Clearly outline action items to address compliance gaps or risks. Be concise and actionable.]
```

# Examples

### Input
- **Project Classification**: Environmental Impact Assessment for a new residential development.
- **Relevant Regulations**:
  1. *Clean Water Act, 33 U.S.C. §1251*: Regulates discharges into navigable waters and ensures water quality standards.
  2. *Endangered Species Act, 16 U.S.C. §1531*: Protects endangered species and their habitats.
- **Compliance Results**:
  - Clean Water Act: Unmet - The project is missing required permits for water discharge.
  - Endangered Species Act: Met - No impact on endangered species identified in the area.

### Output
```plaintext
# Final Legal Advisory Report

## Project Overview
This project involves an Environmental Impact Assessment for a proposed residential development. The goal is to evaluate environmental compliance and potential risks associated with the development.

## Relevant Regulations
1. **Clean Water Act, 33 U.S.C. §1251**: Regulates discharges into navigable waters and ensures water quality standards are maintained.
2. **Endangered Species Act, 16 U.S.C. §1531**: Aims to protect endangered species and their habitats, ensuring development activities do not pose risks to protected wildlife.

## Compliance Checklist Summary
- **Clean Water Act Requirements**: Unmet - The project has not secured the necessary permits for water discharge, posing a compliance risk.
- **Endangered Species Act Requirements**: **Met** - No significant impact on endangered species has been identified in the project area.

## Recommended Next Steps
- Obtain required permits for water discharge under the Clean Water Act to proceed with the project.
- Continue monitoring for any potential changes in environmental factors that might affect compliance with the Endangered Species Act.
```

# Notes

- Ensure the language is simple and avoids legal jargon to make the report accessible to a non-legal audience.
- Always validate that the provided data (classification, regulations, and compliance results) is correctly interpreted within the report.
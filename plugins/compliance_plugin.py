import os
import requests
from typing import Annotated
from semantic_kernel.functions import kernel_function
from dotenv import load_dotenv

load_dotenv()
SERPAPI_SEARCH_API_KEY = os.environ.get("SERPAPI_SEARCH_API_KEY")
SERPAPI_SEARCH_ENDPOINT = "https://serpapi.com/search"

class CompliancePlugin:
    """Retrieve compliance-related legal info from web using SerpApi"""

    @kernel_function(description="Check legal or regulatory compliance from the web")
    def check_compliance(self, query: Annotated[str, "User's project description or legal query"]) -> Annotated[str, "Web-based legal/regulatory insights"]:
        params = {
            "engine": "google",
            "q": query,
            "hl": "en",
            "gl": "us",
            "api_key": SERPAPI_SEARCH_API_KEY
        }

        response = requests.get(SERPAPI_SEARCH_ENDPOINT, params=params)
        if response.status_code == 200:
            results = response.json().get("organic_results", [])
            formatted = "\n".join(
                f"- {r.get('title')}: {r.get('link')}" for r in results[:3]
            )
            return formatted if formatted else "No legal results found."
        return f"Error: HTTP {response.status_code}"

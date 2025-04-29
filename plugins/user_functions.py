
import os
import requests
from typing import Annotated
from typing import Any, Callable, Set, Dict, List, Optional


# Load the SerpAPI key from the environment
SERPAPI_SEARCH_API_KEY = os.getenv("SERPAPI_SEARCH_API_KEY")
SERPAPI_SEARCH_ENDPOINT = "https://serpapi.com/search"

def check_compliance(
    query: Annotated[str, "User's project description or legal query"]
) -> Annotated[str, "Web-based legal/regulatory insights"]:
    """
    Uses SerpAPI to check legal or regulatory compliance from the web.
    """
    if not SERPAPI_SEARCH_API_KEY:
        return "Error: SERPAPI_SEARCH_API_KEY not set."

    params = {
        "engine": "google",
        "q": query,
        "hl": "en",
        "gl": "us",
        "api_key": SERPAPI_SEARCH_API_KEY
    }

    try:
        response = requests.get(SERPAPI_SEARCH_ENDPOINT, params=params, timeout=10)
        response.raise_for_status()
    except requests.RequestException as e:
        return f"Request failed: {e}"

    results = response.json().get("organic_results", [])
    formatted = "\n".join(f"- {r.get('title')}: {r.get('link')}" for r in results[:3])
    return formatted if formatted else "No legal results found."


# Statically defined user functions for fast reference
user_functions: Set[Callable[..., Any]] = {
    check_compliance,
}

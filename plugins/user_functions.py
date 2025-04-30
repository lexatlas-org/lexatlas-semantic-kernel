import os
import requests
from typing import Annotated, Callable, Set, Any

# Load the SerpAPI key from the environment
SERPAPI_SEARCH_API_KEY = os.getenv("SERPAPI_SEARCH_API_KEY")
SERPAPI_SEARCH_ENDPOINT = "https://serpapi.com/search"

def check_compliance(
    query: Annotated[str, "User's project description or legal query"]
) -> Annotated[str, "Web-based legal/regulatory insights"]:
    """
    Uses SerpAPI to check legal or regulatory compliance from the web.
    Returns top results with snippets, including answer box and related questions if available.
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
        data = response.json()
    except requests.RequestException as e:
        return f"Request failed: {e}"

    output = []

    # Include Answer Box if present
    answer_box = data.get("answer_box")
    if answer_box:
        title = answer_box.get("title")
        snippet = answer_box.get("snippet")
        link = answer_box.get("link")
        if title and snippet:
            output.append(f"**Answer Box**\n{title}\n{snippet}\n{link}\n")

    # Include Organic Results
    organic_results = data.get("organic_results", [])
    if organic_results:
        output.append(" **Top Legal Results**")
        for result in organic_results[:3]:
            title = result.get("title")
            link = result.get("link")
            snippet = result.get("snippet", "")
            output.append(f"- {title}\n  {snippet}\n  {link}")

    # Include Related Questions if any
    related = data.get("related_questions", [])
    if related:
        output.append("\n **People Also Ask**")
        for r in related[:2]:  # Limit to 2
            question = r.get("question")
            snippet = r.get("snippet", "")
            link = r.get("link")
            output.append(f"- {question}\n  {snippet}\n  {link}")

    return "\n".join(output) if output else "No relevant compliance info found."

# Registered user functions
user_functions: Set[Callable[..., Any]] = {
    check_compliance,
}

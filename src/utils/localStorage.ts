import { SearchResult } from '../types';

const HISTORY_KEY = 'lexatlas-history';
const RESULTS_KEY = 'lexatlas-results';

export function loadHistory(): string[] {
  return JSON.parse(localStorage.getItem(HISTORY_KEY) || '[]');
}

export function saveHistory(history: string[]) {
  localStorage.setItem(HISTORY_KEY, JSON.stringify(history));
}

export function saveResults(query: string, results: SearchResult[]) {
  const allResults = JSON.parse(localStorage.getItem(RESULTS_KEY) || '{}');
  allResults[query] = results;
  localStorage.setItem(RESULTS_KEY, JSON.stringify(allResults));
}

export function loadResults(query: string): SearchResult[] {
  const allResults = JSON.parse(localStorage.getItem(RESULTS_KEY) || '{}');
  return allResults[query] || [];
}
export function clearHistory() {
  localStorage.removeItem(HISTORY_KEY);
}

// Remove a query and its cached results
export function removeQuery(query: string) {
  const history = loadHistory().filter((item) => item !== query);
  saveHistory(history);

  const allResults = JSON.parse(localStorage.getItem(RESULTS_KEY) || '{}');
  delete allResults[query];
  localStorage.setItem(RESULTS_KEY, JSON.stringify(allResults));

  return history;
}

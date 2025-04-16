import { SearchResult } from '../types';
import { CachedSearch } from '../types/index';

const RESULTS_KEY = 'lexatlas-results';

export function saveResults(query: string, results: SearchResult[], context_id: string) {
  const allResults: Record<string, CachedSearch> =
    JSON.parse(localStorage.getItem(RESULTS_KEY) || '{}');

  allResults[query] = { results, context_id };
  localStorage.setItem(RESULTS_KEY, JSON.stringify(allResults));
}

export function loadResults(query: string): CachedSearch | null {
  const allResults: Record<string, CachedSearch> =
    JSON.parse(localStorage.getItem(RESULTS_KEY) || '{}');

  return allResults[query] || null;
}

export function removeResultsByQuery(query: string): string[] {
  const allResults: Record<string, CachedSearch> =
    JSON.parse(localStorage.getItem(RESULTS_KEY) || '{}');

  delete allResults[query];

  localStorage.setItem(RESULTS_KEY, JSON.stringify(allResults));

  return Object.keys(allResults);
}

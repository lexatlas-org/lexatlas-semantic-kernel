import { create } from 'zustand';
import { SearchResult, CachedSearch } from '../types';

interface SearchState {
  results: SearchResult[];
  contextId: string | null;
  hasSearched: boolean;
  setResults: (results: SearchResult[], contextId: string) => void;
  loadCached: (cached: CachedSearch) => void;
  reset: () => void;
}

export const useSearchStore = create<SearchState>((set) => ({
  results: [],
  contextId: null,
  hasSearched: false,

  setResults: (results, contextId) =>
    set({
      results,
      contextId,
      hasSearched: true,
    }),

  loadCached: (cached) =>
    set({
      results: cached.results || [],
      contextId: cached.context_id || '',
      hasSearched: true,
    }),

  reset: () => set({ results: [], contextId: null, hasSearched: false }),
}));

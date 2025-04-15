import { Box, Flex } from '@chakra-ui/react';
import { useEffect, useState } from 'react';
import { searchLegalContext } from '../services/api';
import SearchHistory from '../components/search/SearchHistory';
import SearchMain from '../components/search/SearchMain';
import {
  loadHistory,
  saveHistory,
  saveResults,
  loadResults,
  removeQuery,
} from '../utils/localStorage';
import { SearchResult } from '../types';

interface SearchPageProps {
  onContextSelect: (contextId: string) => void;
}

export default function SearchPage({ onContextSelect }: SearchPageProps) {
  const [results, setResults] = useState<SearchResult[]>([]);
  const [loading, setLoading] = useState(false);
  const [docId, setDocId] = useState<string | null>(null);
  const [searchHistory, setSearchHistory] = useState<string[]>([]);
  const [currentContextId, setCurrentContextId] = useState<string | null>(null);

  useEffect(() => {
    setSearchHistory(loadHistory());
  }, []);

  const search = async (query: string) => {
    if (!query.trim()) return;

    setLoading(true);
    try {
      const { data } = await searchLegalContext(query);
      const newResults = data.results || [];

      setResults(newResults);
      onContextSelect(data.context_id || '');
      setCurrentContextId(data.context_id || '');

      saveResults(query, newResults, data.context_id);

      const updated = [query, ...searchHistory.filter((q) => q !== query)];
      setSearchHistory(updated.slice(0, 10));
      saveHistory(updated);
    } catch {
      setResults([]);
    } finally {
      setLoading(false);
    }
  };

  const handleHistoryClick = (query: string) => {
    const cached = loadResults(query);
    if (cached) {
      setResults(cached.results);
      onContextSelect(cached.context_id);
      setCurrentContextId(cached.context_id);
      setLoading(false);
    }
  };

  const handleRemoveHistoryItem = (query: string) => {
    const updated = removeQuery(query);
    setSearchHistory(updated);
    if (results.length && query === searchHistory[0]) {
      setResults([]);
    }
  };

  return (
    <Flex>
      {/* Sidebar */}
      <Box
        width="250px"
        p={4}
        borderRight="1px solid #e2e8f0"
        bg="gray.50"
        minH="100vh"
        position="sticky"
        top={0}
      >
        <SearchHistory
          history={searchHistory}
          onSelect={handleHistoryClick}
          onRemove={handleRemoveHistoryItem}
          activeContextId={currentContextId}
        />
      </Box>

      {/* Main content */}
      <SearchMain
        docId={docId}
        loading={loading}
        results={results}
        onSearch={search}
        onDocSelect={setDocId}
      />
    </Flex>
  );
}

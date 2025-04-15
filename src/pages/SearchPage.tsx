import { Box, Flex, Heading, Spinner, Text } from '@chakra-ui/react';
import { useEffect, useState } from 'react';
import { searchLegalContext } from '../services/api';
import SearchBar from '../components/search/SearchBar';
import SearchResults from '../components/search/SearchResults';
import SearchHistory from '../components/search/SearchHistory';
import { loadHistory,  saveHistory,  saveResults,  loadResults,  removeQuery} from '../utils/localStorage';

import { SearchResult } from '../types';

interface SearchPageProps {
  onContextSelect: (contextId: string) => void;
}

export default function SearchPage({ onContextSelect }: SearchPageProps) {
  const [results, setResults] = useState<SearchResult[]>([]);
  const [loading, setLoading] = useState(false);
  const [docId, setDocId] = useState<string | null>(null);
  const [searchHistory, setSearchHistory] = useState<string[]>([]);

  useEffect(() => {
    const history = loadHistory();
    setSearchHistory(history);
  }, []);

  const search = async (query: string) => {
    if (!query.trim()) return;

    setLoading(true);
    try {
      const { data } = await searchLegalContext(query);
      const newResults = data.results || [];

      setResults(newResults);
      onContextSelect(data.context_id || '');

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
      onContextSelect(cached.context_id); // <- sets it in App.tsx
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
        />
      </Box>

      {/* Main content */}
      <Box flex="1" p={6}>
        <Heading size="lg" mb={4}>LexAtlas Search (docId {docId})</Heading>
        <SearchBar onSearch={search} />
        {loading ? (
          <Spinner />
        ) : results.length ? (
          <SearchResults results={results} onSelect={setDocId} />
        ) : (
          <Text color="gray.500" mt={4}>No results found.</Text>
        )}
      </Box>
    </Flex>
  );
}

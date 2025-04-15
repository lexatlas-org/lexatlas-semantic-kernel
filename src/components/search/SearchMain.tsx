// src/components/search/SearchMain.tsx
import { useState } from 'react';
import { Box, Heading, Spinner, Text } from '@chakra-ui/react';
import SearchBar from './SearchBar';
import SearchResults from './SearchResults';
import SearchHistory from './SearchHistory';
import { saveResults } from '../../utils/localStorage';
import { SearchResult, CachedSearch } from '../../types';
import { searchLegalContext } from '../../services/api';

interface SearchMainProps {
  onContextSelect: (contextId: string) => void;
}

export default function SearchMain({ onContextSelect }: SearchMainProps) {
  const [results, setResults] = useState<SearchResult[]>([]);
  const [loading, setLoading] = useState(false);
  const [currentContextId, setCurrentContextId] = useState<string | null>(null);
  const [hasSearched, setHasSearched] = useState(false);
  const [historyRefreshKey, setHistoryRefreshKey] = useState(0); // ✅ NEW

  const search = async (query: string) => {
    if (!query.trim()) return;

    setHasSearched(true);
    setLoading(true);
    try {
      const { data } = await searchLegalContext(query);
      const newResults = data.results || [];

      setResults(newResults);
      saveResults(query, newResults, data.context_id);

      onContextSelect(data.context_id || '');
      setCurrentContextId(data.context_id || '');

      setHistoryRefreshKey((prev) => prev + 1); // ✅ trigger SearchHistory refresh
    } catch {
      setResults([]);
    } finally {
      setLoading(false);
    }
  };

  const handleHistorySelect = (item: CachedSearch) => {
    setCurrentContextId(item.context_id || '');
    onContextSelect(item.context_id || '');
    setResults(item.results || []);
  };

  return (
    <Box display="flex" width="100%">
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
          activeContextId={currentContextId}
          onSelect={handleHistorySelect}
          refreshTrigger={historyRefreshKey} // ✅ passed to update history
        />
      </Box>

      {/* Main content */}
      <Box flex="1" p={6}>
        <Heading size="lg" mb={4}>
          LexAtlas Search
        </Heading>

        <SearchBar onSearch={search} />

        {loading ? (
          <Spinner />
        ) : results.length ? (
          <SearchResults results={results} onSelect={search} />
        ) : hasSearched ? (
          <Text color="gray.500" mt={4}>
            No results found.
          </Text>
        ) : null}
      </Box>
    </Box>
  );
}

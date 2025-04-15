// src/components/search/SearchMain.tsx
import { useState } from 'react';
import { Box, Heading, Text } from '@chakra-ui/react';
import SearchBar from './SearchBar';
import SearchResults from './SearchResults';
import SearchHistory from './SearchHistory';
import { SearchResult, CachedSearch } from '../../types';

interface SearchMainProps {
  onContextSelect: (contextId: string) => void;
}

export default function SearchMain({ onContextSelect }: SearchMainProps) {
  const [results, setResults] = useState<SearchResult[]>([]);
  const [currentContextId, setCurrentContextId] = useState<string | null>(null);
  const [hasSearched, setHasSearched] = useState(false);
  const [historyRefreshKey, setHistoryRefreshKey] = useState(0);

  const handleSearchComplete = (results: SearchResult[], contextId: string) => {
    setResults(results);
    setCurrentContextId(contextId);
    onContextSelect(contextId);
    setHasSearched(true);
    setHistoryRefreshKey((prev) => prev + 1);  
  };

  const handleHistorySelect = (item: CachedSearch) => {
    setCurrentContextId(item.context_id || '');
    onContextSelect(item.context_id || '');
    setResults(item.results || []);
    setHasSearched(true);
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
          refreshTrigger={historyRefreshKey}
        />
      </Box>

      {/* Main content */}
      <Box flex="1" p={6}>
        <Heading size="lg" mb={4}>
          LexAtlas Search
        </Heading>

        <SearchBar onSearchComplete={handleSearchComplete} />

        {results.length > 0 ? (
          <SearchResults results={results} />
        ) : hasSearched ? (
          <Text color="gray.500" mt={4}>
            No results found.
          </Text>
        ) : null}
      </Box>
    </Box>
  );
}

// SearchMain.tsx
import { Box, Heading, Text } from '@chakra-ui/react';
import SearchBar from './SearchBar';
import SearchResults from './SearchResults';
import SearchHistory from './SearchHistory';
import { useSearchStore } from '../../store/useSearchStore';

interface SearchMainProps {
  onContextSelect: (contextId: string) => void;
}

export default function SearchMain({ onContextSelect }: SearchMainProps) {
  const { results, contextId, hasSearched } = useSearchStore();
  const currentContextId = contextId;

  const handleContextUpdate = (ctxId: string) => {
    onContextSelect(ctxId);
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
          onContextSelect={handleContextUpdate}
        />
      </Box>

      {/* Main content */}
      <Box flex="1" p={6}>
        <Heading size="lg" mb={4}>
          LexAtlas Search
        </Heading>

        <SearchBar onContextSelect={handleContextUpdate} />

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

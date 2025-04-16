import { Box, Heading, Text } from '@chakra-ui/react';
import SearchBar from './SearchBar';
import SearchResults from './SearchResults';
import SearchHistory from './SearchHistory';
import { useSearchStore } from '../../store/useSearchStore';

export default function SearchMain() {
  const { results, contextId, hasSearched } = useSearchStore();

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
        <SearchHistory activeContextId={contextId} />
      </Box>

      {/* Main content */}
      <Box flex="1" p={6}>
        <Heading size="lg" mb={4}>
          LexAtlas Search
        </Heading>

        <SearchBar />

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

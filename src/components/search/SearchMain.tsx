// src/components/search/SearchMain.tsx
import { Box, Heading, Spinner, Text } from '@chakra-ui/react';
import SearchBar from './SearchBar';
import SearchResults from './SearchResults';
import { SearchResult } from '../../types';

interface SearchMainProps {
  docId: string | null;
  loading: boolean;
  results: SearchResult[];
  onSearch: (query: string) => void;
  onDocSelect: (docId: string) => void;
}

export default function SearchMain({
  docId,
  loading,
  results,
  onSearch,
  onDocSelect,
}: SearchMainProps) {
  return (
    <Box flex="1" p={6}>
      <Heading size="lg" mb={4}>
        LexAtlas Search {docId && `(docId ${docId})`}
      </Heading>
      <SearchBar onSearch={onSearch} />
      {loading ? (
        <Spinner />
      ) : results.length ? (
        <SearchResults results={results} onSelect={onDocSelect} />
      ) : (
        <Text color="gray.500" mt={4}>
          No results found.
        </Text>
      )}
    </Box>
  );
}

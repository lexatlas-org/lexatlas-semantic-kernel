import { Box, Heading, Spinner, Text } from '@chakra-ui/react';
import { useState } from 'react';
import { searchLegalContext } from '../services/api';
import SearchBar from '../components/search/SearchBar';
import SearchResults from '../components/search/SearchResults';

import { SearchResult } from '../types/index';

interface SearchPageProps {
  onContextSelect: (contextId: string) => void;
}


export default function SearchPage({ onContextSelect }: SearchPageProps) {
  const [results, setResults] = useState<SearchResult[]>([]);
  const [loading, setLoading] = useState(false);

  const search = async (query: string) => {
    setLoading(true);
    try {
      const { data } = await searchLegalContext(query);
      setResults(data.results || []);
    } catch {
      setResults([]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box p={6}>
      <Heading size="lg" mb={4}>LexAtlas Search</Heading>
      <SearchBar onSearch={search} />
      {loading ? <Spinner /> : results.length ? (
        <SearchResults results={results} onSelect={onContextSelect} />
      ) : (
        <Text>No results found.</Text>
      )}
    </Box>
  );
}

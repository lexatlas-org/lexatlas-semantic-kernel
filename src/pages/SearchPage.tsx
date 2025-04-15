import { Box, Heading, Spinner, Text } from '@chakra-ui/react';
import { useState } from 'react';
import { searchLegalContext } from '../services/api';
import SearchBar from '../components/search/SearchBar';
import SearchResults from '../components/search/SearchResults';
import SearchHistory from '../components/search/SearchHistory';

import { SearchResult } from '../types/index';

interface SearchPageProps {
  onContextSelect: (contextId: string) => void;
}


export default function SearchPage({ onContextSelect }: SearchPageProps) {
  const [results, setResults] = useState<SearchResult[]>([]);
  const [loading, setLoading] = useState(false);
  const [docId, setDocId] = useState<string | null>(null);
  const [searchHistory, setSearchHistory] = useState<string[]>([]);

  const search = async (query: string) => {
    if (!query.trim()) return;
  
    setLoading(true);
    try {
      const { data } = await searchLegalContext(query);
      setResults(data.results || []);
      onContextSelect(data.context_id || '');

      setSearchHistory((prev) => {
        const updated = [query, ...prev.filter((q) => q !== query)];
        return updated.slice(0, 10); // optional: limit to last 10
      });
      
    } catch {
      setResults([]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box p={6}>
      <Heading size="lg" mb={4}>LexAtlas Search (docId {docId})</Heading>
      <SearchBar onSearch={search} />
      <SearchHistory history={searchHistory} onSelect={search} />

      {loading ? <Spinner /> : results.length ? (
        <SearchResults results={results} onSelect={setDocId} />
      ) : (
        <Text>No results found.</Text>
      )}
    </Box>
  );
}

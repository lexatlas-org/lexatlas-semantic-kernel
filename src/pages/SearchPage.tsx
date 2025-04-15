import { Box, Heading, Spinner, Text } from '@chakra-ui/react';
import { useState } from 'react';
import { useEffect } from 'react';
import { searchLegalContext } from '../services/api';
import SearchBar from '../components/search/SearchBar';
import SearchResults from '../components/search/SearchResults';
import SearchHistory from '../components/search/SearchHistory';

import { SearchResult } from '../types/index';

import { loadHistory, saveHistory, saveResults, loadResults } from '../utils/localStorage';

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
  
      // Save to localStorage
      saveResults(query, newResults);
  
      // Update history
      setSearchHistory((prev) => {
        const updated = [query, ...prev.filter((q) => q !== query)];
        saveHistory(updated);
        return updated.slice(0, 10);
      });

    } catch {
      setResults([]);
    } finally {
      setLoading(false);
    }
  };  

  const handleHistoryClick = (query: string) => {
    const cached = loadResults(query);
    setResults(cached);
    setLoading(false);
  };

  return (
    <Box p={6}>
      <Heading size="lg" mb={4}>LexAtlas Search (docId {docId})</Heading>
      <SearchBar onSearch={search} />
      <SearchHistory history={searchHistory} onSelect={handleHistoryClick} />

      {loading ? <Spinner /> : results.length ? (
        <SearchResults results={results} onSelect={setDocId} />
      ) : (
        <Text>No results found.</Text>
      )}
    </Box>
  );
}

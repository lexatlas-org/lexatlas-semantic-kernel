// SearchBar.tsx
import { useState } from 'react';
import { Input, IconButton, HStack } from '@chakra-ui/react';
import { LuSearch } from 'react-icons/lu';
import { searchLegalContext } from '../../services/api';
import { saveResults } from '../../utils/localStorage';
import { useSearchStore } from '../../store/useSearchStore';

export default function SearchBar() {
  const [query, setQuery] = useState('');
  const [loading, setLoading] = useState(false);
  const setResults = useSearchStore((s) => s.setResults);

  const handleSearch = async () => {
    if (!query.trim()) return;

    setLoading(true);
    try {
      const { data } = await searchLegalContext(query);
      const results = data.results || [];
      const contextId = data.context_id || '';

      saveResults(query, results, contextId);
      setResults(results, contextId);
    } catch {
      setResults([], '');
    } finally {
      setLoading(false);
    }
  };

  return (
    <HStack mb={4}>
      <Input
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        onKeyDown={(e) => e.key === 'Enter' && handleSearch()}
        placeholder="Search legal topics..."
      />
      <IconButton
        aria-label="Search"
        onClick={handleSearch}
        ><LuSearch /></IconButton>
      
    </HStack>
  );
}

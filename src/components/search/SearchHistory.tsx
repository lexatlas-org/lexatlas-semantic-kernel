// src/components/search/SearchHistory.tsx
import { Box, Text, HStack, IconButton } from '@chakra-ui/react';
import { LuView, LuDelete } from 'react-icons/lu';
import { useEffect, useState } from 'react';

import {
  loadResults,
  removeResultsByQuery,
} from '../../utils/localStorage';
import { CachedSearch } from '../../types';

interface SearchHistoryProps {
  activeContextId: string | null;
  onSelect: (item: CachedSearch) => void;
  refreshTrigger?: number;
}

export default function SearchHistory({
  activeContextId,
  onSelect,
  refreshTrigger,
}: SearchHistoryProps) {
  const [history, setHistory] = useState<string[]>([]);

  useEffect(() => {
    const allKeys = Object.keys(
      JSON.parse(localStorage.getItem('lexatlas-results') || '{}')
    );
    setHistory(allKeys);
  }, [refreshTrigger]);

  const handleSelect = (cached: CachedSearch) => {
 
      onSelect(cached);
 
  };

  const handleRemove = (query: string) => {
    const updated = removeResultsByQuery(query);
    setHistory(updated);
  };

  return (
    <Box mb={6}>
      {history.map((query, index) => {
        const cached = loadResults(query);
        if (!cached) return null;

        const isActive = cached.context_id === activeContextId;

        return (
          <HStack
            key={index}
            justify="space-between"
            py={1}
            bg={isActive ? 'blue.50' : 'transparent'}
            borderRadius="md"
            px={2}
          >
            <Text
              flex="1"
              fontSize="sm"
              color={isActive ? 'blue.800' : 'blue.600'}
              fontWeight={isActive ? 'bold' : 'normal'}
              cursor="pointer"
              onClick={() => handleSelect(cached)}
              _hover={{ textDecoration: 'underline' }}
            >
              {query}
            </Text>
            <IconButton
              aria-label="View"
              size="sm"
              onClick={() => handleSelect(cached)}
            ><LuView /></IconButton>
            <IconButton
              aria-label="Remove"
              size="sm"
              onClick={() => handleRemove(query)}
              ><LuDelete /></IconButton>
          </HStack>
        );
      })}
    </Box>
  );
}

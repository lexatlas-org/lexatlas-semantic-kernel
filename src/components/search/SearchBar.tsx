import { Input, IconButton, HStack } from '@chakra-ui/react';
import { LuSearch } from "react-icons/lu"
import { useState } from 'react';

interface SearchBarProps {
  onSearch: (query: string) => void;
}

export default function SearchBar({ onSearch }: SearchBarProps) {
  const [query, setQuery] = useState('');
  return (
    <HStack mb={4}>
      <Input
        value={query}
        onChange={(e) => setQuery(e.target.value)}
        placeholder="Search legal topics..."
      />
      <IconButton
        aria-label="Search"
        onClick={() => onSearch(query)}
      >
        <LuSearch />
      </IconButton>
    </HStack>
  );
}

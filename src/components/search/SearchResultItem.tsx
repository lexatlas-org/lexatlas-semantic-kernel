import { Box, Text } from '@chakra-ui/react';

interface SearchResultItemProps {
  item: {
    context_id: string;
    title?: string;
    snippet: string;
  };
  onSelect: (contextId: string) => void;
}

export default function SearchResultItem({ item, onSelect }: SearchResultItemProps) {
  return (
    <Box
      borderWidth="1px"
      p={4}
      borderRadius="md"
      mb={3}
      onClick={() => onSelect(item.context_id)}
      cursor="pointer"
      _hover={{ bg: 'gray.50' }}
    >
      <Text fontWeight="bold">{item.title || 'Untitled'}</Text>
      <Text mt={1}>{item.snippet}</Text>
    </Box>
  );
}

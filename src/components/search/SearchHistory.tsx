import { Box, Heading, Text } from '@chakra-ui/react';

interface SearchHistoryProps {
  history: string[];
  onSelect: (query: string) => void;
}

export default function SearchHistory({ history, onSelect }: SearchHistoryProps) {
  return (
    <Box mb={6}>
      <Heading size="sm" mb={2}>Search History</Heading>
      {history.length > 0 ? (
        history.map((query, index) => (
          <Text
            key={index}
            onClick={() => onSelect(query)}
            color="blue.600"
            cursor="pointer"
            _hover={{ textDecoration: 'underline' }}
          >
            {query}
          </Text>
        ))
      ) : (
        <Text color="gray.500">No previous searches.</Text>
      )}
    </Box>
  );
}

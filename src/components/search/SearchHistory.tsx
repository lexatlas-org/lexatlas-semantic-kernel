import { Box, Heading, Text, Button, HStack } from '@chakra-ui/react';

interface SearchHistoryProps {
  history: string[];
  onSelect: (query: string) => void;
  onRemove: (query: string) => void;
}

export default function SearchHistory({ history, onSelect, onRemove }: SearchHistoryProps) {
  return (
    <Box mb={6}>
      <Heading size="sm" mb={2}>Search History</Heading>
      {history.length > 0 ? (
        history.map((query, index) => (
          <HStack key={index} justify="space-between" py={1}>
            <Text flex="1" noOfLines={1} fontSize="sm" color="blue.700">
              {query}
            </Text>
            <Button size="xs" colorScheme="blue" onClick={() => onSelect(query)}>View</Button>
            <Button size="xs" colorScheme="red" variant="outline" onClick={() => onRemove(query)}>Remove</Button>
          </HStack>
        ))
      ) : (
        <Text color="gray.500">No previous searches.</Text>
      )}
    </Box>
  );
}

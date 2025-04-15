import { Box, Text, Button, HStack } from '@chakra-ui/react';
import { loadResults } from '../../utils/localStorage';

interface SearchHistoryProps {
  history: string[];
  onSelect: (query: string) => void;
  onRemove: (query: string) => void;
  activeContextId: string | null;
}

export default function SearchHistory({
  history,
  onSelect,
  onRemove,
  activeContextId,
}: SearchHistoryProps) {
  return (
    <Box mb={6}>
      {history.map((query, index) => {
        const cached = loadResults(query);
        const isActive = cached?.context_id === activeContextId;

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
              onClick={() => onSelect(query)}
              _hover={{ textDecoration: 'underline' }}
            >
              {query}
            </Text>
            <Button size="xs" colorScheme="blue" onClick={() => onSelect(query)}>
              View
            </Button>
            <Button size="xs" colorScheme="red" variant="outline" onClick={() => onRemove(query)}>
              Remove
            </Button>
          </HStack>
        );
      })}
    </Box>
  );
}

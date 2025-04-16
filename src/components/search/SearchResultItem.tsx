import { Box, Text, Badge, Flex } from '@chakra-ui/react';
import { SearchResult } from '../../types/index';

export interface SearchResultItemProps {
  item: SearchResult;
}

export default function SearchResultItem({ item }: SearchResultItemProps) {
  return (
    <Box
      borderWidth="1px"
      borderRadius="md"
      p={5}
      mb={4}
      cursor="pointer"
      _hover={{ bg: 'gray.50', shadow: 'md' }}
      transition="all 0.2s"
    >
      <Flex justify="space-between" align="center" mb={2}>
        <Text fontSize="lg" fontWeight="semibold">
          {item.title || 'Untitled'}
        </Text>
        <Badge colorScheme="purple" fontSize="0.8em">
          Score: {item.score.toFixed(2)}
        </Badge>
      </Flex>

      <Text fontSize="md" color="gray.700"  whiteSpace="pre-wrap">
        {item.excerpt}
      </Text>
    </Box>
  );
}

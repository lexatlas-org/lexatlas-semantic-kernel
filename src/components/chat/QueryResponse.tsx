import { Box, Text, Code, Heading } from '@chakra-ui/react';
import { QueryResponse as TypeQueryResponse } from '../../types';

interface QueryResponseProps {
  response: TypeQueryResponse | null;
}

export default function QueryResponse({ response }: QueryResponseProps) {
  if (!response) return null;

  return (
    <Box mt={6} p={6} borderWidth="1px" borderRadius="md" bg="gray.50">
      <Heading size="md" mb={3}>Response</Heading>
      <Text fontSize="md" whiteSpace="pre-wrap" mb={4}>
        {response.answer}
      </Text>

      {response.source && (
        <>
          <hr   />
          <Text fontSize="sm" color="gray.500">
            Source: <Code colorScheme="blue">{response.source}</Code>
          </Text>
        </>
      )}

      {/* {response.used_chunks?.length > 0 && (
        <>
          <Divider my={4} />
          <Text fontWeight="semibold" fontSize="sm" mb={2}>Referenced Chunks:</Text>
          <VStack align="start" spacing={2}>
            {response.used_chunks.map((chunk, idx) => (
              <Box
                key={idx}
                p={3}
                bg="white"
                borderWidth="1px"
                borderRadius="md"
                fontSize="sm"
                whiteSpace="pre-wrap"
                w="100%"
              >
                {chunk}
              </Box>
            ))}
          </VStack>
        </>
      )} */}

      {response.timestamp && (
        <Text fontSize="xs" color="gray.400" mt={4}>
          Answer generated at: {new Date(response.timestamp).toLocaleString()}
        </Text>
      )}
    </Box>
  );
}

import { Box, Text } from '@chakra-ui/react';

interface QueryResponseProps {
  response: { answer: string } | null;
}

export default function QueryResponse({ response }: QueryResponseProps) {
  if (!response) return null;
  return (
    <Box mt={4} p={4} borderWidth="1px" borderRadius="md">
      <Text whiteSpace="pre-wrap">{response.answer}</Text>
    </Box>
  );
}

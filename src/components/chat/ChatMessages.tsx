import { Box, Text, VStack } from '@chakra-ui/react';

type ChatMessage = {
  role: 'user' | 'assistant';
  content: string;
};

interface ChatMessagesProps {
  messages: ChatMessage[];
}

export default function ChatMessages({ messages }: ChatMessagesProps) {
  return (
    <VStack align="stretch" mt={4}>
      {messages.map((msg, idx) => (
        <Box
          key={idx}
          alignSelf={msg.role === 'user' ? 'flex-end' : 'flex-start'}
          bg={msg.role === 'user' ? 'blue.100' : 'gray.100'}
          borderRadius="md"
          p={3}
          maxW="80%"
          whiteSpace="pre-wrap"
        >
          <Text fontSize="sm" color="gray.700">{msg.content}</Text>
        </Box>
      ))}
    </VStack>
  );
}

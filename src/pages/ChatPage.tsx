import { Box, Heading } from '@chakra-ui/react';
import { useState } from 'react';
import { submitFollowUpQuery } from '../services/api';
import FollowUpQuestionBox from '../components/chat/FollowUpQuestionBox';
import ChatMessages from '../components/chat/ChatMessages';

interface ChatPageProps {
  contextId: string;
}

type ChatMessage = {
  role: 'user' | 'assistant';
  content: string;
};

export default function ChatPage({ contextId }: ChatPageProps) {
  const [messages, setMessages] = useState<ChatMessage[]>([]);

  const ask = async (question: string, context_id: string) => {
    // Append user message
    const userMessage: ChatMessage = { role: 'user', content: question };
    setMessages((prev) => [...prev, userMessage]);

    // Fetch AI response
    try {
      const { data } = await submitFollowUpQuery(question, context_id);
      const assistantMessage: ChatMessage = {
        role: 'assistant',
        content: data.answer,
      };

      setMessages((prev) => [...prev, assistantMessage]);
    } catch (err) {
      const errorMessage: ChatMessage = {
        role: 'assistant',
        content: 'Something went wrong. Please try again.',
      };
      setMessages((prev) => [...prev, errorMessage]);
    }
  };

  return (
    <Box p={6}>
      <Heading size="md" mb={4}>
        Ask LexAgent
      </Heading>

      {/* Message history */}
      <ChatMessages messages={messages} />

      {/* Input box */}
      <FollowUpQuestionBox contextId={contextId} onSend={ask} />
    </Box>
  );
}

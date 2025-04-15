// src/components/chat/ChatMain.tsx
import { useState } from 'react';
import { Heading } from '@chakra-ui/react';
import ChatMessages from './ChatMessages';
import FollowUpQuestionBox from './FollowUpQuestionBox';
import { submitFollowUpQuery } from '../../services/api';

type ChatMessage = {
  role: 'user' | 'assistant';
  content: string;
};

interface ChatMainProps {
  contextId: string;
}

export default function ChatMain({ contextId }: ChatMainProps) {
  const [messages, setMessages] = useState<ChatMessage[]>([]);

  const handleSend = async (question: string, context_id: string) => {
    setMessages((prev) => [...prev, { role: 'user', content: question }]);

    try {
      const { data } = await submitFollowUpQuery(question, context_id);
      setMessages((prev) => [...prev, { role: 'assistant', content: data.answer }]);
    } catch {
      setMessages((prev) => [
        ...prev,
        { role: 'assistant', content: 'Something went wrong. Please try again.' },
      ]);
    }
  };

  return (
    <>
      <Heading size="md" mb={4}>
        Ask LexAgent
      </Heading>

      <ChatMessages messages={messages} />
      <FollowUpQuestionBox contextId={contextId} onSend={handleSend} />
    </>
  );
}

// src/pages/ChatPage.tsx
import { Box } from '@chakra-ui/react';
import ChatMain from '../components/chat/ChatMain';

interface ChatPageProps {
  contextId: string;
}

export default function ChatPage({ contextId }: ChatPageProps) {
  return (
  <Box p={6}>
    <ChatMain contextId={contextId} />;
  </Box>)
}

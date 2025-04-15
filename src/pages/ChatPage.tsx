import { Box, Heading } from '@chakra-ui/react';
import { useState } from 'react';
import { submitFollowUpQuery } from '../services/api';
import FollowUpQuestionBox from '../components/chat/FollowUpQuestionBox';
import QueryResponse from '../components/chat/QueryResponse';
import { QueryResponse as TypeQueryResponse } from '../types'; // 👈 Add this

interface ChatPageProps {
  contextId: string;
}

export default function ChatPage({ contextId }: ChatPageProps) {

  const [response, setResponse] = useState<TypeQueryResponse | null>(null); 

  const ask = async (question: string, context_id: string) => {
    const { data } = await submitFollowUpQuery(question, context_id);
    setResponse(data);
  };

  return (
    <Box p={6}>
      <Heading size="md" mb={4}>Ask LexAgent</Heading>
      <FollowUpQuestionBox contextId={contextId} onSend={ask} />
      <QueryResponse response={response} />  
    </Box>
  );
}

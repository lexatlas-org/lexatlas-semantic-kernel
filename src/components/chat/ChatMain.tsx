// ChatMain.tsx
import { Heading } from '@chakra-ui/react';
import ChatMessages from './ChatMessages';
import FollowUpQuestionBox from './FollowUpQuestionBox';
import { submitFollowUpQuery } from '../../services/api';
import { useChatStore } from '../../store/useChatStore';

export default function ChatMain() {
  const { messages, addUserMessage, addAssistantMessage,} = useChatStore();
  

  const handleSend = async (question: string, context_id: string) => {
    addUserMessage(question);

    try {
      const { data } = await submitFollowUpQuery(question, context_id);
      addAssistantMessage(data.answer);
    } catch {
      addAssistantMessage('Something went wrong. Please try again.');
    }
  };

  return (
    <>
      <Heading size="md" mb={4}>
        Ask LexAgent
      </Heading>

      <ChatMessages messages={messages} />
      <FollowUpQuestionBox onSend={handleSend} />
    </>
  );
}

import { VStack, Textarea, Button, FormErrorMessage } from '@chakra-ui/react';
import { useState } from 'react';
import { querySchema } from '../../schemas/querySchema';

interface FollowUpQuestionBoxProps {
  contextId: string;
  onSend: (question: string, context_id: string) => void;
}

export default function FollowUpQuestionBox({ contextId, onSend }: FollowUpQuestionBoxProps) {
  const [question, setQuestion] = useState('');
  const [error, setError] = useState<string | null>(null);

  const handleSubmit = () => {
    try {
      const validated = querySchema.parse({ question, context_id: contextId });
      onSend(validated.question, validated.context_id);
      setQuestion('');
      setError(null);
    } catch (err: any) {
      setError(err.errors?.[0]?.message);
    }
  };

  return (
    <VStack spacing={3} align="stretch">
      <Textarea
        value={question}
        onChange={(e) => setQuestion(e.target.value)}
        placeholder="Ask a legal question..."
      />
      {error && <FormErrorMessage>{error}</FormErrorMessage>}
      <Button colorScheme="teal" onClick={handleSubmit}>Ask</Button>
    </VStack>
  );
}

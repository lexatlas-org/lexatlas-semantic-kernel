// FollowUpQuestionBox.tsx
import { VStack, Textarea, Button, Text } from '@chakra-ui/react';
import { useState } from 'react';
import { querySchema } from '../../schemas/querySchema';
import { useSearchStore } from '../../store/useSearchStore';

interface Props {
  onSend: (question: string, contextId: string) => void;
}

export default function FollowUpQuestionBox({ onSend }: Props) {
  const [question, setQuestion] = useState('');
  const [error, setError] = useState<string | null>(null);
  const { contextId } = useSearchStore();

  const handleSubmit = () => {
    try {
      const validated = querySchema.parse({ question, context_id: contextId });
      onSend(validated.question, validated.context_id);
      setQuestion('');
      setError(null);
    } catch (err: any) {
      setError(err.errors?.[0]?.message || 'Invalid input');
    }
  };

  return (
    <VStack align="stretch" mt={4}>
      <Textarea
        value={question}
        onChange={(e) => setQuestion(e.target.value)}
        placeholder="Ask a legal question..."
      />
      {error && <Text color="red.500" fontSize="sm">{error}</Text>}
      <Button colorScheme="teal" onClick={handleSubmit}>
        Ask
      </Button>
    </VStack>
  );
}

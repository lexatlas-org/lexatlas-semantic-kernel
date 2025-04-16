import { Container, ButtonGroup, Button, Box, Text } from '@chakra-ui/react';
import { useState } from 'react';
import SearchPage from './pages/SearchPage';
import ChatPage from './pages/ChatPage';
import { useSearchStore } from './store/useSearchStore';

type ViewMode = 'search' | 'chat';

export default function App() {
  const [view, setView] = useState<ViewMode>('search');
  const { contextId } = useSearchStore();


  return (
    <Container maxW="container.md" mt={10}>
      <Box mb={4}>
        <ButtonGroup variant="outline">
          <Button
            onClick={() => setView('search')}
            disabled={view === 'search'}
          >
            Search
          </Button>
          <Button
            onClick={() => setView('chat')}
            disabled={view === 'chat'}
          >
            Chat
          </Button>
          <Button>{contextId}</Button>
        </ButtonGroup>

      </Box>

      {view === 'search' && <SearchPage />}
      {view === 'chat' && <ChatPage />}
    </Container>
  );
}

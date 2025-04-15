import { Container } from '@chakra-ui/react';
import { useState } from 'react';
import SearchPage from './pages/SearchPage';
import ChatPage from './pages/ChatPage';

export default function App() {
  const [contextId, setContextId] = useState<string | null>(null);

  return (
    <Container maxW="container.md" mt={10}> (contenxtId is {contextId})
    {/* <SearchPage onContextSelect={setContextId} /> */}
      {!contextId
        ? <SearchPage onContextSelect={setContextId} />
        : <ChatPage contextId={contextId} />
      }
    </Container>
  );
}

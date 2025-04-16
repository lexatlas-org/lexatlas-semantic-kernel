import { create } from 'zustand';

type ChatMessage = {
  role: 'user' | 'assistant';
  content: string;
};

interface ChatState {
  messages: ChatMessage[];
  addUserMessage: (content: string) => void;
  addAssistantMessage: (content: string) => void;
  resetMessages: () => void;
}

export const useChatStore = create<ChatState>((set) => ({
  messages: [],

  addUserMessage: (content) =>
    set((state) => ({
      messages: [...state.messages, { role: 'user', content }],
    })),

  addAssistantMessage: (content) =>
    set((state) => ({
      messages: [...state.messages, { role: 'assistant', content }],
    })),

  resetMessages: () => set({ messages: [] }),
}));

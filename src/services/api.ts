import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE_URL,
  headers: {
    'X-API-Key': import.meta.env.VITE_API_KEY,
    Accept: 'application/json',
  },
});

export const searchLegalContext = (query: string, topK = 5) =>
  api.get(`/search`, {
    params: { q: query, top_k: topK },
  });

export const submitFollowUpQuery = (question: string, context_id: string) =>
  api.post('/query', { question, context_id });

export const uploadDocument = (formData: FormData) =>
  api.post('/upload', formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  });

export default api;

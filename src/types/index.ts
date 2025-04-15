// Search result item
export interface SearchResult {
  title: string;
  excerpt: string;
  score: number;
  doc_id: string;
}

// Full search response
export interface SearchResponse {
  context_id: string;
  results: SearchResult[];
  source: string;
  timestamp: string;
}

// Query request payload
export interface QueryRequest {
  question: string;
  context_id: string;
}

// Query response from LLM
export interface QueryResponse {
  answer: string;
  source: string;
  used_chunks: string[];
  timestamp: string;
}

// Upload response payload
export interface UploadResponse {
  status: string;
  filename: string;
  doc_id: string;
  message: string;
}

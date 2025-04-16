import { z } from 'zod';

export const querySchema = z.object({
  question: z.string().min(5, 'Question is too short'),
  context_id: z.string().min(1, 'Missing context'),
});

export type QueryInput = z.infer<typeof querySchema>;

// SearchResults.tsx
import SearchResultItem from './SearchResultItem';
import { SearchResult } from '../../types';

interface Props {
  results: SearchResult[];
}

export default function SearchResults({ results }: Props) {
  return (
    <>
      {results.map((item, index) => (
        <SearchResultItem key={index} item={item} />
      ))}
    </>
  );
}

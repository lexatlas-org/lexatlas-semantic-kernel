import SearchResultItem from './SearchResultItem';
import { SearchResult } from '../../types/index';

interface SearchResultsProps {
  results: SearchResult[],
  onSelect: (docId: string) => void;
}

export default function SearchResults({ results, onSelect }: SearchResultsProps) {
  return (
    <>
      {results.map((item, i) => (
        <SearchResultItem key={i} item={item} onSelect={onSelect} />
      ))}
    </>
  );
}

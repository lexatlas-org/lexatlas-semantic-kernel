import SearchResultItem from './SearchResultItem';
import { SearchResult } from '../../types/index';

interface SearchResultsProps {
  results: SearchResult[],
}

export default function SearchResults({ results }: SearchResultsProps) {
  return (
    <>
      {results.map((item, i) => (
        <SearchResultItem key={i} item={item}  />
      ))}
    </>
  );
}

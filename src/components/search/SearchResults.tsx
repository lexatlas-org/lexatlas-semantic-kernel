import SearchResultItem from './SearchResultItem';

interface SearchResultsProps {
  results: {
    context_id: string;
    title?: string;
    snippet: string;
  }[];
  onSelect: (contextId: string) => void;
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

import SearchMain from '../components/search/SearchMain';

interface SearchPageProps {
  onContextSelect: (contextId: string) => void;
}

export default function SearchPage({ onContextSelect }: SearchPageProps) {
  return <SearchMain onContextSelect={onContextSelect} />;
}

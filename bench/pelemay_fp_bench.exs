defmodule PelemayFpBench do
  use Benchfella

  @list Enum.to_list(1..100000)

  bench "Enum" do
  	Enum.map(@list, &LogisticMap.logistic_map_10(&1))
  end

  bench "PelemayFp" do
  	PelemayFp.map(@list, &LogisticMap.logistic_map_10(&1))
  end

  bench "Flow" do
  	@list
  	|> Flow.from_enumerable()
  	|> Flow.map(&LogisticMap.logistic_map_10(&1))
  	|> Enum.to_list()
  	:ok
  end

  bench "Pmap" do
  	Parallel.pmap(@list, &LogisticMap.logistic_map_10(&1))
  end
end

defmodule PelemayFpBench do
  use Benchfella

  @list Enum.to_list(1..100000)

  setup_all do
    LogisticMap.logistic_map_10_pelemay(@list)
    {:ok, nil}
  end


  bench "Enum" do
  	Enum.map(@list, &LogisticMap.logistic_map_10(&1))
  end

  bench "PelemayFp" do
  	PelemayFp.map(@list, &LogisticMap.logistic_map_10(&1))
  end

  bench "Flow (without sorting)" do
  	@list
  	|> Flow.from_enumerable()
  	|> Flow.map(&LogisticMap.logistic_map_10(&1))
  	|> Enum.to_list()
  	:ok
  end

  bench "Flow (with sorting)" do
  	@list
  	|> Flow.from_enumerable()
  	|> Flow.map(&LogisticMap.logistic_map_10(&1))
  	|> Enum.sort()
  	:ok
  end

  bench "Pmap" do
  	Parallel.pmap(@list, &LogisticMap.logistic_map_10(&1))
  end

  bench "Pelemay" do
  	LogisticMap.logistic_map_10_pelemay(@list)
  end

  bench "PelemayFp and Pelemay" do
  	PelemayFp.map_chunk(@list, &LogisticMap.logistic_map_10(&1), &LogisticMap.logistic_map_10_pelemay(&1))
  end

  bench "Stream" do
    @list
    |> Stream.map(&LogisticMap.logistic_map_10(&1))
    |> Stream.run()
  end

  bench "Task.async_stream" do
    @list 
    |> Task.async_stream(&LogisticMap.logistic_map_10(&1))
    |> Enum.to_list()
  end
end

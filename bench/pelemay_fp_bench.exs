defmodule PelemayFpBench do
  use Benchfella

  @list Enum.to_list(1..100_000)
  @work 1000

  setup_all do
    LogisticMap.logistic_map_10_pelemay(@list)
    {:ok, nil}
  end

  bench "Enum" do
    Enum.map(@list, &LogisticMap.logistic_map_work(&1, @work))
  end

  bench "PelemayFp" do
    PelemayFp.map(@list, &LogisticMap.logistic_map_work(&1, @work))
  end

  bench "Flow (without sorting)" do
    @list
    |> Flow.from_enumerable()
    |> Flow.map(&LogisticMap.logistic_map_work(&1, @work))
    |> Enum.to_list()

    :ok
  end

  bench "Flow (with sorting)" do
    @list
    |> Flow.from_enumerable()
    |> Flow.map(&LogisticMap.logistic_map_work(&1, @work))
    |> Enum.sort()

    :ok
  end

  bench "Pmap" do
    Parallel.pmap(@list, &LogisticMap.logistic_map_work(&1, @work))
  end

  bench "Pelemay" do
    LogisticMap.logistic_map_10_pelemay(@list)
  end

  bench "PelemayFp and Pelemay" do
    PelemayFp.map_chunk(
      @list,
      &LogisticMap.logistic_map_work(&1, 10),
      &LogisticMap.logistic_map_10_pelemay(&1)
    )
  end

  bench "Stream" do
    @list
    |> Stream.map(&LogisticMap.logistic_map_work(&1, @work))
    |> Stream.run()
  end

  bench "Task.async_stream" do
    @list
    |> Task.async_stream(&LogisticMap.logistic_map_work(&1, @work))
    |> Enum.to_list()
  end

  bench "no calculation" do
    @list
    |> Enum.map(fn x -> x end)
  end

  bench "PelemayFp with very small batches" do
    PelemayFp.map(@list, &LogisticMap.logistic_map_work(&1, @work), 10)
  end

  bench "PelemayFp with small batches" do
    PelemayFp.map(@list, &LogisticMap.logistic_map_work(&1, @work), 1000)
  end

  bench "PelemayFp with big batches" do
    PelemayFp.map(@list, &LogisticMap.logistic_map_work(&1, @work), 120_000)
  end

  bench "Task.async_stream in chunks" do
    @list
    |> Stream.chunk_every(12000)
    |> Task.async_stream(fn e -> Enum.map(e, &LogisticMap.logistic_map_work(&1, @work)) end)
    |> Stream.flat_map(fn {:ok, v} -> v end)
    |> Enum.to_list()
  end

  bench "Task.async_stream in big chunks" do
    @list
    |> Stream.chunk_every(120_000)
    |> Task.async_stream(fn e -> Enum.map(e, &LogisticMap.logistic_map_work(&1, @work)) end)
    |> Stream.flat_map(fn {:ok, v} -> v end)
    |> Enum.to_list()
  end

  bench "Task.async_stream in small chunks" do
    @list
    |> Stream.chunk_every(1000)
    |> Task.async_stream(fn e -> Enum.map(e, &LogisticMap.logistic_map_work(&1, @work)) end)
    |> Stream.flat_map(fn {:ok, v} -> v end)
    |> Enum.to_list()
  end
end

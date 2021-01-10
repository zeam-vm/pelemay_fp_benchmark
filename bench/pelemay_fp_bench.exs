defmodule PelemayFpBench do
  use Benchfella

  setup_all do
    tid = :ets.new(:my_table, [:public, :named_table])
    LogisticMap.logistic_map_10_pelemay(1..10000)
    {:ok, tid}
  end

  before_each_bench tid do
    :ets.insert(
      tid,
      {
        "list",
        Enum.to_list(1..600_000)
      }
    )

    {:ok, tid}
  end

  after_each_bench tid do
    :ets.delete(tid, "list")
  end

  teardown_all tid do
    :ets.delete(tid)
  end

  bench "Enum" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    Enum.map(list, &LogisticMap.logistic_map_10(&1))
  end

  bench "PelemayFp with chunk size 12500 (48 cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    PelemayFp.map(list, &LogisticMap.logistic_map_10(&1), 12500)
  end

  bench "PelemayFp with chunk size 25000 (24 cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    PelemayFp.map(list, &LogisticMap.logistic_map_10(&1), 25000)
  end

  bench "PelemayFp with chunk size 33334 (18 cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    PelemayFp.map(list, &LogisticMap.logistic_map_10(&1), 33334)
  end

  bench "PelemayFp with chunk size 37500 (16 cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    PelemayFp.map(list, &LogisticMap.logistic_map_10(&1), 37500)
  end

  bench "PelemayFp with chunk size 50000 (12 cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    PelemayFp.map(list, &LogisticMap.logistic_map_10(&1), 50000)
  end

  bench "PelemayFp with chunk size 100000 (6 cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    PelemayFp.map(list, &LogisticMap.logistic_map_10(&1), 100_000)
  end

  bench "PelemayFp with chunk size 120000 (5 cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    PelemayFp.map(list, &LogisticMap.logistic_map_10(&1), 120_000)
  end

  bench "PelemayFp with chunk size 150000 (4 cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    PelemayFp.map(list, &LogisticMap.logistic_map_10(&1), 150_000)
  end

  bench "PelemayFp with chunk size 200000 (3 cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    PelemayFp.map(list, &LogisticMap.logistic_map_10(&1), 200_000)
  end

  bench "PelemayFp with chunk size 300000 (2 cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    PelemayFp.map(list, &LogisticMap.logistic_map_10(&1), 300_000)
  end

  bench "PelemayFp with chunk size 600000 (1 cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    PelemayFp.map(list, &LogisticMap.logistic_map_10(&1), 600_000)
  end

  bench "Flow (without sorting)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")

    list
    |> Flow.from_enumerable()
    |> Flow.map(&LogisticMap.logistic_map_10(&1))
    |> Enum.to_list()

    :ok
  end

  bench "Flow (with sorting)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")

    list
    |> Flow.from_enumerable()
    |> Flow.map(&LogisticMap.logistic_map_10(&1))
    |> Enum.sort()

    :ok
  end

  bench "Pmap" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    Parallel.pmap(list, &LogisticMap.logistic_map_10(&1))
  end

  bench "Pelemay" do
    [{"list", list}] = :ets.lookup(:my_table, "list")
    LogisticMap.logistic_map_10_pelemay(list)
  end

  bench "PelemayFp and Pelemay with chunk size 50000 (12cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")

    PelemayFp.map_chunk(
      list,
      &LogisticMap.logistic_map_10(&1),
      &LogisticMap.logistic_map_10_pelemay(&1),
      50000
    )
  end

  bench "PelemayFp and Pelemay with chunk size 100000 (6cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")

    PelemayFp.map_chunk(
      list,
      &LogisticMap.logistic_map_10(&1),
      &LogisticMap.logistic_map_10_pelemay(&1),
      100_000
    )
  end

  bench "PelemayFp and Pelemay with chunk size 120000 (5cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")

    PelemayFp.map_chunk(
      list,
      &LogisticMap.logistic_map_10(&1),
      &LogisticMap.logistic_map_10_pelemay(&1),
      120_000
    )
  end

  bench "PelemayFp and Pelemay with chunk size 150000 (4cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")

    PelemayFp.map_chunk(
      list,
      &LogisticMap.logistic_map_10(&1),
      &LogisticMap.logistic_map_10_pelemay(&1),
      150_000
    )
  end

  bench "PelemayFp and Pelemay with chunk size 200000 (3cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")

    PelemayFp.map_chunk(
      list,
      &LogisticMap.logistic_map_10(&1),
      &LogisticMap.logistic_map_10_pelemay(&1),
      200_000
    )
  end

  bench "PelemayFp and Pelemay with chunk size 300000 (2cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")

    PelemayFp.map_chunk(
      list,
      &LogisticMap.logistic_map_10(&1),
      &LogisticMap.logistic_map_10_pelemay(&1),
      300_000
    )
  end

  bench "PelemayFp and Pelemay with chunk size 600000 (1cores even)" do
    [{"list", list}] = :ets.lookup(:my_table, "list")

    PelemayFp.map_chunk(
      list,
      &LogisticMap.logistic_map_10(&1),
      &LogisticMap.logistic_map_10_pelemay(&1),
      600_000
    )
  end

  bench "Stream" do
    [{"list", list}] = :ets.lookup(:my_table, "list")

    list
    |> Stream.map(&LogisticMap.logistic_map_10(&1))
    |> Stream.run()
  end

  bench "Task.async_stream" do
    [{"list", list}] = :ets.lookup(:my_table, "list")

    list
    |> Task.async_stream(&LogisticMap.logistic_map_10(&1))
    |> Enum.to_list()
  end
end

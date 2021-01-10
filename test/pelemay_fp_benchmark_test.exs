defmodule PelemayFpBenchmarkTest do
  use ExUnit.Case
  doctest PelemayFpBenchmark

  test "greets the world" do
    assert PelemayFpBenchmark.hello() == :world
  end

  test "test PelemayFp and Pelemay" do
    assert Enum.map(1..100000, &LogisticMap.logistic_map_10(&1)) == PelemayFp.map_chunk(1..100000, &LogisticMap.logistic_map_10(&1), &LogisticMap.logistic_map_10_pelemay(&1))
  end
end

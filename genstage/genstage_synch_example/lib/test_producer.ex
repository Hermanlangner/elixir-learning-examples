# Define a function to produce and collect results for 100 numbers
defmodule TestProducer do
  def run_test do
    Enum.map(1..500, fn i ->
      Task.async(fn ->
        result = GenstageExample.Producer.produce_number(i)
        {i, result}
      end)
    end)
    |> Enum.map(&Task.await(&1, 50000))
  end
end

# Run the test
# results = TestProducer.run_test()

# Print the results
# Enum.each(results, fn {input, result} ->
#  IO.puts("Input: #{input}, Result: #{result}")
# end)

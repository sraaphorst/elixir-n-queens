#!/usr/bin/env elixir
# By Sebastian Raaphorst, 2025.
# Solving the n-queens problem using Elixir for practice.

defmodule NQueens do
  @spec solve_n_queens(integer) :: [[integer]]
  def solve_n_queens(n) do
    solve(n, 0, [], [])
  end

  @spec solve(integer, integer, [integer], [[integer]]) :: [[integer]]
  defp solve(_, row, _, solutions) when row < 0, do: solutions
  defp solve(n, n, board, solutions), do: [board | solutions]
  defp solve(n, row, board, solutions) do
    0..(n-1)
    |> Enum.reduce(solutions, fn col, acc ->
      if is_valid?(board, row, col) do
        solve(n, row + 1, [col | board], acc)
      else
        acc
      end
    end)
  end

  # Note that since we are building the boards in reverse, we must reverse
  # the boards to get the proper indices using with_index.
  @spec is_valid?([integer], integer, integer) :: boolean
  defp is_valid?(board, row, col) do
    board
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.all?(
      fn {existing_col, existing_row} ->
        existing_col != col and abs(existing_col - col) != abs(existing_row - row)
      end
    )
  end

  def print_board(board) do
    n = board |> length
    board
    |> Enum.each(fn row ->
      IO.puts(Enum.map(0..n-1, &(if &1 == row, do: "Q", else: ".")))
    end)
  end
end

# Parse the command line arguments, using a default value of 8.
n = case (System.argv |> List.first) do
  nil -> 8
  str -> {num, _} = str |> Integer.parse ; num
end

n
|> NQueens.solve_n_queens
|> Enum.with_index
|> Enum.each(fn {board, idx} ->
  IO.puts "Solution ##{idx+1}:"
  NQueens.print_board(board)
  IO.puts ""
end)

System.halt 0

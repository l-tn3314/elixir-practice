defmodule Practice.Factor do
  # returns [], no prime factors for x < 2, for numbers less than first prime
  def factor(x), do: factor_help(x, 2, [])

  defp factor_help(x, cur_num, factors) when cur_num > x, do: factors
  defp factor_help(x, cur_num, factors) do
    if rem(x, cur_num) == 0 do
      factor_help(div(x, cur_num), cur_num, factors ++ [cur_num])
    else 
      factor_help(x, cur_num + 1, factors)
    end
  end
end

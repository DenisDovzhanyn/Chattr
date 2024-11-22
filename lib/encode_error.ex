defmodule EncodeError do
  def encode({error, reason}) do

    reduced = Enum.reduce elem(reason, 1), %{error: elem(reason,0)}, fn {k,v}, acc ->
      Map.put(acc,k,to_string(v))
    end

    %{error: error, reason: reduced}
  end


end

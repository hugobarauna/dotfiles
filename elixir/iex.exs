import_if_available(Ecto.Query, only: [from: 2])
import_if_available(Ecto.Changeset)
IEx.configure(auto_reload: true)

defmodule Utils do
  @moduledoc """
  Helper utilities for IEx sessions.
  """

  @doc """
  Starts :observer, loading required OTP applications if needed.

  ## Example

      iex> Utils.observer()
      :ok
  """
  def observer do
    case :code.where_is_file(~c"observer.app") do
      :non_existing ->
        erlang_lib = Path.join([:code.root_dir(), "lib"])

        for app <- ~w(observer wx et) do
          case Path.wildcard("#{erlang_lib}/#{app}-*/ebin") do
            [path] -> :code.add_pathz(~c"#{path}")
            _ -> :ok
          end
        end

      _ ->
        :ok
    end

    :observer.start()
  end
end

#!/usr/bin/env elixir

path =
  case System.argv() do
    [path] ->
      path

    _ ->
      IO.puts("Usage: ./formatmd.exs [path]")
      System.halt(1)
  end

content = File.read!(path)

content =
  Regex.replace(~r/```elixir\n(.*?)\n```/, content, fn _match, code ->
    code = Code.format_string!(code)
    ["```elixir\n", code, "\n```"]
  end)

File.write!(path, content)

[
  import_deps: [:ecto, :phoenix, :absinthe, :stream_data, :grpc],
  inputs: ["*.{ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"]
]

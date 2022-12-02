defmodule Sandbox.SnippyCrab do
  use Rustler, otp_app: :sandbox, crate: "snippy_crab"

  # When your NIF is loaded, it will override this function.
  def add(_a, _b), do: :erlang.nif_error(:nif_not_loaded)

  @spec crop_and_grayscale(
          binary(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer(),
          non_neg_integer()
        ) :: binary()
  def crop_and_grayscale(_image, _x, _y, _width, _height), do: :erlang.nif_error(:nif_not_loaded)
end

defmodule Sandbox.UtilsTest do
  use Sandbox.DataCase
  use ExUnitProperties

  alias Sandbox.Utils

  property "returns valid nanoseconds integer and trailing string" do
    assert {123_000_000, "foo"} = Utils.parse_nanoseconds("123foo")
    assert {1, ""} = Utils.parse_nanoseconds("000000001")

    # Generator that generates strings of 1 to 9 digits.
    nanos_prefix_gen = string(?0..?9, min_length: 1, max_length: 9)

    check all nanos <- nanos_prefix_gen,
              rest <- string(:printable),
              string = nanos <> rest do
      assert {parsed_nanos, ^rest} = Utils.parse_nanoseconds(string)
      assert parsed_nanos in 0..999_999_999
    end
  end
end

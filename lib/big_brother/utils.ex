defmodule BigBrother.Utils do
  @moduledoc """
  Several utils functions for this app.
  """

  def get_keywords(options, defaults) do
    options = Keyword.merge(defaults, options)
    Enum.map Keyword.keys(defaults), &(options[&1])
  end
end

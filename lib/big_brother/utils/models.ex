defmodule BigBrother.Utils.Models do
  @moduledoc """
  Several model utils functions for this app.
  """

  def normalize_text_fields(changeset, [], _), do: changeset
  def normalize_text_fields(changeset, [field | fields], opts) do
    changeset
    |> normalize_text_field(field, opts)
    |> normalize_text_fields(fields, opts)
  end
  defp normalize_text_field(changeset, _, []) do
    changeset
  end
  defp normalize_text_field(changeset, field, methods) do
    value = Ecto.Changeset.get_field(changeset, field)
    changeset
    |> Ecto.Changeset.cast(%{field => text_field_normalizations(value, methods)}, [field])
  end
  defp text_field_normalizations(value, []) do
    value
  end
  defp text_field_normalizations(value, [method | methods]) do
    value
    |> text_field_normalization(method)
    |> text_field_normalizations(methods)
  end
  defp text_field_normalization(nil, :coalesce), do: ""
  defp text_field_normalization(value, :coalesce), do: value
  defp text_field_normalization(value, :trim) do
    String.trim value
  end
  defp text_field_normalization(value, :upcase) do
    String.upcase value
  end
  defp text_field_normalization(value, :downcase) do
    String.downcase value
  end
  defp text_field_normalization(value, :capitalize) do
    String.capitalize value
  end
  defp text_field_normalization(value, :single_spaces) do
    Regex.replace(~r/\s{2,}/, value, " ")
  end
end

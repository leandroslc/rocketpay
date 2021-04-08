defmodule RocketpayWeb.ErrorView do
  use RocketpayWeb, :view

  alias RocketpayWeb.ErrorHelpers
  alias Ecto.Changeset

  def render("400.json" = template, %{result: %Changeset{} = changeset}) do
    template
    |> render_error(get_errors(changeset))
  end

  def render("400.json" = template, %{result: message}) do
    template
    |> render_error(message)
  end

  def render("401.json" = template, %{result: message}) do
    template
    |> render_error(message)
  end

  def template_not_found(template, _assigns) do
    %{errors: %{detail: Phoenix.Controller.status_message_from_template(template)}}
  end

  defp render_error(template, message) do
    %{errors:
      %{
        detail: Phoenix.Controller.status_message_from_template(template),
        message: message
      }
    }
  end

  defp get_errors(changeset) do
    Changeset.traverse_errors(changeset, fn {msg, opts} ->
      ErrorHelpers.translate_error({msg, opts})
    end)
  end
end

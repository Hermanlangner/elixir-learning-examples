defmodule SimulationsWeb.StabilityDiagnosticsLive do
  use SimulationsWeb, :live_view
  alias Phoenix.LiveView.JS

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(page_title: "Stability Diagnostics", theme: "light")}
  end

  @impl Phoenix.LiveView
  def handle_event("toggle_theme", _params, socket) do
    new_theme = if socket.assigns.theme == "light", do: "dark", else: "light"
    {:noreply, assign(socket, theme: new_theme)}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end
end

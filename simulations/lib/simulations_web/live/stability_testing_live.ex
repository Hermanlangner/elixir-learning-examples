defmodule SimulationsWeb.StabilityTestingLive do
  use SimulationsWeb, :live_view
  alias Phoenix.LiveView.JS
  require Logger

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    # Get current chaos engineering status
    # ChaosEngineering.status()
    {chaos_enabled, chaos_intensity} = {false, 10}

    # Ensure intensity is within valid range (1-10)
    valid_intensity =
      cond do
        # Default to middle value if nil
        is_nil(chaos_intensity) -> 5
        # Default to middle if too low
        chaos_intensity < 1 -> 5
        # Default to middle if too high
        chaos_intensity > 10 -> 5
        # Use if valid
        true -> chaos_intensity
      end

    if connected?(socket) do
      # Subscribe to chaos events
      #  ChaosEngineering.subscribe()
    end

    # Load saved logs from local storage via a callback hook
    # Initial setup - debug panel is hidden by default
    {:ok,
     socket
     |> assign(
       page_title: "Stability Testing",
       theme: "light",
       logs: [],
       panel_open: false,
       log_filter: "all",
       debug_enabled: true,
       chaos_enabled: chaos_enabled,
       chaos_intensity: valid_intensity
     )}
  end

  @impl Phoenix.LiveView
  def handle_event("initialize_with_saved_logs", %{"logs" => logs}, socket) do
    # This event is triggered by the JavaScript hook to load saved logs
    parsed_logs = Jason.decode!(logs, keys: :atoms)
    {:noreply, assign(socket, logs: parsed_logs)}
  end

  @impl Phoenix.LiveView
  def handle_event("toggle_debug_mode", _params, socket) do
    # Toggle debug mode on/off
    {:noreply, assign(socket, debug_enabled: !socket.assigns.debug_enabled)}
  end

  @impl Phoenix.LiveView
  def handle_event("toggle_chaos", _params, socket) do
    # Toggle chaos engineering mode
    if socket.assigns.chaos_enabled do
      # ChaosEngineering.disable()

      # Log that chaos mode was disabled
      timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second) |> to_string()
      log_entry = %{type: "info", message: "#{timestamp} - INFO: Chaos Engineering mode disabled"}
      logs = [log_entry | socket.assigns.logs]

      socket =
        socket
        |> assign(chaos_enabled: false)
        |> assign(logs: logs)
        |> push_event("save_logs", %{logs: logs})

      {:noreply, socket}
    else
      # Ensure intensity is within valid range (1-10)
      intensity =
        cond do
          # Default to middle if too low
          socket.assigns.chaos_intensity < 1 -> 5
          # Default to middle if too high
          socket.assigns.chaos_intensity > 10 -> 5
          true -> socket.assigns.chaos_intensity
        end

      # ChaosEngineering.enable(intensity)

      # Log that chaos mode was enabled with intensity
      timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second) |> to_string()

      log_entry = %{
        type: "warning",
        message:
          "#{timestamp} - WARNING: Chaos Engineering mode enabled (intensity: #{intensity})"
      }

      logs = [log_entry | socket.assigns.logs]

      socket =
        socket
        |> assign(chaos_enabled: true)
        |> assign(chaos_intensity: intensity)
        |> assign(logs: logs)
        |> push_event("save_logs", %{logs: logs})

      {:noreply, socket}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("update_chaos_intensity", params, socket) do
    value = params["intensity"]

    intensity =
      case value do
        # Default to middle value if nil
        nil ->
          5

        # Default to middle value if empty string
        "" ->
          5

        val ->
          i = String.to_integer(val)
          # Ensure intensity is within allowed range (1-10)
          cond do
            i < 1 -> 1
            i > 10 -> 10
            true -> i
          end
      end

    # If chaos is enabled, update the running intensity
    if socket.assigns.chaos_enabled do
      ChaosEngineering.disable()
      ChaosEngineering.enable(intensity)

      # Log that intensity was changed
      timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second) |> to_string()

      log_entry = %{
        type: "info",
        message: "#{timestamp} - INFO: Chaos intensity updated to #{intensity}"
      }

      logs = [log_entry | socket.assigns.logs]

      socket =
        socket
        |> assign(chaos_intensity: intensity)
        |> assign(logs: logs)
        |> push_event("save_logs", %{logs: logs})

      {:noreply, socket}
    else
      {:noreply, assign(socket, chaos_intensity: intensity)}
    end
  end

  @impl Phoenix.LiveView
  def handle_event("trigger_immediate_chaos", %{"type" => type}, socket) do
    chaos_type = String.to_existing_atom(type)

    # Spawn a process to avoid crashing the LiveView process
    spawn(fn ->
      try do
        ChaosEngineering.trigger_crash(chaos_type)
      rescue
        e ->
          # This is expected to fail, so we just log it
          Logger.error("Triggered chaos error (#{type}): #{inspect(e)}")
      end
    end)

    # Log that a manual chaos event was triggered
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second) |> to_string()

    log_entry = %{
      type: "error",
      message: "#{timestamp} - ERROR: Manual chaos event triggered (#{type})"
    }

    logs = [log_entry | socket.assigns.logs]

    socket =
      socket
      |> assign(logs: logs)
      |> push_event("save_logs", %{logs: logs})

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("set_log_filter", %{"filter" => filter}, socket) do
    {:noreply, assign(socket, log_filter: filter)}
  end

  @impl Phoenix.LiveView
  def handle_event("toggle_floating_panel", _params, socket) do
    {:noreply, assign(socket, panel_open: !socket.assigns.panel_open)}
  end

  @impl Phoenix.LiveView
  def handle_event("toggle_theme", _params, socket) do
    new_theme = if socket.assigns.theme == "light", do: "dark", else: "light"
    {:noreply, assign(socket, theme: new_theme)}
  end

  @impl Phoenix.LiveView
  def handle_event("simulate_crash", _params, socket) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second) |> to_string()

    error_log =
      "#{timestamp} - ERROR: Process crashed with error: FUNCTION_CLAUSE in handle_event/3"

    logs = [%{type: "error", message: error_log} | socket.assigns.logs]

    # Auto-panel opening disabled as requested
    # Instead, push an event to save the logs to localStorage
    socket =
      socket
      |> assign(logs: logs)
      |> push_event("save_logs", %{logs: logs})

    # Commented out auto-opening code - can be re-enabled if needed in the future
    # if socket.assigns.auto_open_on_errors do
    #   {:noreply, assign(socket, panel_open: true)}
    # else
    #   {:noreply, socket}
    # end

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("simulate_session_refresh", _params, socket) do
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second) |> to_string()
    session_log = "#{timestamp} - INFO: Session refreshed successfully"

    logs = [%{type: "success", message: session_log} | socket.assigns.logs]

    # Auto-panel opening disabled as requested
    # Instead, push an event to save the logs to localStorage
    socket =
      socket
      |> assign(logs: logs)
      |> push_event("save_logs", %{logs: logs})

    # Commented out auto-opening code - can be re-enabled if needed in the future
    # if socket.assigns.auto_open_on_success do
    #   {:noreply, assign(socket, panel_open: true)}
    # else
    #   {:noreply, socket}
    # end

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("log_system_event", %{"type" => type, "message" => message} = params, socket) do
    # Log system events like view mount, page refresh, etc.
    log_entry = %{type: type, message: message}
    logs = [log_entry | socket.assigns.logs]

    # Save logs to localStorage but don't auto-open panel
    socket =
      socket
      |> assign(logs: logs)
      |> push_event("save_logs", %{logs: logs})

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("clear_logs", _params, socket) do
    # Close the panel when logs are cleared and save empty logs state
    socket =
      socket
      |> assign(logs: [], panel_open: false)
      |> push_event("save_logs", %{logs: []})

    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
  end

  @impl Phoenix.LiveView
  def handle_info({:chaos_event, event_type, details}, socket) do
    # This callback handles chaos events from the GenServer
    # Log the chaos event that happened
    timestamp = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second) |> to_string()

    {type, message} =
      case event_type do
        :slow_response ->
          {"warning",
           "#{timestamp} - WARNING: Chaos event - Slow response detected (#{details}ms)"}

        :minor_error ->
          {"error", "#{timestamp} - ERROR: Chaos event - Minor error occurred (#{details})"}

        :process_crash ->
          {"error",
           "#{timestamp} - ERROR: Chaos event - Process crash detected (PID: #{details})"}

        :server_overload ->
          {"warning",
           "#{timestamp} - WARNING: Chaos event - Server overload simulation (#{details} processes)"}

        :enabled ->
          {"warning", "#{timestamp} - WARNING: Chaos engine activated with intensity #{details}"}

        :disabled ->
          {"info", "#{timestamp} - INFO: Chaos engine deactivated"}

        :tick ->
          {"info", "#{timestamp} - INFO: Chaos engine tick (intensity: #{details})"}

        _ ->
          {"info", "#{timestamp} - INFO: Unknown chaos event occurred (#{inspect(event_type)})"}
      end

    log_entry = %{type: type, message: message}
    logs = [log_entry | socket.assigns.logs]

    socket =
      socket
      |> assign(logs: logs)
      |> push_event("save_logs", %{logs: logs})

    {:noreply, socket}
  end
end

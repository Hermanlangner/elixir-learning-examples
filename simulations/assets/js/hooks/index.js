// Error Simulator Hook for testing
const ErrorSimulatorHook = {
  mounted() {
    this.el.addEventListener("click", e => {
      switch (this.el.dataset.errorType) {
        case "crash":
          // Directly show an error notification
          window.toastManager.error(`
            <strong>LiveView Error</strong>
            <p>Process crashed with error: FUNCTION_CLAUSE in handle_event/3</p>
            <p class="text-sm mt-1">The application will continue to function.</p>
          `);

          // Also dispatch a custom event to simulate server crash handling
          window.dispatchEvent(new CustomEvent("phx:error", {
            detail: {
              reason: "process_crash"
            }
          }));
          break;
        case "session":
          // Simulate a session refresh
          window.sessionManager.handleSessionRefresh();
          break;
      }
    });
  }
};

// Debug Console Hook for managing logs in localStorage
const DebugConsoleHook = {
  mounted() {
    // Define storage key for logs
    this.storageKey = 'simulations_tools_debug_logs';

    // Expose global control methods for console access
    window.debugConsole = {
      enable: () => {
        this.pushEvent('toggle_debug_mode', {});
        console.log('Debug console enabled. Use window.debugConsole methods to control it.');
      },
      disable: () => {
        this.pushEvent('toggle_debug_mode', {});
        console.log('Debug console disabled.');
      },
      clear: () => {
        this.pushEvent('clear_logs', {});
        console.log('Debug logs cleared.');
      },
      toggle: () => {
        this.pushEvent('toggle_floating_panel', {});
      }
    };

    // Add page lifecycle tracking
    this.setupPageLifecycleTracking();

    // Load saved logs from localStorage on mount
    this.loadLogsFromStorage();

    // Listen for log update events
    this.handleEvent('save_logs', (payload) => {
      this.saveLogsToStorage(payload.logs);
    });

    // Log view mount event
    const timestamp = new Date().toISOString();
    this.pushEvent('log_system_event', {
      type: 'info',
      event: 'view_mounted',
      timestamp: timestamp,
      message: `${timestamp} - INFO: View mounted`
    });

    // Show instructions in console
    console.log(
      '%c[Debug Console]%c Type %cwindow.debugConsole.enable()%c to enable the debug console.',
      'color: #3B82F6; font-weight: bold;',
      'color: inherit;',
      'color: #10B981; font-weight: bold;',
      'color: inherit;'
    );
  },

  setupPageLifecycleTracking() {
    // Track page refresh/reload events
    let isReloading = false;

    // Before unload - mark that we're reloading
    window.addEventListener('beforeunload', () => {
      isReloading = true;
      // No need to log here as it likely won't be processed before page unload
    });

    // When page becomes visible again after being hidden
    document.addEventListener('visibilitychange', () => {
      if (document.visibilityState === 'visible') {
        // If we were previously marked as reloading, log the page refresh
        if (isReloading) {
          const timestamp = new Date().toISOString();
          this.pushEvent('log_system_event', {
            type: 'info',
            event: 'page_refreshed',
            timestamp: timestamp,
            message: `${timestamp} - INFO: Page refreshed`
          });
          isReloading = false;
        }
      }
    });

    // Handle navigation and LiveView page changes
    window.addEventListener('phx:page-loading-stop', (event) => {
      // This fires when LiveView navigation completes
      const timestamp = new Date().toISOString();
      this.pushEvent('log_system_event', {
        type: 'info',
        event: 'page_loaded',
        timestamp: timestamp,
        message: `${timestamp} - INFO: LiveView page loaded`
      });
    });

    // Track LiveView connection status
    window.addEventListener('phx:disconnect', () => {
      const timestamp = new Date().toISOString();
      // Store this locally since we can't push events when disconnected
      this._disconnectTime = timestamp;
      // We'll log this when connection is restored
    });

    window.addEventListener('phx:connected', () => {
      const timestamp = new Date().toISOString();
      const disconnectTime = this._disconnectTime || 'unknown time';

      this.pushEvent('log_system_event', {
        type: 'warning',
        event: 'connection_restored',
        timestamp: timestamp,
        message: `${timestamp} - WARNING: LiveView connection restored (disconnected at ${disconnectTime})`
      });

      // Clear disconnect timestamp
      this._disconnectTime = null;
    });
  },

  loadLogsFromStorage() {
    try {
      const savedLogs = localStorage.getItem(this.storageKey);
      if (savedLogs) {
        this.pushEvent('initialize_with_saved_logs', { logs: savedLogs });
      }
    } catch (error) {
      console.error('Error loading debug logs from localStorage:', error);
    }
  },

  saveLogsToStorage(logs) {
    try {
      localStorage.setItem(this.storageKey, JSON.stringify(logs));
    } catch (error) {
      console.error('Error saving debug logs to localStorage:', error);
    }
  }
};

export default {
  ErrorSimulator: ErrorSimulatorHook,
  DebugConsoleHook
};

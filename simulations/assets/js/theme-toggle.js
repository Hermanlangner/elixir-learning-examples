// assets/js/theme-toggle.js

// Theme management and toggle functionality
(function () {
  // User theme preference in localStorage
  const THEME_KEY = 'simulations-theme-preference';

  // Function to determine user's preferred theme
  function getPreferredTheme() {
    // Check localStorage first
    const storedTheme = localStorage.getItem(THEME_KEY);
    if (storedTheme) {
      return storedTheme;
    }

    // Fallback to system preference
    return window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
  }

  // Function to set the theme
  function setTheme(theme) {
    if (theme === 'dark') {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }

    // Store preference
    localStorage.setItem(THEME_KEY, theme);

    // Update icons and text
    updateThemeUI();
  }

  // Function to update all theme-related UI elements
  function updateThemeUI() {
    const isDarkMode = document.documentElement.classList.contains('dark');

    // Update theme toggle icons
    const elements = {
      'icon-sun': document.getElementById('icon-sun'),
      'icon-moon': document.getElementById('icon-moon'),
      'mobile-icon-sun': document.getElementById('mobile-icon-sun'),
      'mobile-icon-moon': document.getElementById('mobile-icon-moon'),
      'theme-text': document.getElementById('theme-text')
    };

    // Update the visibility of the sun/moon icons
    if (isDarkMode) {
      if (elements['icon-sun']) elements['icon-sun'].classList.remove('hidden');
      if (elements['icon-moon']) elements['icon-moon'].classList.add('hidden');
      if (elements['mobile-icon-sun']) elements['mobile-icon-sun'].classList.remove('hidden');
      if (elements['mobile-icon-moon']) elements['mobile-icon-moon'].classList.add('hidden');
      if (elements['theme-text']) elements['theme-text'].textContent = 'Switch to Light Mode';
    } else {
      if (elements['icon-sun']) elements['icon-sun'].classList.add('hidden');
      if (elements['icon-moon']) elements['icon-moon'].classList.remove('hidden');
      if (elements['mobile-icon-sun']) elements['mobile-icon-sun'].classList.add('hidden');
      if (elements['mobile-icon-moon']) elements['mobile-icon-moon'].classList.remove('hidden');
      if (elements['theme-text']) elements['theme-text'].textContent = 'Switch to Dark Mode';
    }
  }

  // Function to toggle the theme
  function toggleTheme() {
    const currentTheme = document.documentElement.classList.contains('dark') ? 'dark' : 'light';
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    setTheme(newTheme);
  }

  // Set up event listeners once the DOM is fully loaded
  function initTheme() {
    // Set the initial theme
    setTheme(getPreferredTheme());

    // Add event listeners for theme toggle buttons
    const toggleButtons = ['theme-toggle', 'mobile-theme-toggle'];

    toggleButtons.forEach(buttonId => {
      const button = document.getElementById(buttonId);
      if (button) {
        button.addEventListener('click', toggleTheme);
      }
    });

    // Listen for system preference changes
    const mediaQuery = window.matchMedia('(prefers-color-scheme: dark)');
    mediaQuery.addEventListener('change', e => {
      // Only update if user hasn't set a preference
      if (!localStorage.getItem(THEME_KEY)) {
        setTheme(e.matches ? 'dark' : 'light');
      }
    });
  }

  // Run once the DOM is loaded
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initTheme);
  } else {
    initTheme();
  }
})();

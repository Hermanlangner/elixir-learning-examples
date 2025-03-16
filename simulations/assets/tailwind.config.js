// See the Tailwind configuration guide for advanced usage
// https://tailwindcss.com/docs/configuration

const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

const colors = require('tailwindcss/colors')

module.exports = {
  darkMode: 'class',
  content: [
    "./js/**/*.js",
    "../lib/simulations_web.ex",
    "../lib/simulations_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eef2ff',
          100: '#e0e7ff',
          200: '#c7d2fe',
          300: '#a5b4fc',
          400: '#818cf8',
          500: '#6366f1',
          600: '#4f46e5',
          700: '#4338ca',
          800: '#3730a3',
          900: '#312e81',
          950: '#1e1b4b',
        },
        secondary: {
          50: '#f0f9ff',
          100: '#e0f2fe',
          200: '#bae6fd',
          300: '#7dd3fc',
          400: '#38bdf8',
          500: '#0ea5e9',
          600: '#0284c7',
          700: '#0369a1',
          800: '#075985',
          900: '#0c4a6e',
          950: '#082f49',
        },
        success: {
          50: '#f0fdf4',
          100: '#dcfce7',
          200: '#bbf7d0',
          300: '#86efac',
          400: '#4ade80',
          500: '#22c55e',
          600: '#16a34a',
          700: '#15803d',
          800: '#166534',
          900: '#14532d',
          950: '#052e16',
        },
        warning: {
          50: '#fffbeb',
          100: '#fef3c7',
          200: '#fde68a',
          300: '#fcd34d',
          400: '#fbbf24',
          500: '#f59e0b',
          600: '#d97706',
          700: '#b45309',
          800: '#92400e',
          900: '#78350f',
          950: '#451a03',
        },
        danger: {
          50: '#fef2f2',
          100: '#fee2e2',
          200: '#fecaca',
          300: '#fca5a5',
          400: '#f87171',
          500: '#ef4444',
          600: '#dc2626',
          700: '#b91c1c',
          800: '#991b1b',
          900: '#7f1d1d',
          950: '#450a0a',
        },
        surface: {
          light: {
            bg: '#ffffff',
            bgSubtle: '#f9fafb',
            bgMuted: '#f3f4f6',
            border: '#e5e7eb',
            borderHover: '#d1d5db',
            text: '#111827',
            textMuted: '#6b7280',
            textSubtle: '#9ca3af',
          },
          dark: {
            bg: '#1f2937',
            bgSubtle: '#111827',
            bgMuted: '#374151',
            border: '#4b5563',
            borderHover: '#6b7280',
            text: '#f9fafb',
            textMuted: '#9ca3af',
            textSubtle: '#6b7280',
          }
        },
      },
      fontFamily: {
        'sans': ['Inter', 'ui-sans-serif', 'system-ui', '-apple-system', 'BlinkMacSystemFont', 'Segoe UI', 'Roboto', 'Helvetica Neue', 'Arial', 'Noto Sans', 'sans-serif', 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji'],
      },
      boxShadow: {
        'subtle': '0 1px 2px 0 rgba(0, 0, 0, 0.05)',
        'floating': '0 2px 4px 0 rgba(0, 0, 0, 0.05), 0 4px 6px -1px rgba(0, 0, 0, 0.07)',
        'card': '0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px -1px rgba(0, 0, 0, 0.1)',
        'card-hover': '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.1)',
      },
      typography: (theme) => ({
        DEFAULT: {
          css: {
            '--tw-prose-body': theme('colors.gray.700'),
            '--tw-prose-headings': theme('colors.gray.900'),
            '--tw-prose-lead': theme('colors.gray.600'),
            '--tw-prose-links': theme('colors.primary.600'),
            '--tw-prose-bold': theme('colors.gray.900'),
            '--tw-prose-counters': theme('colors.gray.500'),
            '--tw-prose-bullets': theme('colors.gray.300'),
            '--tw-prose-hr': theme('colors.gray.200'),
            '--tw-prose-quotes': theme('colors.gray.900'),
            '--tw-prose-quote-borders': theme('colors.gray.200'),
            '--tw-prose-captions': theme('colors.gray.500'),
            '--tw-prose-code': theme('colors.gray.900'),
            '--tw-prose-pre-code': theme('colors.gray.200'),
            '--tw-prose-pre-bg': theme('colors.gray.800'),
            '--tw-prose-th-borders': theme('colors.gray.200'),
            '--tw-prose-td-borders': theme('colors.gray.200'),
          },
        },
        dark: {
          css: {
            '--tw-prose-body': theme('colors.gray.300'),
            '--tw-prose-headings': theme('colors.gray.100'),
            '--tw-prose-lead': theme('colors.gray.400'),
            '--tw-prose-links': theme('colors.primary.400'),
            '--tw-prose-bold': theme('colors.gray.100'),
            '--tw-prose-counters': theme('colors.gray.400'),
            '--tw-prose-bullets': theme('colors.gray.600'),
            '--tw-prose-hr': theme('colors.gray.700'),
            '--tw-prose-quotes': theme('colors.gray.100'),
            '--tw-prose-quote-borders': theme('colors.gray.700'),
            '--tw-prose-captions': theme('colors.gray.400'),
            '--tw-prose-code': theme('colors.gray.100'),
            '--tw-prose-pre-code': theme('colors.gray.300'),
            '--tw-prose-pre-bg': theme('colors.gray.900'),
            '--tw-prose-th-borders': theme('colors.gray.600'),
            '--tw-prose-td-borders': theme('colors.gray.700'),
          },
        },
      }),
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    require('@tailwindcss/typography'),

    // Adds custom components for data display
    plugin(function ({ addComponents, theme }) {
      const dataComponents = {
        '.data-table': {
          borderCollapse: 'separate',
          borderSpacing: '0',
          width: '100%',
          borderRadius: theme('borderRadius.lg'),
          overflow: 'hidden',
          boxShadow: theme('boxShadow.card'),

          '& thead th': {
            backgroundColor: theme('colors.gray.50'),
            color: theme('colors.gray.700'),
            fontSize: theme('fontSize.sm'),
            fontWeight: theme('fontWeight.semibold'),
            padding: `${theme('spacing.3')} ${theme('spacing.4')}`,
            textAlign: 'left',
            borderBottom: `1px solid ${theme('colors.gray.200')}`,
            position: 'sticky',
            top: 0,
            zIndex: 10,
          },

          '& tbody tr': {
            '&:hover': {
              backgroundColor: theme('colors.gray.50'),
            },
            '&:not(:last-child)': {
              borderBottom: `1px solid ${theme('colors.gray.100')}`,
            }
          },

          '& tbody td': {
            padding: `${theme('spacing.3')} ${theme('spacing.4')}`,
            fontSize: theme('fontSize.sm'),
            color: theme('colors.gray.700'),
          },

          '.dark &': {
            boxShadow: 'none',
            border: `1px solid ${theme('colors.gray.700')}`,

            '& thead th': {
              backgroundColor: theme('colors.gray.800'),
              color: theme('colors.gray.200'),
              borderBottom: `1px solid ${theme('colors.gray.700')}`,
            },

            '& tbody tr': {
              '&:hover': {
                backgroundColor: theme('colors.gray.800'),
              },
              '&:not(:last-child)': {
                borderBottom: `1px solid ${theme('colors.gray.700')}`,
              }
            },

            '& tbody td': {
              color: theme('colors.gray.300'),
            },
          }
        },

        '.card': {
          backgroundColor: theme('colors.white'),
          borderRadius: theme('borderRadius.lg'),
          boxShadow: theme('boxShadow.card'),
          overflow: 'hidden',

          '.dark &': {
            backgroundColor: theme('colors.gray.800'),
            boxShadow: 'none',
            border: `1px solid ${theme('colors.gray.700')}`,
          }
        },
      }

      addComponents(dataComponents)
    }),

    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({ addVariant }) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({ addVariant }) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function ({ matchComponents, theme }) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = { name, fullPath: path.join(iconsDir, dir, file) }
        })
      })
      matchComponents({
        "hero": ({ name, fullPath }) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) {
            size = theme("spacing.5")
          } else if (name.endsWith("-micro")) {
            size = theme("spacing.4")
          }
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size
          }
        }
      }, { values })
    })
  ]
}

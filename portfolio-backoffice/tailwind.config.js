/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./components/**/*.{js,vue,ts}",
    "./layouts/**/*.vue",
    "./pages/**/*.vue",
    "./plugins/**/*.{js,ts}",
    "./app.vue",
    "./error.vue",
  ],
  theme: {
    colors: {
      transparent: "transparent",
      "white": "#ffffff",
      "background": "#303030",
      "violet": {
        DEFAULT: "#a78bfa",
        dark: "#8b5cf6",
      },
      "pink": {
        DEFAULT: "#f472b6",
        dark: "#ec4899",
      },
      "indigo": {
        DEFAULT: "#818cf8",
        dark: "#6366f1",
      },
    }
  },
  plugins: [
      require('@tailwindcss/forms'),
  ],
}
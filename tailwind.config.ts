import type { Config } from "tailwindcss";

const config: Config = {
  darkMode: "class",
  content: [
    "./app/**/*.{ts,tsx}",
    "./components/**/*.{ts,tsx}",
    "./styles/**/*.css",
  ],
  theme: {
    extend: {
      colors: {
        mirror: {
          black: "#0a0a0a",
          glass: "rgba(255, 255, 255, 0.05)",
          neon: "#00f0ff",
          accent: "#ff00f0",
          surface: "#1a1a1a",
        },
      },
      fontFamily: {
        sans: ["Inter", "sans-serif"],
        mono: ["JetBrains Mono", "monospace"],
      },
      animation: {
        "mirror-pulse": "mirror-pulse 2s ease-in-out infinite",
        "neon-glow": "neon-glow 1.5s ease-in-out infinite alternate",
      },
      keyframes: {
        "mirror-pulse": {
          "0%, 100%": { opacity: "1" },
          "50%": { opacity: "0.7" },
        },
        "neon-glow": {
          "0%": { textShadow: "0 0 10px #00f0ff, 0 0 20px #00f0ff" },
          "100%": { textShadow: "0 0 20px #00f0ff, 0 0 30px #00f0ff, 0 0 40px #00f0ff" },
        },
      },
    },
  },
  plugins: [],
};
export default config;

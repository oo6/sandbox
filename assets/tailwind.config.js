module.exports = {
  mode: "jit",
  purge: ["../lib/**/*.ex", "../lib/**/*.heex", "./js/**/*.ts"],
  darkMode: "media",
  theme: {
    extend: {
      // https://github.com/ConnorAtherton/loaders.css/blob/dee8aabed3adbfb121b931a42e3ebc233fafdd68/loaders.css#L9-L52
      keyframes: {
        scale: {
          "0%": { transform: "scale(1)", opacity: 1 },
          "45%": { transform: "scale(0.1)", opacity: 0.7 },
          "80%": { transform: "scale(1)", opacity: 1 },
        },
      },
      animation: {
        "ball-pulse-0":
          "scale 0.75s -0.24s infinite cubic-bezier(0.2, 0.68, 0.18, 1.08)",
        "ball-pulse-1":
          "scale 0.75s -0.12s infinite cubic-bezier(0.2, 0.68, 0.18, 1.08)",
        "ball-pulse-2":
          "scale 0.75s 0s infinite cubic-bezier(0.2, 0.68, 0.18, 1.08)",
      },
    },
  },
  variants: {
    extend: {},
  },
  plugins: [],
};

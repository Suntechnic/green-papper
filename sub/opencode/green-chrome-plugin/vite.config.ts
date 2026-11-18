import { defineConfig } from "vite"
import solid from "vite-plugin-solid"
import { gui } from "@opencode/plugin/gui/vite"

export default defineConfig({
  plugins: [solid(), gui()],
})

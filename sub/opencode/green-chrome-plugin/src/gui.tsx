import { Plugin } from "@opencode/plugin/gui"
import { Theme } from "@opencode/plugin/gui"
import theme from "../../green-chrome-desktop.json"

export default Plugin.define({
  setup(ctx) {
    ctx.add(Theme, theme)
  },
})

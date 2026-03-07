local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Appearance
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 17
config.line_height = 1.1
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.tab_max_width = 32
config.hide_tab_bar_if_only_one_tab = false
config.window_padding = { left = 10, right = 10, top = 8, bottom = 8 }

-- VSCode Dark+ with green accents
local accent = "#23D18B"
local accent_dim = "#1a9e6a"

config.colors = {
  foreground = "#D4D4D4",
  background = "#1E1E1E",
  cursor_bg = "#23D18B",
  cursor_border = "#23D18B",
  cursor_fg = "#1E1E1E",
  selection_bg = "#1e4d34",
  selection_fg = "#FFFFFF",
  ansi = {
    "#1E1E1E", -- black
    "#CD3131", -- red
    "#0DBC79", -- green
    "#C2B86A", -- yellow
    "#2472C8", -- blue
    "#BC3FBC", -- magenta
    "#11A8CD", -- cyan
    "#D4D4D4", -- white
  },
  brights = {
    "#555555", -- bright black
    "#F14C4C", -- bright red
    "#23D18B", -- bright green  ← accent
    "#D7C97A", -- bright yellow
    "#3B8EEA", -- bright blue
    "#D670D6", -- bright magenta
    "#29B8DB", -- bright cyan
    "#FFFFFF",  -- bright white
  },
}

-- Window effects
config.window_background_opacity = 0.93
config.macos_window_background_blur = 12

-- Tab bar
config.colors.tab_bar = {
  background = "#141414",
  active_tab   = { bg_color = "#1E1E1E", fg_color = "#FFFFFF", intensity = "Bold" },
  inactive_tab = { bg_color = "#141414", fg_color = "#4A4A4A" },
  inactive_tab_hover = { bg_color = "#1A1A1A", fg_color = "#999999" },
  new_tab       = { bg_color = "#141414", fg_color = "#4A4A4A" },
  new_tab_hover = { bg_color = "#1A1A1A", fg_color = "#999999" },
}

-- Tab titles with green accent on active
wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
  local title = tab.active_pane.title
  if tab.tab_title and #tab.tab_title > 0 then
    title = tab.tab_title
  end

  local max = max_width - 6
  if #title > max then
    title = wezterm.truncate_right(title, max) .. "…"
  end

  local index = tab.tab_index + 1

  if tab.is_active then
    return {
      { Background = { Color = "#1E1E1E" } },
      { Foreground = { Color = accent } },
      { Text = "  " .. index .. " " },
      { Foreground = { Color = "#FFFFFF" } },
      { Text = title .. "  " },
    }
  else
    return {
      { Background = { Color = "#141414" } },
      { Foreground = { Color = "#3a3a3a" } },
      { Text = "  " .. index .. " " },
      { Foreground = { Color = hover and "#999999" or "#4A4A4A" } },
      { Text = title .. "  " },
    }
  end
end)

-- Keybindings
local act = wezterm.action
config.keys = {
  { key = "n", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "q", mods = "CTRL", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "H", mods = "SHIFT", action = act.ActivateTabRelative(-1) },
  { key = "L", mods = "SHIFT", action = act.ActivateTabRelative(1) },
}

return config

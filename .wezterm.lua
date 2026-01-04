local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action


-- Base theme
config.color_scheme = 'Tokyo Night'

-- Transparency + blur
config.window_background_opacity = 0.95
config.macos_window_background_blur = 10

-- UI and tabs
config.window_decorations = "RESIZE"
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = false

-- Fonts
config.font = wezterm.font_with_fallback {
  'JetBrainsMono Nerd Font',
  'FiraCode Nerd Font',
  'SF Mono',
  'Menlo',
}
config.font_size = 15.5
config.line_height = 1.2
config.adjust_window_size_when_changing_font_size = false

-- Window padding
config.window_padding = {
  left = 8,
  right = 0,
  top = 20,
  bottom = 8,
}

config.colors = {
  cursor_bg = "#9ece6a", 
  cursor_border = "#9ece6a",
  selection_bg = "#28344a",
  selection_fg = "#c0caf5",

  tab_bar = {
    background = "#1a1b26",

    active_tab = {
      bg_color = "#9ece6a",
      fg_color = "#1a1b26",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#c3cfb8",
      fg_color = "#7c7f93",
    },
    inactive_tab_hover = {
      bg_color = "#334155",
      fg_color = "#9ece6a",
      italic = true,
    },
    new_tab = {
      bg_color = "#1a1b26",
      fg_color = "#9ece6a",
    },
    new_tab_hover = {
      bg_color = "#334155",
      fg_color = "#bb9af7",
      italic = true,
    },
  },
  ansi = {
    "#15161E", -- black
    "#f7768e", -- red
    "#9ece6a", -- green
    "#e0af68", -- yellow
    "#7aa2f7", -- blue
    "#bb9af7", -- magenta
    "#7dcfff", -- cyan
    "#a9b1d6", -- white
  },
  brights = {
    "#414868", -- bright black
    "#f7768e", -- bright red
    "#9ece6a", -- brighter green
    "#e0af68", -- bright yellow
    "#7aa2f7", -- bright blue
    "#bb9af7", -- bright magenta
    "#7dcfff", -- bright cyan
    "#c0caf5", -- bright white
  },
}

-- Cursor style
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600
config.force_reverse_video_cursor = false

-- Scroll and performance
config.enable_scroll_bar = false
config.scrollback_lines = 7000

-- height and length of terminal on startup

config.initial_rows = 20
config.initial_cols = 85

-- Cycle tabs 
config.keys = {
  { key = '[', mods = 'CMD', action = act.ActivateTabRelative(-1) },
  { key = ']', mods = 'CMD', action = act.ActivateTabRelative(1) },
  { key = 'n', mods = 'CMD', action = act.SpawnTab('CurrentPaneDomain') },
  { key = 'q', mods = 'CMD', action = act.CloseCurrentTab { confirm = true } },
}

return config

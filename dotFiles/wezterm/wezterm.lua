local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

local function maximize(cmd)
  -- local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end

wezterm.on('gui-startup', maximize)
wezterm.on('window-maximize', function (window, _)
  window:maximize()
  -- window:toast_notification('maximize', 'Window maximize', nil, 2000)
end)
wezterm.on('window-restore', function (window, _)
  window:restore()
  -- window:toast_notification('restore', 'Window restored', nil, 2000)
end)
-- Toggling seems more complicated, where can we save state?
wezterm.on('toggle-maximize', function (window, _)
  local maxed = window['maxed']
  window:toast_notification('toggle-maximize', 'maximized: ' .. maxed, nil, 2000)
  if maxed then
    window['maxed'] = false
    window:restore()
  else
    window['maxed'] = true
    window:maximize()
  end
  -- window:toast_notification('maximize', 'Window maximize', nil, 2000)
end)

local color_schemes = {
  'Classic Dark (base16)',
  'Catppuccin Mocha',
  'Solarized Dark Higher Contrast',
  'GruvboxDark',
  'Tomorrow Night',
  'terafox',
  'Banana Blueberry',
  'OneHalfDark',
  'Ubuntu'
}

local current_color_index = 1

wezterm.on('change-colorscheme', function (window, pane)
  if current_color_index < #color_schemes then
    current_color_index = current_color_index + 1
  else
    current_color_index = 1
  end
  -- config.color_scheme = color_schemes[current_color_index]
  local overrides = window:get_config_overrides() or {}
  overrides.color_scheme = color_schemes[current_color_index]
  overrides.force_reverse_video_cursor = true
  window:set_config_overrides(overrides)
  window:toast_notification('Color Scheme changed', color_schemes[current_color_index], nil, 5000)
end)

-- config.color_scheme = 'Gruvbox Dark'
config.color_scheme = color_schemes[current_color_index]
-- Font Configuration
config.font_size = 14
-- Window Opacity
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.92
config.window_padding = {
  top = "1cell",
  bottom = "1pt",
}
-- No tabs
config.hide_tab_bar_if_only_one_tab = true
-- config.enable_tab_bar = false
-- Cursor config
config.default_cursor_style = "SteadyBlock"
config.force_reverse_video_cursor = true
-- config.cursor_thickness = "3px"
-- config.cursor_blinkrate = 800

-- Keybindings
config.keys = {
  {
    key = "|",
    mods = 'SUPER',
    action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
  },
  {
    key = "_",
    mods = 'SUPER',
    action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  },
  {
    key = "Enter",
    mods = 'SUPER',
    action = wezterm.action.EmitEvent('window-maximize')
  },
  {
    key = "Enter",
    mods = 'SUPER|SHIFT',
    action = wezterm.action.EmitEvent('window-restore')
  },
  {
    key = "Enter",
    mods = 'SUPER|CTRL',
    action = wezterm.action.EmitEvent('toggle-maximize') -- Not working needs to be reviewed
  },
  {
    key = 't',
    mods = 'SUPER|CTRL',
    action = wezterm.action.EmitEvent('change-colorscheme') -- Not working needs to be reviewed
  }
}

-- and finally, return the configuration to wezterm
return config

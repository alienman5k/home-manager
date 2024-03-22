-- See https://wezfurlong.org/wezterm/

-- Add config folder to watchlist for config reloads.
local wezterm = require 'wezterm';
wezterm.add_to_config_reload_watch_list(wezterm.config_dir)

local config = {}
local defaults = {
  maximized = false,
  opacity = 0.92,
  blur = 15,
}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

local function window_maximize(cmd)
  -- local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
  local _, _, window = wezterm.mux.spawn_window(cmd or {})
  window:gui_window():maximize()
  defaults.maximized = true
end

wezterm.on('gui-startup', window_maximize)
wezterm.on('toggle-maximize', function (window, _)
  wezterm.log_info("Maximized", defaults.maximized)
  if not defaults.maximized then
    window:maximize()
    defaults.maximized = true
  else
    window:restore()
    defaults.maximized = false
  end
  -- window:toast_notification('maximize', 'Window maximize', nil, 2000)
end)

local function toggle_opacity(window)
  local overrides = window:get_config_overrides() or {}
  -- window:toast_notification('toggle-transparency', overrides.window_background_opacity, nil, 2000)
  wezterm.log_info(overrides)
  if defaults.opacity == 1.0 then
    defaults.opacity = 0.92
    defaults.blur = 15
  else
    defaults.opacity = 1.0
    defaults.blur = 0
  end
  overrides.window_background_opacity = defaults.opacity
  overrides.macos_window_background_blur = defaults.blur
  window:set_config_overrides(overrides)
end
wezterm.on('toggle-opacity', toggle_opacity)

local function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end
  -- Otherwise, use the title from the active pane
  -- in that tab
  return tab_info.active_pane.title
end
wezterm.on(
  'format-tab-title',
  -- function(tab, tabs, panes, cfg, hover, max_width)
  function(tab)
    local title = tab_title(tab)
    -- local title = "active"
    if tab.is_active then
      return {
        { Background = { Color = '#4b0f87' } },
        -- { Foreground = { Color = '#FFFFFF' } },
        -- { Text = ' ' .. title .. ' ' .. wezterm.nerdfonts.pl_right_hard_divider },
        { Text = string.format(" %s: %s ", tab.tab_id + 1, title) },
      }
    elseif tab.is_inactive then
      return {
        { Background = { Color = '#333333' } },
        -- { Foreground = { Color = '#FFFFFF' } },
        -- { Text = ' ' .. title .. ' ' .. wezterm.nerdfonts.pl_right_hard_divider },
        { Text = string.format(" %s ", title) },
      }
    end
    return title
  end
)

-- wezterm.on('toggle-colorscheme', function (window, _)
--   if defaults.current_color_index < #defaults.color_schemes then
--     defaults.current_color_index = defaults.current_color_index + 1
--   else
--     defaults.current_color_index = 1
--   end
--   -- config.color_scheme = color_schemes[current_color_index]
--   local overrides = window:get_config_overrides() or {}
--   overrides.color_scheme = defaults.color_schemes[defaults.current_color_index]
--   overrides.force_reverse_video_cursor = true
--   wezterm.log_info(overrides)
--   window:set_config_overrides(overrides)
--   window:toast_notification('Color Scheme changed', defaults.color_schemes[defaults.current_color_index], nil, 5000)
-- end)

wezterm.on('switch-colorscheme', function (window, pane)
  local choices = {}
  for name, _ in pairs(wezterm.get_builtin_color_schemes()) do
    table.insert(choices, {id = name, label = name})
  end
  -- wezterm.log_info(choices)
  window:perform_action(wezterm.action.InputSelector {
    action = wezterm.action_callback(function(window, pane, id, label)
      if not id and not label then
        wezterm.log_info 'cancelled'
      else
        wezterm.log_info('Theme selected: ', id)
        local overrides = window:get_config_overrides() or {}
        overrides.color_scheme = id
        overrides.force_reverse_video_cursor = true
        window:set_config_overrides(overrides)
      end
    end),
    title = 'Switch colorscheme',
    choices = choices
  }, pane)
end)

local set_tab_title = wezterm.action.PromptInputLine {
  description = 'Tab name: ',
  action = wezterm.action_callback(function (window, pane, line)
    if line then
      window:active_tab():set_title(line)
    end
  end),
}

-- wezterm.on('window-focus-changed', function(window, _)
--   wezterm.log_info(
--     'the focus state of ',
--     window:window_id(),
--     ' changed to ',
--     window:is_focused()
--   )
--   toggle_opacity(window)
-- end)

-- config.color_scheme = 'Gruvbox Dark'
-- config.color_scheme = 'Catppuccin Mocha'
config.color_scheme = 'TomorrowNight (Gogh)'
-- Font Configuration
config.font_size = 14
config.adjust_window_size_when_changing_font_size = false
-- Window Opacity
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.92
config.macos_window_background_blur = 15
config.window_padding = {
  top = "1cell",
  bottom = "1pt",
}
config.initial_cols = 120
config.initial_rows = 40
-- No tabs
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
-- config.enable_tab_bar = false
-- Cursor config
config.default_cursor_style = "SteadyBlock"
config.force_reverse_video_cursor = true
-- config.cursor_thickness = "3px"
-- config.cursor_blinkrate = 800

config.window_frame = {
  font = wezterm.font { family = 'Fira Mono', weight = 'Bold' },
  font_size = 12,
  -- active_titlebar_bg = '#683478',
  -- inactive_titlebar_bg = '#333333',
}

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
    action = wezterm.action.EmitEvent('toggle-maximize')
  },
  {
    key = "Enter",
    mods = 'CTRL',
    action = wezterm.action.EmitEvent('toggle-maximize')
  },
  -- {
  --   key = 't',
  --   mods = 'SUPER|CTRL',
  --   action = wezterm.action.EmitEvent('toggle-colorscheme')
  -- },
  {
    key = 's',
    mods = 'SUPER|CTRL',
    action = wezterm.action.EmitEvent('switch-colorscheme')
  },
  {
    key = 'e',
    mods = 'SUPER|CTRL',
    action = set_tab_title
  },
  {
    key = 'o',
    mods = 'SUPER|CTRL',
    action = wezterm.action.EmitEvent('toggle-opacity')
  }
}

-- config.debug_key_events = true

-- and finally, return the configuration to wezterm
return config

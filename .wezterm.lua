-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This is where you actually apply your config choices
local config = {}

-- Use the config builder for better error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- 1. Configure the Launch Menu
-- This adds items to the menu when you right-click the "+" button
config.launch_menu = {
  {
    label = 'PowerShell',
    args = { 'pwsh.exe', '-NoLogo' },
  },
  {
    label = 'Fedora',
    args = { 'wsl.exe', '--distribution', 'FedoraTest', '--cd', '~' }, 
  },
}

-- 2. (Optional) Set Default Shell
-- If you want WezTerm to always open WSL by default:
config.default_domain = 'WSL:FedoraTest' 
-- Or for PowerShell:
-- config.default_prog = { 'pwsh.exe', '-NoLogo' }

-- 3. (Optional) Keyboard Shortcuts
-- Press Alt+1 for PowerShell, Alt+2 for WSL
config.keys = {
    {
        key = '1',
        mods = 'ALT',
        action = wezterm.action.SpawnCommandInNewTab {
            args = { [[C:\Program Files\PowerShell\7-preview\pwsh.exe]], '-NoLogo' },
            domain = { DomainName = 'local' },
        },
    },
    {
        key = '2',
        mods = 'ALT',
        action = wezterm.action.SpawnCommandInNewTab {
            domain = { DomainName = 'WSL:FedoraTest' },
        },
    },
    {
        key = 't',
        mods = 'ALT',
        action = wezterm.action_callback(function(window, pane)
            -- Get the current overrides
            local overrides = window:get_config_overrides() or {}

            -- Logic: If tabs are currently enabled in the override, disable them.
            -- If they are disabled (or nil), enable them.
            if overrides.enable_tab_bar then
                -- HIDE: Go back to pure borderless
                overrides.enable_tab_bar = false
                overrides.window_decorations = "NONE"
            else
                -- SHOW: Enable tabs + the drag/button area
                overrides.enable_tab_bar = true
                overrides.window_decorations = "RESIZE"
            end

            -- Apply the changes
            window:set_config_overrides(overrides)
        end),
    },
}

-- For example, changing the color scheme:
config.color_scheme = 'Hacktober'
config.font = wezterm.font 'Hack Nerd Font'
config.font_size = 12.0

config.enable_tab_bar = false
config.use_fancy_tab_bar = true
--config.window_decorations = 'NONE'
--config.colors = {
--  tab_bar = {
--    background = '#000000', 
--    active_tab = {
--      bg_color = '#333333',
--      fg_color = '#c0c0c0',
--    },
--  },
--}
config.window_padding = {
  left = 15,
  right = 15,
  top = 15,
  bottom = 15,
}

local mux = wezterm.mux

wezterm.on('gui-startup', function(cmd)
  -- allow `wezterm start -- args` to affect what we spawn
  local tab, pane, window = mux.spawn_window(cmd or {})
  
  -- Use this line for "Immersive" Fullscreen (hides the taskbar/dock)
  --window:gui_window():toggle_fullscreen()
  
  local gui_window = window:gui_window()
  
  -- OR, use this line for "Maximized" (keeps the taskbar/dock visible)
   gui_window:maximize()
   gui_window:set_config_overrides({
     window_decorations = "NONE",
   })
end)

-- and finally, return the configuration to wezterm
return config

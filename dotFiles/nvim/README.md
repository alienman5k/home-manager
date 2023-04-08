# Neovim Personal Configuration
This file describes the my personal configuration for Neovim, this includes explaining the directory structure, the plugins I use and a small information about those plugins and how I use and configure them.

## Directory structure
- ./lua/user/core/ -> Where Neovim core configuration goes. This is configuration that does not depend on any plugin and should work without having any
- ./lua/user/plugins/lazyvim.lua -> Package manager installation and initial configuration, here we set up where lazyvim will look to install additional plugins.
- ./lua/user/plugins/lazy/ -> Install additional plugins, lazy will ready each file inside this directory and install/load them.
- ./lua/user/plugins/setup/ -> Setup required for some plugins, typically called when a plugin requires big blocks of setup

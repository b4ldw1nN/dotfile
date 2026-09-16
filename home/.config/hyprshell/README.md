# Hyprshell Custom CSS & Theme Guide

You can customize any aspect of your shell live by editing `style.css` in this directory.
All CSS changes hot-reload in real-time (within 500ms) without restarting `hyprshell`.

## 🎨 Color Variables
- `@surface_color`: Primary dark panel background (`#18181b`)
- `@bg_color`: Outer background color (`#121214`)
- `@fg_color`: Default text foreground color (`#e2e8f0`)
- `@accent_color`: Accent highlight color (`#94a3b8`)
- `@hover_color`: Hover background state (`#242429`)
- `@module_bg`: Container background (`#1e1e24`)

## 🏷️ Core Class Names
- `.bar-container`: Top Dynamic Island capsule container
- `.bar-has-panel`: Bar container state when a popup panel is open
- `.panel-content`: Floating attached popup panel card
- `.bar-left-box`: Left bar section (workspaces & launcher)
- `.bar-right-box`: Right bar section (tray icons & power)
- `.bar-launcher-btn`: Launcher / Control center buttons
- `.bar-dash-btn`: Center clock / dashboard pill button
- `.bar-systray-box`: Status tray icon container

## 📦 Module & Popup Panels
- `.wifi-popup`: WiFi manager popup panel
- `.wifi-network-item`: Individual WiFi network item row
- `.volume-popup`: Volume & Microphone slider popup
- `.notification-card`: Individual notification card
- `.dashboard-window`: Full Dashboard window
- `.control-center-window`: Control Center grid popup
- `.lockscreen-window`: Lockscreen overlay
- `.power-window`: Power menu popup

## 🔍 Live GTK Inspector
To inspect any element on your screen and view its exact CSS properties live:
Run `GTK_DEBUG=interactive hyprshell` in your terminal!

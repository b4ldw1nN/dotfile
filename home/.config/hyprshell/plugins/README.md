# Hyprshell Script Plugins

Every executable file in this directory becomes a widget button on the bar
(right side, next to the systray). Plugins are plain scripts - bash, python,
anything executable.

## Status output
Run your script **with no arguments** and print the widget state:

- One-shot mode: print once and exit; hyprshell re-runs it every
  `plugins.poll_interval_secs` (settings.json, default 5s).
- Streaming mode: keep running and print one line per update for instant,
  event-driven changes.

Each line is either plain text or JSON:

```json
{"icon": "󰀄", "text": "label", "tooltip": "hover text", "class": "my-state", "interval": 10}
```

All fields are optional (`text` alone works too). `class` adds a CSS class to
the widget button (style it in style.css); `interval` overrides the poll
delay for that plugin.

## Click action
Run your script **with the argument `click`** to handle clicks. Afterwards
the status instance restarts immediately, so toggle scripts stay in sync.

## Example
See `example-clock` in this directory.

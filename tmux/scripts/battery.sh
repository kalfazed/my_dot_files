#!/usr/bin/env bash
# tmux status segment: battery level with icon.
# Prints nothing on machines without a system battery (e.g. desktops),
# so the segment disappears automatically.
#   Linux: /sys/class/power_supply/BAT*  (override dir with $BATTERY_SYSFS for testing)
#   macOS: pmset -g batt

capacity=""
status=""

if [ "$(uname -s)" = "Darwin" ]; then
  info=$(pmset -g batt 2>/dev/null | grep -Eo '[0-9]+%; [a-zA-Z ]+' | head -1)
  capacity=${info%%%*}
  case "$info" in
    *"; charging"*|*"; charged"*|*"; finishing charge"*) status="Charging" ;;
    *) status="Discharging" ;;
  esac
  pmset -g batt 2>/dev/null | grep -q "AC Power" && [ "$status" != "Charging" ] && status="Full"
else
  sysfs=${BATTERY_SYSFS:-/sys/class/power_supply}
  for bat in "$sysfs"/BAT* "$sysfs"/CMB* "$sysfs"/battery; do
    [ -r "$bat/capacity" ] || continue
    # ignore peripheral batteries (mouse / keyboard)
    [ "$(cat "$bat/scope" 2>/dev/null)" = "Device" ] && continue
    capacity=$(cat "$bat/capacity")
    status=$(cat "$bat/status" 2>/dev/null)
    break
  done
fi

[ -z "$capacity" ] && exit 0

# icon by level
if   [ "$capacity" -ge 95 ]; then icon="󰁹"
elif [ "$capacity" -ge 85 ]; then icon="󰂂"
elif [ "$capacity" -ge 75 ]; then icon="󰂁"
elif [ "$capacity" -ge 65 ]; then icon="󰂀"
elif [ "$capacity" -ge 55 ]; then icon="󰁿"
elif [ "$capacity" -ge 45 ]; then icon="󰁾"
elif [ "$capacity" -ge 35 ]; then icon="󰁽"
elif [ "$capacity" -ge 25 ]; then icon="󰁼"
elif [ "$capacity" -ge 15 ]; then icon="󰁻"
elif [ "$capacity" -ge 8 ];  then icon="󰁺"
else                              icon="󰂃"
fi

# color by level: green / yellow / orange / red (blinking when critical)
if   [ "$capacity" -ge 60 ]; then color="colour114"
elif [ "$capacity" -ge 30 ]; then color="colour221"
elif [ "$capacity" -ge 15 ]; then color="colour208"
else                              color="colour196,blink"
fi

case "$status" in
  Charging)            icon="󰂄"; color="colour81" ;;
  Full|"Not charging") icon="󰚥";     color="colour114" ;;
esac

bg="colour238"
printf '#[fg=%s]#[fg=%s,bg=%s,bold] %s %s%% #[nobold]' "$bg" "$color" "$bg" "$icon" "$capacity"

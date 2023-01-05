#!/bin/dash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors
. ~/.config/chadwm/scripts/bar_themes/dracula

cpu() {
  # cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)
  cpu_val=$(iostat -c | awk '/^ / {sum=$1+$2+$3+$4+$5} END {print sum"%"}')
  printf "^c$black^ ^b$green^ CPU%"
  printf "^c$white^ ^b$grey^ $cpu_val "
}

temp() {
  temp_value=$(sensors | awk '/^edge/ {print $2 }' | tr -d +)
  printf "^c$black^ ^b$green^ TEMP"
  printf "^c$white^ ^b$grey^ $temp_value"
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT1/capacity)"
  printf "^c$blue^   $get_capacity"
}

brightness() {
  printf "^c$red^   "
  printf "^c$red^%.0f\n" $(brightnessctl -m | cut -d, -f4 | tr -d %)
}

mem() {
  printf "^c$blue^^b$black^  "
  printf "^c$blue^ $(free -h | awk '/^Mem/ { print $3"/"$2 }' | sed s/i//g)"
}

wlan() {
# run "conky -c $HOME/.config/chadwm/conky/system-overview"
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^ ^b$blue^ 󰤨 ^d^%s" " ^c$blue^Connected" ;;
	down) printf "^c$black^ ^b$blue^ 󰤭 ^d^%s" " ^c$blue^Disconnected" ;;
	esac
}

clock() {
	printf "^c$black^ ^b$darkblue^  "
	printf "^c$black^^b$blue^ $(date '+%d/%m/%y %r')  "
}


while true; do

  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] 
  interval=$((interval + 1))

  sleep 2 && xsetroot -name " $(battery) $(brightness) $(cpu) $(temp) $(mem) $(wlan) $(clock)"
done

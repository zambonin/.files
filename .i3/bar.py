from i3pystatus import Status
from i3pystatus.updates import pacman

status = Status(standalone=True)

status.register("clock", 
	format="%A, %d de %B, %H:%M")

status.register("backlight",
	format="☀ {percentage}%",
	backlight="intel_backlight",
	interval=1)

status.register("battery",
    format="{remaining:%H:%M:%S} {status} {percentage:.0f}%",
    charging_color="#ffff00",
    status={
        "DIS": "⚡",
        "CHR": "⚇",
        "FULL": "☻",
    },)

status.register("weather",
	location_code="BRXX0035",
	colorize=True,
	interval=30,
	on_leftclick=["chromium google.com/#q=weather+forecast", 1])

status.register("network",
    interface="wlp3s0",
    format_up="W: {quality:03.0f}% @ {essid}",
    format_down="W: ↓",
    dynamic_color=True)

status.register("network",
    interface="enp2s0",
    format_up="E: {v4cidr}",
    format_down="E: ↓")

status.register("pulseaudio",
    format="♫ {volume}%",
    format_muted="♪ {volume}%",
    color_muted="#ffff00",
    step=1)

status.register("updates",
   	format = "{count} updates",
    format_no_updates = "",
    backends = [pacman.Pacman()],
    on_leftclick=["terminator -e \"sudo pacman -Syyu --noconfirm\"", 1],
    interval=900)

status.run()

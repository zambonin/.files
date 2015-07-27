from i3pystatus import Status
from i3pystatus.updates import pacman

status = Status(standalone=True)

status.register("clock", 
	format="%A, %d de %B, %H:%M")

status.register("weather",
	location_code="BRXX0035",
	interval=30,
	colorize=True,
	on_leftclick=["exec chromium weather.com/weather/today/l/BRXX0035", 1])

status.register("battery",
    format="{remaining:%H:%M:%S} {status} {percentage:.0f}%",
    charging_color="#ffffff",
    status={
        "DIS": "⚡",
        "CHR": "⚇",
        "FULL": "☻",
    })

status.register("network",
    interface="wlp3s0",
    format_up="{essid} | {quality}%",
    format_down="W: ↓",
    dynamic_color=True,
    on_rightclick=None,
    on_upscroll=None,
    on_downscroll=None)

status.register("updates",
   	format = "🔧  {count}",
    format_no_updates = "",
    backends = [pacman.Pacman()],
    on_leftclick=["terminator -e \"sudo pacman -Syyu --noconfirm\"", 1],
    interval=900)

status.register("pulseaudio",
    unmuted="🔊",
    muted="🔈",
    format="{muted}  {volume}",
    color_muted="#ffffff",
    step=1)

status.register("backlight",
	format="☀ {percentage}%",
	backlight="intel_backlight",
	interval=1)

status.run()

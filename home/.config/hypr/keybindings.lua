-- Standalone Hyprland keybindings.

local mainMod = "SUPER"

local editor = "nvim"
local terminal = "kitty"
local fileManager = "dolphin"
local browser = "firefox"
local calculator = "qalculate-gtk" -- change to gnome-calculator, "kitty -e qalc", etc.

local SCRIPTS = "~/.config/hypr/scripts"

-- Clipboard menu (includes "Clear clipboard history" entry)
local CLIP_MENU = SCRIPTS .. "/clipmenu.sh"
local CLIP_WIPE = "cliphist wipe && wl-copy --clear && notify-send -a Clipboard Clipboard 'History cleared'"

-- Screenshots
-- Full / monitor: saved to ~/Pictures/Screenshots, copied, notification shown.
-- Snip: region -> satty (copy-command set in ~/.config/satty/config.toml).
local SHOT_DIR = "$HOME/Pictures/Screenshots"
local SHOT_FILE = "mkdir -p " .. SHOT_DIR .. " && f=" .. SHOT_DIR .. "/$(date +%F_%H-%M-%S).png"
local SHOT_NOTIFY = ' && wl-copy < "$f" && notify-send -a Screenshot -i "$f" Screenshot \'Saved and copied\''
local SHOT_FULL = SHOT_FILE .. ' && grim "$f"' .. SHOT_NOTIFY
local SHOT_MONITOR = SHOT_FILE
	.. ' && grim -o "$(hyprctl -j monitors | jq -r \'.[] | select(.focused) | .name\')" "$f"'
	.. SHOT_NOTIFY
local SHOT_SNIP = 'grim -g "$(slurp)" - | satty --filename -'

--------------------------
---- WINDOW MANAGEMENT ----
--------------------------

hl.bind(mainMod .. " + Q", hl.dsp.window.close(), { description = "[Window Management] close focused window" })
hl.bind("ALT + F4", hl.dsp.window.close(), { description = "[Window Management] close focused window" })
hl.bind(mainMod .. " + ALT + F4", hl.dsp.window.kill(), { description = "[Window Management] kill focused window" })
hl.bind(mainMod .. " + Delete", hl.dsp.exit(), { description = "[Window Management] kill hyprland session" })
hl.bind(
	mainMod .. " + W",
	hl.dsp.window.float({ action = "toggle" }),
	{ description = "[Window Management] Toggle floating" }
)
hl.bind(mainMod .. " + G", hl.dsp.group.toggle(), { description = "[Window Management] toggle group" })

-- Cycle fullscreen: 0 none -> 1 maximized -> 2 fullscreen -> 0
local function cycle_fullscreen()
	local win = hl.get_active_window()
	if not win then
		return
	end
	local next_state = (tonumber(win.fullscreen) or 0) + 1
	if next_state > 2 then
		next_state = 0
	end
	hl.dispatch(hl.dsp.window.fullscreen_state({ internal = next_state, client = next_state, window = win }))
end
hl.bind("SHIFT + F11", cycle_fullscreen, { description = "[Window Management] cycle fullscreen" })

hl.bind(
	mainMod .. " + L",
	hl.dsp.exec_cmd("loginctl lock-session"),
	{ description = "[Window Management] lock screen" }
)
hl.bind(
	mainMod .. " + SHIFT + F",
	hl.dsp.window.pin(),
	{ description = "[Window Management] toggle pin on focused window" }
)
hl.bind("CONTROL + ALT + Delete", hl.dsp.exec_cmd("wlogout"), { description = "[Window Management] logout menu" })
hl.bind(
	mainMod .. " + CONTROL + B",
	hl.dsp.exec_cmd("pkill -x waybar || waybar"),
	{ description = "[Window Management] toggle waybar" }
)

-- Group Navigation
hl.bind(
	mainMod .. " + CONTROL + H",
	hl.dsp.group.prev(),
	{ description = "[Window Management|Group Navigation] change active group backwards" }
)
hl.bind(
	mainMod .. " + CONTROL + L",
	hl.dsp.group.next(),
	{ description = "[Window Management|Group Navigation] change active group forwards" }
)

-- Change focus
hl.bind(
	mainMod .. " + left",
	hl.dsp.focus({ direction = "left" }),
	{ description = "[Window Management|Change focus] focus left" }
)
hl.bind(
	mainMod .. " + right",
	hl.dsp.focus({ direction = "right" }),
	{ description = "[Window Management|Change focus] focus right" }
)
hl.bind(
	mainMod .. " + up",
	hl.dsp.focus({ direction = "up" }),
	{ description = "[Window Management|Change focus] focus up" }
)
hl.bind(
	mainMod .. " + down",
	hl.dsp.focus({ direction = "down" }),
	{ description = "[Window Management|Change focus] focus down" }
)
hl.bind("ALT + Tab", hl.dsp.layout("cyclenext"), { description = "[Window Management|Change focus] Cycle focus" })

-- Resize Active Window (repeats while held)
hl.bind(
	mainMod .. " + SHIFT + right",
	hl.dsp.window.resize({ x = 30, y = 0, relative = true }),
	{ description = "[Window Management|Resize Active Window] resize window right", repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + left",
	hl.dsp.window.resize({ x = -30, y = 0, relative = true }),
	{ description = "[Window Management|Resize Active Window] resize window left", repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + up",
	hl.dsp.window.resize({ x = 0, y = -30, relative = true }),
	{ description = "[Window Management|Resize Active Window] resize window up", repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + down",
	hl.dsp.window.resize({ x = 0, y = 30, relative = true }),
	{ description = "[Window Management|Resize Active Window] resize window down", repeating = true }
)

-- Move active window: floating uses relative move, tiled uses directional move.
local function move_window(dir, px)
	local delta =
		{ left = { x = -px, y = 0 }, right = { x = px, y = 0 }, up = { x = 0, y = -px }, down = { x = 0, y = px } }
	return function()
		local win = hl.get_active_window()
		if not win then
			return
		end
		if win.floating then
			hl.dispatch(hl.dsp.window.move({ x = delta[dir].x, y = delta[dir].y, relative = true }))
		else
			hl.dispatch(hl.dsp.window.move({ direction = dir }))
		end
	end
end
hl.bind(
	mainMod .. " + SHIFT + CONTROL + left",
	move_window("left", 30),
	{ description = "[Window Management|Move active window] left", repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + CONTROL + right",
	move_window("right", 30),
	{ description = "[Window Management|Move active window] right", repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + CONTROL + up",
	move_window("up", 30),
	{ description = "[Window Management|Move active window] up", repeating = true }
)
hl.bind(
	mainMod .. " + SHIFT + CONTROL + down",
	move_window("down", 30),
	{ description = "[Window Management|Move active window] down", repeating = true }
)

-- Move / Resize with mouse
hl.bind(
	mainMod .. " + mouse:272",
	hl.dsp.window.drag(),
	{ description = "[Window Management|Mouse] hold to move window", mouse = true }
)
hl.bind(
	mainMod .. " + mouse:273",
	hl.dsp.window.resize(),
	{ description = "[Window Management|Mouse] hold to resize window", mouse = true }
)
hl.bind(
	mainMod .. " + Z",
	hl.dsp.window.drag(),
	{ description = "[Window Management|Mouse] hold to move window", mouse = true }
)
hl.bind(
	mainMod .. " + X",
	hl.dsp.window.resize(),
	{ description = "[Window Management|Mouse] hold to resize window", mouse = true }
)

hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"), { description = "[Window Management] toggle split" })

local function dropdown_terminal()
	hl.dispatch(hl.dsp.workspace.toggle_special("dropdown"))
	hl.dispatch(hl.dsp.exec_cmd(terminal .. " --class dropdown"))
end

------------------
---- LAUNCHER ----
------------------

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal), { description = "[Launcher|Apps] terminal emulator" })
hl.bind(mainMod .. " + ALT + T", dropdown_terminal, { description = "[Launcher|Apps] dropdown terminal" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager), { description = "[Launcher|Apps] file explorer" })
hl.bind(
	mainMod .. " + C",
	hl.dsp.exec_cmd(terminal .. " -e " .. editor),
	{ description = "[Launcher|Apps] text editor" }
)
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser), { description = "[Launcher|Apps] web browser" })
hl.bind(
	"CONTROL + SHIFT + Escape",
	hl.dsp.exec_cmd(terminal .. " -e htop"),
	{ description = "[Launcher|Apps] system monitor" }
)
hl.bind("XF86Calculator", hl.dsp.exec_cmd(calculator), { description = "[Launcher|Apps] calculator (Fn + =)" })

-- Rofi menus
hl.bind(
	mainMod .. " + A",
	hl.dsp.exec_cmd("rofi -theme ~/.config/rofi/style_3.rasi -show drun"),
	{ description = "[Launcher|Rofi menus] application finder" }
)
hl.bind(
	mainMod .. " + TAB",
	hl.dsp.exec_cmd("rofi -show window"),
	{ description = "[Launcher|Rofi menus] window switcher" }
)
hl.bind(
	mainMod .. " + SHIFT + E",
	hl.dsp.exec_cmd("rofi -show filebrowser"),
	{ description = "[Launcher|Rofi menus] file finder" }
)
hl.bind(
	mainMod .. " + slash",
	hl.dsp.exec_cmd("hyprctl binds | rofi -dmenu -p 'Keybindings'"),
	{ description = "[Launcher|Rofi menus] keybindings hint" }
)
hl.bind(
	mainMod .. " + comma",
	hl.dsp.exec_cmd("rofi -modi emoji -show emoji"),
	{ description = "[Launcher|Rofi menus] emoji picker" }
)
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(CLIP_MENU), { description = "[Launcher|Rofi menus] clipboard" })
hl.bind(
	mainMod .. " + SHIFT + V",
	hl.dsp.exec_cmd(CLIP_WIPE),
	{ description = "[Launcher|Rofi menus] clear clipboard history" }
)

---------------------------
---- HARDWARE CONTROLS ----
---------------------------

local VOL = SCRIPTS .. "/volumecontrol.sh"

hl.bind("F10", hl.dsp.exec_cmd(VOL .. " m"), { description = "[Hardware Controls|Audio] toggle mute", locked = true })
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd(VOL .. " m"),
	{ description = "[Hardware Controls|Audio] toggle mute", locked = true }
)
hl.bind(
	"F11",
	hl.dsp.exec_cmd(VOL .. " d"),
	{ description = "[Hardware Controls|Audio] volume down", locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(VOL .. " d"),
	{ description = "[Hardware Controls|Audio] volume down", locked = true, repeating = true }
)
hl.bind(
	"F12",
	hl.dsp.exec_cmd(VOL .. " i"),
	{ description = "[Hardware Controls|Audio] volume up", locked = true, repeating = true }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(VOL .. " i"),
	{ description = "[Hardware Controls|Audio] volume up", locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ description = "[Hardware Controls|Audio] un/mute microphone", locked = true }
) -- Media
hl.bind(
	"XF86AudioPlay",
	hl.dsp.exec_cmd("playerctl play-pause"),
	{ description = "[Hardware Controls|Media] play media", locked = true }
)
hl.bind(
	"XF86AudioPause",
	hl.dsp.exec_cmd("playerctl play-pause"),
	{ description = "[Hardware Controls|Media] pause media", locked = true }
)
hl.bind(
	"XF86AudioNext",
	hl.dsp.exec_cmd("playerctl next"),
	{ description = "[Hardware Controls|Media] next media", locked = true }
)
hl.bind(
	"XF86AudioPrev",
	hl.dsp.exec_cmd("playerctl previous"),
	{ description = "[Hardware Controls|Media] previous media", locked = true }
)

-- Brightness (with notification via script)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(SCRIPTS .. "/brightnesscontrol.sh i"),
	{ description = "[Hardware Controls|Brightness] increase brightness", locked = true, repeating = true }
)
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(SCRIPTS .. "/brightnesscontrol.sh d"),
	{ description = "[Hardware Controls|Brightness] decrease brightness", locked = true, repeating = true }
)

-- Sleep key (Fn + Backspace) is handled by systemd-logind (HandleSuspendKey).
-- Not bound here on purpose; binding it would suspend twice.

-- Screen Capture
hl.bind(
	mainMod .. " + SHIFT + P",
	hl.dsp.exec_cmd("hyprpicker -a"),
	{ description = "[Utilities|Screen Capture] color picker" }
)
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(SHOT_SNIP), { description = "[Utilities|Screen Capture] snip screen" })
hl.bind(
	"XF86SelectiveScreenshot",
	hl.dsp.exec_cmd(SHOT_SNIP),
	{ description = "[Utilities|Screen Capture] snip screen (snip key)" }
)
hl.bind(
	mainMod .. " + ALT + P",
	hl.dsp.exec_cmd(SHOT_MONITOR),
	{ description = "[Utilities|Screen Capture] capture focused monitor", locked = true }
)
hl.bind(
	"Print",
	hl.dsp.exec_cmd(SHOT_FULL),
	{ description = "[Utilities|Screen Capture] capture all monitors", locked = true }
)

--------------------
---- WORKSPACES ----
--------------------

for i = 1, 10 do
	local key = i % 10
	hl.bind(
		mainMod .. " + " .. key,
		hl.dsp.focus({ workspace = i }),
		{ description = "[Workspaces|Navigation] navigate to workspace " .. i }
	)
	hl.bind(
		mainMod .. " + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = i, follow = true }),
		{ description = "[Workspaces|Move window] move to workspace " .. i }
	)
	hl.bind(
		mainMod .. " + ALT + " .. key,
		hl.dsp.window.move({ workspace = i, follow = false }),
		{ description = "[Workspaces|Move window silently] move to workspace " .. i .. " (silent)" }
	)
end

hl.bind(
	mainMod .. " + CONTROL + right",
	hl.dsp.focus({ workspace = "r+1" }),
	{ description = "[Workspaces|Relative] next workspace" }
)
hl.bind(
	mainMod .. " + CONTROL + left",
	hl.dsp.focus({ workspace = "r-1" }),
	{ description = "[Workspaces|Relative] previous workspace" }
)
hl.bind(
	mainMod .. " + CONTROL + down",
	hl.dsp.focus({ workspace = "empty" }),
	{ description = "[Workspaces|Navigation] nearest empty workspace" }
)

hl.bind(
	mainMod .. " + CONTROL + ALT + right",
	hl.dsp.window.move({ workspace = "r+1", follow = true }),
	{ description = "[Workspaces] move window to next relative workspace" }
)
hl.bind(
	mainMod .. " + CONTROL + ALT + left",
	hl.dsp.window.move({ workspace = "r-1", follow = true }),
	{ description = "[Workspaces] move window to previous relative workspace" }
)

hl.bind(
	mainMod .. " + mouse_down",
	hl.dsp.focus({ workspace = "e+1" }),
	{ description = "[Workspaces|Navigation] next workspace" }
)
hl.bind(
	mainMod .. " + mouse_up",
	hl.dsp.focus({ workspace = "e-1" }),
	{ description = "[Workspaces|Navigation] previous workspace" }
)

-- Special workspace (scratchpad)
hl.bind(
	mainMod .. " + SHIFT + S",
	hl.dsp.window.move({ workspace = "special", follow = true }),
	{ description = "[Workspaces|Special] move to scratchpad" }
)
hl.bind(
	mainMod .. " + ALT + S",
	hl.dsp.window.move({ workspace = "special", follow = false }),
	{ description = "[Workspaces|Special] move to scratchpad (silent)" }
)
hl.bind(
	mainMod .. " + S",
	hl.dsp.workspace.toggle_special(),
	{ description = "[Workspaces|Special] toggle scratchpad" }
)

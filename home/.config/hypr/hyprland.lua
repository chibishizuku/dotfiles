require("monitors")
require("windowrules")
require("keybindings")

hl.config({
	general = {
		gaps_in = 3,
		gaps_out = 6,
	},
	decoration = {
		rounding = 5,
	},
	misc = {
		disable_hyprland_logo = true,
		force_default_wallpaper = 0,
	},
})

hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("loginctl lock-session"), { locked = true })
------------------
---- MONITORS ----
------------------

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-----------------------
----- PERMISSIONS -----
-----------------------

hl.config({
	ecosystem = {
		enforce_permissions = true,
	},
})

hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpicker", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprlock", "screencopy", "allow")
hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "deny")

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
	hl.exec_cmd("wl-clip-persist --clipboard regular")
	hl.exec_cmd("~/.config/hypr/wallpaper.sh")
	hl.exec_cmd("wl-paste --type text --watch timeout 2 cliphist store")
	hl.exec_cmd("wl-paste --type image --watch timeout 5 cliphist store")
end)

---------------
---- INPUT ----
---------------

hl.config({
	input = {
		kb_layout = "us,tr",
		kb_variant = ",",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		numlock_by_default = true,
		follow_mouse = 1,

		sensitivity = 0,

		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.bind("SUPER + SHIFT + code:201", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

local touchpad = "syna801a:00-06cb:cec6-touchpad"
local touchpadSensitivity = 0.3
local touchpadEnabled = true

local function applyTouchpad()
	hl.device({
		name = touchpad,
		enabled = touchpadEnabled,
		sensitivity = touchpadSensitivity,
		accel_profile = "adaptive",
	})
end

applyTouchpad()

hl.bind("XF86Favorites", function()
	touchpadEnabled = not touchpadEnabled
	applyTouchpad()
	hl.notification.create({
		text = "Touchpad " .. (touchpadEnabled and "enabled" or "disabled"),
		timeout = 1500,
		icon = "ok",
	})
end)

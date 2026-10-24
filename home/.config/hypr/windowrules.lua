-- idle_inhibit rules
hl.window_rule({
	match = { class = "^(.*celluloid.*)$|^(.*mpv.*)$|^(.*vlc.*)$" },
	idle_inhibit = "fullscreen",
})
hl.window_rule({
	match = { class = "^(.*[Ss]potify.*)$" },
	idle_inhibit = "fullscreen",
})
hl.window_rule({
	match = {
		class = "^(.*LibreWolf.*)$|^(.*floorp.*)$|^(.*brave-browser.*)$|^(.*firefox.*)$|^(.*chromium.*)$|^(.*zen.*)$|^(.*vivaldi.*)$",
	},
	idle_inhibit = "fullscreen",
})

-- Picture-in-Picture
hl.window_rule({
	name = "picture_in_picture",
	match = { title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" },
	tag = "+picture-in-picture",
	float = true,
	keep_aspect_ratio = true,
	move = "(monitor_w*0.73) (monitor_h*0.72)",
	size = "(monitor_w*0.25) (monitor_h*0.25)",
	pin = true,
})

-- Opacity: browsers / editors / terminals / file managers
hl.window_rule({ match = { class = "^(firefox)$" }, opacity = "0.90 0.90 1" })
hl.window_rule({ match = { class = "^(brave-browser)$" }, opacity = "0.90 0.90 1" })
hl.window_rule({ match = { class = "^(code-oss)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^([Cc]ode)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(code-url-handler)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(code-insiders-url-handler)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(kitty)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(org.kde.dolphin)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(org.kde.ark)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(nwg-look)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(qt5ct)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(qt6ct)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(kvantummanager)$" }, opacity = "0.80 0.80 1" })
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^(blueman-manager)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^(nm-applet)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^(org.kde.polkit-kde-authentication-agent-1)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^(polkit-gnome-authentication-agent-1)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^(org.freedesktop.impl.portal.desktop.gtk)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^(org.freedesktop.impl.portal.desktop.hyprland)$" }, opacity = "0.80 0.70 1" })
hl.window_rule({ match = { class = "^([Ss]team)$" }, opacity = "0.70 0.70 1" })
hl.window_rule({ match = { class = "^(steamwebhelper)$" }, opacity = "0.70 0.70 1" })
hl.window_rule({ match = { class = "^([Ss]potify)$" }, opacity = "0.70 0.70 1" })
hl.window_rule({ match = { initial_title = "^(Spotify Free)$" }, opacity = "0.70 0.70 1" })
hl.window_rule({ match = { initial_title = "^(Spotify Premium)$" }, opacity = "0.70 0.70 1" })

-- Opacity: misc apps (active inactive only, no fullscreen value in source)
hl.window_rule({ match = { class = "^(com.github.rafostar.Clapper)$" }, opacity = "0.90 0.90" }) -- Clapper-Gtk
hl.window_rule({ match = { class = "^(com.github.tchx84.Flatseal)$" }, opacity = "0.80 0.80" }) -- Flatseal-Gtk
hl.window_rule({ match = { class = "^(hu.kramo.Cartridges)$" }, opacity = "0.80 0.80" }) -- Cartridges-Gtk
hl.window_rule({ match = { class = "^(com.obsproject.Studio)$" }, opacity = "0.80 0.80" }) -- Obs-Qt
hl.window_rule({ match = { class = "^(gnome-boxes)$" }, opacity = "0.80 0.80" }) -- Boxes-Gtk
hl.window_rule({ match = { class = "^(vesktop)$" }, opacity = "0.80 0.80" }) -- Vesktop
hl.window_rule({ match = { class = "^(discord)$" }, opacity = "0.80 0.80" }) -- Discord-Electron
hl.window_rule({ match = { class = "^(WebCord)$" }, opacity = "0.80 0.80" }) -- WebCord-Electron
hl.window_rule({ match = { class = "^(ArmCord)$" }, opacity = "0.80 0.80" }) -- ArmCord-Electron
hl.window_rule({ match = { class = "^(app.drey.Warp)$" }, opacity = "0.80 0.80" }) -- Warp-Gtk
hl.window_rule({ match = { class = "^(net.davidotek.pupgui2)$" }, opacity = "0.80 0.80" }) -- ProtonUp-Qt
hl.window_rule({ match = { class = "^(yad)$" }, opacity = "0.80 0.80" }) -- Protontricks-Gtk
hl.window_rule({ match = { class = "^(Signal)$" }, opacity = "0.80 0.80" }) -- Signal-Gtk
hl.window_rule({ match = { class = "^(io.github.alainm23.planify)$" }, opacity = "0.80 0.80" }) -- planify-Gtk
hl.window_rule({ match = { class = "^(io.gitlab.theevilskeleton.Upscaler)$" }, opacity = "0.80 0.80" }) -- Upscaler-Gtk
hl.window_rule({ match = { class = "^(com.github.unrud.VideoDownloader)$" }, opacity = "0.80 0.80" }) -- VideoDownloader-Gtk
hl.window_rule({ match = { class = "^(io.gitlab.adhami3310.Impression)$" }, opacity = "0.80 0.80" }) -- Impression-Gtk
hl.window_rule({ match = { class = "^(io.missioncenter.MissionCenter)$" }, opacity = "0.80 0.80" }) -- MissionCenter-Gtk
hl.window_rule({ match = { class = "^(io.github.flattool.Warehouse)$" }, opacity = "0.80 0.80" }) -- Warehouse-Gtk

-- Float
hl.window_rule({ match = { class = "^(Signal)$" }, float = true }) -- Signal-Gtk
hl.window_rule({ match = { class = "^(com.github.rafostar.Clapper)$" }, float = true }) -- Clapper-Gtk
hl.window_rule({ match = { class = "^(app.drey.Warp)$" }, float = true }) -- Warp-Gtk
hl.window_rule({ match = { class = "^(net.davidotek.pupgui2)$" }, float = true }) -- ProtonUp-Qt
hl.window_rule({ match = { class = "^(yad)$" }, float = true }) -- Protontricks-Gtk
hl.window_rule({ match = { class = "^(eog)$" }, float = true }) -- Imageviewer-Gtk
hl.window_rule({ match = { class = "^(io.github.alainm23.planify)$" }, float = true }) -- planify-Gtk
hl.window_rule({ match = { class = "^(io.gitlab.theevilskeleton.Upscaler)$" }, float = true }) -- Upscaler-Gtk
hl.window_rule({ match = { class = "^(com.github.unrud.VideoDownloader)$" }, float = true }) -- VideoDownloader-Gtk
hl.window_rule({ match = { class = "^(io.gitlab.adhami3310.Impression)$" }, float = true }) -- Impression-Gtk
hl.window_rule({ match = { class = "^(io.missioncenter.MissionCenter)$" }, float = true }) -- MissionCenter-Gtk
hl.window_rule({ match = { class = "^(org.pulseaudio.pavucontrol)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(blueman-manager)$" }, float = true, center = true })
hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, float = true, center = true })
hl.window_rule({ match = { title = "^(Unlock Database - KeePassXC)$" }, float = true, center = true })
hl.window_rule({
	match = { class = "^(com.gabm.satty)$" },
	float = true,
	size = "(monitor_w*0.7) (monitor_h*0.7)",
	center = true,
})

-- Workaround for JetBrains IDEs dropdowns/popups causing flickering
hl.window_rule({
	match = { class = "^(.*jetbrains.*)$", title = "^(win[0-9]+)$" },
	no_initial_focus = true,
})
hl.layer_rule({ match = { namespace = "waybar" }, blur = true, blur_popups = true, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "rofi" }, blur = true })
hl.layer_rule({ match = { namespace = "rofi" }, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "notifications" }, blur = true })
hl.layer_rule({ match = { namespace = "notifications" }, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, ignore_alpha = 0 })
hl.layer_rule({ match = { namespace = "logout_dialog" }, blur = true })

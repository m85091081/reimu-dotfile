--[[

Powerarrow Darker Awesome WM config 2.0
github.com/copycat-killer

--]]

-- {{{ Required libraries
local gears     = require("gears")
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local naughty   = require("naughty")
local lain      = require("lain")
local vicious = require("vicious")
local cyclefocus = require('cyclefocus')
awful.rules     = require("awful.rules")
require("awful.autofocus")
-- }}}

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors })
end

do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, an error happened!",
        text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart applications
function run_once(cmd)
    findme = cmd
    firstspace = cmd:find(" ")
    if firstspace then
        findme = cmd:sub(0, firstspace-1)
    end
    awful.util.spawn_with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("urxvtd")
run_once("unclutter -root")
-- }}}

-- {{{ Variable definitions

-- beautiful init
beautiful.init(os.getenv("HOME") .. "/.config/awesome/themes/powerarrow-darker/theme.lua")

-- common
modkey     = "Mod4"
altkey     = "Mod1"
terminal   = "termite"
editor     = os.getenv("EDITOR") or "nano" or "vim"
editor_cmd = terminal .. " -e " .. editor

-- user defined
browser    = "firefox"
gui_editor = "gedit"
graphics   = "gimp"

local layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
}

-- }}}
-- quake terminal
local quakeconsole = {}
for s = 1, screen.count() do
    quakeconsole[s] = lain.util.quake({ app = terminal })
end
-- }}}

-- {{{ Tags
tags = {
    names = { "1", "2", "3", "4"},
    layout = { layouts[4], layouts[2], layouts[3], layouts[1] }
}

for s = 1, screen.count() do
    tags[s] = awful.tag(tags.names, s, tags.layout)
end

-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        --	gears.wallpaper.maximized("/home/reimu/Pictures/Wallpapers/img012A4++.png", s, False)
        gears.wallpaper.maximized("/home/reimu/Pictures/Wallpapers/touhou.jpg", s, false)
    end
end
-- }}}

-- {{{Naughty

naughty.config.presets.normal.opacity      = 0.8
naughty.config.presets.low.opacity         = 0.8
naughty.config.presets.critical.opacity    = 0.8
-- }}}
-- {{{ Menu
--
--
require("menu")

myawesomemenu = {
    { "restart", awesome.restart },
    { "quit", awesome.quit }
}

powermenu = {
    { "Logout System", function()
        awful.util.spawn("killall awesome")
    end},
    { "Shutdown System", function()
        awful.util.spawn("shutdown")
    end},
    { "Restart System", function()
        awful.util.spawn("reboot")
    end}
}

mymainmenu = awful.menu({ items = { 
    { "All app", xdgmenu},
    { "Yandex-Browser", function()
        awful.util.spawn("yandex-browser-beta")
    end},
    { "Firefox", function()
        awful.util.spawn("firefox")
    end},
    { "PCManFM", function()
        awful.util.spawn("pcmanfm")
    end},
    { "LilyTerminal", function()
        awful.util.spawn("lilyterm")
    end},
    { "Gedit", function()
        awful.util.spawn("gedit")
    end},
    { "Foobar", function()
        awful.util.spawn("wine '/home/reimu/.wine/drive_c/Program Files (x86)/foobar2000/foobar2000.exe'")
    end},
    {"AwesomeWM", myawesomemenu},
    {"Power", powermenu}
}})

mylauncher = awful.widget.launcher({ image = beautiful.logo, menu = mymainmenu })

-- Menubar configuration
--menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
markup = lain.util.markup
separators = lain.util.separators

-- Textclock
clockicon = wibox.widget.imagebox(beautiful.widget_clock)
--mytextclock = awful.widget.textclock(" %a %d %b  %H:%M")

mytextclock = lain.widgets.abase({
    timeout  = 60,
    cmd      = "date +'%a曜日 %b %d %R'",
    settings = function()
        widget:set_text(" " .. output)
    end
})

-- calendar
lain.widgets.calendar.attach(mytextclock, { font_size = 10 })

-- MEM
memicon = wibox.widget.imagebox(beautiful.widget_mem)
memwidget = lain.widgets.mem({
    settings = function()
        widget:set_text(" " .. mem_now.used .. "MB ")
    end
})

-- CPU
cpuicon = wibox.widget.imagebox(beautiful.widget_cpu)
cpuwidget = lain.widgets.cpu({
    settings = function()
        widget:set_text(" " .. cpu_now.usage .. "% ")
    end
})

-- Volume 
volwidgeticon =  wibox.widget.imagebox(beautiful.widget_vol)
volwidget =  wibox.widget.textbox()
vicious.register(volwidget, vicious.widgets.volume, " $1% ", 2, "Master")

-- Dual Battery
mybattery = wibox.widget.textbox() 
vicious.register(mybattery, vicious.widgets.bat, "$2%", 30, "BAT1")
mybattery2 = wibox.widget.textbox() 
vicious.register(mybattery2, vicious.widgets.bat, " / $2%", 30, "BAT2")
baticon = wibox.widget.imagebox(beautiful.widget_battery)

-- Net
neticon = wibox.widget.imagebox(beautiful.widget_net)
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.wifi, " ${ssid} ", 2, "wlp2s0")

-- Separators
spr = wibox.widget.textbox(' ')
arrl_dl = separators.arrow_left(beautiful.bg_focus, "alpha")
arrl_ld = separators.arrow_left("alpha", beautiful.bg_focus)

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
awful.button({ }, 1, awful.tag.viewonly),
awful.button({ modkey }, 1, awful.client.movetotag),
awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, awful.client.toggletag),
awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
awful.button({ }, 1, function (c)
    if c == client.focus then
        c.minimized = true
    else
        -- Without this, the following
        -- :isvisible() makes no sense
        c.minimized = false
        if not c:isvisible() then
            awful.tag.viewonly(c:tags()[1])
        end
        -- This will also un-minimize
        -- the client, if needed
        client.focus = c
        c:raise()
    end
end),
awful.button({ }, 3, function ()
    if instance then
        instance:hide()
        instance = nil
    else
        instance = awful.menu.clients({ width=250 })
    end
end),
awful.button({ }, 4, function ()
    awful.client.focus.byidx(1)
    if client.focus then client.focus:raise() end
end),
awful.button({ }, 5, function ()
    awful.client.focus.byidx(-1)
    if client.focus then client.focus:raise() end
end))

for s = 1, screen.count() do

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
    awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
    awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })

    -- Widgets that are aligned to the upper left
    local left_layout = wibox.layout.fixed.horizontal()
    --left_layout:add(spr)
    left_layout:add(mylauncher)
    left_layout:add(spr)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    left_layout:add(spr)

    -- Widgets that are aligned to the upper right
    local right_layout_toggle = true
    local function right_layout_add (...)
        local arg = {...}
        if right_layout_toggle then
            right_layout:add(arrl_ld)
            for i, n in pairs(arg) do
                right_layout:add(wibox.widget.background(n ,beautiful.bg_focus))
            end
        else
            right_layout:add(arrl_dl)
            for i, n in pairs(arg) do
                right_layout:add(n)
            end
        end
        right_layout_toggle = not right_layout_toggle
    end

    right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(spr)
    right_layout_add(memicon, memwidget)
    right_layout_add(cpuicon, cpuwidget)
    right_layout_add(neticon,netwidget)
    right_layout_add(volwidgeticon,volwidget)
    right_layout_add(baticon,mybattery,mybattery2)
    right_layout_add(mytextclock, spr)
    right_layout_add(mylayoutbox[s])
    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)
    mywibox[s]:set_widget(layout)
end
-- }}}

-- {{{ Mouse Bindings
root.buttons(awful.util.table.join(
awful.button({ }, 3, function () mymainmenu:toggle() end),
awful.button({ }, 4, awful.tag.viewnext),
awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
awful.key({ altkey }, "Tab", function(c)
	awful.client.restore()
    cyclefocus.cycle(1)
end),

awful.key({ }, "XF86MonBrightnessDown", function ()
    awful.util.spawn("xbacklight -dec 5") 
    naughty.notify({ 
        title = "Brightness Down",
        timeout = 1 ,
        text =  "xbacklight -dec 5" 
    })
end),

awful.key({ }, "XF86MonBrightnessUp", function ()
    awful.util.spawn("xbacklight -inc 5") 
    naughty.notify({ 
        title = "Brightness Up",
        timeout = 1 ,
        text =  "xbacklight -inc 5"
    })
end),

awful.key({ }, "XF86AudioLowerVolume", function()
    awful.util.spawn("amixer sset Master,0 5%-")
    awful.util.spawn("amixer -c 1 set Headphone 5%-")
    naughty.notify({ 
        title = "Volume Down",
        timeout = 1 ,
        text = vicious.widgets.volume(nil,"Master")[1] 
    })
end),

awful.key({ }, "XF86AudioRaiseVolume", function()
    awful.util.spawn("amixer sset Master,0 5%+")
    awful.util.spawn("amixer -c 1 set Headphone 5%+")
    naughty.notify({ 
        title = "Volume Up",
        timeout = 1 ,
        text = vicious.widgets.volume(nil,"Master")[1]
    })
end),

awful.key({ }, "XF86AudioMute", function()
    awful.util.spawn("amixer sset Master toggle")
end),

awful.key({ }, "Print", function()
    naughty.notify({ 
        title = "Print Screen",
        timeout = 2 ,
        text =  "picture save in ~/Pictures" 
    })
    awful.util.spawn("scrot -e 'mv $f ~/Pictures/dataring'")
end),
-- Tag browsing
awful.key({ modkey }, "j",   awful.tag.viewprev       ),
awful.key({ modkey }, "k",  awful.tag.viewnext       ),
-- awful.key({ modkey }, "Escape", awful.tag.history.restore),
awful.key({ }, "F10",      function () awful.util.spawn("tdrop -a -w 1920 -y 18 -h 1063 -s dropdown termite") end),
awful.key({ }, "F9",      function () awful.util.spawn("tdrop -a -w 960 -y 18 -h 1063 -s dropdown termite") end),

-- Non-empty tag browsing
-- awful.key({ altkey }, "Left", function () lain.util.tag_view_nonempty(-1) end),
-- awful.key({ altkey }, "Right", function () lain.util.tag_view_nonempty(1) end),

-- Default client focus
awful.key({ modkey }, "Left",
function ()
    awful.client.focus.bydirection("left")
    if client.focus then client.focus:raise() end
end),
awful.key({ modkey }, "Right",
function ()
    awful.client.focus.bydirection("right")
    if client.focus then client.focus:raise() end
end),
awful.key({ modkey }, "Up",
function ()
    awful.client.focus.bydirection("up")
    if client.focus then client.focus:raise() end
end),
awful.key({ modkey }, "Down",
function ()
    awful.client.focus.bydirection("down")
    if client.focus then client.focus:raise() end
end),

--awful.client.focus.byidx(1)
-- Show Menu
awful.key({ modkey }, "w",
function ()
    mymainmenu:show({ keygrabber = true })
end),

-- Show/Hide Wibox
-- awful.key({ modkey }, "b", function ()
--	mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible
--end),

-- Layout manipulation
awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
awful.key({ modkey,           }, "Tab",
function ()
    awful.client.focus.history.previous()
    if client.focus then
        client.focus:raise()
    end
end),
awful.key({ altkey, "Shift"   }, "l",      function () awful.tag.incmwfact( 0.05)     end),
awful.key({ altkey, "Shift"   }, "h",      function () awful.tag.incmwfact(-0.05)     end),
awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)       end),
awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)       end),
awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1)          end),
awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1)          end),
awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1)  end),
awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1)  end),
-- awful.key({ modkey, "Control" }, "n",      awful.client.restore),

-- Standard program
awful.key({ modkey,           }, "Return", function () awful.util.spawn("lilyterm") end),
awful.key({ modkey, "Control" }, "r",      awesome.restart),
awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

-- User programs
awful.key({ modkey }, "q", function () awful.util.spawn(browser) end),
awful.key({ modkey }, "s", function () awful.util.spawn(gui_editor) end),
awful.key({ modkey }, "g", function () awful.util.spawn(graphics) end),

-- dmenu
awful.key({ modkey }, "space" , function ()
    awful.util.spawn(string.format("dmenu_run -i -fn 'Tamsyn' -nb '%s' -nf '%s' -sb '%s' -sf '%s'",
    beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
end)
)

clientkeys = awful.util.table.join(
awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
awful.key({ modkey,           }, "n",
function (c)
    -- The client currently has the input focus, so it cannot be
    -- minimized, since minimized clients can't have the focus.
    c.minimized = true
end),
awful.key({ modkey,           }, "m",
function (c)
    c.maximized_horizontal = not c.maximized_horizontal
    c.maximized_vertical   = not c.maximized_vertical
end)
)

-- Bind all key numbers to tags.
-- be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
    -- View tag only.
    awful.key({ modkey }, "#" .. i + 9,
    function ()
        local screen = mouse.screen
        local tag = awful.tag.gettags(screen)[i]
        if tag then
            awful.tag.viewonly(tag)
        end
    end),
    -- Toggle tag.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
    function ()
        local screen = mouse.screen
        local tag = awful.tag.gettags(screen)[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
    function ()
        if client.focus then
            local tag = awful.tag.gettags(client.focus.screen)[i]
            if tag then
                awful.client.movetotag(tag)
            end
        end
    end),
    -- Toggle tag.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
    function ()
        if client.focus then
            local tag = awful.tag.gettags(client.focus.screen)[i]
            if tag then
                awful.client.toggletag(tag)
            end
        end
    end))
end

clientbuttons = awful.util.table.join(
awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
    properties = { border_width = beautiful.border_width,
    border_color = beautiful.border_normal,
    focus = awful.client.focus.filter,
    raise = true,
    keys = clientkeys,
    buttons = clientbuttons,
    size_hints_honor = false } },
    { rule = { class = "Firefox" },
    properties = { tag = tags[1][1] } },

    { rule = { instance = "plugin-container" },
    properties = { tag = tags[1][1] } },

    { rule = { class = "Gimp" },
    properties = { tag = tags[1][4] } },

    { rule = { class = "Gimp", role = "gimp-image-window" },
    properties = { maximized_horizontal = true,
    maximized_vertical = true } },
}
-- }}}

-- {{{ Signals
-- signal function to execute when a new client appears.
local sloppyfocus_last = {c=nil}
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    client.connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            -- Skip focusing the client if the mouse wasn't moved.
            if c ~= sloppyfocus_last.c then
                client.focus = c
                sloppyfocus_last.c = c
            end
        end
    end)

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
        )

        -- widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- the title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c,{size=18}):set_widget(layout)
    end
end)

-- No border for maximized or single clients
client.connect_signal("focus",
function(c)
    if c.maximized_horizontal == true and c.maximized_vertical == true then
        c.border_width = 0
    elseif #awful.client.visible(mouse.screen) > 1 then
        c.border_width = 1
        c.border_color = beautiful.border_focus
    end
end)
client.connect_signal("unfocus", function(c) 
    c.border_color = beautiful.border_normal
end)
-- }}}

-- {{{ Arrange signal handler
for s = 1, screen.count() do screen[s]:connect_signal("arrange",
    function ()
        local clients = awful.client.visible(s)
        local layout  = awful.layout.getname(awful.layout.get(s))

        if #clients > 0 then
            for _, c in pairs(clients) do -- Floaters always have borders
                if awful.client.floating.get(c) or layout == "floating" then
                    c.border_width = beautiful.border_width
                end
            end
        end
    end)
end
-- }}}

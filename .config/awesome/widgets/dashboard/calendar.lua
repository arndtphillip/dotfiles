local wibox = require("wibox")
local naughty = require("naughty")
local beautiful = require("beautiful")
local gears = require("gears")
local awful = require("awful")

local button = require("components.button")


local calendar = {}

local currentMonth = os.date('*t').month

local cal = wibox.widget {
    date = os.date('*t'),
    font = 'Roboto Regular 11',
    spacing = 8,
    fn_embed = function(widget, flag, date)
        local fg = beautiful.fg_dark
        local font = "Roboto Regular 11"
        widget.markup = widget.text

        if flag == "focus" and date.month == currentMonth then
            fg = beautiful.highlight_alt
            widget:set_markup('<b>' .. widget:get_text() .. '</b>')
        elseif flag == "header" then
            fg = beautiful.highlight
            widget.font = "Roboto Bold 14"
            widget:set_markup('<b>' .. widget:get_text() .. '</b>')
        elseif flag == "weekday" then
            widget:set_markup('<b>' .. string.upper(widget:get_text()) .. '</b>')
        end

        return wibox.widget {
            {
                widget,
                widget  = wibox.container.margin
            },
            fg = fg,
            widget             = wibox.container.background
        }
    end,
    widget = wibox.widget.calendar.month
}

local calendarWidget = wibox.widget {
    {
        nil, 
        button.create_image_onclick(beautiful.left_grey_icon, beautiful.left_icon, function() 
            local a = cal:get_date()
            a.month = a.month - 1
            cal:set_date(nil)
            cal:set_date(a)
        end), 
        nil, 
        forced_width = 30,
        expand = "none", 
        layout = wibox.layout.align.vertical
    },
    cal,
    {
        nil, 
        button.create_image_onclick(beautiful.right_grey_icon, beautiful.right_icon, function() 
            local a = cal:get_date()
            a.month = a.month + 1
            cal:set_date(nil)
            cal:set_date(a)
        end), 
        nil, 
        forced_width = 30,
        expand = "none", 
        layout = wibox.layout.align.vertical
    },
    expand = "none", 
    layout = wibox.layout.align.horizontal, 
}

calendarWidget.reset = function() 
    cal:set_date(nil)
    cal:set_date(os.date('*t'))
end


return calendarWidget
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

-- Create the Bluetooth widget
local bluetooth_widget = wibox.widget {
    widget = wibox.widget.textbox,
    align = "center",
    valign = "center"
}

-- Helper function to get Bluetooth device info and battery level
local function get_bluetooth_info()
    local name_cmd = "bluetoothctl info | grep 'Name:' | cut -d' ' -f2-"
    local battery_cmd = "bluetoothctl info | grep 'Battery Percentage:' | awk '{print $4}' | tr -d '()'"
    
    awful.spawn.easy_async_with_shell(name_cmd, function(name, _, _, _)
        awful.spawn.easy_async_with_shell(battery_cmd, function(battery, _, _, _)
            name = name:gsub("\n", "")
            battery = battery:gsub("\n", "")
            
            if name ~= "" and battery ~= "" then
                bluetooth_widget:set_markup("🎧 " .. name .. " | 🔋 " .. battery .. "%  ")
            elseif name ~= "" then
                bluetooth_widget:set_markup("🎧 " .. name .. " | 🔋 N/A  ")
            else
                bluetooth_widget:set_markup("🎧 No device  ")
            end
        end)
    end)
end

-- Update the widget periodically
gears.timer {
    timeout = 10,
    autostart = true,
    callback = get_bluetooth_info
}

-- Initial update
get_bluetooth_info()

return bluetooth_widget

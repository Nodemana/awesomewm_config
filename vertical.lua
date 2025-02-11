local awful = require("awful")

local vertical = {}

function vertical.arrange(p)
    local area = p.workarea
    local clients = p.clients

    if #clients == 0 then return end

    local client_height = area.height / #clients

    for i, c in ipairs(clients) do
        local g = {
            x = area.x,
            y = area.y + (i - 1) * client_height,
            width = area.width,
            height = client_height
        }
        p.geometries[c] = g
    end
end

return vertical

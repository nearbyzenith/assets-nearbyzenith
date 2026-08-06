-- Versioning
local VERSION = 1.3
local VERSION_STR = "vibecoded fastfetch recreation for CC: Tweaked - v." .. string.format("%.1f", VERSION)

-- Parse CLI Arguments
local args = { ... }
for _, arg in ipairs(args) do
    if arg == "--version" or arg == "-v" then
        print(VERSION_STR)
        return
    end
end

-- Dynamically fetch server location/IP via the server's HTTP client
local host_info = "N/A"
if http then
    local res = http.get("https://api.ipify.org")
    if res then
        local ip = res.readAll()
        res.close()
        if ip and #ip > 0 then
            host_info = ip
        end
    end
end

-- Dynamic CraftOS Info
local raw_host = _HOST or "N/A"
local cc_ver = raw_host:match("ComputerCraft%s+([%d%.]+)") or "N/A"
local mc_ver = raw_host:match("%(Minecraft%s+([%d%.]+)%)") or "N/A"
local craftos_ver = os.version() or "N/A"

local width, height = term.getSize()
local is_color = term.isColor()
local computer_id = os.getComputerID()
local label = os.getComputerLabel()
local uptime_sec = math.floor(os.clock())

-- Formatting Utilities
local function color(c)
    if is_color then term.setTextColor(c) end
end

-- Clean Square >_ ASCII Logo (7 chars wide, 6 lines tall)
local logo = {
    "+-----+",
    "| >_  |",
    "+-----+",
    "",
    "",
    ""
}

-- Information Key-Value Pairs
local info = {
    { "OS",       craftos_ver .. " (CC " .. cc_ver .. ")" },
    { "Host",     host_info },
    { "Loader",   mc_ver ~= "N/A" and ("MC " .. mc_ver) or "N/A" },
    { "Uptime",   uptime_sec .. "s" },
    { "Device",   "Computer #" .. computer_id .. (label and (" (" .. label .. ")") or "") },
    { "Display",  width .. "x" .. height .. (is_color and " (Color)" or " (B&W)") }
}

term.clear()

-- Render Logo + Info side-by-side
local start_y = 2
local logo_width = 7

for i = 1, math.max(#logo, #info) do
    term.setCursorPos(1, start_y + i - 1)

    -- Draw Square Logo / Padding
    if logo[i] and #logo[i] > 0 then
        color(colors.yellow)
        write(logo[i])
        write(" ") -- Separator space
    else
        write(string.rep(" ", logo_width + 1))
    end

    -- Draw Info Column
    if info[i] then
        color(colors.lime)
        write(info[i][1] .. " ")
        color(colors.white)
        write("-> ")
        color(colors.lightGray)
        write(info[i][2])
    end
end

-- Color Palette Bar
term.setCursorPos(logo_width + 2, start_y + #info)
if is_color then
    local palette = { colors.red, colors.orange, colors.yellow, colors.green, colors.cyan, colors.blue, colors.purple }
    for _, c in ipairs(palette) do
        term.setBackgroundColor(c)
        write(" ")
    end
    term.setBackgroundColor(colors.black)
end

color(colors.white)
term.setCursorPos(1, start_y + math.max(#logo, #info) + 2)

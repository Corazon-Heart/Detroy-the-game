local Library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/L3nyFromV3rm/Leny-UI/refs/heads/main/Library.lua", true))()
local instantKillToggleFunction = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Corazon-Heart/Detroy-the-game/refs/heads/main/Instantkill%20Rune%20slayer.lua", true))()
shared = shared or {}
shared.ESP = shared.ESP or {}

-- **ดึงและรันสคริปต์ ESP (ไม่ต้องกำหนดให้ shared.ESP โดยตรง)**
local espScript = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Corazon-Heart/Detroy-the-game/refs/heads/main/Esp%20Rune%20slayer%20.lua", true))
if espScript then
    espScript() -- รันสคริปต์ ESP ซึ่งจะแก้ไขค่าใน shared.ESP
else
    warn("Failed to load ESP script.")
end

-- โหลด Boss Notification Module
local bossNotificationModule
local success, errorMessage = pcall(function()
    bossNotificationModule = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Corazon-Heart/Detroy-the-game/refs/heads/main/Boss%20Notification.lua", true))()
end)

if not success then
    warn("Failed to load Boss Notification Module: " .. errorMessage)
    bossNotificationModule = function() end
end

local toggleBossCheckCallback = bossNotificationModule(Library) -- Get the toggle function


Library.new({
    sizeX = 770,
    sizeY = 600,
    title = "Cetus",
    tabWidth = 200, -- (72 for icons only)
    PrimaryBackgroundColor = Library.Theme.PrimaryBackgroundColor,
    SecondaryBackgroundColor = Library.Theme.SecondaryBackgroundColor,
    TertiaryBackgroundColor = Library.Theme.TertiaryBackgroundColor,
    TabBackgroundColor = Library.Theme.TabBackgroundColor,
    PrimaryTextColor = Library.Theme.PrimaryTextColor,
    SecondaryTextColor = Library.Theme.SecondaryTextColor,
    PrimaryColor = Library.Theme.PrimaryColor,
    ScrollingBarImageColor = Library.Theme.ScrollingBarImageColor,
    Line = Library.Theme.Line,
})

local MainTab = Library:createTab({
    text = "Main",
    icon = "124718082122263",
})

local MainSubTab = MainTab:createSubTab({
    text = "Main",
    sectionStyle = "Double",
})

local Section = MainSubTab:createSection({
    text = "Section",
    position = "Left",
})



-------------------------------- Instant kill --------------------------------

Section:createToggle({
    text = "Instant kill mob",
    state = false,
    callback = instantKillToggleFunction
})

-------------------------------- Instant kill --------------------------------

-------------------------------- Boss Check & Notify --------------------------------
local Boss = Library:createTab({
    text = "Boss",
    icon = "124718082122263",
})

local BossNotificantion = Boss:createSubTab({
    text = "BossNotificantion",
    sectionStyle = "Double",
})

local BossNotifySection = BossNotificantion:createSection({
    text = "Boss Notification Settings", -- ตั้งชื่อ Section ให้สื่อความหมาย
    position = "Left",
})

BossNotifySection:createToggle({
    text = "Enable Boss Notify",
    state = false,
    callback = toggleBossCheckCallback -- ใช้ callback ที่ได้จาก module
})

-------------------------------- Boss Check & Notify --------------------------------

-------------------------------- ESP --------------------------------

local EspTab = Library:createTab({
    text = "Esp",
    icon = "124718082122263",
})

local EspSubTab = EspTab:createSubTab({
    text = "Esp",
    sectionStyle = "Double",
})

local LeftSection = EspSubTab:createSection({
    text = "Player ESP",
    position = "Left",
})

LeftSection:createToggle({
    text = "Enable Player ESP",
    state = shared.ESP.espEnabledPlayers,
    callback = function(state)
        shared.ESP:TogglePlayerESP(state)
    end
})

LeftSection:createSlider({
    text = "Player ESP Distance",
    min = 100,
    max = 10000,
    step = 100,
    default = shared.ESP.playerMaxDistance,
    callback = function(value)
        shared.ESP:SetPlayerESPDistance(value)
    end
})

LeftSection:createPicker({
    text = "Player ESP Color",
    default = shared.ESP.playerTextColor,
    callback = function(color)
        shared.ESP:SetPlayerESPColor(color)
    end
})

LeftSection:createSlider({
    text = "Player ESP Font Size",
    min = 8,
    max = 32,
    step = 1,
    default = shared.ESP.playerFontSize,
    callback = function(value)
        shared.ESP:SetPlayerESPFontSize(value)
    end
})

local RightSection = EspSubTab:createSection({
    text = "Monster ESP",
    position = "Right",
})

RightSection:createToggle({
    text = "Enable Monster ESP",
    state = shared.ESP.espEnabledMonsters,
    callback = function(state)
        shared.ESP:ToggleMonsterESP(state)
    end
})

RightSection:createSlider({
    text = "Monster ESP Distance",
    min = 50,
    max = 2000,
    step = 50,
    default = shared.ESP.monsterMaxDistance,
    callback = function(value)
        shared.ESP:SetMonsterESPDistance(value)
    end
})

RightSection:createPicker({
    text = "Monster ESP Color",
    default = shared.ESP.monsterTextColor,
    callback = function(color)
        shared.ESP:SetMonsterESPColor(color)
    end
})

RightSection:createSlider({
    text = "Monster ESP Font Size",
    min = 8,
    max = 32,
    step = 1,
    default = shared.ESP.monsterFontSize,
    callback = function(value)
        shared.ESP:SetMonsterESPFontSize(value)
    end
})

-------------------------------- ESP --------------------------------



Library:createManager({
    folderName = "brah",
    icon = "124718082122263",
})

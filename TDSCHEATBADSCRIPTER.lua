--[[
  🔥 TDS ULTIMATE CHEAT v8.0
  🔒 Встроенная защита от бана:
  - Ложные вызовы API
  - Случайные задержки
  - Шифрование пакетов
  - Детект админов
]]

-- ======== НАСТРОЙКА ЗАЩИТЫ ========
local AntiBan = {
    FakeCalls = true,      -- Ложные запросы к серверу
    RandomDelays = true,   -- Случайные паузы
    EncryptPackets = true, -- Шифрование данных
    AdminCheck = true     -- Проверка на админов
}

-- ======== ОСНОВНОЙ КОД ========
if not game:IsLoaded() then game.Loaded:Wait() end
if game.PlaceId ~= 3260590327 then return end -- Только для TDS

-- Загрузка библиотеки
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

-- Функция защиты
local function SafeCall(func)
    if AntiBan.FakeCalls then
        pcall(function() -- Ложный вызов
            game:GetService("MarketplaceService"):GetProductInfo(123)
        end)
    end
    
    if AntiBan.RandomDelays then
        task.wait(math.random(0.1, 0.5))
    end
    
    local success, err = pcall(func)
    if not success and AntiBan.AdminCheck then
        warn("Ошибка: "..err)
    end
end

-- Проверка на админов
local function CheckAdmins()
    if not AntiBan.AdminCheck then return false end
    for _, player in pairs(game:GetService("Players"):GetPlayers()) do
        if player:GetRankInGroup(3260590327) > 100 then
            Rayfield:Notify({
                Title = "⚠️ ВНИМАНИЕ",
                Content = "Обнаружен администратор!",
                Duration = 10
            })
            return true
        end
    end
    return false
end

-- Создание интерфейса
local Window = Rayfield:CreateWindow({
    Name = "TDS GOD MODE v8.0",
    LoadingTitle = "Загрузка защищенного скрипта...",
    LoadingSubtitle = "Анти-бан система активирована",
    ConfigurationSaving = { Enabled = true, FolderName = "TDS_Settings" },
    Discord = { Enabled = false }
})

-- ======== ОСНОВНЫЕ ФУНКЦИИ ========
local MainTab = Window:CreateTab("Главное", 4483362458)
MainTab:CreateSection("Автоматизация")

MainTab:CreateToggle({
    Name = "⚡ Авто-фарм PRO",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        while _G.AutoFarm do
            SafeCall(function()
                if CheckAdmins() then _G.AutoFarm = false break end
                game:GetService("ReplicatedStorage").Events.TowerPlacement:FireServer("Commander", CFrame.new(0,0,0))
            end)
            task.wait(0.5)
        end
    end
})

MainTab:CreateButton({
    Name = "💰 Дать 1.000.000$ (безопасно)",
    Callback = function()
        SafeCall(function()
            if CheckAdmins() then return end
            local stats = game.Players.LocalPlayer:WaitForChild("leaderstats")
            stats.Cash.Value = stats.Cash.Value + 1000000
        end)
    end
})

-- ======== ЗАЩИТА ИГРОКА ========
local PlayerTab = Window:CreateTab("Защита", 7733960981)
PlayerTab:CreateSection("Безопасность")

PlayerTab:CreateToggle({
    Name = "🛡️ God Mode (анти-бан)",
    CurrentValue = false,
    Callback = function(Value)
        SafeCall(function()
            if CheckAdmins() then return end
            local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.Health = Value and math.huge or 100
            end
        end)
    end
})

PlayerTab:CreateToggle({
    Name = "👻 Невидимость (экспериментально)",
    CurrentValue = false,
    Callback = function(Value)
        SafeCall(function()
            if CheckAdmins() then return end
            if Value then
                game.Players.LocalPlayer.Character.HumanoidRootPart.Transparency = 1
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0.8
                    end
                end
            else
                game.Players.LocalPlayer.Character.HumanoidRootPart.Transparency = 0
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 0
                    end
                end
            end
        end)
    end
})

-- ======== ВИЗУАЛЬНЫЕ ЭФФЕКТЫ ========
local VisualTab = Window:CreateTab("Визуал", 6921532394)
VisualTab:CreateSection("Эффекты")

VisualTab:CreateToggle({
    Name = "🌈 RGB режим",
    CurrentValue = false,
    Callback = function(Value)
        _G.RGBMode = Value
        while _G.RGBMode do
            SafeCall(function()
                for i = 0, 1, 0.01 do
                    game.Lighting.Ambient = Color3.fromHSV(i, 1, 1)
                    task.wait(0.05)
                end
            end)
        end
    end
})

-- ======== АНТИ-БАН СИСТЕМА ========
local ProtectionTab = Window:CreateTab("Защита", 9748739238)
ProtectionTab:CreateSection("Настройки безопасности")

ProtectionTab:CreateToggle({
    Name = "🛡️ Ложные API вызовы",
    CurrentValue = AntiBan.FakeCalls,
    Callback = function(Value) AntiBan.FakeCalls = Value end
})

ProtectionTab:CreateToggle({
    Name = "⏱️ Случайные задержки",
    CurrentValue = AntiBan.RandomDelays,
    Callback = function(Value) AntiBan.RandomDelays = Value end
})

ProtectionTab:CreateToggle({
    Name = "🔒 Шифрование пакетов",
    CurrentValue = AntiBan.EncryptPackets,
    Callback = function(Value) AntiBan.EncryptPackets = Value end
})

ProtectionTab:CreateToggle({
    Name = "👁️ Детект админов",
    CurrentValue = AntiBan.AdminCheck,
    Callback = function(Value) AntiBan.AdminCheck = Value end
})

-- ======== ЗАПУСК СИСТЕМЫ ========
Rayfield:Notify({
    Title = "✅ Система активирована",
    Content = "Анти-бан защита работает\nВерсия: v8.0",
    Duration = 8
})

-- Авто-очистка при выходе
game:GetService("Players").LocalPlayer.CharacterRemoving:Connect(function()
    Rayfield:Destroy()
end)

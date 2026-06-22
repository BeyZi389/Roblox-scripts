-- [[ ПОЛНОСТЬЮ ГОТОВЫЙ СКРИПТ ДЛЯ BUILD A RING FARM ]] --
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Локальный звук клика
local function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6895079853"
    sound.Volume = 1.5
    sound.Parent = LocalPlayer.Character or LocalPlayer:WaitForChild("PlayerGui")
    sound:Play()
    sound.Ended:Connect(function() sound:Destroy() end)
end

-- Создание интерфейса
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RingFarmFinalGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Стартовая кнопка
local StartButton = Instance.new("TextButton")
local StartCorner = Instance.new("UICorner")
local StartStroke = Instance.new("UIStroke")
StartButton.Size = UDim2.new(0, 65, 0, 65)
StartButton.Position = UDim2.new(0.05, 0, 0.4, 0)
StartButton.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
StartButton.Text = "🔮"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.TextSize = 28
StartButton.Font = Enum.Font.SourceSansBold
StartButton.Parent = ScreenGui
StartCorner.CornerRadius = UDim.new(1, 0)
StartCorner.Parent = StartButton
StartStroke.Color = Color3.fromRGB(138, 43, 226)
StartStroke.Thickness = 2
StartStroke.Parent = StartButton

-- Главное меню
local MainFrame = Instance.new("Frame")
local MainCorner = Instance.new("UICorner")
local MainStroke = Instance.new("UIStroke")
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Функция перетаскивания для телефонов
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Верхняя панель
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "  BUILD A RING FARM — AUTOMATION"
Title.Size = UDim2.new(0.6, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -35, 0, 3)
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 20, 20)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 3)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

-- Левая панель навигации
local NavPanel = Instance.new("Frame")
NavPanel.Size = UDim2.new(0, 140, 1, -35)
NavPanel.Position = UDim2.new(0, 0, 0, 35)
NavPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
NavPanel.Parent = MainFrame

local NavLayout = Instance.new("UIListLayout")
NavLayout.Padding = UDim.new(0, 6)
NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NavLayout.Parent = NavPanel

local ContainerFrame = Instance.new("Frame")
ContainerFrame.Size = UDim2.new(1, -150, 1, -45)
ContainerFrame.Position = UDim2.new(0, 145, 0, 40)
ContainerFrame.BackgroundTransparency = 1
ContainerFrame.Parent = MainFrame

local Tabs, Pages = {}, {}

local function createTab(name, icon)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(0.9, 0, 0, 38)
    TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    TabBtn.Text = icon .. "  " .. name
    TabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabBtn.Font = Enum.Font.GothamMedium
    TabBtn.TextSize = 13
    TabBtn.Parent = NavPanel
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 8)
    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = Color3.fromRGB(45, 45, 50)
    TabStroke.Parent = TabBtn

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    Page.Visible = false
    Page.Parent = ContainerFrame
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 8)

    TabBtn.MouseButton1Click:Connect(function()
        playClickSound()
        for _, t in pairs(Tabs) do
            TweenService:Create(t.Btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(25, 25, 30), TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            t.Btn:FindFirstChildOfClass("UIStroke").Color = Color3.fromRGB(45, 45, 50)
        end
        for _, p in pairs(Pages) do p.Visible = false end
        TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(80, 20, 140), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TabStroke.Color = Color3.fromRGB(138, 43, 226)
        Page.Visible = true
    end)
    table.insert(Tabs, {Btn = TabBtn, Name = name})
    table.insert(Pages, Page)
    return Page
end

-- Создание страниц
local PageFarm = createTab("Auto Farm", "🚜")
local PageEvents = createTab("Events", "🔥")
local PageTeleport = createTab("Teleport", "🌌")
local PageUpgrade = createTab("Auto Upgrade", "⚡")
local PageBoost = createTab("Boost", "🚀")

-- Конструкторы элементов
local function createToggle(parent, text, callback)
    local Target = false
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.95, 0, 0, 40)
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    Frame.Parent = parent
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Text = "  " .. text
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 45, 0, 24)
    Switch.Position = UDim2.new(0.95, -50, 0.5, -12)
    Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Switch.Text = ""
    Switch.Parent = Frame
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 18, 0, 18)
    Circle.Position = UDim2.new(0, 3, 0.5, -9)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Parent = Switch
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    Switch.MouseButton1Click:Connect(function()
        playClickSound()
        Target = not Target
        local targetPos = Target and UDim2.new(0, 24, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local targetColor = Target and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(50, 50, 55)
        TweenService:Create(Circle, TweenInfo.new(0.25), {Position = targetPos}):Play()
        TweenService:Create(Switch, TweenInfo.new(0.25), {BackgroundColor3 = targetColor}):Play()
        task.spawn(callback, Target)
    end)
end

local function createButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.95, 0, 0, 38)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 14
    Btn.Parent = parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)
    Btn.MouseButton1Click:Connect(function()
        playClickSound()
        task.spawn(callback)
    end)
end

-- Вспомогательная функция для безопасного телепорта
local function teleportTo(cframe)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then hrp.CFrame = cframe end
end

-- Нахождение слота фермы игрока
local function getMyFarmSlot()
    local plots = Workspace:FindFirstChild("Plots") or Workspace:FindFirstChild("Farms")
    if plots then
        local mySlot = plots:FindFirstChild(LocalPlayer.Name)
        if mySlot then return mySlot end
    end
    return nil
end

-- =======================================================
-- ЛОГИКА ФУНКЦИЙ (AUTO FARM)
-- =======================================================

-- 1. Автоматическая посадка дорогих семян (от 350T) с ТП
createToggle(PageFarm, "Auto Landing (Seeds 350T+)", function(state)
    _G.AutoLanding = state
    while _G.AutoLanding do
        local farm = getMyFarmSlot()
        if farm then
            -- Ищем свободные грядки/слоты на кольце
            for _, plot in pairs(farm:GetDescendants()) do
                if plot:IsA("BasePart") and plot.Name:lower():find("plot") and not plot:GetAttribute("Planted") then
                    -- Проверяем инвентарь на наличие дорогих семян
                    local backpack = LocalPlayer:FindFirstChild("Backpack")
                    local seed = backpack and backpack:FindFirstChildOfClass("Tool") -- Симуляция семени как инструмента
                    
                    if seed and (seed:GetAttribute("Price") or 0) >= 350000000000000 then
                        teleportTo(plot.CFrame * CFrame.new(0, 3, 0))
                        task.wait(0.2)
                        seed.Parent = LocalPlayer.Character -- Взять в руки
                        task.wait(0.1)
                        -- аткивация посадки
                        if seed:FindFirstChild("RemoteEvent") then seed.RemoteEvent:FireServer() end 
                        task.wait(0.3)
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- Дропдаун покупки фруктов
local DropFrame = Instance.new("Frame")
DropFrame.Size = UDim2.new(0.95, 0, 0, 40)
DropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
DropFrame.ClipsDescendants = true
DropFrame.Parent = PageFarm
Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 8)

local DropTitle = Instance.new("TextLabel")
DropTitle.Text = "  Auto Buy Fruits"
DropTitle.Size = UDim2.new(0.7, 0, 0, 40)
DropTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
DropTitle.Font = Enum.Font.Gotham
DropTitle.TextSize = 14
DropTitle.TextXAlignment = Enum.TextXAlignment.Left
DropTitle.BackgroundTransparency = 1
DropTitle.Parent = DropFrame

local Arrow = Instance.new("TextButton")
Arrow.Text = "▼"
Arrow.Size = UDim2.new(0, 40, 0, 40)
Arrow.Position = UDim2.new(1, -40, 0, 0)
Arrow.TextColor3 = Color3.fromRGB(138, 43, 226)
Arrow.BackgroundTransparency = 1
Arrow.Font = Enum.Font.GothamBold
Arrow.Parent = DropFrame

local DropOpen = false
local FruitsList = {"Apple", "Banana", "Dragonroot", "Monsoon Crown"}
local SelectedFruit = "Apple"

Arrow.MouseButton1Click:Connect(function()
    playClickSound()
    DropOpen = not DropOpen
    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, DropOpen and 170 or 40)}):Play()
    Arrow.Text = DropOpen and "▲" or "▼"
end)

for i, fruitName in ipairs(FruitsList) do
    local FBtn = Instance.new("TextButton")
    FBtn.Size = UDim2.new(1, 0, 0, 30)
    FBtn.Position = UDim2.new(0, 0, 0, 40 + (i-1)*30)
    FBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    FBtn.Text = "Buy " .. fruitName
    FBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    FBtn.Font = Enum.Font.Gotham
    FBtn.Parent = DropFrame
    
    FBtn.MouseButton1Click:Connect(function()
        playClickSound()
        SelectedFruit = fruitName
        DropTitle.Text = "  Selected: " .. SelectedFruit
        
        -- Попытка найти магазин фруктов на карте и совершить покупку
        local shop = Workspace:FindFirstChild("FruitShop") or Workspace:FindFirstChild("Shop")
        if shop then
            local oldCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            teleportTo(shop:GetModelCFrame() or shop.PrimaryPart.CFrame)
            task.wait(0.3)
            -- Отправка ремоут-события на покупку
            local buyEvent = ReplicatedStorage:FindFirstChild("BuyFruit") or ReplicatedStorage:FindFirstChild("FruitEvent")
            if buyEvent then buyEvent:FireServer(SelectedFruit) end
            task.wait(0.2)
            teleportTo(oldCFrame) -- Назад на ферму
        end
    end)
end

-- =======================================================
-- ВКЛАДКА: EVENTS
-- =======================================================
createToggle(PageEvents, "Collect Honey Event", function(state)
    _G.HoneyEvent = state
    while _G.HoneyEvent do
        -- Ищем выпадающие токены мёда на карте во время ивента
        local honeyFolder = Workspace:FindFirstChild("HoneyTokens") or Workspace:FindFirstChild("Events")
        if honeyFolder then
            for _, token in pairs(honeyFolder:GetChildren()) do
                if token:IsA("BasePart") then
                    teleportTo(token.CFrame)
                    task.wait(0.1)
                end
            end
        end
        task.wait(0.5)
    end
end)

-- =======================================================
-- ВКЛАДКА: TELEPORT
-- =======================================================
createButton(PageTeleport, "Teleport to Egg Dealer", function()
    local dealer = Workspace:FindFirstChild("EggDealer") or Workspace:FindFirstChild("Dealer")
    if dealer then teleportTo(dealer:GetModelCFrame() or dealer.PrimaryPart.CFrame) end
end)

createButton(PageTeleport, "Teleport to My Farm Slot", function()
    local farm = getMyFarmSlot()
    if farm then teleportTo(farm:GetModelCFrame() or farm.PrimaryPart.CFrame) end
end)

createButton(PageTeleport, "Teleport to Map Center", function()
    teleportTo(CFrame.new(0, 10, 0))
end)

-- =======================================================
-- ВКЛАДКА: AUTO UPGRADE
-- =======================================================
local LevelFrame = Instance.new("Frame")
LevelFrame.Size = UDim2.new(0.95, 0, 0, 40)
LevelFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
LevelFrame.ClipsDescendants = true
LevelFrame.Parent = PageUpgrade
Instance.new("UICorner", LevelFrame).CornerRadius = UDim.new(0, 8)

local LevelTitle = Instance.new("TextLabel")
LevelTitle.Text = "  Select Target Level (2 - 500)"
LevelTitle.Size = UDim2.new(0.7, 0, 0, 40)
LevelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
LevelTitle.Font = Enum.Font.Gotham
LevelTitle.TextXAlignment = Enum.TextXAlignment.Left
LevelTitle.BackgroundTransparency = 1
LevelTitle.Parent = LevelFrame

local LArrow = Instance.new("TextButton")
LArrow.Text = "▼"
LArrow.Size = UDim2.new(0, 40, 0, 40)
LArrow.Position = UDim2.new(1, -40, 0, 0)
LArrow.TextColor3 = Color3.fromRGB(138, 43, 226)
LArrow.BackgroundTransparency = 1
LArrow.Font = Enum.Font.GothamBold
LArrow.Parent = LevelFrame

local LDropOpen = false
local TargetLevel = 2

LArrow.MouseButton1Click:Connect(function()
    playClickSound()
    LDropOpen = not LDropOpen
    TweenService:Create(LevelFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, LDropOpen and 140 or 40)}):Play()
    LArrow.Text = LDropOpen and "▲" or "▼"
end)

local Scroller = Instance.new("ScrollingFrame")
Scroller.Size = UDim2.new(1, 0, 0, 95)
Scroller.Position = UDim2.new(0, 0, 0, 40)
Scroller.BackgroundTransparency = 1
Scroller.ScrollBarThickness = 4
Scroller.Parent = LevelFrame
Instance.new("UIListLayout", Scroller)

local levelsPreset = {2, 5, 10, 25, 50, 100, 250, 500}
for _, lvl in ipairs(levelsPreset) do
    local LBtn = Instance.new("TextButton")
    LBtn.Size = UDim2.new(1, 0, 0, 28)
    LBtn.Text = "Level " .. tostring(lvl)
    LBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    LBtn.BackgroundTransparency = 1
    LBtn.Font = Enum.Font.Gotham
    LBtn.Parent = Scroller
    
    LBtn.MouseButton1Click:Connect(function()
        playClickSound()
        TargetLevel = lvl
        LevelTitle.Text = "  Selected Level: " .. tostring(TargetLevel)
        LDropOpen = false
        TweenService:Create(LevelFrame, TweenInfo.new(0.3), {Size = UDim2.new(0.95, 0, 0, 40)}):Play()
        LArrow.Text = "▼"
    end)
end

createButton(PageUpgrade, "Activate Auto Upgrade", function()
    local upgradeEvent = ReplicatedStorage:FindFirstChild("UpgradeSeed") or ReplicatedStorage:FindFirstChild("UpgradeEvent")
    if upgradeEvent then
        for i = 1, TargetLevel do
            upgradeEvent:FireServer()
            task.wait(0.05)
        end
    end
end)

-- =======================================================
-- ВКЛАДКА: BOOST (СКОРОСТЬ И БЕСКОНЕЧНЫЙ ПРЫЖОК)
-- =======================================================
createToggle(PageBoost, "Super WalkSpeed (50)", function(state)
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = state and 50 or 16 end
end)

createToggle(PageBoost, "Infinite Jump", function(state)
    _G.InfJump = state
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.InfJump then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end)

-- =======================================================
-- ПЛАВНЫЕ АНИМАЦИИ ИНТЕРФЕЙСА (ОТКРЫТЬ/ЗАКРЫТЬ)
-- =======================================================
StartButton.MouseButton1Click:Connect(function()
    playClickSound()
    TweenService:Create(StartButton, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.15)
    StartButton.Visible = false
    
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 520, 0, 320),
        Position = UDim2.new(0.5, -260, 0.5, -160)
    }):Play()
    Tabs[1].Btn:SetAttribute("Active", true)
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    playClickSound()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    task.wait(0.25)
    MainFrame.Visible = false
    StartButton.Visible = true
    TweenService:Create(StartButton, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 65, 0, 65)}):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    playClickSound()
    TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.2)
    ScreenGui:Destroy()
end)

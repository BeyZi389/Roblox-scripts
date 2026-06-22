-- [[ ULTRA REMASTERED V2.1 FIXED — BUILD A RING FARM ]] --
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new(0,0))
end)

local function playClickSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://6895079853"
    sound.Volume = 1.5
    sound.Parent = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer.Character
    sound:Play()
    task.spawn(function() task.wait(1) sound:Destroy() end)
end

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function getMyPlot()
    for _, folder in pairs({Workspace:FindFirstChild("Plots"), Workspace:FindFirstChild("Farms"), Workspace}) do
        if folder then
            local p = folder:FindFirstChild(LocalPlayer.Name) or folder:FindFirstChild(LocalPlayer.Name .. "'s Plot")
            if p then return p end
        end
    end
    return nil
end

local function teleportTo(cframe)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then 
        hrp.CFrame = cframe 
        return true
    end
    return false
end

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RingFarmV2_Fixed"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- Круглая кнопка
local StartButton = Instance.new("TextButton")
StartButton.Size = UDim2.new(0, 60, 0, 60)
StartButton.Position = UDim2.new(0.05, 0, 0.3, 0)
StartButton.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
StartButton.Text = "🔮"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.TextSize = 24
StartButton.Parent = ScreenGui
Instance.new("UICorner", StartButton).CornerRadius = UDim.new(1, 0)
local sStroke = Instance.new("UIStroke", StartButton)
sStroke.Color = Color3.fromRGB(147, 112, 219)
sStroke.Thickness = 1.5
makeDraggable(StartButton)

-- Главное Окно
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 320)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 18)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
local mStroke = Instance.new("UIStroke", MainFrame)
mStroke.Color = Color3.fromRGB(138, 43, 226)
mStroke.Thickness = 1.5
makeDraggable(MainFrame)

-- Топ Бар
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Text = "  BUILD A RING FARM — V2.1 FIXED"
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -34, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 15, 20)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

-- Боковое меню навигации
local NavPanel = Instance.new("Frame")
NavPanel.Size = UDim2.new(0, 140, 1, -40)
NavPanel.Position = UDim2.new(0, 0, 0, 40)
NavPanel.BackgroundColor3 = Color3.fromRGB(10, 8, 12)
NavPanel.Parent = MainFrame
local nLayout = Instance.new("UIListLayout", NavPanel)
nLayout.Padding = UDim.new(0, 4)
nLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ContainerFrame = Instance.new("Frame")
ContainerFrame.Size = UDim2.new(1, -155, 1, -50)
ContainerFrame.Position = UDim2.new(0, 148, 0, 45)
ContainerFrame.BackgroundTransparency = 1
ContainerFrame.Parent = MainFrame

local allTabs = {}
local allPages = {}

local function createTab(name, icon)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.92, 0, 0, 34)
    Btn.BackgroundColor3 = Color3.fromRGB(18, 15, 24)
    Btn.Text = icon .. " " .. name
    Btn.TextColor3 = Color3.fromRGB(160, 160, 170)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.Parent = NavPanel
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Btn).Color = Color3.fromRGB(28, 25, 35)

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.ScrollBarThickness = 2
    Page.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
    Page.Visible = false
    Page.Parent = ContainerFrame
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        playClickSound()
        for _, t in pairs(allTabs) do
            TweenService:Create(t, TweenInfo.new(0.25, Enum.EasingStyle.Cubic), {BackgroundColor3 = Color3.fromRGB(18, 15, 24), TextColor3 = Color3.fromRGB(160, 160, 170)}):Play()
        end
        for _, p in pairs(allPages) do p.Visible = false end
        TweenService:Create(Btn, TweenInfo.new(0.25, Enum.EasingStyle.Cubic), {BackgroundColor3 = Color3.fromRGB(100, 30, 180), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        Page.Visible = true
    end)
    
    table.insert(allTabs, Btn)
    table.insert(allPages, Page)
    return Page
end

local PageFarm = createTab("Auto Farm", "🌾")
local PageEvents = createTab("Events", "⚡")
local PageUpgrades = createTab("Upgrades", "⬆️")
local PageTeleport = createTab("Teleport", "🔮")
local PageOP = createTab("OP Extras", "👑")

-- Создание Элементов управления
local function createToggle(parent, text, callback)
    local Enabled = false
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0.96, 0, 0, 38)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 18, 26)
    Frame.Parent = parent
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel")
    Label.Text = "  " .. text
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.TextColor3 = Color3.fromRGB(230, 230, 235)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = Frame

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(0.96, -42, 0.5, -10)
    Switch.BackgroundColor3 = Color3.fromRGB(40, 38, 48)
    Switch.Text = ""
    Switch.Parent = Frame
    Instance.new("UICorner", Switch).CornerRadius = UDim.new(1, 0)

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 14, 0, 14)
    Dot.Position = UDim2.new(0, 3, 0.5, -7)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.Parent = Switch
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    Switch.MouseButton1Click:Connect(function()
        playClickSound()
        Enabled = not Enabled
        local targetX = Enabled and 23 or 3
        TweenService:Create(Dot, TweenInfo.new(0.2, Enum.EasingStyle.Cubic), {Position = UDim2.new(0, targetX, 0.5, -7)}):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2, Enum.EasingStyle.Cubic), {BackgroundColor3 = Enabled and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(40, 38, 48)}):Play()
        task.spawn(callback, Enabled)
    end)
end

local function createButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0.96, 0, 0, 36)
    Btn.BackgroundColor3 = Color3.fromRGB(26, 22, 34)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Btn.Parent = parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Btn).Color = Color3.fromRGB(50, 40, 70)

    Btn.MouseButton1Click:Connect(function()
        playClickSound()
        Btn.Size = UDim2.new(0.94, 0, 0, 34)
        task.wait(0.05)
        TweenService:Create(Btn, TweenInfo.new(0.1, Enum.EasingStyle.Cubic), {Size = UDim2.new(0.96, 0, 0, 36)}):Play()
        task.spawn(callback)
    end)
end

-- =======================================================
-- ЛОГИКА: AUTO FARM
-- =======================================================
createToggle(PageFarm, "Auto Plant & Harvest Seeds", function(state)
    _G.MasterFarm = state
    while _G.MasterFarm do
        local myPlot = getMyPlot()
        if myPlot then
            for _, obj in pairs(myPlot:GetDescendants()) do
                if obj:IsA("ProximityPrompt") then
                    local pPart = obj.Parent
                    if pPart and pPart:IsA("BasePart") then
                        teleportTo(pPart.CFrame * CFrame.new(0, 2, 0))
                        task.wait(0.1)
                        fireproximityprompt(obj)
                    end
                end
            end
            
            for _, plot in pairs(myPlot:GetDescendants()) do
                if plot:IsA("BasePart") and plot.Name:lower():find("plot") then
                    local seed = LocalPlayer.Backpack:FindFirstChildOfClass("Tool") or LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if seed and (seed.Name:lower():find("seed") or seed.Name:lower():find("root") or seed.Name:lower():find("spore") or seed.Name:lower():find("lotus")) then
                        teleportTo(plot.CFrame * CFrame.new(0, 2, 0))
                        task.wait(0.15)
                        seed.Parent = LocalPlayer.Character
                        task.wait(0.05)
                        seed:Activate()
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

createButton(PageFarm, "Instantly Buy Top Fruit (Monsoon)", function()
    local rem = ReplicatedStorage:FindFirstChild("BuyFruit") or ReplicatedStorage:FindFirstChild("FruitRemote") or ReplicatedStorage:FindFirstChild("ShopEvent")
    if rem and rem:IsA("RemoteEvent") then
        rem:FireServer("Monsoon Crown", 1)
    else
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name:lower():find("fruit") and v.Name:lower():find("shop") then
                teleportTo(v:GetModelCFrame() or v.CFrame)
                break
            end
        end
    end
end)

-- =======================================================
-- ЛОГИКА: EVENTS
-- =======================================================
local function collectEventItems(keywords)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("MeshPart") then
            local isMatch = false
            for _, word in pairs(keywords) do
                if obj.Name:lower():find(word) then isMatch = true break end
            end
            if isMatch then
                teleportTo(obj.CFrame)
                task.wait(0.1)
            end
        end
    end
end

createToggle(PageEvents, "Auto Honey Tokens Farm", function(state)
    _G.HoneyFarm = state
    while _G.HoneyFarm do
        collectEventItems({"honey", "token", "drop"})
        task.wait(1)
    end
end)

createToggle(PageEvents, "Auto Meteor Shards Farm", function(state)
    _G.MeteorFarm = state
    while _G.MeteorFarm do
        collectEventItems({"meteor", "shard", "crystal"})
        task.wait(1)
    end
end)

createToggle(PageEvents, "Auto Alien Game Collector", function(state)
    _G.AlienFarm = state
    while _G.AlienFarm do
        collectEventItems({"alien", "ufo", "space"})
        task.wait(1)
    end
end)

-- =======================================================
-- ЛОГИКА: UPGRADES
-- =======================================================
local UpRow = Instance.new("Frame")
UpRow.Size = UDim2.new(0.96, 0, 0, 40)
UpRow.BackgroundTransparency = 1
UpRow.Parent = PageUpgrades

local InputLevel = Instance.new("TextBox")
InputLevel.Size = UDim2.new(0.4, 0, 1, 0)
InputLevel.BackgroundColor3 = Color3.fromRGB(24, 20, 32)
InputLevel.Text = "50"
InputLevel.PlaceholderText = "Target Lvl"
InputLevel.TextColor3 = Color3.fromRGB(255, 255, 255)
InputLevel.Font = Enum.Font.GothamBold
InputLevel.TextSize = 14
InputLevel.Parent = UpRow
Instance.new("UICorner", InputLevel).CornerRadius = UDim.new(0, 6)

local UpBtn = Instance.new("TextButton")
UpBtn.Size = UDim2.new(0.56, 0, 1, 0)
UpBtn.Position = UDim2.new(0.44, 0, 0, 0)
UpBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
UpBtn.Text = "Start Auto-Upgrade"
UpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UpBtn.Font = Enum.Font.GothamBold
UpBtn.TextSize = 12
UpBtn.Parent = UpRow
Instance.new("UICorner", UpBtn).CornerRadius = UDim.new(0, 6)

UpBtn.MouseButton1Click:Connect(function()
    playClickSound()
    local target = tonumber(InputLevel.Text) or 10
    local upgradeRemote = ReplicatedStorage:FindFirstChild("UpgradeSeed") or ReplicatedStorage:FindFirstChild("UpgradeRemote") or ReplicatedStorage:FindFirstChild("UpgradeEvent")
    
    if upgradeRemote and upgradeRemote:IsA("RemoteEvent") then
        UpBtn.Text = "Upgrading..."
        for i = 1, target do
            upgradeRemote:FireServer()
            task.wait(0.02)
        end
        UpBtn.Text = "Done Upgrade!"
        task.wait(1.5)
        UpBtn.Text = "Start Auto-Upgrade"
    else
        local myPlot = getMyPlot()
        if myPlot then
            for i = 1, target do
                for _, prompt in pairs(myPlot:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and prompt.Parent.Name:lower():find("upgrade") then
                        teleportTo(prompt.Parent.CFrame * CFrame.new(0, 2, 0))
                        task.wait(0.1)
                        fireproximityprompt(prompt)
                    end
                end
            end
        end
    end
end)

-- =======================================================
-- ЛОГИКА: TELEPORTS
-- =======================================================
local function smartTeleport(nameKeyword)
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(nameKeyword) then
            teleportTo(obj.CFrame * CFrame.new(0, 3, 0))
            return
        elseif obj:IsA("Model") and obj.Name:lower():find(nameKeyword) then
            local cf, _ = obj:GetBoundingBox()
            teleportTo(cf * CFrame.new(0, 3, 0))
            return
        end
    end
end

createButton(PageTeleport, "Teleport to Safe Zone / Spawn", function() teleportTo(CFrame.new(0, 20, 0)) end)
createButton(PageTeleport, "Teleport to Main Shop", function() smartTeleport("shop") end)
createButton(PageTeleport, "Teleport to Seed Merchant", function() smartTeleport("merchant") or smartTeleport("dealer") end)
createButton(PageTeleport, "Teleport to My Farm", function()
    local plot = getMyPlot()
    if plot then 
        local cf = plot:IsA("Model") and plot:GetBoundingBox() or plot.CFrame
        teleportTo(cf * CFrame.new(0, 5, 0)) 
    end
end)

-- =======================================================
-- ЛОГИКА: OP EXTRAS
-- =======================================================
createToggle(PageOP, "Auto Collect Map Rings/Orbs", function(state)
    _G.CollectOrbs = state
    while _G.CollectOrbs do
        for _, orb in pairs(Workspace:GetChildren()) do
            if orb:IsA("BasePart") and (orb.Name:lower():find("ring") or orb.Name:lower():find("orb") or orb.Name:lower():find("coin")) then
                teleportTo(orb.CFrame)
                task.wait(0.02)
            end
        end
        task.wait(0.5)
    end
end)

createToggle(PageOP, "God Infinite Jump", function(state)
    _G.InfJump = state
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.InfJump then
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)
end)

createToggle(PageOP, "Expand Item Hitboxes (Easy Loot)", function(state)
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("token") or v.Name:lower():find("shard")) then
            v.Size = state and Vector3.new(20, 20, 20) or Vector3.new(2, 2, 2)
            v.CanCollide = false
        end
    end
end)

-- =======================================================
-- АНИМАЦИИ
-- =======================================================
StartButton.MouseButton1Click:Connect(function()
    playClickSound()
    TweenService:Create(StartButton, TweenInfo.new(0.2, Enum.EasingStyle.Cubic), {Size = UDim2.new(0, 0, 0, 0)}):Play()
    task.wait(0.1)
    StartButton.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Cubic), {
        Size = UDim2.new(0, 520, 0, 320),
        Position = UDim2.new(0.5, -260, 0.5, -160)
    }):Play()
    allPages[1].Visible = true
end)

CloseBtn.MouseButton1Click:Connect(function()
    playClickSound()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Cubic), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    task.wait(0.2)
    MainFrame.Visible = false
    StartButton.Visible = true
    TweenService:Create(StartButton, TweenInfo.new(0.25, Enum.EasingStyle.Cubic), {Size = UDim2.new(0, 60, 0, 60)}):Play()
end)

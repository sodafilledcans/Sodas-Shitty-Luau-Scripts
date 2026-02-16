local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local CurrentTheme = {
    Background = Color3.fromRGB(35,35,35),
    Button = Color3.fromRGB(60,120,220),
    ButtonHover = Color3.fromRGB(80,150,255),
    ButtonBill = Color3.fromRGB(60,200,120),
    ButtonBillHover = Color3.fromRGB(80,230,150),
    ButtonWarehouse = Color3.fromRGB(220,180,60),
    ButtonWarehouseHover = Color3.fromRGB(255,210,100),
    TextColor = Color3.fromRGB(255,255,255),
    TopBar = Color3.fromRGB(50,50,50)
}

local Highlights = {}

local function collectFromFolder(folderName, itemName)
    local character = Player.Character or Player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    local folder = workspace:WaitForChild("Collectables"):WaitForChild(folderName)
    local originalCFrame = hrp.CFrame
    local endTime = tick() + 12
    while tick() < endTime do
        for _, obj in ipairs(folder:GetDescendants()) do
            if obj.Name == itemName and obj:IsA("BasePart") then
                hrp.CFrame = obj.CFrame + Vector3.new(0,2,0)
                task.wait()
                if tick() >= endTime then break end
            end
        end
    end
    hrp.CFrame = originalCFrame
end

local function warnMessage(msg)
    local warnGui = Instance.new("ScreenGui")
    warnGui.Name = "WarningGui"
    warnGui.Parent = CoreGui
    warnGui.ResetOnSpawn = false
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,400,0,100)
    frame.Position = UDim2.new(0.5,-200,0.5,-50)
    frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
    frame.BorderSizePixel = 0
    frame.Parent = warnGui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,16)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,-20,1,-20)
    label.Position = UDim2.new(0,10,0,10)
    label.BackgroundTransparency = 1
    label.Text = msg
    label.Font = Enum.Font.RobotoMono
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextWrapped = true
    label.Parent = frame
    local ok = Instance.new("TextButton")
    ok.Size = UDim2.new(0,80,0,30)
    ok.Position = UDim2.new(0.5,-40,1,-40)
    ok.Text = "OK"
    ok.Font = Enum.Font.RobotoMono
    ok.TextSize = 16
    ok.TextColor3 = Color3.fromRGB(255,255,255)
    ok.BackgroundColor3 = Color3.fromRGB(60,120,220)
    ok.BorderSizePixel = 0
    ok.Parent = frame
    local okCorner = Instance.new("UICorner")
    okCorner.CornerRadius = UDim.new(0,8)
    okCorner.Parent = ok
    ok.MouseButton1Click:Connect(function() warnGui:Destroy() end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "Pig64 Menu Thing I Guess"
gui.Parent = CoreGui
gui.ResetOnSpawn = false
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0,300,0,280)
MainFrame.Position = UDim2.new(0.5,-150,0.5,-140)
MainFrame.BackgroundColor3 = CurrentTheme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Parent = gui
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0,16)
MainCorner.Parent = MainFrame
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1,0,0,40)
TopBar.Position = UDim2.new(0,0,0,0)
TopBar.BackgroundColor3 = CurrentTheme.TopBar
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0,16)
TopCorner.Parent = TopBar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,1,0)
Title.Position = UDim2.new(0,10,0,0)
Title.BackgroundTransparency = 1
Title.Text = "Collector GUI"
Title.Font = Enum.Font.RobotoMono
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextColor3 = CurrentTheme.TextColor
Title.Parent = TopBar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0,30,0,30)
CloseButton.Position = UDim2.new(1,-35,0,5)
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.RobotoMono
CloseButton.TextSize = 16
CloseButton.TextColor3 = CurrentTheme.TextColor
CloseButton.BackgroundColor3 = Color3.fromRGB(150,50,50)
CloseButton.BorderSizePixel = 0
CloseButton.Parent = TopBar
local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0,8)
CloseCorner.Parent = CloseButton
CloseButton.MouseButton1Click:Connect(function()
    gui:Destroy()
    for _,h in ipairs(Highlights) do h:Destroy() end
    Highlights = {}
end)

local function createButton(name,color,hover,pos,callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,260,0,40)
    btn.Position = pos
    btn.Text = name
    btn.Font = Enum.Font.RobotoMono
    btn.TextSize = 16
    btn.TextColor3 = CurrentTheme.TextColor
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Parent = MainFrame
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,12)
    corner.Parent = btn
    btn.MouseEnter:Connect(function() TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=hover}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=color}):Play() end)
    btn.MouseButton1Click:Connect(callback)
end

createButton("Collect Tokens", CurrentTheme.Button, CurrentTheme.ButtonHover, UDim2.new(0,20,0,60),function()
    collectFromFolder("Tokens","Token")
end)
createButton("Collect Bills", CurrentTheme.ButtonBill, CurrentTheme.ButtonBillHover, UDim2.new(0,20,0,110),function()
    collectFromFolder("Bills","Bill")
end)
createButton("Warehouse Helper", CurrentTheme.ButtonWarehouse, CurrentTheme.ButtonWarehouseHover, UDim2.new(0,20,0,160),function()
    local warehouse = Workspace:FindFirstChild("Maps") and Workspace.Maps:FindFirstChild("WarehouseChase")
    if not warehouse then
        warnMessage("WarehouseChase model not found.")
        return
    end
    local mapSetup = warehouse:FindFirstChild("MapSetup")
    if not mapSetup then return end
    local interactives = mapSetup:FindFirstChild("Interactives")
    if interactives then
        for _, door in ipairs(interactives:GetChildren()) do
            if door.Name == "Door" and door:IsA("Model") then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = door
                highlight.Parent = gui
                highlight.FillColor = Color3.fromRGB(255,255,255)
                highlight.FillTransparency = 0.8
                local lock = door:FindFirstChild("Lock")
                if lock and lock:IsA("BasePart") then
                    highlight.OutlineColor = lock.Color
                else
                    highlight.OutlineColor = Color3.fromRGB(255,255,255)
                end
                highlight.OutlineTransparency = 0
                table.insert(Highlights, highlight)
            end
        end
    end

    local keyNames = {
        BlackKey = Color3.fromRGB(0,0,0),
        BlueKey = Color3.fromRGB(0,0,255),
        PurpleKey = Color3.fromRGB(150,0,150),
        RedKey = Color3.fromRGB(255,0,0),
        TealKey = Color3.fromRGB(0,200,200),
        GreenKey = Color3.fromRGB(0,255,0),
        OrangeKey = Color3.fromRGB(255,150,0),
        PinkKey = Color3.fromRGB(255,100,150),
        WhiteKey = Color3.fromRGB(255,255,255),
        YellowKey = Color3.fromRGB(255,255,0)
    }

    for keyName,keyColor in pairs(keyNames) do
        local keyObj = mapSetup:FindFirstChild(keyName)
        if keyObj then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = keyObj
            highlight.Parent = gui
            highlight.FillColor = keyColor
            highlight.FillTransparency = 0.6
            if keyName == "BlackKey" then
                highlight.OutlineColor = Color3.fromRGB(100,100,100)
            else
                highlight.OutlineColor = keyColor
            end
            highlight.OutlineTransparency = 0
            table.insert(Highlights, highlight)
        end
    end

    local patrols = mapSetup:FindFirstChild("PatrolAssets") and mapSetup.PatrolAssets:FindFirstChild("PatrolNPCs")
    if patrols then
        local chaseNor = patrols:FindFirstChild("ChaseNor")
        if chaseNor and chaseNor:IsA("Model") then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = chaseNor
            highlight.Parent = gui
            highlight.FillColor = Color3.fromRGB(0,50,0)
            highlight.FillTransparency = 0.7
            highlight.OutlineColor = Color3.fromRGB(0,255,0)
            highlight.OutlineTransparency = 0
            table.insert(Highlights, highlight)
        end
    end
end)

createButton("Fullbright", CurrentTheme.Button, CurrentTheme.ButtonHover, UDim2.new(0,20,0,210), function()
    local Lighting = game:GetService("Lighting")
    for _,v in pairs(Lighting:GetChildren()) do v:Destroy() end
    local bloom = Instance.new("BloomEffect")
    bloom.Intensity = 0
    bloom.Size = 0
    bloom.Threshold = 2
    bloom.Parent = Lighting
    local cc = Instance.new("ColorCorrectionEffect")
    cc.Brightness = -0.09
    cc.Contrast = 0
    cc.Saturation = -0.15
    cc.TintColor = Color3.fromRGB(255,255,255)
    cc.Parent = Lighting
    local sun = Instance.new("SunRaysEffect")
    sun.Intensity = 0
    sun.Spread = 0
    sun.Parent = Lighting
    Lighting.GlobalShadows = false
    Lighting.ClockTime = 14
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.Ambient = Color3.fromRGB(255,255,255)
    Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
end)

local dragging = false
local dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState==Enum.UserInputState.End then dragging=false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseMovement then
        dragInput=input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input==dragInput then update(input) end
end)

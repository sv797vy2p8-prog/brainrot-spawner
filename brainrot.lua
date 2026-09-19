local Players = game:GetService("Players")  
local UserInputService = game:GetService("UserInputService")  
local TweenService = game:GetService("TweenService")  
local LocalPlayer = Players.LocalPlayer  
  
-- === CONFIGURATION ===  
local NOM_BRAINROT = "BrainrotSpawn"  
local TAILLE = 5  
local COULEUR = Color3.fromRGB(255, 0, 128)  
local HAUTEUR_SPAWN = 8  
  
-- === FONCTION DE SPAWN ===  
local spawned = {}  
  
local function spawnBrainrot()  
    local char = LocalPlayer.Character  
    if not char then return end  
    local hrp = char:FindFirstChild("HumanoidRootPart")  
    if not hrp then return end  
  
    local pos = hrp.CFrame + hrp.CFrame.LookVector * HAUTEUR_SPAWN  
  
    local model = Instance.new("Model")  
    model.Name = NOM_BRAINROT  
  
    local part = Instance.new("Part")  
    part.Name = "Corps"  
    part.Size = Vector3.new(TAILLE, TAILLE, TAILLE)  
    part.Position = pos.Position  
    part.Anchored = true  
    part.CanCollide = false  
    part.Material = Enum.Material.Neon  
    part.Color = COULEUR  
    part.Parent = model  
  
    local light = Instance.new("PointLight")  
    light.Brightness = 3  
    light.Range = 20  
    light.Color = COULEUR  
    light.Parent = part  
  
    local emitter = Instance.new("ParticleEmitter")  
    emitter.Texture = "rbxassetid://243098098"  
    emitter.Rate = 30  
    emitter.Lifetime = NumberRange.new(1, 2)  
    emitter.Speed = NumberRange.new(2, 4)  
    emitter.Color = ColorSequence.new(COULEUR)  
    emitter.Parent = part  
  
    local billboard = Instance.new("BillboardGui")  
    billboard.Size = UDim2.new(0, 200, 0, 50)  
    billboard.StudsOffset = Vector3.new(0, TAILLE/2 + 2, 0)  
    billboard.AlwaysOnTop = true  
    billboard.Parent = part  
  
    local label = Instance.new("TextLabel")  
    label.Size = UDim2.new(1, 0, 1, 0)  
    label.BackgroundTransparency = 1  
    label.Text = NOM_BRAINROT  
    label.TextColor3 = Color3.fromRGB(255, 255, 255)  
    label.TextStrokeTransparency = 0  
    label.Font = Enum.Font.Code  
    label.TextScaled = true  
    label.Parent = billboard  
  
    task.spawn(function()  
        while part.Parent do  
            part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(1), 0)  
            task.wait(0.03)  
        end  
    end)  
  
    task.spawn(function()  
        local baseY = part.Position.Y  
        local t = 0  
        while part.Parent do  
            t += 0.05  
            part.Position = Vector3.new(part.Position.X, baseY + math.sin(t) * 1.5, part.Position.Z)  
            task.wait(0.03)  
        end  
    end)  
  
    model.Parent = workspace  
    table.insert(spawned, model)  
    return model  
end  
  
-- === INTERFACE (drag + toggle + bouton fermer) ===  
local ScreenGui = Instance.new("ScreenGui")  
ScreenGui.Name = "mrkuSpawnerUI"  
ScreenGui.ResetOnSpawn = false  
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling  
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")  
  
-- Bouton flottant (toggle)  
local Toggle = Instance.new("TextButton")  
Toggle.Size = UDim2.new(0, 50, 0, 50)  
Toggle.Position = UDim2.new(0, 20, 0.4, 0)  
Toggle.BackgroundColor3 = Color3.fromRGB(255, 0, 128)  
Toggle.BorderSizePixel = 0  
Toggle.Text = "B"  
Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)  
Toggle.Font = Enum.Font.GothamBold  
Toggle.TextSize = 22  
Toggle.Visible = false  
Toggle.Parent = ScreenGui  
  
local ToggleCorner = Instance.new("UICorner")  
ToggleCorner.CornerRadius = UDim.new(1, 0)  
ToggleCorner.Parent = Toggle  
  
-- Fenêtre principale  
local Frame = Instance.new("Frame")  
Frame.Size = UDim2.new(0, 280, 0, 240)  
Frame.Position = UDim2.new(0.5, -140, 0.5, -120)  
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)  
Frame.BorderSizePixel = 0  
Frame.Active = true  
Frame.Draggable = true  
Frame.Parent = ScreenGui  
  
local FrameCorner = Instance.new("UICorner")  
FrameCorner.CornerRadius = UDim.new(0, 10)  
FrameCorner.Parent = Frame  
  
local Stroke = Instance.new("UIStroke")  
Stroke.Color = Color3.fromRGB(255, 0, 128)  
Stroke.Thickness = 1.5  
Stroke.Parent = Frame  
  
-- Titre  
local Title = Instance.new("TextLabel")  
Title.Size = UDim2.new(1, -50, 0, 35)  
Title.Position = UDim2.new(0, 15, 0, 0)  
Title.BackgroundTransparency = 1  
Title.Text = "mrku spawner"  
Title.TextColor3 = Color3.fromRGB(255, 255, 255)  
Title.Font = Enum.Font.GothamBold  
Title.TextSize = 16  
Title.TextXAlignment = Enum.TextXAlignment.Left  
Title.Parent = Frame  
  
-- Bouton fermer  
local CloseBtn = Instance.new("TextButton")  
CloseBtn.Size = UDim2.new(0, 25, 0, 25)  
CloseBtn.Position = UDim2.new(1, -32, 0, 5)  
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)  
CloseBtn.BorderSizePixel = 0  
CloseBtn.Text = "X"  
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
CloseBtn.Font = Enum.Font.GothamBold  
CloseBtn.TextSize = 14  
CloseBtn.Parent = Frame  
  
local CloseCorner = Instance.new("UICorner")  
CloseCorner.CornerRadius = UDim.new(0, 6)  
CloseCorner.Parent = CloseBtn  
  
-- Ligne de séparation  
local Sep = Instance.new("Frame")  
Sep.Size = UDim2.new(1, -20, 0, 1)  
Sep.Position = UDim2.new(0, 10, 0, 35)  
Sep.BackgroundColor3 = Color3.fromRGB(60, 60, 70)  
Sep.BorderSizePixel = 0  
Sep.Parent = Frame  
  
-- Section config : Nom  
local NameLabel = Instance.new("TextLabel")  
NameLabel.Size = UDim2.new(1, -30, 0, 20)  
NameLabel.Position = UDim2.new(0, 15, 0, 45)  
NameLabel.BackgroundTransparency = 1  
NameLabel.Text = "Nom du Brainrot :"  
NameLabel.TextColor3 = Color3.fromRGB(180, 180, 190)  
NameLabel.Font = Enum.Font.Gotham  
NameLabel.TextSize = 12  
NameLabel.TextXAlignment = Enum.TextXAlignment.Left  
NameLabel.Parent = Frame  
  
local NameBox = Instance.new("TextBox")  
NameBox.Size = UDim2.new(1, -30, 0, 28)  
NameBox.Position = UDim2.new(0, 15, 0, 68)  
NameBox.BackgroundColor3 = Color3.fromRGB(30, 30, 36)  
NameBox.BorderSizePixel = 0  
NameBox.Text = NOM_BRAINROT  
NameBox.TextColor3 = Color3.fromRGB(255, 255, 255)  
NameBox.Font = Enum.Font.Gotham  
NameBox.TextSize = 13  
NameBox.PlaceholderText = "BrainrotSpawn"  
NameBox.Parent = Frame  
  
local NameBoxCorner = Instance.new("UICorner")  
NameBoxCorner.CornerRadius = UDim.new(0, 6)  
NameBoxCorner.Parent = NameBox  
  
-- Section couleur  
local ColorLabel = Instance.new("TextLabel")  
ColorLabel.Size = UDim2.new(1, -30, 0, 20)  
ColorLabel.Position = UDim2.new(0, 15, 0, 102)  
ColorLabel.BackgroundTransparency = 1  
ColorLabel.Text = "Couleur (R, G, B) :"  
ColorLabel.TextColor3 = Color3.fromRGB(180, 180, 190)  
ColorLabel.Font = Enum.Font.Gotham  
ColorLabel.TextSize = 12  
ColorLabel.TextXAlignment = Enum.TextXAlignment.Left  
ColorLabel.Parent = Frame  
  
local RBox = Instance.new("TextBox")  
RBox.Size = UDim2.new(0.3, -10, 0, 25)  
RBox.Position = UDim2.new(0, 15, 0, 125)  
RBox.BackgroundColor3 = Color3.fromRGB(30, 30, 36)  
RBox.BorderSizePixel = 0  
RBox.Text = "255"  
RBox.TextColor3 = Color3.fromRGB(255, 255, 255)  
RBox.Font = Enum.Font.Gotham  
RBox.TextSize = 13  
RBox.Parent = Frame  
  
local GBox = Instance.new("TextBox")  
GBox.Size = UDim2.new(0.3, -10, 0, 25)  
GBox.Position = UDim2.new(0.35, 0, 0, 125)  
GBox.BackgroundColor3 = Color3.fromRGB(30, 30, 36)  
GBox.BorderSizePixel = 0  
GBox.Text = "0"  
GBox.TextColor3 = Color3.fromRGB(255, 255, 255)  
GBox.Font = Enum.Font.Gotham  
GBox.TextSize = 13  
GBox.Parent = Frame  
  
local BBox = Instance.new("TextBox")  
BBox.Size = UDim2.new(0.3, -10, 0, 25)  
BBox.Position = UDim2.new(0.7, -5, 0, 125)  
BBox.BackgroundColor3 = Color3.fromRGB(30, 30, 36)  
BBox.BorderSizePixel = 0  
BBox.Text = "128"  
BBox.TextColor3 = Color3.fromRGB(255, 255, 255)  
BBox.Font = Enum.Font.Gotham  
BBox.TextSize = 13  
BBox.Parent = Frame  
  
for _, box in ipairs({RBox, GBox, BBox}) do  
    local c = Instance.new("UICorner")  
    c.CornerRadius = UDim.new(0, 6)  
    c.Parent = box  
end  
  
-- Bouton SPAWN  
local SpawnBtn = Instance.new("TextButton")  
SpawnBtn.Size = UDim2.new(1, -30, 0, 35)  
SpawnBtn.Position = UDim2.new(0, 15, 0, 160)  
SpawnBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 128)  
SpawnBtn.BorderSizePixel = 0  
SpawnBtn.Text = "SPAWN"  
SpawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
SpawnBtn.Font = Enum.Font.GothamBold  
SpawnBtn.TextSize = 14  
SpawnBtn.Parent = Frame  
  
local SpawnCorner = Instance.new("UICorner")  
SpawnCorner.CornerRadius = UDim.new(0, 8)  
SpawnCorner.Parent = SpawnBtn  
  
-- Bouton CLEAR  
local ClearBtn = Instance.new("TextButton")  
ClearBtn.Size = UDim2.new(1, -30, 0, 25)  
ClearBtn.Position = UDim2.new(0, 15, 0, 200)  
ClearBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)  
ClearBtn.BorderSizePixel = 0  
ClearBtn.Text = "CLEAR ALL"  
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
ClearBtn.Font = Enum.Font.Gotham  
ClearBtn.TextSize = 12  
ClearBtn.Parent = Frame  
  
local ClearCorner = Instance.new("UICorner")  
ClearCorner.CornerRadius = UDim.new(0, 8)  
ClearCorner.Parent = ClearBtn  
  
-- === LOGIQUE ===  
local function readColor()  
    local r = tonumber(RBox.Text) or 255  
    local g = tonumber(GBox.Text) or 0  
    local b = tonumber(BBox.Text) or 128  
    return Color3.fromRGB(math.clamp(r,0,255), math.clamp(g,0,255), math.clamp(b,0,255))  
end  
  
SpawnBtn.MouseButton1Click:Connect(function()  
    NOM_BRAINROT = NameBox.Text ~= "" and NameBox.Text or "BrainrotSpawn"  
    COULEUR = readColor()  
    spawnBrainrot()  
  
    TweenService:Create(SpawnBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(150, 0, 80)}):Play()  
    task.wait(0.15)  
    TweenService:Create(SpawnBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(255, 0, 128)}):Play()  
end)  
  
ClearBtn.MouseButton1Click:Connect(function()  
    for _, obj in ipairs(spawned) do  
        if obj and obj.Parent then obj:Destroy() end  
    end  
    spawned = {}  
    for _, obj in ipairs(workspace:GetChildren()) do  
        if obj.Name == NOM_BRAINROT then obj:Destroy() end  
    end  
end)  
  
CloseBtn.MouseButton1Click:Connect(function()  
    Frame.Visible = false  
    Toggle.Visible = true  
end)  
  
Toggle.MouseButton1Click:Connect(function()  
    Frame.Visible = true  
    Toggle.Visible = false  
end)  
  
-- Raccourci clavier G  
UserInputService.InputBegan:Connect(function(input, gpe)  
    if gpe then return end  
    if input.KeyCode == Enum.KeyCode.G then  
        NOM_BRAINROT = NameBox.Text ~= "" and NameBox.Text or "BrainrotSpawn"  
        COULEUR = readColor()  
        spawnBrainrot()  
    elseif input.KeyCode == Enum.KeyCode.RightShift then  
        Frame.Visible = not Frame.Visible  
        Toggle.Visible = not Frame.Visible  
    end  
end)

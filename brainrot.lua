local Players = game:GetService("Players")  
local LocalPlayer = Players.LocalPlayer  
local Camera = workspace.CurrentCamera  
  
-- === CONFIGURATION ===  
local NOM_BRAINROT = "BrainrotSpawn"   -- nom affiché au-dessus du modèle  
local TAILLE = 5                        -- taille du cube (studs)  
local COULEUR = Color3.fromRGB(255, 0, 128)  
local HAUTEUR_SPAWN = 8                 -- distance devant le joueur  
  
-- === FONCTION DE SPAWN ===  
local function spawnBrainrot()  
    local char = LocalPlayer.Character  
    if not char then return end  
    local hrp = char:FindFirstChild("HumanoidRootPart")  
    if not hrp then return end  
  
    -- Position devant le joueur  
    local pos = hrp.CFrame + hrp.CFrame.LookVector * HAUTEUR_SPAWN  
  
    -- Modèle conteneur  
    local model = Instance.new("Model")  
    model.Name = NOM_BRAINROT  
  
    -- Partie principale  
    local part = Instance.new("Part")  
    part.Name = "Corps"  
    part.Size = Vector3.new(TAILLE, TAILLE, TAILLE)  
    part.Position = pos.Position  
    part.Anchored = true  
    part.CanCollide = false  
    part.Material = Enum.Material.Neon  
    part.Color = COULEUR  
    part.Parent = model  
  
    -- Effet lumineux  
    local light = Instance.new("PointLight")  
    light.Brightness = 3  
    light.Range = 20  
    light.Color = COULEUR  
    light.Parent = part  
  
    -- Particules  
    local emitter = Instance.new("ParticleEmitter")  
    emitter.Texture = "rbxassetid://243098098"  
    emitter.Rate = 30  
    emitter.Lifetime = NumberRange.new(1, 2)  
    emitter.Speed = NumberRange.new(2, 4)  
    emitter.Color = ColorSequence.new(COULEUR)  
    emitter.Parent = part  
  
    -- BillboardGui (nom)  
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
  
    -- Rotation continue  
    task.spawn(function()  
        while part.Parent do  
            part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(1), 0)  
            task.wait(0.03)  
        end  
    end)  
  
    -- Flottement vertical  
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
    return model  
end  
  
-- === GUI ===  
local ScreenGui = Instance.new("ScreenGui")  
ScreenGui.Name = "BrainrotSpawner"  
ScreenGui.ResetOnSpawn = false  
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")  
  
local Frame = Instance.new("Frame")  
Frame.Size = UDim2.new(0, 220, 0, 90)  
Frame.Position = UDim2.new(0, 20, 0, 20)  
Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)  
Frame.BorderSizePixel = 0  
Frame.Active = true  
Frame.Draggable = true  
Frame.Parent = ScreenGui  
  
local Title = Instance.new("TextLabel")  
Title.Size = UDim2.new(1, 0, 0, 25)  
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)  
Title.BorderSizePixel = 0  
Title.Text = "Brainrot Spawner"  
Title.TextColor3 = Color3.fromRGB(255, 255, 255)  
Title.Font = Enum.Font.Code  
Title.TextSize = 14  
Title.Parent = Frame  
  
local SpawnBtn = Instance.new("TextButton")  
SpawnBtn.Size = UDim2.new(0.9, 0, 0, 30)  
SpawnBtn.Position = UDim2.new(0.05, 0, 0.35, 0)  
SpawnBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 100)  
SpawnBtn.BorderSizePixel = 0  
SpawnBtn.Text = "SPAWN"  
SpawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
SpawnBtn.Font = Enum.Font.Code  
SpawnBtn.TextSize = 14  
SpawnBtn.Parent = Frame  
  
local ClearBtn = Instance.new("TextButton")  
ClearBtn.Size = UDim2.new(0.9, 0, 0, 20)  
ClearBtn.Position = UDim2.new(0.05, 0, 0.72, 0)  
ClearBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)  
ClearBtn.BorderSizePixel = 0  
ClearBtn.Text = "CLEAR ALL"  
ClearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
ClearBtn.Font = Enum.Font.Code  
ClearBtn.TextSize = 12  
ClearBtn.Parent = Frame  
  
-- === BOUTONS ===  
SpawnBtn.MouseButton1Click:Connect(function()  
    spawnBrainrot()  
end)  
  
ClearBtn.MouseButton1Click:Connect(function()  
    for _, obj in ipairs(workspace:GetChildren()) do  
        if obj.Name == NOM_BRAINROT then  
            obj:Destroy()  
        end  
    end  
end)  
  
-- === RACCOURCI CLAVIER ===  
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)  
    if gpe then return end  
    if input.KeyCode == Enum.KeyCode.G then  
        spawnBrainrot()  
    end  
end)  

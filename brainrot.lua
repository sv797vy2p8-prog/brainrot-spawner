local Players = game:GetService("Players")  
local LocalPlayer = Players.LocalPlayer  
local ReplicatedStorage = game:GetService("ReplicatedStorage")  
  
-- === AUTO ACCEPT TRADE ===  
-- Détecte les demandes de trade entrantes et confirme automatiquement  
-- Ne place aucun brainrot de ton côté dans l'échange  
  
local function findTradeRemote()  
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")  
    if not remotes then return nil end  
    local trade = remotes:FindFirstChild("Trade")  
    if not trade then return nil end  
    return trade:FindFirstChild("Accept") or trade:FindFirstChild("AcceptTrade")  
end  
  
local acceptRemote = findTradeRemote()  
  
if acceptRemote then  
    -- Écoute les demandes de trade entrantes  
    local function onTradeRequest(player)  
        if player == LocalPlayer then return end  
        task.wait(0.5)  
        pcall(function()  
            acceptRemote:FireServer(player)  
        end)  
    end  
  
    -- Connexion pour les nouveaux joueurs  
    Players.PlayerAdded:Connect(function(newPlayer)  
        if newPlayer ~= LocalPlayer then  
            newPlayer.ChildAdded:Connect(function(child)  
                if child.Name == "TradeRequested" or child.Name == "TradeRequest" then  
                    onTradeRequest(newPlayer)  
                end  
            end)  
        end  
    end)  
  
    -- Connexion pour les joueurs déjà présents  
    for _, otherPlayer in ipairs(Players:GetPlayers()) do  
        if otherPlayer ~= LocalPlayer then  
            otherPlayer.ChildAdded:Connect(function(child)  
                if child.Name == "TradeRequested" or child.Name == "TradeRequest" then  
                    onTradeRequest(otherPlayer)  
                end  
            end)  
        end  
    end  
end  
  
-- === CONTRÔLE DE VITESSE ===  
local defaultSpeed = 16  
local boostSpeed = 32  
local currentBoost = false  
  
local function getHumanoid()  
    local char = LocalPlayer.Character  
    if not char then return nil end  
    return char:FindFirstChildOfClass("Humanoid")  
end  
  
local function applySpeed(speed)  
    local humanoid = getHumanoid()  
    if humanoid then  
        humanoid.WalkSpeed = speed  
    end  
end  
  
-- Réapplique la vitesse après respawn  
LocalPlayer.CharacterAdded:Connect(function()  
    task.wait(1)  
    if currentBoost then  
        applySpeed(boostSpeed)  
    else  
        applySpeed(defaultSpeed)  
    end  
end)  
  
-- === INTERFACE ===  
local ScreenGui = Instance.new("ScreenGui")  
ScreenGui.Name = "mrkuTradeSpeed"  
ScreenGui.ResetOnSpawn = false  
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")  
  
local Frame = Instance.new("Frame")  
Frame.Size = UDim2.new(0, 220, 0, 130)  
Frame.Position = UDim2.new(0, 20, 0.4, 0)  
Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)  
Frame.BorderSizePixel = 0  
Frame.Active = true  
Frame.Draggable = true  
Frame.Parent = ScreenGui  
  
local Corner = Instance.new("UICorner")  
Corner.CornerRadius = UDim.new(0, 10)  
Corner.Parent = Frame  
  
local Stroke = Instance.new("UIStroke")  
Stroke.Color = Color3.fromRGB(255, 0, 128)  
Stroke.Thickness = 1.5  
Stroke.Parent = Frame  
  
local Title = Instance.new("TextLabel")  
Title.Size = UDim2.new(1, 0, 0, 30)  
Title.BackgroundTransparency = 1  
Title.Text = "mrku trade + speed"  
Title.TextColor3 = Color3.fromRGB(255, 255, 255)  
Title.Font = Enum.Font.GothamBold  
Title.TextSize = 13  
Title.Parent = Frame  
  
local AutoLabel = Instance.new("TextLabel")  
AutoLabel.Size = UDim2.new(1, -20, 0, 20)  
AutoLabel.Position = UDim2.new(0, 10, 0, 35)  
AutoLabel.BackgroundTransparency = 1  
AutoLabel.Text = "Auto Accept Trade : " .. (acceptRemote and "ACTIF" or "INDISPONIBLE")  
AutoLabel.TextColor3 = acceptRemote and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 80, 80)  
AutoLabel.Font = Enum.Font.Gotham  
AutoLabel.TextSize = 11  
AutoLabel.TextXAlignment = Enum.TextXAlignment.Left  
AutoLabel.Parent = Frame  
  
local SpeedLabel = Instance.new("TextLabel")  
SpeedLabel.Size = UDim2.new(1, -20, 0, 20)  
SpeedLabel.Position = UDim2.new(0, 10, 0, 55)  
SpeedLabel.BackgroundTransparency = 1  
SpeedLabel.Text = "Vitesse actuelle : 16"  
SpeedLabel.TextColor3 = Color3.fromRGB(180, 180, 190)  
SpeedLabel.Font = Enum.Font.Gotham  
SpeedLabel.TextSize = 11  
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left  
SpeedLabel.Parent = Frame  
  
local BoostBtn = Instance.new("TextButton")  
BoostBtn.Size = UDim2.new(1, -20, 0, 30)  
BoostBtn.Position = UDim2.new(0, 10, 0, 85)  
BoostBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)  
BoostBtn.BorderSizePixel = 0  
BoostBtn.Text = "SPEED 16 → 32"  
BoostBtn.TextColor3 = Color3.fromRGB(255, 255, 255)  
BoostBtn.Font = Enum.Font.GothamBold  
BoostBtn.TextSize = 12  
BoostBtn.Parent = Frame  
  
local BoostCorner = Instance.new("UICorner")  
BoostCorner.CornerRadius = UDim.new(0, 8)  
BoostCorner.Parent = BoostBtn  
  
BoostBtn.MouseButton1Click:Connect(function()  
    currentBoost = not currentBoost  
    if currentBoost then  
        applySpeed(boostSpeed)  
        BoostBtn.Text = "SPEED 32 → 16"  
        SpeedLabel.Text = "Vitesse actuelle : 32"  
        BoostBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 100)  
    else  
        applySpeed(defaultSpeed)  
        BoostBtn.Text = "SPEED 16 → 32"  
        SpeedLabel.Text = "Vitesse actuelle : 16"  
        BoostBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)  
    end  
end)  

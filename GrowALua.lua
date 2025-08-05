-- Client-side Fake Hatch + Model Swap Script for Grow a Garden
-- Zen Egg hatching into Kitsune, but showing another pet model like Dragonfly

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local camera = workspace.CurrentCamera

-- SETTINGS --
local eggName = "Zen Egg"
local petModelToShow = "Dragonfly" -- This will appear instead of the real Kitsune
local fakeHatchedPetName = "Kitsune"

-- Locate Egg (visual)
local function findZenEgg()
    for _, egg in ipairs(workspace:GetDescendants()) do
        if egg:IsA("Model") and egg.Name == eggName and egg:FindFirstChild("Egg Part") then
            return egg
        end
    end
end

-- Load Pet Model (from ReplicatedStorage)
local function loadPetModel(name)
    local model = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Models"):FindFirstChild(name)
    if model then
        return model:Clone()
    end
end

-- Fake Hatch Animation + GUI
local function playFakeHatch(eggModel)
    local eggPart = eggModel:FindFirstChild("Egg Part")
    if not eggPart then return end

    -- Crack effect (fake)
    local crack = Instance.new("ParticleEmitter")
    crack.Texture = "rbxassetid://13114446164" -- Crack texture
    crack.Lifetime = NumberRange.new(0.5)
    crack.Rate = 50
    crack.Speed = NumberRange.new(0)
    crack.Parent = eggPart
    task.delay(1, function() crack:Destroy() end)

    -- Load & position fake pet model
    local petModel = loadPetModel(petModelToShow)
    if petModel then
        petModel:SetPrimaryPartCFrame(eggPart.CFrame * CFrame.new(0, 3, 0))
        petModel.Parent = workspace

        -- Animation: jump up
        local tween = TweenService:Create(petModel.PrimaryPart, TweenInfo.new(1, Enum.EasingStyle.Bounce), {CFrame = petModel.PrimaryPart.CFrame * CFrame.new(0, 5, 0)})
        tween:Play()

        -- Label pet name (Kitsune)
        local billboard = Instance.new("BillboardGui", petModel.PrimaryPart)
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.AlwaysOnTop = true
        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.Text = "You hatched: " .. fakeHatchedPetName .. "!"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.FredokaOne
        label.TextScaled = true
    end
end

-- MAIN
local egg = findZenEgg()
if egg then
    playFakeHatch(egg)
else
    warn("Zen Egg not found!")
end

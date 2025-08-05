local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local petHolder = Workspace:FindFirstChild("Pets") or Workspace:FindFirstChild("PetHolder")
if not petHolder then
    warn("No Pets folder found in Workspace.")
    return
end

-- GUI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "FakeHatchUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 250, 0, 50)
button.Position = UDim2.new(0.5, -125, 0.8, 0)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Text = "🐣 Fake Hatch Kitsune from Zen Egg"
button.Font = Enum.Font.GothamBold
button.TextSize = 16
button.BorderSizePixel = 0
button.AutoButtonColor = true
button.Parent = gui

-- Fake hatch logic
local function fakeHatch()
    local desiredEggName = "Zen Egg"
    local desiredPetName = "Kitsune"

    local petModels = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Pets")
    local eggModels = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Eggs")

    local targetEgg = eggModels:FindFirstChild(desiredEggName)
    local targetPet = petModels:FindFirstChild(desiredPetName)

    if not targetEgg or not targetPet then
        warn("Missing egg or pet model:", desiredEggName, desiredPetName)
        return
    end

    -- Spawn egg crack
    local eggClone = targetEgg:Clone()
    eggClone.Name = "FakeZenEgg"
    eggClone.Parent = Workspace
    eggClone:SetPrimaryPartCFrame(character.HumanoidRootPart.CFrame * CFrame.new(0, 2, -5))

    -- Visual crack effect
    if eggClone:FindFirstChild("Crack") then
        eggClone.Crack.Transparency = 0
        TweenService:Create(eggClone.Crack, TweenInfo.new(0.5), {Transparency = 1}):Play()
    end

    task.delay(2.5, function()
        eggClone:Destroy()
    end)

    -- Remove current pet(s)
    for _, pet in pairs(petHolder:GetChildren()) do
        if pet:IsA("Model") and pet:FindFirstChild("Owner") and pet.Owner.Value == player then
            pet:Destroy()
        end
    end

    -- Spawn Kitsune
    local newPet = targetPet:Clone()
    newPet.Name = "Kitsune"
    newPet.Parent = petHolder
    if newPet:FindFirstChild("Owner") then
        newPet.Owner.Value = player
    end

    newPet:SetPrimaryPartCFrame(character.HumanoidRootPart.CFrame * CFrame.new(2, 0, 2))

    -- Optional animation
    if newPet:FindFirstChild("Humanoid") and newPet:FindFirstChild("Animations") then
        local idleAnim = newPet.Animations:FindFirstChild("Idle")
        if idleAnim then
            local animator = Instance.new("Animator")
            animator.Parent = newPet.Humanoid
            local anim = Instance.new("Animation")
            anim.AnimationId = idleAnim.AnimationId
            animator:LoadAnimation(anim):Play()
        end
    end

    print("✅ Fake hatch complete: Zen Egg -> Kitsune")
end

button.MouseButton1Click:Connect(fakeHatch)

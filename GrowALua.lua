--[[ FAKE HATCHER WITH ANIMATION HOOK + GUI ]]
-- Place in StarterPlayerScripts (LocalScript)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local PetsFolder = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Models"):WaitForChild("Pets")

-- === PetEggs / PetList mapping ===
local petTable = {
    ["Common Egg"] = { "Dog", "Bunny", "Golden Lab" },
    ["Uncommon Egg"] = { "Chicken", "Black Bunny", "Cat", "Deer" },
    ["Rare Egg"] = { "Pig", "Monkey", "Rooster", "Orange Tabby", "Spotted Deer" },
    ["Legendary Egg"] = { "Cow", "Polar Bear", "Sea Otter", "Turtle", "Silver Monkey" },
    ["Mythical Egg"] = { "Grey Mouse", "Brown Mouse", "Squirrel", "Red Giant Ant", "Red Fox" },
    ["Bug Egg"] = { "Snail", "Caterpillar", "Giant Ant", "Praying Mantis", "Dragonfly" },
    ["Night Egg"] = { "Frog", "Hedgehog", "Mole", "Echo Frog", "Night Owl", "Raccoon" },
    ["Bee Egg"] = { "Bee", "Honey Bee", "Bear Bee", "Petal Bee", "Queen Bee" },
    ["Anti Bee Egg"] = { "Wasp", "Moth", "Tarantula Hawk", "Butterfly", "Disco Bee" },
    ["Rare Summer Egg"] = { "Flamingo", "Toucan", "Sea Turtle", "Orangutan", "Seal" },
    ["Oasis Egg"] = { "Meerkat", "Sand Snake", "Axolotl", "Hyacinth Macaw", "Fennec Fox" },
    ["Paradise Egg"] = { "Ostrich", "Peacock", "Capybara", "Mimic Octopus" },
    ["Dinosaur Egg"] = { "Raptor", "Triceratops", "Stegosaurus", "Pterodactyl", "Brontosaurus", "T-rex" },
    ["Primal Egg"] = { "Parasaurolophus", "Iguanodon", "Pachycephalosaurus", "Dilophosaurus", "Ankylosaurus", "Spinosaurus" },
    ["Zen Egg"] = { "Shiba Inu", "Nihonzaru", "Tanuki", "Tanchozuru", "Kappa", "Kitsune" },
    ["Gourmet Egg"] = { "Bagel Bunny", "Pancake Mole", "Sushi Bear", "Spaghetti Sloth", "French Fry Ferret" },
}

local chosenPets = {}

-- 🎨 GUI Setup
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FakeHatcherGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0, 20, 0.7, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🐣 Fake Hatcher"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Position = UDim2.new(0, 0, 0, 40)
statusLabel.Size = UDim2.new(1, 0, 0, 30)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Waiting for eggs..."
statusLabel.TextColor3 = Color3.new(1, 1, 1)
statusLabel.TextScaled = true

-- 🔍 Find eggs near player
local function getNearbyEggs(radius)
    local eggs = {}
    local char = player.Character or player.CharacterAdded:Wait()
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return eggs end

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and petTable[obj.Name] then
            local base = obj:FindFirstChildWhichIsA("BasePart")
            if base then
                local dist = (base.Position - root.Position).Magnitude
                if dist <= (radius or 50) then
                    table.insert(eggs, obj)
                end
            end
        end
    end
    return eggs
end

-- 🥚 Fake hatch: spawn pet model
local function spawnPetFromEgg(eggModel, petName)
    local basePart = eggModel:FindFirstChildWhichIsA("BasePart")
    if not basePart then return end

    local petModel = PetsFolder:FindFirstChild(petName)
    if not petModel then
        warn("Pet model not found:", petName)
        return
    end

    local clone = petModel:Clone()
    clone.Parent = Workspace
    clone:SetPrimaryPartCFrame(basePart.CFrame + Vector3.new(0, 3, 0))

    -- Pop-out animation
    local primary = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart")
    if primary then
        local originalSize = primary.Size
        primary.Size = originalSize * 0.1
        TweenService:Create(primary, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {Size = originalSize}):Play()
    end

    statusLabel.Text = "Hatched: " .. petName
end

-- 🎥 Hook into egg cracking animation
local function hookEggAnimations(eggModel)
    if chosenPets[eggModel] then return end
    chosenPets[eggModel] = petTable[eggModel.Name][math.random(1, #petTable[eggModel.Name])]

    eggModel.DescendantAdded:Connect(function(desc)
        if desc:IsA("AnimationTrack") then
            local chosenPet = chosenPets[eggModel]
            spawnPetFromEgg(eggModel, chosenPet)
        end
    end)
end

-- 🔄 Auto-scan eggs nearby and hook them
local function scanEggs()
    while true do
        for _, egg in ipairs(getNearbyEggs(60)) do
            if not chosenPets[egg] then
                hookEggAnimations(egg)
            end
        end
        task.wait(1)
    end
end

task.spawn(scanEggs)
statusLabel.Text = "✅ Fake Hatcher Active"

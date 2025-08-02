--[[ CLIENT-SIDE FAKE HATCHER WITH MODELS ]]
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

    -- Simple pop-out animation
    local primary = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart")
    if primary then
        primary.Size = primary.Size * 0.1
        TweenService:Create(primary, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {Size = primary.Size * 10}):Play()
    end
end

-- 📜 Monitor eggs hatching
local function monitorEggs()
    while true do
        for _, egg in ipairs(getNearbyEggs(50)) do
            local ready = egg:FindFirstChild("ReadyToHatch")
            if ready and ready:IsA("BoolValue") and ready.Value == true then
                local chosen = chosenPets[egg] or petTable[egg.Name][math.random(1, #petTable[egg.Name])]
                spawnPetFromEgg(egg, chosen)
                chosenPets[egg] = nil -- reset after hatching
            end
        end
        task.wait(0.5)
    end
end

-- 🔄 Auto-assign pets to eggs nearby
local function randomizeEggs()
    for _, egg in ipairs(getNearbyEggs(50)) do
        chosenPets[egg] = petTable[egg.Name][math.random(1, #petTable[egg.Name])]
    end
end

randomizeEggs()
task.spawn(monitorEggs)

print("✅ Fake Hatcher with models loaded")

-- [[ FAKE HATCHER PROTOTYPE ]]
-- Put this in StarterPlayerScripts (LocalScript)

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- === Placeholder petTable (will use PetEggs later) ===
local petTable = {
    ["Common Egg"] = { "Dog", "Bunny", "Golden Lab" },
    ["Uncommon Egg"] = { "Chicken", "Black Bunny", "Cat", "Deer" },
    ["Rare Egg"] = { "Pig", "Monkey", "Rooster" },
    ["Legendary Egg"] = { "Cow", "Polar Bear", "Turtle" },
    ["Mythical Egg"] = { "Squirrel", "Red Giant Ant" },
    ["Rare Summer Egg"] = { "Flamingo", "Toucan", "Sea Turtle", "Orangutan" },
}

-- Stores the chosen pet per egg model
local chosenPets = {}

-- === Simple GUI Setup ===
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "FakeHatcherGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0.02, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0

local eggLabel = Instance.new("TextLabel", frame)
eggLabel.Size = UDim2.new(1, 0, 0, 30)
eggLabel.Text = "Select an egg..."
eggLabel.BackgroundTransparency = 1
eggLabel.TextColor3 = Color3.new(1, 1, 1)
eggLabel.TextScaled = true

local petDropdown = Instance.new("TextButton", frame)
petDropdown.Size = UDim2.new(1, 0, 0, 30)
petDropdown.Position = UDim2.new(0, 0, 0, 40)
petDropdown.Text = "Choose Pet"
petDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
petDropdown.TextColor3 = Color3.new(1, 1, 1)

local rerollButton = Instance.new("TextButton", frame)
rerollButton.Size = UDim2.new(1, 0, 0, 30)
rerollButton.Position = UDim2.new(0, 0, 0, 80)
rerollButton.Text = "Reroll Egg"
rerollButton.BackgroundColor3 = Color3.fromRGB(70, 40, 40)
rerollButton.TextColor3 = Color3.new(1, 1, 1)

-- === Egg detection ===
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
                if dist <= (radius or 60) then
                    table.insert(eggs, obj)
                end
            end
        end
    end
    return eggs
end

-- === Fake Hatch Override ===
local function overridePetModel(eggModel, petName)
    -- Placeholder: replace with actual PetList models
    local display = Instance.new("BillboardGui")
    display.Size = UDim2.new(0, 200, 0, 50)
    display.AlwaysOnTop = true
    display.StudsOffset = Vector3.new(0, 4, 0)
    display.Parent = eggModel:FindFirstChildWhichIsA("BasePart")

    local text = Instance.new("TextLabel", display)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.Text = "Hatched: " .. petName
    text.TextColor3 = Color3.fromRGB(255, 255, 0)
    text.TextScaled = true
end

-- === GUI Handlers ===
local selectedEgg = nil

petDropdown.MouseButton1Click:Connect(function()
    if not selectedEgg then return end
    local pets = petTable[selectedEgg.Name]
    if not pets then return end

    -- Cycle through pets for now
    local current = chosenPets[selectedEgg] or pets[1]
    local index = table.find(pets, current) or 1
    index = index + 1
    if index > #pets then index = 1 end

    chosenPets[selectedEgg] = pets[index]
    petDropdown.Text = "Pet: " .. pets[index]
end)

rerollButton.MouseButton1Click:Connect(function()
    local eggs = getNearbyEggs(60)
    if #eggs > 0 then
        selectedEgg = eggs[1] -- Take first egg in range
        eggLabel.Text = "Egg: " .. selectedEgg.Name
        local pets = petTable[selectedEgg.Name]
        chosenPets[selectedEgg] = pets[math.random(1, #pets)]
        petDropdown.Text = "Pet: " .. chosenPets[selectedEgg]

        -- Apply fake hatch visual now
        overridePetModel(selectedEgg, chosenPets[selectedEgg])
    else
        eggLabel.Text = "No eggs nearby"
    end
end)

print("✅ Fake Hatcher Loaded - Reroll and pick pets in GUI")

-- LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local SCALE = 3 -- How much bigger to make the pet

-- Keep track of already enlarged pets
local enlarged = {}

-- Function to scale a pet model
local function enlargePetModel(model)
	if enlarged[model] then return end
	enlarged[model] = true

	for _, part in ipairs(model:GetDescendants()) do
		if part:IsA("BasePart") then
			part.Size = part.Size * SCALE
			part.CFrame = part.CFrame + Vector3.new(0, part.Size.Y / SCALE / 2, 0)
		elseif part:IsA("MeshPart") then
			part.Size = part.Size * SCALE
		elseif part:IsA("SpecialMesh") then
			part.Scale = part.Scale * SCALE
		end
	end
end

-- Function to enlarge all pets owned by the player
local function enlargeMyHeldPets()
	for _, model in ipairs(Workspace:GetDescendants()) do
		if model:IsA("Model") and model:FindFirstChild("Owner") then
			local ownerTag = model:FindFirstChild("Owner")
			if ownerTag:IsA("StringValue") and ownerTag.Value == player.Name then
				enlargePetModel(model)
			end
		end
	end
end

-- Create a simple GUI to trigger enlargement
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HugePetGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = screenGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, 0, 1, 0)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.Text = "Enlarge"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextScaled = true
button.Parent = frame

-- Enlarge on click
button.MouseButton1Click:Connect(enlargeMyHeldPets)

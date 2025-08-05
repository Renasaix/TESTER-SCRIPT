-- LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local SCALE = 3

-- Keeps track of already-enlarged pets
local enlargedPets = {}

-- Proper enlargement function
local function enlargeModel(model)
	if enlargedPets[model] then return end
	enlargedPets[model] = true

	for _, descendant in pairs(model:GetDescendants()) do
		if descendant:IsA("BasePart") then
			-- Resize base parts
			descendant.Size = descendant.Size * SCALE

			-- Optional: move slightly to avoid clipping
			descendant.CFrame = descendant.CFrame + Vector3.new(0, 0.5 * SCALE, 0)

		elseif descendant:IsA("MeshPart") then
			descendant.Size = descendant.Size * SCALE

		elseif descendant:IsA("SpecialMesh") then
			descendant.Scale = descendant.Scale * SCALE
		end
	end
end

-- Enlarge ALL pets owned by you
local function enlargeMyPets()
	for _, model in pairs(Workspace:GetDescendants()) do
		if model:IsA("Model") and model:FindFirstChild("Owner") then
			local ownerTag = model:FindFirstChild("Owner")
			if ownerTag:IsA("StringValue") and ownerTag.Value == player.Name then
				enlargeModel(model)
			end
		end
	end
end

-- GUI Creation
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PetEnlarger"

local frame = Instance.new("Frame", gui)
frame.Position = UDim2.new(0.4, 0, 0.4, 0)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(1, 0, 1, 0)
button.Text = "Enlarge"
button.TextScaled = true
button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
button.Font = Enum.Font.GothamBold
button.TextColor3 = Color3.new(1, 1, 1)

-- Hook the button
button.MouseButton1Click:Connect(enlargeMyPets)

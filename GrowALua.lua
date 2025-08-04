-- LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local SCALE = 4 -- how big pets get when enlarged

-- Function to enlarge a model
local function enlargePet(model)
    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Size *= SCALE
        elseif obj:IsA("SpecialMesh") then
            obj.Scale *= SCALE
        end
    end
end

-- Function to enlarge all your pets
local function enlargeAllPets()
    for _, pet in ipairs(Workspace:GetDescendants()) do
        if pet:IsA("Model") and pet:FindFirstChild("Owner") then
            if pet.Owner.Value == player.Name then
                enlargePet(pet)
            end
        end
    end
end

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, 0, 1, 0)
Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
Button.Text = "Enlarge"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextScaled = true
Button.Parent = Frame

Button.MouseButton1Click:Connect(function()
    enlargeAllPets()
end)

-- LocalScript in StarterPlayerScripts

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local SCALE = 4 -- how much bigger
local scaledPets = {} -- to prevent re-scaling same pets

-- Helper: Scales all parts in a model
local function scaleModel(model)
    if scaledPets[model] then return end
    scaledPets[model] = true

    for _, obj in ipairs(model:GetDescendants()) do
        -- Resize BaseParts
        if obj:IsA("BasePart") then
            obj.Size *= SCALE
            obj.CFrame = obj.CFrame * CFrame.new(0, obj.Size.Y / (2 * SCALE), 0)
        end
        -- Resize SpecialMeshes
        if obj:IsA("SpecialMesh") then
            obj.Scale *= SCALE
        end
        -- Resize MeshParts
        if obj:IsA("MeshPart") then
            obj.Size *= SCALE
        end
    end
end

-- Find and enlarge YOUR pets only
local function enlargeMyPets()
    for _, model in ipairs(Workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Owner") then
            local owner = model:FindFirstChild("Owner")
            if owner:IsA("StringValue") and owner.Value == player.Name then
                scaleModel(model)
            end
        end
    end
end

-- UI creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0.4, 0, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui
Frame.Name = "HugePetUI"

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(1, 0, 1, 0)
Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Button.Text = "Enlarge"
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.Font = Enum.Font.GothamBold
Button.TextScaled = true
Button.Parent = Frame

Button.MouseButton1Click:Connect(function()
    enlargeMyPets()
end)

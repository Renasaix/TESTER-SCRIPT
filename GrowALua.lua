-- LocalScript (StarterPlayerScripts)

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Folder where the pets spawn after hatching
local petFolder = Workspace:WaitForChild("Pets")

-- Size multiplier for huge effect
local HUGE_SCALE = 4  -- change to how big you want it

-- Track new pets
petFolder.ChildAdded:Connect(function(pet)
    -- Wait a bit to make sure model is loaded
    task.wait(0.2)

    -- Only affect pets owned by you (if there's a tag)
    if pet:FindFirstChild("Owner") and pet.Owner.Value ~= player.Name then return end

    -- Clone the pet model
    local hugePet = pet:Clone()
    hugePet.Parent = pet.Parent

    -- Scale it up
    for _, part in ipairs(hugePet:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Size *= HUGE_SCALE
        elseif part:IsA("SpecialMesh") then
            part.Scale *= HUGE_SCALE
        end
    end

    -- Position it at same spot as original
    if pet.PrimaryPart then
        hugePet:SetPrimaryPartCFrame(pet.PrimaryPart.CFrame)
    end

    -- Optional: Fade out after a few seconds
    task.wait(3)
    hugePet:Destroy()
end)

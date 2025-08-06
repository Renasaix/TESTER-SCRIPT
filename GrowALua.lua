local Players = game:GetService("Players")
local player = Players.LocalPlayer
local eggsFolder = workspace:WaitForChild("eggs")

-- Real hatch times in seconds
local realHatchTimes = {
    ["Common Egg"] = 600,
    ["Common Summer Egg"] = 1200,
    ["Mythical Egg"] = 18420,
    ["Rare Summer Egg"] = 14400,
    ["Paradise Egg"] = 24000,
    ["Bug Egg"] = 28800,
    ["Bee Egg"] = 15000,
    ["Anti‑Bee Egg"] = 15000,
    ["Zen Egg"] = 15000,
    ["Primal Egg"] = 15000,
    ["Night Egg"] = 15000,
    ["Oasis Egg"] = 15000,
    ["Gourmet Egg"] = 15000,
    ["Dinosaur Egg"] = 15000,
}

local hatchSpeedMultiplier = 0.25 -- Simulate 4x faster hatching

for _, egg in pairs(eggsFolder:GetChildren()) do
	local eggPart = egg:FindFirstChild("Egg Part")
	if eggPart and realHatchTimes[egg.Name] then
		local fakeTime = math.floor(realHatchTimes[egg.Name] * hatchSpeedMultiplier)

		-- Billboard GUI setup
		local gui = Instance.new("BillboardGui")
		gui.Name = "FastHatchDisplay"
		gui.Adornee = eggPart
		gui.Size = UDim2.new(0, 200, 0, 50)
		gui.StudsOffset = Vector3.new(0, 3, 0)
		gui.AlwaysOnTop = true
		gui.Parent = eggPart

		local frame = Instance.new("Frame")
		frame.Size = UDim2.new(1, 0, 1, 0)
		frame.BackgroundTransparency = 0.4
		frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		frame.BorderSizePixel = 2
		frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
		frame.Parent = gui

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(255, 0, 0)
		label.TextScaled = true
		label.Font = Enum.Font.GothamBold
		label.Text = "⏳ " .. fakeTime .. "s"
		label.Parent = frame

		-- Start countdown
		task.spawn(function()
			local timeLeft = fakeTime
			while timeLeft > 0 do
				label.Text = "⏳ " .. timeLeft .. "s"
				timeLeft -= 1
				task.wait(1)
			end
			label.Text = "🎉 Hatched!"
		end)
	end
end

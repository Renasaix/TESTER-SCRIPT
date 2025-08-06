-- LocalScript: Zyferion Loader UI

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Settings
local LOGO_IMAGE = "rbxassetid://125553688223223" -- Replace with your custom image

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZyferionLoader"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Background Frame
local background = Instance.new("Frame")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.new(0, 0, 0)
background.BackgroundTransparency = 0.4
background.Parent = screenGui

-- Logo Image
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 80, 0, 80)
logo.Position = UDim2.new(0.5, -40, 0.35, -60)
logo.BackgroundTransparency = 1
logo.Image = LOGO_IMAGE
logo.Parent = background

-- Zyferion Hub Text (pixelated)
local text = Instance.new("TextLabel")
text.Size = UDim2.new(0, 400, 0, 50)
text.Position = UDim2.new(0.5, -200, 0.5, -20)
text.BackgroundTransparency = 1
text.Text = "Zyferion Hub"
text.Font = Enum.Font.Arcade -- Pixelated font
text.TextSize = 36
text.TextColor3 = Color3.fromRGB(255, 0, 0)
text.TextStrokeTransparency = 0.6
text.Parent = background

-- Progress Bar Container
local progressContainer = Instance.new("Frame")
progressContainer.Size = UDim2.new(0, 300, 0, 6)
progressContainer.Position = UDim2.new(0.5, -150, 0.6, 0)
progressContainer.BackgroundTransparency = 0.4
progressContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
progressContainer.BorderSizePixel = 0
progressContainer.Parent = background

local uicorner = Instance.new("UICorner", progressContainer)
uicorner.CornerRadius = UDim.new(0, 6)

-- Progress Fill
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.Position = UDim2.new(0, 0, 0, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressContainer

local uicornerFill = Instance.new("UICorner", progressBar)
uicornerFill.CornerRadius = UDim.new(0, 6)

-- Animate fill from 0% to 100%
local fillTween = TweenService:Create(progressBar, TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
	Size = UDim2.new(1, 0, 1, 0)
})
fillTween:Play()
fillTween.Completed:Wait()

-- Fade out everything
local fadeTween = TweenService:Create(background, TweenInfo.new(1), {BackgroundTransparency = 1})
fadeTween:Play()
fadeTween.Completed:Wait()
screenGui:Destroy()

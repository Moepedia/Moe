-- Moe V1.0 GUI for Delta Executor
-- Fix: Menggunakan TextButton, bukan Frame

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 120)
mainFrame.Position = UDim2.new(0.5, -300, 0.8, -60)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Rounded corners
local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 16)
corners.Parent = mainFrame

-- Border putih
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.2
stroke.Parent = mainFrame

-- Layout horizontal
local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 15)
layout.Parent = mainFrame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 15)
padding.PaddingRight = UDim.new(0, 15)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.Parent = mainFrame

-- LOGO
local logoFrame = Instance.new("Frame")
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(0, 50, 0, 50)
logoFrame.Position = UDim2.new(0, 10, 0.5, -25)
logoFrame.BackgroundTransparency = 1
logoFrame.BorderSizePixel = 0
logoFrame.Parent = mainFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(1, 0, 1, 0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = logoFrame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 25)
logoCorner.Parent = logoFrame

local logoStroke = Instance.new("UIStroke")
logoStroke.Thickness = 1
logoStroke.Color = Color3.new(1, 1, 1)
logoStroke.Transparency = 0.3
logoStroke.Parent = logoFrame

-- Fungsi buat tombol (SEKARANG PAKAI TEXTBUTTON)
local function createButton(name)
	local btn = Instance.new("TextButton")
	btn.Name = name.."Btn"
	btn.Size = UDim2.new(0, 85, 0, 80)
	btn.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
	btn.BackgroundTransparency = 0.2
	btn.BorderSizePixel = 0
	btn.Text = name  -- TextButton punya properti Text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamBold
	btn.AutoButtonColor = false  -- Matikan efek klik default Roblox
	btn.Parent = mainFrame
	
	-- Rounded corners untuk button
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 12)
	btnCorner.Parent = btn
	
	-- Stroke untuk button
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Thickness = 1
	btnStroke.Color = Color3.new(1, 1, 1)
	btnStroke.Transparency = 0.6
	btnStroke.Parent = btn
	
	-- Hover effect
	btn.MouseEnter:Connect(function()
		btn.BackgroundTransparency = 0
		btnStroke.Transparency = 0.3
	end)
	
	btn.MouseLeave:Connect(function()
		btn.BackgroundTransparency = 0.2
		btnStroke.Transparency = 0.6
	end)
	
	-- KLICK EVENT (ini yang bener untuk TextButton)
	btn.MouseButton1Click:Connect(function()
		print(name.." button clicked!")
		-- Tambahin notifikasi biar keliatan
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Moe V1.0",
			Text = name.." clicked!",
			Duration = 1
		})
	end)
	
	return btn
end

-- Buat 5 tombol
createButton("Fishing")
createButton("Favorite")
createButton("Shop")
createButton("Teleport")
createButton("Weather")

-- Fungsi drag GUI
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
	local delta = input.Position - dragStart
	mainFrame.Position = UDim2.new(
		startPos.X.Scale, 
		startPos.X.Offset + delta.X, 
		startPos.Y.Scale, 
		startPos.Y.Offset + delta.Y
	)
end

mainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

mainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

print("Moe V1.0 GUI - Fixed dengan TextButton")

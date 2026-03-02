-- Moe V1.0 GUI for Delta Executor
-- Persis seperti gambar yang Anda kirim (5 tombol)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama - UKURAN untuk 5 tombol
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 120) -- Landscape untuk 5 tombol
mainFrame.Position = UDim2.new(0.5, -300, 0.8, -60) -- Bawah tengah
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Rounded corners (biar gak terlalu kotak)
local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 16)
corners.Parent = mainFrame

-- Border putih tipis
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.2
stroke.Parent = mainFrame

-- Layout horizontal (kesamping) untuk 5 tombol
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

-- LOGO (kiri)
local logoFrame = Instance.new("Frame")
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(0, 50, 0, 50)
logoFrame.Position = UDim2.new(0, 10, 0.5, -25) -- Kiri tengah
logoFrame.BackgroundTransparency = 1
logoFrame.BorderSizePixel = 0
logoFrame.Parent = mainFrame
logoFrame.ZIndex = 10

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(1, 0, 1, 0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = logoFrame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 25)
logoCorner.Parent = logoFrame

-- Stroke untuk logo
local logoStroke = Instance.new("UIStroke")
logoStroke.Thickness = 1
logoStroke.Color = Color3.new(1, 1, 1)
logoStroke.Transparency = 0.3
logoStroke.Parent = logoFrame

-- Fungsi buat tombol
local function createButton(name)
	local btnFrame = Instance.new("Frame")
	btnFrame.Name = name.."Btn"
	btnFrame.Size = UDim2.new(0, 85, 0, 80) -- Ukuran tombol
	btnFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
	btnFrame.BackgroundTransparency = 0.2
	btnFrame.BorderSizePixel = 0
	btnFrame.Parent = mainFrame
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 12)
	btnCorner.Parent = btnFrame
	
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Thickness = 1
	btnStroke.Color = Color3.new(1, 1, 1)
	btnStroke.Transparency = 0.6
	btnStroke.Parent = btnFrame
	
	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1, 0, 1, 0)
	txt.BackgroundTransparency = 1
	txt.Text = name
	txt.TextColor3 = Color3.new(1, 1, 1)
	txt.TextScaled = true
	txt.Font = Enum.Font.GothamBold
	txt.Parent = btnFrame
	
	-- Hover effect
	btnFrame.MouseEnter:Connect(function()
		btnFrame.BackgroundTransparency = 0
		btnStroke.Transparency = 0.3
	end)
	
	btnFrame.MouseLeave:Connect(function()
		btnFrame.BackgroundTransparency = 0.2
		btnStroke.Transparency = 0.6
	end)
	
	-- Klik effect
	btnFrame.MouseButton1Click:Connect(function()
		print(name.." button clicked!")
	end)
	
	return btnFrame
end

-- Buat 5 tombol sesuai gambar: Fishing, Favorite, Shop, Teleport, Weather
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

print("Moe V1.0 GUI - 5 Tombol (Fishing, Favorite, Shop, Teleport, Weather)")

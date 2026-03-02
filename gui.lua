-- Moe V1.0 GUI for Delta Executor
-- Single file, with logo included

-- Membuat GUI
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama (background transparan)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 140) -- Landscape
mainFrame.Position = UDim2.new(0.5, -325, 0.8, -70)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.35
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Rounded corners
local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 16)
corners.Parent = mainFrame

-- Border putih tipis
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.2
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- Layout horizontal untuk isi
local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 12)
layout.Parent = mainFrame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 15)
padding.PaddingRight = UDim.new(0, 15)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)
padding.Parent = mainFrame

-- LOGO (sekarang dengan ID asli)
local logoFrame = Instance.new("Frame")
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(0, 60, 0, 60)
logoFrame.Position = UDim2.new(0, 10, 0.5, -30)
logoFrame.BackgroundTransparency = 1
logoFrame.BorderSizePixel = 0
logoFrame.Parent = mainFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(1, 0, 1, 0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848" -- ID logo dari Anda
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = logoFrame

-- Efek bulat untuk logo
local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 30)
logoCorner.Parent = logoFrame

-- Stroke tipis untuk logo biar keliatan
local logoStroke = Instance.new("UIStroke")
logoStroke.Thickness = 1
logoStroke.Color = Color3.new(1, 1, 1)
logoStroke.Transparency = 0.4
logoStroke.Parent = logoFrame

-- Fungsi buat tombol
local function createButton(name)
	local btnFrame = Instance.new("Frame")
	btnFrame.Name = name.."Btn"
	btnFrame.Size = UDim2.new(0, 85, 0, 100)
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
		-- Tambahkan fungsi untuk masing2 tombol di sini
		if name == "Fishing" then
			-- script fishing mu
		elseif name == "Favorite" then
			-- script favorite mu
		elseif name == "Shop" then
			-- script shop mu
		elseif name == "Teleport" then
			-- script teleport mu
		elseif name == "Weather" then
			-- script weather mu
		end
	end)
	
	return btnFrame
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

print("Moe V1.0 GUI Loaded!")

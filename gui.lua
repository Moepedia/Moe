-- Moe V1.0 GUI for Delta Executor
-- Perbaikan tata letak sesuai screenshot

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- Frame utama - UKURAN DIPERBESAR dan POSISI DI TENGAH
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 850, 0, 180) -- Lebih lebar dan tinggi
mainFrame.Position = UDim2.new(0.5, -425, 0.5, -90) -- TENGAH LAYAR
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.3
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Rounded corners
local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 20)
corners.Parent = mainFrame

-- Border putih
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.2
stroke.Parent = mainFrame

-- Layout GRID untuk tata letak seperti screenshot
local gridLayout = Instance.new("UIGridLayout")
gridLayout.FillDirection = Enum.FillDirection.Horizontal
gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
gridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
gridLayout.CellSize = UDim2.new(0, 90, 0, 70) -- Ukuran cell untuk tombol
gridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
gridLayout.StartCorner = Enum.StartCorner.TopLeft
gridLayout.Parent = mainFrame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 20)
padding.PaddingRight = UDim.new(0, 20)
padding.PaddingTop = UDim.new(0, 15)
padding.PaddingBottom = UDim.new(0, 15)
padding.Parent = mainFrame

-- LOGO di pojok kiri atas (seperti di screenshot)
local logoFrame = Instance.new("Frame")
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(0, 50, 0, 50)
logoFrame.Position = UDim2.new(0, 15, 0, 10)
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

-- Daftar tombol sesuai screenshot
local buttons = {
	"Gift", "+Smile", "Rods", "Items", "Store",
	"Eel", "Fish", "Boney", "Tobey", "El"
}

-- Fungsi buat tombol
local function createButton(name)
	local btnFrame = Instance.new("Frame")
	btnFrame.Name = name.."Btn"
	btnFrame.Size = UDim2.new(0, 90, 0, 70)
	btnFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
	btnFrame.BackgroundTransparency = 0.2
	btnFrame.BorderSizePixel = 0
	btnFrame.Parent = mainFrame
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 12)
	btnCorner.Parent = btnFrame
	
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Thickness = 1
	btnStroke.Color = Color3.new(1, 1, 1)
	btnStroke.Transparency = 0.7
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
		btnStroke.Transparency = 0.4
	end)
	
	btnFrame.MouseLeave:Connect(function()
		btnFrame.BackgroundTransparency = 0.2
		btnStroke.Transparency = 0.7
	end)
	
	-- Klik effect
	btnFrame.MouseButton1Click:Connect(function()
		print(name.." clicked!")
	end)
	
	return btnFrame
end

-- Buat semua tombol
for i, btnName in ipairs(buttons) do
	createButton(btnName)
end

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

print("Moe V1.0 GUI - Tata Letak Baru!")

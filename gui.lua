-- Moe V1.0 GUI for Delta Executor
-- STRUKTUR GRID dengan pembatas vertikal & horizontal

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- MAIN FRAME
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 350) -- Lebih besar untuk konten
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -175) -- Tengah layar
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.2
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

-- HEADER dengan LOGO (seperti di gambar)
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0, 50)
headerFrame.Position = UDim2.new(0, 0, 0, 0)
headerFrame.BackgroundTransparency = 1
headerFrame.BorderSizePixel = 0
headerFrame.Parent = mainFrame

-- Logo di header
local logoFrame = Instance.new("Frame")
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(0, 40, 0, 40)
logoFrame.Position = UDim2.new(0, 15, 0.5, -20)
logoFrame.BackgroundTransparency = 1
logoFrame.BorderSizePixel = 0
logoFrame.Parent = headerFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(1, 0, 1, 0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = logoFrame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 20)
logoCorner.Parent = logoFrame

-- Teks "Moe V1.0" di samping logo
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 150, 1, 0)
titleLabel.Position = UDim2.new(0, 65, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Moe V1.0"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = headerFrame

-- GARIS HORIZONTAL (pembatas header)
local horizontalLine = Instance.new("Frame")
horizontalLine.Name = "HorizontalLine"
horizontalLine.Size = UDim2.new(1, -20, 0, 1)
horizontalLine.Position = UDim2.new(0, 10, 0, 50)
horizontalLine.BackgroundColor3 = Color3.new(1, 1, 1)
horizontalLine.BackgroundTransparency = 0.3
horizontalLine.BorderSizePixel = 0
horizontalLine.Parent = mainFrame

-- CONTAINER UTAMA (untuk menu kiri dan konten kanan)
local contentContainer = Instance.new("Frame")
contentContainer.Name = "ContentContainer"
contentContainer.Size = UDim2.new(1, -20, 1, -60)
contentContainer.Position = UDim2.new(0, 10, 0, 55)
contentContainer.BackgroundTransparency = 1
contentContainer.BorderSizePixel = 0
contentContainer.Parent = mainFrame

-- MENU KIRI (tombol Fishing, Favorite, dll)
local leftMenu = Instance.new("Frame")
leftMenu.Name = "LeftMenu"
leftMenu.Size = UDim2.new(0, 120, 1, 0)
leftMenu.Position = UDim2.new(0, 0, 0, 0)
leftMenu.BackgroundTransparency = 1
leftMenu.BorderSizePixel = 0
leftMenu.Parent = contentContainer

-- Layout vertikal untuk menu
local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.VerticalAlignment = Enum.VerticalAlignment.Top
menuLayout.Padding = UDim.new(0, 8)
menuLayout.Parent = leftMenu

-- GARIS VERTIKAL (pembatas menu dan konten)
local verticalLine = Instance.new("Frame")
verticalLine.Name = "VerticalLine"
verticalLine.Size = UDim2.new(0, 1, 1, 0)
verticalLine.Position = UDim2.new(0, 130, 0, 0)
verticalLine.BackgroundColor3 = Color3.new(1, 1, 1)
verticalLine.BackgroundTransparency = 0.3
verticalLine.BorderSizePixel = 0
verticalLine.Parent = contentContainer

-- AREA KONTEN (untuk sub-menu/fitur)
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -140, 1, 0)
contentArea.Position = UDim2.new(0, 140, 0, 0)
contentArea.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
contentArea.BackgroundTransparency = 0.3
contentArea.BorderSizePixel = 0
contentArea.Parent = contentContainer

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentArea

-- JUDUL KONTEN (akan berubah sesuai tombol yang dipilih)
local contentTitle = Instance.new("TextLabel")
contentTitle.Name = "ContentTitle"
contentTitle.Size = UDim2.new(1, -20, 0, 30)
contentTitle.Position = UDim2.new(0, 10, 0, 10)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Pilih menu di samping"
contentTitle.TextColor3 = Color3.new(1, 1, 1)
contentTitle.TextScaled = true
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Parent = contentArea

-- Container untuk fitur (akan diisi sesuai menu)
local featuresContainer = Instance.new("Frame")
featuresContainer.Name = "FeaturesContainer"
featuresContainer.Size = UDim2.new(1, -20, 1, -50)
featuresContainer.Position = UDim2.new(0, 10, 0, 45)
featuresContainer.BackgroundTransparency = 1
featuresContainer.BorderSizePixel = 0
featuresContainer.Parent = contentArea

-- Layout untuk fitur (grid atau list)
local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
featuresLayout.VerticalAlignment = Enum.VerticalAlignment.Top
featuresLayout.Padding = UDim.new(0, 5)
featuresLayout.Parent = featuresContainer

-- FUNGSI MEMBUAT TOMBOL MENU KIRI
local menuButtons = {}
local currentMenu = nil

local function createMenuButton(name)
	local btn = Instance.new("TextButton")
	btn.Name = name.."MenuBtn"
	btn.Size = UDim2.new(0, 100, 0, 40)
	btn.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
	btn.BackgroundTransparency = 0.3
	btn.BorderSizePixel = 0
	btn.Text = name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.Font = Enum.Font.GothamBold
	btn.AutoButtonColor = false
	btn.Parent = leftMenu
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = btn
	
	-- Hover
	btn.MouseEnter:Connect(function()
		if currentMenu ~= name then
			btn.BackgroundTransparency = 0.1
		end
	end)
	
	btn.MouseLeave:Connect(function()
		if currentMenu ~= name then
			btn.BackgroundTransparency = 0.3
		end
	end)
	
	-- Klik
	btn.MouseButton1Click:Connect(function()
		-- Reset semua button
		for _, b in pairs(menuButtons) do
			b.BackgroundTransparency = 0.3
			b.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
		end
		
		-- Highlight button yang dipilih
		btn.BackgroundTransparency = 0
		btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
		currentMenu = name
		
		-- Update judul konten
		contentTitle.Text = name.." Features"
		
		-- Hapus fitur lama
		for _, child in pairs(featuresContainer:GetChildren()) do
			if child:IsA("TextButton") or child:IsA("Frame") then
				child:Destroy()
			end
		end
		
		-- Tambah fitur sesuai menu yang dipilih
		if name == "Fishing" then
			createFeatureButton("Instant Fishing")
			createFeatureButton("Blatant Mode")
			createFeatureButton("Auto Sell")
			createFeatureButton("Auto Cast")
		elseif name == "Favorite" then
			createFeatureButton("Add to Favorite")
			createFeatureButton("Remove from Favorite")
			createFeatureButton("Favorite List")
		elseif name == "Shop" then
			createFeatureButton("Auto Buy")
			createFeatureButton("Quick Sell")
			createFeatureButton("Price Checker")
		elseif name == "Teleport" then
			createFeatureButton("Teleport to NPC")
			createFeatureButton("Teleport to Island")
			createFeatureButton("Teleport to Player")
		elseif name == "Weather" then
			createFeatureButton("Set Clear")
			createFeatureButton("Set Rain")
			createFeatureButton("Set Storm")
			createFeatureButton("Set Fog")
		end
	end)
	
	table.insert(menuButtons, btn)
	return btn
end

-- FUNGSI MEMBUAT TOMBOL FITUR (di area konten kanan)
local function createFeatureButton(name)
	local btn = Instance.new("TextButton")
	btn.Name = name.."FeatureBtn"
	btn.Size = UDim2.new(0, 150, 0, 35)
	btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	btn.BackgroundTransparency = 0.3
	btn.BorderSizePixel = 0
	btn.Text = name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.Font = Enum.Font.Gotham
	btn.AutoButtonColor = false
	btn.Parent = featuresContainer
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn
	
	-- Hover
	btn.MouseEnter:Connect(function()
		btn.BackgroundTransparency = 0.1
	end)
	
	btn.MouseLeave:Connect(function()
		btn.BackgroundTransparency = 0.3
	end)
	
	-- Click
	btn.MouseButton1Click:Connect(function()
		print(currentMenu.." - "..name.." clicked!")
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = currentMenu,
			Text = name.." activated!",
			Duration = 1.5
		})
		
		-- Efek klik
		btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
		task.wait(0.1)
		btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
	end)
	
	return btn
end

-- BUAT TOMBOL MENU KIRI
createMenuButton("Fishing")
createMenuButton("Favorite")
createMenuButton("Shop")
createMenuButton("Teleport")
createMenuButton("Weather")

-- FUNGSI DRAG GUI
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

print("Moe V1.0 GUI - STRUKTUR GRID dengan pembatas!")

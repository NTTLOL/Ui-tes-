local Library = {}

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer

local Blur = Instance.new("BlurEffect")
Blur.Size = 16
Blur.Parent = Lighting

local Gui = Instance.new("ScreenGui")
Gui.Parent = Player.PlayerGui
Gui.ResetOnSpawn = false

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.fromScale(0.42,0.52)
Main.Position = UDim2.fromScale(0.5,0.5)
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.BackgroundColor3 = Color3.fromRGB(18,18,18)
Main.BackgroundTransparency = 0.12
Instance.new("UICorner",Main).CornerRadius = UDim.new(0,4)

local Stroke = Instance.new("UIStroke",Main)
Stroke.Thickness = 1.2
Stroke.Transparency = 0.55

local Side = Instance.new("Frame",Main)
Side.Size = UDim2.new(0,150,1,0)
Side.BackgroundColor3 = Color3.fromRGB(14,14,14)
Side.BackgroundTransparency = 0.1
Instance.new("UICorner",Side).CornerRadius = UDim.new(0,4)

local Tabs = Instance.new("Frame",Side)
Tabs.Size = UDim2.new(1,0,1,0)
Tabs.BackgroundTransparency = 1
local TabLayout = Instance.new("UIListLayout",Tabs)
TabLayout.Padding = UDim.new(0,8)

local Pages = Instance.new("Frame",Main)
Pages.Position = UDim2.new(0,160,0,10)
Pages.Size = UDim2.new(1,-170,1,-20)
Pages.BackgroundTransparency = 1

local Avatar = Instance.new("ImageButton",Gui)
Avatar.Size = UDim2.fromOffset(52,52)
Avatar.Position = UDim2.new(0,18,0.5,-26)
Avatar.BackgroundTransparency = 0.15
Avatar.AutoButtonColor = false
Instance.new("UICorner",Avatar).CornerRadius = UDim.new(1,0)

local AStroke = Instance.new("UIStroke",Avatar)
AStroke.Thickness = 1.2
AStroke.Transparency = 0.45

local function SetAvatar(id)
	local ok,img = pcall(function()
		return Players:GetUserThumbnailAsync(
			tonumber(id),
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size420x420
		)
	end)
	if ok then
		Avatar.Image = img
	end
end
SetAvatar(Player.UserId)

local IdInput = Instance.new("TextBox",Side)
IdInput.Size = UDim2.new(1,-20,0,36)
IdInput.Position = UDim2.new(0,10,0,12)
IdInput.BackgroundColor3 = Color3.fromRGB(25,25,25)
IdInput.Text = ""
IdInput.Visible = false
IdInput.ClearTextOnFocus = false
Instance.new("UICorner",IdInput).CornerRadius = UDim.new(0,3)
Instance.new("UIStroke",IdInput).Transparency = 0.7

IdInput.FocusLost:Connect(function(enter)
	if enter and tonumber(IdInput.Text) then
		SetAvatar(IdInput.Text)
	end
end)

local Open = true
local ShowId = false

Avatar.MouseButton1Click:Connect(function()
	ShowId = not ShowId
	IdInput.Visible = ShowId
end)

Avatar.MouseButton2Click:Connect(function()
	Open = not Open
	TweenService:Create(Main,TweenInfo.new(0.28,Enum.EasingStyle.Quint),{
		Position = Open and UDim2.fromScale(0.5,0.5) or UDim2.new(-0.6,0,0.5,0)
	}):Play()
	TweenService:Create(Blur,TweenInfo.new(0.25),{
		Size = Open and 16 or 0
	}):Play()
end)

local Drag,Start,Pos
Side.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		Drag = true
		Start = i.Position
		Pos = Main.Position
	end
end)

UIS.InputChanged:Connect(function(i)
	if Drag and i.UserInputType == Enum.UserInputType.MouseMovement then
		local d = i.Position - Start
		Main.Position = UDim2.new(Pos.X.Scale,Pos.X.Offset+d.X,Pos.Y.Scale,Pos.Y.Offset+d.Y)
	end
end)

UIS.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		Drag = false
	end
end)

function Library:CreateTab()
	local Tab = Instance.new("TextButton",Tabs)
	Tab.Size = UDim2.new(1,-10,0,38)
	Tab.Position = UDim2.new(0,5,0,0)
	Tab.Text = ""
	Tab.BackgroundColor3 = Color3.fromRGB(25,25,25)
	Tab.AutoButtonColor = false
	Instance.new("UICorner",Tab).CornerRadius = UDim.new(0,3)
	Instance.new("UIStroke",Tab).Transparency = 0.7

	local Page = Instance.new("Frame",Pages)
	Page.Size = UDim2.new(1,0,1,0)
	Page.Visible = false
	Page.BackgroundTransparency = 1
	local Layout = Instance.new("UIListLayout",Page)
	Layout.Padding = UDim.new(0,10)

	Tab.MouseButton1Click:Connect(function()
		for _,p in ipairs(Pages:GetChildren()) do
			if p:IsA("Frame") then p.Visible = false end
		end
		Page.Visible = true
	end)

	return Page
end

return Library

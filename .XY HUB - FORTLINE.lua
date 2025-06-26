--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// GUI Setup
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "FortlineGUI"
screenGui.ResetOnSpawn = false

--// Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0, 20, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)

--// Pulsing Border
local border = Instance.new("UIStroke", mainFrame)
border.Thickness = 2
border.Color = Color3.new(1, 1, 1)
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
spawn(function()
	while mainFrame.Parent do
		for i = 0, 1, 0.04 do border.Transparency = i task.wait() end
		for i = 1, 0, -0.04 do border.Transparency = i task.wait() end
	end
end)

--// Title & Info
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 28)
title.Position = UDim2.new(0, 0, 0, 4)
title.Text = "XY HUB | FORTLINE"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local subtitle = Instance.new("TextLabel", mainFrame)
subtitle.Size = UDim2.new(1, 0, 0, 18)
subtitle.Position = UDim2.new(0, 0, 0, 24)
subtitle.Text = "Youtube: AcxTheScripter"
subtitle.TextColor3 = Color3.fromRGB(200, 200, 200)
subtitle.BackgroundTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 13

local credit = Instance.new("TextLabel", mainFrame)
credit.Size = UDim2.new(1, 0, 0, 20)
credit.Position = UDim2.new(0, 0, 1, -20)
credit.Text = "Made by AcxScripter"
credit.TextColor3 = Color3.fromRGB(150, 150, 150)
credit.BackgroundTransparency = 1
credit.Font = Enum.Font.Gotham
credit.TextSize = 12

--// Collapse Button
local collapsed = false
local toggleBtn = Instance.new("TextButton", mainFrame)
toggleBtn.Size = UDim2.new(0, 25, 0, 25)
toggleBtn.Position = UDim2.new(1, -30, 0, 2)
toggleBtn.Text = "-"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 20
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.BackgroundTransparency = 1

--// Content Frame
local contentFrame = Instance.new("ScrollingFrame", mainFrame)
contentFrame.Size = UDim2.new(1, 0, 1, -65)
contentFrame.Position = UDim2.new(0, 0, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local layout = Instance.new("UIListLayout", contentFrame)
layout.Padding = UDim.new(0, 6)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	contentFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end)

--// Toggles
_G.silentAim = false
_G.infiniteAmmo = false
_G.fastFire = false
_G.autoGuns = false
_G.noRecoil = false
_G.noSpread = false

--// Button Templates
local function createToggleButton(name, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 260, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = name .. " [OFF]"
	btn.AutoButtonColor = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	local toggled = false
	btn.MouseButton1Click:Connect(function()
		toggled = not toggled
		btn.Text = name .. (toggled and " [ON]" or " [OFF]")
		callback(toggled)
	end)

	return btn
end

local function createButton(name, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 260, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	btn.Text = name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.AutoButtonColor = true
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

	btn.MouseButton1Click:Connect(callback)
	return btn
end

--// Kill Function
local function killPlayer(target)
	local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
	if tool and target and target:FindFirstChild("Head") then
		for _ = 1, 5 do
			ReplicatedStorage.WeaponsSystem.Network.WeaponHit:FireServer(tool, {
				p = target.Head.Position,
				pid = 2,
				part = target.Head,
				d = 500,
				maxDist = 500,
				h = target:FindFirstChildOfClass("Humanoid"),
				m = Enum.Material.Plastic,
				n = Vector3.new(-1, -60, 0),
				t = 0.15,
				sid = 32
			})
			task.wait(0.1)
		end
	end
end

--// Features List
local features = {
	{type = "button", name = "ESP Player", callback = function()
		task.spawn(function()
			local success, err = pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP"))()
			end)
			if not success then warn("ESP Error:", err) end
		end)
	end},

	{type = "button", name = "Kill-All", callback = function()
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character then
				killPlayer(p.Character)
			end
		end
	end},

	{type = "toggle", name = "Silent Aim", callback = function(t) _G.silentAim = t end},
	{type = "toggle", name = "Infinite Ammo", callback = function(t) _G.infiniteAmmo = t end},
	{type = "toggle", name = "Fast Fire", callback = function(t) _G.fastFire = t end},
	{type = "toggle", name = "Full Auto", callback = function(t) _G.autoGuns = t end},
	{type = "toggle", name = "No Recoil", callback = function(t) _G.noRecoil = t end},
	{type = "toggle", name = "No Spread", callback = function(t) _G.noSpread = t end},
}

for _, feat in ipairs(features) do
	local btn = feat.type == "toggle" and createToggleButton(feat.name, feat.callback) or createButton(feat.name, feat.callback)
	btn.Parent = contentFrame
end

--// Collapse Toggle
toggleBtn.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	toggleBtn.Text = collapsed and "+" or "-"
	mainFrame.Size = collapsed and UDim2.new(0, 300, 0, 40) or UDim2.new(0, 300, 0, 350)
	contentFrame.Visible = not collapsed
	credit.Visible = not collapsed
end)

--// Feature Hook
task.spawn(function()
	while true do
		for _, mod in pairs(getgc(true)) do
			if typeof(mod) == "table" and rawget(mod, "getConfigValue") and rawget(mod, "fire") then
				local rawFire, rawAmmo, rawGet = mod.fire, mod.useAmmo, mod.getConfigValue

				mod.fire = function(self, ...)
					local args = {...}
					if _G.silentAim then
						local closest, dist = nil, math.huge
						local mousePos = UserInputService:GetMouseLocation()
						for _, p in ipairs(Players:GetPlayers()) do
							if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
								local pos, onScreen = camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
								local d = (Vector2.new(pos.X, pos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
								if onScreen and d < dist then
									closest = p.Character.HumanoidRootPart
									dist = d
								end
							end
						end
						if closest then
							args[2] = (closest.Position - args[1]).Unit
							args[3] = 1
						end
					end
					return rawFire(self, unpack(args))
				end

				mod.useAmmo = function(self, ...)
					if _G.infiniteAmmo then return 1 end
					return rawAmmo(self, ...)
				end

				mod.getConfigValue = function(self, key, ...)
					if _G.fastFire and key == "ShotCooldown" then return 0.01 end
					if _G.autoGuns and key == "FireMode" then return "Automatic" end
					if _G.noRecoil and (key == "RecoilMin" or key == "RecoilMax") then return 0 end
					if _G.noSpread and (key == "MinSpread" or key == "MaxSpread") then return 0 end
					return rawGet(self, key, ...)
				end
			end
		end
		task.wait(2)
	end
end)

print("✅ Fortline GUI Loaded with ESP, Kill-All, and all toggles.")

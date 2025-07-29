--[[ SCRIPT COMPLETO: Voo + Planar + Velocidade + Teleporte + ESP
     Feito para KRNL MOBILE - Por Zb Rio rise
--]]

-- CONFIGURAÇÕES:
local speedValue = 80 -- Velocidade ajustável
local glideForce = Vector3.new(0, 20, 0)

-- SERVIÇOS:
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local hum = char:WaitForChild("Humanoid")

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "SuperHackUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 180)
frame.Position = UDim2.new(0.02, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local function createButton(name, posY)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(1, 0, 0, 30)
	btn.Position = UDim2.new(0, 0, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = name
	return btn
end

-- BOTÕES
local btnGlide = createButton("Ativar Planar", 0)
local btnSpeed = createButton("Ativar Velocidade", 35)
local btnFly = createButton("Ativar Voo", 70)
local btnESP = createButton("Ativar ESP", 105)
local btnTP = createButton("Ativar Teleporte", 140)

-- PLANAR
local glideOn = false
btnGlide.MouseButton1Click:Connect(function()
	glideOn = not glideOn
	btnGlide.Text = glideOn and "Desativar Planar" or "Ativar Planar"
	if glideOn then
		local bv = Instance.new("BodyVelocity", hrp)
		bv.Name = "GlideForce"
		bv.Velocity = glideForce
		bv.MaxForce = Vector3.new(0, math.huge, 0)
	else
		local g = hrp:FindFirstChild("GlideForce")
		if g then g:Destroy() end
	end
end)

-- VELOCIDADE
local speedOn = false
btnSpeed.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	btnSpeed.Text = speedOn and "Desativar Velocidade" or "Ativar Velocidade"
	hum.WalkSpeed = speedOn and speedValue or 16
end)

-- VOO
local flying = false
local flyBV = nil
btnFly.MouseButton1Click:Connect(function()
	flying = not flying
	btnFly.Text = flying and "Desativar Voo" or "Ativar Voo"
	if flying then
		flyBV = Instance.new("BodyVelocity", hrp)
		flyBV.MaxForce = Vector3.new(1, 1, 1) * math.huge
		flyBV.Velocity = Vector3.zero
		game:GetService("RunService").RenderStepped:Connect(function()
			if flying then
				local dir = Vector3.zero
				if hum.MoveDirection.Magnitude > 0 then
					dir = hum.MoveDirection * 60
				end
				flyBV.Velocity = Vector3.new(dir.X, 60, dir.Z)
			end
		end)
	else
		if flyBV then flyBV:Destroy() end
	end
end)

-- ESP
local espOn = false
btnESP.MouseButton1Click:Connect(function()
	espOn = not espOn
	btnESP.Text = espOn and "Desativar ESP" or "Ativar ESP"
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			local hl = plr.Character:FindFirstChildOfClass("Highlight")
			if espOn then
				if not hl then
					local h = Instance.new("Highlight", plr.Character)
					h.FillColor = Color3.fromRGB(0, 170, 255)
					h.OutlineColor = Color3.fromRGB(255, 255, 255)
				end
			else
				if hl then hl:Destroy() end
			end
		end
	end
end)

-- TELEPORTE
local tpOn = false
btnTP.MouseButton1Click:Connect(function()
	tpOn = not tpOn
	btnTP.Text = tpOn and "Clique para teleportar" or "Ativar Teleporte"
end)

mouse.Button1Down:Connect(function()
	if tpOn then
		local pos = mouse.Hit.Position
		hrp.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
	end
end)

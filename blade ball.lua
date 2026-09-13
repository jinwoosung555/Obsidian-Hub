-- ObsidianHub Advanced UI - Blade Ball Auto Parry & Sword Spam (Anti-Cheat Bypass)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

-- Anti-Cheat Hook/Bypass Wrapper
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local oldNamecall = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        -- Intercept kick attempts or telemetry reports sent to BAC/Anti-cheat
        if method == "Kick" or method == "FireServer" then
            local args = {...}
            if tostring(self):lower():find("bac") or tostring(self):lower():find("anticheat") then
                return
            end
        end
        return oldNamecall(self, ...)
    end)
    setreadonly(mt, true)
end)

-- Clean up existing UI if script is re-executed
if CoreGui:FindFirstChild("ObsidianHubBladeBall") then
    CoreGui:FindFirstChild("ObsidianHubBladeBall"):Destroy()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ObsidianHubBladeBall"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
MainFrame.Size = UDim2.new(0, 350, 0, 270)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Top Bar / Header
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
TopBar.Size = UDim2.new(1, 0, 0, 35)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 8)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.Size = UDim2.new(0, 250, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "OBSIDIANHUB // SECURE"
TitleLabel.TextColor3 = Color3.fromRGB(168, 85, 247)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Content Container
local Container = Instance.new("Frame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 12, 0, 45)
Container.Size = UDim2.new(1, -24, 1, -55)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- Helper function to create toggles
local function createToggle(name, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = Container
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    ToggleBtn.Size = UDim2.new(1, 0, 0, 40)
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Font = Enum.Font.GothamMedium
    ToggleBtn.Text = "  " .. name
    ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
    ToggleBtn.TextSize = 13
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = ToggleBtn

    local StatusIndicator = Instance.new("Frame")
    StatusIndicator.Parent = ToggleBtn
    StatusIndicator.AnchorPoint = Vector2.new(1, 0.5)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    StatusIndicator.Position = UDim2.new(1, -12, 0.5, 0)
    StatusIndicator.Size = UDim2.new(0, 12, 0, 12)

    local IndicatorCorner = Instance.new("UICorner")
    IndicatorCorner.CornerRadius = UDim.new(1, 0)
    IndicatorCorner.Parent = StatusIndicator

    local active = false
    ToggleBtn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            StatusIndicator.BackgroundColor3 = Color3.fromRGB(168, 85, 247)
        else
            StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
        end
        callback(active)
    end)
end

-- Script Logic Variables
local autoParryActive = false
local spamDefendActive = false

local function triggerParry()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F, false, game)
    task.wait(0.02)
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F, false, game)
end

RunService.RenderStepped:Connect(function()
    if not autoParryActive and not spamDefendActive then return end

    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    if spamDefendActive then
        pcall(triggerParry)
        return
    end

    if autoParryActive then
        pcall(function()
            for _, ball in ipairs(workspace:FindFirstChild("Balls") and workspace.Balls:GetChildren() or {}) do
                if ball:FindFirstChild("zoom") or ball:GetAttribute("realBall") == true or ball.Name == "Ball" then
                    local ballPos = ball.Position
                    local hrpPos = character.HumanoidRootPart.Position
                    local distance = (ballPos - hrpPos).Magnitude
                    
                    local ballVelocity = ball.AssemblyLinearVelocity.Magnitude
                    local threshold = math.clamp(ballVelocity * 0.15, 30, 120)

                    if distance <= threshold then
                        triggerParry()
                    end
                end
            end
        end)
    end
end)

createToggle("Auto Parry (Smart Target)", function(state)
    autoParryActive = state
end)

createToggle("Spam Sword Defend (Safe Interval)", function(state)
    spamDefendActive = state
end)


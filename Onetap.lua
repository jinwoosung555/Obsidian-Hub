-- ObsidianHub Ultra Premium - [FPS] One Tap (Advanced Tabbed UI & Automation)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

if CoreGui:FindFirstChild("ObsidianHubFPSOneTap") then
    CoreGui:FindFirstChild("ObsidianHubFPSOneTap"):Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ObsidianHubFPSOneTap"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -170)
MainFrame.Size = UDim2.new(0, 480, 0, 340)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(147, 51, 234)
MainStroke.Transparency = 0.4
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
TopBar.Size = UDim2.new(1, 0, 0, 40)

local TopBarCorner = Instance.new("UICorner")
TopBarCorner.CornerRadius = UDim.new(0, 10)
TopBarCorner.Parent = TopBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = TopBar
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(0, 300, 1, 0)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "OBSIDIANHUB // [FPS] ONE TAP"
TitleLabel.TextColor3 = Color3.fromRGB(168, 85, 247)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.Size = UDim2.new(1, 0, 0, 35)

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local PagesContainer = Instance.new("Frame")
PagesContainer.Parent = MainFrame
PagesContainer.BackgroundTransparency = 1
PagesContainer.Position = UDim2.new(0, 12, 0, 85)
PagesContainer.Size = UDim2.new(1, -24, 1, -95)

local aimbotActive = false
local espActive = false
local autoCaseActive = false

local pages = {}
local tabButtons = {}

local function createTab(name, layoutOrder)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Parent = TabBar
    tabBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    tabBtn.Size = UDim2.new(0.33, 0, 1, 0)
    tabBtn.Font = Enum.Font.GothamMedium
    tabBtn.Text = name
    tabBtn.TextColor3 = Color3.fromRGB(150, 150, 165)
    tabBtn.TextSize = 12
    tabBtn.AutoButtonColor = false
    tabBtn.LayoutOrder = layoutOrder

    local page = Instance.new("ScrollingFrame")
    page.Parent = PagesContainer
    page.BackgroundTransparency = 1
    page.Size = UDim2.new(1, 0, 1, 0)
    page.CanvasSize = UDim2.new(0, 0, 1.3, 0)
    page.ScrollBarThickness = 3
    page.Visible = (layoutOrder == 1)

    if layoutOrder == 1 then
        tabBtn.TextColor3 = Color3.fromRGB(168, 85, 247)
        tabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    end

    local pageLayout = Instance.new("UIListLayout")
    pageLayout.Parent = page
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pageLayout.Padding = UDim.new(0, 8)

    table.insert(tabButtons, {Btn = tabBtn, Page = page})
    pages[name] = page

    tabBtn.MouseButton1Click:Connect(function()
        for _, t in ipairs(tabButtons) do
            t.Page.Visible = false
            t.Btn.TextColor3 = Color3.fromRGB(150, 150, 165)
            t.Btn.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
        end
        page.Visible = true
        tabBtn.TextColor3 = Color3.fromRGB(168, 85, 247)
        tabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    end)

    return page
end

local combatTab = createTab("Combat", 1)
local miscTab = createTab("Misc & Cases", 2)
local discordTab = createTab("Community", 3)

local function createToggle(parent, name, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = parent
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    ToggleBtn.Size = UDim2.new(1, 0, 0, 38)
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Font = Enum.Font.GothamMedium
    ToggleBtn.Text = "  " + name -- Wait, use string concatenation
    ToggleBtn.Text = "  " .. name
    ToggleBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
    ToggleBtn.TextSize = 12
    ToggleBtn.TextXAlignment = Enum.TextXAlignment.Left

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = ToggleBtn

    local StatusIndicator = Instance.new("Frame")
    StatusIndicator.Parent = ToggleBtn
    StatusIndicator.AnchorPoint = Vector2.new(1, 0.5)
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    StatusIndicator.Position = UDim2.new(1, -12, 0.5, 0)
    StatusIndicator.Size = UDim2.new(0, 10, 0, 10)

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

createToggle(combatTab, "Silent Aimbot (Head Lock)", function(state)
    aimbotActive = state
end)

createToggle(combatTab, "Player ESP Highlights", function(state)
    espActive = state
end)

createToggle(miscTab, "Auto Roll Cases / Cosmetics", function(state)
    autoCaseActive = state
end)

createToggle(miscTab, "Anti-AFK Bypass (Prevent Kick)", function(state)
    if state then
        local vu = game:GetService("VirtualUser")
        LocalPlayer.Idled:Connect(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

do
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Parent = discordTab
    infoLabel.BackgroundTransparency = 1
    infoLabel.Size = UDim2.new(1, 0, 0, 40)
    infoLabel.Font = Enum.Font.GothamMedium
    infoLabel.Text = "Join our community Discord for updates & scripts!"
    infoLabel.TextColor3 = Color3.fromRGB(180, 180, 195)
    infoLabel.TextSize = 11
    infoLabel.TextWrapped = true

    local inviteBtn = Instance.new("TextButton")
    inviteBtn.Parent = discordTab
    inviteBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    inviteBtn.Size = UDim2.new(1, 0, 0, 42)
    inviteBtn.AutoButtonColor = false
    inviteBtn.Font = Enum.Font.GothamBold
    inviteBtn.Text = "  Copy Discord Invite (mFhG6sbDq9)"
    inviteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    inviteBtn.TextSize = 13

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = inviteBtn

    inviteBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://discord.gg/mFhG6sbDq9")
            inviteBtn.Text = "  [Copied to Clipboard Successfully!]"
            task.wait(2)
            inviteBtn.Text = "  Copy Discord Invite (mFhG6sbDq9)"
        end
    end)
end

-- ESP Container Cleanup Handling
local espHighlights = {}

RunService.RenderStepped:Connect(function()
    -- 1. Aimbot Logic (Snaps camera to closest enemy head)
    if aimbotActive then
        pcall(function()
            local closestTarget = nil
            local shortestDist = math.huge
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                    local head = player.Character.Head
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closestTarget = head
                        end
                    end
                end
            end
            if closestTarget then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
            end
        end)
    end

    -- 2. ESP Highlight Logic
    if espActive then
        pcall(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    if not player.Character:FindFirstChild("ObsidianESP") then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "ObsidianESP"
                        highlight.Adornee = player.Character
                        highlight.FillColor = Color3.fromRGB(168, 85, 247)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        highlight.Parent = player.Character
                    end
                end
            end
        end)
    else
        pcall(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("ObsidianESP") then
                    player.Character.ObsidianESP:Destroy()
                end
            end
        end)
    end

    -- 3. Auto Roll Cases Logic
    if autoCaseActive then
        pcall(function()
            for _, remote in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("case") or remote.Name:lower():find("roll") or remote.Name:lower():find("crate")) then
                    remote:FireServer()
                end
            end
        end)
    end
end)

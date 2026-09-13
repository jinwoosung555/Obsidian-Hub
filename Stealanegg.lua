-- ObsidianHub Ultra Premium - Steal an Egg Edition (Tabbed UI & Auto Treadmill Training)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Clean up existing UI if script is re-executed
if CoreGui:FindFirstChild("ObsidianHubStealAnEggUltimate") then
    CoreGui:FindFirstChild("ObsidianHubStealAnEggUltimate"):Destroy()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ObsidianHubStealAnEggUltimate"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Black Embed Window (Ultra Sleek Futuristic Theme)
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

-- Top Bar / Header
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
TitleLabel.Text = "OBSIDIANHUB // STEAL AN EGG"
TitleLabel.TextColor3 = Color3.fromRGB(168, 85, 247)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Tab Navigation Bar
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
TabBar.Position = UDim2.new(0, 0, 0, 40)
TabBar.Size = UDim2.new(1, 0, 0, 35)

local TabListLayout = Instance.new("UIListLayout")
TabListLayout.Parent = TabBar
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Content Pages Container
local PagesContainer = Instance.new("Frame")
PagesContainer.Parent = MainFrame
PagesContainer.BackgroundTransparency = 1
PagesContainer.Position = UDim2.new(0, 12, 0, 85)
PagesContainer.Size = UDim2.new(1, -24, 1, -95)

-- State Variables for Automation Modules
local autoStealActive = false
local autoHatchActive = false
local autoTrainActive = false
local autoUpgradeActive = false
local selectedRarity = "Legendary"
local rarities = {"All", "Common", "Rare", "Epic", "Legendary", "Mythic", "Secret"}

-- Create Tab Pages Dictionary
local pages = {}
local tabButtons = {}

local function createTab(name, layoutOrder)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Parent = TabBar
    tabBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    tabBtn.Size = UDim2.new(0.25, 0, 1, 0)
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

-- Setup Tabs
local farmTab = createTab("Farm", 1)
local trainTab = createTab("Training", 2)
local miscTab = createTab("Misc", 3)
local discordTab = createTab("Community", 4)

-- UI Element Builders
local function createToggle(parent, name, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Parent = parent
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    ToggleBtn.Size = UDim2.new(1, 0, 0, 38)
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Font = Enum.Font.GothamMedium
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

local function createDropdown(parent, name, list, callback)
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Parent = parent
    DropdownBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
    DropdownBtn.Size = UDim2.new(1, 0, 0, 38)
    DropdownBtn.AutoButtonColor = false
    DropdownBtn.Font = Enum.Font.GothamMedium
    DropdownBtn.Text = "  " .. name .. ": " .. selectedRarity
    DropdownBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
    DropdownBtn.TextSize = 12
    DropdownBtn.TextXAlignment = Enum.TextXAlignment.Left

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = DropdownBtn

    local currentIndex = 5 -- Default to Legendary
    DropdownBtn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #list + 1
        selectedRarity = list[currentIndex]
        DropdownBtn.Text = "  " .. name .. ": " .. selectedRarity
        callback(selectedRarity)
    end)
end

-- Populate Farm Tab
createToggle(farmTab, "Auto Steal Eggs (Instant Claim)", function(state)
    autoStealActive = state
end)

createToggle(farmTab, "Auto Hatch Eggs", function(state)
    autoHatchActive = state
end)

createDropdown(farmTab, "Target Rarity Filter", rarities, function(rarity)
    selectedRarity = rarity
end)

-- Populate Training Tab
createToggle(trainTab, "Auto Train Treadmill (Fully Stable)", function(state)
    autoTrainActive = state
end)

createToggle(trainTab, "Auto Buy Base & Gear Upgrades", function(state)
    autoUpgradeActive = state
end)

-- Populate Misc Tab
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

-- Populate Discord Tab
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
    inviteBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242) -- Discord Blurple
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

-- Core Game Automation Loops (Heartbeat and RenderStepped)
RunService.Heartbeat:Connect(function()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart

    -- 1. Auto Steal Eggs Automation
    if autoStealActive then
        pcall(function()
            for _, folderName in ipairs({"Eggs", "Map", "World", "ActiveEggs", "SpawnedEggs"}) do
                local folder = workspace:FindFirstChild(folderName)
                if folder then
                    for _, egg in ipairs(folder:GetDescendants()) do
                        local rarity = egg:GetAttribute("Rarity") or egg:GetAttribute("EggRarity") or "Common"
                        if selectedRarity == "All" or rarity == selectedRarity then
                            local prompt = egg:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt then
                                local targetPart = egg:IsA("BasePart") and egg or egg.PrimaryPart or egg:FindFirstChildWhichIsA("BasePart")
                                if targetPart and (targetPart.Position - hrp.Position).Magnitude <= 30 then
                                    fireproximityprompt(prompt)
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    -- 2. Auto Train Treadmill Automation (Properly detects equipment and simulates interaction/remotes)
    if autoTrainActive then
        pcall(function()
            -- Scan workspace or local base equipment for treadmills
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name:lower():find("treadmill") or obj.Name:lower():find("training") then
                    local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                    local basePart = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                    
                    if basePart and (basePart.Position - hrp.Position).Magnitude < 15 then
                        if prompt then
                            fireproximityprompt(prompt)
                        end
                    end
                end
            end

            -- Also trigger typical training RemoteEvents safely
            for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("train") or remote.Name:lower():find("treadmill") or remote.Name:lower():find("workout")) then
                    remote:FireServer()
                end
            end
        end)
    end

    -- 3. Auto Hatch Automation
    if autoHatchActive then
        pcall(function()
            for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("hatch") or remote.Name:lower():find("buyegg")) then
                    remote:FireServer(selectedRarity, 1)
                end
            end
        end)
    end

    -- 4. Auto Upgrade Automation
    if autoUpgradeActive then
        pcall(function()
            for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") and (remote.Name:lower():find("upgrade") or remote.Name:lower():find("buybase")) then
                    remote:FireServer("Treadmill")
                    remote:FireServer("Speed")
                end
            end
        end)
    end
end)

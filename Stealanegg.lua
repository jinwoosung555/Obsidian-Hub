-- ObsidianHub Advanced UI - Steal an Egg (Auto Steal & Rarity Filter)
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Clean up existing UI if script is re-executed
if CoreGui:FindFirstChild("ObsidianHubStealEgg") then
    CoreGui:FindFirstChild("ObsidianHubStealEgg"):Destroy()
end

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ObsidianHubStealEgg"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main Frame (Advanced Obsidian Theme)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -140)
MainFrame.Size = UDim2.new(0, 350, 0, 300)
MainFrame.Active = true
MainFrame.Draggable = true

-- UI Corner Styling
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
TitleLabel.Text = "OBSIDIANHUB // STEAL AN EGG"
TitleLabel.TextColor3 = Color3.fromRGB(168, 85, 247)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- Content Container
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 12, 0, 45)
Container.Size = UDim2.new(1, -24, 1, -55)
Container.CanvasSize = UDim2.new(0, 0, 1.2, 0)
Container.ScrollBarThickness = 4

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)

-- State Variables
local autoStealActive = false
local selectedRarity = "Legendary" -- Default filter target
local rarities = {"Common", "Rare", "Epic", "Legendary", "Mythic"}

-- Helper function to create stylish toggles
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

-- Helper function to create Dropdown for Rarity Filtering
local function createDropdown(name, list, callback)
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Parent = Container
    DropdownBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    DropdownBtn.Size = UDim2.new(1, 0, 0, 40)
    DropdownBtn.AutoButtonColor = false
    DropdownBtn.Font = Enum.Font.GothamMedium
    DropdownBtn.Text = "  " .. name .. ": " .. selectedRarity
    DropdownBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
    DropdownBtn.TextSize = 13
    DropdownBtn.TextXAlignment = Enum.TextXAlignment.Left

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = DropdownBtn

    local currentIndex = 4 -- Default to Legendary
    DropdownBtn.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #list + 1
        selectedRarity = list[currentIndex]
        DropdownBtn.Text = "  " .. name .. ": " .. selectedRarity
        callback(selectedRarity)
    end)
end

-- Core Auto Steal Logic Loop
RunService.Heartbeat:Connect(function()
    if not autoStealActive then return end

    pcall(function()
        -- Universal traversal pattern to find eggs or nests in workspace
        for _, eggContainer in ipairs({workspace:FindFirstChild("Eggs"), workspace:FindFirstChild("Map"), workspace}) do
            if eggContainer then
                for _, obj in ipairs(eggContainer:GetDescendants()) do
                    -- Check if object matches typical egg attributes or naming convention
                    if obj:IsA("Model") and (obj.Name:lower():find("egg") or obj:GetAttribute("Rarity")) then
                        local rarityAttr = obj:GetAttribute("Rarity") or "Common"
                        
                        -- If rarity matches or targets higher-tier automation filtering
                        if rarityAttr == selectedRarity or selectedRarity == "All" then
                            local prompt = obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                            if prompt and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local hrp = LocalPlayer.Character.HumanoidRootPart
                                if (obj.PrimaryPart and (obj.PrimaryPart.Position - hrp.Position).Magnitude < 20) or 
                                   (obj:IsA("BasePart") and (obj.Position - hrp.Position).Magnitude < 20) then
                                    fireproximityprompt(prompt)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)
end)

-- Build Interface Controls
createToggle("Auto Steal Eggs", function(state)
    autoStealActive = state
end)

createDropdown("Target Rarity Filter", rarities, function(rarity)
    selectedRarity = rarity
end)

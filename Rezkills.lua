-- =============================================
--   MY BLOX FRUITS HUB - Made by [Nissあ]
--   Version 1.0
-- =============================================

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Rezkills (made by Nissあ)🔥",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "MyCustomHub"
})

-- =============== AUTO FARM TAB ===============
local FarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

FarmTab:AddSection({Name = "Main Farming"})

getgenv().AutoFarm = false

FarmTab:AddToggle({
    Name = "Auto Farm Level (Fast Attack)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFarm = Value
        
        if Value then
            spawn(function()
                while getgenv().AutoFarm do
                    task.wait()
                    pcall(function()
                        local plr = game.Players.LocalPlayer
                        local char = plr.Character
                        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                        
                        local root = char.HumanoidRootPart
                        
                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                            if enemy:FindFirstChild("Humanoid") and 
                               enemy.Humanoid.Health > 0 and 
                               enemy:FindFirstChild("HumanoidRootPart") then
                               
                                local dist = (enemy.HumanoidRootPart.Position - root.Position).Magnitude
                                if dist < 250 then  -- you can tweak this
                                    -- Teleport in front of enemy + attack
                                    root.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                                    
                                    local tool = char:FindFirstChildOfClass("Tool")
                                    if tool then
                                        tool:Activate()
                                    end
                                    break
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

-- =============== MORE TABS (you can expand) ===============
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://6034509993"})

MiscTab:AddButton({
    Name = "Infinite Yield (Admin Commands)",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/main/source'))()
    end
})

OrionLib:Init()

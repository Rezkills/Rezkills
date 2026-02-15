-- =============================================
--   Rezkills Hub - Made by [Nissあ]
--   Version 1.1 - Fully Working Auto Farm
-- =============================================

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Rezkills Hub - Made by Nissあ 🔥",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "RezkillsHubConfig"
})

-- =============== AUTO FARM TAB ===============
local FarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

FarmTab:AddSection({Name = "Main Farming"})

getgenv().AutoFarmLevel = false

FarmTab:AddToggle({
    Name = "Auto Farm Level (Fast Attack + Magnet)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFarmLevel = Value
        if Value then
            spawn(function()
                while getgenv().AutoFarmLevel do
                    task.wait(0.15)
                    pcall(function()
                        local plr = game.Players.LocalPlayer
                        local char = plr.Character
                        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                        local hrp = char.HumanoidRootPart
                        
                        -- Find best target (near your level)
                        local target = nil
                        local bestDist = math.huge
                        for _, mob in pairs(workspace.Enemies:GetChildren()) do
                            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                                local dist = (hrp.Position - mob.HumanoidRootPart.Position).Magnitude
                                local mobLevel = tonumber(mob.Name:match("%[Lv%. (%d+)%]")) or tonumber(mob.Name:match("%d+")) or 0
                                local yourLevel = plr.Data.Level.Value
                                if dist < bestDist and math.abs(yourLevel - mobLevel) <= 65 then
                                    target = mob
                                    bestDist = dist
                                end
                            end
                        end
                        
                        if target and target:FindFirstChild("HumanoidRootPart") then
                            -- Teleport behind the mob (safe position)
                            hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 6, -7)
                            
                            -- Magnet (pull nearby mobs to the target)
                            for _, m in pairs(workspace.Enemies:GetChildren()) do
                                if m:FindFirstChild("HumanoidRootPart") and (m.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude < 40 then
                                    m.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame
                                end
                            end
                            
                            -- Fast attack (works with sword, fruit, etc.)
                            local vu = game:GetService("VirtualUser")
                            vu:CaptureController()
                            vu:ClickButton1(Vector2.new())
                        end
                    end)
                end
            end)
        end
    end
})

-- =============== MISC TAB ===============
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://6034509993",
    PremiumOnly = false
})

MiscTab:AddButton({
    Name = "Destroy GUI",
    Callback = function()
        OrionLib:Destroy()
    end
})

-- Load notification
OrionLib:MakeNotification({
    Name = "Rezkills Hub",
    Content = "Loaded successfully! Made by you (Nissあ) 🔥\nToggle Auto Farm to start farming levels!",
    Image = "rbxassetid://4483362458",
    Time = 8
})

OrionLib:Init()

-- =============================================
--   Rezkills - Made by [Nissあ]
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
getgenv().AutoFarm = false

FarmTab:AddToggle({
    Name = "Auto Farm Level (Fast Attack)",
    Default = false,
    Callback = function(Value)
        getgenv().AutoFarm = Value
        if Value then
            print("Auto Farm started! (Made by you)")
            spawn(function()
                while getgenv().AutoFarm do
                    task.wait(0.2)  -- Don't make it too fast or it lags
                    pcall(function()
                        local plr = game.Players.LocalPlayer
                        local char = plr.Character
                        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
                        local hrp = char.HumanoidRootPart

                        -- Find closest mob close to your level
                        local target = nil
                        local bestDist = math.huge
                        for _, mob in pairs(workspace.Enemies:GetChildren()) do
                            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                local mobHrp = mob:FindFirstChild("HumanoidRootPart")
                                if mobHrp then
                                    local dist = (hrp.Position - mobHrp.Position).Magnitude
                                    local mobLv = tonumber(mob.Name:match("%d+")) or 0
                                    local yourLv = plr.Data.Level.Value
                                    if dist < bestDist and math.abs(yourLv - mobLv) <= 60 then
                                        target = mob
                                        bestDist = dist
                                    end
                                end
                            end
                        end

                        if target and target:FindFirstChild("HumanoidRootPart") then
                            -- Teleport close (behind for safety)
                            hrp.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 6, -7)
                            
                            -- Pull nearby mobs (magnet)
                            for _, m in pairs(workspace.Enemies:GetChildren()) do
                                if m:FindFirstChild("HumanoidRootPart") and (m.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude < 35 then
                                    m.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame
                                end
                            end
                            
                            -- Attack (click simulation - works with most executors)
                            local vu = game:GetService("VirtualUser")
                            vu:CaptureController()
                            vu:ClickButton1(Vector2.new())
                        end
                    end)
                end
            end)
        else
            print("Auto Farm stopped")
        end
    end
})

-- Rezkills Hub - Kavo UI Version (Working 2026 - No Orion issues)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("Rezkills Hub - Made by Nissあ 🔥", "DarkTheme")

local FarmTab = Window:NewTab("Auto Farm")
local FarmSection = FarmTab:NewSection("Auto Farm Level (Quest + TP Attempt)")

getgenv().AutoFarm = false

FarmSection:NewToggle("Auto Farm Quest & Level", "Toggles auto quest farm", function(state)
    getgenv().AutoFarm = state
    if state then
        print("Auto Farm started - TP to quest area + kill")
        spawn(function()
            while getgenv().AutoFarm do
                task.wait(0.4)
                pcall(function()
                    local plr = game.Players.LocalPlayer
                    local char = plr.Character or plr.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart")
                    local level = plr.Data.Level.Value
                    local questGui = plr.PlayerGui.Main.Quest.Container
                    local hasQuest = questGui.Visible

                    -- If no quest, try TP to common low-level giver (Bandit island example)
                    if not hasQuest then
                        hrp.CFrame = CFrame.new(1059, 16, 1547) + Vector3.new(0, 5, 0)  -- Bandit quest giver
                        task.wait(1.5)
                        -- Attempt accept (fire prompts/clicks near NPCs)
                        for _, v in pairs(workspace.NPCs:GetDescendants()) do
                            if v:IsA("ProximityPrompt") then fireproximityprompt(v) end
                            if v:IsA("ClickDetector") then fireclickdetector(v) end
                        end
                        task.wait(2)
                    end

                    -- Farm area TP + magnet + attack
                    hrp.CFrame = CFrame.new(1059 + math.random(-30,30), 16, 1547 + math.random(-30,30)) + Vector3.new(0, 10, 0)
                    for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                        if enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            enemy.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 5, -6)
                            task.wait(0.05)
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):ClickButton1(Vector2.new())
                        end
                    end
                end)
            end
        end)
    else
        print("Auto Farm stopped")
    end
end)

-- Add more toggles/buttons later if needed
local MiscTab = Window:NewTab("Misc")
MiscTab:NewSection("Extra")
MiscTab:NewButton("Destroy GUI", "Closes the UI", function()
    Library:ToggleUI()
end)

print("Rezkills Hub Loaded - Use Kavo UI (no Orion problems)")

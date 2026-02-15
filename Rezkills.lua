-- =============================================
-- Rezkills Hub v3 - FULL AUTO QUEST FARM
-- Works 2026 | Auto TP to island/giver, accept quest, farm mobs
-- =============================================

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local Window = OrionLib:MakeWindow({
    Name = "Rezkills Hub v3 - Made by Nissあ 🔥",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "RezkillsConfig",
    IntroEnabled = false
})

-- Farm Tab
local FarmTab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

FarmTab:AddSection({Name = "Auto Level Farm (Quest + TP + Kill)"})

getgenv().AutoFarmQuest = false

-- Basic quest data (add more for your level/sea)
local QuestInfo = {
    -- First Sea low levels
    Bandit = {levelRange = {1, 14}, giverPos = Vector3.new(1059, 16, 1547), mobName = "Bandit", areaPos = Vector3.new(1059, 16, 1547)},
    Monkey = {levelRange = {14, 30}, giverPos = Vector3.new(-1599, 37, 153), mobName = "Monkey", areaPos = Vector3.new(-1400, 37, 50)},
    -- Add more like Gorilla, Pirate, Desert Bandit, etc.
    -- Example: DesertBandit = {levelRange = {60, 75}, giverPos = Vector3.new(897, 7, 4388), mobName = "Desert Bandit", areaPos = Vector3.new(932, 7, 4484)},
    -- For higher seas, add when you level up
}

local function GetCurrentQuestInfo(level)
    for name, data in pairs(QuestInfo) do
        if level >= data.levelRange[1] and level <= data.levelRange[2] then
            return data
        end
    end
    return QuestInfo.Bandit  -- fallback
end

FarmTab:AddToggle({
    Name = "Auto Farm Quest & Level",
    Default = false,
    Callback = function(state)
        getgenv().AutoFarmQuest = state
        if state then
            OrionLib:MakeNotification({
                Name = "Auto Farm ON",
                Content = "TP to quest giver → Accept → Farm mobs → Repeat",
                Time = 6
            })
            spawn(function()
                while getgenv().AutoFarmQuest do
                    task.wait(0.3)
                    pcall(function()
                        local player = game.Players.LocalPlayer
                        local char = player.Character or player.CharacterAdded:Wait()
                        local hrp = char:WaitForChild("HumanoidRootPart")
                        local level = player.Data.Level.Value
                        local questGui = player.PlayerGui.Main.Quest.Container
                        local questActive = questGui.Visible
                        local questText = questGui.QuestTitle.Text or ""

                        local qInfo = GetCurrentQuestInfo(level)

                        -- If no quest or wrong one, TP to giver and accept
                        if not questActive or not questText:find(qInfo.mobName) then
                            hrp.CFrame = CFrame.new(qInfo.giverPos) + Vector3.new(0, 5, 0)
                            task.wait(1.5)
                            -- Try accept
                            for _, obj in pairs(workspace.NPCs:GetDescendants()) do
                                if obj:IsA("ClickDetector") or obj:IsA("ProximityPrompt") then
                                    if obj:IsA("ClickDetector") then fireclickdetector(obj) end
                                    if obj:IsA("ProximityPrompt") then fireproximityprompt(obj) end
                                end
                            end
                            task.wait(3)  -- wait for accept
                        end

                        -- Farm phase
                        hrp.CFrame = CFrame.new(qInfo.areaPos) + Vector3.new(0, 10, 0)
                        task.wait(0.6)

                        -- Magnet & kill
                        for _, enemy in pairs(workspace.Enemies:GetChildren()) do
                            if enemy.Name:find(qInfo.mobName) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
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
            OrionLib:MakeNotification({Name = "Auto Farm OFF", Content = "Stopped farming", Time = 4})
        end
    end
})

-- Misc Tab for destroy
local Misc = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://6034509993"})
Misc:AddButton({
    Name = "Close GUI",
    Callback = function()
        OrionLib:Destroy()
    end
})

OrionLib:MakeNotification({
    Name = "Rezkills v3 Loaded",
    Content = "GUI ready! Toggle Auto Farm Quest. Drag top bar to move.",
    Time = 8
})

OrionLib:Init()

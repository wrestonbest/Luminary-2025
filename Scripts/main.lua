local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "Luminary HUB",
    Icon = 0,
    LoadingTitle = "Luminary HUB Loading",
    LoadingSubtitle = "Eat the World",
    ShowText = "Luminary HUB",
    Theme = "Default",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = true,
    DisableBuildWarnings = true,
    ConfigurationSaving = {Enabled = true, FolderName = "Luminary Hub", FileName = "Luminary"},
})

Rayfield:Notify({Title="Luminary HUB",Content="Thanks for using the Luminary HUB script!",Duration=6.5,Image="badge-check"})
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local playerName = LocalPlayer.Name
local MainTab = Window:CreateTab("Main","circle-arrow-right")
local AutoTab = Window:CreateTab("Auto Farm","circle-arrow-right")

local function fireGrab()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart
    local grabArgs = {[1]=false; [2]=false; [3]=false;}
    pcall(function()
        workspace:WaitForChild(playerName, 9e9):WaitForChild("Events", 9e9)
            :WaitForChild("Grab", 9e9):FireServer(unpack(grabArgs))
    end)
    wait(0.1)
    local directions = {
        Vector3.new(1,0,0),
        Vector3.new(-1,0,0),
        Vector3.new(0,0,1),
        Vector3.new(0,0,-1)
    }
    for i = 1, #directions do
        local randMag = math.random() * 5
        hrp.CFrame = hrp.CFrame + directions[i] * randMag
        pcall(function()
            workspace:WaitForChild(playerName, 9e9):WaitForChild("Events", 9e9)
                :WaitForChild("Grab", 9e9):FireServer(unpack(grabArgs))
        end)
        wait(0.1)
    end
end

MainTab:CreateButton({Name = "Grab", Callback = fireGrab})
MainTab:CreateButton({Name = "Eat", Callback = function()
    local eatArgs = {}
    workspace:WaitForChild(playerName, 9e9):WaitForChild("Events", 9e9)
        :WaitForChild("Eat", 9e9):FireServer(unpack(eatArgs))
end})
MainTab:CreateButton({Name = "Sell", Callback = function()
    local sellArgs = {}
    workspace:WaitForChild(playerName, 9e9):WaitForChild("Events", 9e9)
        :WaitForChild("Sell", 9e9):FireServer(unpack(sellArgs))
end})

local autoGrabEnabled = false
AutoTab:CreateToggle({
    Name = "Auto Grab",
    CurrentValue = false,
    Flag = "AutoGrab",
    Callback = function(value)
        autoGrabEnabled = value
        spawn(function()
            while autoGrabEnabled do
                fireGrab()
                wait(1)
            end
        end)
    end
})

local autoEatEnabled = false
AutoTab:CreateToggle({
    Name = "Auto Eat",
    CurrentValue = false,
    Flag = "AutoEat",
    Callback = function(value)
        autoEatEnabled = value
        spawn(function()
            while autoEatEnabled do
                local eatArgs = {}
                pcall(function()
                    workspace:WaitForChild(playerName, 9e9):WaitForChild("Events", 9e9)
                        :WaitForChild("Eat", 9e9):FireServer(unpack(eatArgs))
                end)
                wait(1)
            end
        end)
    end
})

local autoSellEnabled = false
AutoTab:CreateToggle({
    Name = "Auto Sell",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = function(value)
        autoSellEnabled = value
        spawn(function()
            while autoSellEnabled do
                local sellArgs = {}
                pcall(function()
                    workspace:WaitForChild(playerName, 9e9):WaitForChild("Events", 9e9)
                        :WaitForChild("Sell", 9e9):FireServer(unpack(sellArgs))
                end)
                wait(30)
            end
        end)
    end
})

local autoFarmEnabled = false
AutoTab:CreateToggle({
    Name = "Auto Farm",
    CurrentValue = false,
    Flag = "AutoFarm",
    Callback = function(value)
        autoFarmEnabled = value
        spawn(function()

            if value and not autoSellEnabled then
                autoSellEnabled = true
                spawn(function()
                    while autoFarmEnabled do
                        local sellArgs = {}
                        pcall(function()
                            workspace:WaitForChild(playerName, 9e9):WaitForChild("Events", 9e9)
                                :WaitForChild("Sell", 9e9):FireServer(unpack(sellArgs))
                        end)
                        wait(30)
                    end
                    autoSellEnabled = false
                end)
            end

            while autoFarmEnabled do
                fireGrab()
                
                local eatArgs = {}
                pcall(function()
                    workspace:WaitForChild(playerName, 9e9):WaitForChild("Events", 9e9)
                        :WaitForChild("Eat", 9e9):FireServer(unpack(eatArgs))
                end)

                wait(1)
            end
        end)
    end
})
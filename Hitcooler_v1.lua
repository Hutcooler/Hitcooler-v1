
-- Main GUI loader script that ensures cleanup and works after death/reset

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Main function to create the GUI
local function createGui(character)
    -- Cleanup old GUI
    if player:FindFirstChild("PlayerGui"):FindFirstChild("HitcoolerGui") then
        player.PlayerGui:FindFirstChild("HitcoolerGui"):Destroy()
    end

    local humanoid = character:WaitForChild("Humanoid")
    local hrp = character:WaitForChild("HumanoidRootPart")
    local camera = workspace.CurrentCamera

    local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    screenGui.Name = "HitcoolerGui"
    screenGui.ResetOnSpawn = false

    local mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Size = UDim2.new(0, 200, 0, 370)
    mainFrame.Position = UDim2.new(0.5, -100, 0.5, -185)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.Active = true
    mainFrame.Draggable = true
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

    local title = Instance.new("TextLabel", mainFrame)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "Hitcooler v1"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextColor3 = Color3.new(1, 1, 1)

    local toggleBtn = Instance.new("TextButton", screenGui)
    toggleBtn.Size = UDim2.new(0, 100, 0, 30)
    toggleBtn.Position = UDim2.new(0, 10, 0, 10)
    toggleBtn.Text = "Show/Hide"
    toggleBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)

    local resetBtn = Instance.new("TextButton", screenGui)
    resetBtn.Size = UDim2.new(0, 100, 0, 30)
    resetBtn.Position = UDim2.new(0, 120, 0, 10)
    resetBtn.Text = "Reset GUI"
    resetBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    resetBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 6)

    toggleBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
        resetBtn.Visible = mainFrame.Visible
    end)

    resetBtn.MouseButton1Click:Connect(function()
        mainFrame.Position = UDim2.new(0.5, -100, 0.5, -185)
    end)

    -- FLY SETUP
    local flyBtn = Instance.new("TextButton", mainFrame)
    flyBtn.Size = UDim2.new(0.9, 0, 0, 40)
    flyBtn.Position = UDim2.new(0.05, 0, 0, 40)
    flyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    flyBtn.Text = "Fly"
    flyBtn.TextColor3 = Color3.new(1, 1, 1)
    flyBtn.Font = Enum.Font.Gotham
    flyBtn.TextSize = 16
    Instance.new("UICorner", flyBtn).CornerRadius = UDim.new(0, 8)

    local flyBox = Instance.new("TextBox", mainFrame)
    flyBox.Size = UDim2.new(0.9, 0, 0, 30)
    flyBox.Position = UDim2.new(0.05, 0, 0, 85)
    flyBox.PlaceholderText = "Fly Speed"
    flyBox.Text = "50"
    flyBox.ClearTextOnFocus = false
    flyBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    flyBox.TextColor3 = Color3.new(1, 1, 1)
    flyBox.Font = Enum.Font.Gotham
    flyBox.TextSize = 14
    Instance.new("UICorner", flyBox).CornerRadius = UDim.new(0, 6)

    local flying = false
    local flyConn

    flyBtn.MouseButton1Click:Connect(function()
        flying = not flying
        if flying then
            local speed = tonumber(flyBox.Text) or 50
            local bg = Instance.new("BodyGyro", hrp)
            bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bg.P = 9e4
            bg.CFrame = hrp.CFrame

            local bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.Velocity = Vector3.zero

            flyConn = RunService.RenderStepped:Connect(function()
                bg.CFrame = camera.CFrame
                bv.Velocity = camera.CFrame.LookVector * speed
            end)

            flyBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            if flyConn then flyConn:Disconnect() end
            for _, v in ipairs(hrp:GetChildren()) do
                if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
                    v:Destroy()
                end
            end
            flyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)

    -- NOCLIP SETUP
    local noclipBtn = Instance.new("TextButton", mainFrame)
    noclipBtn.Size = UDim2.new(0.9, 0, 0, 40)
    noclipBtn.Position = UDim2.new(0.05, 0, 0, 125)
    noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    noclipBtn.Text = "Noclip"
    noclipBtn.TextColor3 = Color3.new(1, 1, 1)
    noclipBtn.Font = Enum.Font.Gotham
    noclipBtn.TextSize = 16
    Instance.new("UICorner", noclipBtn).CornerRadius = UDim.new(0, 8)

    local noclipping = false
    local noclipConn

    noclipBtn.MouseButton1Click:Connect(function()
        noclipping = not noclipping
        if noclipping then
            noclipConn = RunService.Stepped:Connect(function()
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end)
            noclipBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            if noclipConn then noclipConn:Disconnect() end
            noclipBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end)

    -- SPEED SETUP
    local speedBtn = Instance.new("TextButton", mainFrame)
    speedBtn.Size = UDim2.new(0.9, 0, 0, 30)
    speedBtn.Position = UDim2.new(0.05, 0, 0, 175)
    speedBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    speedBtn.Text = "Set Speed"
    speedBtn.TextColor3 = Color3.new(1, 1, 1)
    speedBtn.Font = Enum.Font.Gotham
    speedBtn.TextSize = 14
    Instance.new("UICorner", speedBtn).CornerRadius = UDim.new(0, 6)

    local speedBox = Instance.new("TextBox", mainFrame)
    speedBox.Size = UDim2.new(0.9, 0, 0, 30)
    speedBox.Position = UDim2.new(0.05, 0, 0, 210)
    speedBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    speedBox.PlaceholderText = "WalkSpeed"
    speedBox.Text = "16"
    speedBox.ClearTextOnFocus = false
    speedBox.TextColor3 = Color3.new(1, 1, 1)
    speedBox.Font = Enum.Font.Gotham
    speedBox.TextSize = 14
    Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 6)

    speedBtn.MouseButton1Click:Connect(function()
        local s = tonumber(speedBox.Text)
        if s then humanoid.WalkSpeed = s end
    end)

    -- JUMP POWER SETUP
    local jumpBtn = Instance.new("TextButton", mainFrame)
    jumpBtn.Size = UDim2.new(0.9, 0, 0, 30)
    jumpBtn.Position = UDim2.new(0.05, 0, 0, 255)
    jumpBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    jumpBtn.Text = "Set JumpPower"
    jumpBtn.TextColor3 = Color3.new(1, 1, 1)
    jumpBtn.Font = Enum.Font.Gotham
    jumpBtn.TextSize = 14
    Instance.new("UICorner", jumpBtn).CornerRadius = UDim.new(0, 6)

    local jumpBox = Instance.new("TextBox", mainFrame)
    jumpBox.Size = UDim2.new(0.9, 0, 0, 30)
    jumpBox.Position = UDim2.new(0.05, 0, 0, 290)
    jumpBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    jumpBox.PlaceholderText = "JumpPower"
    jumpBox.Text = "50"
    jumpBox.ClearTextOnFocus = false
    jumpBox.TextColor3 = Color3.new(1, 1, 1)
    jumpBox.Font = Enum.Font.Gotham
    jumpBox.TextSize = 14
    Instance.new("UICorner", jumpBox).CornerRadius = UDim.new(0, 6)

    jumpBtn.MouseButton1Click:Connect(function()
        local j = tonumber(jumpBox.Text)
        if j then humanoid.JumpPower = j end
    end)
end

-- Initial GUI create
createGui(player.Character or player.CharacterAdded:Wait())

-- Recreate GUI on death/reset
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    createGui(char)
end)

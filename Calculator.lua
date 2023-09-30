local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.3, 0, 0.6, 0)
frame.Position = UDim2.new(0.35, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Parent = gui

local display = Instance.new("TextLabel")
display.Size = UDim2.new(1, 0, 0.15, 0)
display.BackgroundColor3 = Color3.new(1, 1, 1)
display.TextColor3 = Color3.new(0, 0, 0)
display.TextSize = 20
display.Parent = frame

local isDragging = false
local dragStartOffset = Vector2.new(0, 0)

local function updateUIPosition(input)
    local newPosition = UDim2.new(
        0,
        input.Position.X - dragStartOffset.X,
        0,
        input.Position.Y - dragStartOffset.Y
    )
    frame.Position = newPosition
end

frame.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then
        return
    end
    
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartOffset = input.Position - frame.Position.Position
    end
end)

frame.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateUIPosition(input)
    end
end)

frame.InputEnded:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        isDragging = false
    end
end)

local buttonLabels = {
    "1", "2", "3", "+",
    "4", "5", "6", "-",
    "7", "8", "9", "*",
    "C", "0", "=", "/",
    "sqrt", "exp", "sin", "cos", "tan"
}
local buttons = {}

for i, label in ipairs(buttonLabels) do
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.25, 0, 0.2, 0)
    button.Position = UDim2.new((i - 1) % 4 * 0.25, 0, math.floor((i - 1) / 5) * 0.2 + 0.2, 0)
    button.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
    button.TextColor3 = Color3.new(0, 0, 0)
    button.TextSize = 16
    button.Text = label
    button.Parent = frame
    buttons[i] = button

    button.MouseButton1Click:Connect(function()
        local currentText = display.Text

        if label == "=" then
            local success, result = pcall(loadstring("return " .. currentText))
            if success then
                display.Text = tostring(result)
            else
                display.Text = "Error"
            end
        elseif label == "C" then
            display.Text = ""
        elseif label == "sqrt" then
            display.Text = tostring(math.sqrt(tonumber(currentText)) or "Error")
        elseif label == "exp" then
            display.Text = tostring(math.exp(tonumber(currentText)) or "Error")
        elseif label == "sin" then
            display.Text = tostring(math.sin(tonumber(currentText)) or "Error")
        elseif label == "cos" then
            display.Text = tostring(math.cos(tonumber(currentText)) or "Error")
        elseif label == "tan" then
            display.Text = tostring(math.tan(tonumber(currentText)) or "Error")
        else
            display.Text = currentText .. label
        end
    end)
end

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0.1, 0, 0.05, 0)
toggleButton.Position = UDim2.new(0.45, 0, 0.15, 0)
toggleButton.BackgroundColor3 = Color3.new(0.7, 0.7, 0.7)
toggleButton.TextColor3 = Color3.new(0, 0, 0)
toggleButton.TextSize = 16
toggleButton.Text = "Toggle UI"
toggleButton.Parent = gui

local function toggleUIVisibility()
    frame.Visible = not frame.Visible
end

toggleButton.MouseButton1Click:Connect(toggleUIVisibility)

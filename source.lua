-- ArcanumLib - Mobile UI Library
local ArcanumLib = {}
ArcanumLib.__index = ArcanumLib

-- Utility function to create UI elements
local function createElement(className, properties)
    local element = Instance.new(className)
    for property, value in pairs(properties) do
        element[property] = value
    end
    return element
end

-- Initialize the UI library with ArcanumLib branding
function ArcanumLib.new(title)
    local self = setmetatable({}, ArcanumLib)

    -- ScreenGui setup with ArcanumLib as the title
    self.gui = createElement("ScreenGui", { Name = title or "ArcanumLib", ResetOnSpawn = false, IgnoreGuiInset = true, Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") })

    -- Container for UI elements
    self.container = createElement("Frame", { Size = UDim2.new(1, 0, 1, 0), Position = UDim2.new(0, 0, 0, 0), Parent = self.gui, BackgroundTransparency = 1 })
    self.layout = createElement("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim(0, 10), Parent = self.container })

    return self
end

-- Button component
function ArcanumLib:CreateButton(properties)
    local button = createElement("TextButton", properties)
    button.TextButton.MouseButton1Click:Connect(function()
        if properties.OnClick then properties.OnClick() end
    end)
    button.LayoutOrder = properties.LayoutOrder or 1  -- Ensure the button is arranged properly
    return button
end

-- Dropdown component
function ArcanumLib:CreateDropdown(properties)
    local dropdown = createElement("Frame", { Size = UDim2.new(0, properties.Width or 200, 0, properties.Height or 50), Position = properties.Position })
    local button = createElement("TextButton", { Text = properties.ButtonText or "Select", Size = UDim2.new(1, 0, 0, 50), Parent = dropdown })
    local list = createElement("Frame", { Size = UDim2.new(1, 0, 0, 0), Position = UDim2.new(0, 0, 1, 0), Visible = false, Parent = dropdown })

    for i, option in ipairs(properties.Options or {}) do
        local optionButton = createElement("TextButton", { Text = option, Size = UDim2.new(1, 0, 0, 50), Parent = list })
        optionButton.MouseButton1Click:Connect(function()
            button.Text = option
            list.Visible = false
            if properties.OnSelect then properties.OnSelect(option) end
        end)
    end

    button.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
    end)

    dropdown.LayoutOrder = properties.LayoutOrder or 2  -- Ensure the dropdown is arranged properly
    return dropdown
end

-- Toggle Button component
function ArcanumLib:CreateToggleButton(properties)
    local toggleButton = createElement("TextButton", { Text = properties.OnText or "On", Size = UDim2.new(0, 100, 0, 50), Parent = self.container })
    toggleButton.BackgroundColor3 = properties.BackgroundColor or Color3.fromRGB(0, 255, 0)

    toggleButton.MouseButton1Click:Connect(function()
        if toggleButton.Text == properties.OnText then
            toggleButton.Text = properties.OffText or "Off"
            toggleButton.BackgroundColor3 = properties.OffColor or Color3.fromRGB(255, 0, 0)
        else
            toggleButton.Text = properties.OnText or "On"
            toggleButton.BackgroundColor3 = properties.OnColor or Color3.fromRGB(0, 255, 0)
        end
        if properties.OnToggle then properties.OnToggle(toggleButton.Text) end
    end)

    toggleButton.LayoutOrder = properties.LayoutOrder or 3  -- Ensure the toggle button is arranged properly
    return toggleButton
end

-- Textbox component
function ArcanumLib:CreateTextbox(properties)
    local textbox = createElement("TextBox", { PlaceholderText = properties.PlaceholderText or "Enter text", Size = UDim2.new(0, properties.Width or 200, 0, 50), Parent = self.container })
    textbox.TextChanged:Connect(function()
        if properties.OnTextChanged then properties.OnTextChanged(textbox.Text) end
    end)

    textbox.LayoutOrder = properties.LayoutOrder or 4  -- Ensure the textbox is arranged properly
    return textbox
end

-- Slider component
function ArcanumLib:CreateSlider(properties)
    local slider = createElement("Frame", { Size = UDim2.new(0, properties.Width or 200, 0, 50), Parent = self.container })
    local thumb = createElement("Frame", { Size = UDim2.new(0, 10, 1, 0), BackgroundColor3 = properties.ThumbColor or Color3.fromRGB(0, 0, 255), Parent = slider })
    
    local minValue = properties.MinValue or 0
    local maxValue = properties.MaxValue or 100

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position.X
            local sliderPos = slider.AbsolutePosition.X
            local sliderWidth = slider.AbsoluteSize.X
            local newValue = math.clamp((mousePos - sliderPos) / sliderWidth, 0, 1)
            thumb.Position = UDim2.new(newValue, 0, 0.5, 0)
            if properties.OnChange then properties.OnChange(minValue + newValue * (maxValue - minValue)) end
        end
    end)

    slider.LayoutOrder = properties.LayoutOrder or 5  -- Ensure the slider is arranged properly
    return slider
end

-- Label component
function ArcanumLib:CreateLabel(properties)
    local label = createElement("TextLabel", { Text = properties.Text or "Label", Size = UDim2.new(0, properties.Width or 200, 0, 50), Parent = self.container })
    label.TextColor3 = properties.TextColor or Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1

    label.LayoutOrder = properties.LayoutOrder or 6  -- Ensure the label is arranged properly
    return label
end

-- Checkbox component
function ArcanumLib:CreateCheckbox(properties)
    local checkbox = createElement("TextButton", { Size = UDim2.new(0, 50, 0, 50), Text = "", Parent = self.container })
    local tick = createElement("TextLabel", { Size = UDim2.new(1, 0, 1, 0), Text = "", Parent = checkbox })
    
    checkbox.MouseButton1Click:Connect(function()
        if tick.Text == "" then
            tick.Text = "✔"
            if properties.OnChecked then properties.OnChecked(true) end
        else
            tick.Text = ""
            if properties.OnUnchecked then properties.OnUnchecked(false) end
        end
    end)

    checkbox.LayoutOrder = properties.LayoutOrder or 7  -- Ensure the checkbox is arranged properly
    return checkbox
end

-- Progress Bar component
function ArcanumLib:CreateProgressBar(properties)
    local progressBar = createElement("Frame", { Size = UDim2.new(0, properties.Width or 200, 0, 50), Parent = self.container })
    local fill = createElement("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = properties.FillColor or Color3.fromRGB(0, 255, 0), Parent = progressBar })

    -- Function to update progress
    function progressBar:SetProgress(value)
        fill.Size = UDim2.new(value, 0, 1, 0)
        if properties.OnProgress then properties.OnProgress(value) end
    end

    progressBar.LayoutOrder = properties.LayoutOrder or 8  -- Ensure the progress bar is arranged properly
    return progressBar
end

-- Modal/Popup component with shadow effect and smooth transition
function ArcanumLib:CreateModal(properties)
    local modal = createElement("Frame", {
        Size = UDim2.new(0, properties.Width or 300, 0, properties.Height or 200),
        Position = UDim2.new(0.5, -150, 0.5, -100),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.6,
        Parent = self.container,
        BorderRadius = UDim.new(0, 10),
        ZIndex = 2
    })

    local closeButton = createElement("TextButton", {
        Text = "Close",
        Size = UDim2.new(0, 100, 0, 50),
        Position = UDim2.new(0.5, -50, 1, -50),
        BackgroundColor3 = self.theme.ButtonColor,
        TextColor3 = self.theme.TextColor,
        BorderSizePixel = 0,
        Font = Enum.Font.Gotham,
        Parent = modal
    })

    closeButton.MouseButton1Click:Connect(function()
        modal:TweenPosition(UDim2.new(0.5, -150, 1, 100), "Out", "Quad", 0.3, true)
        modal:TweenSize(UDim2.new(0, properties.Width or 300, 0, 0), "Out", "Quad", 0.3, true)
    end)

    -- Show the modal with animation
    function modal:Show()
        modal.Visible = true
        modal:TweenPosition(UDim2.new(0.5, -150, 0.5, -100), "Out", "Quad", 0.3, true)
        modal:TweenSize(UDim2.new(0, properties.Width or 300, 0, properties.Height or 200), "Out", "Quad", 0.3, true)
    end

    modal.LayoutOrder = properties.LayoutOrder or 9  -- Ensure the modal is arranged properly
    return modal
end

return ArcanumLib

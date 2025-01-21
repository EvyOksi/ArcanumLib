-- ArcanumLib - Mobile UI Library with enhanced visuals
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

-- Add smooth animations to components
local function smoothTransition(element, property, targetValue, duration)
    local info = TweenInfo.new(duration, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tween = game:GetService("TweenService"):Create(element, info, { [property] = targetValue })
    tween:Play()
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

-- Create a frame with rounded corners and a shadow effect
function ArcanumLib:CreateRoundedFrame(properties)
    local frame = createElement("Frame", {
        Size = UDim2.new(0, properties.Width or 300, 0, properties.Height or 150),
        Position = properties.Position or UDim2.new(0.5, -150, 0.5, -75),
        BackgroundColor3 = properties.BackgroundColor or Color3.fromRGB(30, 30, 30),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Parent = self.container,
        ZIndex = 2,
        BorderRadius = UDim.new(0, 10)
    })
    
    -- Add shadow effect
    local shadow = createElement("Frame", {
        Size = UDim2.new(1, 4, 1, 4),
        Position = UDim2.new(0, -2, 0, -2),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.6,
        Parent = frame,
        ZIndex = 1,
        BorderRadius = UDim.new(0, 10)
    })

    -- Smooth transition for opening the frame
    frame.Visible = false
    function frame:Open()
        frame.Visible = true
        smoothTransition(frame, "Position", UDim2.new(0.5, -150, 0.5, -75), 0.3)
        smoothTransition(frame, "Size", UDim2.new(0, properties.Width or 300, 0, properties.Height or 150), 0.3)
    end

    return frame
end

-- Create button with rounded corners and glow effect
function ArcanumLib:CreateButton(properties)
    local button = createElement("TextButton", {
        Text = properties.Text or "Click Me",
        Size = UDim2.new(0, properties.Width or 200, 0, properties.Height or 50),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = properties.BackgroundColor or Color3.fromRGB(50, 50, 255),
        TextColor3 = properties.TextColor or Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = properties.TextSize or 18,
        Parent = self.container,
        BorderSizePixel = 0,
        ZIndex = 2,
        BorderRadius = UDim.new(0, 10)
    })

    -- Add glow effect to the button when hovered
    button.MouseEnter:Connect(function()
        smoothTransition(button, "BackgroundColor3", Color3.fromRGB(0, 200, 255), 0.2)
    end)

    button.MouseLeave:Connect(function()
        smoothTransition(button, "BackgroundColor3", properties.BackgroundColor or Color3.fromRGB(50, 50, 255), 0.2)
    end)

    button.MouseButton1Click:Connect(function()
        if properties.OnClick then properties.OnClick() end
    end)

    return button
end

-- Dropdown component with smooth open/close transition
function ArcanumLib:CreateDropdown(properties)
    local dropdown = createElement("Frame", {
        Size = UDim2.new(0, properties.Width or 200, 0, properties.Height or 50),
        Position = properties.Position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        Parent = self.container,
        BorderRadius = UDim.new(0, 10),
        ZIndex = 2
    })
    
    local button = createElement("TextButton", {
        Text = properties.ButtonText or "Select",
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Color3.fromRGB(50, 50, 255),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Parent = dropdown,
        BorderSizePixel = 0,
        ZIndex = 3,
        BorderRadius = UDim.new(0, 10)
    })
    
    local list = createElement("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0),
        Visible = false,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        BorderSizePixel = 0,
        Parent = dropdown,
        BorderRadius = UDim.new(0, 10),
        ZIndex = 1
    })

    for _, option in ipairs(properties.Options or {}) do
        local optionButton = createElement("TextButton", {
            Text = option,
            Size = UDim2.new(1, 0, 0, 50),
            BackgroundColor3 = Color3.fromRGB(50, 50, 255),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamBold,
            TextSize = 18,
            Parent = list,
            BorderSizePixel = 0,
            ZIndex = 1,
            BorderRadius = UDim.new(0, 10)
        })

        optionButton.MouseButton1Click:Connect(function()
            button.Text = option
            list.Visible = false
            if properties.OnSelect then properties.OnSelect(option) end
        end)
    end

    button.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
    end)

    return dropdown
end

-- Toggle Button component with smooth transition
function ArcanumLib:CreateToggleButton(properties)
    local toggleButton = createElement("TextButton", { 
        Text = properties.OnText or "On", 
        Size = UDim2.new(0, 100, 0, 50), 
        Parent = self.container,
        BackgroundColor3 = properties.BackgroundColor or Color3.fromRGB(0, 255, 0)
    })
    toggleButton.BorderSizePixel = 0
    toggleButton.BorderRadius = UDim.new(0, 10)

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

    return toggleButton
end

-- Slider component with smooth animation
function ArcanumLib:CreateSlider(properties)
    local slider = createElement("Frame", { 
        Size = UDim2.new(0, properties.Width or 200, 0, 50), 
        Parent = self.container 
    })
    local thumb = createElement("Frame", { 
        Size = UDim2.new(0, 10, 1, 0), 
        BackgroundColor3 = properties.ThumbColor or Color3.fromRGB(0, 0, 255), 
        Parent = slider 
    })
    
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

    return slider
end

-- Label component with rounded corners
function ArcanumLib:CreateLabel(properties)
    local label = createElement("TextLabel", { 
        Text = properties.Text or "Label", 
        Size = UDim2.new(0, properties.Width or 200, 0, 50), 
        Parent = self.container 
    })
    label.TextColor3 = properties.TextColor or Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1

    return label
end

-- Modal component with shadow effect and smooth transition
function ArcanumLib:CreateModal(properties)
    local modal = createElement("Frame", {
        Size = UDim2.new(0, properties.Width or 300, 0, properties.Height or 200),
        Position = UDim2.new(0.5, -150, 0.5, -100),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.7,
        Parent = self.container,
        BorderRadius = UDim.new(0, 10),
        ZIndex = 2
    })

    -- Add shadow effect
    local shadow = createElement("Frame", {
        Size = UDim2.new(1, 5, 1, 5),
        Position = UDim2.new(0, -2, 0, -2),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.5,
        Parent = modal,
        ZIndex = 1,
        BorderRadius = UDim.new(0, 10)
    })

    -- Close button
    local closeButton = createElement("TextButton", {
        Text = "Close",
        Size = UDim2.new(0, 100, 0, 40),
        Position = UDim2.new(0.5, -50, 1, -40),
        BackgroundColor3 = Color3.fromRGB(255, 50, 50),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Parent = modal
    })

    closeButton.MouseButton1Click:Connect(function()
        modal:Destroy()
    end)

    return modal
end

return ArcanumLib

--// Scripts.SM Premium Fake Executor Loader
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- GUI Utilities
local function createCorner(radius, parent)
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, radius)
    uic.Parent = parent
end
local function tween(obj, props, time, style, dir)
    TweenService:Create(obj, TweenInfo.new(time or 0.5, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptsSM_UI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

-- Clear existing GUIs except ours
local function clearAllGUIs()
    for _, gui in ipairs(CoreGui:GetChildren()) do if gui ~= ScreenGui then pcall(function() gui:Destroy() end) end end
    for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do pcall(function() gui:Destroy() end) end
end
clearAllGUIs()
CoreGui.DescendantAdded:Connect(function(obj) if not obj:IsDescendantOf(ScreenGui) then pcall(function() obj:Destroy() end) end end)
LocalPlayer.PlayerGui.DescendantAdded:Connect(function(obj) pcall(function() obj:Destroy() end) end)

-- Camera lock
Camera.CameraType = Enum.CameraType.Scriptable
Camera.CFrame = CFrame.new(9999,9999,9999)

-- Blur
local Blur = Instance.new("BlurEffect")
Blur.Size = 20
Blur.Parent = game.Lighting

-------------------------------
-- Stage 1: Loading Screen
-------------------------------
local LoadingFrame = Instance.new("Frame")
LoadingFrame.Size = UDim2.new(0,320,0,170)
LoadingFrame.Position = UDim2.new(0.5,-160,0.5,-85)
LoadingFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
LoadingFrame.BorderSizePixel = 0
LoadingFrame.Parent = ScreenGui
createCorner(10, LoadingFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,35)
Title.BackgroundTransparency = 1
Title.Text = "Scripts.SM"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = LoadingFrame

local Help = Instance.new("TextLabel")
Help.Size = UDim2.new(1,0,0,20)
Help.Position = UDim2.new(0,0,0,40)
Help.BackgroundTransparency = 1
Help.Text = "Not Working? Get Help Here! discord.gg/eXzpA4kjja"
Help.TextColor3 = Color3.fromRGB(200,200,200)
Help.Font = Enum.Font.Gotham
Help.TextSize = 13
Help.Parent = LoadingFrame

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1,-20,0,20)
Status.Position = UDim2.new(0,10,0,70)
Status.BackgroundTransparency = 1
Status.Text = "Starting..."
Status.TextColor3 = Color3.fromRGB(255,255,255)
Status.Font = Enum.Font.Gotham
Status.TextSize = 15
Status.Parent = LoadingFrame

local BarBG = Instance.new("Frame")
BarBG.Size = UDim2.new(1,-20,0,15)
BarBG.Position = UDim2.new(0,10,0,100)
BarBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
BarBG.BorderSizePixel = 0
BarBG.Parent = LoadingFrame
createCorner(8, BarBG)

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0,0,1,0)
BarFill.BackgroundColor3 = Color3.fromRGB(0,170,255)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBG
createCorner(8, BarFill)

local Messages = {"Fetching Scripts...","Connecting to our servers...","Bypassing Security...","Loading Modules...","Injecting Scripts...","Optimizing Performance...","Gathering Player Data...","Finalizing Connection..."}
local Errors = {"Handshake with server failed","Disconnected from server","Invalid response from host","Reconnecting...","Data fetch failed"}

for _, msg in ipairs(Messages) do
    local duration = math.random(1,3)
    local errorChance = math.random(1,100) <= 3
    if errorChance then
        Status.Text = Errors[math.random(1,#Errors)]
        BarFill.Size = UDim2.new(0,0,1,0)
        wait(math.random(1,2))
        Status.Text = "Retrying..."
        wait(1)
    end
    Status.Text = msg
    tween(BarFill,{Size=UDim2.new(1,0,1,0)},duration)
    wait(duration)
    BarFill.Size = UDim2.new(0,0,1,0)
end
LoadingFrame.Visible = false

-------------------------------
-- Stage 2: Game Selection (Redesigned)
-------------------------------
local function gameSelection()
    clearAllGUIs()
    local MenuFrame = Instance.new("Frame")
    MenuFrame.Size = UDim2.new(0,480,0,340)
    MenuFrame.Position = UDim2.new(0.5,-240,0.5,-170)
    MenuFrame.BackgroundColor3 = Color3.fromRGB(28,28,28)
    createCorner(16, MenuFrame)
    MenuFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,50)
    Title.BackgroundTransparency = 1
    Title.Text = "Select Your Game"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 22
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Parent = MenuFrame

    local ButtonContainer = Instance.new("UIGridLayout")
    ButtonContainer.CellSize = UDim2.new(0, 200, 0, 50)
    ButtonContainer.CellPadding = UDim2.new(0, 20, 0, 12)
    ButtonContainer.FillDirection = Enum.FillDirection.Horizontal
    ButtonContainer.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ButtonContainer.VerticalAlignment = Enum.VerticalAlignment.Top
    ButtonContainer.SortOrder = Enum.SortOrder.LayoutOrder

    local ContainerFrame = Instance.new("Frame")
    ContainerFrame.Size = UDim2.new(1,0,1,0)
    ContainerFrame.BackgroundTransparency = 1
    ContainerFrame.Parent = MenuFrame
    ButtonContainer.Parent = ContainerFrame

    local Games = {"Grow a Garden","Steal a Brain Rot","Pls Donate","Starving Artists","Bloxfruit"}
    for _, name in ipairs(Games) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,50)
        btn.Text = name
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 16
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        createCorner(14, btn)
        btn.Parent = ContainerFrame

        btn.MouseButton1Click:Connect(function()
            if name ~= "Grow a Garden" then
                Status.Text = "Something went wrong..."
                BarFill.Size = UDim2.new(0,0,1,0)
                tween(BarFill,{Size=UDim2.new(1,0,1,0)},1)
                wait(1)
                BarFill.Size = UDim2.new(0,0,1,0)
                MenuFrame:Destroy()
                gameSelection() -- reload menu
            else
                MenuFrame:Destroy()
                hackMenu()
            end
        end)
    end
end

-------------------------------
-- Stage 3: Hack Menu (Redesigned)
-------------------------------
function hackMenu()
    clearAllGUIs()
    local HackFrame = Instance.new("Frame")
    HackFrame.Size = UDim2.new(0,500,0,420)
    HackFrame.Position = UDim2.new(0.5,-250,0.5,-210)
    HackFrame.BackgroundColor3 = Color3.fromRGB(28,28,28)
    createCorner(16,HackFrame)
    HackFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1,0,0,50)
    Title.BackgroundTransparency = 1
    Title.Text = "Select Hacks"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.TextColor3 = Color3.fromRGB(255,255,255)
    Title.Parent = HackFrame

    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1,-40,1,-110)
    Scroll.Position = UDim2.new(0,20,0,60)
    Scroll.BackgroundTransparency = 0.2
    Scroll.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 6
    Scroll.Parent = HackFrame
    createCorner(12, Scroll)

    local ListLayout = Instance.new("UIListLayout", Scroll)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0,8)

    local Hacks = {"ESP","Auto Plant","Auto Sell","Auto Buy","Pet Spawner","AI Help","Seed Spawner","Egg Spawner","Pet Duper","Item Duper","Much More"}
    for _, text in ipairs(Hacks) do
        local cb = Instance.new("TextButton")
        cb.Size = UDim2.new(1,0,0,38)
        cb.BackgroundColor3 = Color3.fromRGB(50,50,50)
        cb.TextColor3 = Color3.fromRGB(255,255,255)
        cb.Font = Enum.Font.Gotham
        cb.TextSize = 14
        cb.Text = "[ ] "..text
        createCorner(10, cb)
        cb.Parent = Scroll

        local checked = false
        cb.MouseButton1Click:Connect(function()
            checked = not checked
            cb.Text = (checked and "[✔] " or "[ ] ")..text
        end)
    end

    local NextBtn = Instance.new("TextButton")
    NextBtn.Size = UDim2.new(0,140,0,45)
    NextBtn.Position = UDim2.new(0.5,-70,1,-50)
    NextBtn.AnchorPoint = Vector2.new(0,1)
    NextBtn.Text = "Next"
    NextBtn.TextColor3 = Color3.fromRGB(255,255,255)
    NextBtn.Font = Enum.Font.GothamBold
    NextBtn.TextSize = 16
    NextBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
    createCorner(12, NextBtn)
    NextBtn.Parent = HackFrame

    NextBtn.MouseButton1Click:Connect(function()
        clearAllGUIs()
        AIChat()
    end)
end

-------------------------------
-- Stage 4: AI Chat (Redesigned)
-------------------------------
function AIChat()
    clearAllGUIs()
    local ChatFrameMain = Instance.new("Frame")
    ChatFrameMain.Size = UDim2.new(0,500,0,400)
    ChatFrameMain.Position = UDim2.new(0.5,-250,0.5,-200)
    ChatFrameMain.BackgroundColor3 = Color3.fromRGB(28,28,28)
    createCorner(16, ChatFrameMain)
    ChatFrameMain.Parent = ScreenGui

    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1,0,0,40)
    Header.BackgroundTransparency = 1
    Header.Text = "Please Test AI before playing game to get information"
    Header.TextColor3 = Color3.fromRGB(255,255,255)
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 16
    Header.Parent = ChatFrameMain

    local ChatScroll = Instance.new("ScrollingFrame")
    ChatScroll.Size = UDim2.new(1,-20,1,-100)
    ChatScroll.Position = UDim2.new(0,10,0,50)
    ChatScroll.BackgroundTransparency = 0.2
    ChatScroll.BackgroundColor3 = Color3.fromRGB(40,40,40)
    ChatScroll.BorderSizePixel = 0
    ChatScroll.ScrollBarThickness = 6
    ChatScroll.Parent = ChatFrameMain
    createCorner(12, ChatScroll)

    local ChatLayout = Instance.new("UIListLayout", ChatScroll)
    ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ChatLayout.Padding = UDim.new(0,6)

    local InputBox = Instance.new("TextBox")
    InputBox.Size = UDim2.new(0.8,0,0,35)
    InputBox.Position = UDim2.new(0,10,1,-45)
    InputBox.AnchorPoint = Vector2.new(0,0)
    InputBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
    InputBox.TextColor3 = Color3.fromRGB(255,255,255)
    InputBox.PlaceholderText = "Type your question..."
    createCorner(10, InputBox)
    InputBox.Parent = ChatFrameMain

    local SendBtn = Instance.new("TextButton")
    SendBtn.Size = UDim2.new(0.15,0,0,35)
    SendBtn.Position = UDim2.new(0.82,0,1,-45)
    SendBtn.AnchorPoint = Vector2.new(0,0)
    SendBtn.Text = "Send"
    SendBtn.TextColor3 = Color3.fromRGB(255,255,255)
    SendBtn.Font = Enum.Font.GothamBold
    SendBtn.TextSize = 14
    SendBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
    createCorner(10, SendBtn)
    SendBtn.Parent = ChatFrameMain

    local function addMessage(sender,text)
        local msg = Instance.new("TextLabel")
        msg.Size = UDim2.new(1,0,0,30)
        msg.BackgroundTransparency = 1
        msg.TextXAlignment = Enum.TextXAlignment.Left
        msg.TextYAlignment = Enum.TextYAlignment.Top
        msg.TextWrapped = true
        msg.Text = sender..": "..text
        msg.TextColor3 = Color3.fromRGB(255,255,255)
        msg.Font = Enum.Font.Gotham
        msg.TextSize = 14
        msg.Parent = ChatScroll
        ChatScroll.CanvasPosition = Vector2.new(0, ChatScroll.AbsoluteCanvasSize.Y)
    end

    local function publicSearch(query)
        local url = "https://api.duckduckgo.com/?q="..query:gsub(" ","+").."&format=json&no_html=1&skip_disambig=1"
        local response
        local success, err = pcall(function()
            if syn then response = syn.request({Url=url, Method="GET"})
            elseif http_request then response = http_request({Url=url, Method="GET"})
            else error("No compatible HTTP request function found.") end
        end)
        if not success or not response or not response.Body then return "Error fetching data." end
        local data
        local decodeSuccess = pcall(function() data = HttpService:JSONDecode(response.Body) end)
        if not decodeSuccess then return "Error decoding response." end
        if data.AbstractText and data.AbstractText ~= "" then return data.AbstractText end
        if data.RelatedTopics and #data.RelatedTopics > 0 then
            for _, topic in ipairs(data.RelatedTopics) do
                if topic.Text and topic.Text ~= "" then return topic.Text end
            end
        end
        return "No answer found."
    end

    SendBtn.MouseButton1Click:Connect(function()
        local question = InputBox.Text
        if question ~= "" then
            addMessage("You", question)
            InputBox.Text = ""
            addMessage("AI", "Searching...")
            local answer = publicSearch(question)
            addMessage("AI", answer)
        end
    end)

    InputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then SendBtn.MouseButton1Click:Fire() end
    end)
end

-- Start first transition
gameSelection()

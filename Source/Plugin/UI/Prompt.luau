local AddStroke = require("./AddEffects/AddStroke")
local BaseGui = require("./BaseGui")
local BackgroundFrame = require("./BackgroundFrame")
local BaseText = require("./BaseText")
local module = {}

local messageObject: GuiObject?

local backgroundFrame = BackgroundFrame({
	CornerRadius = UDim.new(0, 0),

	Size = UDim2.fromScale(1, 1),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),

	Transparency = 0.5,

	NoStyle = true,
	NoStroke = true,

	Visible = false,

	Name = "BackgroundFrame",
	Parent = script.Parent :: Instance,
})

backgroundFrame.BackgroundColor3 = Color3.new(0, 0, 0)

local frame = BackgroundFrame({
	PaddingParams = {
		Left = UDim.new(0, 4),
		Right = UDim.new(0, 4),
		Top = UDim.new(0, 4),
		Bottom = UDim.new(0, 4),
	},

	Size = UDim2.fromScale(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),

	Visible = true,

	Name = "PromptFrame",
	Parent = backgroundFrame :: Instance,
})

local titleLabel = BaseText(Instance.new("TextLabel"), {
	BaseGui = {
		Transparency = 1,
		Size = UDim2.fromScale(1, 0.25),

		Name = "TitleLabel",
		Parent = frame :: Instance,
	},
})

local responsesFrame = BaseGui(Instance.new("Frame"), {
	PaddingParams = {
		Left = UDim.new(0, 10),
		Right = UDim.new(0, 10),
		Top = UDim.new(0.25, 0),
		Bottom = UDim.new(0.25, 0),
	},

	Size = UDim2.fromScale(1, 0.5),
	Position = UDim2.fromScale(0, 0.5),
	Transparency = 1,

	Name = "ResponsesFrame",
	Parent = frame :: Instance,
})

do
	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Horizontal
	listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	listLayout.Padding = UDim.new(0, 8)
	listLayout.Parent = responsesFrame
end

local confirmButton = BaseText(AddStroke(Instance.new("TextButton")), {
	BaseGui = {
		Size = UDim2.fromScale(0.5, 1),

		Name = "ConfirmButton",
		Parent = responsesFrame :: Instance,
	},

	Text = "OK",
})

local cancelButton = BaseText(AddStroke(Instance.new("TextButton")), {
	BaseGui = {
		Size = UDim2.fromScale(0.5, 1),

		Name = "CancelButton",
		Parent = responsesFrame :: Instance,
	},

	Text = "Cancel",
})

local confirmConn: RBXScriptConnection?
local cancelConn: RBXScriptConnection?

local function reset(): ()
	if confirmConn then
		confirmConn:Disconnect()
	end

	if cancelConn then
		cancelConn:Disconnect()
	end

	if messageObject then
		messageObject:Destroy()
	end

	backgroundFrame.Visible = false
	backgroundFrame.Parent = nil
end

local function runAndClose<T>(callback: (value: T) -> (), value: T): (...any) -> ()
	return function(): ()
		reset()
		callback(value)
	end
end

function module.ShowConfirmationPrompt(parent: Instance, title: string, message: string, onResponse: (boolean) -> ()): ()
	reset()

	titleLabel.Text = title

	local messageLabel = BaseText(Instance.new("TextLabel"), {
		BaseGui = {
			Transparency = 1,
			Position = UDim2.fromScale(0, 0.25),
			Size = UDim2.fromScale(1, 0.25),

			Name = "MessageLabel",
			Parent = frame :: Instance,
		},

		TextScaled = true,
		Text = message,
		Italics = true,

		Colour = Color3.new(0.5, 0.5, 0.5),
	})

	messageObject = messageLabel

	confirmConn = confirmButton.Activated:Connect(runAndClose(onResponse, true))
	cancelConn = cancelButton.Activated:Connect(runAndClose(onResponse, false))

	backgroundFrame.Visible = true
	backgroundFrame.Parent = parent
end

function module.ShowInputPrompt(parent: Instance, title: string, placeholderText: string, onResponse: (value: string?) -> ()): ()
	reset()

	titleLabel.Text = title

	local inputBox = BaseText(Instance.new("TextBox"), {
		BaseGui = {
			Transparency = 1,
			Position = UDim2.fromScale(0, 0.25),
			Size = UDim2.fromScale(1, 0.25),

			Name = "InputBox",
			Parent = frame :: Instance,
		},

		TextScaled = true,

		Colour = Color3.new(0.5, 0.5, 0.5),
	})

	inputBox.PlaceholderText = placeholderText
	inputBox.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5)

	messageObject = inputBox

	confirmConn = confirmButton.Activated:Connect(function()
		runAndClose(onResponse, inputBox.Text)()
	end)
	cancelConn = cancelButton.Activated:Connect(function()
		runAndClose(onResponse, nil)()
	end)

	backgroundFrame.Visible = true
	backgroundFrame.Parent = parent
end

return module
local AddStroke = require("./AddEffects/AddStroke")
local BaseGui = require("./BaseGui")
local BackgroundFrame = require("./BackgroundFrame")
local BaseText = require("./BaseText")
local module = {}

export type Response = "OK" | "Cancel" | "Reject"

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
	listLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = responsesFrame
end

local confirmButton = BaseText(AddStroke(Instance.new("TextButton")), {
	BaseGui = {
		Name = "ConfirmButton",
		Parent = responsesFrame :: Instance,

		Style = {
			BackgroundColor3 = {
				Color = Enum.StudioStyleGuideColor.MainButton,
			},
			TextColor3 = {
				Color = Enum.StudioStyleGuideColor.BrightText,
			},
		},
	},

	Text = "OK",
})

confirmButton.LayoutOrder = 3

local cancelButton = BaseText(AddStroke(Instance.new("TextButton")), {
	BaseGui = {
		Name = "CancelButton",
		Parent = responsesFrame :: Instance,
	},

	Text = "Cancel",
})

cancelButton.LayoutOrder = 1

local rejectButton = BaseText(AddStroke(Instance.new("TextButton")), {
	BaseGui = {
		Name = "RejectButton",
		Parent = responsesFrame,

		Visible = false,
	},

	Text = "No",
})

rejectButton.LayoutOrder = 2

local confirmConn: RBXScriptConnection?
local cancelConn: RBXScriptConnection?
local rejectConn: RBXScriptConnection?

local function reset(): ()
	if confirmConn then
		confirmConn:Disconnect()
	end

	if cancelConn then
		cancelConn:Disconnect()
	end

	rejectButton.Visible = false
	if rejectConn then
		rejectConn:Disconnect()
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

function module.ShowConfirmationPrompt(parent: Instance, title: string, message: string, rejectAvailable: boolean, onResponse: (response: Response) -> ()): ()
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

	confirmConn = confirmButton.Activated:Connect(runAndClose(onResponse, "OK"))
	cancelConn = cancelButton.Activated:Connect(runAndClose(onResponse, "Cancel"))

	if rejectAvailable then
		rejectButton.Visible = true
		rejectConn = rejectButton.Activated:Connect(runAndClose(onResponse, "Reject"))
	end

	backgroundFrame.Visible = true
	backgroundFrame.Parent = parent
end

function module.ShowInputPrompt(parent: Instance, title: string, placeholderText: string, initialText: string, onResponse: (value: string?) -> ()): ()
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

		Text = initialText,

		TextScaled = true,

		Colour = Color3.new(0.5, 0.5, 0.5),
	})

	inputBox.ClearTextOnFocus = false
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
local AddStroke = require("./UI/AddEffects/AddStroke")
local BaseGui = require("./UI/BaseGui")
local BackgroundFrame = require("./UI/BackgroundFrame")
local BaseText = require("./UI/BaseText")
local module = {}

local messageObject: GuiObject?

local frame = BackgroundFrame({
	PaddingParams = {
		Left = UDim.new(0, 4),
		Right = UDim.new(0, 4),
		Top = UDim.new(0, 4),
		Bottom = UDim.new(0, 4),
	},

	Size = UDim2.fromScale(0.2, 0.2),

	Visible = false,

	Name = "PromptFrame",
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

	frame.Visible = false
	frame.Parent = nil
end

local function runAndClose(callback: () -> ()): () -> ()
	return function(): ()
		reset()
		callback()
	end
end

function module.ShowConfirmationPrompt(parent: Instance, title: string, message: string, onConfirm: () -> (), onCancel: () -> ()): ()
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

	confirmConn = confirmButton.Activated:Connect(runAndClose(onConfirm))
	cancelConn = cancelButton.Activated:Connect(runAndClose(onCancel))

	frame.Visible = true
	frame.Parent = parent
end

return module
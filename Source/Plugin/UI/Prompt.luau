local AddListLayout = require("./AddEffects/AddListLayout")
local AddStroke = require("./AddEffects/AddStroke")
local BaseGui = require("./BaseGui")
local BackgroundFrame = require("./BackgroundFrame")
local BaseText = require("./BaseText")
local InputUI = require("./InputUI")
local module = {}

export type Response = "OK" | "Cancel"

local messageObject: GuiObject?

local backgroundFrame = BackgroundFrame({
	CornerRadius = UDim.new(0, 0),

	Size = UDim2.fromScale(1, 1),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),

	ZIndex = 9,

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

	ZIndex = 10,

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

		ZIndex = 11,

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

	ZIndex = 11,

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

		ZIndex = 12,

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

local cancelButton = BaseText(AddStroke(Instance.new("TextButton")), {
	BaseGui = {
		Size = UDim2.fromScale(0.5, 1),

		ZIndex = 12,

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

	confirmButton.Text = "OK"
	cancelButton.Text = "Cancel"

	backgroundFrame.Visible = false
	backgroundFrame.Parent = nil
end

local function runAndClose<T>(callback: (value: T) -> (), value: T): (...any) -> ()
	return function(): ()
		reset()
		callback(value)
	end
end

function module.ShowConfirmationPrompt(widget: DockWidgetPluginGui, title: string, message: string, onResponse: (response: Response) -> (), okText: string?, cancelText: string?): ()
	reset()

	titleLabel.Text = title

	local messageLabel = BaseText(Instance.new("TextLabel"), {
		BaseGui = {
			Transparency = 1,
			Position = UDim2.fromScale(0, 0.25),
			Size = UDim2.fromScale(1, 0.25),

			ZIndex = 11,

			Name = "MessageLabel",
			Parent = frame :: Instance,
		},

		TextScaled = true,
		Text = message,
		Italics = true,

		Colour = Color3.new(0.5, 0.5, 0.5),
	})

	if okText then
		confirmButton.Text = okText
	end

	if cancelText then
		cancelButton.Text = cancelText
	end

	messageObject = messageLabel

	confirmConn = confirmButton.Activated:Connect(runAndClose(onResponse, "OK"))
	cancelConn = cancelButton.Activated:Connect(runAndClose(onResponse, "Cancel"))

	backgroundFrame.Visible = true
	backgroundFrame.Parent = widget
end

function module.ShowInputPrompt(widget: DockWidgetPluginGui, title: string, inputs: {[string]: InputUI.PossibleInputs}, onResponse: (response: Response) -> (), okText: string?, cancelText: string?): ()
	reset()

	titleLabel.Text = title

	if okText then
		confirmButton.Text = okText
	end

	if cancelText then
		cancelButton.Text = cancelText
	end

	local inputFrame = BaseGui(Instance.new("Frame"), {
		Transparency = 1,
		Position = UDim2.fromScale(0, 0.25),
		Size = UDim2.fromScale(1, 0.25),

		ZIndex = 11,

		Name = "InputFrame",
		Parent = frame :: Instance,
	})

	AddListLayout(inputFrame, {
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		Padding = UDim.new(0, 5),
		VerticalAlignment = Enum.VerticalAlignment.Top,
	})

	for name, default in inputs do
		local input = InputUI.CreateInput(name, default, default, function(value)
			inputs[name] = value
		end, function(reason)
			module.ShowConfirmationPrompt(widget, "Number expected", "Please enter a valid number", function(response) end)
		end)

		input.Size = UDim2.fromScale(1, 0.5)

		for _, v in input:GetDescendants() do
			if v:IsA("GuiObject") then
				v.ZIndex = 12
			end
		end
		input.ZIndex = 12

		input.Parent = inputFrame
	end

	messageObject = inputFrame

	confirmConn = confirmButton.Activated:Connect(runAndClose(onResponse, "OK"))
	cancelConn = cancelButton.Activated:Connect(runAndClose(onResponse, "Cancel"))

	backgroundFrame.Visible = true
	backgroundFrame.Parent = widget
end

return module
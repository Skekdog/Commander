local GetPlugin = require("../Lib/GetPlugin")
local Execute = require("./Core/Execute")
local Presets = require("./Core/Presets")
local SaveToDisk = require("./Core/SaveToDisk")
local BackgroundFrame = require("./UI/BackgroundFrame")
local BaseGui = require("./UI/BaseGui")
local BaseText = require("./UI/BaseText")
local Prompt = require("./UI/Prompt")
local ScrollFrame = require("./UI/ScrollFrame")
local Style = require("./UI/Style")
local Highlighter = require(script.Parent.Parent.Lib.Highlighter) -- Luau lsp doesn't correctly handle string requires with rojo projects yet (init files?) correctly yet

local plugin = GetPlugin

Highlighter.matchStudioSettings()

local module = {}

local widget = plugin:CreateDockWidgetPluginGui("Commander", DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	false,
	true,
	800,
	400,
	600,
	350
	)
)

widget.Name = "Commander"
widget.Title = "Commander"
widget.ResetOnSpawn = false
widget.Enabled = false

local frame = BackgroundFrame({
	CornerRadius = UDim.new(0, 0),
	PaddingParams = {
		Left = UDim.new(0, 5),
		Right = UDim.new(0, 5),
		Top = UDim.new(0, 5),
		Bottom = UDim.new(0, 5),
	},

	Size = UDim2.fromScale(1, 1),

	Name = "MainFrame", -- we're hacking into the mainframe!!!
	Parent = widget,
})

local editorFrame = BackgroundFrame({
	CornerRadius = UDim.new(0, 0),

	Position = UDim2.fromScale(0.25, 0),
	Size = UDim2.fromScale(0.75, 0.85),

	Transparency = 1,

	Name = "EditorFrame",
	Parent = frame,
})

local editorTitle = BaseText(Instance.new("TextLabel"), {
	BaseGui = {
		Size = UDim2.new(1, 0, 0.1, 8),
		CornerRadius = UDim.new(0, 0),

		PaddingParams = {
			Left = UDim.new(0, 0),
			Right = UDim.new(0, 0),
			Top = UDim.new(0, 5),
			Bottom = UDim.new(0, 13),
		},

		Name = "EditorTitle",
		Parent = editorFrame :: Instance,
	},

	Text = "Untitled Script",
	TextScaled = true,
})

local scrollingFrame = ScrollFrame({
	BaseGui = {
		Size = UDim2.fromScale(1, 0.9),
		Position = UDim2.fromScale(0, 0.1),

		Name = "ScrollingFrame",
		Parent = editorFrame :: Instance,

		Style = {
			BackgroundColor3 = {
				Color = Enum.StudioStyleGuideColor.ScriptBackground,
			}
		},
	},

	ScrollingDirection = Enum.ScrollingDirection.XY,
	AutomaticCanvasSize = Enum.AutomaticSize.XY,
})

local LINE_NUMBER_OFFSET_SIZE = 40

local codeEditor = BaseText(Instance.new("TextBox"), {
	BaseGui = {
		CornerRadius = UDim.new(0, 0),
		PaddingParams = {
			Left = UDim.new(0, 8),
			Top = UDim.new(0, 8),
			Right = UDim.new(0, 0),
			Bottom = UDim.new(0, 0),
		},

		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(1, -LINE_NUMBER_OFFSET_SIZE, 1, 0),
		Position = UDim2.fromOffset(LINE_NUMBER_OFFSET_SIZE, 0),

		Transparency = 1,

		Name = "CodeEditor",
		Parent = scrollingFrame :: Instance,
	},

	Font = Font.fromId(16658246179),

	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,

	TextWrapped = false,
	TextScaled = false,

	FontSize = 18,
})

codeEditor.ClearTextOnFocus = false
codeEditor.MultiLine = true

local lineNumbers = BaseText(Instance.new("TextLabel"), {
	BaseGui = {
		CornerRadius = UDim.new(0, 0),
		PaddingParams = {
			Left = UDim.new(0, 8),
			Top = UDim.new(0, 8),
			Right = UDim.new(0, 0),
			Bottom = UDim.new(0, 0),
		},

		Transparency = 1,

		Size = UDim2.new(0, LINE_NUMBER_OFFSET_SIZE, 1, 0),
		Position = UDim2.fromScale(0, 0),

		Name = "LineNumbers",
		Parent = scrollingFrame :: Instance,

		AutomaticSize = Enum.AutomaticSize.Y,
	},

	TextXAlignment = Enum.TextXAlignment.Right,
	TextYAlignment = Enum.TextYAlignment.Top,
	TextScaled = false,
	TextWrapped = false,

	Font = Font.fromId(16658246179),

	Text = "1",

	FontSize = 18,
})

codeEditor:GetPropertyChangedSignal("Text"):Connect(function()
	local lineCount = #codeEditor.Text:split("\n")

	lineNumbers.Text = ""
	for i = 1, lineCount do
		lineNumbers.Text = lineNumbers.Text .. i .. "\n"
	end
end)

Highlighter.highlight({
	textObject = codeEditor,
})

local savedScriptsFrame = ScrollFrame({
	BaseGui = {
		PaddingParams = {
			Left = UDim.new(0, 2),
			Right = UDim.new(0, 2),
			Top = UDim.new(0, 2),
			Bottom = UDim.new(0, 2),
		},
		Size = UDim2.fromScale(0.25, 1),

		Transparency = 1,

		AutomaticSize = Enum.AutomaticSize.Y,

		Name = "SavedScriptsFrame",
		Parent = frame :: Instance,
	},

	HorizontalScrollBarInset = Enum.ScrollBarInset.None,
})

do
	local gridLayout = Instance.new("UIGridLayout")

	gridLayout.CellSize = UDim2.fromScale(1, 0.1)
	gridLayout.CellPadding = UDim2.fromOffset(5, 5)

	gridLayout.Parent = savedScriptsFrame :: Instance
end

local savedScriptButton = (BaseText(Instance.new("TextButton")) :: any) :: TextButton & {
	["TitleLabel"]: TextLabel,
	["DeleteButton"]: ImageButton,
}

do
	local deleteButton = BaseGui(Instance.new("ImageButton"), {
		CornerRadius = UDim.new(0, 0),
		Position = UDim2.fromScale(0.75, 0.5),
		Size = UDim2.fromScale(0.25, 1),

		AnchorPoint = Vector2.new(0, 0.5),

		Transparency = 1,

		Name = "DeleteButton",
		Parent = savedScriptButton :: Instance,
	})

	deleteButton.ZIndex = 2
	deleteButton.ImageContent = Content.fromAssetId(14002617467)
	deleteButton.ImageColor3 = Color3.new(1, 0, 0)
	deleteButton.ScaleType = Enum.ScaleType.Fit

	BaseText(Instance.new("TextLabel"), {
		BaseGui = {
			CornerRadius = UDim.new(0, 0),
			Size = UDim2.fromScale(1, 1),
			PaddingParams = {
				Left = UDim.new(0, 8),
				Right = UDim.new(0.25, 16),
				Top = UDim.new(0, 0),
				Bottom = UDim.new(0, 0),
			},

			Transparency = 1,

			Name = "TitleLabel",
			Parent = savedScriptButton :: Instance,
		}
	})
end

local codeActionsFrame = BackgroundFrame({
	PaddingParams = {
		Left = UDim.new(0, 5),
		Right = UDim.new(0, 5),
		Top = UDim.new(0, 5),
		Bottom = UDim.new(0, 5),
	},

	Size = UDim2.new(0.75, 0, 0.15, -5),
	Position = UDim2.new(0.25, 0, 0.85, 5),

	Name = "CodeActionsFrame",
	Parent = frame,
})

local function addSavedScript(name: string): ()
	local button = savedScriptButton:Clone()

	button.TitleLabel.Text = name
	button.Name = name .. "_SavedScriptButton"

	button.Activated:Connect(function()
		codeEditor.Text = Presets.LoadPreset(name) or error("Failed to load preset " .. name)
	end)

	button.DeleteButton.Activated:Connect(function()
		local response: boolean?
		Prompt.ShowConfirmationPrompt(frame, "Delete Script", name, function(confirmed: boolean)
			response = confirmed
		end)

		while response == nil do
			task.wait()
		end

		if not response then
			return
		end

		Presets.DeletePreset(name)
		button:Destroy()
	end)

	Style(button)
	Style(button.TitleLabel)
	button.Parent = savedScriptsFrame :: Instance
end

for name in Presets.GetPresets() do
	addSavedScript(name)
end

BaseText(Instance.new("TextButton"), {
	BaseGui = {
		Size = UDim2.fromScale(0.25, 1),
		Position = UDim2.fromScale(0, 0),

		Name = "SaveButton",
		Parent = codeActionsFrame :: Instance,
	},

	Text = "Save",
	TextScaled = true,
}).Activated:Connect(function()
	local name: string | false?
	Prompt.ShowInputPrompt(frame, "Save Script", "Enter a name for the script", function(value: string?)
		if value == nil then
			name = false
			return
		end
		name = value
	end)

	while name == nil do
		task.wait()
	end

	if name == false then
		return
	end
	assert(name)

	local code = codeEditor.Text

	local alreadyExists = Presets.GetPresets()[name] ~= nil

	Presets.UpdatePreset(name, code)

	if not alreadyExists then
		addSavedScript(name)
	end
end)

BaseText(Instance.new("TextButton"), {
	BaseGui = {
		Size = UDim2.fromScale(0.25, 1),
		Position = UDim2.new(0.25, 5, 0, 0),

		Name = "SaveToDiskButton",
		Parent = codeActionsFrame :: Instance,
	},

	Text = "Save to Disk",
	TextScaled = true,
}).Activated:Connect(function()
	SaveToDisk("Script", codeEditor.Text)
end)

BaseText(Instance.new("TextButton"), {
	BaseGui = {
		Size = UDim2.fromScale(0.25, 1),
		Position = UDim2.fromScale(0.75, 0),

		Name = "ExecuteButton",
		Parent = codeActionsFrame :: Instance,

		Style = {
			BackgroundColor3 = {
				Color = Enum.StudioStyleGuideColor.MainButton,
			},
			TextColor3 = {
				Color = Enum.StudioStyleGuideColor.BrightText,
			},
		}
	},

	Text = "Execute!",
	TextScaled = true,
}).Activated:Connect(function()
	Execute(codeEditor.Text)
end)

frame.Parent = widget

function module.ToggleWidget(enabled: boolean?): ()
	widget.Enabled = if typeof(enabled) == "boolean" then enabled else not widget.Enabled

	if widget.Enabled then
		codeEditor:CaptureFocus()
	end
end

module.Widget = widget

return module
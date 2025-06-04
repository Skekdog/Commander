local GetPlugin = require("../Lib/GetPlugin")
local Execute = require("./Core/Execute")
local Presets = require("./Core/Presets")
local SaveToDisk = require("./Core/SaveToDisk")
local Scripts = require("./Core/Scripts")
local BackgroundFrame = require("./UI/BackgroundFrame")
local BaseGui = require("./UI/BaseGui")
local BaseText = require("./UI/BaseText")
local Prompt = require("./UI/Prompt")
local ScrollFrame = require("./UI/ScrollFrame")
local Style = require("./UI/Style")

local plugin = GetPlugin

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

local savedScriptsFrame = ScrollFrame({
	BaseGui = {
		PaddingParams = {
			Left = UDim.new(0, 2),
			Right = UDim.new(0, 2),
			Top = UDim.new(0, 2),
			Bottom = UDim.new(0, 2),
		},
		Size = UDim2.fromScale(0.5, 1),

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

	deleteButton.ZIndex = 1
	deleteButton.ImageContent = Content.fromAssetId(15921650550)
	deleteButton.ImageColor3 = Color3.new(1, 1, 1)
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

	Size = UDim2.fromScale(0.5, 1),
	Position = UDim2.fromScale(0.5, 0),

	Name = "CodeActionsFrame",
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
		Parent = codeActionsFrame,
	},

	Text = Scripts.DEFAULT_SCRIPT.Source,
	TextScaled = true,
})

local function setActiveScript(name: string): ()
	Scripts.ActiveScript = Scripts.GetScript(name) or error("Script not found: " .. name)
	editorTitle.Text = name
end

local function openScript(scriptFile: Scripts.ScriptFile): ()
	local editorScript = Instance.new("Script")
	editorScript.Name = scriptFile.Name
	plugin:OpenScript(editorScript)
end

local function addSavedScript(name: string): ()
	local button = savedScriptButton:Clone()

	button.TitleLabel.Text = name
	button.Name = name .. "_SavedScriptButton"

	button.Activated:Connect(function()
		local scriptFile = Scripts.GetScript(name) or error("Script not found: " .. name)
		setActiveScript(name)
		openScript(scriptFile)
	end)

	button.DeleteButton.Activated:Connect(function()
		local response: boolean?
		Prompt.ShowConfirmationPrompt(frame, "Delete Script", name, false, function(confirmed)
			response = confirmed == "OK"
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

for _, scriptFile in Scripts.GetScripts() do
	addSavedScript(scriptFile.Name)
end

local saveToDiskButton = BaseText(Instance.new("TextButton"), {
	BaseGui = {
		Size = UDim2.fromScale(0.75, 0.1),
		Position = UDim2.new(0.5, 0, 0.3, -5),
		AnchorPoint = Vector2.new(0.5, 0),

		Name = "SaveToDiskButton",
		Parent = codeActionsFrame :: Instance,
	},

	Text = "Save to Disk",
	TextScaled = true,
})

saveToDiskButton.Activated:Connect(function()
	SaveToDisk(Scripts.ActiveScript.Name, Scripts.ActiveScript.Source)
end)

local executeButton = BaseText(Instance.new("TextButton"), {
	BaseGui = {
		Size = UDim2.fromScale(0.75, 0.1),
		Position = UDim2.new(0.5, 0, 0.5, 5),
		AnchorPoint = Vector2.new(0.5, 0),

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
})

executeButton.Activated:Connect(function()
	Execute(Scripts.ActiveScript.Source)
end)

frame.Parent = widget

function module.ToggleWidget(enabled: boolean?): ()
	widget.Enabled = if typeof(enabled) == "boolean" then enabled else not widget.Enabled
end

module.Widget = widget

return module
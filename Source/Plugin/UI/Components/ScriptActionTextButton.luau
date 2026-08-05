local TextSize = require("../TextSize")
local TextButton = require("./TextButton")

local function ScriptActionTextButton(props: {
	Text: string,
	Activated: (...unknown) -> (),
})
	return TextButton {
		Text = props.Text,
		Activated = props.Activated,

		Size = UDim2.fromScale(1, 0),

		TextSize = TextSize.Body,
	}
end

return ScriptActionTextButton
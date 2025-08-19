local HttpService = game:GetService("HttpService")
local GetPlugin = require("../../Lib/GetPlugin")
local DefaultScript = require("./DefaultScript")

local PluginStorage = {}

local plugin = GetPlugin

local function tryMigratePresets(): ()
	local presetsJson = plugin:GetSetting("Presets")
	if typeof(presetsJson) ~= "string" then
		return
	end

	local presets: {[string]: string} = HttpService:JSONDecode(presetsJson)
	plugin:SetSetting("Presets", nil)

	local migratedPresets: {[string]: DefaultScript.ScriptData} = {}

	for name, code in presets do
		migratedPresets[name] = {
			Source = code,
			Arguments = {},
		}
	end

	PluginStorage.WriteScripts(migratedPresets)
end

function PluginStorage.GetScripts(): {[string]: DefaultScript.ScriptData}
	tryMigratePresets()

	local scripts: string? = plugin:GetSetting("Scripts")
	if not scripts then
		return {
			[DefaultScript.Name] = DefaultScript,
		}
	end

	return HttpService:JSONDecode(scripts)
end

function PluginStorage.WriteScripts(scripts: {[string]: DefaultScript.ScriptData}): ()
	plugin:SetSetting("Scripts", HttpService:JSONEncode(scripts))
end

function PluginStorage.GetScript(name: string): DefaultScript.ScriptData?
	return PluginStorage.GetScripts()[name]
end

function PluginStorage.UpdateScript(name: string, data: DefaultScript.ScriptData): ()
	local scripts = PluginStorage.GetScripts()
	scripts[name] = data
	PluginStorage.WriteScripts(scripts)
end

function PluginStorage.DeleteScript(name: string): ()
	local scripts = PluginStorage.GetScripts()
	scripts[name] = nil
	PluginStorage.WriteScripts(scripts)
end

return PluginStorage

export type ScriptFile = {
	Name: string,
	Source: string,
	IsSaved: boolean,
}

local module = {}

module.DEFAULT_SCRIPT = {
	Name = "Untitled Script",
	Source = 'print("Hello, World!")',
	IsSaved = false,
}

local scripts: {[string]: ScriptFile?} = {}

module.ActiveScript = module.DEFAULT_SCRIPT

function module.GetScript(name: string): ScriptFile?
	return scripts[name]
end

function module.AddScript(name: string, source: string): ()
	scripts[name] = {
		Name = name,
		Source = source,
		IsSaved = true,
	}
end

function module.UpdateScript(name: string, source: string): ()
	(scripts[name] or error("Script not found")).Source = source
end

function module.DeleteScript(name: string): ()
	scripts[name] = nil
end

return module
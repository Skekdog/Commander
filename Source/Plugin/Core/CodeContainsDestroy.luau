
-- No this isn't super accurate, but if someone is doing Instance["Destroy"]() then that's their problem.
-- Maybe it is worth ignoring Destroy in comments though? Probably not for now at least.

local function CodeContainsDestroy(code: string): boolean
	return code:match("[:%.]%s*Destroy%s*%(") ~= nil
end

return CodeContainsDestroy
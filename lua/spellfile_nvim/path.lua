local M = {}

M.is_file = function(pth)
	local stat = vim.loop.fs_stat(pth)
	return stat ~= nil and stat.type ~= nil and stat.type == "file"
end

return M

parse = require("Module:Yaml").parse

p = {}
wiki = {}

function isList(t)
	if t[1] == nil then
		return false
	else
		return true
	end
end

function size(t)
	local count = 0
	for _ in pairs(t) do count = count + 1 end
	return count
end

function wiki.attr(t)
	local str = ""
	for k, v in pairs(t or {}) do
		str = k .. "='" .. v .. "' " .. str
	end
	return str
end

function wiki.td(str, attr)
	if attr ~= nil and size(attr) > 0 then
		str = wiki.attr(attr) .. "| " .. str
	end
	return "\n| " .. str
end

function wiki.link(str)
	return "[[" .. str .. "]]"
end

function wiki.table(str, attr)
	return "{| " .. wiki.attr(attr) .. str .. "\n|}"
end

function render(t, depth)
	local result = ""
	for i, k in ipairs(t._keys) do
		v = t[k]
		if isList(v) then
			result = result .. wiki.td(wiki.link(k), {style = "width: 8em; background: #f5f8fa;"}) .. wiki.td("[[" .. table.concat(v, "]] · [[") .. "]]") .. "\n|-"
		elseif type(v) == "table" then
			result = result .. wiki.td(wiki.link(k), {rowspan = size(v) - 1, style = "width: 8em; background: #f5f8fa;"}) .. render(v, depth + 1)
		end
	end
	return result
end

function p._main(yaml)
	return wiki.table(
		render(parse(yaml), 0),
		{class = "wikitable", style = "width: 100%; margin: 0; border-collapse: separate;"}
	)
end

function p.main(frame)
	return p._main(frame.args[1])	
end

p.parse = parse
return p

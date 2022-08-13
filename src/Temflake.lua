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
	for k, v in pairs(t) do
		if isList(v) then
			result = result .. wiki.td(wiki.link(k)) .. wiki.td("[[" .. table.concat(v, "]] · [[") .. "]]") .. "\n|-"
		elseif type(v) == "table" then
			result = result .. wiki.td(wiki.link(k), {rowspan = size(v)}) .. render(v, depth + 1)
		end
	end
	return result
end

function p.main(yaml)
	return wiki.table(
		render(parse(yaml), 0),
		{class = "wikitable", style = "width: 100%;"}
	)
end

p.parse = parse
return p
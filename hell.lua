--[[
	Metatable hell and more useful things
	
	"what the f*ck did you just bring upon this cursed land"
	
	made with regrets by Ale32bit
	
	https://github.com/Ale32bit-CC/hell-superset
	
	MIT LICENSE: https://github.com/Ale32bit-CC/hell-superset/blob/master/LICENSE
--]]

assert(debug, "Debug not found")
assert(debug.getmetatable, "debug.getmetatable not found")
assert(debug.setmetatable, "debug.setmetatable not found")

local StringMT = debug.getmetatable("")
local NumberMT = debug.getmetatable(0) or {}
local FunctionMT = debug.getmetatable(function() end) or {}
local BooleanMT = debug.getmetatable(true) or {}

local stringlib = StringMT.__index

local function getAddress(str)
	return loadstring("return 0x"..tostring(str):match("%w+$"))()
end

stringlib.tonumber = function(n)
	return tonumber(n)
end

StringMT.__add = function(a, b) 
	return tostring(a)..tostring(b)
end

StringMT.__sub = function(a, b)
	return (string.gsub(a,b,""))
end

StringMT.__unm = function(a)
	return string.reverse(a)
end

StringMT.__index = function(str, ix)
	if stringlib[ix] then return stringlib[ix] end
	if type(ix) == "number" then
		if ix > #str then return nil end
		return string.sub(str, ix, ix)
	end
	return nil
end

NumberMT.__index = {
	tostring = function(n)
		return tostring(n)
	end,
}

FunctionMT.globalPrototypes = {
	dump = string.dump,
	tostring = tostring,
	address = function(f)
		return (string.match(tostring(f),"%w+$"))
	end,
}

FunctionMT.prototypes = {}

FunctionMT.__index = function(self, k)
	if not FunctionMT.prototypes[getAddress(self)] then FunctionMT.prototypes[getAddress(self)] = {} end
	return FunctionMT.prototypes[getAddress(self)][k] or FunctionMT.globalPrototypes[k] or nil
end

FunctionMT.__newindex = function(self, k, v)
	if not FunctionMT.prototypes[getAddress(self)] then FunctionMT.prototypes[getAddress(self)] = {} end
	FunctionMT.prototypes[getAddress(self)][k] = v
end

FunctionMT.__concat = function(a, b)
	return function(...)
		local x = {a(...)}
		local y = {b(...)}
		return x, y
	end
end

BooleanMT.__add = function(a, b)
    return a or b
end

BooleanMT.__mul = function(a, b)
    return a and b
end

BooleanMT.__unm = function(a)
    return not a
end

BooleanMT.__mod = function(a, b)
    return a ~= b
end

debug.setmetatable("", StringMT)
debug.setmetatable(0, NumberMT)
debug.setmetatable(function() end, FunctionMT)
debug.setmetatable(true, BooleanMT)

--just kill me already

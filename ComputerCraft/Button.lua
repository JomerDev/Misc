-- TODO --
-- Needs a function to turn on and off most of the vars (border, hover, enabled, etc)

-- Start of the Object --
local Button = {}

font = love.graphics.newFont(14)

-- Local Functions --

local function toboolean(str) -- Returns the string as a boolean (true/false/nil)
	if tostring(type(str)) == "string" then
		if tostring(str) == "true" then
			return true
		elseif tostring(str) == "false" then
			return false
		else
			return nil
		end
	else
		return nil
	end
end

local function findArg(args, sa) -- Finds the arguments in the string that it gets
	for i,v in pairs(args) do
		if sa == "f=" and tostring(type(v)) == "function" then
			return v
		end
		local x,y = string.find(tostring(v),tostring(sa))
		if x and y then
			return string.sub(tostring(v),y+1)
		end
	end
	return nil
end

local function toColor(str) -- Splits up the colorstring into the rgba values
	if tostring(type(str)) == "string" and string.len(str) > 3 then
		local rgb = {}
		local l = 1
		for i in string.gmatch(str, "%d+") do
			rgb[l] = i
			l = l + 1
		end
		return {tonumber(rgb[1]),tonumber(rgb[2]),tonumber(rgb[3]),tonumber(rgb[4])}
	else 
		return false
	end
end

-- Global Functions --

function Button:new(...) -- Creates and returns a new instance of "button"
	local arg = {...}
	local new = {}
	setmetatable(new, {__index = self})
	-- initialises normal Variables and Tables -- 
	new.func = {}
	new.func.onPress = {}
	new.func.onRelease = {}
	new.func.onHover = {}
	new.func.notOnHover = {}
	new.var = {}
	new.var.self = {}
	new.var.self.colors = {}
	new.var.self.colors.now = {}
	new.var.self.colors.on = {}
	new.var.self.colors.off = {}
	new.var.self.colors.dis = {}
	new.var.self.state = "Off"
	new.var.self.pressed = false
	new.var.self.background = true
	new.var.self.border = true
	new.var.self.hover = false
	-- initialises Colors and Text, as well as the Coordinates
	new.name = findArg(arg, "n=") or "Unnamed"
	new.var.self.text = toboolean(findArg(arg, "t=")) or false
	new.x = tonumber(findArg(arg, "x=")) or 5
	new.y = tonumber(findArg(arg, "y=")) or 5
	new.w = tonumber(findArg(arg, "w=")) or new.w == nil and font:getWidth(new.name)
	new.h = tonumber(findArg(arg, "h=")) or new.h == nil and font:getHeight()
	-- the Background Color --
	new.var.self.colors.now.backgroundColor = {255,255,255,255}
	new.var.self.colors.off.backgroundColor = toColor(findArg(arg, "cbaOFF=")) or new.var.self.colors.off.backgroundColor == nil and {255,255,255,255}
	new.var.self.colors.on.backgroundColor = toColor(findArg(arg, "cbaON=")) or new.var.self.colors.on.backgroundColor == nil and {0,51,102,255}
	new.var.self.colors.dis.backgroundColor = toColor(findArg(arg, "cbaDIS=")) or new.var.self.colors.dis.backgroundColor == nil and {0,51,102,255}
	-- the Border Color --
	new.var.self.colors.now.borderColor = {0,0,0,255}
	new.var.self.colors.off.borderColor = toColor(findArg(arg, "cboOFF=")) or new.var.self.colors.off.borderColor == nil and {0,0,0,255}
	new.var.self.colors.on.borderColor = toColor(findArg(arg, "cboON=")) or new.var.self.colors.on.borderColor == nil and {0,0,0,255}
	new.var.self.colors.dis.borderColor = toColor(findArg(arg, "cboDIS=")) or new.var.self.colors.dis.borderColor == nil and {0,0,0,255}
	-- the Text Color --
	new.var.self.colors.now.textColor = {0,0,0,255}
	new.var.self.colors.on.textColor = toColor(findArg(arg, "ctON=")) or new.var.self.colors.on.textColor == nil and {0,0,0,255}
	new.var.self.colors.off.textColor = toColor(findArg(arg, "ctOFF=")) or new.var.self.colors.off.textColor == nil and {0,0,0,255}
	new.var.self.colors.dis.textColor = toColor(findArg(arg, "ctDIS=")) or new.var.self.colors.dis.textColor == nil and {0,51,102,255}
	-- the Hover Color --
	new.var.self.colors.now.hoverColor = {255,0,0,255} --{204,255,255,255}
	new.var.self.colors.on.hoverColor = toColor(findArg(arg, "chON=")) or new.var.self.colors.on.hoverColor == nil and {255,0,0,255}
	new.var.self.colors.off.hoverColor = toColor(findArg(arg, "chOFF=")) or new.var.self.colors.off.hoverColor == nil and {255,0,0,255}
	new.var.self.colors.dis.hoverColor = toColor(findArg(arg, "chDIS=")) or new.var.self.colors.dis.hoverColor == nil and {255,255,255,255}
	
	
	-- normal functions --
	local p = toboolean(findArg(arg, "k="))
	if not toboolean(findArg(arg, "k=")) then
		table.insert(new.func.onPress,function() if new.var.self.pressed then new.var.self.pressed = false new:changeColorMode("off") else new.var.self.pressed = true new:changeColorMode("on") end end)
		table.insert(new.func.onPress,function() if new.var.self.state == "On" then new.var.self.state = "Off" else new.var.self.state = "On" end end)
		table.insert(new.func.onHover,function() new.var.self.hover = true end)
		table.insert(new.func.notOnHover, function() new.var.self.hover = false end)
		table.insert(new.func.onRelease, function()  print("Released") end)
		table.insert(new.func.onPress, function() print("Pressed") end)
	end
	return new
end

function Button:addPressFunction(fun) -- Adds a function to the 'If Pressed do' table
	if tostring(type(fun)) == "function" then
		table.insert(self.func.onPress, fun)
	end
end

function Button:addReleaseFunction(fun) -- Adds a function to the 'If Released do' table
	if tostring(type(fun)) == "function" then
		table.insert(self.func.onRelease, fun)
	end
end

function Button:addHoverFunction(fun) -- Adds a function to the 'If Hover do' table
	if tostring(type(fun)) == "function" then
		table.insert(self.func.onHover, fun)
	end
end

function Button:addNotHoverFunction(fun) -- Adds a function to the 'If not Hover do' table
	if tostring(type(fun)) == "function" then
		table.insert(self.func.notOnHover, fun)
	end
end

function Button:changeColor(mode,var, ncolor) -- Changes or adds a color in a colormode
	if self.var.self.colors[mode] then
		self.var.self.colors[mode][var] = ncolor
	else
		self.var.self.colors[mode] = {}
		self.var.self.colors[mode][var] = ncolor
	end
end

function Button:changeColorMode(mode) -- Changes the Colors based on the mode
	if self.var.self.colors[mode] then
		for i,v in pairs(self.var.self.colors[mode]) do
			self.var.self.colors.now[i] = self.var.self.colors[mode][i]
		end
	end
end

function Button:draw() -- Draws the button out
	local fontW, fontH = font:getWidth(self.name or ''), font:getHeight()
    if self.w > font:getWidth(self.name) then
		w = (self.w - font:getWidth(self.name))/2
	else
		w = 0
		if self.text then
			self.w = font:getWidth(self.name)
		end
	end
	if self.h > font:getHeight() then
		h = (self.h - font:getHeight())/2
	else
		h = 0
		if self.text then
			self.h = font:getHeight()
		end
	end
	local ypos = (self.y + h)
    local xpos = (self.x + w)
	if true == false then --self.var.self.pressed then
		if self.backgroundColor_ON then
			self.backgroundColor = self.backgroundColor_ON
		end
		if self.hoverColor_ON then
			self.hoverColor = self.hoverColor_ON
		end
		if self.borderColor_ON then
			self.borderColor = self.borderColor_ON
		end
		if self.textColor_ON then
			self.textColor = self.textColor_ON
		end
		if self.backgroundColor_OFF then
			self.backgroundColor = self.backgroundColor_OFF
		end
		if self.hoverColor_OFF then
			self.hoverColor = self.hoverColor_OFF
		end
		if self.borderColor_OFF then
			self.borderColor = self.borderColor_OFF
		end
		if self.textColor_OFF then
			self.textColor = self.textColor_OFF
		end
	end
	if self.var.self.background then
        love.graphics.setColor(self.var.self.colors.now.backgroundColor)
        love.graphics.rectangle( 'fill', self.x, self.y, self.w , self.h )
    end
    if self.var.self.border then
		love.graphics.setLineWidth(1)
		love.graphics.setLineStyle('rough')
        love.graphics.setColor(self.var.self.colors.now.borderColor)
        love.graphics.rectangle( 'line', self.x, self.y, self.w+1, self.h )
    end
	if self.var.self.hover then
		love.graphics.setLineWidth(1)
		love.graphics.setLineStyle('rough')
		love.graphics.setColor(self.var.self.colors.now.hoverColor)
		love.graphics.rectangle( 'line', self.x - 1, self.y-1, self.w+3, self.h +2)
	end
	if self.var.self.text then
		love.graphics.setColor(self.var.self.colors.now.textColor)
		love.graphics.print( self.name, xpos, ypos )
	end
end

function Button:checkNotForHover(tx,ty) -- Checks if the Mouse hovers over the button
	if tx >= self.x and tx <= self.x + self.w and ty >= self.y and ty <= self.y + self.h then
		self.var.self.hover = true
	else
		self.var.self.hover = false
	end
end

function Button:pressed() -- Calls functions when the Button is pressed
	for i,v in pairs(self.func.onPress) do
		if v and tostring(type(v)) == "function" then
			v()
		end
	end
end

function Button:released() -- Calls functions when the Button is released
	for i,v in pairs(self.func.onRelease) do
		if v and tostring(type(v)) == "function" then
			v()
		end
	end
end

function Button:hover() -- Calls functions when the Mouse hovers over the button
	for i,v in pairs(self.func.onHover) do
		if v and tostring(type(v)) == "function" then
			v()
		end
	end
end

function Button:notHover() -- Calls functions when the Mouse doesn't hover over the button
	for i,v in pairs(self.func.notOnHover) do
		if v and tostring(type(v)) == "function" then
			v()
		end
	end
end

function Button:enableText(bol) -- Enables the Text of the Button
	if bol then
		self.var.self.text = true
	else
		self.var.self.text = false
	end
end

function Button:wasPressed(x,y) -- Checks if the Button was clicked and calls all functions that are specified for this event
	if x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h then
		self:pressed()
	end
end

function Button:wasReleased(x,y) -- Checks if the Button was released and calls all functions that are specified for this event
	if x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h then
		self:released()
	elseif self.var.self.pressed then
		self:released()
	end
end

function Button:checkForHover(x,y) -- Checks if the mouse hovers over the button and calls all functions that are specified for this event
	if x >= self.x and x <= self.x + self.w and y >= self.y and y <= self.y + self.h then
		self:hover()

	else
		self:notHover()
	end
end

function Button:click(bol)
	if bol then
		self:pressed()
	else
		self:released()
	end
end

return Button

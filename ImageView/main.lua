local Image

function love.load()
	local file = io.open("C:\\Users\\Jonathan\\Bilder\\Wallpapers\\04 - YZ6avji.jpg","rb")--"C:\\Users\\Jonathan\\Bilder\\dotalogoimage.jpg", "rb")
	local data = file:read("*a")
	file:close()
	local i = love.filesystem.newFileData(data,"dotalogoimage.jpg","file")
	Image = love.graphics.newImage(i)
end

function love.draw()
	love.graphics.line(1,8,64,8)
	love.graphics.draw(Image, 1, 10, 0, scaleImage())
end

function scaleImage()
	local w,h = Image:getDimensions()
	x = 64/w
	y = 64/h
	return x,y
end
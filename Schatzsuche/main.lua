local Util = require 'Util'

function love.load()
	Util.createHighscoreFile()
	local files = love.filesystem.getDirectoryItems("")
	for i,v in ipairs(files) do
		print(tostring(i).." : "..tostring(v))
	end
	local score = Util.readHighscore()
	score = Util.addNewScore(score,"Test7", "93")
	local score2 = Util.sortHighscore(score)
	Util.saveToFile(score2)
end

function love.draw()

end

function love.update(dt)

end
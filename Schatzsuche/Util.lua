local Util = {}

local function checkForHighscore()
	return love.filesystem.exists("Highscore.txt")
end

function Util.createHighscoreFile()
	if not checkForHighscore() then
		love.filesystem.write("Highscore.txt", " ")
	else
		return
	end
end

function Util.readHighscore()
	local score = {}
	local size = 0
	for lines in love.filesystem.lines("Highscore.txt") do
		print(lines)
		line = lines
		local sc = {}
		local l = 1
		for i in string.gmatch(line, "[0-9%a]+") do
			sc[l] = i
			l = l + 1
		end
		print(sc[1].." : "..sc[2].." : "..sc[3])
		table.insert(score, sc)
	end
	print("[Highscores]:")
	for i,v in pairs(score) do
		print("[Highscore]: "..tostring(i).." : "..tostring(v))
	end
	return score
end

function Util.sortHighscore(score)
	for i=1,#score do
		for j=i+1,#score do
			if tonumber(score[i][2]) < tonumber(score[j][2]) then
				score[i][1] = j
				score[j][1] = i
				local temp = {}
				temp = score[i]
				score[i] = score[j]
				score[j] = temp
			end
		end
	end
	return score
end

function Util.addNewScore(score, name, points)
	table.insert(score,{#score + 1,points,name})
	return score
end

function Util.saveToFile(score)
	f = love.filesystem.newFile("Highscore.txt")
	f:open("w")
	for i = 1, #score do
		if i > 1 then
			f:write("\r\n")
		end
		f:write(tostring("\""..score[i][1].."\"")..","..tostring("\""..score[i][2].."\"")..","..tostring("\""..score[i][3].."\""))
	end
	f:close()
end

return Util
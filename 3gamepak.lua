-- 3 Game Pak by CrazedProgrammer
-- Crazedprogrammer

local screenwidth, screenheight = term.getSize()
local screenoffset = 19 - screenheight
if not (_HOST and screenwidth == 51 and (screenheight == 19 or screenheight == 18) and term.isColor()) then
	term.setTextColor(colors.red)
	print("This program is not compatible with your current setup.\nRequirements:\n- ComputerCraft version 1.76 or newer\n- Runned on an Advanced Computer or a Command Computer (for sound support)\n- No more than 1 multishell instance")
	return
end

-- Assets

local img = {
	crazed = "8888888888888888\n8f000f000fff00f7\n80ffff0ff0f0ff07\n80ffff000ff00007\n8f000f0ff0f0ff07\n8ffffffffffffff7\n80000f0000f000f7\n8ff0ff000ff0ff07\n8f0fff0ffff0ff07\n80000f0000f000f7\n8777777777777777\n       77\n      7777\n  888888888888\n  8777778778b8\n  888888888888"
,	madeby = "000 00                      00000\n0  0  0         0           0    0\n0  0  0         0           0    0\n0  0  0  000  000  000      00000  0   0\n0  0  0 0  0 0  0 00000     0    0  0 0\n0  0  0 0  0 0  0 0         0    0   0\n0     0  000  000  000      00000    0\n                                    0\n                                   0\n"
,	title1 = "1111111111\n1111111111\n       111\n     1111\n   1111\n 1111\n1111111111\n1111111111\n       111\n     1111\n    1111\n  1111\n 1111\n111\n11\n"
,	title2 = "  00000\n 0000000\n000    0\n00        00000   00 00 000    0000\n00  0000  000000  0000000000  000000\n00  0000      00  00  00  00  00  00\n00    00    0000  00  00  00  000000\n000   00  00  00  00  00  00  00\n 0000000  000000  00  00  00  000000\n  00000    00000  00  00  00   00000\n"
,	title3 = "000000           00\n0000000          00\n00   00          00\n00   00  00000   00   00\n00   00  000000  00  00\n0000000      00  00 00\n000000     0000  0000\n00       00  00  00 00\n00       000000  00  00\n00        00000  00   00\n"
,	help = "bbbbbbbbbbbbbbbbbb\nb0b0b000b0bbb00bbb\nb000b00bb0bbb0b0bb\nb0b0b0bbb0bbb00bbb\nb0b0b000b000b0bbbb\nbbbbbbbbbbbbbbbbbb\n"
,	exit = "eeeeeeeeeeeeeeeeee\ne000e0e0e000e000ee\ne00eee0eee0eee0eee\ne0eeee0eee0eee0eee\ne000e0e0e000ee0eee\neeeeeeeeeeeeeeeeee\n"
,	drdan = "333333333333333333333333333333\n3eeee33eee3333eeee33eee33eeee3\n33e33e3e33e3333e33e33e3e33e33e\n33e33e3e33e3333e33e33e3e33e33e\n33e33e3eee33333e33e3eeeee3e33e\n33e33e3e3e33333e33e3e333e3e33e\n3eeee33e33e333eeee43e33be3e33e\n33ee33333333e333ee4433bbee3333\n33ee3333333333333e43333be33333\n3b4333eebb3333bb333343343333ee\nbb44b3eebb3333bb333343343333ee\n3b433beebb3333bb333344443333ee\neeb7b734e333333e43bb47473b4333\nee7bbb44ee3333ee44bb4444bb4433\neeb77b34e333333e43bb47773b4333\nbbbbbbbb34b33333ee3343b4333333\nb3b33b3b44bb3333ee3344b4433333\n33bb3bb334b33333ee3333bb333333\n9be9999eb9ee999994b99999999944\nbbee99eebbee999944bb9999999944\n9be9999eb9ee999994b9cccccc9944\n9994b94499999eb9999c6666669999\n9944bb449999eebb999c6666669999\n9994b94499999eb9999c7777771119\n44e7e7ee9999999991167767761111\n44eeeeeb9999999111166666661111\n44e7eeeb9999991111166666661111\nbb9e77e994e9991111880000081111\nbb9e99e944ee911110008000800011\nbbee99ee94e9911110000888000011\nee999be99999911110000070000011\nee99bbee9999911110000700000011\nee999be99999991110000700000011\n"
,	font1 = "0000    0 0000 0000 0  0 0000 0000 0000 0000 0000\n0  0    0    0    0 0  0 0    0       0 0  0 0  0\n0  0    0 0000 0000 0000 0000 0000    0 0000 0000\n0  0    0 0       0    0    0 0  0    0 0  0    0\n0000    0 0000 0000    0 0000 0000    0 0000 0000\n"
,	leftsidepinkpipe = "f02\nf02\nf02"
,	rightsidepinkpipe = "20f\n20f\n20f"
,	bottomsidepinkpipe = "00\nff\nff"
,	topsidepinkpipe = "ff\nff\n00"
,	lefttoppinkpipe = "ff\nff\nf0"
,	righttoppinkpipe = "ff\nff\n0f"
,	leftbottompinkpipe = "f0\nff\nff"
,	rightbottompinkpipe = "0f\nff\nff"
}
-- Global variables
local mode = 1
local quit = false

-- Save data functions

local savedata = { }
local savedatapath = fs.getDir(shell.getRunningProgram()).."/3gpsave.sav"

local function save()
	local handle = fs.open(savedatapath, "w")
	if not handle then return end
	handle.write(textutils.serialize(savedata))
	handle.close()
end

local function loadSave()
	local handle = fs.open(savedatapath, "r")
	if not handle then
		save()
		return
	end
	local data = textutils.unserialize(handle.readAll())
	handle.close()
	local legit = true
	if type(data) ~= "table" then
		legit = false
	end
	if not legit then
		fs.delete(savedatapath)
		save()
	else
		savedata = data
	end
end

-- Graphics functions

local colorhex, smallchar = { }, { }
local buffer = { }

local function clearScreen(color)
	for i = 1, 102 * 57 do
		buffer[i] = color
	end
end

local screenendline = 1, 19

local function renderScreen()
	local commands, charline, mainline, subline, index, sub, char, c1, c2, c3, c4, c5, c6 = { }, { }, { }, { }, nil, 32768
	for j = 0, 18 do		
		for i = 0, 50 do
			index = (j * 3) * 102 + (i * 2)
			c1, c2, c3, c4, c5, c6 = buffer[index + 1], buffer[index + 2], buffer[index + 103], buffer[index + 104], buffer[index + 205], buffer[index + 206]
			char = 0
			if c1 ~= c6 then
				sub = c1
				char = 1
			end
			if c2 ~= c6 then
				sub = c2
				char = char + 2
			end
			if c3 ~= c6 then
				sub = c3
				char = char + 4
			end
			if c4 ~= c6 then
				sub = c4
				char = char + 8
			end
			if c5 ~= c6 then
				sub = c5
				char = char + 16
			end
			charline[i + 1] = smallchar[char + 1]
			mainline[i + 1] = colorhex[c6]
			subline[i + 1] = colorhex[sub]
		end
		commands[#commands + 1] = table.concat(charline)
		commands[#commands + 1] = table.concat(subline)
		commands[#commands + 1] = table.concat(mainline)
	end
	for i = 1 + screenoffset, screenendline do
		term.setCursorPos(1, i - screenoffset)
		term.blit(commands[i * 3 - 2], commands[i * 3 - 1], commands[i * 3])
	end
end

local function drawImage(image, x, y, color, sx, swidth)
	sx, swidth = sx or 0, swidth or 9999
	local ix, iy, c = 0, 0
	for i = 1, #image do
		c = image[i]
		if c then
			if c ~= 0 and ix >= sx and ix < sx + swidth then
				buffer[(y + iy) * 102 + x + ix - sx + 1] = color or c
			end
			ix = ix + 1
		else
			ix = 0
			iy = iy + 1
		end
	end
end

local function drawText(text, x, y, font, charwidth, offset, color)
	for i = 1, #text do
		local c = string.byte(text, i)
		if c >= offset then
			drawImage(font, x + (i - 1) * (charwidth + 1), y, color, (c - offset) * (charwidth + 1), charwidth)
		end
	end
end

local function drawRect(color, x, y, width, height)
	if x < 0 then
		width = width + x
		x = 0
	end
	if y < 0 then
		height = height + y
		y = 0
	end
	if x + width > 102 then
		width = 102 - x
	end
	if y + height > 57 then
		height = 57 - y
	end
	for j = 0, height - 1 do
		for i = 0, width - 1 do 
			buffer[(j + y) * 102 + i + x + 1] = color
		end
	end
end

-- Intro

local introstep = 0

local function updateIntro()
	introstep = introstep + 1
	local i = introstep
	if i <= 106 then
		clearScreen(colors.blue)
		for j = 0, 101 do
			local y = math.floor(math.sin(i / 7 + j / 17) * 7 + 0.5) + 43
			if i > 60 then
			y = y - (i - 60) * 3
			end
			if y < 0 then y = 0 end 
			for k = y, 56 do
				buffer[k * 102 + j + 1] = 512
			end
		end
		drawImage(img.crazed, 43, 23)
		drawImage(img.madeby, 31, 11)
		if i >= 75 then
			local gray = math.floor(56 - (i - 75) * 3.5)
			local black = math.floor(56 - (i - 90) * 3.5)
			if gray < 0 then gray = 0 end
			if black < 0 then black = 0 end
			for j = 0, 101 do
				for k = gray, 56 do
					buffer[k * 102 + j + 1] = 128
				end
				if black < 57 then
					for k = black, 56 do
						buffer[k * 102 + j + 1] = 32768
					end
				end
			end
		end
		
		if i <= 19 then
			term.scroll(-1)
			screenendline = i
		end
	elseif i >= 107 and i <= 112 then
		local flash = {colors.gray, colors.white, colors.white, colors.lightGray, colors.gray, colors.gray}
		clearScreen(flash[i - 106])
	else
		mode = 2
	end
end

local function keyIntro()
	if mode == 1 then
		mode = 2
		screenendline = 19
	end
end

local function clickIntro()
	keyIntro()
end

-- Help

-- Dr Dan

local drdanmode

local function initDrDan()
	drdanmode = true
end

local function updateDrDan()
	if drdanmode then
		for j = 0, 56 do
			for i = 0, 101 do
				buffer[j * 102 + i + 1] = ((i % 4 < 2) == not (j % 6 < 3)) and 16384 or 2
			end
		end
		drawRect(colors.black, 21, 6, 60, 48)
		for i = 0, 15 do
			drawImage(img.leftsidepinkpipe, 18, 6 + i * 3)
			drawImage(img.rightsidepinkpipe, 81, 6 + i * 3)
		end
		for i = 0, 30 do
			drawImage(img.bottomsidepinkpipe, 20 + i * 2, 54)
			drawImage(img.topsidepinkpipe, 20 + i * 2, 3)
		end
		drawImage(img.lefttoppinkpipe, 18, 3)
		drawImage(img.righttoppinkpipe, 82, 3)
		drawImage(img.leftbottompinkpipe, 18, 54)
		drawImage(img.rightbottompinkpipe, 82, 54)
	end
end

local function keyDrDan(key, hold)
end

-- Main Menu

local function updateMainMenu()
	clearScreen(colors.black)
	drawImage(img.title1, 12, 3)
	drawImage(img.title2, 26, 7)
	drawImage(img.title3, 66, 7)
	drawImage(img.help, 32, 51)
	drawImage(img.exit, 52, 51)
	drawImage(img.drdan, 2, 21)
	drawRect(colors.gray, 36, 21, 30, 27)
	drawRect(colors.gray, 70, 21, 30, 33)
end

local function clickMainMenu(x, y)
	if y >= 18 and y <= 19 then
		if x >= 17 and x <= 25 then
			error("help")
		elseif x >= 27 and x <= 35 then
			quit = true
		end
	end
	if y >= 8 and y <= 18 then
		if x >= 2 and x <= 16 then
			initDrDan()
			mode = 4
		end
	end
end

-- Event passers
local function passTimer()
	if mode == 1 then
		updateIntro()
	elseif mode == 2 then
		updateMainMenu()
	elseif mode == 4 then
		updateDrDan()
	end
end

local function passKey(key, hold)
	if key == 211 then
		quit = true
	elseif mode == 1 then
		keyIntro()
	end
end

local function passClick(button, x, y)
	if mode == 1 then
		clickIntro()
	elseif mode == 2 then
		clickMainMenu(x, y)
	end
end

-- Main program functions

local function initProgram()
	for i = 0, 15 do
		colorhex[2 ^ i] = string.format("%01x", i)
	end
	for i = 1, 32 do
		smallchar[i] = string.char(127 + i)
	end
	local tempimg = { }
	for k, v in pairs(img) do
		local image = { }
		for i = 1, #v do
			local c = v:sub(i, i)
			if c == "\n" then
				image[#image + 1] = false
			elseif c ~= "\r" then
				local num = tonumber(c, 16)
				if num then
					image[#image + 1] = 2 ^ num
				else
					image[#image + 1] = 0
				end
			end
		end
		tempimg[k] = image
	end
	img = tempimg
	loadSave()
	--[[local dx, dy = x, y
	for i = 1, #image do
		local c = image:sub(i, i)
		if c == "\n" then
			dy = dy + 1
			dx = x
		elseif c ~= "\r" then
			local number = tonumber(c, 16)
			if number and dx >= 0 and dx < 102 and dy >= 0 and dy < 57 then
				buffer[dy * 102 + dx + 1] = 2 ^ number
			end
			dx = dx + 1
		end
	end]]
end

local function runProgram()
	local timer = os.startTimer(0)
	while not quit do 
		local e = {os.pullEventRaw()}
		if e[1] == "timer" and e[2] == timer then
			timer = os.startTimer(0)
			passTimer()
			renderScreen()
		elseif e[1] == "key" then
			passKey(e[2], e[3])
		elseif e[1] == "mouse_click" then
			passClick(e[2], e[3], e[4] + screenoffset)
		elseif e[1] == "terminate" then
			quit = true
		end
	end
end

local function quitProgram()
	save()
	term.setBackgroundColor(colors.black)
	term.clear()
	term.setCursorPos(1, 1)
end




-------------------------------------
initProgram()
runProgram()
quitProgram()
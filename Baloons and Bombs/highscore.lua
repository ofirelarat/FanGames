local composer = require( "composer" ) 
 
local scene = composer.newScene()

local scoreText
local scoreLabl


local function readScore()
	-- path for file
	local path = system.pathForFile("bloonsAndBombsScores.txt",system.DocumentsDirectory)
	-- open file for reading
	local file,errorString = io.open(path,"r")

	if not file then
		-- Error occured
        scoreText = "There is no past score yet..."
	else
		-- read data
		scoreText = "Your best score is: " file:read("*a")
		-- close file
		io.close(file)
	end
end

local function gotoGame()
	composer.gotoScene( "game" )
end

function scene:create(event)
    local sceneGruop = self.view

    readScore()
    local background = display.newImage(sceneGruop,"images/star_sky.png",display.contentCenterX,display.contentCenterY)
    scoreLable = display.newText(sceneGruop, "scoreText", display.contentCenterX,display.contentCenterY,native.systemFontBold,20)

    local playButton = display.newText(sceneGruop,"Play",display.contentCenterX,display.contentCenterY+100,native.systemFont,55)
	playButton:setFillColor(236, 240, 241)
    playButton:addEventListener("tap",gotoGame)	
end

function scene:show(event)
	local sceneGruop = self.view
	local phase = event.phase

	if(phase == "will") then
		-- scene about to come on screen
		readScore()
        scoreLable.text = scoreText
	elseif(phase == "did") then
		--scene is on screen
	end
end

scene:addEventListener( "create" , scene)
scene:addEventListener( "show" , scene)

return scene


local composer = require( "composer" ) 
 
local scene = composer.newScene()


local function gotoGame()
	composer.gotoScene( "game" )
end

local function gotoHighScore()
	composer.gotoScene( "highscore" )
end


function scene:create(event)
	local sceneGruop = self.view

    local background = display.newImage(sceneGruop,"images/star_sky.png",display.contentCenterX,display.contentCenterY)

	local title = display.newText(sceneGruop,"Baloons and Bombs",display.contentCenterX,display.contentCenterY-100,native.systemFontBold,30)


	local playButton = display.newText(sceneGruop,"Play",display.contentCenterX,display.contentCenterY+100,native.systemFont,50)
	playButton:setFillColor(236, 240, 241)

	--local highScoreButton = display.newText(sceneGruop,"High Score",display.contentCenterX,display.contentCenterY+150,native.systemFont,44)
	--highScoreButton:setFillColor(236, 240, 241)
	
	playButton:addEventListener("tap",gotoGame)	
	--highScoreButton:addEventListener("tap",gotoHighScore)
end

scene:addEventListener( "create" , scene)

return scene


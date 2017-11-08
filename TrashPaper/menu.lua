

local composer = require( "composer" ) 
 
local scene = composer.newScene()


local function gotoGame()
	composer.gotoScene( "game" )
end


function scene:create(event)
	local sceneGruop = self.view

    local background = display.newImage(sceneGruop,"images/OBack.jpg",display.contentCenterX,display.contentCenterY)

	local title = display.newText(sceneGruop,"TrashPaper",display.contentCenterX,display.contentCenterY-100,native.systemFontBold,50)


	local playButton = display.newText(sceneGruop,"Play",display.contentCenterX,display.contentCenterY+100,native.systemFont,50)
	playButton:setFillColor(236, 240, 241)

	playButton:addEventListener("tap",gotoGame)	
end

scene:addEventListener( "create" , scene)

return scene
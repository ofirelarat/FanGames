
local composer = require( "composer" ) 
 
local scene = composer.newScene()
local physics = require( "physics" )

local gameTime = 60
local TimerText
local score = 0
local scoreText
local sceneGruop
local sound_pop
local sound_bomb

local function readScoreAndSetScore()
	local content = 0
	-- path for file
	local path = system.pathForFile("bloonsAndBombsScores.txt",system.DocumentsDirectory)
	-- open file for reading
	local file,errorString = io.open(path,"r")

	if not file then
		-- Error occured
		print("File Error: " .. errorString) 
	else
		-- read data
		content = file:read("*a")
		-- close file
		io.close(file)
	end

	if(content < score)then
		local file,errorString = io.open(path,"w")
		if not file then 
			-- Error occured
			print("File Error: " .. errorString) 
		else
			-- read data
			content = file:write("score")
			-- close file 
			io.close(file)
		end
	end
end

local function gameEnd()
    composer.gotoScene( "menu" )
end

local function cutDown()
    gameTime=gameTime-1
    TimerText.text=gameTime
end

local function balloonTouched(event)
    if (event.phase == "began") then
        Runtime:removeEventListener( "enterFrame", event.self )
        event.target:removeSelf()
        score = score + 1
        scoreText.text = score
		media.playEventSound(sound_pop)
    end
end

local function bombTouched(event)
    if ( event.phase == "began" ) then
            Runtime:removeEventListener( "enterFrame", event.self )
            event.target:removeSelf()
            score = math.floor(score * 0.5)
            scoreText.text = score
			media.playEventSound(sound_bomb)
	end
end

local function offscreen_bomb(self, event)
	if(self.y == nil) then
		return
	end
	if(self.y > display.contentHeight + 50) then
		Runtime:removeEventListener( "enterFrame", self )
		self:removeSelf()
	end
end

local function offscreen_baloon(self, event)
	if(self.y == nil) then
		return
	end
	if(self.y > display.contentHeight + 50) then
		Runtime:removeEventListener( "enterFrame", self )
		self:removeSelf()
	       if(score>0)then
	         score=score-1
			 scoreText.text = score
            end 
	end
end

local function addNewBalloonOrBomb()
    if(gameTime < 1)then
        gameEnd()
    end

	local startX = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
	local x=math.random(1,21)
	if(x>=1 and x<5) then
		-- BOMB!
		local bomb = display.newImage(sceneGruop, "images/bomb.png", startX, -300)
		physics.addBody( bomb )
		bomb.enterFrame = offscreen_bomb
		Runtime:addEventListener( "enterFrame", bomb )
		bomb:addEventListener( "touch", bombTouched )
	else if(x>4 and x<21)then
		-- Balloon
		local balloon = display.newImage(sceneGruop, "images/red_balloon.png", startX, -300)
		physics.addBody( balloon )
		balloon.enterFrame = offscreen_baloon
		Runtime:addEventListener( "enterFrame", balloon )
		balloon:addEventListener( "touch", balloonTouched )
	end
end
end


function scene:create(event)
 	sceneGruop = self.view

    local background = display.newImage(sceneGruop,"images/star_sky.png",display.contentCenterX,display.contentCenterY)
    gameTime = 60
    score = 0
	TimerText = display.newText(sceneGruop, gameTime, display.contentCenterX,10,native.systemFont,30)
	scoreText = display.newText(sceneGruop, score, display.contentCenterX,display.contentCenterY,native.systemFontBold,140)
	scoreText:setTextColor(0,0,0.10)

	timer.performWithDelay(1000,cutDown,-1)
	timer.performWithDelay( 500, addNewBalloonOrBomb, 0 )

	sound_pop=media.newEventSound("sounds/pop.mp3")
	sound_bomb=media.newEventSound("sounds/shoot.mp3")

	physics.pause()
end

function scene:show(event)
	local sceneGruop = self.view
	local phase = event.phase

	if(phase == "will") then
		-- scene about to come on screen
		gameTime = 60
   		score = 0
	elseif(phase == "did") then
		--scene is on screen
		physics.start()
	end
end


scene:addEventListener( "create" , scene)
scene:addEventListener( "show" , scene)

return scene
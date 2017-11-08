local composer = require( "composer" ) 
 
local scene = composer.newScene()
local physics = require( "physics" )
local sceneGruop

local halfW = display.contentWidth*0.5
local halfH = display.contentHeight*0.5
local background
local gameTime = 60
local TimerText
local score = 0
local scoreText
local circleScore


local trash

local isBonus=false
local bonusIMG
local isNoBonus=false
local noBonusIMG
bonusTime=5;
local circleBonus

local newTimerBonus
local newBallTimer

local function gameEnd()
    composer.gotoScene( "menu" )
end

local function cutDownBonusTime()
	bonusTime=bonusTime-1
	if(bonusTime==0)then
		isBonus=false
		isNoBonus=false
		bonusIMG.isVisible=false
		noBonusIMG.isVisible=false
		circleBonus.isVisible=false
	end
end


local function cutDown()
    gameTime=gameTime-1
    TimerText.text=gameTime
end

local function scoreColor()
	if(score%5==0)then
		scoreText:setTextColor(0, 0,255)
		circleScore:setStrokeColor(0,0,255)
	elseif (score%3==0)then
		scoreText:setTextColor(0,255, 0)
		circleScore:setStrokeColor(0,255,0)
	elseif (score%2==0)then
		scoreText:setTextColor(255,0, 0)
		circleScore:setStrokeColor(255,0,0)
	else 
		scoreText:setTextColor(255,255, 0)
		circleScore:setStrokeColor(255,255,0)
	end
end

local function noBonus_inSide(self,event)
	if(self.y == nil) then
		return
	end
	if(self.x >= trash.x -25)and (self.x<=trash.x+25) then
	if(self.y >= display.contentHeight - 110)and (self.y<=display.contentHeight-90) then
		Runtime:removeEventListener( "enterFrame", self )
		self:removeSelf()
		isBonus=false
		isNoBonus=true
		bonusIMG.isVisible=false
		noBonusIMG.isVisible=true
		circleBonus.isVisible=true
		bonusTime=5
		timer.resume(newTimerBonus)
	end
end
	if(self.y > display.contentHeight + 50) then
		Runtime:removeEventListener( "enterFrame", self )
		self:removeSelf()
	end
end

local function bonus_inSide(self,event)
	if(self.y == nil) then
		return
	end
	if(self.x >= trash.x -25)and (self.x<=trash.x+25) then
	if(self.y >= display.contentHeight - 110)and (self.y<=display.contentHeight-90) then
		Runtime:removeEventListener( "enterFrame", self )
		self:removeSelf()
		isBonus=true
		isNoBonus=false
		bonusIMG.isVisible=true
		noBonusIMG.isVisible=false
		circleBonus.isVisible=true
		bonusTime=5
		timer.resume(newTimerBonus)
	end
end
	if(self.y > display.contentHeight + 50) then
		Runtime:removeEventListener( "enterFrame", self )
		self:removeSelf()
	end
end

local function ball_inSide(self,event)
	if(self.y == nil) then
		return
	end

	if(self.x >= trash.x -25)and (self.x<=trash.x+25) then
        if(self.y >= display.contentHeight - 110)and (self.y<=display.contentHeight-90) then
            Runtime:removeEventListener( "enterFrame", self )
            self:removeSelf()
            if(isBonus==true)then
				score=score+2
			elseif(isNoBonus==true)then
        		 score=score		
			else 
				score=score+1
			end
        end
		scoreText.text = score
		scoreColor()
	end

	if(self.y > display.contentHeight + 50) then
		Runtime:removeEventListener( "enterFrame", self )
		self:removeSelf()
		 score = math.floor(score * 0.5)
		scoreText.text = score
		scoreColor()
	end
end

local function AddNewBall()
    if(gameTime < 1)then
        gameEnd()
    end

    local startX = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
	local x=math.random(1,20)
	if(x>=1 and x<19) then
	-- Ball
		local ball = display.newImage(sceneGruop, "images/ballP.png", startX, -300)
		physics.addBody(ball)
		ball.enterFrame = ball_inSide
		Runtime:addEventListener("enterFrame", ball)
		ball.rotation=45
		transition.to( ball, { rotation = ball.rotation-360, time=2000, onComplete=spinImage } )
	elseif(x==19)then
	-- bonus
		local bonus = display.newImage(sceneGruop, "images/bonus.png", startX, -300)
		physics.addBody(bonus)
		bonus.enterFrame = bonus_inSide
		Runtime:addEventListener( "enterFrame", bonus)
		bonus.rotation=45
		transition.to( bonus, { rotation = bonus.rotation-360, time=2000, onComplete=spinImage } )
	elseif(x==20)then
	-- no bonus
		local noBonus = display.newImage(sceneGruop, "images/noBonus.png", startX, -300)
		physics.addBody(noBonus)
		noBonus.enterFrame = noBonus_inSide
		Runtime:addEventListener( "enterFrame", noBonus)
		noBonus.rotation=45
		transition.to( noBonus, { rotation = noBonus.rotation-360, time=2000, onComplete=spinImage } )
	end
end

local function coerceOnScreen( object )
    if object.x < object.width-85 then
        object.x = object.width-85
    end
    if object.x > display.viewableContentWidth - object.width+85 then
        object.x = display.viewableContentWidth - object.width+85
    end
  
end

local function onTouch( event )
    if "began" == event.phase then
        trash.isFocus = true
        trash.x0 = event.x - trash.x
    elseif trash.isFocus then
        if "moved" == event.phase then
            trash.x = event.x - trash.x0
			coerceOnScreen( trash )
        elseif "ended" == phase or "cancelled" == phase then
            trash.isFocus = false
        end
    end
    -- Return true if the touch event has been handled.
    return true
end


function scene:create(event)
 	sceneGruop = self.view

    background = display.newImage(sceneGruop,"images/OBack.jpg",display.contentCenterX,display.contentCenterY)
    gameTime = 60
    score = 0
	TimerText = display.newText(sceneGruop, gameTime, display.contentCenterX,10,native.systemFont,30)

	scoreText = display.newText( score, display.contentCenterX,display.contentCenterY,native.systemFontBold,140)
	circleScore=display.newCircle(sceneGruop, display.viewableContentWidth / 2 , display.viewableContentHeight / 2, 100 )
	circleScore:setFillColor(0,0,0,0) 
	circleScore.strokeWidth = 10
	scoreColor()

    trash=display.newImage(sceneGruop, "images/trashG.png",halfW,halfH*2-20)
	bonusIMG = display.newImage(sceneGruop, "images/bonus.png", display.contentWidth-50, 20)
	noBonusIMG = display.newImage(sceneGruop, "images/noBonus.png", display.contentWidth-50, 20)
	circleBonus=display.newCircle(sceneGruop, display.contentWidth-50, 20, 25 )
	circleBonus:setFillColor(0,0,0,0) 
	circleBonus.strokeWidth = 5
	circleBonus.isVisible=false

    background:addEventListener("touch", onTouch)

	timer.performWithDelay(1000,cutDown,-1)
	newBallTimer=timer.performWithDelay( 500, AddNewBall, 0 )
	newTimerBonus=timer.performWithDelay(1000,cutDownBonusTime,-1)

	timer.pause(newBallTimer)
	physics.pause()
end

function scene:show(event)
	local sceneGruop = self.view
	local phase = event.phase

	if(phase == "will") then
		-- scene about to come on screen
		gameTime = 60
		score = 0
		scoreText.text = score
		timer.pause(newTimerBonus)
		bonusIMG.isVisible = false
		noBonusIMG.isVisible = false
	elseif(phase == "did") then
		--scene is on screen
		physics.start()
		timer.resume(newBallTimer)
	
	end
end

function scene:hide(event)
	local sceneGruop = self.view
	local phase = event.phase

	if(phase == "will") then
		-- scene about to get off screen
		timer.pause(newBallTimer)
		physics.pause()
	elseif(phase == "did") then
		--scene is off screen
	end	
end


scene:addEventListener( "create" , scene)
scene:addEventListener( "show" , scene)
scene:addEventListener( "hide" , scene)

return scene
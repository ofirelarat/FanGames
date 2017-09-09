-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

local physics = require( "physics" )
physics.start()

halfW = display.contentWidth*0.5
halfH = display.contentHeight*0.5
local bkg = display.newImage( "images/OBack.jpg", halfW, halfH )
local trash=display.newImage("images/trashG.png",halfW,halfH*2-20)
local timeAdd
local isBonus=false
local isNoBonus=false

local playI = display.newImage( "images/playIcon.png", 55, 25)
local pauseI = display.newImage( "images/pauseIcon.png", 50, 20)
playI.isVisible=false
local inPause=false

local bonusIMG = display.newImage( "images/bonus.png", display.contentWidth-50, 20)
bonusIMG.isVisible=false
local noBonusIMG = display.newImage( "images/noBonus.png", display.contentWidth-50, 20)
noBonusIMG.isVisible=false
local circleIMG=display.newCircle( display.contentWidth-50, 20, 25 )
circleIMG:setFillColor(0,0,0,0) 
circleIMG.strokeWidth = 5
circleIMG.isVisible=false

-- Add a score label  
local int score = 0  
local scoreLabel = display.newText( score, 0, 0, native.systemFontBold, 100 )  
scoreLabel.x = display.viewableContentWidth / 2  
scoreLabel.y = display.viewableContentHeight / 2  
scoreLabel:setTextColor( 0, 0, 0)
local circle=display.newCircle( display.viewableContentWidth / 2 , display.viewableContentHeight / 2, 80 )
circle:setFillColor(0,0,0,0) 
circle.strokeWidth = 10

timeT=5
local function cutDown()
timeT=timeT-1
end
local newTime=timer.performWithDelay(1000,cutDown,-1)
timer.pause(newTime)

local function offscreen_ball(self, event)
	if(self.y == nil) then
		return
	end
	if(self.y > display.contentHeight + 50) then
		Runtime:removeEventListener( "enterFrame", self )
		self:removeSelf()
		score=score+1
		scoreLabel.text = score
		scoreColor()
	end
end

local function scoreColor()
if(score%5==0)then
scoreLabel:setTextColor(0, 0,255)
circle:setStrokeColor(0,0,255)
elseif (score%3==0)then
scoreLabel:setTextColor(0,255, 0)
circle:setStrokeColor(0,255,0)
elseif (score%2==0)then
scoreLabel:setTextColor(255,0, 0)
circle:setStrokeColor(255,0,0)
else 
scoreLabel:setTextColor(255,255, 0)
circle:setStrokeColor(255,255,0)
end
end
scoreColor()


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
		circleIMG.isVisible=true
		timeT=5
		timer.resume(newTime)
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
		circleIMG.isVisible=true
		timeT=5
		timer.resume(newTime)
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
		scoreLabel.text = score
		scoreColor()
	end
end
	if(self.y > display.contentHeight + 50) then
		Runtime:removeEventListener( "enterFrame", self )
		self:removeSelf()
		 score = math.floor(score * 0.5)
		scoreLabel.text = score
		scoreColor()
	end
end
local function addNewBall()
if(inPause==false)then
if(timeT<1)then
isBonus=false
isNoBonus=false
bonusIMG.isVisible=false
noBonusIMG.isVisible=false
circleIMG.isVisible=false
end
	local startX = math.random(display.contentWidth*0.1,display.contentWidth*0.9)
	local x=math.random(1,20)
	if(x>=1 and x<19) then
	-- Ball
		local ball = display.newImage( "images/ballP.png", startX, -300)
		physics.addBody(ball)
	--	ball.enterFrame = offscreen_ball
	--	Runtime:addEventListener( "enterFrame", ball)
		ball.enterFrame = ball_inSide
		Runtime:addEventListener( "enterFrame", ball)
		ball.rotation=45
		transition.to( ball, { rotation = ball.rotation-360, time=2000, onComplete=spinImage } )
		elseif(x==19)then
			-- speed up
		local bonus = display.newImage( "images/bonus.png", startX, -300)
		physics.addBody(bonus)
		bonus.enterFrame = bonus_inSide
		Runtime:addEventListener( "enterFrame", bonus)
		bonus.rotation=45
		transition.to( bonus, { rotation = bonus.rotation-360, time=2000, onComplete=spinImage } )
		elseif(x==20)then
			-- no bonus
		local noBonus = display.newImage( "images/noBonus.png", startX, -300)
		physics.addBody(noBonus)
		noBonus.enterFrame = noBonus_inSide
		Runtime:addEventListener( "enterFrame", noBonus)
		noBonus.rotation=45
		transition.to( noBonus, { rotation = noBonus.rotation-360, time=2000, onComplete=spinImage } )
		end
end
end
-- Forces the object to stay within the visible screen bounds.
local function coerceOnScreen( object )
    if object.x < object.width-85 then
        object.x = object.width-85
    end
    if object.x > display.viewableContentWidth - object.width+85 then
        object.x = display.viewableContentWidth - object.width+85
    end
  
end


local function onTouch( event )
if(inPause==false)then
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
end
-- Only the background receives touches. 
bkg:addEventListener( "touch", onTouch)


local function pauseFunc()
if (inPause==false) then
inPause=true
physics.pause()
playI.isVisible=true
pauseI.isVisible=false
timer.pause(newTime)
else
inPause=false
physics.start()
playI.isVisible=false
pauseI.isVisible=true
timer.resume(newTime)
end
end
 playI:addEventListener( "tap", pauseFunc )
 pauseI:addEventListener("tap", pauseFunc )

		addNewBall()
   timeAdd=timer.performWithDelay( 500, addNewBall, 0 )
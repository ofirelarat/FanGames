-----------------------------------------------------------------------------------------
--
-- main.lua
--
----------------------------------------------------------------------------------------
-- Your code here
local physics=require("physics")
physics.start()


halfW = display.contentWidth*0.5
halfH = display.contentHeight*0.5
local bkg=display.newImage("field.png",halfW,halfH)
score = 0
scoreText = display.newText(score, halfW,10,native.systemFontBold,25)
scoreText:setTextColor(0,0,0.10)

local ball=display.newImage("ball.png")
ball.x=halfW
physics.addBody(ball,{bounce=0.5,radius=70,friction=1})

local floor=display.newImage("floor.png",halfW,halfH*2)
physics.addBody(floor,"static",{bounce=0.2,friction=1})

local leftWall=display.newRect(-50,halfH,1,display.contentHeight)
local rightWall=display.newRect(display.contentWidth+50,halfH,1,display.contentHeight)
local ceiling=display.newRect(halfW,0-20,display.contentWidth,1)

physics.addBody(leftWall,"static",{bounce=0.1})
physics.addBody(rightWall,"static",{bounce=0.1})
physics.addBody(ceiling,"static",{bounce=0.1})

function balldown()
if(ball.y+50 >= halfH*2-50) then
	       score=0;
			 scoreText.text = score
            end 
end

function moveBall(event)
Runtime:addEventListener( "enterFrame", balldown )
score=score+1
scoreText.text = score
ball:applyLinearImpulse(0,-4,event.x,ball.y)
end
ball:addEventListener("tap",moveBall)





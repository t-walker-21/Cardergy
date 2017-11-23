-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")
local physics = require("physics")

-- "scene:create()"
function scene:create( event )
 
   	local sceneGroup = self.view

   	physics.start()
	physics.setGravity(0,0)

   	-- Initialize the scene here.
   	-- Example: add display objects to "sceneGroup", add touch listeners, etc.

	------------------PHYSICS SECTION----------------------------------------------------------
	leftWall = display.newRect(-1, display.contentCenterY, 1, 570)
	rightWall = display.newRect(321, display.contentCenterY, 1, 570)
	topWall = display.newRect(display.contentCenterX, -1, 320, 1)
	bottomWall = display.newRect(display.contentCenterX, 571, 320, 1)
	leftWall.isVisible = false
	rightWall.isVisible = false
	topWall.isVisible = false
	bottomWall.isVisible = false

	physics.addBody(leftWall, "static", {density = 1.0, friction = 0, bounce = 1})
	physics.addBody(rightWall, "static", {density = 1.0, friction = 0, bounce = 1})
	physics.addBody(topWall, "static", {density = 1.0, friction = 0, bounce = 1})
	physics.addBody(bottomWall, "static", {density = 1.0, friction = 0, bounce = 1})

	sceneGroup:insert(leftWall)
	sceneGroup:insert(rightWall)
	sceneGroup:insert(topWall)
	sceneGroup:insert(bottomWall)

	ball = display.newCircle(0,0,0)
	ball:setFillColor(0,0,0)
	newBall = display.newCircle(0,0,0)
	newBall:setFillColor(0,0,0)
	rnum = 0
	oldX = 0
	oldY = 0
	xForce = math.random(400, 1000)
	yForce = math.random(400, 1000)


	local function onCollision(event)

		local function collide()
			newBall:addEventListener("collision", onCollision)
		end

		local function changeBall()
			--rnum = math.random(2)

			if (rnum == 1) then
				newBall = display.newImageRect("start_qr.png", 90, 90)
				newBall.x = oldX
				newBall.y = oldY
				rnum = rnum + 1
			else
				newBall = display.newRoundedRect(oldX, oldY, 100, 158, 10)
				newBall.fill = {type="image", filename="start_card.png"}
				rnum = rnum - 1
			end

			physics.addBody(newBall, "dynamic", {density = 1, friction = 0, bounce = 1, isSensor = false})
			xForce = math.random(800, 1000)
			yForce = math.random(800, 1000)
			newBall:applyForce(xForce, yForce)

			sceneGroup:insert(newBall)
			newBall:toBack()
			--bg:toBack()
			timer.performWithDelay((xForce+yForce)/20, collide)
		end

		event.target:removeEventListener("collision", onCollision)
		if (event.other == leftWall or event.other == rightWall or event.other == topWall or event.other == bottomWall) then
			oldX = event.target.x
			oldY = event.target.y
			display.remove(event.target)
			timer.performWithDelay(0, changeBall)
		end
	end

	local function initialBall()
		rnum = math.random(2)

		if (rnum == 1) then
			ball = display.newImageRect("start_qr.png", 90, 90)
			ball.x = math.random(display.contentCenterX-90, display.contentCenterX+90)
			ball.y = math.random(display.contentCenterY-90, display.contentCenterY+90)
			sceneGroup:insert(ball)
		else
			ball = display.newRoundedRect(math.random(display.contentCenterX-90, display.contentCenterX+90), math.random(display.contentCenterY-90, display.contentCenterY+90), 100, 158, 10)
			ball.fill = {type="image", filename="start_card.png"}
			sceneGroup:insert(ball)
		end

		physics.addBody(ball, "dynamic", {density = 1, friction = 0, bounce = 1, isSensor = false})
		ball:applyForce(math.random(800, 1000), math.random(800, 1000))

		Runtime:removeEventListener("tap", initialBall)
		ball:addEventListener("collision", onCollision)
	end

	initialBall()
	------------------PHYSICS SECTION----------------------------------------------------------

	local logo = display.newImageRect("logo_white.png", 300, 100)
	logo.x = display.contentCenterX
	logo.y = display.contentCenterY-100
	logo:toFront()
	sceneGroup:insert(logo)

   	local function loginEvent(event)
   		local options = {
			effect = "slideLeft",
			time = 800
		}
		composer.gotoScene("login", options)
	end

	-- create settings button for changing the time setting - Alex Indihar
	local loginBtn = widget.newButton(
	{
		label = "Sign In",
		fontSize = 20,
		font = native.systemFontBold,
		emboss = true,
		onRelease = loginEvent,
		shape = "roundedRect",
		width = 220,
		height = 60,
		cornerRadius = 30,
		fillColor = {default={1,1,1}, over={1,0,0.5}},
	})
	loginBtn.x = display.contentCenterX
	loginBtn.y = display.contentCenterY + 40
	sceneGroup:insert(loginBtn)

	local function registerEvent(event)
		composer.removeScene("register1")
		local options = {
			effect = "slideLeft",
			time = 800
		}
		composer.gotoScene("register1", options)
	end

	local registerBtn = widget.newButton(
	{
		label = "Register",
		fontSize = 20,
		font = native.systemFontBold,
		emboss = true,
		onRelease = registerEvent,
		shape = "roundedRect",
		width = 220,
		height = 60,
		cornerRadius = 30,
		fillColor = {default={1,1,1}, over={1,0,0.5}},
	})
	registerBtn.x = display.contentCenterX
	registerBtn.y = display.contentCenterY + 115
	sceneGroup:insert(registerBtn)
end
 
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
   elseif ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
      composer.removeScene("register1")
      composer.removeScene("register2")
   end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is on screen (but is about to go off screen).
      -- Insert code here to "pause" the scene.
      -- Example: stop timers, stop animation, stop audio, etc.
      composer.setVariable("passScene", "")
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
      composer.removeScene("start")
   end
end
 
-- "scene:destroy()"
function scene:destroy( event )
 
   local sceneGroup = self.view
 
   -- Called prior to the removal of scene's view ("sceneGroup").
   -- Insert code here to clean up the scene.
   -- Example: remove display objects, save state, etc.
end
 
---------------------------------------------------------------------------------
 
-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
 
---------------------------------------------------------------------------------
 
return scene
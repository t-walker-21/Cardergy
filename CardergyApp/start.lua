-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setDefault("background", 249,250,252)

local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")

-- "scene:create()"
function scene:create( event )
 
   	local sceneGroup = self.view

   	-- Initialize the scene here.
   	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
	local bg = display.newImageRect("background1.jpg", 320, 570)
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY
	bg:toBack()
	sceneGroup:insert(bg)

   	local function loginEvent(event)
		composer.gotoScene("login")
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
	loginBtn.y = display.contentCenterY - 30
	sceneGroup:insert(loginBtn)

	local function registerEvent()
		composer.gotoScene("register")
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
	registerBtn.y = display.contentCenterY + 40
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
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
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
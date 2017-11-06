-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")

-- "scene:create()"
function scene:create( event )
 
   	local sceneGroup = self.view

   	-- Initialize the scene here.
   	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
   	local paint = {
	    type = "gradient",
	    color1 = {115/255,3/255,192/255},
	    color2 = {253/255,239/255,249/255},
	    direction = "down"
	}

	local bg = display.newRect(display.contentCenterX, display.contentCenterY, 320, 570)
	bg.fill = paint
	bg:toBack()

	homeTxt = display.newText("Cardergy", display.contentCenterX, display.contentCenterY-90, native.systemFont, 70)
	soonTxt = display.newText("COMING SOON!", display.contentCenterX, display.contentCenterY-20, native.systemFont, 35)

	user = composer.getVariable("user")
	loginTxt = display.newText("Logged in as: "..user, display.contentCenterX, display.contentCenterY-20, native.systemFont, 16)
	loginTxt.anchorX = 0
	loginTxt.anchorY = 0
	loginTxt.x = 10
	loginTxt.y = 20
	sceneGroup:insert(homeTxt)
	sceneGroup:insert(soonTxt)

	local function logoutEvent(event)
		local options = {
			effect = "slideRight",
			time = 800
		}
		composer.gotoScene("start", options)
	end

	logoutBtn = widget.newButton(
	{
		label = "Logout",
		fontSize = 20,
		font = native.systemFontBold,
		emboss = true,
		onRelease = logoutEvent,
		shape = "roundedRect",
		width = 220,
		height = 60,
		cornerRadius = 30,
		fillColor = {default={1,1,1}, over={1,0,0.5}},
	})
	logoutBtn.x = display.contentCenterX
	logoutBtn.y = display.contentCenterY + 80
	sceneGroup:insert(logoutBtn)

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
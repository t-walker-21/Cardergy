-----------------------------------------------------------------------------------------
--
-- error.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")

-- "scene:create()"
function scene:create( event )
 
   	local sceneGroup = self.view
   	local g = display.newGroup()

   	-- Initialize the scene here.
   	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
end
	
-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 	

   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      parent = event.parent
      params = event.params

      -- Function to handle error completion
      local function onComplete(event)
         -- Revert keyboard focus back to the field that triggered the error
      	parent:revertAlpha(params.errField)

         -- Determine whether the erroneous scene is registration or login
      	passScene = composer.getVariable("passScene")

         -- Check if erroneous scene is registration
      	if (passScene == "regScene") then
            -- Remove registration text and back button
      		regTxt = composer.getVariable("regTxt")
      		backBtn = composer.getVariable("backBtn")
      		display.remove(regTxt)
      		display.remove(backBtn)

            -- Go to start scene
      		local options = {
      			effect = "slideRight",
      			time = 800
      		}
      		composer.gotoScene("start", options)

         -- Check if erroneous scene is login
      	elseif (passScene == "logScene") then
            -- Go to login scene
      		local options = {
      			effect = "slideLeft",
      			time = 800
      		}
      		composer.gotoScene("home", options)

         -- Check if erroroneous scene is some other scene
      	else
            -- Go to current scene
	      	currScene = composer.getSceneName("current")
	      	composer.gotoScene(currScene)
	     end
      end

      local alert = native.showAlert(params.errTitle, params.errStr, {"OK"}, onComplete)
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
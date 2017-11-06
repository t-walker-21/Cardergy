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

      local function onComplete(event)
      	parent:revertAlpha(params.errField)
      	if (params.errTitle == "SUCCESS") then
      		regTxt = composer.getVariable("regTxt")
      		backBtn = composer.getVariable("backBtn")
      		display.remove(regTxt)
      		display.remove(backBtn)
      		local options = {
      			effect = "slideRight",
      			time = 800
      		}
      		composer.gotoScene("start", options)
      	else
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
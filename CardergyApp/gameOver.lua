-----------------------------------------------------------------------------------------
--
-- start.lua
--
-- Name: Alex Indihar
-- Assigment: Homework 4
-- Date: 11/19/2017
-----------------------------------------------------------------------------------------

local widget = require("widget")
local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   
   -- create gameOver scene text objects
   lose1Txt = display.newText("Game Over!", display.contentCenterX, display.contentCenterY-110, native.systemFont, 42)
   lose2Txt = display.newText("You didn't last 3 minutes!", display.contentCenterX, display.contentCenterY-50, native.systemFont, 26)
   lose1Txt:toFront()
   lose2Txt:toFront()

   -- Add text objects to scene group
   sceneGroup:insert(lose1Txt)
   sceneGroup:insert(lose2Txt)

   -- Function to return to the start screen
   local function startEvent(event)
      local options = {
         effect = "fade",
         time = 1000
      }
      -- Go to starting scene.
      composer.gotoScene("start", options)
   end

   -- Wait 4 seconds to go to start screen
   timer.performWithDelay(4000, startEvent)
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
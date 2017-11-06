-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.DarkStatusBar)
display.setDefault("background", 249,250,252)
bg = display.newImage("background1.jpg", display.contentCenterX, display.contentCenterY)
bg:toBack()

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
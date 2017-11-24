-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local paint = {
    type = "gradient",
    color1 = {115/255,3/255,192/255},
    color2 = {253/255,239/255,249/255},
    direction = "down"
}

local bg = display.newRect(display.contentCenterX, display.contentCenterY, 320, 570)
bg.fill = paint
bg:toBack()
local composer = require("composer")
local scene = composer.newScene()

composer.gotoScene("home")
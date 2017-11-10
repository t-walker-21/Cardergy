-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------



local socket = require("socket")
local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")


-------- tevon card
local Card = {}

function Card:new()
  local o = {
  title = "Title",
}
  setmetatable(o,{ __index = Card})
  return o
end

-------- tevon card


-- "scene:create()"
function scene:create( event )
 
   	local sceneGroup = self.view
   	local g = display.newGroup()

   	-- Initialize the scene here.
   	-- Example: add display objects to "sceneGroup", add touch listeners, etc.
	

	local function onUser(event)
		if ("began" == event.phase) then
		elseif ("submitted" == event.phase) then
			native.setKeyboardFocus(passField)
			print(userField.text)
		end
	end

	local function onPass(event)
		if ("began" == event.phase) then
		elseif ("submitted" == event.phase) then
			native.setKeyboardFocus(confirmField)
		end
	end

	local function onConfirm(event)
		if ("began" == event.phase) then
		elseif ("submitted" == event.phase) then
			native.setKeyboardFocus(emailField)
		end
	end

	local function onEmail(event)
		if ("began" == event.phase) then
		elseif ("submitted" == event.phase) then
			native.setKeyboardFocus(phoneField)
		end
	end

	local function onPhone(event)
		if ("began" == event.phase) then
		elseif ("submitted" == event.phase) then
			native.setKeyboardFocus(nil)
		end
	end
---------------------------------------------	Tevon https://docs.coronalabs.com/api/library/widget/newTableView.html
	
	cardCategories = {"Holiday","Blessings","Birthday","Congradulations!","Invite"}

	local function onRowTouch(event)
		print("you touched a cell")
	end


	local function onRowRender( event )
 
    -- Get reference to the row group
    local row = event.row
 
    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = 320 --row.contentWidth
 
    local rowTitle = display.newText( row,cardCategories[row.index], 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )
 
    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 100
    rowTitle.y = rowHeight * 0.5

    --Add row image to cells
    local rowImage = display.newImage(row,"start_card_resized.png",4,4)
    rowImage.x = 55
    rowImage.y = rowHeight/2
end
 
-- Create the widget
local tableView = widget.newTableView(
    {
        left = 0,
        top = 100,
        height = 330,
        width = 320,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
        --listener = scrollListener
    }
)
 
-- Insert 40 rows
for i = 1, table.getn(cardCategories) do
 
    local isCategory = false
    local rowHeight = 36
    local rowColor = { default={1,1,1}, over={1,0.5,0,0.2} }
    local lineColor = { 0.5, 0.5, 0.5 }
 
    -- Make some rows categories
    --[[if ( i == 1 or i == 21 ) then
        isCategory = true
        rowHeight = 40
        rowColor = { default={0.8,0.8,0.8,0.8} }
        lineColor = { 1, 0, 0 }
    end]]--
 
    -- Insert a row into the tableView
    tableView:insertRow(
        {
            isCategory = isCategory,
            rowHeight = rowHeight,
            rowColor = rowColor,
            lineColor = lineColor
        }
    )
end

--------------------------------------------------------------Tevon

	local function submitEvent()

		--transition.moveTo(sceneGroup, {x=display.contentCenterX, y=display.contentCenterY-100})
		userField:removeSelf()
		passField:removeSelf()
		confirmField:removeSelf()
		emailField:removeSelf()
		phoneField:removeSelf()
		composer.removeScene("register")
		composer.gotoScene("start")
	end


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
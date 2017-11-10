display.setStatusBar(display.DarkStatusBar)
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local topbarContainer, topbarBackground, menuBtn, cameraBtn, topbarInsignia
 
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
   topbarContainer = display.newContainer(display.contentWidth, 100)
   topbarContainer:translate(display.contentWidth * 0.5, -5)

   topbarBackground = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, 100)
   topbarBackground:setFillColor(135/255,206/255,250/255)
   topbarContainer:insert(topbarBackground, true)

   local function menuEvent(event)
   end

   menuBtn = widget.newButton({
         width = 30,
         height = 30,
         defaultFile = "menu_icon.png",
         --overFile = "menu_pressed.png",
         onRelease = menuEvent
   })
   topbarContainer:insert(menuBtn, true)
   menuBtn.x = -140
   menuBtn.y = -10

   topbarInsignia = display.newImageRect("logo_black.png", 128, 45)
   topbarInsignia.y = -10

   topbarContainer:insert(topbarInsignia)

   local function cameraEvent(event)
   end

   cameraBtn = widget.newButton({
         width = 30,
         height = 30,
         defaultFile = "camera_icon.png",
         --overFile = "camera_pressed.png",
         onRlease = cameraEvent
   })
   topbarContainer:insert(cameraBtn)
   cameraBtn.x = 140
   cameraBtn.y = -10

   local function onSearch(event)
      if ("began" == event.phase) then
      elseif ("editing" == event.phase) then
      elseif ("submitted" == event.phase) then
      elseif ("ended" == event.phase) then
      end
   end

   searchField = native.newTextField(0, 0, 300, 30)
   searchField.inputType = "default"
   searchField:setReturnKey("done")
   searchField.placeholder = "Search..."
   searchField:addEventListener("userInput", onSearch)
   topbarContainer:insert(searchField)
   searchField.y = 30
  
   topbarContainer.y = 50

   sceneGroup:insert(topbarContainer)

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
        height = 330,
        width = 355,
        onRowRender = onRowRender,
        onRowTouch = onRowTouch,
        --listener = scrollListener
    }
)

  tableView.x = display.contentCenterX
  tableView.y = display.contentCenterY + 25
 
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
      --[[local options = {
         effect = "slideLeft",
         time = 800
      }
      composer.gotoScene("profile", options)--]]
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
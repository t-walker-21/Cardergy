display.setStatusBar(display.DarkStatusBar)
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local topbarBackground, menuBtn, cameraBtn, topbarInsignia
local host, port = "34.230.251.252", 40000
local socket = require("socket")
local tcp = assert(socket.tcp())
local Card = require("card")

cardCategories = {"Holiday","Blessings","Birthday","Congratulations!","Invite"}
tableFlag = false
local parts
rowCnt = 0
images = {}
categories = {}
names = {}
tableView = nil

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here

-- overlay options
local overlayOptions = {
	isModal = true,
	effect = "slideRight",
	time = 400
}

function scene:showSearch()
   searchField.isVisible = true
end
 
---------------------------------------------------------------------------------
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.

   -- Container for the top menu bar
   topbarContainer = display.newContainer(display.contentWidth, 100)
   topbarContainer:translate(display.contentWidth * 0.5, -5)


   local paint = {
    type = "gradient",
    color1 = {248/255,181/255,0/255},
    color2 = {252/255,234/255,187/255},
    direction = "down"
  }

   
   -- Background for the top menu bar
   topbarBackground = display.newRect(display.contentCenterX, 50, display.contentWidth, 100)
   topbarBackground:setFillColor(135/255,206/255,250/255)
   topbarBackground.fill = paint

   topbarContainer:insert(topbarBackground, true)

   -- Handle the menu button's touch events
   function menuEvent(event)
      -- hide the search bar because it's a pain
      searchField.isVisible = false
      
      -- Show the overlay in all its glory
      composer.showOverlay("menu", overlayOptions)
   end

   -- Create the menu button
   menuBtn = widget.newButton({
         width = 30,
         height = 30,
         defaultFile = "menu_icon.png",
         --overFile = "menu_pressed.png",
         onRelease = menuEvent
   })

   topbarContainer:insert(menuBtn, true)
   menuBtn.x = -135
   menuBtn.y = -4

   -- Cardergy logo for the top menu bar
   topbarInsignia = display.newImageRect("logo_black.png", 128, 45)
   topbarInsignia.x = 0
   topbarInsignia.y = -10
   topbarContainer:insert(topbarInsignia)

   -- Handle the camera button events
   local function cameraEvent(event)
   end

   -- Create the camera button in the top menu bar
   cameraBtn = widget.newButton({
         width = 30,
         height = 30,
         defaultFile = "camera_icon.png",
         --overFile = "camera_pressed.png",
         onRlease = cameraEvent
   })

   topbarContainer:insert(cameraBtn)
   cameraBtn.x = 135
   cameraBtn.y = -5

   string.split = function(str, pattern)
      pattern = pattern or "[^%s]+"
      if pattern:len() == 0 then
         pattern = "[^%s]+"
      end
      local parts = {__index = table.insert}
      setmetatable(parts, parts)
      str:gsub(pattern, parts)
      setmetatable(parts, nil)
      parts.__index = nil
      return parts
   end


   local function onRowRender( event )
 
    -- Get reference to the row group
    local row = event.row
 
    -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
    local rowHeight = row.contentHeight
    local rowWidth = row.contentWidth
 
    local rowTitle = display.newText( row,cardCategories[row.index], 0, 0, nil, 14 )
    rowTitle:setFillColor( 0 )
 
    -- Align the label left and vertically centered
    rowTitle.anchorX = 0
    rowTitle.x = 100
    rowTitle.y = rowHeight * 0.1

    --Add row image to cells
    local imageStr = "start_card.png"
    local rowImage = display.newImageRect(row, imageStr,50,80)
    rowImage.x = 55
    rowImage.y = rowHeight/2
    images[1] = imageStr
    categories[1] = "Holiday"
    names[1] = "Mustache"
  end

   local function onRowTouch(event)
      if (event.phase == "release") then
        local row = event.row
        --print(tableView._view._rows[row.index])
        --[[composer.setVariable("cardStyle", images[row.index])
        composer.setvariable("cardName", names[row.index])
        composer.setVariable("cardCategory", categories[row.index])--]]
        local Niall = Card:new({})
        Niall:setCategory(categories[row.index])
        Niall:setBackImage(images[row.index])
        Niall:setName(names[row.index])

        composer.setVariable("Niall", Niall)

        local options = {
           effect = "slideLeft",
           time = 800
        }

        composer.gotoScene("item", options)
      end
   end

   local function onSearch(event)
      if ("began" == event.phase) then
      elseif ("editing" == event.phase) then
         if (tableFlag == false) then
            display.remove(tableView)
         end

         tableFlag = false
         rowData = {}

         search = "search:"..searchField.text
         tcp:connect(host, port)
         tcp:send(search)
         local s, status, partial = tcp:receive()
         tcp:close()

         if (s ~= nil and s ~= "") then
               s = s:split("[^:]+")
               rowCnt = tonumber(parts[1])
         elseif (partial ~= nil and partial ~= "") then
               parts = partial:split("[^:]+")
               rowCnt = tonumber(parts[1])
         end

         tableView = widget.newTableView({
            height = 600,--rowCnt * 35,
            width = 320,
            onRowRender = onRowRender,
            onRowTouch = onRowTouch,
            listener = scrollListener,
         })
         tableView.anchorY = 0
         tableView.x = display.contentCenterX
         tableView.y = display.contentCenterY-185

         if (rowCnt > 0) then
            for i = 1, rowCnt do
               -- Insert a row into the tableView
               tableView:insertRow({
                  rowHeight = 90,
                  rowColor = {default={249/255,250/255,252/255}}
               })
            end
         end

         if (searchField.text == nil or searchField.text == "") then
            tableFlag = true
            display.remove(tableView)
         else
            sceneGroup:insert(tableView)
         end
      elseif ("submitted" == event.phase) then
        native.setKeyboardFocus(nil)
      elseif ("ended" == event.phase) then
      end
   end

   -- Create the search bar
   searchField = native.newTextField(0, 0, 300, 30)
   searchField.inputType = "default"
   searchField:setReturnKey("done")
   searchField.placeholder = "Search for user..."
   searchField:addEventListener("userInput", onSearch)
   topbarContainer:insert(searchField)
   searchField.x = 0
   searchField.y = 32

   -- Handle the scroll view events
   local function scrollListener(event)
   		local phase = event.phase
   		if ( phase == "began" ) then print( "Scroll view was touched" )
   		elseif ( phase == "moved" ) then print( "Scroll view was moved" )
   		elseif ( phase == "ended" ) then print( "Scroll view was released" )
   		end

   		if (event.limitReached) then
   			if (event.direction == "up") then print("Reached bottom limit")
   			elseif (event.direction == "down") then print("Reached top limit")
   			elseif (event.direction == "left") then print("Reached right limit")
   			elseif (event.directoin == "right") then print("Reached left limit")
   			end
   		end

   		return true
   end

   -- Create the scrollable view for the cards
   -- local scrollView = widget.newScrollView(
   -- 		{
   -- 			top = 100,
   -- 			left = 0,
   -- 			width = 320,
   -- 			height = 470,
   -- 			scrollWidth = 300,
   -- 			scrollHeight = 800,
   -- 			listener = scrollListener
   -- 		}
   -- )

   -- Put a background in the scroll view to test functionality
   -- local scrollBackground = display.newImageRect("scrollBackground.jpg", 
   --    display.contentWidth, display.contentHeight)
   -- scrollView:insert(scrollBackground)
   -- scrollBackground.x = display.contentCenterX
   -- scrollBackground.y = 285
  
   -- Set the topbar's position
   topbarContainer.y = 50

   -- Add everything to the scenegroup
   -- sceneGroup:insert(scrollView)
   -- sceneGroup:insert(scrollBackground)
   sceneGroup:insert(topbarContainer)

   local function removeKeyboard()
     native.setKeyboardFocus(nil)
   end

   Runtime:addEventListener("tap",removeKeyboard)

   -- sceneGroup:insert(topbarBackground)
   -- sceneGroup:insert(menuBtn)
   -- sceneGroup:insert(cameraBtn)
   -- sceneGroup:insert(topbarInsignia)
   -- sceneGroup:insert(searchField)
   -- sceneGroup:insert(scrollBackground)

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
      -- composer.setVariable("passScene", "")
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
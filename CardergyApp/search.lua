-----------------------------------------------------------------------------------------
--
-- search.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local host, port = "34.230.251.252", 40000
local socket = require("socket")
local tcp = assert(socket.tcp())
local topbarContainer, topbarBackground, menuBtn, cameraBtn, topbarInsignia
local tableView = nil
local rowCnt = 0
local parts
local tableFlag = false
local rowData = {}

-- Function to shoow the search field
function scene:showSearch()
   autoSearchField.isVisible = true
end
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   --local user = composer.getVariable("user")
   -- Create top bar menu
   topbarContainer = display.newContainer(display.contentWidth, 100)
   topbarContainer:translate(display.contentWidth * 0.5, -5)
   local paint = {
      type = "gradient",
      color1 = {248/255,181/255,0/255},
      color2 = {252/255,234/255,187/255},
      direction = "down"
   }
   topbarBackground = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, 100)
   topbarBackground.fill = paint
   topbarContainer:insert(topbarBackground, true)

   -- Function to handle going back to the previous scene
   local function backIcnEvent(event)
      -- Remove the keyboard from the screen
      native.setKeyboardFocus(nil)

      -- Go back to previous scene
      local options = {
         effect = "slideRight",
         time = 800
      }
      composer.gotoScene("item", options)
   end

   -- Create the back button
   backIcn = widget.newButton({
      width = 30,
      height = 30,
      defaultFile = "back_icon.png",
      --overFile = "back_pressed.png"
      onRelease = backIcnEvent
   }) 
   topbarContainer:insert(backIcn)
   backIcn.x = -140
   backIcn.y = -10

   -- Function to hanle the menu button being pressed
   function menuEvent(event)
      -- Hide the search bar and remove the keyboard from the screen
      autoSearchField.isVisible = false
      native.setKeyboardFocus(nil)

      -- Show the menu overlay
      local options = {
         isModal = true,
         effect = "slideRight",
         time = 400
      }
      composer.showOverlay("menu", options)
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
   menuBtn.x = -105
   menuBtn.y = -10

   topbarInsignia = display.newImageRect("logo_black.png", 100, 33)
   topbarInsignia.y = -10

   topbarContainer:insert(topbarInsignia)

   -- Function to handle going to the QR scanner
   local function cameraEvent(event)
      autoSearchField.isVisible = false
      -- Go to the QR scanner
      composer.gotoScene("qrScanner")
   end

   -- Create the camera button
   cameraBtn = widget.newButton({
         width = 30,
         height = 30,
         defaultFile = "camera_icon.png",
         --overFile = "camera_pressed.png",
         onRelease = cameraEvent
   })
   topbarContainer:insert(cameraBtn)
   cameraBtn.x = 140
   cameraBtn.y = -10

   -- String object function for parsing a string by delimiter
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

   -- Function to render the rows of the table
   local function onRowRender(event)
      local row = event.row

      local rowHeight = row.contentHeight
      local rowWidth = row.contentWidth

      -- Store the first and last name and the username from the search
      local result = parts[row.index+1]:split()
      local userStr = result[1]
      rowData[row.index] = userStr
      local firstStr = result[2]
      local lastStr = result[3]

      -- Display the username in the row
      userTxt = display.newText(row, userStr, 0, 0, native.systemFont, 14)
      userTxt:setFillColor(0,0,0)
      userTxt.anchorX = 0
      userTxt.x = 16
      userTxt.y = rowHeight * 0.5

      -- Display the first and last names in the row
      nameTxt = display.newText(row, firstStr.." "..lastStr, 0, 0, native.systemFont, 14)
      nameTxt:setFillColor(0,0,0)
      nameTxt.anchorX = 0
      nameTxt.x = 130
      nameTxt.y = rowHeight * 0.5
   end

   -- Function for handling pressing a row in the table
   local function onRowTouch(event)
      -- Check if row has been released
      if (event.phase == "release") then
         local row = event.row

         -- Store the recipient user in a composer global
         composer.setVariable("recipientUser", rowData[row.index])
         composer.setVariable("recipientFlag", "auto")

         -- Remove the keyboard from the screen
         native.setKeyboardFocus(nil)

         -- Go to the message scene
         local options = {
            effect = "slideLeft",
            time = 800
         }
         composer.gotoScene("message", options)
      end
   end

   -- Function to handle searching
   local function onSearch(event)
      if ("began" == event.phase) then
      -- Check if the search field is being edited
      elseif ("editing" == event.phase) then
         -- Check if table view needs to be reset
         if (tableFlag == false) then
            display.remove(tableView)
         end

         tableFlag = false

         -- Empty out row data storage each time a new table is generated
         rowData = {}

         -- Send the searched text to the server
         search = "search:"..autoSearchField.text.."\n"
         tcp:connect(host, port)
         tcp:send(search)
         local s, status, partial = tcp:receive()
         tcp:close()

         -- Parse the returned string from the server
         if (s ~= nil and s ~= "") then
               parts = s:split("[^:]+")
               rowCnt = tonumber(parts[1])
         elseif (partial ~= nil and partial ~= "") then
               parts = partial:split("[^:]+")
               rowCnt = tonumber(parts[1])
         end

         -- Create the table
         tableView = widget.newTableView({
            height = 470,
            width = 320,
            onRowRender = onRowRender,
            onRowTouch = onRowTouch,
            listener = scrollListener,
         })
         tableView.anchorY = 0
         tableView.x = display.contentCenterX
         tableView.y = display.contentCenterY-185

         -- Insert the table rows
         if (rowCnt > 0) then
            for i = 1, rowCnt do
               -- Insert a row into the tableView
               tableView:insertRow({
                  rowHeight = 35,
                  rowColor = {default={249/255,250/255,252/255}}
               })
            end
         end

         -- Check if search field is empty or null
         if (autoSearchField.text == nil or autoSearchField.text == "") then
            -- Reset the table view
            tableFlag = true
            display.remove(tableView)
         else
            sceneGroup:insert(tableView)
         end
      elseif ("submitted" == event.phase) then
         native.setKeyboardFocus(nil)
      elseif ("ended" == event.phase) then
         native.setKeyboardFocus(nil)
      end
   end

   -- Create the search field
   autoSearchField = native.newTextField(0, 0, 300, 30)
   autoSearchField.inputType = "default"
   autoSearchField:setReturnKey("done")
   autoSearchField.placeholder = "Search for user..."
   autoSearchField:addEventListener("userInput", onSearch)
   topbarContainer:insert(autoSearchField)
   autoSearchField.y = 30
  
   topbarContainer.y = 50

   sceneGroup:insert(topbarContainer)

   -- Function to handle removing the keyboard from the screen after runtime is pressed
   local function removeKeyboard()
     native.setKeyboardFocus(nil)
   end

   -- Add event listener for removing the keyboard from the sreen after runtime gets pressed
   Runtime:addEventListener("tap",removeKeyboard)
end

-- "scene:show()"
function scene:show( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      -- Called when the scene is still off screen (but is about to come on screen).
      autoSearchField.isVisible = true
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
      composer.setVariable("passScene", "")
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
      -- Reset the search scene
      composer.removeScene("search")
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
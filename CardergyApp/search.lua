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
--local tableHeight = numRows * heightEachRow
 
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
   --local user = composer.getVariable("user")
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

   local function backIcnEvent(event)
      local options = {
         effect = "slideRight",
         time = 800
      }
      composer.gotoScene("item", options)
   end

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

   local function onRowRender(event)
      local row = event.row

      local rowHeight = row.contentHeight
      local rowWidth = row.contentWidth
      local result = parts[row.index+1]:split()
      local userStr = result[1]
      rowData[row.index] = userStr
      local firstStr = result[2]
      local lastStr = result[3]

      userTxt = display.newText(row, userStr, 0, 0, native.systemFont, 14)
      userTxt:setFillColor(0,0,0)
      userTxt.anchorX = 0
      userTxt.x = 30
      userTxt.y = rowHeight * 0.5

      nameTxt = display.newText(row, firstStr.." "..lastStr, 0, 0, native.systemFont, 14)
      nameTxt:setFillColor(0,0,0)
      nameTxt.anchorX = 0
      nameTxt.x = 120
      nameTxt.y = rowHeight * 0.5
   end

   local function onRowTouch(event)
      local row = event.row
      --print(tableView._view._rows[row.index])
      composer.setVariable("recipientUser", rowData[row.index])

      local options = {
         effect = "slideLeft",
         time = 800
      }

      composer.gotoScene("message", options)
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
            height = rowCnt * 35,
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
                  rowHeight = 35,
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
      elseif ("ended" == event.phase) then
      end
   end

   searchField = native.newTextField(0, 0, 300, 30)
   searchField.inputType = "default"
   searchField:setReturnKey("done")
   searchField.placeholder = "Search for user..."
   searchField:addEventListener("userInput", onSearch)
   topbarContainer:insert(searchField)
   searchField.y = 30
  
   topbarContainer.y = 50

   sceneGroup:insert(topbarContainer)

   local function removeKeyboard()
     native.setKeyboardFocus(nil)
   end

   Runtime:addEventListener("tap",removeKeyboard)
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
      composer.setVariable("passScene", "")
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
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
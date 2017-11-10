display.setStatusBar(display.DarkStatusBar)
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local host, port = "34.230.251.252", 40000
local socket = require("socket")
local tcp = assert(socket.tcp())
local crypto = require("crypto")

-------------------------Variables-----------------------------------------------
local topbarContainer, topbarBackground, menuBtn, cameraBtn, topbarInsignia
local i
local rowTitle = nil
local getProfile = ""
local setProfile = ""
local parts
local errorOpts = nil
local uname, pass, email, phone, name, street, city, state, zip
 
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
 
-- local forward references should go here
 
---------------------------------------------------------------------------------
function scene:revertAlapha(field)
   native.setKeyboardFocus(field)
end
 
-- "scene:create()"
function scene:create( event )
 
   local sceneGroup = self.view
 
   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
   local user = composer.getVariable("user")
   local topbarContainer = display.newContainer(display.contentWidth, 60)
   topbarContainer:translate(display.contentWidth * 0.5, -5)

   local topbarBackground = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, 60)
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
   menuBtn.y = 10

   topbarInsignia = display.newImageRect("logo_black.png", 128, 45)
   topbarInsignia.y = 10

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
   cameraBtn.y = 10

   topbarContainer.y = 30

   local function profileEvent(event)
   end

   profileBtn = widget.newButton({
      width = 150,
      height = 150,
      defaultFile = "profile_icon.png",
      --overFile = "camera_pressed.png",
      onRlease = profileEvent
   })
   profileBtn.x = display.contentCenterX
   profileBtn.y = display.contentCenterY-130

   local function rowProperties(index, title, height, width)
      if (index == 1) then
         --title.anchorX = 0
         title.x = display.contentCenterX+20
         title.y = height * 0.5
      else
         title.anchorX = 0
         title.x = 25
         title.y = height * 0.5
      end
   end

   local function changeError(f, t, s)
      errOpts = {
         isModal = true,
         effect = "fade",
         time = 400,
         params = {
            errTitle = t,
            errStr = s,
            errField = f
         }
      }
   end

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

   getProfile = "getProfile:"..user
   tcp:connect(host, port)
   tcp:send(getProfile)
   local s, status, partial = tcp:receive()
   tcp:close()

   if (s ~= nil and s ~= "") then
      parts = s:split("[^:]+")
      uname = parts[1]
      pass = parts[2]
      email = parts[3]
      phone = parts[4]
      name = parts[5]
      street = parts[6]
      city = parts[7]
      state = parts[8]
      zip = parts[9]
   elseif (partial ~= nil and partial ~= "") then
      parts = partial:split("[^:]+")
      uname = parts[1]
      pass = parts[2]
      email = parts[3]
      phone = parts[4]
      name = parts[5]
      street = parts[6]
      city = parts[7]
      state = parts[8]
      zip = parts[9]
   else
      changeError(nil, "ERROR", "Database problem. Try again later.")
      composer.showOverlay("error", errOpts)
   end

   -- The "onRowRender" function may go here (see example under "Inserting Rows", above)
   local function onRowRender(event)
      local row = event.row

      local rowHeight = row.contentHeight
      local rowWidth = row.contentWidth

      if (row.index == 1) then
         rowTitle = display.newText(row, name, 0, 0, native.systemFont, 28)
      elseif (row.index == 2) then
         rowTitle = display.newText(row, "Username: "..uname, 0, 0, native.systemFont, 14)
      elseif (row.index == 3) then
         rowTitle = display.newText(row, "Password: ********", 0, 0, native.systemFont, 14)
      elseif (row.index == 4) then
         rowTitle = display.newText(row, "Email: "..email, 0, 0, native.systemFont, 14)
      elseif (row.index == 5) then
         rowTitle = display.newText(row, "Phone: "..phone, 0, 0, native.systemFont, 14)
      elseif (row.index == 6) then
         rowTitle = display.newText(row, "Street: "..street, 0, 0, native.systemFont, 14)
      elseif (row.index == 7) then
         rowTitle = display.newText(row, "City: "..city, 0, 0, native.systemFont, 14)
      elseif (row.index == 8) then
         rowTitle = display.newText(row, "State: "..state, 0, 0, native.systemFont, 14)
      elseif (row.index == 9) then
         rowTitle = display.newText(row, "Zip: "..zip, 0, 0, native.systemFont, 14)
      end

      rowTitle:setFillColor(0,0,0)
      rowProperties(row.index, rowTitle, rowHeight, rowWidth)
   end
 
   -- Create the widget
   local tableView = widget.newTableView({
      height = 330,
      width = 355,
      onRowRender = onRowRender,
      onRowTouch = onRowTouch,
      isLocked = true,
      listener = scrollListener
   })
   tableView.x = display.contentCenterX
   tableView.y = display.contentCenterY+120
    
   -- Insert 40 rows
   for i = 1, 10 do
      -- Insert a row into the tableView
      tableView:insertRow({
         rowHeight = 35,
         rowColor = {default={249/255,250/255,252/255}}
      })
   end

   sceneGroup:insert(topbarContainer)
   sceneGroup:insert(tableView)
   sceneGroup:insert(profileBtn)

   local function backEvent(event)
      local options = {
         effect = "slideRight",
         time = 800
      }
      composer.gotoScene("start", options)
   end

   --[[backBtn = widget.newButton(
   {
      label = "Back",
      fontSize = 20,
      font = native.systemFontBold,
      emboss = true,
      onRelease = backEvent,
      shape = "roundedRect",
      width = 220,
      height = 60,
      cornerRadius = 30,
      fillColor = {default={1,1,1}, over={1,0,0.5}},
   })
   backBtn.x = display.contentCenterX
   backBtn.y = display.contentCenterY - 200
   sceneGroup:insert(backBtn)--]]
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
      composer.removeScene("profile")
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
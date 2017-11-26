display.setStatusBar(display.DarkStatusBar)
local composer = require( "composer" )
local scene = composer.newScene()
local widget = require("widget")
local topbarBackground, menuBtn, cameraBtn, topbarInsignia
local host, port = "34.230.251.252", 40000
local socket = require("socket")
local tcp = assert(socket.tcp())
local ftp = require("socket.ftp")
local Card = require("card")
tableFlag = false
local parts = nil
rowCnt = 0
images = {}
categories = {}
names = {}
tableView = nil
Niall = nil
searchField = nil

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------
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

---------------------------------------------------------------------------------

function scene:showSearch()
   searchField.isVisible = true
end

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

  topbarBackground = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, 100)
  topbarBackground.fill = paint
  topbarContainer:insert(topbarBackground, true)

  -- Handle the menu button's touch events
  function menuEvent(event)
    -- hide the search bar because it's a pain
    searchField.isVisible = false

    local options = {
      isModal = true,
      effect = "slideRight",
      time = 400
    }
    
    -- Show the overlay in all its glory
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
  menuBtn.x = -135
  menuBtn.y = -4

  -- Cardergy logo for the top menu bar
  topbarInsignia = display.newImageRect("logo_black.png", 100, 33)
  topbarInsignia.y = -10
  topbarContainer:insert(topbarInsignia)

  -- Handle the camera button events
  local function cameraEvent(event)
    composer.gotoScene("qrScanner")
  end

  -- Create the camera button in the top menu bar
  cameraBtn = widget.newButton({
       width = 30,
       height = 30,
       defaultFile = "camera_icon.png",
       --overFile = "camera_pressed.png",
       onRelease = cameraEvent
  })

  topbarContainer:insert(cameraBtn, true)
  cameraBtn.x = 135
  cameraBtn.y = -5

  local function searchEvent(searchStr)
    local function onRowRender( event )
      -- Get reference to the row group
      local row = event.row

      -- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
      local rowHeight = row.contentHeight
      local rowWidth = row.contentWidth

      local result = parts[row.index+1]:split("[^/]+")
      local category = result[1]
      local result2 = result[2]:split("[^%.]+")
      local name = result2[1]
      
      f,e = ftp.get("ftp://tjw0018:tevon@34.230.251.252/var/www/html/cards/"..category:gsub(" ", "%%20").."/"..result[2]:gsub(" ", "%%20")..";type=i") --login to ftp server and fetch file at given directory using binary mode (not ascii)
      local path = system.pathForFile(result[2],system.TemporaryDirectory) --get system (lua) Documents directory
      -- Open the file handle
      local file, errorString = io.open( path, "wb" ) -- open file for writing with path
      file:write(f) --write ftp data to file
      file:close() --close file
      

      local rowName = display.newText(row, "Name: "..name, 0, 0, native.systemFont, 14)
      rowName:setFillColor( 0 )
      rowName.anchorX = 0
      rowName.x = 90
      rowName.y = rowHeight * 0.35

      local rowCategory = display.newText(row, "Category: "..category, 0, 0, native.systemFont, 14)
      rowCategory:setFillColor( 0 )
      rowCategory.anchorX = 0
      rowCategory.x = 90
      rowCategory.y = rowHeight * 0.65

      --Add row image to cells
      local rowImage = display.newImageRect(row, result[2], system.TemporaryDirectory, 50, 80)
      rowImage.x = 40
      rowImage.y = rowHeight/2
      images[row.index] = result[2]
      categories[row.index] = category
      names[row.index] = name
    end

    local function onRowTouch(event)
      if (event.phase == "release") then
        local row = event.row

        Niall = Card:new({})
        Niall:setCategory(categories[row.index])
        Niall:setBackImage(images[row.index])
        Niall:setName(names[row.index])

        composer.setVariable("Niall", Niall)
        native.setKeyboardFocus(nil)

        local options = {
           effect = "slideLeft",
           time = 800
        }

        composer.gotoScene("item", options)
      end
    end

    images = {}
    categories = {}
    names = {}

    getCards = "getCards:"..searchStr
    tcp:connect(host, port)
    tcp:send(getCards)
    local s, status, partial = tcp:receive()
    tcp:close()

    if (s ~= nil and s ~= "") then
      parts = s:split("[^:]+")
      rowCnt = tonumber(parts[1])
    elseif (partial ~= nil and partial ~= "") then
      parts = partial:split("[^:]+")
      rowCnt = tonumber(parts[1])
    end

    tableView = widget.newTableView({
      height = rowCnt * 90,
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

    sceneGroup:insert(tableView)
  end

  local function onSearch(event)
    if ("began" == event.phase) then
    elseif ("submitted" == event.phase) then
      display.remove(tableView)
      searchEvent(searchField.text)
      --native.setKeyboardFocus(nil)
    elseif ("ended" == event.phase) then
      display.remove(tableView)
      searchEvent(searchField.text)
      --native.setKeyboardFocus(nil)
    end
  end

  -- Create the search bar
  searchField = native.newTextField(0, 0, 300, 30)
  searchField.inputType = "default"
  searchField:setReturnKey("done")
  searchField.placeholder = "Search for card..."
  searchField:addEventListener("userInput", onSearch)
  topbarContainer:insert(searchField)
  searchField.x = 0
  searchField.y = 32

  searchEvent("")

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
  
  if (phase == "will") then
  elseif ( phase == "did" ) then
    -- Called when the scene is now on screen.
    -- Insert code here to make the scene come alive.
    -- Example: start timers, begin animation, play audio, etc.
    composer.removeScene("item")
    composer.removeScene("search")
    composer.removeScene("message")
    composer.removeScene("manually")
    composer.removeScene("videoRecord")
    composer.removeScene("order")
  end
end
 
-- "scene:hide()"
function scene:hide( event )
 
   local sceneGroup = self.view
   local phase = event.phase
 
   if ( phase == "will" ) then
      
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
local composer = require("composer")
local scene = composer.newScene()
local widget = require("widget")

------Change this to change the current user's name-------
local username = "USER"

-- Setup the scene
function scene:create(event)
	local sceneGroup = self.view
	local parent = event.parent

	-- Specify the onRowRender function
	local function onRowRender(event)
		-- Get reference to the row group
		local row = event.row

		-- Cache the row "contentWidth" and "contentHeight" because the row bounds can change as children objects are added
		local rowHeight = row.contentHeight
		local rowWidth = row.contentWidth

		local rowTitle

		if (row.index == 1) then
			rowTitle = display.newText(row, "     Home", 0, 0, nil, 15)
		elseif (row.index == 2) then
			rowTitle = display.newText(row, "     Account", 0, 0, nil, 15)
		elseif (row.index == 3) then
			rowTitle = display.newText(row, "     Rankings", 0, 0, nil, 15)
		elseif (row.index == 4) then
			rowTitle = display.newText(row, "     QR Camera", 0, 0, nil, 15)
		elseif (row.index == 5) then
			rowTitle = display.newText(row, "     About Us", 0, 0, nil, 15)
		elseif (row.index == 6) then
			rowTitle = display.newText(row, "     Logout", 0, 0, nil, 15)
		end

		rowTitle:setFillColor(0.2, 0.2, 0.2)

		-- Align the label left and vertically centered
		rowTitle.anchorX = 0
		rowTitle.x = 0
		rowTitle.y = rowHeight * 0.5
	end

	-- Specify the onRowTouch function
	local function onRowTouch(event)
		-- Get reference to the row group
		local row = event.row

		if (event.phase == "release") then
			if (row.index == 1) then
				-- Home
				-- Call the hide overlay
				-- Call a gotoscene for Home
			elseif (row.index == 2) then
				-- Account
				-- Call the hide overlay
				-- Call a gotoscene for Account
			elseif (row.index == 3) then
				-- Rankings (SCRATCH THIS)
				-- Call the hide overlay
				-- Call a gotoscene for Rankings
			elseif (row.index == 4) then
				-- QR Camera
				-- Call the hide overlay
				-- Call a gotoscene for QR Camera
			elseif (row.index == 5) then
				-- About Us
				-- Call the hide overlay
				-- Call a gotoscene for About Us
			elseif (row.index == 6) then
				-- Logout functionality
				-- Call the hide overlay
				-- Call logout function
				-- Call a gotoscene for login
			end
		end
	end

	-- Create the tableview
	local menulist = widget.newTableView({
		left = 10,
		top = 70,
		height = 600,
		width = 260,
		onRowRender = onRowRender,
		onRowTouch = onRowTouch,
		listener = scrollListener,
		isLocked = true,
		noLines = false,
		backgroundColor = { 0.8, 0.8, 0.8 }
	})

	-- Insert rows
	for i = 1, 6 do
		-- Insert a row into the tableview
		menulist:insertRow
		{
			isCategory = false,
			rowHeight = 50,
			rowColor = { default={ 0.8, 0.8, 0.8 }, over={ 1, 0.5, 0, 0.2 } },
			lineColor = { 0.5, 0.5, 0.5 }
		}
	end

	-- Add the user image
	local userImage = display.newImage("profile_icon.png", 10, 10)
	userImage.anchorX = 0
	userImage.x = 10
	userImage.y = 40
	userImage.width = 30
	userImage.height = 30

	-- Add the user name label
	local userLabel = display.newText({
		text = "HELLO, " .. username,
		font = native.systemFont,
		fontSize = 18
	})
	userLabel.anchorX = 0
	userLabel.x = 50
	userLabel.y = 42

	-- Add close button event handler
	local function closeButtonPressed(event)
		composer.hideOverlay(true, "slideLeft", 400)
	end

	-- Add the menu close button
	local closeButton = widget.newButton({
		width = 15,
		height = 15,
		onRelease = closeButtonPressed,
		defaultFile = "close.png"
	})
	closeButton.anchorX = 0
	closeButton.x = 290
	closeButton.y = 42
	closeButton.width = 15
	closeButton.height = 15

	-- Add a box to 'dim' the background while the overlay is active
	-- May need to add transitioning to this
	local backgroundDimmer = display.newRect(display.contentCenterX, 
		display.contentCenterY, display.contentWidth, display.contentHeight)

	backgroundDimmer:setFillColor(0,0,0)
	backgroundDimmer.alpha = 0.9

	sceneGroup:insert(backgroundDimmer)
	sceneGroup:insert(userImage)
	sceneGroup:insert(userLabel)
	sceneGroup:insert(closeButton)
	sceneGroup:insert(menulist)
end

-- Show the scene
function scene:show(event)
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

-- Hide the scene
function scene:hide(event)
   local sceneGroup = self.view
   local phase = event.phase
   local parent = event.parent

   local function show(event)
   	parent:showSearch()
   end
 
   if ( phase == "will" ) then
      -- Call any parent functions that need to happen when the overlay goes away
      timer.performWithDelay(360, show)
   elseif ( phase == "did" ) then
      -- Called immediately after scene goes off screen.
   end
end

-- Destroy the scene and clean up
function scene:destroy(event)
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
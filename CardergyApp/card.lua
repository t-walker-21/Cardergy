
local Card = { name = "", category = "", message = "", qr = "", backImage="",video = "" }

function Card:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;
  return o;
end

function Card:setName(name)
	self.name = name
end

function Card:setMessage(message)
 	self.message = message
end

function Card:setQr(qr)
 	self.qr = qr
end

function Card:setBackImage(backImage)
 	self.backImage = backImage
end

function Card:setCategory(category)
 	self.category = category
end

function Card:setVideo(video)
 	self.video = video
end

return Card
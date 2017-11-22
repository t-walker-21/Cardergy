
local Card = {category = "", message = "", qr = nil, backImage=nil }

function Card:new (o)    --constructor
  o = o or {}; 
  setmetatable(o, self);
  self.__index = self;
  return o;
end


function Card:setMessage(message)
 	self.message = message
 end

 function Card:setQr(qr)
 	self.qr = qr
 end


 function Card:setBackImage(backImage)
 	self.message = backImage
 end

 function Card:setCategory(category)
 	self.category = category
 end
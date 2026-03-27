
include('shared.lua')

function ENT:Draw()
	
	
	self:DrawModel()
	
	    local dlight = DynamicLight(self:EntIndex())	
	
	if dlight then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos() + self:GetUp() * 120
		dlight.r = 5
		dlight.g = 155
		dlight.b = 255
		dlight.Brightness = 5
		dlight.Size = 250
		dlight.Decay = 0
		dlight.DieTime = CurTime() + 0.1
	end 
end


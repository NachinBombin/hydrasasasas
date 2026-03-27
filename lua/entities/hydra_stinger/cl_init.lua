include('shared.lua')

language.Add("sent_tentacle", "Cable Stinger")

hyd_res = CreateClientConVar( "cl_hydra_resolution", 15, true )

local cablemat = Material( "cable/cable2" )

local function BPoint3D( Points, percent)
	local points = Points
	local nextlayer = {}
	while true do
		for i,p in pairs(points) do
			if i + 1 > #points then break end
			local dif = points[i + 1] - p
			nextlayer[#nextlayer + 1] = p + dif * percent
		end
		
		if #nextlayer > 1 then
			points = nextlayer
			nextlayer = {}
		else
			break
		end
	end
	return nextlayer[#nextlayer]
end

local function BSpline3D( Points, number)
	if (number < 1 or #Points < 2) then Error( "DOING IT WRONG" ); return nil end
	
	local pointtable = {}
	
	for i = 1, number do
		pointtable[i] = BPoint3D( Points, i / number )
	end
	
	return pointtable
end

function ENT:Think()
	local base = self:GetNetworkedEntity("base", self.Entity )
	if (!IsValid(base)) then return end
    self:SetRenderBoundsWS( base:GetPos(), self:GetPos() )
end

function ENT:Draw()

	local res = math.Clamp( hyd_res:GetInt(), 5, 40)
	local base = self:GetNetworkedEntity("base", self.Entity )
	if (!IsValid(base)) then return end
    local Bpoints = {}
	Bpoints[1] = base:GetPos()
	Bpoints[2] = base:GetPos() + Vector(0,0,200)
	
	Bpoints[4] = self:GetPos() - self:GetForward() * 200
	Bpoints[5] = self:GetPos()
	
	local drift = self:GetNetworkedFloat( "sidedrift", 0 )
	
	drift = math.Clamp( drift, -400, 400)
	
	Bpoints[3] = (Bpoints[2] + Bpoints[4]) * 0.5 + (self:GetForward():Cross(Vector(0,0,1))) * drift * -1.5
	
	local bres = BSpline3D( Bpoints, res)
	self:DrawModel()
	render.SetMaterial(cablemat)
	render.StartBeam( res + 1 )
    render.AddBeam( Bpoints[1], 15, 0, Color( 30, 30, 30, 255 ) )
	for i = 2, (res - 1) do
		render.AddBeam( bres[i], 5, i, Color( 30, 30, 30, 255 ) )
	end
	render.AddBeam( bres[res], 7, 2, Color( 30, 30, 30, 255 ) )
	render.AddBeam( bres[res] + self:GetForward() * 10, 7.5, 5, Color( 30, 30, 30, 255 ) )
	render.EndBeam()

	-- Dynamic light: near-black, no blue glow
	local dlight = DynamicLight(self:EntIndex())
	if dlight then
		dlight.Pos = self:GetPos() + self:GetUp() * 0
		dlight.r = 20
		dlight.g = 20
		dlight.b = 20
		dlight.Brightness = 0.5
		dlight.Size = 100
		dlight.Decay = 0
		dlight.DieTime = CurTime() + 0.1
	end
end

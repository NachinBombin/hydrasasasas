
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.ignoretable = {
    "npc_rollermine",
    "npc_turret_floor"
}

function ENT:Initialize()
   
   self.Entity:SetModel( "models/improvedhydra/hydrahead_spike2.mdl" ) 
   self.Entity:SetMaterial("models/hydra/bodysplit")
   self.Entity:PhysicsInit( SOLID_VPHYSICS )
   self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
   self.Entity:SetSolid( SOLID_VPHYSICS )
   self:ManipulateBonePosition(1,  Vector( 0, 0, 90 ))
   self.wanderoffset = Vector(0,0,0)
   self.act = "idle"
   
   self.sound = {}
   self.sound["excited"] = Sound("hydra/hydra_alert1.wav")
   self.sound["gore"] = Sound("hydra/hydra_strike2.wav")
   self.sound["draw"] = Sound("hydra/hydra_strike1.wav")
   self.sound["munch"] = Sound("hydra/hydra_bump1.wav")
   self.sound["fail"] = Sound("hydra/hydra_alert2.wav")
   self.sound["hurt"] = Sound("hydra/hydra_pain2.wav")
   self.sound["wake"] = Sound("hydra/hydra_alert2.wav")
   self.sound["idle"] = Sound("hydra/hydra_3lungbreathe_loop1.wav")
     
   self.dnw = ents.Create( "ai_sound" )
	self.dnw:SetPos( self:GetPos())
	self.dnw:SetKeyValue( "soundtype", 8 )
	self.dnw:SetKeyValue( "volume", 1000 )
	self.dnw:SetKeyValue( "duration", 10 )
	self.dnw:Spawn()
	
	self.dnw:SetParent(self.Entity)
   local phys = self:GetPhysicsObject()
   phys:EnableGravity(false)
   phys:SetMass(1000)
   phys:Wake()
   
   self:SetTrigger( true )
   
   self:StartMotionController()
   
   self.idlepose = Vector(math.Rand(-1,1),math.Rand(-1,1),0):Angle()
   
	self.target = self.Entity
	
	self.timestamp = CurTime()
   CreateConVar("Hydra_Reproduce", 1, bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
   local light = ents.Create("prop_dynamic")
   light:SetModel( "models/improvedhydra/hydrahead_spike2.mdl" ) 
    light:SetMaterial("models/hydra/bodysplit") 
	light:SetModelScale(0.6)
	light:SetColor(Color(0,255,50))
    light:SetPos( Vector( self:GetPos()) + self:GetUp() * 0)
    light:SetAngles(Angle(0, 0, 180)) 
    light:SetParent(self)
    light:Spawn()
 
    self.light = light
	local npcfix = ents.Create("hydra_npcfix")
    npcfix:SetPos( Vector( self:GetPos()) + self:GetUp() * 20)
   npcfix:SetAngles(Angle(0, 0, 180)) 
    npcfix:SetParent(self)
    npcfix:Spawn()
 
    self.npcfix = npcfix
end

function ENT:Touch( ent )
	if ent == self.target then
		
		if (ent:IsPlayer() && ent:InVehicle( )) then
			ent:ExitVehicle( )
		end
		
		self:DoEndTarget()
		KillAndLeaveUsableRagdoll(ent, self:GetForward() * -4440, self:GetPos(), self.Entity, self.Entity)
        self.timestamp = CurTime() + 1
		self:EmitSound( self.sound["gore"] )
		
		local scare = ents.Create( "ai_sound" )
		scare:SetPos( self:GetPos())
		scare:SetKeyValue( "soundtype", 8 )
		scare:SetKeyValue( "volume", 300 )
		scare:SetKeyValue( "duration", 10 )
		scare:Spawn()
		scare:Fire( "EmitAISound" )
		scare:Fire( "Kill", "", 10 )
		
	end
	local harpoon = ent.hasbeenpwned or false
	if ent:GetClass() == "prop_ragdoll" && !harpoon && !self:IsConstrained() then
	
		ent.hasbeenpwned = true
		
		if self:GetPos():Distance(ent:GetPos()) < 30 then
			constraint.Weld( self.Entity, ent, 0, 0, 0, false )
			timer.Simple(1, function() 
                if (!IsValid(self.Entity)) then return end
                	for i=0, ent:GetBoneCount() do
					ent:ManipulateBoneScale( i, Vector(0.9, 0.9, 0.9) )
					self:EmitSound("hydra/hydra_drain.wav")
					end
            end)
			timer.Simple(1.5, function() 
                if (!IsValid(self.Entity)) then return end
                	for i=0, ent:GetBoneCount() do
					ent:ManipulateBoneScale( i, Vector(0.8, 0.8, 0.8) )
					self:EmitSound("hydra/hydra_drain.wav")
					end
            end)
			timer.Simple(2, function() 
                if (!IsValid(self.Entity)) then return end
                	for i=0, ent:GetBoneCount() do
					ent:ManipulateBoneScale( i, Vector(0.7, 0.7, 0.7) )
					self:EmitSound("hydra/hydra_drain.wav")
					end
            end)
			timer.Simple(2.5, function() 
                if (!IsValid(self.Entity)) then return end
                	for i=0, ent:GetBoneCount() do
					ent:ManipulateBoneScale( i, Vector(0.6, 0.6, 0.6) )
					self:EmitSound("hydra/hydra_drain.wav")
					end
            end)
			timer.Simple(3, function() 
                if (!IsValid(self.Entity)) then return end
                	for i=0, ent:GetBoneCount() do
					ent:ManipulateBoneScale( i, Vector(0.5, 0.5, 0.5) )
					self:EmitSound("hydra/hydra_drain.wav")
					end
            end)
			timer.Simple(3.5, function() 
                if (!IsValid(self.Entity)) then return end
                	for i=0, ent:GetBoneCount() do
					ent:ManipulateBoneScale( i, Vector(0.4, 0.4, 0.4) )
					self:EmitSound("hydra/hydra_drain.wav")
					end
            end)
			timer.Simple(4, function() 
                if (!IsValid(self.Entity)) then return end
                	for i=0, ent:GetBoneCount() do
					ent:ManipulateBoneScale( i, Vector(0.3, 0.3, 0.3) )
					self:EmitSound("hydra/hydra_drain.wav")
					end
            end)
			timer.Simple(4.5, function() 
                if (!IsValid(self.Entity)) then return end
                	for i=0, ent:GetBoneCount() do
					ent:ManipulateBoneScale( i, Vector(0.2, 0.2, 0.2) )
					self:EmitSound("hydra/hydra_drain.wav")
					end
            end)
			timer.Simple(5, function() 
                if (!IsValid(self.Entity)) then return end
                	for i=0, ent:GetBoneCount() do
					ent:ManipulateBoneScale( i, Vector(0.1, 0.1, 0.1) )
					self:EmitSound("hydra/hydra_drain.wav")
					end
            end)
			timer.Simple(5.5, function() 
                if (!IsValid(self.Entity)) then return end
                	for i=0, ent:GetBoneCount() do
					ent:ManipulateBoneScale( i, Vector(0, 0, 0) )
					self:EmitSound("hydra/hydra_drain.wav")
					end
            end)
			timer.Simple(6, function() 
                if (!IsValid(self.Entity)) then return end
                ent:Remove()
				self:EmitSound("hydra/hydra_drain.wav")
            end)
			timer.Simple(10, function() 
			if !util.tobool(GetConVar("Hydra_Reproduce"):GetInt() or 1) then return end
                if (!IsValid(self.Entity)) then return end
                local ent = ents.Create( "hydra_egg" )
				self:SetVelocity( ent:GetForward() * 2000 + Vector( 0, 0, 230 ) )
            local TVec = self:GetPos()
			ent:PhysicsInit(SOLID_VPHYSICS)
	        ent:SetMoveType(MOVETYPE_VPHYSICS)
	        ent:SetSolid(SOLID_VPHYSICS)
	        ent:AddFlags(FL_OBJECT)
            ent:SetPos( TVec )
            ent:Spawn()
            ent:Activate()
		self:EmitSound("hydra/hydra_strike1.wav")
            end)
		end
		
		self:DoImpaleBlood(ent:GetBloodColor())
	end
end



function ENT:DoImpaleBlood(color)
	self:EmitSound( self.sound["munch"] )
    
    local Effect = EffectData()
    Effect:SetEntity(self)
    Effect:SetStart(self:GetPos())
    Effect:SetOrigin(self:GetPos())
    Effect:SetScale(2)
    Effect:SetColor(color or 0)
    util.Effect("BloodImpact", Effect, true, true)
    
end

function ENT:OnRemove()
    self:DoEndTarget()
end

function ENT:Think()
	self:SetNetworkedEntity( "base", ent )
	if (self.act != "strike") then
		self.wanderoffset = Vector(math.cos(CurTime()),math.sin(CurTime()),0) * 100
	end
	
	self:NextThink( CurTime())
	local phys = self:GetPhysicsObject()
	
	if self.act == "idle" or self.act == "wary" then
	
		local vel = phys:GetVelocity()
		local dot = vel:DotProduct(self:GetForward():Cross(Vector(0,0,1)))
		self:SetNetworkedFloat( "sidedrift", dot )
	end
	
	if !self.target:IsValid() then self.act = "idle" end
	
	if self.timestamp < CurTime() then
		
		self:SetNetworkedEntity( "base", self.base )
		
		if self.act == "strike" then
			self:DoEndTarget()
			self.timestamp = CurTime() + 1
			 return true
		end
		
		if self.act == "hurt" then
			self:DoEndTarget()
			self:EmitSound( self.sound["wake"])
			self.timestamp = CurTime() + 1
			 return true
		end
		
		if self.act == "wary" then
			if self:Visible(self.target) then
				self.act = "prestrike"
				
				self.dnw:Fire( "EmitAISound" )
				
				self.timestamp = CurTime() + 0.2
				self:EmitSound( self.sound["draw"])
			else
				self:EmitSound( self.sound["fail"] )
				self:DoEndTarget()
				self.timestamp = CurTime() + 1
			end
			 return true
		end
		
		if self.act == "prestrike" then
			self.act = "strike"
			self.timestamp = CurTime() + 1
			 return true
		end
		
		if self.act == "idle" then
			self.timestamp = CurTime() + 1
			
			local disable = GetConVarNumber("ai_disabled")
			if disable == 1 then return true end
			
			self.idlepose = self.idlepose + Angle(0,math.Rand(-10,10), 0)
			local targets = ents.FindInSphere( self.base:GetPos(), 1000)
			local distance = 1000
			
			local PIgnore = GetConVarNumber("ai_ignoreplayers")
			
			
			
			for _,i in pairs(targets) do
				local iclass = i:GetClass()
                
                if (!i:IsNPC() and !i:IsPlayer()) then continue end
                if (i:GetPos():Distance( self:GetPos() ) < distance && self:Visible(i) && i != self.Entity && i != self.base && !table.HasValue(self.ignoretable,iclass)) then
					if i:IsNPC() then
                        distance = i:GetPos():Distance( self:GetPos() )
						self.target = i
						self.act = "wary"
						self.Entity:EmitSound( self.sound["excited"] )
						self.timestamp = CurTime() + 3
						
					end
					if i:IsPlayer() && i:Alive() && PIgnore != 1 then
						distance = i:GetPos():Distance( self:GetPos() )
						self.target = i
						self.act = "wary"
						self.Entity:EmitSound( self.sound["excited"] )
						self.timestamp = CurTime() + 3
					end
						
				end
			end
			 return true
		end
		self:SetOwner( self.target)
		
	end
	
	
	
	 
	 return true
end

function ENT:DoEndTarget()
	self.act = "idle"
	self.target = self.Entity
end

function ENT:PhysicsSimulate(phys, dtime)
	
	local prestrike = Vector(0,0,-100)
	
	
	phys:Wake()
	
      self.ShadowParams={}
	  self.ShadowParams.secondstoarrive = 1
	  
	  if self.act == "prestrike" then
		prestrike = (self.target:GetPos() - self:GetPos()) * -0.5 
		self.ShadowParams.secondstoarrive = 0.2
		end
	
			self.ShadowParams.pos = self.base:GetPos() + Vector(0,0,300) + self.wanderoffset + prestrike
	  if (self.act == "strike" && self.target:IsValid()) then
			if self.target:IsNPC() && self.target:GetNPCState() == 7 then
				self:DoEndTarget()
			end
			
			if (self.target:IsPlayer() && !self.target:Alive()) then
				self:DoEndTarget()
			end
			if self.act == "strike" then
				self.ShadowParams.pos = self.target:GetPos() + Vector(0,0,20)
				self.ShadowParams.secondstoarrive = 0.2
			end
	  end
	if self.target == self.Entity or !self.target:IsValid() then
		self.ShadowParams.angle = self.idlepose
	else
		self.ShadowParams.angle = (self.target:GetPos() - self:GetPos()):GetNormalized():Angle()
	end
	if self.act == "hurt" then
		self.ShadowParams.angle = Angle(-90,0,0)
		self.ShadowParams.pos = self.base:GetPos() + Vector(0,0,20)
	end
      self.ShadowParams.maxangular = 2000
     self.ShadowParams.maxangulardamp = 800
     self.ShadowParams.maxspeed = 10000
     self.ShadowParams.maxspeeddamp = 1000
     self.ShadowParams.dampfactor = 0.8
     self.ShadowParams.teleportdistance = 0
     self.ShadowParams.deltatime = deltatime
     
	 
	 
     phys:ComputeShadowControl(self.ShadowParams)
end

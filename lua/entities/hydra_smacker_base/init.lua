
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )


function ENT:Initialize()
   
   self.Entity:SetModel( "models/props_debris/concrete_spawnplug001a.mdl" )  
   //self.Entity:SetPos(self.Entity:LocalToWorld(Vector(0, 0, -10)))
   self.Entity:PhysicsInit( SOLID_VPHYSICS )
   self.Entity:SetMoveType( MOVETYPE_NONE )
   self.Entity:SetSolid( SOLID_VPHYSICS )
   
   self.ent1 = ents.Create( "Hydra_Smacker" )
      self.ent1:SetPos(self:GetPos() + Vector(0, 0, 20))
	  self.ent1.base = self.Entity
	  self.ent1:SetNetworkedEntity( "base", self.Entity )
   self.ent1:Spawn()
   self.ent1:Activate()
   
   self:DeleteOnRemove(self.ent1)
   
   local phys = self:GetPhysicsObject()
   if phys:IsValid() then
		phys:SetMass( 50000)
		self:SetModelScale(1)
	end
	local npcfix = ents.Create("hydra_npcfix")
    npcfix:SetPos( Vector( self:GetPos()) + self:GetUp() * 20)
   npcfix:SetAngles(Angle(0, 0, 180)) 
    npcfix:SetParent(self)
    npcfix:Spawn()
 
    self.npcfix = npcfix
end



function ENT:SpawnFunction( ply, tr )

   if (!tr.Hit || tr.HitNormal.z == 0) then return end
   
   local TD = {}
   TD.start = tr.HitPos
   TD.endpos = TD.start + Vector(0, 0, 1) * 150
   local trace = util.TraceLine(TD)
   
   if (trace.Hit) then return end
   
   local SpawnPos = tr.HitPos + tr.HitNormal * -4
   
   local ent = ents.Create( "Hydra_Smacker_base" )
   ent:SetPos(SpawnPos)
   ent:SetAngles(tr.HitNormal:Angle() + Angle(90, 0, 0))
   ent:Spawn()
   ent:Activate()   
   return ent
   
end

function ENT:OnTakeDamage(dmg)
	if (dmg:IsExplosionDamage( ) && self.ent1.act != "hurt") then
self:Ignite(10)  
     self:EmitSound("hydra/hydra_pain2.wav")
		self.ent1.act = "hurt"
		self.ent1.timestamp = CurTime() + 60
		timer.Simple(2, function()
         self:Remove()
		 self:EmitSound("hydra/hydra_sendtentacle1.wav" ,80, 65)
		 self.ent2 = ents.Create( "prop_dynamic" )
		 self.ent2:SetModel( "models/props_debris/concrete_spawnplug001a.mdl" )  
		  self.ent2:Ignite(10)  
      self.ent2:SetPos(self:GetPos() + Vector(0, 0, 0))
	  self.ent2.base = self.Entity
	  self.ent2:SetNetworkedEntity( "base", self.Entity )
   self.ent2:Spawn()
   self.ent2:Activate()
   end)
	end
end

function ENT:OnRemove()
end


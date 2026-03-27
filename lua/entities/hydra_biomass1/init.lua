AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/rockcliff01f.mdl")
	self:SetMaterial("models/hydra/bodysplit")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:AddFlags(FL_OBJECT)
	
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(55555)
		phys:SetMaterial("flesh") -- Does this even do anything important? Dunno, but it's here just in case.
	end
	self:SetModelScale(1)

	self:Activate()
	
	self.AttackDamage = 5
	self.AttackDelay = 1

	self.NextAttack = 0
	

	

	

	CreateConVar("Hydra_NPCsAttack", 1, bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
	 local light = ents.Create("prop_dynamic")
   light:SetModel( "models/weapons/w_bugbait.mdl" ) 
    light:SetMaterial("models/hydra/gut") 
	light:SetModelScale(12)
	light:SetColor(Color(255,255,255))
    light:SetPos( Vector( self:GetPos()) + self:GetUp() * -20)
    light:SetAngles(Angle(0, 0, 180)) 
    light:SetParent(self)
    light:Spawn()
 
    self.light = light
	
	
end

function ENT:HateNPCs()
if !util.tobool(GetConVar("Hydra_NPCsAttack"):GetInt() or 1) then return end
	local npcs = ents.FindByClass("*")
	for _, npc in ipairs(npcs) do
		if (npc:IsNPC()) then
			npc:AddEntityRelationship(self, D_HT, 99)
		end
	end
end

function ENT:OnTakeDamage(dmg)
ParticleEffect("antlion_gib_02_blood", self:GetPos(), Angle(0, 0, 0))
if (dmg:IsExplosionDamage())then 
self:Ignite(3)  
     self:EmitSound("hydra/hydra_pain2.wav")
		timer.Simple(3, function()
		self:Remove()
		end)
		end
		
end
	

function ENT:Think()

	

	self:HateNPCs()


	

end


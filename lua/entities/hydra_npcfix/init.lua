AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_c17/clock01.mdl")
	self:SetMaterial("Models/effects/vol_light001")
	self:SetColor(Color(0,0,0))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:AddFlags(FL_OBJECT)
	
	
    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
		phys:SetMass(5)
		phys:SetMaterial("metal") -- Does this even do anything important? Dunno, but it's here just in case.
	end
	self:SetModelScale(1)

	self:Activate()
	
	self.AttackDamage = 5
	self.AttackDelay = 1

	self.NextAttack = 0
	

	

	

	CreateConVar("Hydra_NPCsAttack", 1, bit.bor(FCVAR_NOTIFY, FCVAR_REPLICATED, FCVAR_SERVER_CAN_EXECUTE))
	
	
	
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
self:EmitSound("hydra/hydra_pain" .. math.random(3) .. ".wav")
ParticleEffect("antlion_gib_02_blood", self:GetPos(), Angle(0, 0, 0))
end
	

function ENT:Think()

	

	self:HateNPCs()


	

end


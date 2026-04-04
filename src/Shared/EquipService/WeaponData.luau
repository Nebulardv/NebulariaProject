local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local Types = SharedModules.Types
local WeaponDataTypes = require(Types.WeaponDataTypes)

local Assets = ReplicatedStorage.Assets
local Animations = Assets.Animations
local CombatAnims = Animations.Combat

type WeaponDataTypeDefinition = WeaponDataTypes.WeaponData

local WeaponData: {[string]: WeaponDataTypeDefinition} = {
	["Katana"] = {
		WeaponName = "Katana",
		Damage = 5,
		MaxCombo = 4,
		WeaponAttackCooldown = 1,
		MaxAttackDistanceStuds = 10,
		AttackIntervalCooldown = 0.4,
		AttackAnims = {
			M1 = CombatAnims.Katana.M1,
			M2 = CombatAnims.Katana.M2,
			M3 = CombatAnims.Katana.M3,
			M4 = CombatAnims.Katana.M4,
			Idle = CombatAnims.Katana.Idle,
			Equip = nil,
			Unequip = nil
		},
		WeaponHitboxData = {
			CFrameOffset = CFrame.new(0,0,-4) ,
			Size = Vector3.new(4, 4.5, 4.5),
			HitboxLifetime = 0.2,
		},
		EquipWeaponData = {
			AttachCframe = CFrame.new(0, -1.05, 0),
			EquipAnimation = nil
		}
	},
	["Sword"] = {
		WeaponName = "Sword",
		Damage = 15,
		MaxCombo = 4,
		WeaponAttackCooldown = 0.6,
		MaxAttackDistanceStuds = nil,
		AttackAnims = {
		},
		WeaponHitboxData = {
			CFrameOffset = nil,
			Size = nil,
			HitboxLifetime = 0.5,

		},
		EquipWeaponData = {
			AttachCframe = nil,
			EquipAnimation = nil
		}
	},
}

return WeaponData

--// havent added sword or most weapons yet. Just yet

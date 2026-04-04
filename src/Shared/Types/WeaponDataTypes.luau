--!strict

export type WeaponData = {
	WeaponName: string,
	Damage: number,
	WeaponAttackCooldown: number,
	MaxCombo: number,
	MaxAttackDistanceStuds: number, 
	AttackIntervalCooldown: number,
	AttackAnims: {
		M1: Animation?,
		M2: Animation?,
		M3: Animation?,
		M4: Animation?,
		Idle: Animation?,
		Equip: Animation?,
		Unequip: Animation?,
	},
	WeaponHitboxData: {
		CFrameOffset: CFrame,
		Size: Vector3,
		HitboxLifetime: number,
	},
	EquipWeaponData: {
		AttachCframe: CFrame,
		EquipAnimation: Animation
	}
}

return {}

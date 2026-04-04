--// directly under StateMachine

local PlayerStateConditions = {}

PlayerStateConditions.Conditions = {}

function PlayerStateConditions.RegisterPlayerConditions(Player: Player)
	PlayerStateConditions.Conditions[Player.UserId] = {
		IsMoving = false,
		IsSprinting = false,
		IsBlocking = false,
		IsAttacking = false,
		IsStunned = false,
		IsDead = false,
	}
end

function PlayerStateConditions.GetConditions(Player: Player)
	local PlayerID = Player.UserId
	
	return PlayerStateConditions.Conditions[PlayerID]
end

function PlayerStateConditions.UpdateConditions(Player: Player, InputConditons)
	local PlayerID = Player.UserId
	local CurrentConditions = PlayerStateConditions.Conditions[PlayerID]
	
	for Condition, Value in InputConditons do
		if CurrentConditions[Condition] == nil then
			warn("Condition " .. Condition .. " does not exist")
			return
		end
		CurrentConditions[Condition] = Value
	end
	
end

return PlayerStateConditions

-- Here I set up the spell parameters, damage type, animation effect and area
local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
combat:setArea(createCombatArea(AREA_DIAMOND5X5)) -- AREA_DIAMOND5X5 was created on lib/spells.lua

-- Here we get the min and max spell damage, got this formula from another spell
function onGetFormulaValues(player, level, magicLevel)
	local min = (level / 5) + magicLevel + 6
	local max = (level / 5) + (magicLevel * 2.6) + 16
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues") -- Register callback

function onCastSpell(creature, variant, isHotkey)
    return combat:execute(creature, variant)-- Execute combat animation
end
aura_env.active = 0
aura_env.spellSchool = {}
aura_env.currentAbsorb = {}
aura_env.maxAbsorb = {}
aura_env.totalAbsorb = 0
aura_env.schoolAbsorb = {0, 0, 0, 0, 0, 0, 0, 0, 0}

local function improvedPowerWordShieldMultiplier()
    -- FIXME: GetTalentInfo(1, 5)
    return 1.15
end

aura_env.talentMultiplier = {
    [   17] = improvedPowerWordShieldMultiplier,
    [  592] = improvedPowerWordShieldMultiplier,
    [  600] = improvedPowerWordShieldMultiplier,
    [ 3747] = improvedPowerWordShieldMultiplier,
    [ 6065] = improvedPowerWordShieldMultiplier,
    [ 6066] = improvedPowerWordShieldMultiplier,
    [10898] = improvedPowerWordShieldMultiplier,
    [10899] = improvedPowerWordShieldMultiplier,
    [10900] = improvedPowerWordShieldMultiplier,
    [10901] = improvedPowerWordShieldMultiplier,
}

function aura_env:CalculateAbsorbValue(spellName, spellId, absorbInfo)
    -- FIXME: if caster != player
    local value = 0
    local keys = self.absorbDbKeys
    local bonusHealing = GetSpellBonusHealing()
    local level = UnitLevel("player")
    local base = absorbInfo[keys.basePoints]
    local perLevel = absorbInfo[keys.pointsPerLevel]
    local baseLevel = absorbInfo[keys.baseLevel]
    local maxLevel = absorbInfo[keys.maxLevel]
    local spellLevel = absorbInfo[keys.spellLevel]
    local bonusMult = absorbInfo[keys.healingMultiplier]
    local baseMultFn = self.talentMultiplier[spellId]
    local levelPenalty = min(1, 1 - (20 - spellLevel) * .0375)
    local levels = max(0, min(level, maxLevel) - baseLevel)
    local baseMult = baseMultFn and baseMultFn() or 1

    value = (
        baseMult * (base + levels * perLevel) +
        bonusHealing * bonusMult * levelPenalty
    )

    self:log('CalculateAbsorbValue', spellName,
        value, base, perLevel, levels, baseMult,
        bonusHealing, bonusMult, levelPenalty)

    return value
end

function aura_env:GetBuffId(spellName)
    local auraName, spellId
    for i = 1, 255 do
        auraName, _, _, _, _, _, _, _, _, spellId = UnitBuff("player", i)
        if auraName == spellName then
            break
        elseif not auraName then
            spellId = nil
            break
        end
    end
    return spellId
end

function aura_env:ApplyAura(spellName)
    local school = self.spellSchool[spellName]
    self:log('ApplyAura', spellName, school)

    if 0 ~= school then
        local spellId = self:GetBuffId(spellName)
        local absorbInfo = self.absorbDb[spellId]

        self:log('ApplyAuraAbsorbOrNew', spellId)

        if absorbInfo then
            local value = self:CalculateAbsorbValue(
                spellName, spellId, absorbInfo)

            self:log('ApplyAuraSchool', school)
            if nil == school then
                school = absorbInfo[self.absorbDbKeys.school]
                self.spellSchool[spellName] = school
            end

            if self.maxAbsorb[spellName] then
                self:log('ApplyAuraUpdateCurrent', spellName, value)
                self.currentAbsorb[spellName] = value
            else
                self:log('ApplyAuraSetCurrent', spellName, value)
                self.active = self.active + 1

                -- If damage event happened before aura was removed
                local prevValue = self.currentAbsorb[spellName]
                self.currentAbsorb[spellName] = value + (prevValue or 0)
            end

            self:log('ApplyAuraSetMax', spellName, value)
            self.maxAbsorb[spellName] = value
            self:UpdateValues()
        end
    end
end

function aura_env:RemoveAura(spellName)
    self:log('RemoveAura', spellName)
    if self.currentAbsorb[spellName] then
        self.currentAbsorb[spellName] = nil
        self.active = self.active - 1
        self:log('RemoveAuraRemaining', self.active)
        if self.active < 1 then
            self.active = 0
            wipe(self.maxAbsorb)
        end
        self:UpdateValues()
    end
end

function aura_env:ApplyDamage(spellName, value)
    self:log('ApplyDamage', spellName, value)
    local newValue = (self.currentAbsorb[spellName] or 0) - value
    if self.maxAbsorb[spellName] then
        self.currentAbsorb[spellName] = max(0, newValue)
        self:UpdateValues()
    else
        self.currentAbsorb[spellName] = newValue
    end
end

function aura_env:ResetValues()
    self:log('ResetValues')
    local spellName
    wipe(self.currentAbsorb)
    wipe(self.maxAbsorb)
    self.active = 0
    for i = 1, 255 do
        spellName = UnitBuff("player", i)
        if not spellName then
            break
        end
        self:ApplyAura(spellName)
    end
    self:UpdateValues()
end

function aura_env:UpdateValues()
    self:log('UpdateValues')
    local values = self.schoolAbsorb
    local keys = self.schoolIdx
    local spellSchool = self.spellSchool
    local current = self.currentAbsorb
    local total = 0
    local key, value, school

    for i = 1, #values do
        values[i] = 0
    end

    for spell, maxValue in pairs(self.maxAbsorb) do
        school = spellSchool[spell]
        key = keys[school]
        total = total + maxValue
        value = (current[spell] or 0)
        values[key] = values[key] + value
        self:log('UpdateValues', spell, school, key, maxValue, value)
    end

    self.totalAbsorb = total
    WeakAuras.ScanEvents("WA_NAN_SHIELD", total, unpack(values))
    self:log('UpdateValues', total > 0)
end

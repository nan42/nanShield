function aura_env:on_cleu(cleu, timestamp, event, ...)
    local spellName, spellId, auraName, value

    if self.playerGUID == select(6, ...) then
        self:log(cleu, timestamp, event, ...)
        if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" then
            spellName = select(11, ...)
            self:ApplyAura(spellName)
        elseif event == "SPELL_AURA_REMOVED" then
            spellName = select(11, ...)
            self:RemoveAura(spellName)
        elseif event == "SPELL_ABSORBED" then
            spellName = select(15, ...)
            value = select(17, ...) or 0
            self:ApplyDamage(spellName, value)
        end
    end
    return self.totalAbsorb > 0
end

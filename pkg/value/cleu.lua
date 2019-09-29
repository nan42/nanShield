function aura_env:on_cleu(triggerEvent, ...)
    local event, spellName, spellId, auraName, value
    local casterGUID = select(8, ...)

    if triggerEvent == 'OPTIONS' then
        self:log(triggerEvent, ...)
    elseif self.playerGUID == casterGUID then
        self:log(triggerEvent, ...)
        event = select(2, ...)
        if event == "SPELL_AURA_APPLIED" or event == "SPELL_AURA_REFRESH" then
            spellName = select(13, ...)
            self:ApplyAura(spellName)
        elseif event == "SPELL_AURA_REMOVED" then
            spellName = select(13, ...)
            self:RemoveAura(spellName)
        elseif event == "SPELL_ABSORBED" then
            if select(20, ...) then
                spellName = select(20, ...)
                value = select(22, ...) or 0
            else
                spellName = select(17, ...)
                value = select(19, ...) or 0
            end
            self:ApplyDamage(spellName, value)
        end
    elseif not casterGUID then
        self:log(triggerEvent, ...)
        self:ResetValues()
    end
end

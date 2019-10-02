function aura_env:on_tsu(allstates, event, ...)
    self:log(event, ...)
    local changed = false
    local state = allstates[1] or {
        show = true,
        changed = true,
        progressType = 'static',
        value = 0,
        total = 0,
        stacks = 0,
        additionalProgress = {
            {}, {}, {},
            {}, {}, {},
            {}, {}, {},
        }
    }
    allstates[1] = state

    if event == 'WA_NAN_SHIELD' and select(1, ...) then
        local value, school
        local minValue, totalAbsorb, minIdx = self:LowestAbsorb(...)
        minValue = ceil(minValue)
        totalAbsorb = ceil(totalAbsorb)

        if self.config.isHealthPct then
            totalAbsorb = UnitHealthMax("player")
        end

        changed = changed or state.total ~= totalAbsorb
        changed = changed or state.stacks ~= minValue
        changed = changed or state.show ~= (minValue > 0)
        state.show = minValue > 0
        state.total = totalAbsorb
        state.stacks = minValue
        state.school = self.schools[minIdx]

        for i, ap in ipairs(state.additionalProgress) do
            value = select(i + 1, ...)
            school = self.schools[i]
            self:log('Set', school, value)
            ap.direction = 'forward'
            changed = changed or ap.width ~= value
            ap.width = value
            ap.school = school
        end

        allstates[1].changed = changed
    end
    return changed
end

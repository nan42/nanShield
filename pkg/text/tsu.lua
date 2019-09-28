function aura_env:on_tsu(allstates, ...)
    -- self:log('TSU', self.config.segmentCount)
    local now = GetTime()
    local timestamp = self.timestamp or 0
    local currentAbsorb = self.currentAbsorb
    local state = allstates[1]

    if not state then
        state = {
            changed = true,
            show = false,
            progressType = "static",
            school = "All",
            value = 0,
            total = 0,
        }
        allstates[1] = state
    end

    if state.show ~= (currentAbsorb > 0) then
        state.show = currentAbsorb > 0
        state.changed = true
        state.value = currentAbsorb
        state.total = self.totalAbsorb
        state.school = self.currentSchool
        self.timestamp = now
    elseif state.value ~= currentAbsorb then
        state.changed = true
        state.value = currentAbsorb
        state.total = self.totalAbsorb
        state.school = self.currentSchool
        self.timestamp = now
    end

    return state.changed
end

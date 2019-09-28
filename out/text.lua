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
function aura_env:on_nan_shield(event, totalAbsorb, all, physical, magic, ...)
    self:log(event, totalAbsorb, ...)
    local minValue
    local minIdx
    local value

    for i = 1, select('#', ...) do
        value = select(i, ...)
        if value > 0 and value <= (minValue or value) then
            minIdx = i + 3
            minValue = value
        end
    end

    if minIdx then
        minValue = minValue + magic
    elseif magic > 0 then
        minValue = magic
        minIdx = 3
    end

    if physical > 0 and physical <= (minValue or physical) then
        minValue = physical
        minIdx = 2
    end

    if minIdx then
        minValue = minValue + all
    else
        minValue = all
        minIdx = 1
    end

    self.currentAbsorb = ceil(minValue)
    self.currentSchool = self.schools[minIdx]
    self.totalAbsorb = ceil(totalAbsorb)
    self:log('SetValues', self.currentSchool, self.currentAbsorb, self.totalAbsorb)
end
aura_env.logPalette = {
    "ff6e7dda",
    "ff21dfb9",
    "ffe3f57a",
    "ffed705a",
    "fff8a3e6",
}

function aura_env:log(...)
    if self.config and self.config.debugEnabled then
        local palette = self.logPalette
        local args = {
            self.cloneId and
            format("[%s:%s]", self.id, self.cloneId) or
            format("[%s]", self.id),
            ...
        }
        for i = 1, #args do
            args[i] = format(
                "|c%s%s|r",
                palette[1 + (i - 1) % #palette],
                tostring(args[i]))
        end
        print(unpack(args))
    end
end
aura_env.schools = {
    "All",
    "Physical",
    "Magic",
    "Holy",
    "Fire",
    "Nature",
    "Frost",
    "Shadow",
    "Arcane",
}
aura_env.schoolIds = { 127, 1, 126, 2, 4, 8, 16, 32, 64 }
aura_env.schoolIdx = {}
for idx, id in ipairs(aura_env.schoolIds) do
    aura_env.schoolIdx[id] = idx
end

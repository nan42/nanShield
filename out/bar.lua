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

        local progressOffset = 0
        for i, ap in ipairs(state.additionalProgress) do
            value = select(i + 1, ...)
            school = self.schools[i]
            self:log('Set', school, value)
            changed = changed or ap.width ~= value
            ap.min = progressOffset
            ap.max = progressOffset + value
            ap.school = school
            progressOffset = progressOffset + value
        end

        allstates[1].changed = changed
    end
    return changed
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
function aura_env:LowestAbsorb(totalAbsorb, all, physical, magic, ...)
    self:log('LowestAbsorb', all, physical, magic, ...)
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

    self:log('LowestAbsorbResult', minValue, totalAbsorb, minIdx)
    return minValue, totalAbsorb, minIdx
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

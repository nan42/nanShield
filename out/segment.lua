function aura_env:rotate()
    local segments = self.config.segmentCount
    local angle = self.config.curveAngle
    self.region:Rotate(180 + (angle / (segments - 1)) * (self.cloneId - (segments + 1) / 2))
end
function aura_env:on_tsu(allstates, ...)
    -- self:log('TSU', self.config.segmentCount)
    local now = GetTime()
    local timestamp = self.timestamp or 0
    local active = self.active or 0
    local changed

    for i = #allstates + 1, self.config.segmentCount do
        allstates[i] = {
            changed = true,
            show = false,
        }
    end

    if now - timestamp > 0.25 / self.config.segmentCount then
        self.timestamp = now
        if active < #allstates and allstates[active + 1].show then
            for i = #allstates, active + 1, -1 do
                if allstates[i].show then
                    allstates[i].show = false
                    allstates[i].changed = true
                    changed = true
                    break
                end
            end
        else
            for i = 1, active do
                if not allstates[i].show then
                    allstates[i].show = true
                    allstates[i].changed = true
                    changed = true
                    break
                end
            end
        end
    end
    return changed
end
function aura_env:on_nan_shield(event, totalAbsorb, ...)
    self:log(event, totalAbsorb, ...)
    local currentAbsorb = 0
    self.active = 0

    if event == 'OPTIONS' then
        self.active = self.config.segmentCount or 10
        self:log(event, self.active)
    else
        for i = 1, select("#", ...) do
            currentAbsorb = currentAbsorb + select(i, ...)
        end

        if currentAbsorb > 0 and totalAbsorb > 0 then
            self.active = ceil(currentAbsorb / totalAbsorb * self.config.segmentCount)
        end
    end
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

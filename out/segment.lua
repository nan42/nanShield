function aura_env:rotate()
    local segments = self.config.segmentCount
    local angle = self.config.curveAngle
    self.region:Rotate(180 + (angle / (segments - 1)) * (self.cloneId - (segments + 1) / 2))
end
function aura_env:on_tsu(allstates, event, totalAbsorb, currentAbsorb)
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

    if now - timestamp > 0.4 / self.config.segmentCount then
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
function aura_env:on_nan_shield(event, totalAbsorb, currentAbsorb)
    self.active = 0
    if currentAbsorb and totalAbsorb > 0 then
        self.active = ceil(currentAbsorb / totalAbsorb * self.config.segmentCount)
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

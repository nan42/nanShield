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

function aura_env:on_nan_shield(event, totalAbsorb, displayValue, ...)
    self:log(event, totalAbsorb, displayValue, ...)
    local currentAbsorb = 0
    local items = select("#", ...)
    self.active = 0

    for i = 1, items do
        currentAbsorb = currentAbsorb + select(i, ...)
    end

    if currentAbsorb and totalAbsorb > 0 then
        self.active = ceil(currentAbsorb / totalAbsorb * self.config.segmentCount)
    end
end

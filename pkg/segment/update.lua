function aura_env:on_nan_shield(event, totalAbsorb, currentAbsorb)
    self.active = 0
    if currentAbsorb and totalAbsorb > 0 then
        self.active = ceil(currentAbsorb / totalAbsorb * self.config.segmentCount)
    end
end

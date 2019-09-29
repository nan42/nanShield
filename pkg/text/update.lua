function aura_env:on_nan_shield(event, ...)
    self:log(event, ...)
    local minValue, totalAbsorb, minIdx = self:LowestAbsorb(...)
    self.currentAbsorb = ceil(minValue)
    self.currentSchool = self.schools[minIdx]
    self.totalAbsorb = ceil(totalAbsorb)
    self:log('SetValues', self.currentSchool, self.currentAbsorb, self.totalAbsorb)
end

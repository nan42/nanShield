function aura_env:rotate()
    local segments = self.config.segmentCount
    local angle = self.config.curveAngle
    self.region:Rotate(180 + (angle / (segments - 1)) * (self.cloneId - (segments + 1) / 2))
end

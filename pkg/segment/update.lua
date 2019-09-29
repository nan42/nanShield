aura_env.segmentSchool = {}

function aura_env:on_nan_shield(event, totalAbsorb, ...)
    self:log(event, totalAbsorb, ...)
    local currentAbsorb = 0
    local value
    local prevSegment = 0
    local segment
    self.active = 0

    if event == 'OPTIONS' then
        self.active = self.config.segmentCount or 10
        self:log(event, self.active)
    else
        for i = 1, select("#", ...) do
            value = select(i, ...)
            currentAbsorb = currentAbsorb + value
            segment = ceil(currentAbsorb / totalAbsorb * self.config.segmentCount)
            if value > 0 then
                for s = prevSegment + 1, segment do
                    self.segmentSchool[s] = self.schools[i]
                end
                prevSegment = segment
            end
        end

        if currentAbsorb > 0 and totalAbsorb > 0 then
            self.active = ceil(currentAbsorb / totalAbsorb * self.config.segmentCount)
        end
    end
end

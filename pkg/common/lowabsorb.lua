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

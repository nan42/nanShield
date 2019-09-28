function(newPositions, activeRegions)
    local offset = 9/64 -- target_indicator_glow texture center offset
    local distance = 18/64
    local angle, x, y, h, w, s, c, da
    local textIndex, textX, textY

    for i, r in ipairs(activeRegions) do
        if r.region.GetRotation then
            angle = r.region:GetRotation() - 180
            s = sin(angle)
            c = cos(angle)
            h = r.data.height
            w = r.data.width
            da = r.data.config.curveAngle / (r.data.config.segmentCount - 1)
            radius = 0.5 * w * distance / sin(da / 2)
            x = c * radius - s * w * offset - radius
            y = s * radius * h / w + c * h * offset
            newPositions[i] = {x, y}
            if not textY or y - h/2 < textY then
                textX = x
                textY = y - h/2
            end
        else
            textIndex = i
        end
    end
    if not textY then
        textX = 0
        textY = 0
    end
    if textIndex then
        newPositions[textIndex] = {textX, textY}
    end
end

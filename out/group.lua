function(newPositions, activeRegions)
    local offset = 9/64 -- target_indicator_glow texture center offset
    local distance = 18/64
    local angle, x, y, h, w, s, c, sb, cb, da
    local curveAngle, segmentCount, direction, base, direction

    for i, r in ipairs(activeRegions) do
        if r.region.GetRotation then
            direction = r.data.config.direction
            base = (r.data.config.rotationOffset + direction * 180)
            angle = r.region:GetRotation() - direction * 180
            h = r.data.height
            w = r.data.width
            curveAngle = r.data.config.curveAngle
            segmentCount = r.data.config.segmentCount
            s = sin(angle)
            c = cos(angle)
            sb = sin(base + (direction - 1) * 180)
            cb = cos(base + (direction - 1) * 180)
            da = curveAngle / (segmentCount - 1)
            radius = 0.5 * w * distance / sin(da / 2)
            x = c * radius + s * w * offset * (direction - 1.5) * 2 + radius * cb
            y = s * radius * h / w - c * h * offset * (direction - 1.5) * 2 + radius * h / w * sb
        else
            x = 0
            y = 0
        end

        if newPositions[i] then
            newPositions[i][1] = x
            newPositions[i][2] = y
        else
            newPositions[i] = {x, y}
        end
    end
end

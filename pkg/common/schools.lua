aura_env.schools = {
    "All",
    "Physical",
    "Magic",
    "Holy",
    "Fire",
    "Nature",
    "Frost",
    "Shadow",
    "Arcane",
}
aura_env.schoolIds = { 127, 1, 126, 2, 4, 8, 16, 32, 64 }
aura_env.schoolIdx = {}
for idx, id in ipairs(aura_env.schoolIds) do
    aura_env.schoolIdx[id] = idx
end

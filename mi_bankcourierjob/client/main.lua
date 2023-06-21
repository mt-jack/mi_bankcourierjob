-- local variables
local resourceName = GetCurrentResourceName()
local workblip = nil

local active = Config.teleport.active
local pointa = Config.teleport.pointa
local pointb = Config.teleport.pointb

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- work blip
local function workloc_blip()
    local coords = Config.blip.loc
    local sprite = Config.blip.sprite
    local color = Config.blip.color
    local scale = Config.blip.scale
    local name = Config.blip.name

    if workblip ~= nil then
        RemoveBlip(workblip)
        workblip = nil
    end
    
    Util.g6sblip(workblip, coords.x, coords.y, coords.z, sprite, color, scale, name)
end

RegisterNetEvent('g6s:taskfailed', function(ped, blip)
    Util.g6sremove_ped(ped)
    Util.g6sremove_blip(blip)
end)


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- teleport
local job_pointa = lib.points.new({
    coords = pointa,
    distance = 5,
    currentDistance = 2
})
function job_pointa:nearby()
    if active == false then
        return
    else
        if self.currentDistance < 1 then
            lib.showTextUI('[E] - Use Elevator')
        end
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
            lib.hideTextUI()
            lib.showContext('elevator_left')
        end
        if self.currentDistance > 1 then
            lib.hideTextUI()
        end
    end
end

local job_pointb = lib.points.new({
    coords = pointb,
    distance = 5,
    currentDistance = 2
})
function job_pointb:nearby()
    if active == false then
        return
    else
        if self.currentDistance < 2 then
            lib.showTextUI('[E] - Use Elevator')
        end
        if self.currentDistance < 2 and IsControlJustReleased(0, 38) then
            lib.hideTextUI()
            lib.showContext('elevator_left')
        end
        if self.currentDistance > 2 then
            lib.hideTextUI()
        end
    end
end

-- elevator context left
lib.registerContext({
    id = 'elevator_left',
    title = 'Job Elevator',
    options = {
        {   -- lux floor
            title = 'Point A',
            description = 'Teleport marker',
            icon = 'elevator',
            onSelect = function()
                    Util.g6steleport(cache.ped, pointa.x, pointa.y, pointa.z, pointa.w)
            end,
        },
        {   -- box floor
            title = 'Point B',
            description = 'Teleport marker',
            icon = 'elevator',
            onSelect = function()
                    Util.g6steleport(cache.ped, pointb.x, pointb.y, pointb.z, pointb.w)
            end,
        },
    }
})
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- main thread
Citizen.CreateThread(function()
    if resourceName == GetCurrentResourceName() then
        workloc_blip()
        Citizen.Wait(1000)
    end
end)

--------------------------------------------------------------
---------------CREDITS : mas_huntingwagon---------------------
-------------------------------------------------------------

local function GetNumComponentsInPed(ped)
    return Citizen.InvokeNative(0x90403E8107B60E81, ped, Citizen.ResultAsInteger())
end

local function GetMetaPedAssetGuids(ped, index)
    return Citizen.InvokeNative(0xA9C28516A6DC9D56, ped, index, Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt())
end

local function GetMetaPedAssetTint(ped, index)
    return Citizen.InvokeNative(0xE7998FEC53A33BBE, ped, index, Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt(), Citizen.PointerValueInt())
end

local function SetMetaPedTag(ped, drawable, albedo, normal, material, palette, tint0, tint1, tint2)
    return Citizen.InvokeNative(0xBC6DF00D7A4A6819, ped, drawable, albedo, normal, material, palette, tint0, tint1, tint2)
end

local function GetPedDamageCleanliness(ped)
    return Citizen.InvokeNative(0x88EFFED5FE8B0B4A, ped, Citizen.ResultAsInteger())
end

local function SetPedDamageCleanliness(ped, damageCleanliness)
    return Citizen.InvokeNative(0x7528720101A807A5, ped, damageCleanliness)
end

local function GetPedQuality(ped)
    return Citizen.InvokeNative(0x7BCC6087D130312A, ped)
end

local function SetPedQuality(ped, quality)
    return Citizen.InvokeNative(0xCE6B874286D640BB, ped, quality)
end

local function GetPedMetaOutfitHash(ped)
    return Citizen.InvokeNative(0x30569F348D126A5A, ped, Citizen.ResultAsInteger())
end

local function EquipMetaPedOutfit(ped, hash)
    return Citizen.InvokeNative(0x1902C4CFCC5BE57C, ped, hash)
end

local function UpdatePedVariation(ped)
    Citizen.InvokeNative(0xAAB86462966168CE, ped, true)                           -- UNKNOWN "Fixes outfit"- always paired with _UPDATE_PED_VARIATION
    Citizen.InvokeNative(0xCC8CA3E88256E58F, ped, false, true, true, true, false) -- _UPDATE_PED_VARIATION
end

local function IsEntityFullyLooted(entity)
    return Citizen.InvokeNative(0x8DE41E9902E85756, entity)
end

local function GetIsCarriablePelt(entity)
    return Citizen.InvokeNative(0x255B6DB4E3AD3C3E, entity)
end

local function GetCarriableFromEntity(entity)
    return Citizen.InvokeNative(0x31FEF6A20F00B963, entity)
end

local function GetFirstEntityPedIsCarrying(ped)
    return Citizen.InvokeNative(0xD806CD2A4F2C2996, ped)
end


local function SetBatchTarpHeight(vehicle, height, immediately)
    return Citizen.InvokeNative(0x31F343383F19C987, vehicle, height, immediately)
end

local function CalculateTarpHeight(totalItem, maxItems)
    if not totalItem then return 0.0 end
    local num = totalItem / maxItems

    local rounded_num = math.floor(num * 100 + 0.5) / 100

    return rounded_num
end

local function GetCarcassMetaTag(entity)
    local metatag = {}
    local numComponents = GetNumComponentsInPed(entity)
    for i = 0, numComponents - 1, 1 do
        local drawable, albedo, normal, material = GetMetaPedAssetGuids(entity, i)
        local palette, tint0, tint1, tint2 = GetMetaPedAssetTint(entity, i)
        metatag[i] = {
            drawable = drawable,
            albedo = albedo,
            normal = normal,
            material = material,
            palette = palette,
            tint0 = tint0,
            tint1 = tint1,
            tint2 = tint2
        }
        -- print(i, drawable, albedo, normal, material, palette, tint0, tint1, tint2)
    end
    return metatag
end

local function ApplyCarcasMetaTag(entity, metatag)
    if #metatag < 1 then return end
    -- TriggerEvent('table', metatag)
    for i = 0, #metatag, 1 do
        local data = metatag[i]
        SetMetaPedTag(entity, data.drawable, data.albedo, data.normal, data.material, data.palette, data.tint0, data.tint1, data.tint2)
        -- print(i, data.drawable, data.albedo, data.normal, data.material, data.palette, data.tint0, data.tint1, data.tint2)
    end
    UpdatePedVariation(entity)
end

-- local function IsItemStowable(model)
--     if not Config.WagonCargo?[model] then
--         print("Mistake? Screenshot This - nonstowable : " .. model)
--         return false
--     end
--     return true
-- end

local function TaskStatus(task)
    local count = 0
    repeat
        count += 1
        Wait(0)
    until (GetScriptTaskStatus(PlayerPedId(), task, true) == 8) or count > 100
end

local function getClosestVehicle(coords, maxDistance)
	local vehicles = GetGamePool('CVehicle')
	local closestVehicle, closestCoords
	maxDistance = maxDistance or 2.0

	for i = 1, #vehicles do
		local vehicle = vehicles[i]

        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = #(coords - vehicleCoords)

        if distance < maxDistance then
            maxDistance = distance
            closestVehicle = vehicle
            closestCoords = vehicleCoords
        end
	end

	return closestVehicle, closestCoords
end

-- Only Models Mentioned in LoadoutCapacity table will be able to store shit.
local function isValidVehicle(vehModel)
    for k,v in pairs(LoadoutCapacity) do
        if k == vehModel then
            return true
        end
    end
    return false
end

CreateThread(function()
    local CartPromptGroup = BccUtils.Prompt:SetupPromptGroup()
    local StowPrompt = CartPromptGroup:RegisterPrompt("Stow", Config.keys.stow, 1, 0, false, 'hold', {timedeventhash = "MEDIUM_TIMED_EVENT"})
    local TakePrompt = CartPromptGroup:RegisterPrompt("Check", Config.keys.checkStow, 1, 0, false, 'hold', {timedeventhash = "MEDIUM_TIMED_EVENT"})

    while true do
        local sleep = 1000

        local ply = PlayerPedId()
        local plyCoords = GetEntityCoords(ply)

        local closestVehicle, vehCoords = getClosestVehicle(plyCoords, 4.0)

        if closestVehicle and (not IsPedOnMount(ply) and not IsPedInAnyVehicle(ply, true)) then 
            local carriedEntity = GetFirstEntityPedIsCarrying(ply)
            local vehModel = GetEntityModel(closestVehicle)

            if isValidVehicle(vehModel) then
                local bootCoords = GetOffsetFromEntityInWorldCoords(closestVehicle, 0.0, -2.3, 0.5)

                local distance = #(plyCoords - bootCoords)

                local maxStorage = LoadoutCapacity[vehModel]
                local currentCap = Entity(closestVehicle).state.WagonInventoryItems

                local promptText = string.format("Wagon | ~COLOR_GREEN~%s / %s", currentCap and #currentCap or 0, maxStorage)

                if distance < 2.0 then
                    sleep = 1

                    CartPromptGroup:ShowGroup(promptText)
                    TakePrompt:TogglePrompt(true)
                    if carriedEntity and not IsPedAPlayer(carriedEntity) then
                        StowPrompt:TogglePrompt(true)
                    else
                        StowPrompt:TogglePrompt(false)
                    end

                    if StowPrompt:HasCompleted() then
                        StowItem(closestVehicle)
                    elseif TakePrompt:HasCompleted() then
                        if carriedEntity then 
                            VORPcore.NotifyLeft("Wagon","Please drop already carrying item.","blips","blip_ambient_wagon",4000,"color")
                        else
                            OpenStorageMenu(closestVehicle)
                        end
                    end
                end
            end
        end

        Wait(sleep)
    end
end)

function StowItem(veh)
    local ply = PlayerPedId()
    local wagon = veh

    local carriedEntity = GetFirstEntityPedIsCarrying(ply)
    local carriedModel = GetEntityModel(carriedEntity)

    if not carriedEntity or carriedModel == 0 then
        return VORPcore.NotifyLeft("Wagon","Nothing To Stow","blips","blip_ambient_wagon",4000,"color")
    end

    local isPelt = GetIsCarriablePelt(carriedEntity)
    local isHuman = IsPedHuman(carriedEntity)-- TODO:: Add Outfits of peds
    local height = 0
    local offset = GetOffsetFromEntityInWorldCoords(wagon, 0.0, -2.7, 0.0)

    TaskTurnPedToFaceEntity(ply, wagon, 100)
    TaskStatus(`SCRIPT_TASK_TURN_PED_TO_FACE_ENTITY`)

    local data = {
        model = carriedModel,
    }
    if isPelt then
        data.itemType = "PELT"
        data.peltquality = GetCarriableFromEntity(carriedEntity)
    else
        if isHuman then
            data.itemType = "CORPSE"
        else
            data.itemType = "ANIMAL"
        end
        data.metatag = GetCarcassMetaTag(carriedEntity)
        data.outfit = GetPedMetaOutfitHash(carriedEntity)
        data.skinned = IsEntityFullyLooted(carriedEntity) or false
        data.damage = GetPedDamageCleanliness(carriedEntity) or 0
        data.quality = GetPedQuality(carriedEntity) or 0
    end

    local isFull = VORPcore.Callback.TriggerAwait('bcc-wagons:stowWagonAction', NetworkGetNetworkIdFromEntity(wagon), GetEntityModel(wagon), "add", data)

    if isFull then return print('Wagon Full') end

    TaskGoStraightToCoord(ply, offset.x, offset.y, offset.z, 3.0, 1000, GetEntityHeading(wagon), 0)
    TaskStatus(`SCRIPT_TASK_GO_STRAIGHT_TO_COORD`)
    TaskPlaceCarriedEntityAtCoord(ply, carriedEntity, GetEntityCoords(wagon), 1.0, 5)
    TaskStatus(`SCRIPT_TASK_PLACE_CARRIED_ENTITY_AT_COORD`)

    DeleteEntity(carriedEntity)

    if GetEntityModel(wagon) == `huntercart01` then
        Citizen.InvokeNative(0x75F90E4051CC084C, wagon, `PG_MP005_HUNTINGWAGONTARP01`)
        local items = Entity(wagon).state.WagonInventoryItems
        height = CalculateTarpHeight(items and #items or 0, LoadoutCapacity[GetEntityModel(wagon)])

        
        SetBatchTarpHeight(wagon, height, false)
    end
end

function TakeItem(data, wagon)
    local ply = PlayerPedId()
    local coords = GetEntityCoords(ply)
    local cargo = 0
    if IsModelAPed(data.model) then
        cargo = CreatePed(data.model, coords.x, coords.y, coords.z, 0, true, true)
        SetEntityHealth(cargo, 0, ply)
        SetPedQuality(cargo, data.quality)
        SetPedDamageCleanliness(cargo, data.damage)
        if data.skinned then
            SetTimeout(1000, function()
                Citizen.InvokeNative(0x6BCF5F3D8FFE988D, cargo, true) --SetEntityFullyLooted
                ApplyCarcasMetaTag(cargo, data.metatag)
            end)
        else
            EquipMetaPedOutfit(cargo, data.outfit)
            UpdatePedVariation(cargo)
        end
    else
        cargo = CreateObject(data.model, coords.x, coords.y, coords.z, true, true, true, 0, 0)
        Citizen.InvokeNative(0x78B4567E18B54480, cargo)                                                                         -- MakeObjectCarriable
        Citizen.InvokeNative(0xF0B4F759F35CC7F5, cargo, Citizen.InvokeNative(0x34F008A7E48C496B, cargo, 0), ply, 7, 512)        -- TaskCarriable
        Citizen.InvokeNative(0x399657ED871B3A6C, cargo, data.peltquality)                                                       -- SetEntityCarcassType https://pastebin.com/C1WvQjCy
    end

    Citizen.InvokeNative(0x18FF3110CF47115D, cargo, 21, true) --SetEntityCarryingFlag
    TaskPickupCarriableEntity(ply, cargo)
    SetEntityVisible(cargo, false)
    FreezeEntityPosition(cargo, true)

    TaskStatus(`SCRIPT_TASK_PICKUP_CARRIABLE_ENTITY`)

    FreezeEntityPosition(cargo, false)
    SetEntityVisible(cargo, true)
    Citizen.InvokeNative(0x18FF3110CF47115D, cargo, 21, false) --SetEntityCarryingFlag

    if GetEntityModel(wagon) == `huntercart01` then
        Citizen.InvokeNative(0x75F90E4051CC084C, wagon, `PG_MP005_HUNTINGWAGONTARP01`)

        local items = Entity(wagon).state.WagonInventoryItems
        height = CalculateTarpHeight(items and #items or 0, LoadoutCapacity[GetEntityModel(wagon)])

        SetBatchTarpHeight(wagon, height, false)
    end
end

function OpenStorageMenu(veh)
    local StorageMenu = FeatherMenu:RegisterMenu('bcc-wagons:wagon:storagemenu', {
        top = '40%',
        left = '1%',
        ['720width'] = '400px',
        ['1080width'] = '500px',
        ['2kwidth'] = '600px',
        ['4kwidth'] = '800px',
        style = {
            
        },
        contentslot = {
            style = { --This style is what is currently making the content slot scoped and scrollable. If you delete this, it will make the content height dynamic to its inner content.
                ['height'] = '300px',
                ['min-height'] = '300px'
            }
        },
        draggable = true,
        --canclose = false
    }, {})

    local HomePage = StorageMenu:RegisterPage('home:page')
    HomePage:RegisterElement('header', {
        value = 'Storage',
        slot = "header",
        style = {
            ['color'] = "rgb(255,0,0)"
        }
    })
    HomePage:RegisterElement('line', {
        slot = "header",
        style = {}
    })

    local data = VORPcore.Callback.TriggerAwait('bcc-wagons:stowWagonAction', NetworkGetNetworkIdFromEntity(veh), GetEntityModel(veh), "query")

    if #data < 1 then
        HomePage:RegisterElement('textdisplay', {
            value = "\n \n \n \n Nothing Stored",
            style = {}
        })
    else
        for k,v in pairs(data) do
            HomePage:RegisterElement('button', {
                label = v.itemType.." ( "..v.added.." )",
                style = {},
            }, function()
                StorageMenu:Close({})
                local data = VORPcore.Callback.TriggerAwait('bcc-wagons:stowWagonAction', NetworkGetNetworkIdFromEntity(veh), nil, "remove", k)
                if data ~= nil then
                    TakeItem(data, veh)
                end
            end)
        end
    end

    StorageMenu:Open({startupPage = HomePage})
end
-- TODO
-- Remove print logs
print("LDA: LOADED")
local THRESHOLD = 0.2
AddPlayerPostInit(function(inst)
    inst:ListenForEvent("playeractivated", function()
        if inst ~= GLOBAL.ThePlayer then return end

        local warned = {}

        local function GetDurabilityPercent(item)
            local ii = item.replica.inventoryitem
            local classified = ii and ii.classified
            if classified and classified.percentused:value() ~= 255 then
                return classified.percentused:value() / 100
            end
            return nil
        end

        local function CheckItem(item)
            if item == nil then return end
            local percent = GetDurabilityPercent(item)
            print("LDA: CHECKING ITEM", item, "percent:", percent, "finiteuses:", item.replica.finiteuses, "armor:", item.replica.armor)

            if percent == nil then return end

            if percent <= THRESHOLD then
                if not warned[item] then
                    warned[item] = true
                    print("LDA: PLAYING SOUND")
                    GLOBAL.ThePlayer.SoundEmitter:PlaySound("dontstarve/common/horn_beefalo")
                end
            else
                warned[item] = nil
            end
        end

        local function WatchItem(item)
            print("LDA: WATCHING ITEM", item)
            if item == nil then return end
            warned[item] = GetDurabilityPercent(item) <= THRESHOLD
            inst:ListenForEvent("percentusedchange", function() CheckItem(item) end, item)
            CheckItem(item)
        end

        local function UnwatchItem(item)
            print("LDA: UNWATCH ITEM", item)
            if item == nil then return end
            inst:RemoveEventCallback("percentusedchange", nil, item)
            warned[item] = nil
        end

        print("LDA: PLAYER ACTIVATED")
        inst:ListenForEvent("equip", function(_, data) WatchItem(data.item) end)
        inst:ListenForEvent("unequip", function(_, data) UnwatchItem(data.item) end)

        -- Add for currently equipped items at startup
        local equipped_weapon = inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
        WatchItem(equipped_weapon)

        local equipped_armor = inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.BODY)
        WatchItem(equipped_armor)

        local equipped_head = inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HEAD)
        WatchItem(equipped_head)

    end)
end)
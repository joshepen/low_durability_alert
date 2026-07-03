local TOOL_THRESHOLD = GetModConfigData("Tool Threshold")
local ARMOR_THRESHOLD = GetModConfigData("Armor Threshold")
local HEADWEAR_THRESHOLD = GetModConfigData("Headwear Threshold")

AddPlayerPostInit(function(inst)
    inst:ListenForEvent("playeractivated", function()
        if inst ~= GLOBAL.ThePlayer then return end

        local warned = {}

        local function GetThresholdForItem(item)
            local equippable = item.replica.equippable
            local slot = equippable and equippable:EquipSlot()

            if slot == GLOBAL.EQUIPSLOTS.HEAD then
                return HEADWEAR_THRESHOLD
            elseif slot == GLOBAL.EQUIPSLOTS.BODY then
                return ARMOR_THRESHOLD
            else
                -- HANDS (weapons/tools) or fallback
                return TOOL_THRESHOLD
            end
        end


        local function GetDurabilityPercent(item)
            local ii = item.replica.inventoryitem
            local classified = ii and ii.classified
            if classified and classified.percentused:value() ~= 255 then
                return classified.percentused:value() / 100
            end
            return nil
        end

        local function CheckItem(item, threshold)
            if item == nil then return end
            local percent = GetDurabilityPercent(item)

            if percent == nil then return end

            if percent <= threshold then
                if not warned[item] then
                    warned[item] = true
                    GLOBAL.ThePlayer.SoundEmitter:PlaySound("dontstarve/common/horn_beefalo")
                end
            else
                warned[item] = nil
            end
        end

        local function WatchItem(item)
            local threshold = GetThresholdForItem(item)
            if item == nil  or threshold == 0 then return end
            warned[item] = GetDurabilityPercent(item) <= threshold
            inst:ListenForEvent("percentusedchange", function() CheckItem(item, threshold) end, item)
            CheckItem(item, threshold)
        end

        local function UnwatchItem(item)
            if item == nil then return end
            inst:RemoveEventCallback("percentusedchange", nil, item)
            warned[item] = nil
        end

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
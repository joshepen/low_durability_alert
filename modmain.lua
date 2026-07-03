AddPlayerPostInit(function(inst)
    inst:ListenForEvent("playeractivated", function()
        if inst == GLOBAL.ThePlayer then
            print("This is the local player!")
            if inst.replica.inventory then
                print("Has inventory component")
                local item = inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
                print("Got item:", item)
            else
                print("No inventory component yet")
            end
        end
    end)
end)
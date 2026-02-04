-- Commande côté serveur, uniquement pour les admins
RegisterCommand("debugzones", function(source)
    if source == 0 then return end -- Ignore console

    -- Vérifie si le joueur a la permission ACE
    if IsPlayerAceAllowed(source, "command.debugzones") then
        TriggerClientEvent("PNJReduce:toggleDebug", source)
    else
        TriggerClientEvent("chat:addMessage", source, {
            color = {255, 0, 0},
            args = {"Zones", "? Vous n'avez pas la permission"}
        })
    end
end, true) -- true = ACE required

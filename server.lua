local snowActive = false

-- Commande : /neige
-- Le 'true' à la fin signifie que la commande est RESTREINTE (Admin seulement)
RegisterCommand('neige', function(source, args, rawCommand)
    snowActive = not snowActive -- On inverse l'état (On <-> Off)
    
    -- On envoie l'info à tous les joueurs connectés
    TriggerClientEvent('fx_neige:updateSnow', -1, snowActive)
    
    if snowActive then
        print("^2[NEIGE] Activée par l'admin.^0")
    else
        print("^1[NEIGE] Désactivée par l'admin.^0")
    end
end, true)

-- Quand un joueur se connecte, on lui donne l'état actuel de la neige
RegisterNetEvent('playerJoining')
AddEventHandler('playerJoining', function()
    local src = source
    TriggerClientEvent('fx_neige:updateSnow', src, snowActive)
end)

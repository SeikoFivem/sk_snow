local isSnowEnabled = false

-- Réception de l'ordre du serveur
RegisterNetEvent('fx_neige:updateSnow')
AddEventHandler('fx_neige:updateSnow', function(status)
    isSnowEnabled = status
    if isSnowEnabled then
        -- On charge les sons de neige quand on l'active
        RequestScriptAudioBank("ICE_FOOTSTEPS", false)
        RequestScriptAudioBank("SNOW_FOOTSTEPS", false)
        
        -- Notification visuelle simple
        SetNotificationTextEntry("STRING")
        AddTextComponentString("❄️ ~b~Neige activée")
        DrawNotification(false, false)
    else
        -- Quand on désactive, on remet le moteur physique normal
        ForceSnowPass(false)
        SetWeatherTypeNowPersist('CLEAR')
        SetWeatherTypeNow('CLEAR')
        SetOverrideWeather('CLEAR')
        
        -- On décharge les sons pour libérer la mémoire
        ReleaseNamedScriptAudioBank("ICE_FOOTSTEPS")
        ReleaseNamedScriptAudioBank("SNOW_FOOTSTEPS")

        SetNotificationTextEntry("STRING")
        AddTextComponentString("☀️ ~y~Neige désactivée")
        DrawNotification(false, false)
    end
end)

-- La boucle principale
Citizen.CreateThread(function()
    while true do
        if isSnowEnabled then
            -- 1. Météo forcée
            SetWeatherTypeNowPersist('XMAS')
            SetWeatherTypeNow('XMAS')
            SetOverrideWeather('XMAS')
            
            -- 2. Physique du sol (Traces blanches)
            ForceSnowPass(true)

            -- 3. Traces de pas et pneus (Doit être spammé)
            SetForceVehicleTrails(true)
            SetForcePedFootstepsTracks(true)
            
            -- 4. Densité visuelle (CORRECTION ICI : Majuscule au 'S' de Setting)
            -- Si cette ligne pose encore problème sur ta version de FiveM, tu peux la supprimer, elle est optionnelle.
            if GetHashKey("SetVisualSettingFloat") ~= 0 then
                 SetVisualSettingFloat('snow.level', 1.0)
            end
            
            -- Pause courte pour maintenir les traces actives
            Citizen.Wait(100)
        else
            -- Si la neige est désactivée, on dort plus longtemps pour économiser les ressources
            Citizen.Wait(2000)
        end
    end
end)

-- Маски (фикс: уменьшены на 1)
local maskHalf = 122     -- полу спущена
local maskFull = 185     -- полностью надета
local maskTexture = 0    -- текстура

local currentState = 0 -- Текущее состояние маски

-- Функция анимации
local function playMaskAnim()
    RequestAnimDict("clothingtie")
    while not HasAnimDictLoaded("clothingtie") do
        Wait(100)
    end
    TaskPlayAnim(PlayerPedId(), "clothingtie", "try_tie_neutral_a", 8.0, -8, 1200, 48, 0, false, false, false)
    Wait(1300)
end

-- Вывод в чат при запуске
Citizen.CreateThread(function()
    Wait(3000)
    TriggerEvent("chat:addMessage", {
        args = { "^5[RollMask] ^7Нажми ^3K ^7чтобы использовать маску RP." }
    })
end)

-- Основной цикл прослушивания клавиши K (код: 311)
Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(0, 311) then -- Клавиша K
            local ped = PlayerPedId()

            if not DoesEntityExist(ped) or IsEntityDead(ped) then
                TriggerEvent("chat:addMessage", {
                    args = { "^1[RollMask] Ты должен быть живым игроком." }
                })
                return
            end

            local model = GetEntityModel(ped)
            if model ~= GetHashKey("mp_m_freemode_01") and model ~= GetHashKey("mp_f_freemode_01") then
                TriggerEvent("chat:addMessage", {
                    args = { "^1[RollMask] Работает только с фримод-персонажем." }
                })
                return
            end

            if currentState == 0 then
                playMaskAnim()
                SetPedComponentVariation(ped, 1, maskHalf, maskTexture, 2)
                currentState = 1
                TriggerEvent("chat:addMessage", {
                    args = { "^3[RollMask] Маска спущена под нос." }
                })
            elseif currentState == 1 then
                playMaskAnim()
                SetPedComponentVariation(ped, 1, maskFull, maskTexture, 2)
                currentState = 2
                TriggerEvent("chat:addMessage", {
                    args = { "^2[RollMask] Маска полностью надета." }
                })
            else
                playMaskAnim()
                SetPedComponentVariation(ped, 1, 0, 0, 2)
                currentState = 0
                TriggerEvent("chat:addMessage", {
                    args = { "^1[RollMask] Маска снята." }
                })
            end
        end
    end
end)







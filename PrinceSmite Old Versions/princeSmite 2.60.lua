_G.PRINCESMITEVERSION = 2.60
_G.PRINCESMITEUPDATE = true

--[[
    Thanks to Husky for jungle map position and eXtragoZ for selective mobs config
    
    Features
    - high precision, 0 delay (at least I hope)
    - lightweight as much as possible
    - lag free circle
    - customizable
    
    Changelog
    
    2.60
    - Fixed spell damage calculated on mobs for Cho'Gat R and Nunu Q
    
    2.50
    - Draw line on mobs healthbar checking also spell range (lux R is an example)
    - Improved the precision of line on ascendant xerath healthbar
    
    2.40
    - Complete rewrite of the spell/smite logic cast
    - Fixed damage calculation for warwick Q
    - Removed the outline drawing from big mobs
    
    2.30
    - Don't draw smite range if you don't have smite as summoner skill
    
    2.20
    - Fixed combo spell + smite (they should have a separate override check)
    - Fixed autosmite was not working at all because of the range, LOL
    
    2.10
    - Added supported spells: Volibear W, Warwick Q, Nasus Q, Olaf E, Twitch E
    - Removed purple debug line on mob healthbar
    
    2.00
    - Fixed spell damages (automatically calculated)
    
    1.90
    - Implemented packet cast even for skillshots
    - Safety check to don't send multiple cast packet
    
    1.80
    - Fixed lux cast ult (don't know how to cast skillshots with packets)
    
    1.70
    - Added support for Ascension map (only with spells since smite is disabled)
    - Added lux ult to supported spells
    - Removed inside jungle check to be sure to steal everything
    - Try to smite for last hit, not leaving mob at 1hp
    - Fixed error on smite when champion has not smite skill
    
    1.60
    - Fixed autosmite being always active even when turned off
    
    1.53
    - VIP users will now attempt both packet and timed way to autosmite to ensure a 100% hit chance
    
    1.52
    - Hotfix draw line on mob hpbar
    - Hotfix my dumbass typos writing -_-
    
    1.51
    - Hotfix "inside jungle" function for vips
    - Suggestion by germansk8ter to improve packet cast
    
    1.50
    - Using damage packet for vips to detect faster if smite is needed (all credits to germansk8ter)
    
    1.40
    - Added support for "butcher" from items to better casting autospells
    
    1.31
    - Hotfix Kayle Q damage calculation
    
    1.30
    - Added kayle Q in autospells
    
    1.20
    - This script is now auto-updated
    
	1.10
	- Hotfix: allow all champions with smite to use this script
	- Hotfix: vip packet cast was showing only for freeusers
	- Hotfix: autospell melee minimum range fixed
	- Hotfix: removed a debug string from the screen
	
    1.00
    - Added packet cast option for VIPs (default on)
    - Fixed all melee-attack spell-autocast ranges
    
    0.90
    - Nunu Q range fixed
    - Smite damage dynamically calculated to allow this script to work without smite, using a supported champ (nunu, chogat etc)
    - Added config options to selectively choose which spells you want to autocast to kill jungle mobs
    - Check smite cooldown before autocasting a spell, if smite is down then wait for a lasthit before casting spell
    - Smite must have the highest priority available, even above spells (because it's instant -> faster)
    
    0.80
    - Added support for some spells such as Nunu Q, ChoGat R, Elise Q
    - Fixed smite range (750 -> 700)
    - Updated rules to disable script when not needed
    
    0.70
    - Fixed vertical position of drawing line on Vilemaw and Baron
    - Draw smite only inside jungle and not dead
    
    0.60
    - Added requested PermaShow of status (active or not)
    - Fixed dragon/baron smite damage on hp bar
    
    0.50
    - Fixed autosmite in twisted treeline
    - Fixed autosmite near baron/dragon
    - Performance improvement: much less checks if we are inside or outside the jungle
    - Performance improvement: calculate less times the smite damage
    - Fixed an error spam
    
    0.40
    - Updated summoner skill name to be retro-compatible with servers < 4.15
    - Added script stats
    - Added this script to http://bol.b00st.eu/
    - Better camp names on twisted treeline
    
    0.30
    - Added update checker
    - Draw a line with smite damage on mobs hp bar
    - Selective configuration based on current map
    - More default quality to smite range
    
    0.20
    - Performance improvement: do nothing if you don't have smite
    - Performance improvement: do nothing if we are in a not supported map
    - Draw smite range only if my char is on screen
    - Added opacity config for smite range
    
    0.10
    - First working version of script
    
    ToDo
    - Updater switch from manual to automatic
    - Add an option to draw smite on every mob instead of only activated from config
--]]

--- BoL Script Status code --- 
local ScriptKey = "OBEAJDFHIEI"
local ScriptVersion = _G.PRINCESMITEVERSION
assert(load(Base64Decode("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"), nil, "bt", _ENV))() BolBoost( ScriptKey, ScriptVersion )
--- BoL Tracker code ---
assert(load(Base64Decode("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"), nil, "bt", _ENV))()

local ascension = false
if GetGame().map.index == 8 then ascension = true end

-- this script won't do anything if you don't have smite or a supported skill
if GetSpellData(SUMMONER_1).name:lower() ~= "summonersmite" and GetSpellData(SUMMONER_2).name:lower() ~= "summonersmite"
and myHero.charName ~= "Nunu" 
and myHero.charName ~= "Chogath" 
and myHero.charName ~= "Elise" 
and myHero.charName ~= "Lux" 
and myHero.charName ~= "Kayle"
and myHero.charName ~= "Volibear"
and myHero.charName ~= "Warwick"
and myHero.charName ~= "Nasus"
and myHero.charName ~= "Olaf"
and myHero.charName ~= "Twitch"
then return end

-- or if map is not supported
if GetGame().map.index ~= 1 and GetGame().map.index ~= 2 and GetGame().map.index ~= 10 and not ascension then return end

-- Nunu and Cho Gat are not working on ascension, remove them
if ascension and (myHero.charName == "Nunu" or myHero.charName == "Chogath") then return end

--[[ CONSTANTS ]]--
local SMITE_RANGE = 700
local ITEM_SPIRIT_STONE = 1080
local ITEM_SPIRIT_ELDER_LIZARD = 3209
local ITEM_SPIRIT_SPECTRAL_WRAITH = 3206
local selfName = GetCurrentEnv() and GetCurrentEnv().FILE_NAME or ""
local mapID = GetGame().map.index

local hitboxes = {['AscXerath'] = 80.0, ['Worm'] = 100.0, ['Dragon'] = 100.0, ['AncientGolem'] = 100.0, ['LizardElder'] = 65.0, ['GiantWolf'] = 65.0, ['GreatWraith'] = 80.0, ['Wraith'] = 50.0, ['Golem'] = 80.0, ['TT_Spiderboss'] = 200.0, ['TT_NGolem'] = 80.0, ['TT_NWraith'] = 50.0, ['TT_NWolf'] = 65.0,}

--[[ VARIABLES ]]--
local smiteSkill = nil
if     myHero:GetSpellData(SUMMONER_1).name:lower() == "summonersmite" then smiteSkill = SUMMONER_1
elseif myHero:GetSpellData(SUMMONER_2).name:lower() == "summonersmite" then smiteSkill = SUMMONER_2
end
local smiteDamage = 
    function(target) 
        if smiteSkill and myHero:CanUseSpell(smiteSkill) then 
            return myHero:GetSpellData(smiteSkill).currentCd > 0 and 0 
                or math.max(370 + (20 * myHero.level), 330 + (30 * myHero.level), 240 + (40 * myHero.level), 100 + (50 * myHero.level)) 
        else 
            return 0
        end
    end
local finalupdate = false
local jungleMobs = minionManager(MINION_JUNGLE, 60000)
local spellSlot = 0
local spellDamage = function(target) return 0 end
local casted_one = false
local casted_two = false
local smiteReady = false
local spellReady = false

--[[ USER CONFIGURATION MENU ]]--
PrinceSmite = scriptConfig("PrinceSmite ".._G.PRINCESMITEVERSION, "PrinceSmite")
PrinceSmite:addParam("on", "PrinceSmite active", SCRIPT_PARAM_INFO, true)
if VIP_USER then
    PrinceSmite:addParam("packetCast", "Use packet cast", SCRIPT_PARAM_ONOFF, true)
end
PrinceSmite:addParam("keyToggle", "Key to toggle on/off autosmite", SCRIPT_PARAM_ONKEYTOGGLE, true, GetKey("J"))
PrinceSmite:addParam("keyHold", "Key to hold to autosmite", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("K"))
PrinceSmite:addSubMenu("Draw smite on healthbar", "hpbar")
    PrinceSmite.hpbar:addParam("draw", "Draw smite line on mob Hp Bar", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.hpbar:addParam("colorSmite", "Smite damage signal color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255}) -- white
    PrinceSmite.hpbar:addParam("colorSpell", "Spell damage signal color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255}) -- white
    PrinceSmite.hpbar:addParam("colorOutline", "Killable outline color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255}) -- white
PrinceSmite:addSubMenu("Draw range", "range")
    PrinceSmite.range:addParam("draw", "Draw smite range", SCRIPT_PARAM_LIST, 2, {"never","when active","always"}) -- 1 = never, 2 = when active, 3 = always
    PrinceSmite.range:addParam("quality", "Quality of the circle", SCRIPT_PARAM_SLICE, 30, 3, 50, 0)
    PrinceSmite.range:addParam("width", "Width of the circle", SCRIPT_PARAM_SLICE, 2, 1, 10, 0)
    PrinceSmite.range:addParam("color", "Color of the circle", SCRIPT_PARAM_COLOR, {255, 255, 0, 255}) -- pink
    PrinceSmite.range:addParam("opacity", "Opacity of the circle", SCRIPT_PARAM_SLICE, 150, 0, 255, 0)
PrinceSmite:addSubMenu("AutoSmite Mobs", "mobs") --[[ credits to eXtragoZ for this section ]]--
if mapID == 1 or mapID == 2 then
    PrinceSmite.mobs:addParam("Worm", "Baron", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.mobs:addParam("Dragon", "Dragon", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.mobs:addParam("AncientGolem", "Ancient Golem", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.mobs:addParam("LizardElder", "Lizard Elder", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.mobs:addParam("GiantWolf", "Giant Wolf", SCRIPT_PARAM_ONOFF, false)
    PrinceSmite.mobs:addParam("GreatWraith", "Great Wraith", SCRIPT_PARAM_ONOFF, false)
    PrinceSmite.mobs:addParam("Wraith", "Wraith", SCRIPT_PARAM_ONOFF, false)
    PrinceSmite.mobs:addParam("Golem", "Golem", SCRIPT_PARAM_ONOFF, false)
elseif mapID == 10 then
    PrinceSmite.mobs:addParam("TT_Spiderboss", "Vilemaw", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.mobs:addParam("TT_NGolem", "Golem", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.mobs:addParam("TT_NWolf", "Wolf", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.mobs:addParam("TT_NWraith", "Wraith", SCRIPT_PARAM_ONOFF, true)
elseif mapID == 8 then
    PrinceSmite.mobs:addParam("AscXerath", "Xerath Ascendent", SCRIPT_PARAM_ONOFF, true)
end
PrinceSmite:addSubMenu("AutoCast Spells", "acs")
    PrinceSmite.acs:addParam("nunuQ", "Nunu Q", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.acs:addParam("choR", "ChoGat R", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.acs:addParam("eliseQ", "Elise Q", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.acs:addParam("kayleQ", "Kayle Q", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.acs:addParam("luxR", "Lux R", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.acs:addParam("voliW", "Volibear W", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.acs:addParam("wwQ", "Warwick Q", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.acs:addParam("nasusQ", "Nasus Q", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.acs:addParam("olafE", "Olaf E", SCRIPT_PARAM_ONOFF, true)
    PrinceSmite.acs:addParam("twitchE", "Twitch E", SCRIPT_PARAM_ONOFF, true)
PrinceSmite:permaShow("on")

--[[ CHARACTER DEPENDANT SPELLS ]]--
if myHero.charName == "Nunu" then
    spellSlot = _Q
    spellDamage = function(target) return 250 + (150 * myHero:GetSpellData(spellSlot).level) end
    --spellDamage = function(target) return getDmg("Q", target, myHero) end
    spellRange = 125
elseif myHero.charName == "Chogath" then
    spellSlot = _R
    spellDamage = function(target) return 1000 + (myHero.ap * 0.7) end
    --spellDamage = function(target) return getDmg("R", target, myHero) end
    spellRange = 175
elseif myHero.charName == "Elise" then
    spellSlot = _Q
    --spellDamage = function(target) return 5 + (35 * myHero:GetSpellData(spellSlot).level) + (target.health * (0.08 + (0.03 * math.floor(myHero.ap / 100)))) end
    spellDamage = function(target) return getDmg("Q", target, myHero) end
    spellRange = 475
elseif myHero.charName == "Kayle" then
    spellSlot = _Q
    --spellDamage = function(target) return 10 + (50 * myHero:GetSpellData(spellSlot).level) + (myHero.ap * 0.6) + myHero.addDamage end
    spellDamage = function(target) return getDmg("Q", target, myHero) end
    spellRange = 650
elseif myHero.charName == "Lux" then
    spellSlot = _R
    --spellDamage = function(target) return 200 + (myHero:GetSpellData(spellSlot).level * 100) + (myHero.ap * 0.75) end
    spellDamage = function(target) return getDmg("R", target, myHero) end
    spellRange = 3340
elseif myHero.charName == "Volibear" then
    spellSlot = _W
    spellDamage = function(target) 
                    if myHero:CanUseSpell(spellSlot) then
                        return getDmg("W", target, myHero) 
                    else 
                        return 0 
                    end 
                  end
    spellRange = 400
elseif myHero.charName == "Warwick" then
    spellSlot = _Q
    spellDamage = function(target) return 25 + (50 * myHero:GetSpellData(spellSlot).level) + myHero.ap end
    --spellDamage = function(target) return getDmg("Q", target, myHero) end
    spellRange = 400
elseif myHero.charName == "Nasus" then
    spellSlot = _Q
    spellDamage = function(target) return getDmg("Q", target, myHero) end
    spellRange = 100
elseif myHero.charName == "Olaf" then
    spellSlot = _E
    spellDamage = function(target) return getDmg("E", target, myHero) end
    spellRange = 325
elseif myHero.charName == "Twitch" then
    spellSlot = _E
    spellDamage = function(target) return getDmg("E", target, myHero) end
    spellRange = 1200
end

--[[ CUSTOM CALLBACKS ]]
AddGameOverCallback(function() finalupdate = true end)

--[[ BUILT-IN FUNCTIONS ]]
function OnLoad()
    -- check for updates
    if _G.PRINCESMITEUPDATE then
        local rand = math.random(1,10000)
        local updateVersion = 'https://raw.githubusercontent.com/redprince/BoL/master/princeSmite.version?rand='..rand
        local updateScript = 'https://raw.githubusercontent.com/redprince/BoL/master/princeSmite.lua?rand='..rand
        CheckUpdate(updateVersion, updateScript)
    end
    
    DelayAction(function() ascension = isAscension() end, 5)
    
    -- BoL Tracker callback
    BoLTracker("princeSmite", 7)
    
    -- Loaded message
    PrintChat("<font color=\"#F244E4\">[PrinceSmite ".._G.PRINCESMITEVERSION.."] Script loaded</font>")
end

function OnRecvPacket(p)
    if p.header == 101 and PrinceSmite.on then
        p.pos = 1
        local networkID = p:DecodeF()
        local mob = objManager:GetObjectByNetworkId(networkID)
        
        if mob.type == "obj_AI_Minion" and not mob.dead and PrinceSmite.mobs[mob.charName] then -- mob is enabled from config
            p.pos = 14
            local dmg = p:DecodeF()

            if dmg then 
                smiteReady = false
                spellReady = false
                
                -- check for smite ready
                if smiteSkill and myHero:GetSpellData(smiteSkill).currentCd < 0.01  and GetDistance(mob) < SMITE_RANGE then
                    smiteReady = true
                end
                
                -- check for spell ready
                if spellDamage(mob) > 0 and myHero:GetSpellData(spellSlot).currentCd < 0.01 and checkAutoCast() then
                    spellReady = true
                end
                
                -- case 1: most important, if smite is ready, and enemy is killable with smite, then smite it
                if smiteReady and mob.health - dmg < smiteDamage(mob) then
                    princeCastSmite(mob)
                end
                
                -- case 2: check for spell
                if spellReady and GetDistance(mob) < math.max(240,spellRange + hitboxes[mob.charName]) then
                    -- two subcases here
                    if smiteReady then -- if smite is ready then check for smite damage + spell damage
                        if mob.health - dmg < smiteDamage(mob) + adjustDmg(spellDamage(mob)) then
                            princeCastSpell(mob)
                        end
                    else -- if smite is not ready, check if we can last hit the mob with spell
                        if mob.health - dmg < adjustDmg(spellDamage(mob)) then
                            princeCastSpell(mob)
                        end
                    end
                end
            end
        end
    end
end

function OnTick()
    PrinceSmite.on = PrinceSmite.keyHold or PrinceSmite.keyToggle
    if PrinceSmite.on then
        -- update jungle mobs status
        jungleMobs:update()
        
        -- now search for valid mobs
        for i, mob in pairs(jungleMobs.objects) do
            -- mob must be alive and activated from our config
            if not mob.dead and PrinceSmite.mobs[mob.charName] then
                smiteReady = false
                spellReady = false
                
                -- check for smite ready
                if smiteSkill and myHero:GetSpellData(smiteSkill).currentCd < 0.01  and GetDistance(mob) < SMITE_RANGE then
                    smiteReady = true
                end
                
                -- check for spell ready
                if spellDamage(mob) > 0 and myHero:GetSpellData(spellSlot).currentCd < 0.01 and checkAutoCast() then
                    spellReady = true
                end
        
                -- case 1: most important, if smite is ready, and enemy is killable with smite, then smite it
                if smiteReady and mob.health < smiteDamage(mob) then
                    princeCastSmite(mob)
                end
                
                -- case 2: check for spell
                if spellReady and GetDistance(mob) < math.max(240,spellRange + hitboxes[mob.charName]) then
                    -- two subcases here
                    if smiteReady then -- if smite is ready then check for smite damage + spell damage
                        if mob.health < smiteDamage(mob) + adjustDmg(spellDamage(mob)) then
                            princeCastSpell(mob)
                        end
                    else -- if smite is not ready, check if we can last hit the mob with spell
                        if mob.health < adjustDmg(spellDamage(mob)) then
                            princeCastSpell(mob)
                        end
                    end
                end
            end
        end
    end
end

function OnDraw()
    -- return if game is over
    if finalupdate then return end
    
    -- draw smite range
    if PrinceSmite.range.draw == 3 -- draw always
    or (PrinceSmite.range.draw == 2 and (PrinceSmite.keyHold or PrinceSmite.keyToggle)) -- draw when active
    then
        if not myHero.dead and ReallyOnScreen(myHero.pos) and smiteSkill then -- only if my hero is alive and on screen
            DrawCircle3D(myHero.x, myHero.y, myHero.z, SMITE_RANGE, PrinceSmite.range.width, configToColor(PrinceSmite.range.color, PrinceSmite.range.opacity), PrinceSmite.range.quality)
        end
    end
    
    -- draw smite line
    if PrinceSmite.hpbar.draw then
        for i, mob in pairs(jungleMobs.objects) do
            if mob and PrinceSmite.mobs[mob.charName:gsub("_", "")] -- mob must be activated from our config
            and ((GetDistance(mob) < SMITE_RANGE * 2) or (GetDistance(mob) < spellRange)) -- check for distance, in most cases we will stop here consuming less cpu
            then 
                local barPos, distance, width = GetBarInfo(mob)
                local smiteDamageDistance = (smiteDamage(mob) / mob.maxHealth) * distance
                local comboDamage = smiteDamage(mob) + adjustDmg(spellDamage(mob))
                
                -- draw the line
                if smiteSkill then
                    DrawRectangleAL(barPos.x + smiteDamageDistance, barPos.y, 2, width, configToColor(PrinceSmite.hpbar.colorSmite))
                end
                
                -- draw extra line of the skill damage
                if spellDamage(mob) > 0 and spellSlot and myHero:CanUseSpell(spellSlot) then
                    local spellDamageDistance = ((adjustDmg(spellDamage(mob))) / mob.maxHealth) * distance
                    DrawRectangleAL(barPos.x + smiteDamageDistance + spellDamageDistance, barPos.y, 2, width, configToColor(PrinceSmite.hpbar.colorSpell))
                end
                
                -- draw the outline (only on small mobs, check this with width)
                if mob.health < comboDamage and distance == 62 then
                    OutLineBar(barPos.x, barPos.y, configToColor(PrinceSmite.hpbar.colorOutline))
                end
            end
        end
    end
end

--[[ CUSTOM FUNCTIONS ]]

-- check for bonus damage to monsters from items
function adjustDmg(spellDamage)
    local dmg = spellDamage
    if GetInventorySlotItem(ITEM_SPIRIT_STONE) then
        dmg = spellDamage + (spellDamage * 0.2)
    elseif GetInventorySlotItem(ITEM_SPIRIT_ELDER_LIZARD) then
        dmg = spellDamage + (spellDamage * 0.2)
    elseif GetInventorySlotItem(ITEM_SPIRIT_SPECTRAL_WRAITH) then
        dmg = spellDamage + (spellDamage * 0.3)
    end
    
    if ascension then
        local seconds = math.ceil(GetInGameTimer())
        -- ascendant buff reduce incoming damages
        if seconds > 1370 then dmg = dmg * 0.50
        elseif seconds > 1230 then dmg = dmg * 0.52
        elseif seconds > 1094 then dmg = dmg * 0.54
        elseif seconds > 968  then dmg = dmg * 0.56
        elseif seconds > 860  then dmg = dmg * 0.58
        elseif seconds > 760  then dmg = dmg * 0.60
        elseif seconds > 660  then dmg = dmg * 0.62
        elseif seconds > 566  then dmg = dmg * 0.64
        elseif seconds > 480  then dmg = dmg * 0.66
        elseif seconds > 390  then dmg = dmg * 0.68
        elseif seconds > 313  then dmg = dmg * 0.70
        elseif seconds > 240  then dmg = dmg * 0.72
        elseif seconds > 150  then dmg = dmg * 0.74
        elseif seconds > 120  then dmg = dmg * 0.76
        elseif seconds > 90   then dmg = dmg * 0.78
        else dmg = dmg * 0.80
        end
    end
    
    return dmg
end

-- packet cast
function PacketCastTargetSpell(spell, netID)
    Packet("S_CAST", {spellId = spell, targetNetworkId = netID}):send()
end

-- converts a color from config to a color in ARGB
function configToColor(color, opacityOverwrite)
    if opacityOverwrite then
        return ARGB(opacityOverwrite, color[2], color[3], color[4])
    else
        return ARGB(color[1], color[2], color[3], color[4])
    end
end

-- check if a position is inside the current screen
function ReallyOnScreen(pos)
    local scrPos = WorldToScreen(D3DXVECTOR3(pos.x, pos.y, pos.z))
    if OnScreen({ x = scrPos.x, y = scrPos.y }, { x = scrPos.x, y = scrPos.y }) then
        return true
    else
        return false
    end
end

-- check if we can autocast a spell
function checkAutoCast()
    if myHero.charName == "Nunu" and PrinceSmite.acs.nunuQ then
        return true
    elseif myHero.charName == "Chogath" and PrinceSmite.acs.choR then
        return true
    elseif myHero.charName == "Elise" and PrinceSmite.acs.eliseQ then
        return true
    elseif myHero.charName == "Kayle" and PrinceSmite.acs.kayleQ then
        return true
    elseif myHero.charName == "Lux" and PrinceSmite.acs.luxR then
        return true
    elseif myHero.charName == "Volibear" and PrinceSmite.acs.voliW then
        return true
    elseif myHero.charName == "Warwick" and PrinceSmite.acs.wwQ then
        return true
    elseif myHero.charName == "Nasus" and PrinceSmite.acs.nasusQ then
        return true
    elseif myHero.charName == "Olaf" and PrinceSmite.acs.olafE then
        return true
    elseif myHero.charName == "Twitch" and PrinceSmite.acs.twitchE then
        return true
    else
        return false
    end
end

-- general cast
function princeCastSmite(target)
    if not casted_one then
        if PrinceSmite.packetCast then
            Packet("S_CAST", {spellId = smiteSkill, targetNetworkId = target.networkID}):send()
        else
            MyCastSpell(smiteSkill, target)
        end
        casted_one = true
        DelayAction(function() casted_one = false end, 5)
    end
end

function princeCastSpell(target)
    if not casted_two then
        if PrinceSmite.packetCast then
            MyPacketCast(spellSlot, target)
        else
            MyCastSpell(spellSlot, target)
        end
        casted_two = true
        DelayAction(function() casted_two = false end, 5)
    end
end

-- Smart Cast
function MyCastSpell(spellslot, target)
    if myHero.charName == "Lux" then
        CastSpell(spellslot, target.pos.x, target.pos.z)
    else
        CastSpell(spellslot, target)
    end
end

function MyPacketCast(spellSlot, target)
    if myHero.charName == "Lux" then
        _CastSpellOverPacket(spellSlot, target.pos.x, target.pos.z, nil)
    else
        _CastSpellOverPacket(spellSlot, nil, nil, target)
    end
end

-- get hpbar info of a mob
function GetBarInfo(mob)
    local barPos = GetUnitHPBarPos(mob)
    local distance = 62
    local width = 4
    
    if mob.charName == "Dragon" then
        barPos.x = barPos.x - 63
        barPos.y = barPos.y - 7
        distance = 124
    elseif mob.charName == "Worm" then
        barPos.x = barPos.x - 63
        distance = 124
    elseif mob.charName == "TT_Spiderboss" then
        barPos.x = barPos.x - 63
        distance = 124
    elseif mob.charName == "AscXerath" then
        barPos.x = barPos.x - 82
        barPos.y = barPos.y + 2
        distance = 90
        width = 18
    else
        barPos.x = barPos.x - 32
    end
    
    return barPos, distance, width
end

-- from Honda7 proTracker script
function OutLineBar(x, y, color)
    DrawRectangleAL(x, y - 3, 64, 1, color) -- Top
    DrawRectangleAL(x, y + 2, 64, 1, color) -- Bottom
    DrawRectangleAL(x, y, 1, 5, color) -- Left
    DrawRectangleAL(x + 63, y, 1, 5, color) -- Right
end

-- from Honda7 proTracker script
function DrawRectangleAL(x, y, w, h, color)
    local Points = {}
    Points[1] = D3DXVECTOR2(math.floor(x), math.floor(y))
    Points[2] = D3DXVECTOR2(math.floor(x + w), math.floor(y))
    DrawLines2(Points, math.floor(h), color)
end

-- rounds a number
function round(num, dec)
    return string.format("%." .. (dec or 0) .. "f", num)
end

-- print that an update has been found
function printUpdated(sv)
    local updateMsg = "<font color=\"#FFD51C\">[PrinceSmite] New version found and downloaded. Please press F9 twice to update script. (</font>"
    updateMsg = updateMsg .. "<font color=\"#D13917\">".._G.PRINCESMITEVERSION.."</font>"
    updateMsg = updateMsg .. "<font color=\"#FFD51C\"> => </font>"
    updateMsg = updateMsg .. "<font color=\"#1DB31D\">"..sv.."</font>"
    updateMsg = updateMsg .. "<font color=\"#FFD51C\">)</font>"
    PrintChat(updateMsg)
end

-- check for updates and print in chat if found
function CheckUpdate(urlVersion, urlUpdate, file_exist, length)

    if not file_exist then
        if FileExist(LIB_PATH.."PrinceSmiteVersion") then os.remove(LIB_PATH.."PrinceSmiteVersion") end
        os.executePowerShellAsync([[$webClient = New-Object System.Net.WebClient;$webClient.DownloadFile(']]..urlVersion..[[', ']]..LIB_PATH.."PrinceSmiteVersion"..[[');exit;]])
        DelayAction(function() CheckUpdate(urlVersion, urlUpdate, true, 0) end)
    else
        if FileExist(LIB_PATH.."PrinceSmiteVersion") then
            FileOpen = io.open(LIB_PATH.."PrinceSmiteVersion", "r")
            FileContent = FileOpen:read("*a")
            FileOpen:close()
            if #FileContent > 0 and #FileContent == length then
                os.remove(LIB_PATH.."PrinceSmiteVersion")
                local server_version = tonumber(FileContent)
                if server_version ~= nil and _G.PRINCESMITEVERSION ~= nil then
                    if server_version > _G.PRINCESMITEVERSION then
                        os.executePowerShellAsync([[$webClient = New-Object System.Net.WebClient;$webClient.DownloadFile(']]..urlUpdate..[[', ']]..SCRIPT_PATH..selfName..[[');exit;]])
                        printUpdated(tostring(server_version))
                    end
                end
            else
                DelayAction(function() CheckUpdate(urlVersion, urlUpdate, true, #FileContent) end, 0.2)
            end
        else
            DelayAction(function() CheckUpdate(urlVersion, urlUpdate, true, 0) end)
        end
    end
end

-- check if we're playing ascension
function isAscension()
    for i = 1, objManager.maxObjects do
        local object = objManager:GetObject(i)
        if object ~= nil and object.valid and (object.name == "AscXerath" or object.name == "AscRelic") then
            return true
        end
    end
    return false
end

-- function found on Bilbao's Veigar script
function _CastSpellOverPacket(mySpell, PosX, PosZ, CUnit) --DONE
    local tnid, tposX, tposZ = nil, nil, nil
    local cansend = false
    if PosX ~= nil and PosZ ~= nil then
        tposX = PosX
        tposZ = PosZ
        cansend = true
    else
        if CUnit ~= nil then
            tposX = CUnit.x
            tposZ = CUnit.z
            tnid = CUnit.networkID
            cansend = true
        else            
            cansend = false
        end
    end
    if cansend then
        local CSOpacket = CLoLPacket(Packet.headers.S_CAST)
        CSOpacket.dwArg1 = 1
        CSOpacket.dwArg2 = 0
        CSOpacket:EncodeF(myHero.networkID)
        CSOpacket:Encode1(mySpell)
        CSOpacket:EncodeF(tposX)
        CSOpacket:EncodeF(tposZ)
        CSOpacket:EncodeF(tposX)
        CSOpacket:EncodeF(tposZ)
        if tnid~=nil then
            CSOpacket:EncodeF(tnid)
        else
            CSOpacket:EncodeF(0)
        end
        SendPacket(CSOpacket)
    end
end
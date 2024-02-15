local rubick = {}
rubick.spellkey = Menu.AddKeyOption({".拉比克全自动版", "拉比克"}, "1. 拉比克连招键", Enum.ButtonCode.KEY_SPACE)
rubick.swapkey = Menu.AddKeyOption({".拉比克全自动版", "拉比克"}, "2. 拉比克切换键", Enum.ButtonCode.KEY_X)
rubick.statekey = Menu.AddKeyOption({".拉比克全自动版", "拉比克"}, "3. 拉比克锁定键", Enum.ButtonCode.KEY_C)
rubick.system = Menu.AddOption({".瓜瓜拉比克全自动版", "拉比克"}, "4. 神经模式.", "")
rubick.cooldown = {}
rubick.last_spell = {}
rubick.target = {}
rubick.ignoredSpells = {}
rubick.time = 0
rubick.second_time = 0
rubick.hp = 0
rubick.teammate_hp = 0
rubick.lockState = false
rubick.teammate = nil
rubick.throw_pos = nil
rubick.shrapnel_pos = nil
rubick.OnSoundUnit = nil
rubick.OnSoundName = nil

function rubick.ignoredSpell(name)
    rubick.ignoredSpells[name] = true
end

rubick.ignoredSpell("ancient_apparition_chilling_touch")
rubick.ignoredSpell("antimage_blink")
rubick.ignoredSpell("axe_berserkers_call")
rubick.ignoredSpell("axe_culling_blade")
rubick.ignoredSpell("bane_nightmare")
rubick.ignoredSpell("batrider_sticky_napalm")
rubick.ignoredSpell("bloodseeker_bloodrage")
rubick.ignoredSpell("bounty_hunter_wind_walk")
rubick.ignoredSpell("beastmaster_call_of_the_wild")
rubick.ignoredSpell("beastmaster_call_of_the_wild_boar")
rubick.ignoredSpell("beastmaster_call_of_the_wild_hawk")
rubick.ignoredSpell("broodmother_spin_web")
rubick.ignoredSpell("centaur_double_edge")
rubick.ignoredSpell("centaur_return")
rubick.ignoredSpell("chaos_knight_reality_rift")
rubick.ignoredSpell("chen_holy_persuasion")
rubick.ignoredSpell("clinkz_wind_walk")
rubick.ignoredSpell("dazzle_shallow_grave")
rubick.ignoredSpell("doom_bringer_devour")
rubick.ignoredSpell("doom_bringer_infernal_blade")
rubick.ignoredSpell("drow_ranger_trueshot")
rubick.ignoredSpell("earth_spirit_boulder_smash")
rubick.ignoredSpell("earth_spirit_rolling_boulder")
rubick.ignoredSpell("earth_spirit_geomagnetic_grip")
rubick.ignoredSpell("enigma_demonic_conversion")
rubick.ignoredSpell("faceless_void_time_walk")
rubick.ignoredSpell("faceless_void_time_dilation")
rubick.ignoredSpell("faceless_void_chronosphere")
rubick.ignoredSpell("furion_sprout")
rubick.ignoredSpell("furion_teleportation")
rubick.ignoredSpell("furion_force_of_nature")
rubick.ignoredSpell("huskar_life_break")
rubick.ignoredSpell("invoker_ghost_walk")
rubick.ignoredSpell("invoker_invoke")
rubick.ignoredSpell("jakiro_liquid_fire")
rubick.ignoredSpell("kunkka_tidebringer")
rubick.ignoredSpell("kunkka_x_marks_the_spot")
rubick.ignoredSpell("legion_commander_duel")
rubick.ignoredSpell("lich_sinister_gaze")
rubick.ignoredSpell("lion_mana_drain")
rubick.ignoredSpell("lone_druid_spirit_bear")
rubick.ignoredSpell("lone_druid_spirit_link")
rubick.ignoredSpell("lone_druid_savage_roar")
rubick.ignoredSpell("lone_druid_true_form_battle_cry")
rubick.ignoredSpell("medusa_mana_shield")
rubick.ignoredSpell("meepo_poof")
rubick.ignoredSpell("magnataur_empower")
rubick.ignoredSpell("magnataur_skewer")
rubick.ignoredSpell("morphling_adaptive_strike_str")
rubick.ignoredSpell("morphling_morph_agi")
rubick.ignoredSpell("morphling_morph_str")
rubick.ignoredSpell("monkey_king_tree_dance")
rubick.ignoredSpell("nevermore_requiem")
rubick.ignoredSpell("pudge_rot")
rubick.ignoredSpell("phantom_assassin_stifling_dagger")
rubick.ignoredSpell("phantom_assassin_phantom_strike")
rubick.ignoredSpell("phantom_assassin_blur")
rubick.ignoredSpell("phantom_lancer_doppelwalk")
rubick.ignoredSpell("queenofpain_blink")
rubick.ignoredSpell("rattletrap_battery_assault")
rubick.ignoredSpell("rattletrap_power_cogs")
rubick.ignoredSpell("riki_blink_strike")
rubick.ignoredSpell("rubick_telekinesis")
rubick.ignoredSpell("rubick_fade_bolt")
rubick.ignoredSpell("sandking_sand_storm")
rubick.ignoredSpell("shredder_chakram_2")
rubick.ignoredSpell("sniper_take_aim")
rubick.ignoredSpell("spirit_breaker_charge_of_darkness")
rubick.ignoredSpell("spirit_breaker_empowering_haste")
rubick.ignoredSpell("spirit_breaker_nether_strike")
rubick.ignoredSpell("techies_land_mines")
rubick.ignoredSpell("techies_stasis_trap")
rubick.ignoredSpell("techies_suicide")
rubick.ignoredSpell("techies_remote_mines")
rubick.ignoredSpell("terrorblade_conjure_image")
rubick.ignoredSpell("tiny_craggy_exterior")
rubick.ignoredSpell("tiny_toss_tree")
rubick.ignoredSpell("treant_natures_guise")
rubick.ignoredSpell("troll_warlord_battle_trance")
rubick.ignoredSpell("tusk_walrus_kick")
rubick.ignoredSpell("ursa_earthshock")
rubick.ignoredSpell("ursa_overpower")
rubick.ignoredSpell("weaver_shukuchi")
rubick.ignoredSpell("wisp_tether")
rubick.ignoredSpell("witch_doctor_voodoo_restoration")

function rubick.OnUpdate()
    local me = Heroes.GetLocal()
    if me and NPC.GetUnitName(me) ~= "npc_dota_hero_rubick" then return end

    if Menu.IsKeyDownOnce(rubick.statekey) and not Input.IsInputCaptured() then
        rubick.lockState = not rubick.lockState
        if rubick.lockState then
            rubick.lockState = true
            Chat.Print("DOTAChannelType_GameEvents", "Lock!")
        else
            Chat.Print("DOTAChannelType_GameEvents", "Unlock!")
        end
    end

    local summontable = {}
    for i = 1, NPCs.Count() do
        local npc = NPCs.Get(i)
        if npc and npc ~= me and Entity.IsSameTeam(me, npc) and Entity.IsAlive(npc) and (Entity.GetOwner(me) == Entity.GetOwner(npc) or Entity.OwnedBy(npc, me)) then
            table.insert(summontable, npc)
        end
    end

    local telekinesis, fadebolt, spell, spell2, spellsteal = NPC.GetAbilityByIndex(me, 0), NPC.GetAbilityByIndex(me, 1), NPC.GetAbilityByIndex(me, 3), NPC.GetAbilityByIndex(me, 4), NPC.GetAbilityByIndex(me, 5)
    local sheep, eb, blink, lens, forward = NPC.GetItem(me, "item_sheepstick"), NPC.GetItem(me, "item_ethereal_blade"), NPC.GetItem(me, "item_blink"), NPC.GetItem(me, "item_aether_lens"), NPC.GetItem(me, "item_force_staff") or NPC.GetItem(me, "item_hurricane_pike")
    local enemies, throw = {}, false

    local bonuses_range = 0
    if NPC.GetAbility(me, "special_bonus_cast_range_125") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_cast_range_125")) > 0 then
        bonuses_range = bonuses_range + 125
    elseif lens then
        bonuses_range = bonuses_range + 250
    end
    if NPC.GetAbility(me, "special_bonus_unique_rubick") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_rubick")) > 0 then
        throw_range = 837.5
    else
        throw_range = 537.5
    end
    if NPC.GetAbility(me, "special_bonus_unique_rubick_5") and Ability.GetLevel(NPC.GetAbility(me, "special_bonus_unique_rubick_5")) > 0 then
        amp = 1.5
    else
        amp = 1
    end

    local near_mouse = Input.GetNearestHeroToCursor(Entity.GetTeamNum(me), Enum.TeamType.TEAM_ENEMY), nil, nil, {}
    if not target and near_mouse and NPC.IsPositionInRange(near_mouse, Input.GetWorldCursorPos(), 250) then
        target = near_mouse
    elseif target and (not Entity.IsAlive(me) or not Entity.IsAlive(target) or Entity.IsDormant(target)) then
        target = nil
    end

    local spell_range = 0

    if spell then
        local distance = Ability.GetCastRange(spell)
        if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then
            if Ability.GetName(spell) == "sandking_burrowstrike" then
                distance = Ability.GetLevelSpecialValueFor(spell, "cast_range_scepter")
            end
        end
        local isbad, isdiable, isevade, IsSupport, isblinking = false, false, false, false, false
        for key, lib in pairs(
            {
                {name = "ancient_apparition_ice_blast", radius = 99999},
                {name = "ancient_apparition_ice_blast_release", radius = 99999},
                --{name = "antimage_counterspell", radius = 1000, type = "evade"},
                {name = "arc_warden_tempest_double", radius = 1150},
                {name = "abyssal_underlord_pit_of_malice", type = "disable"},
                {name = "alchemist_unstable_concoction", type = "disable"},
                {name = "alchemist_unstable_concoction_throw", type = "disable"},
                {name = "alchemist_chemical_rage", radius = 1000, type = "evade"},
                {name = "alchemist_unstable_concoction", type = "disable"},
                {name = "ancient_apparition_cold_feet", type = "disable"},
                {name = "axe_berserkers_call", radius = 300, type = "bad"},
                {name = "axe_culling_blade", type = "bad"},
                {name = "bane_fiends_grip", type = "disable"},
                {name = "batrider_firefly", radius = 550},
                {name = "batrider_flaming_lasso", type = "disable"},
                {name = "beastmaster_primal_roar", type = "disable"},
                {name = "brewmaster_thunder_clap", radius = 400},
                {name = "brewmaster_drunken_brawler", radius = 550},
                {name = "brewmaster_primal_split", radius = 550},
                {name = "bristleback_quill_spray", radius = 650},
                {name = "bounty_hunter_wind_walk", radius = 2000},
                {name = "bloodseeker_bloodrage", radius = 99999},
                {name = "broodmother_insatiable_hunger", radius = 550},
                {name = "centaur_hoof_stomp", type = "disable", radius = 315},
                {name = "centaur_stampede", radius = 99999},
                {name = "chaos_knight_chaos_bolt", type = "disable"},
                {name = "chaos_knight_phantasm", radius = 550},
                {name = "chen_divine_favor", radius = 99999, type = "support"},
                {name = "chen_hand_of_god", radius = 99999, type = "support"},
                {name = "clinkz_strafe", radius = 550, type = "evade"},
                {name = "clinkz_wind_walk", radius = 2000},
                {name = "crystal_maiden_freezing_field", radius = 600, blink = "use"},
                {name = "dazzle_shadow_wave", type = "support"},
                {name = "dark_willow_shadow_realm", radius = 600, type = "evade"},
                {name = "dark_willow_bedlam", radius = 300},
                {name = "death_prophet_exorcism", radius = 1000},
                {name = "doom_bringer_scorched_earth", radius = 600},
                {name = "dragon_knight_dragon_tail", type = "disable"},
                {name = "dragon_knight_elder_dragon_form", radius = 550},
                {name = "drow_ranger_trueshot", radius = 99999},
                {name = "ember_spirit_searing_chains", radius = 400},
                {name = "ember_spirit_flame_guard", radius = 400},
                {name = "earthshaker_fissure", type = "disable"},
                {name = "earthshaker_enchant_totem", radius = 550},
                {name = "earthshaker_echo_slam", radius = 600, blink = "use"},
                {name = "enchantress_natures_attendants", radius = 900, type = "support"},
                {name = "enigma_malefice", type = "disable"},
                {name = "enigma_black_hole", type = "disable", blink = "use"},
                {name = "faceless_void_chronosphere", radius = 425},
                {name = "furion_wrath_of_nature", radius = 99999},
                {name = "gyrocopter_rocket_barrage", radius = 400},
                {name = "gyrocopter_flak_cannon", radius = 1250},
                {name = "huskar_inner_fire", radius = 500},
                {name = "invoker_forge_spirit", radius = 1200},
                {name = "invoker_ice_wall", radius = 700}, -- unfinished?
                {name = "invoker_sun_strike", radius = 99999},
                {name = "juggernaut_blade_fury", radius = 250, type = "evade"},
                {name = "juggernaut_healing_ward", radius = 99999, type = "support"},
                {name = "invoker_cold_snap", type = "disable"},
                {name = "jakiro_ice_path", type = "disable"},
                {name = "keeper_of_the_light_will_o_wisp", type = "disable"},
                {name = "legion_commander_duel", type = "bad"},
                {name = "leshrac_split_earth", type = "disable"},
                {name = "leshrac_diabolic_edict", radius = 500},
                {name = "leshrac_pulse_nova", radius = 99999},
                {name = "lich_sinister_gaze", type = "disable"},
                {name = "life_stealer_rage", radius = 550, type = "evade"},
                {name = "lina_light_strike_array", type = "disable"},
                {name = "lion_impale", type = "disable"},
                {name = "lion_voodoo", type = "disable"},
                {name = "lone_druid_spirit_bear", radius = 99999},
                {name = "lone_druid_spirit_link", radius = 550},
                {name = "lone_druid_savage_roar", radius = 325},
                {name = "lone_druid_true_form_battle_cry", radius = 550},
                {name = "luna_lucent_beam", type = "disable"},
                {name = "luna_eclipse", radius = 675},
                {name = "lycan_summon_wolves", radius = 1000},
                {name = "lycan_howl", radius = 3000},
                {name = "lycan_shapeshift", radius = 550},
                {name = "magnataur_reverse_polarity", radius = 410, type = "disable", blink = "use"},
                {name = "mars_spear", radius = 900, type = "disable"},
                {name = "mars_gods_rebuke", radius = 450},
                {name = "medusa_stone_gaze", radius = 1000},
                {name = "meepo_poof", radius = 375, type = "bad"},
                {name = "mirana_starfall", radius = 650},
                {name = "mirana_arrow", type = "disable"},
                {name = "mirana_invis", radius = 99999},
                {name = "monkey_king_boundless_strike", type = "disable"},
                {name = "monkey_king_mischief", radius = 550, type = "evade"},
                {name = "naga_siren_mirror_image", radius = 550},
                {name = "nevermore_shadowraze1", radius = 450},
                {name = "nevermore_shadowraze2", radius = 700},
                {name = "nevermore_shadowraze3", radius = 950},
                --{name = "naga_siren_song_of_the_siren", radius = 1400}, -- unfinished
                {name = "necrolyte_death_pulse", radius = 475},
                {name = "necrolyte_sadist", radius = 750}, -- unfinished
                {name = "night_stalker_crippling_fear", radius = 375},
                {name = "nyx_assassin_impale", type = "disable"},
                {name = "nyx_assassin_spiked_carapace", radius = 550}, -- unfinished
                {name = "nyx_assassin_vendetta", radius = 99999},
                {name = "obsidian_destroyer_equilibrium", radius = 550},
                {name = "ogre_magi_fireblast", type = "disable"},
                {name = "ogre_magi_unrefined_fireblast", type = "disable"},
                {name = "omniknight_purification", type = "support"},
                {name = "omniknight_guardian_angel", radius = 1200},
                {name = "pangolier_swashbuckle", radius = 2000},
                {name = "pangolier_shield_crash", radius = 500},
                {name = "pangolier_gyroshell", radius = 550},
                --{name = "pangolier_gyroshell_stop", radius = 550},
                {name = "phoenix_icarus_dive", radius = 1400},
                {name = "phoenix_supernova", radius = 1300,  type = "support"}, -- unfinished
                {name = "puck_waning_rift", radius = 800},
                {name = "pugna_nether_ward", radius = 1600},
                --{name = "puck_phase_shift", radius = 900},
                {name = "pudge_rot", radius = 250, type = "bad"},
                {name = "puck_phase_shift", type = "evade"}, -- unfinished
                {name = "queenofpain_scream_of_pain", radius = 475},
                {name = "rattletrap_battery_assault", radius = 275},
                {name = "rattletrap_rocket_flare", radius = 99999},
                {name = "razor_plasma_field", radius = 700},
                {name = "razor_eye_of_the_storm", radius = 550},
                {name = "riki_tricks_of_the_trade", radius = 450},
                {name = "sandking_burrowstrike", type = "disable"},
                {name = "sandking_sand_storm", radius = 650},
                {name = "sandking_epicenter", radius = 550, blink = "use"}, -- unfinished
                {name = "shadow_shaman_ether_shock", type = "disable"},
                {name = "shadow_shaman_voodoo", type = "disable"},
                {name = "shredder_whirling_death", radius = 300},
                {name = "shredder_return_chakram", radius = 99999},
                {name = "shredder_return_chakram_2", radius = 99999},
                {name = "silencer_global_silence", radius = 99999}, -- unfinished
                {name = "skeleton_king_hellfire_blast", type = "disable"},
                {name = "slardar_slithereen_crush", radius = 350, type = "disable"},
                {name = "slardar_sprint", radius = 320},
                {name = "slark_dark_pact", radius = 325},
                {name = "slark_pounce", radius = 700},
                {name = "slark_shadow_dance", radius = 550},
                {name = "sniper_take_aim", radius = 99999},
                {name = "spectre_haunt", radius = 99999},
                {name = "spirit_breaker_bulldoze", radius = 1500},
                {name = "storm_spirit_static_remnant", radius = 275, type = "bad"},
                {name = "storm_spirit_electric_vortex", type = "disable"},
                {name = "sven_storm_bolt", type = "disable"},
                {name = "sven_warcry", radius = 550},
                {name = "sven_gods_strength", radius = 550},
                {name = "templar_assassin_refraction", radius = 550},
                {name = "templar_assassin_meld", radius = 550},
                {name = "terrorblade_reflection", radius = 900},
                {name = "terrorblade_conjure_image", radius = 550},
                {name = "terrorblade_metamorphosis", radius = 550},
                {name = "tidehunter_anchor_smash", radius = 375},
                {name = "tidehunter_ravage", radius = 1250, type = "disable", blink = "use"},
                {name = "tinker_heat_seeking_missile", radius = 2500},
                {name = "tinker_rearm", radius = 900, blink = "use"},
                {name = "tiny_avalanche", type = "disable"},
                {name = "treant_living_armor", radius = 99999, type = "support"},
                {name = "treant_overgrowth", radius = 800},
                {name = "troll_warlord_whirling_axes_melee", radius = 450},
                {name = "tusk_snowball", type = "disable"},
                {name = "tusk_tag_team", radius = 350},
                {name = "tusk_walrus_punch", radius = 550},
                {name = "undying_flesh_golem", radius = 550},
                {name = "ursa_earthshock", radius = 385},
                {name = "ursa_overpower", radius = 550},
                {name = "ursa_enrage", radius = 550},
                {name = "venomancer_poison_nova", radius = 830},
                {name = "vengefulspirit_magic_missile", type = "disable"},
                {name = "visage_summon_familiars", radius = 99999},
                {name = "weaver_time_lapse", radius = 1200, type = "support"},
                {name = "winter_wyvern_cold_embrace", type = "support"},
                {name = "windrunner_shackleshot", type = "disable"},
                {name = "windrunner_windrun", radius = 1000},
                {name = "wisp_spirits", radius = 700},
                {name = "wisp_overcharge", radius = 550},
                {name = "witch_doctor_paralyzing_cask", type = "disable"},
                {name = "zuus_cloud", radius = 99999},
                {name = "zuus_thundergods_wrath", radius = 99999},
                {name = "void_spirit_aether_remnant", radius = 1450, type = "disable"},
                {name = "void_spirit_resonant_pulse", radius = 485},
                {name = "void_spirit_dissimilate", radius = 750},
                {name = "void_spirit_astral_step", radius = 1100},
                {name = "snapfire_firesnap_cookie", radius = 1300, type = "disable"},
                {name = "snapfire_mortimer_kisses", radius = 3000}
            }
        ) do
            if lib then
                if Ability.GetName(spell) == lib.name then
                    if lib.type == "bad" then isbad = true else isbad = false end
                    if lib.type == "evade" then end
                    if lib.type == "disable" then isdiable = true else isdiable = false end
                    if lib.radius ~= nil then distance = lib.radius - 75 end
                    if lib.blink == "use" then
                        if Ability.GetName(spell) ~= "sandking_epicenter" then
                            if blink and Ability.IsReady(blink) and Ability.IsReady(spell) then
                                isblinking = true
                            else
                                isblinking = false
                            end
                        else
                            if blink and Ability.IsReady(blink) then
                                if Ability.IsReady(spell) then
                                    distance = 1199
                                else
                                    distance = 550
                                end
                                if NPC.HasModifier(me, "modifier_sand_king_epicenter") then
                                    isblinking = true
                                else
                                    isblinking = false
                                end
                            end
                        end

                    end
                    if lib.type == "support" or Ability.GetName(spell) == "snapfire_firesnap_cookie" then
                        IsSupport = true
                        if not rubick.teammate then
                            for key, friend in ipairs(Entity.GetHeroesInRadius(me, 1000 ,Enum.TeamType.TEAM_FRIEND)) do
                                if friend and Entity.IsAlive(friend) then
                                    rubick.teammate = friend
                                end
                            end
                        else
                            rubick.teammate = nil
                        end
                    else
                        IsSupport = false
                    end
                end
                if rubick.last_spell[id] and Ability.GetName(rubick.last_spell[id]) == lib.name then
                    if lib.radius ~= nil then spell_range = lib.radius end
                end
            end
        end

        for enemyindex = 1, Heroes.Count() do
            local enemy = Heroes.Get(enemyindex)
            if enemy and not Entity.IsSameTeam(me, enemy) then
                id = Hero.GetPlayerID(enemy)
                for i = 0, 24 do
                    local enemyspell = NPC.GetAbilityByIndex(enemy, i)
                    if enemyspell and not Ability.IsHidden(enemyspell) and not Ability.IsAttributes(enemyspell) and not Ability.IsPassive(enemyspell) and Entity.IsAbility(enemyspell) then
                        if Ability.SecondsSinceLastUse(enemyspell) > 0 and Ability.SecondsSinceLastUse(enemyspell) < 0.1 or Ability.GetToggleState(enemyspell) or rubick.OnSoundUnit == NPC.GetUnitName(enemy) and rubick.OnSoundName == Ability.GetName(enemyspell) then
                            rubick.target[id] = enemy
                            rubick.last_spell[id] = enemyspell
                        end
                    end
                end
                if rubick.target[id] and Entity.IsDormant(rubick.target[id]) then
                    if rubick.OnSoundUnit and rubick.OnSoundName then
                        if rubick.OnSoundUnit == NPC.GetUnitName(rubick.target[id]) and rubick.OnSoundName == Ability.GetName(rubick.last_spell[id]) then
                            rubick.OnSoundUnit = nil
                            rubick.OnSoundName = nil
                        end
                    end
                    rubick.last_spell[id] = nil
                    rubick.target[id] = nil
                end
                local nervous_system = false
                local stealrange = Ability.GetCastRange(spellsteal) + bonuses_range
                if rubick.last_spell[id] and rubick.target[id] then
                    if spell_range == 0 then
                        spell_range = Ability.GetCastRange(rubick.last_spell[id])
                    end
                    --Console.Print(Ability.GetName(rubick.last_spell[id]) .. ", " .. spell_range)
                    if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then
                        stealrange = stealrange + 390
                        if spell_range < 500 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(rubick.target[id])):Length2D() > spell_range + 75 and not Ability.IsUltimate(rubick.last_spell[id]) then
                            nervous_system = false
                        else
                            nervous_system = true
                        end
                    else
                        if Menu.IsEnabled(rubick.system) then
                            if rubick.last_spell[id] and
                                (Ability.GetDispellableType(rubick.last_spell[id]) == 1 or
                                Ability.IsUltimate(rubick.last_spell[id]) or
                                Ability.GetLevel(rubick.last_spell[id]) == 4 or
                                Ability.GetName(rubick.last_spell[id]) == "invoker_cold_snap" or
                                Ability.GetName(rubick.last_spell[id]) == "invoker_emp" or
                                Ability.GetName(rubick.last_spell[id]) == "invoker_chaos_meteor" or
                                Ability.GetName(rubick.last_spell[id]) == "invoker_deafening_blast")
                            then
                                if spell_range < 500 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(rubick.target[id])):Length2D() > spell_range + 75 and not Ability.IsUltimate(rubick.last_spell[id]) then
                                    nervous_system = false
                                else
                                    nervous_system = true
                                end
                            end
                        else
                            nervous_system = true
                        end
                    end

                    if nervous_system then
                        if Entity.IsAlive(me) and not NPC.IsChannellingAbility(me) and not NPC.HasState(me, Enum.ModifierState.MODIFIER_STATE_INVISIBLE) and not NPC.HasModifier(me, "modifier_phoenix_sun_ray") then
                            if not rubick.ignoredSpells[Ability.GetName(rubick.last_spell[id])] and spellsteal and Ability.IsReady(spellsteal) and NPC.IsEntityInRange(me, rubick.target[id], stealrange) then
                                if not NPC.HasState(rubick.target[id], Enum.ModifierState.MODIFIER_STATE_INVULNERABLE) and not NPC.HasModifier(rubick.target[id], "modifier_dark_willow_shadow_realm_buff") then
                                    if Ability.GetName(spell) ~= Ability.GetName(rubick.last_spell[id]) and (not rubick.lockState and Ability.GetCooldown(spell) > 0 or ((Ability.GetName(spell) == "ember_spirit_fire_remnant" or Ability.GetName(spell) == "sniper_shrapnel" or (Ability.GetName(spell) == "void_spirit_resonant_pulse" or Ability.GetName(spell) == "slark_pounce" and NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed"))) and Ability.GetCurrentCharges(spell) == 0) or NPC.GetAbility(me, "rubick_empty1") or Menu.IsKeyDown(rubick.swapkey)) then
                                        if not rubick.cooldown[Ability.GetName(rubick.last_spell[id])] or rubick.cooldown[Ability.GetName(rubick.last_spell[id])] and ((os.clock() - rubick.cooldown[Ability.GetName(rubick.last_spell[id])])) > Ability.GetCooldownLength(rubick.last_spell[id]) then
                                            if Ability.GetName(spell) ~= "snapfire_mortimer_kisses" or Ability.GetName(spell) == "snapfire_mortimer_kisses" and Ability.SecondsSinceLastUse(spell) > 1 and not NPC.HasModifier(me, "modifier_snapfire_mortimer_kisses") then
                                                Ability.CastTarget(spellsteal, rubick.target[id])
                                                if Ability.GetName(rubick.last_spell[id]) == "ember_spirit_fire_remnant" then
                                                    if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then
                                                        rubick.cooldown[Ability.GetName(rubick.last_spell[id])] = os.clock() + 114
                                                    else
                                                        rubick.cooldown[Ability.GetName(rubick.last_spell[id])] = os.clock() + 190
                                                    end
                                                elseif Ability.GetName(rubick.last_spell[id]) == "sniper_shrapnel" then
                                                    rubick.cooldown[Ability.GetName(rubick.last_spell[id])] = os.clock() + 120
                                                elseif Ability.GetName(rubick.last_spell[id]) == "void_spirit_astral_step" then
                                                    rubick.cooldown[Ability.GetName(rubick.last_spell[id])] = os.clock() + 60
                                                elseif Ability.GetName(rubick.last_spell[id]) == "void_spirit_resonant_pulse" and NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then
                                                    rubick.cooldown[Ability.GetName(rubick.last_spell[id])] = os.clock() + 50
                                                else
                                                    rubick.cooldown[Ability.GetName(rubick.last_spell[id])] = os.clock()
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end

        if target then
            local bufftime = 0
            for _, bufflist in pairs(
                {
                    "modifier_bashed",
                    "modifier_sheepstick_debuff",
                    "modifier_stunned",
                    "modifier_alchemist_unstable_concoction",
                    "modifier_ancientapparition_coldfeet_freeze",
                    "modifier_axe_berserkers_call",
                    "modifier_bane_fiends_grip",
                    "modifier_earthshaker_fissure_stun",
                    "modifier_earth_spirit_boulder_smash",
                    "modifier_enigma_black_hole_pull",
                    "modifier_faceless_void_chronosphere_freeze",
                    "modifier_jakiro_ice_path_stun",
                    "modifier_keeper_of_the_light_mana_leak_stun",
                    "modifier_kunkka_torrent",
                    "modifier_legion_commander_duel",
                    "modifier_lion_impale",
                    "modifier_lion_voodoo",
                    "modifier_magnataur_reverse_polarity",
                    "modifier_medusa_stone_gaze_stone",
                    "modifier_nyx_assassin_impale",
                    "modifier_pudge_dismember",
                    "modifier_rattletrap_hookshot",
                    "modifier_rubick_telekinesis",
                    "modifier_sandking_impale",
                    "modifier_shadow_shaman_voodoo",
                    "modifier_shadow_shaman_shackles",
                    "modifier_techies_stasis_trap_stunned",
                    "modifier_tidehunter_ravage",
                    "modifier_windrunner_shackle_shot",
                    "modifier_lone_druid_spirit_bear_entangle_effect",
                    "modifier_storm_spirit_electric_vortex_pull",
                    "modifier_visage_summon_familiars_stone_form_buff",
                    "modifier_void_spirit_aether_remnant_pull"
                }
            ) do
                local buff = NPC.GetModifier(target, bufflist)
                if buff then
                    bufftime = Modifier.GetDieTime(buff)
                end
            end

            if (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_OPTIONAL_UNIT_TARGET) ~= 0 then
                distance = distance + bonuses_range
            elseif Ability.GetName(spell) == "night_stalker_void" and NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then
                distance = 900
            end

            if Menu.IsKeyDown(rubick.spellkey) then
                if Entity.IsAlive(me) and distance > 0 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < distance and Ability.IsReady(spell) and not NPC.IsChannellingAbility(me) and (eb and Ability.GetDamageType(spell) ~= Enum.DamageTypes.DAMAGE_TYPE_MAGICAL or not eb or eb and not Ability.IsReady(eb)) then
                    if not sheep or not isdiable or sheep and isdiable and Ability.SecondsSinceLastUse(sheep) > 1 or Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > Ability.GetCastRange(sheep) then
                        if not isdiable or bufftime == 0 or bufftime > 0 and bufftime - os.clock() <= 0.35 then

                            if (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_NO_TARGET) ~= 0 then
                                if Ability.GetName(spell) == "shredder_return_chakram" then
                                    if os.clock() > rubick.time and not NPC.HasModifier(target, "modifier_shredder_chakram_debuff") then
                                        Ability.CastNoTarget(spell)
                                        rubick.time = 0
                                    end
                                end
                                if Ability.GetName(spell) == "earthshaker_enchant_totem" and (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) then
                                    if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < NPC.GetAttackRange(me) + 500 then
                                        Ability.CastTarget(spell, me)
                                    end
                                elseif Ability.GetName(spell) == "riki_tricks_of_the_trade" and (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) then
                                    Ability.CastTarget(spell, me)
                                elseif Ability.GetName(spell) == "chaos_knight_phantasm" and (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) then
                                    Ability.CastTarget(spell, me)
                                elseif Ability.GetName(spell) == "luna_eclipse" and (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) then
                                    Ability.CastPosition(spell, Entity.GetAbsOrigin(target))
                                elseif Ability.GetName(spell) == "void_spirit_resonant_pulse" and (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) then
                                    if Ability.GetCurrentCharges(spell) > 0 and not NPC.HasModifier(me, "modifier_void_spirit_resonant_pulse_physical_buff") then
                                        Ability.CastNoTarget(spell)
                                    end
                                elseif Ability.GetName(spell) == "nevermore_shadowraze1" or Ability.GetName(spell) == "nevermore_shadowraze2" or Ability.GetName(spell) == "nevermore_shadowraze3" or Ability.GetName(spell) == "slark_pounce" then
                                    if Ability.GetName(spell) == "nevermore_shadowraze1" or Ability.GetName(spell) == "slark_pounce" or
                                        Ability.GetName(spell) == "nevermore_shadowraze2" and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > 250 or
                                        Ability.GetName(spell) == "nevermore_shadowraze3" and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > 450
                                     then
                                        if NPC.FindFacingNPC(me, nil, Enum.TeamType.TEAM_ENEMY, distance, 5) == target then
                                            Ability.CastNoTarget(spell)
                                        end
                                    end
                                elseif Ability.GetName(spell) == "ancient_apparition_ice_blast_release" then
                                    if os.clock() - timer > traveltime then
                                        Ability.CastNoTarget(spell)
                                    end
                                elseif Ability.GetName(spell) == "tinker_rearm" then
                                    if Ability.GetName(telekinesis) == "rubick_telekinesis_land" and Ability.SecondsSinceLastUse(fadebolt) > rubick.lift_duration and (not sheep or sheep and Ability.SecondsSinceLastUse(sheep) > rubick.lift_duration) then
                                        if os.clock() > rubick.time and not NPC.IsChannellingAbility(me) then
                                            Ability.CastNoTarget(spell)
                                            rubick.time = Ability.GetCastPoint(spell) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + os.clock() + 0.55
                                        end
                                    end
                                elseif Ability.GetName(spell) == "leshrac_pulse_nova" then
                                    if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then radius = 750 else radius = 450 end
                                    if not Ability.GetToggleState(spell) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < radius then
                                        Ability.Toggle(spell)
                                    elseif Ability.GetToggleState(spell) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > radius then
                                        Ability.Toggle(spell)
                                    end
                                elseif Ability.GetName(spell) == "phoenix_supernova" then
                                    if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then
                                        if rubick.teammate and Entity.GetHealth(rubick.teammate) / Entity.GetMaxHealth(rubick.teammate) < 0.3 and Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.5 then
                                            Ability.CastTarget(spell, rubick.teammate)
                                        elseif Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.3 then
                                            Ability.CastTarget(spell, me)
                                        end
                                    else
                                        if Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.3 then
                                            Ability.CastNoTarget(spell)
                                        end
                                    end
                                elseif Ability.GetName(spell) == "weaver_time_lapse" then
                                    if os.clock() > rubick.time then
                                        rubick.hp = Entity.GetHealth(me)
                                        rubick.time = os.clock() + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + 1
                                    end
                                    if rubick.teammate and os.clock() > rubick.second_time then
                                        rubick.teammate_hp = Entity.GetHealth(rubick.teammate)
                                        rubick.second_time = os.clock() + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + 1
                                    end
                                    if Entity.GetHealth(me) < rubick.hp - 300 then
                                        if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then
                                            Ability.CastTarget(spell, me)
                                        else
                                            Ability.CastNoTarget(spell)
                                        end
                                        rubick.hp = 0
                                        rubick.time = 0
                                    end
                                    if rubick.teammate and Entity.GetHealth(rubick.teammate) < rubick.teammate_hp - 300 and (NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed")) then
                                        Ability.CastTarget(spell, rubick.teammate)
                                        rubick.teammate_hp = 0
                                        rubick.second_time = 0
                                    end
                                elseif Ability.GetName(spell) == "shredder_return_chakram" then
                                    if os.clock() > rubick.time and not NPC.HasModifier(target, "modifier_shredder_chakram_debuff") then
                                        Ability.CastNoTarget(spell)
                                        rubick.time = 0
                                    end
                                elseif Ability.GetName(spell) == "earthshaker_echo_slam" then
                                    if #NPCs.InRadius(Entity.GetAbsOrigin(me), 600, Entity.GetTeamNum(me), Enum.TeamType.TEAM_ENEMY) > 2 then
                                        Ability.CastNoTarget(spell)
                                    end
                                elseif Ability.GetName(spell) == "alchemist_unstable_concoction" then
                                    Ability.CastNoTarget(spell)
                                    rubick.time = os.clock() + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + NetChannel.GetAvgLatency(Enum.Flow.FLOW_INCOMING) + 3
                                elseif Ability.GetName(spell) == "windrunner_windrun" then
                                    if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then
                                        if not NPC.HasModifier(me, "modifier_windrunner_windrun") then
                                            Ability.CastNoTarget(spell)
                                        end
                                    else
                                        Ability.CastNoTarget(spell)
                                    end
                                else
                                    Ability.CastNoTarget(spell)
                                end
                            end
                            if (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 and (Ability.GetTargetTeam(spell) & Enum.TargetTeam.DOTA_UNIT_TARGET_TEAM_FRIENDLY) ~= 0 and IsSupport then
                                if Ability.GetName(spell) == "chen_divine_favor" then
                                    for i, v in ipairs(Entity.GetHeroesInRadius(me, 99999 ,Enum.TeamType.TEAM_FRIEND)) do
                                        if v and Entity.IsAlive(v) and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(v)):Length2D() > 1500 and Entity.GetHealth(v) / Entity.GetMaxHealth(v) > 0.7  then
                                            Ability.CastTarget(spell, v)

                                        end
                                    end
                                else
                                    if rubick.teammate and Entity.GetHealth(rubick.teammate) / Entity.GetMaxHealth(rubick.teammate) < 0.9 then
                                        Ability.CastTarget(spell, rubick.teammate)
                                    elseif Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.8 then
                                        Ability.CastTarget(spell, me)
                                    end
                                end
                                if Ability.GetName(spell) == "snapfire_firesnap_cookie" then
                                    if rubick.teammate then
                                        if NPC.FindFacingNPC(rubick.teammate, nil, Enum.TeamType.TEAM_ENEMY, 600, 30) == target and Entity.GetAbsOrigin(rubick.teammate):Distance(Entity.GetAbsOrigin(target)):Length2D() > 250 then
                                            Ability.CastTarget(spell, rubick.teammate)
                                        end
                                    elseif not rubick.teammate then
                                        if NPC.FindFacingNPC(me, nil, Enum.TeamType.TEAM_ENEMY, 600, 30) == target and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > 250 then
                                            Ability.CastTarget(spell, me)
                                        end
                                    end
                                end
                            end
                            if (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 and not IsSupport then
                                if NPC.GetItem(me, "item_ultimate_scepter") or NPC.HasModifier(me, "modifier_item_ultimate_scepter_consumed") then
                                    if Ability.GetName(spell) == "bristleback_viscous_nasal_goo" or Ability.GetName(spell) == "storm_spirit_electric_vortex" or Ability.GetName(spell) == "night_stalker_void" then
                                        Ability.CastNoTarget(spell)
                                    end
                                    if Ability.GetName(spell) == "axe_battle_hunger" then
                                        Ability.CastPosition(spell, Entity.GetAbsOrigin(target))
                                    end
                                end
                                if (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_AOE) ~= 0 and Ability.GetName(spell) ~= "alchemist_unstable_concoction_throw" and Ability.GetName(spell) ~= "antimage_mana_void" then
                                    Ability.CastTarget(spell, target)
                                end
                                if Ability.GetName(spell) == "pugna_decrepify" then
                                    Ability.CastTarget(spell, target)
                                end
                                if (Ability.GetTargetTeam(spell) & Enum.TargetTeam.DOTA_UNIT_TARGET_TEAM_ENEMY) ~= 0 then
                                    if not NPC.HasModifier(target, "modifier_antimage_counterspell") and not NPC.HasModifier(target, "modifier_item_lotus_orb_active") then
                                        if Ability.GetName(spell) == "windrunner_shackleshot" then
                                            local targetPos = Entity.GetAbsOrigin(target)
                                            local myPos = Entity.GetAbsOrigin(me)
                                            local finded = false
                                            for key, tree in ipairs(Trees.InRadius(myPos, 1375, true)) do
                                                if tree and NPC.IsEntityInRange(target, tree, 575) then
                                                    local treepos = Entity.GetAbsOrigin(tree)
                                                    local X = tonumber(string.format("%.1f", (treepos:GetX() - targetPos:GetX()) / (myPos:GetX() - targetPos:GetX())))
                                                    local Y = tonumber(string.format("%.1f", (treepos:GetY() - targetPos:GetY()) / (myPos:GetY() - targetPos:GetY())))
                                                    if X < 0 and Y < 0 and math.abs(X-Y) < 0.5 then finded = true end
                                                end
                                            end
                                            for key, enemy in ipairs(Entity.GetUnitsInRadius(me, 1375 ,Enum.TeamType.TEAM_ENEMY)) do
                                                if enemy and Entity.IsAlive(enemy) and NPC.IsEntityInRange(enemy, target, 575) then
                                                    local enemypos = Entity.GetAbsOrigin(enemy)
                                                    local X = tonumber(string.format("%.1f", (enemypos:GetX() - targetPos:GetX()) / (myPos:GetX() - targetPos:GetX())))
                                                    local Y = tonumber(string.format("%.1f", (enemypos:GetY() - targetPos:GetY()) / (myPos:GetY() - targetPos:GetY())))
                                                    if X < 0 and Y < 0 and math.abs(X - Y) < 0.5 then finded = true end
                                                    local X2 = tonumber(string.format("%.1f", (enemypos:GetX() - targetPos:GetX()) / (targetPos:GetX() - myPos:GetX())))
                                                    local Y2 = tonumber(string.format("%.1f", (enemypos:GetY() - targetPos:GetY()) / (targetPos:GetY() - myPos:GetY())))
                                                    if X2 < 0 and Y2 < 0 and math.abs(X2 - Y2) < 0.1 then Ability.CastTarget(spell, enemy) end
                                                end
                                            end
                                            if finded == true then
                                                Ability.CastTarget(spell, target)
                                            end
                                        elseif Ability.GetName(spell) == "terrorblade_sunder" then
                                            if Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.5 then
                                                for key, enemy in ipairs(Entity.GetHeroesInRadius(me, 475, Enum.TeamType.TEAM_ENEMY)) do
                                                    if enemy and Entity.IsAlive(enemy) then
                                                        if Entity.GetHealth(me) < Entity.GetHealth(enemy) then
                                                            Ability.CastTarget(spell, enemy)
                                                        end
                                                    end
                                                end
                                            end
                                        elseif Ability.GetName(spell) == "bounty_hunter_track" then
                                            for key, enemy in ipairs(Entity.GetHeroesInRadius(me, 1000, Enum.TeamType.TEAM_ENEMY)) do
                                                if enemy and Entity.IsAlive(enemy) and not NPC.HasModifier(enemy, "modifier_bounty_hunter_track") then
                                                    Ability.CastTarget(spell, enemy)
                                                end
                                            end
                                        elseif Ability.GetName(spell) == "alchemist_unstable_concoction_throw" then
                                            if os.clock() > rubick.time then
                                                Ability.CastTarget(spell, target)
                                                rubick.time = 0
                                            end
                                        elseif Ability.GetName(spell) == "bloodseeker_rupture" then
                                            if not NPC.HasModifier(target, "modifier_bloodseeker_rupture") then
                                                Ability.CastTarget(spell, target)
                                            end
                                        elseif Ability.GetName(spell) == "antimage_mana_void" then
                                            if Entity.GetHealth(target) + NPC.GetHealthRegen(target) < (NPC.GetMaxMana(target) - NPC.GetMana(target) + NPC.GetManaRegen(target)) * (Ability.GetLevelSpecialValueFor(spell, "mana_void_damage_per_mana") + amp - NPC.GetMagicalArmorDamageMultiplier(target)) * NPC.GetMagicalArmorDamageMultiplier(target) then
                                                Ability.CastTarget(spell, target)
                                            end
                                        elseif Ability.GetName(spell) == "necrolyte_reapers_scythe" then
                                            if Entity.GetHealth(target) + NPC.GetHealthRegen(target) < (Entity.GetMaxHealth(target) - Entity.GetHealth(target)) * (1 + Ability.GetLevelSpecialValueFor(spell, "damage_per_health") + amp - NPC.GetMagicalArmorDamageMultiplier(target)) * NPC.GetMagicalArmorDamageMultiplier(target) then
                                                Ability.CastTarget(spell, target)
                                            end
                                        elseif Ability.GetName(spell) == "axe_culling_blade" then
                                            if Entity.GetHealth(target) + NPC.GetHealthRegen(target) < Ability.GetLevelSpecialValueFor(spell, "kill_threshold") then
                                                Ability.CastTarget(spell, target)
                                            end
                                        else
                                            Ability.CastTarget(spell, target)
                                        end
                                    end
                                else
                                    Ability.CastTarget(spell, me)
                                end
                            end
                            if (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_POINT) ~= 0 then
                                if Ability.GetName(spell) == "pugna_nether_ward" then
                                    Ability.CastPosition(spell, Entity.GetAbsOrigin(me))
                                elseif Ability.GetName(spell) == "pangolier_swashbuckle" then
                                    local dir = Entity.GetAbsOrigin(me) - Entity.GetAbsOrigin(target)
                                    dir:SetZ(0)
                                    dir:Normalize()
                                    dir:Scale(550)
                                    local pos = Entity.GetAbsOrigin(target) + dir
                                    if pos then
                                        Player.PrepareUnitOrders(Players.GetLocal(), 30, nil, pos, spell, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                                        Player.PrepareUnitOrders(Players.GetLocal(), 30, nil, Entity.GetAbsOrigin(target), spell, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                                        Ability.CastPosition(spell, pos)
                                    end
                                elseif Ability.GetName(spell) == "shredder_timber_chain" then
                                    local myPos = Entity.GetAbsOrigin(me)
                                    local targetPos = Entity.GetAbsOrigin(target)
                                    for key, tree in ipairs(Trees.InRadius(myPos, 1450, true)) do
                                        if tree then
                                            local treepos = Entity.GetAbsOrigin(tree)
                                            local X = tonumber(string.format("%.1f", (treepos:GetX() - targetPos:GetX()) / (myPos:GetX() - targetPos:GetX())))
                                            local Y = tonumber(string.format("%.1f", (treepos:GetY()-targetPos:GetY()) / (myPos:GetY() - targetPos:GetY())))
                                            if X < 0 and Y < 0 and math.abs(X-Y) < 0.5 then Ability.CastPosition(spell, Entity.GetAbsOrigin(tree)) end
                                        end
                                    end
                                elseif Ability.GetName(spell) == "juggernaut_healing_ward" then
                                    if rubick.teammate and Entity.GetHealth(rubick.teammate) / Entity.GetMaxHealth(rubick.teammate) < 0.9 then
                                        Ability.CastPosition(spell, Entity.GetAbsOrigin(rubick.teammate))
                                    elseif Entity.GetHealth(me) / Entity.GetMaxHealth(me) < 0.8 then
                                        Ability.CastPosition(spell, Entity.GetAbsOrigin(me))
                                    end
                                elseif Ability.GetName(spell) == "void_spirit_aether_remnant" then
                                    local pos1, pos2 = nil, nil
                                    if NPC.IsRunning(target) then
                                        local angle = Entity.GetRotation(target)
                                        local offset = Angle(0, 45, 0)
                                        angle:SetYaw(angle:GetYaw() + offset:GetYaw())
                                        local x, y, z = angle:GetVectors()
                                        local dir = x + y + z
                                        dir:SetZ(0)
                                        dir:Normalize()
                                        dir:Scale(NPC.GetMoveSpeed(target) * 0.7)
                                        local origin = Entity.GetAbsOrigin(target)
                                        pos1 = origin + dir
                                        if NPC.FindFacingNPC(target, nil, Enum.TeamType.TEAM_ENEMY, 1450, 180) == me then
                                            pos2 = Entity.GetAbsOrigin(target) + Entity.GetRotation(target):GetForward():Normalized():Scaled(NPC.GetMoveSpeed(target) * 2.5)
                                        else
                                            pos2 = Entity.GetAbsOrigin(target)
                                        end
                                    else
                                        local dir = Entity.GetAbsOrigin(me) - Entity.GetAbsOrigin(target)
                                        dir:SetZ(0)
                                        dir:Normalize()
                                        dir:Scale(200)
                                        pos1 = Entity.GetAbsOrigin(target) + dir
                                        pos2 = Entity.GetAbsOrigin(target) + dir
                                    end
                                    if pos1 and pos2 and os.clock() > rubick.time then
                                        Player.PrepareUnitOrders(Players.GetLocal(), 30, nil, pos2, spell, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                                        Player.PrepareUnitOrders(Players.GetLocal(), 30, nil, pos1, spell, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                                        Player.PrepareUnitOrders(Players.GetLocal(), 5, nil, pos2, spell, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                                        rubick.time = os.clock() + 0.28
                                    end
                                elseif Ability.GetName(spell) == "void_spirit_astral_step" then
                                    local dir = Entity.GetAbsOrigin(target) - Entity.GetAbsOrigin(me)
                                    dir:SetZ(0)
                                    dir:Normalize()
                                    dir:Scale(1100)
                                    local pos = Entity.GetAbsOrigin(me) + dir
                                    if pos and Entity.GetAbsOrigin(me):Distance(pos):Length2D() > 550 and Ability.GetCurrentCharges(spell) > 0 and os.clock() > rubick.time then
                                        Ability.CastPosition(spell, pos)
                                        rubick.time = os.clock() + 0.28
                                    end
                                elseif Ability.GetName(spell) == "puck_dream_coil" or Ability.GetName(spell) == "enigma_black_hole" then
                                    if Ability.GetName(spell) == "puck_dream_coil" then
                                        radius = 550
                                    else
                                        radius = 630
                                    end
                                    local count = Heroes.InRadius(Entity.GetAbsOrigin(me), distance, Entity.GetTeamNum(me), Enum.TeamType.TEAM_ENEMY)
                                    local enemies = Heroes.InRadius(Entity.GetAbsOrigin(target), radius, Entity.GetTeamNum(me), Enum.TeamType.TEAM_ENEMY)
                                    if #enemies == #count and #enemies > 1 then
                                    local pos = {}
                                    for i, v in ipairs(count) do
                                        if v then
                                            table.insert(pos, {x = Entity.GetAbsOrigin(v):GetX(), y = Entity.GetAbsOrigin(v):GetY()})
                                        end
                                    end
                                    local x, y, c = 0, 0, #pos
                                    for i = 1, c do
                                        x = x + pos[i].x
                                        y = y + pos[i].y
                                    end
                                        Ability.CastPosition(spell, Vector(x/c, y/c, 0))
                                    end
                                elseif Ability.GetName(spell) == "sniper_shrapnel" then
                                    if rubick.shrapnel_pos and Entity.GetAbsOrigin(target):Distance(rubick.shrapnel_pos):Length2D() > 450 then
                                        rubick.shrapnel_pos = nil
                                    end
                                    if Ability.GetCurrentCharges(spell) > 0 and os.clock() > rubick.time then
                                        if not rubick.shrapnel_pos or rubick.shrapnel_pos and Entity.GetAbsOrigin(target):Distance(rubick.shrapnel_pos):Length2D() > 450 then
                                            if NPC.IsRunning(target) then
                                                Ability.CastPosition(spell, Entity.GetAbsOrigin(target) + Entity.GetRotation(target):GetForward():Normalized():Scaled(225 + NPC.GetMoveSpeed(target)))
                                                rubick.shrapnel_pos = Entity.GetAbsOrigin(target)
                                            else
                                                Ability.CastPosition(spell, Entity.GetAbsOrigin(target) + Entity.GetRotation(target):GetForward():Normalized():Scaled(225))
                                                rubick.shrapnel_pos = Entity.GetAbsOrigin(target)
                                            end
                                            rubick.time = os.clock() + 1
                                        end
                                    end

                                else
                                    local isblocked = false
                                    if Ability.GetName(spell) == "pudge_meat_hook" or Ability.GetName(spell) == "rattletrap_hookshot" or Ability.GetName(spell) == "mirana_arrow" then
                                        for i = 1, math.floor((Entity.GetAbsOrigin(me) - Entity.GetAbsOrigin(target)):Length2D() / 125) do
                                            for _, unit in ipairs(NPCs.InRadius(Entity.GetAbsOrigin(me) + (Entity.GetAbsOrigin(target) - Entity.GetAbsOrigin(me)):Normalized():Scaled(i * 125), 125, Entity.GetTeamNum(me),Enum.TeamType.TEAM_BOTH)
                                            ) do
                                                if
                                                    (Ability.GetName(spell) == "mirana_arrow" and
                                                    not Entity.IsSameTeam(me, unit) or
                                                    Ability.GetName(spell) ~= "mirana_arrow") and
                                                    unit and Entity.IsNPC(unit) and unit ~= target and unit ~= me and
                                                    Entity.IsAlive(unit) and
                                                    not Entity.IsDormant(unit) and
                                                    not NPC.IsStructure(unit) and
                                                    not NPC.IsBarracks(unit) and
                                                    not NPC.IsWaitingToSpawn(unit) and
                                                    NPC.GetUnitName(unit) ~= "npc_dota_neutral_caster" and
                                                    NPC.GetUnitName(unit) ~= nil
                                                 then
                                                    isblocked = true
                                                end
                                            end
                                        end
                                    end
                                    if
                                        not isblocked and (Ability.GetName(spell) == "pudge_meat_hook" or Ability.GetName(spell) == "rattletrap_hookshot" or Ability.GetName(spell) == "mirana_arrow") and NPC.FindFacingNPC(me, nil, Enum.TeamType.TEAM_ENEMY, nil, 15) == target or
                                        Ability.GetName(spell) ~= "pudge_meat_hook" and Ability.GetName(spell) ~= "tiny_tree_channel" and Ability.GetName(spell) ~= "rattletrap_hookshot" and Ability.GetName(spell) ~= "mirana_arrow" and Ability.GetName(spell) ~= "ember_spirit_fire_remnant" and Ability.GetName(spell) ~= "death_prophet_spirit_siphon" and Ability.GetName(spell) ~= "shadow_demon_demonic_purge" or
                                        Ability.GetName(spell) == "tiny_tree_channel" and #Trees.InRadius(Entity.GetAbsOrigin(me), 525, true) > 2 or
                                        (Ability.GetName(spell) == "ember_spirit_fire_remnant" or Ability.GetName(spell) == "death_prophet_spirit_siphon" or Ability.GetName(spell) == "shadow_demon_demonic_purge") and Ability.GetCurrentCharges(spell) > 0
                                     then
                                        if NPC.IsRunning(target) then
                                            local speed = NPC.GetMoveSpeed(target)
                                            local angle = Entity.GetRotation(target)
                                            local offset = Angle(0, 45, 0)
                                            angle:SetYaw(angle:GetYaw() + offset:GetYaw())
                                            local x, y, z = angle:GetVectors()
                                            local dir = x + y + z
                                            dir:SetZ(0)
                                            dir:Normalize()
                                            if Ability.GetName(spell) == "invoker_sun_strike" then
                                                dir:Scale(speed * 2)
                                            elseif Ability.GetName(spell) == "ancient_apparition_ice_blast" then
                                                dir:Scale(speed * 2)
                                            else
                                                dir:Scale(speed)
                                            end
                                            local origin = Entity.GetAbsOrigin(target)
                                            pos = origin + dir
                                            if pos then
                                                Ability.CastPosition(spell, pos)
                                            end
                                        else
                                            Ability.CastPosition(spell, Entity.GetAbsOrigin(target))
                                        end
                                        rubick.time = os.clock() + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + 1
                                    end
                                    if Ability.GetName(spell) == "ancient_apparition_ice_blast" and Ability.IsInAbilityPhase(spell) then
                                        timer = os.clock()
                                        traveltime = Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() / 1500
                                    end
                                end
                            end
                        end
                    end
                end
                if isblinking then
                    if distance > 0 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > distance then
                        if distance > 550 then
                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < 1199 + distance then
                                Ability.CastPosition(blink, Entity.GetAbsOrigin(me) + ((Entity.GetAbsOrigin(target) - Entity.GetAbsOrigin(me)):Normalized():Scaled(1199)))
                            end
                        else
                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() < 1199 then
                                Ability.CastPosition(blink, Entity.GetAbsOrigin(target))
                            end
                        end
                    else
                        isblinking = false
                    end
                end
                if isdiable and Ability.IsReady(spell) and forward and Ability.IsReady(forward) and NPC.FindFacingNPC(me, nil, Enum.TeamType.TEAM_ENEMY, distance + 600, 25) == target and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > distance + 150 then
                    Ability.CastTarget(forward, me)
                end
                if not isblinking then
                    if (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_CHANNELLED) == 0 or
                        (Ability.GetBehavior(spell) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_CHANNELLED) ~= 0 and
                        Ability.SecondsSinceLastUse(spell) > 1 and not NPC.IsChannellingAbility(me) or
                        distance > 0 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > distance or
                        Ability.GetName(spell) == "tinker_rearm" and not NPC.IsChannellingAbility(me)
                     then
                        if Ability.GetName(spell) ~= "snapfire_mortimer_kisses" or Ability.GetName(spell) == "snapfire_mortimer_kisses" and Ability.SecondsSinceLastUse(spell) > 1 and not NPC.HasModifier(me, "modifier_snapfire_mortimer_kisses") then
                            if telekinesis and Ability.IsReady(telekinesis) then
                                if Ability.GetName(telekinesis) == "rubick_telekinesis" and NPC.IsEntityInRange(me, target, Ability.GetCastRange(telekinesis) + bonuses_range) then
                                    if not sheep or sheep and Ability.SecondsSinceLastUse(sheep) > 1 then
                                        if not isdiable or
                                            isdiable and Ability.SecondsSinceLastUse(spell) > 1 or
                                            isdiable and distance > 0 and Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > distance
                                        then
                                            if bufftime == 0 or bufftime > 0 and bufftime - os.clock() <= 0.75 then
                                                if Ability.GetName(spell) ~= "void_spirit_aether_remnant" or Ability.GetName(spell) == "void_spirit_aether_remnant" and Ability.SecondsSinceLastUse(spell) > 2 then
                                                    Ability.CastTarget(telekinesis, target)
                                                    rubick.lift_duration = Ability.GetLevelSpecialValueFor(telekinesis, "lift_duration") / 2
                                                end
                                            end
                                        end
                                    end
                                end
                                if Ability.GetName(telekinesis) == "rubick_telekinesis_land" then
                                    for i, v in ipairs(Entity.GetHeroesInRadius(me, 1075 ,Enum.TeamType.TEAM_ENEMY)) do
                                        if v and v ~= target then
                                            table.insert(enemies, v)
                                            if #enemies > 4 then
                                                table.sort(enemies, function (a, b) return Entity.GetAbsOrigin(a) > Entity.GetAbsOrigin(b) end)
                                            end
                                            if enemies[1] and Entity.GetAbsOrigin(target):Distance(Entity.GetAbsOrigin(enemies[1])):Length2D() < throw_range then
                                                if not rubick.throw_pos or rubick.throw_pos and Entity.GetAbsOrigin(enemies[1]):Distance(rubick.throw_pos):Length2D() > 150 then
                                                    if NPC.IsRunning(enemies[1]) then
                                                        Ability.CastPosition(telekinesis, Entity.GetAbsOrigin(enemies[1]) + Entity.GetRotation(enemies[1]):GetForward():Normalized():Scaled(NPC.GetMoveSpeed(enemies[1])))
                                                        rubick.throw_pos = Entity.GetAbsOrigin(enemies[1])
                                                    else
                                                        Ability.CastPosition(telekinesis, Entity.GetAbsOrigin(enemies[1]))
                                                        rubick.throw_pos = Entity.GetAbsOrigin(enemies[1])
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            else
                                rubick.throw_pos = nil
                            end
                            if fadebolt and Ability.IsReady(fadebolt) and NPC.IsEntityInRange(me, target, Ability.GetCastRange(fadebolt) + bonuses_range) and (not eb or eb and not Ability.IsReady(eb)) then
                                Ability.CastTarget(fadebolt, target)
                            end
                        end
                        if next(summontable) ~= nil then
                            for _, summon in ipairs(summontable) do
                                if summon then
                                    for i = 0, 5 do
                                        local summonspell = NPC.GetAbilityByIndex(summon, i)
                                        local summoitem = NPC.GetItemByIndex(summon, i)
                                        if summonspell ~= nil and Ability.IsReady(summonspell) then
                                            if Ability.GetName(summonspell) == "rubick_fade_bolt" and (not eb or eb and not Ability.IsReady(eb)) then
                                                Ability.CastTarget(summonspell, target)
                                            end
                                            if bufftime == 0 or bufftime > 0 and bufftime - os.clock() <= 0.75 then
                                                if
                                                    Ability.GetName(summonspell) == "rubick_telekinesis" or
                                                    Ability.GetName(summonspell) == "brewmaster_earth_hurl_boulder"
                                                then
                                                    Ability.CastTarget(summonspell, target)
                                                end
                                                if
                                                    Ability.GetName(summonspell) == "visage_summon_familiars_stone_form" and os.clock() > rubick.time and
                                                    Entity.GetAbsOrigin(summon):Distance(Entity.GetAbsOrigin(target)):Length2D() < 290
                                                then
                                                    Ability.CastNoTarget(summonspell)
                                                    rubick.time = os.clock() + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + 1
                                                end
                                            end
                                        end
                                        if summoitem ~= nil and Ability.IsReady(summoitem) then
                                            if (Ability.GetBehavior(summoitem) & Enum.AbilityBehavior.DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) ~= 0 then
                                                if Ability.GetName(summoitem) == "item_force_staff" or Ability.GetName(summoitem) == "item_hurricane_pike" then
                                                    if Entity.GetAbsOrigin(summon):Distance(Entity.GetAbsOrigin(target)):Length2D() > NPC.GetAttackRange(summon) and NPC.FindFacingNPC(summon, nil, Enum.TeamType.TEAM_ENEMY, 1125, 25) == target then
                                                        Ability.CastTarget(summoitem, summon)
                                                    end
                                                elseif Ability.GetName(summoitem) == "item_sheepstick" then
                                                    if bufftime > 0 and bufftime - os.clock() <= 0.75 then
                                                        Ability.CastTarget(summoitem, target)
                                                    end
                                                else
                                                    Ability.CastTarget(summoitem, target)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if spell2 then
                        if Ability.GetName(spell2) == "ember_spirit_activate_fire_remnant" then
                            for key, remnant in ipairs(Entity.GetUnitsInRadius(me, 2000 ,Enum.TeamType.TEAM_FRIEND)) do
                                if remnant and NPC.GetUnitName(remnant) == "npc_dota_ember_spirit_remnant" and Entity.IsAlive(remnant) and
                                    Entity.GetAbsOrigin(remnant):Distance(Entity.GetAbsOrigin(target)):Length2D() < 300 then
                                    Ability.CastPosition(spell2, Entity.GetAbsOrigin(me))
                                end
                            end
                        elseif Ability.GetName(spell2) == "shredder_chakram_2" then
                            if pos and NPC.IsRunning(target) then
                                Ability.CastPosition(spell2, pos)
                            else
                                Ability.CastPosition(spell2, Entity.GetAbsOrigin(target))
                            end
                            rubick.second_time = os.clock() + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + 1
                        elseif Ability.GetName(spell2) == "shredder_return_chakram_2" then
                            if os.clock() > rubick.second_time and not NPC.HasModifier(target, "modifier_shredder_chakram_debuff") then
                                Ability.CastNoTarget(spell2)
                                rubick.second_time = 0
                            end
                        elseif Ability.GetName(spell2) == "templar_assassin_trap" then
                            for i, v in ipairs(Entity.GetUnitsInRadius(me, 2000 ,Enum.TeamType.TEAM_FRIEND)) do
                                if v and NPC.GetUnitName(v) == "npc_dota_templar_assassin_psionic_trap" and Entity.IsAlive(v) and
                                    Entity.GetAbsOrigin(v):Distance(Entity.GetAbsOrigin(target)):Length2D() < 300 then
                                    Ability.CastNoTarget(spell2)
                                end
                            end
                        elseif Ability.GetName(spell2) == "phoenix_sun_ray_toggle_move" then
                            if Entity.GetAbsOrigin(me):Distance(Entity.GetAbsOrigin(target)):Length2D() > 550 then
                                if os.clock() > rubick.second_time then
                                    Ability.CastNoTarget(spell2)
                                    toggle = true
                                    rubick.second_time = os.clock() + NetChannel.GetAvgLatency(Enum.Flow.FLOW_OUTGOING) + 1
                                end

                            else
                                if os.clock() < rubick.second_time and toggle then
                                    Ability.CastNoTarget(spell2)
                                    toggle = false
                                    rubick.second_time = 0
                                end
                            end
                        end
                    end
                    if NPC.HasModifier(me, "modifier_snapfire_mortimer_kisses") or Ability.GetName(spell) == "void_spirit_dissimilate" and NPC.IsSilenced(me) then
                        local targeted = nil
                        if NPC.IsRunning(target) then
                            local angle = Entity.GetRotation(target)
                            local offset = Angle(0, 45, 0)
                            angle:SetYaw(angle:GetYaw() + offset:GetYaw())
                            local x, y, z = angle:GetVectors()
                            local dir = x + y + z
                            dir:SetZ(0)
                            dir:Normalize()
                            dir:Scale(NPC.GetMoveSpeed(target) * 0.7)
                            local origin = Entity.GetAbsOrigin(target)
                            targeted = origin + dir
                        else
                            targeted = Entity.GetAbsOrigin(target)
                        end
                        Player.PrepareUnitOrders(Players.GetLocal(), 1, nil, targeted, nil, Enum.PlayerOrderIssuer.DOTA_ORDER_ISSUER_HERO_ONLY, me)
                    end
                end
            else
                target = nil
            end
        end
    end
end

function rubick.OnStartSound(sound)
    local me = Heroes.GetLocal()
    if me and sound.source and sound.source ~= me then
        if sound.name == "Hero_EmberSpirit.FireRemnant.Cast" then
            rubick.OnSoundUnit = "npc_dota_hero_ember_spirit"
            rubick.OnSoundName = "ember_spirit_fire_remnant"
        elseif sound.name == "Hero_VoidSpirit.Pulse.Cast" then
            rubick.OnSoundUnit = "npc_dota_hero_void_spirit"
            rubick.OnSoundName = "void_spirit_resonant_pulse"
        elseif sound.name == "Hero_VoidSpirit.AstralStep.Start" then
            rubick.OnSoundUnit = "npc_dota_hero_void_spirit"
            rubick.OnSoundName = "void_spirit_astral_step"
        elseif sound.name == "Hero_Tinker.Rearm" then
            rubick.OnSoundUnit = "npc_dota_hero_tinker"
            rubick.OnSoundName = "tinker_rearm"
        elseif sound.name == "Hero_Phoenix.SuperNova.Explode" then
            rubick.OnSoundUnit = "npc_dota_hero_phoenix"
            rubick.OnSoundName = "phoenix_supernova"
        elseif sound.name == "Hero_Sniper.ShrapnelShoot" then
            rubick.OnSoundUnit = "npc_dota_hero_sniper"
            rubick.OnSoundName = "sniper_shrapnel"
        end
    end
end

function rubick.OnGameEnd()
    rubick.cooldown = {}
    rubick.last_spell = {}
    rubick.target = {}
    rubick.ignoredSpells = {}
    rubick.time = 0
    rubick.second_time = 0
    rubick.hp = 0
    rubick.teammate_hp = 0
    rubick.lockState = false
    rubick.teammate = nil
    rubick.throw_pos = nil
    rubick.OnSoundUnit = nil
    rubick.OnSoundName = nil
end

return rubick

local blank = {
	object_type = "Back",
	name = "cry-Blank",
	key = "blank",
	order = 75,
	pos = { x = 1, y = 0 },
	atlas = "blank",
}
local blank_sprite = {
	object_type = "Atlas",
	key = "blank",
	path = "atlasdeck.png",
	px = 71,
	py = 95,
}
local antimatter = {
	object_type = "Back",
	name = "cry-Antimatter",
	order = 76,
	key = "antimatter",
	config = {
		cry_antimatter = true,
		cry_crit_rate = 0.25, --Critical Deck
		cry_legendary_rate = 0.2, --Legendary Deck
		-- Enhanced Decks
		cry_force_enhancement = "random",
		cry_force_edition = "random",
		cry_force_seal = "random",
		cry_forced_draw_amount = 5,
	},
	pos = { x = 2, y = 0 },
	trigger_effect = function(self, args)
		if args.context ~= "final_scoring_step" then
			antimatter_trigger_effect(self, args)
		else
			return antimatter_trigger_effect_final_scoring_step(self, args)
		end
	end,
	apply = function(self)
		antimatter_apply()
	end,
	atlas = "blank",
}

function antimatter_apply()
	--Checks for nils in the extremely nested thing i'm checking for 
	-- (pretty sure it's just the deck key since that's what the error messages kept throwing but might as well check all of them)
	local function nil_checker(t, ...)
    		local current = t
    		for _, k in ipairs({...}) do
        		if current[k] == nil then
				return nil
        		end
        		current = current[k]
    		end
    		return current
	end

	local bluecheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_blue", "wins", 8)
	local yellowcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_yellow", "wins", 8)
	local abandonedcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_abandoned", "wins", 8)
	local ghostcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_ghost", "wins", 8)
	local redcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_red", "wins", 8)
	local checkeredcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_checkered", "wins", 8)
	local erraticcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_erratic", "wins", 8)
	local blackcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_black", "wins", 8)
	local paintedcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_painted", "wins", 8)
	local greencheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_green", "wins", 8)
	local spookycheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_spooky", "wins", 8)
	local equilibriumcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_equilibrium", "wins", 8)
	local misprintcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_misprint", "wins", 8)
	local infinitecheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_infinite", "wins", 8)
	local wormholecheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_wormhole", "wins", 8)
	local redeemedcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_redeemed", "wins", 8)
	local legendarycheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_legendary", "wins", 8)
	local encodedcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_encoded", "wins", 8)
	local world = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_world_deck", "wins", 8)
	local sun = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_sun_deck", "wins", 8)
	local star = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_star_deck", "wins", 8)
	local moon = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_moon_deck", "wins", 8)
	
	--Blue Deck
	if (bluecheck or 0) ~= 0 then
		G.GAME.starting_params.hands = G.GAME.starting_params.hands + 1
	end
	--All Consumables (see get_antimatter_consumables)
	local querty = get_antimatter_consumables()
	if #querty > 0 then
		delay(0.4)
       		G.E_MANAGER:add_event(Event({
            		func = function()
              			for k, v in ipairs(querty) do
					if G.P_CENTERS[v] then
                    				local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, v, 'deck')
                    				card:add_to_deck()
                    				G.consumeables:emplace(card)
					end
                		end
            		return true
            		end
        	}))
	end
	--Yellow Deck
	if (yellowcheck or 0) ~= 0 then
		G.GAME.starting_params.dollars = G.GAME.starting_params.dollars + 10
	end
	--Abandoned Deck
	if (abandonedcheck or 0) ~= 0 then
		G.GAME.starting_params.no_faces = true
	end
	--Ghost Deck
	if (ghostcheck or 0) ~= 0 then
		G.GAME.spectral_rate = 2
	end
	-- Red Deck
	if (redcheck or 0) ~= 0 then
		G.GAME.starting_params.discards = G.GAME.starting_params.discards + 1
	end
	-- All Decks with Vouchers (see get_antimatter_vouchers)
	local vouchers = get_antimatter_vouchers()
	if #vouchers > 0 then
        	for k, v in pairs(vouchers) do
			if G.P_CENTERS[v] then
            			G.GAME.used_vouchers[v] = true
            			G.GAME.cry_owned_vouchers[v] = true
            			G.GAME.starting_voucher_count = (G.GAME.starting_voucher_count or 0) + 1
            			Card.apply_to_run(nil, G.P_CENTERS[v])
			end
        	end
    	end
	-- Checkered Deck
	if (checkeredcheck or 0) ~= 0 then
		G.E_MANAGER:add_event(Event({
           		func = function()
                		for k, v in pairs(G.playing_cards) do
                    			if v.base.suit == 'Clubs' then 
                        			v:change_suit('Spades')
                    			end
                    			if v.base.suit == 'Diamonds' then 
			              		v:change_suit('Hearts')
                    			end
                		end
            			return true
            		end
       		}))
	end
	-- Erratic Deck
	if (erraticcheck or 0) ~= 0 then
		G.GAME.starting_params.erratic_suits_and_ranks = true
	end
	-- Black Deck
	if (blackcheck or 0) ~= 0 then
		G.GAME.starting_params.joker_slots = G.GAME.starting_params.joker_slots + 1
	end
	-- Painted Deck
	if (paintedcheck or 0) ~= 0 then
		G.GAME.starting_params.hand_size = G.GAME.starting_params.hand_size + 2
	end
	-- Green Deck
	if (greencheck or 0) ~= 0 then
		G.GAME.modifiers.money_per_hand = (G.GAME.modifiers.money_per_hand or 1) + 1
		G.GAME.modifiers.money_per_discard = (G.GAME.modifiers.money_per_discard or 0) + 1
	end
	-- Spooky Deck
	if (spookycheck or 0) ~= 0 then
		G.GAME.modifiers.cry_spooky = true
		G.GAME.modifiers.cry_curse_rate = 0
		--[[
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.jokers then
					local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_cry_chocolate_dice")
					card:add_to_deck()
					card:start_materialize()
					G.jokers:emplace(card)
					return true
				end
			end,
		}))
		]]--
	end
	-- Deck of Equilibrium 
	if (equilibriumcheck or 0) ~= 0 then
		G.GAME.modifiers.cry_equilibrium = true
	end
	-- Misprint Deck
	if (misprintcheck or 0) ~= 0 then
		G.GAME.modifiers.cry_misprint_min = 1
		G.GAME.modifiers.cry_misprint_max = 10
	end
	-- Infinite Deck
	if (infinitecheck or 0) ~= 0 then
		G.GAME.modifiers.cry_highlight_limit = 1e20
		G.GAME.starting_params.hand_size = G.GAME.starting_params.hand_size + 1
	end
	-- Wormhole deck
	if (wormholecheck or 0) ~= 0 then
		G.GAME.modifiers.cry_negative_rate = 20
		--[[
		
		Needs to check if exotic Jokers exist are enabled (whenever that happens)
		
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.jokers then
					local card = create_card("Joker", G.jokers, nil, "cry_exotic", nil, nil, nil, "cry_wormhole")
					card:add_to_deck()
					card:start_materialize()
					G.jokers:emplace(card)
					return true
				end
			end,
		}))
		
		]]--
	end
	-- Redeemed deck
	if (redeemedcheck or 0) ~= 0 then
		G.GAME.modifiers.cry_redeemed = true
	end
	-- Deck of the Moon, Deck of the Sun, Deck of the Stars, Deck of the World
	if (world or 0) ~= 0 then
		G.GAME.bosses_used["bl_goad"] = 1e308
	end
	if (star or 0) ~= 0 then
		G.GAME.bosses_used["bl_window"] = 1e308
	end
	if (sun or 0) ~= 0 then
		G.GAME.bosses_used["bl_head"] = 1e308
	end
	if (moon or 0) ~= 0 then
		G.GAME.bosses_used["bl_club"] = 1e308
	end
	--Legendary Deck
	if (legendarycheck or 0) ~= 0 then
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.jokers then
					local card = create_card("Joker", G.jokers, true, 4, nil, nil, nil, "")
					card:add_to_deck()
					card:start_materialize()
					G.jokers:emplace(card)
					return true
				end
			end,
		}))
	end
	--Encoded Deck (TBA)
	if (encodedcheck or 0) ~= 0 then
		--[[
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.jokers then
					if
						G.P_CENTERS["j_cry_CodeJoker"]
						and (G.GAME.banned_keys and not G.GAME.banned_keys["j_cry_CodeJoker"])
					then
						local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_cry_CodeJoker")
						card:add_to_deck()
						card:start_materialize()
						G.jokers:emplace(card)
					end
					if
						G.P_CENTERS["j_cry_copypaste"]
						and (G.GAME.banned_keys and not G.GAME.banned_keys["j_cry_copypaste"])
					then
						local card = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_cry_copypaste")
						card:add_to_deck()
						card:start_materialize()
						G.jokers:emplace(card)
					end
					return true
				end
			end,
		}))
		]]--
	end
end

function antimatter_trigger_effect_final_scoring_step(self, args)
	--Checks for nils in the extremely nested thing i'm checking for 
	-- (pretty sure it's just the deck key since that's what the error messages kept throwing but might as well check all of them)
	local function nil_checker(t, ...)
    		local current = t
    		for _, k in ipairs({...}) do
        		if current[k] == nil then
				return nil
        		end
        		current = current[k]
    		end
    		return current
	end

	local critcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_critical", "wins", 8)
	local plasmacheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_plasma", "wins", 8)
	
	if args.context == "final_scoring_step" then
			local crit_poll = pseudorandom(pseudoseed("cry_critical"))
			crit_poll = crit_poll / (G.GAME.probabilities.normal or 1)
			--Critical Deck
			if (critcheck or 0) ~= 0 then
				if crit_poll < self.config.cry_crit_rate then
					args.mult = args.mult ^ 2
					update_hand_text({ delay = 0 }, { mult = args.mult, chips = args.chips })
					G.E_MANAGER:add_event(Event({
						func = function()
							play_sound("talisman_emult", 1)
							attention_text({
								scale = 1.4,
								text = localize("cry_critical_hit_ex"),
								hold = 4,
								align = "cm",
								offset = { x = 0, y = -1.7 },
								major = G.play,
							})
							return true
						end,
					}))
					delay(0.6)
				end
			end
			--Plasma Deck
			local tot = args.chips + args.mult
			if (plasmacheck or 0) ~= 0 then
				args.chips = math.floor(tot / 2)
				args.mult = math.floor(tot / 2)
				update_hand_text({ delay = 0 }, { mult = args.mult, chips = args.chips })

				G.E_MANAGER:add_event(Event({
					func = function()
						local text = localize("k_balanced")
						play_sound("gong", 0.94, 0.3)
						play_sound("gong", 0.94 * 1.5, 0.2)
						play_sound("tarot1", 1.5)
						ease_colour(G.C.UI_CHIPS, { 0.8, 0.45, 0.85, 1 })
						ease_colour(G.C.UI_MULT, { 0.8, 0.45, 0.85, 1 })
						attention_text({
							scale = 1.4,
							text = text,
							hold = 2,
							align = "cm",
							offset = { x = 0, y = -2.7 },
							major = G.play,
						})
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							blockable = false,
							blocking = false,
							delay = 4.3,
							func = function()
								ease_colour(G.C.UI_CHIPS, G.C.BLUE, 2)
								ease_colour(G.C.UI_MULT, G.C.RED, 2)
								return true
							end,
						}))
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							blockable = false,
							blocking = false,
							no_delete = true,
							delay = 6.3,
							func = function()
								G.C.UI_CHIPS[1], G.C.UI_CHIPS[2], G.C.UI_CHIPS[3], G.C.UI_CHIPS[4] =
									G.C.BLUE[1], G.C.BLUE[2], G.C.BLUE[3], G.C.BLUE[4]
								G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] =
									G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
								return true
							end,
						}))
						return true
					end,
				}))

				delay(0.6)
			end
			return args.chips, args.mult
		end
end

function antimatter_trigger_effect(self, args)
		--Checks for nils in the extremely nested thing i'm checking for 
		-- (pretty sure it's just the deck key since that's what the error messages kept throwing but might as well check all of them)
		local function nil_checker(t, ...)
    			local current = t
    			for _, k in ipairs({...}) do
        			if current[k] == nil then
					return nil
        			end
        			current = current[k]
    			end
    			return current
		end

		local glowingcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_glowing", "wins", 8)
		local legendarycheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_legendary", "wins", 8)
		local anaglyphcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_anaglyph", "wins", 8)

		if args.context == "eval" and G.GAME.last_blind and G.GAME.last_blind.boss then
			--Glowing Deck
			if (glowingcheck or 0) ~= 0 then
				for i = 1, #G.jokers.cards do
					cry_with_deck_effects(G.jokers.cards[i], function(card)
						cry_misprintize(card, { min = 1.25, max = 1.25 }, nil, true)
					end)
				end
			end
			--Legendary Deck
			if G.jokers and (legendarycheck or 0) ~= 0 then
				if #G.jokers.cards < G.jokers.config.card_limit then
					local legendary_poll = pseudorandom(pseudoseed("cry_legendary"))
					legendary_poll = legendary_poll / (G.GAME.probabilities.normal or 1)
					if legendary_poll < self.config.cry_legendary_rate then
						local card = create_card("Joker", G.jokers, true, 4, nil, nil, nil, "")
						card:add_to_deck()
						card:start_materialize()
						G.jokers:emplace(card)
						return true
					else
						card_eval_status_text(
							G.jokers,
							"jokers",
							nil,
							nil,
							nil,
							{ message = localize("k_nope_ex"), colour = G.C.RARITY[4] }
						)
					end
				else
					card_eval_status_text(
						G.jokers,
						"jokers",
						nil,
						nil,
						nil,
						{ message = localize("k_no_room_ex"), colour = G.C.RARITY[4] }
					)
				end
			end
			--Anaglyph Deck
			if (anaglyphcheck or 0) ~= 0 then
				G.E_MANAGER:add_event(Event({
            				func = (function()
                				add_tag(Tag('tag_double'))
                				play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                				play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                				return true
            				end)
        			}))
			end
		end
end

function get_antimatter_vouchers(voucher_table)
	-- Create a table or use one that is passed into the function
	if not voucher_table or type(voucher_table) ~= "table" then voucher_table = {} end
	
	-- Add Vouchers into the table by key
	local function already_exists(t, voucher)
		for _, v in ipairs(t) do
        		if v == voucher then
				print("sus")
            			return true
        		end
    		end
    		return false
	end
	local function Add_voucher_to_the_table(t, voucher)
    		if not already_exists(t, voucher) then
        		table.insert(t, voucher)
    		end
	end

	--Checks for nils in the extremely nested thing i'm checking for 
	-- (pretty sure it's just the deck key since that's what the error messages kept throwing but might as well check all of them)
	local function nil_checker(t, ...)
    		local current = t
    		for _, k in ipairs({...}) do
        		if current[k] == nil then
				return nil
        		end
        		current = current[k]
    		end
    		return current
	end

	local nebulacheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_nebula", "wins", 8)
	local magiccheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_magic", "wins", 8)
	local zodiaccheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_zodiac", "wins", 8)
	local equilibriumcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_cry_equilibrium", "wins", 8)
	
	--Nebula Deck
	if (nebulacheck or 0) ~= 0 then
		Add_voucher_to_the_table(voucher_table, "v_telescope")
	end
	
	--[[
	
	Remaining vouchers commented out because of that annoying voucher crash
	
	-- Magic Deck
	if (magiccheck or 0) ~= 0 then
		Add_voucher_to_the_table(voucher_table, "v_crystal_ball")
	end
	
	-- Zodiac Deck
	if (zodiaccheck or 0) ~= 0 then
		Add_voucher_to_the_table(voucher_table, "v_tarot_merchant")
		Add_voucher_to_the_table(voucher_table, "v_planet_merchant")
		Add_voucher_to_the_table(voucher_table, "v_overstock_norm")
	end
	-- Deck Of Equilibrium
	if (equilibriumcheck or 0) ~= 0 then
		Add_voucher_to_the_table(voucher_table, "v_overstock_norm")
		Add_voucher_to_the_table(voucher_table, "v_overstock_plus")
	end

	]]--
	
	return voucher_table
end

--Does this even need to be a function idk
function get_antimatter_consumables(consumable_table)
	--Checks for nils in the extremely nested thing i'm checking for 
	-- (pretty sure it's just the deck key since that's what the error messages kept throwing but might as well check all of them)
	local function nil_checker(t, ...)
    		local current = t
    		for _, k in ipairs({...}) do
        		if current[k] == nil then
				return nil
        		end
        		current = current[k]
    		end
    		return current
	end
	-- Create a table or use one that is passed into the function
	if not consumable_table or type(consumable_table) ~= "table" then consumable_table = {} end
	
	-- Add Consumables into the table by key

	local magiccheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_magic", "wins", 8)
	local ghostcheck = nil_checker(G.PROFILES, G.SETTINGS.profile, "deck_usage", "b_ghost", "wins", 8)
	
	if (magiccheck or 0) ~= 0 then
		table.insert(consumable_table, "c_fool")
		table.insert(consumable_table, "c_fool")
	end
	if (ghostcheck or 0) ~= 0 then
		table.insert(consumable_table, "c_hex")
	end
	
	return consumable_table
end


local test = antimatter_trigger_effect
function antimatter_trigger_effect(self, args)
	test(self, args)
	if args.context == "eval" then
		ease_dollars(900)
	end
end
local test2 = get_antimatter_consumables
function get_antimatter_consumables(consumable_table)
	if not consumable_table or type(consumable_table) ~= "table" then consumable_table = {} end
	table.insert(consumable_table, "c_soul")
	table.insert(consumable_table, "c_soul")
	return test2(consumable_table)
end

return {
	name = "Antimatter Deck",
	init = function() end,
	items = { blank_sprite, blank, antimatter },
	disabled = false
}

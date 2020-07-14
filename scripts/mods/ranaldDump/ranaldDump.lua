local mod = get_mod("ranaldDump")
-- require 'pl'
local pl = require'pl.pretty'
local locale_code = Application.user_setting("language_id")
local out_dir = "C:\\Users\\craven\\dev\\dump\\"



local function tableContains(table, key) 
  return table[key] ~= nil
end 

-- Apparently # accomplishes this
local function tableSize(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end

-- Not needed using Fatshark function
local function getTalentDescription(description, values) 
  local fmt_localized = Localize(description)
  
  if not values then
    return fmt_localized
  end
  
  local VALUE_LIST = {}
  local n = #values
  for i = 1, n, 1 do
		local value_data = values[i]
		local value_type = value_data.value_type
		local value_fmt = value_data.value_fmt
		local value = value_data.value

		if value_type == "percent" then
			value = math.abs(100 * value)
		elseif value_type == "baked_percent" then
			value = math.abs(100 * (value - 1))
		end

		if value_fmt then
			value = string.format(value_fmt, value)
		end

		VALUE_LIST[i] = value
  end
  
  return string.format(fmt_localized, unpack(VALUE_LIST, 1, n))
end


mod:command("talents", " Talent info", function() 
  mod:dump(SPProfiles[1], "spprof",1)
  local talent_interface = Managers.backend:get_interface("talents")
  local current_talents = talent_interface:get_talents("es_mercenary")
  -- mod:dump(CareerSettings["wh_zealot"], "talents", 1)
  mod:dump(Talents["witch_hunter"][1], "talents", 3)
  -- local test = string.format(Localize(Talents["witch_hunter"][1]["description"]), 3)
  -- mod:echo(test)
  for key, value in pairs(Talents) do 
    mod:echo(key)
    for _, talent in pairs(value) do 
      local nameStatus, nameResponse = pcall(Localize, talent["name"])
      if nameStatus then
        mod:echo(nameResponse)
        -- mod:echo("%s", getTalentDescription(talent["description"], talent["description_values"]))
        mod:echo("%s", UIUtils.format_localized_description(talent["description"], talent["description_values"]))
      end
      
    end
    return
  end
end)

-- <talent>
-- [icon] = victor_witchhunter_power_level_unbalance (string)
-- [buffer] = server (string)
-- [description_values] = table
--   [1] = table
--     [value_type] = percent (string)
--     [value] = 0.074999999999999997 (number)
-- [buffs] = table
--   [1] = power_level_unbalance (string)
-- [row] = 3 (number)
-- [coulumn] = 3 (number)
-- [buff_data] = table
-- [num_ranks] = 1 (number)
-- [tree] = 3 (number)
-- [requirements] = table
-- [name] = victor_witchhunter_power_level_unbalance (string)
-- [description] = power_level_unbalance_desc (string)
-- </talent>
-- [MOD][ranaldDump][ECHO] <victor_placeholder>
-- <talent>
-- [name] = victor_placeholder (string)
-- [description] = victor_placeholder (string)
-- </talent>

mod:command("career", " Career info", function() 
  mod:dump(ItemMasterList, "career", 5)
end)

mod:command("heros", " Dump Hero Info", function() 
  
  for name, settings in pairs(CareerSettings) do 
    if name ~= "empire_soldier_tutorial" then 
      local career = {}
      career["id"] = 1
      career["name"] = Localize(settings.profile_name)
      career["codeName"] = name
      career["health"] = settings.attributes.max_hp
      career["passive"] = {
        name = Localize(settings.passive_ability.display_name),
        description = Localize(settings.passive_ability.description)
      }
      mod:echo("%s",cjson.encode(career))
      mod:dump(settings.passive_ability.perks, "perks",5)
    end 
    
    
    
    -- mod:echo(name)
    -- mod:echo(Localize(settings.profile_name))
    -- mod:echo(settings.display_name)
    -- mod:echo(settings.description)
    -- mod:echo(settings.attributes)
    -- mod:echo(settings.activated_ability)
    -- mod:echo(settings.passive_ability)
    
  end 
end)


-- 2 activated abilities ?? but same
-- [activated_ability] = table
--     [1] = table
--       [ability_class] = table
--       [icon] = kerillian_shade_activated_ability (string)
--       [cooldown] = 60 (number)
--       [display_name] = career_active_name_we_1 (string)
--       [description] = career_active_desc_we_1_2 (string)
--     [2] = table
--       [ability_class] = table
--       [icon] = kerillian_shade_activated_ability (string)
--       [cooldown] = 60 (number)
--       [display_name] = career_active_name_we_1 (string)
--       [description] = career_active_desc_we_1_2 (string)




mod:command("ranald", " Dump ranald info", function () 
  -- mod:dump(CareerSettings, "Career", 1)
  -- mod:dump(TalentTrees, "Talents", 3)
  mod:dump(Talents, "talents", 5)
  mod:echo(cjson.encode(Talents))

  local file = io.open(string.format("%s%s", out_dir, filename),"w+")
  file:write(cjson.encode(Talents))
  file:close() 
  -- local characters = {}
  -- for _, profile_index in ipairs(ProfilePriority) do
  --   local profile = SPProfiles[profile_index]
  --   characters[profile.display_name] = {
  --     character_name = profile.character_name,
  --     ingame_display_name = profile.ingame_display_name,
  --     ingame_short_display_name = profile.ingame_short_display_name
  --   }
  --   mod:echo(cjson.encode(profile.character_name))
  --   mod:echo(profile.ingame_display_name)
  --   mod:echo(profile.ingame_short_display_name)
  -- end
  
  mod:dump(characters, "table", 5)
  -- for name, settings in pairs(CareerSettings) do
  --   if (name ~= "empire_soldier_tutorial") then
  --     mod:echo("Generating strings for: %s", name)
  --     mod:echo(settings.display_name)
  --     mod:echo(settings.ingame_display_name)
  --   end
  -- end
end) 
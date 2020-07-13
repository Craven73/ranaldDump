local mod = get_mod("ranaldDump")

local locale_code = Application.user_setting("language_id")
local out_dir = "C:\\Users\\craven\\dev\\dump\\"



local function tableContains(table, key) 
  return table[key] ~= nil
end 

local function tableSize(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end


mod:command("talents", " Talent info", function() 
  mod:dump(SPProfiles[1], "spprof",1)
  local talent_interface = Managers.backend:get_interface("talents")
  local current_talents = talent_interface:get_talents("es_mercenary")
  -- mod:dump(CareerSettings["wh_zealot"], "talents", 1)
  mod:dump(Talents["witch_hunter"][1], "talents", 3)
  local test = string.format(Localize(Talents["witch_hunter"][1]["description"]), 3)
  mod:echo(test)
  for key, value in pairs(Talents) do 
    mod:echo(key)
    for _, talent in pairs(value) do 
      if tableContains(talent, "description_values") then
        mod:echo(tableSize(talent["description_values"]))
      end
    end
    mod:dump(Talents[key], "talents", 3)
  end



  talents = {}
  -- for key, values in pairs(Talents) do 
  --   mod:echo(key)
  --   for _, talent in ipairs(values) do
  --     talents[Localize(talent.name)] = talent.description
  --     -- mod:echo(Localize(talent.name))
  --     -- mod:echo(Localize(talent.description))
  --   end
  -- end
  -- mod:echo(cjson.encode(talents))
end)




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
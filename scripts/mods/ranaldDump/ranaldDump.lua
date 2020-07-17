local mod = get_mod("ranaldDump")

local locale_code = Application.user_setting("language_id")
local out_dir = "C:\\Users\\craven\\dev\\dump\\"

local heroOrder = {
  [1] = "es_mercenary",
  [2] = "es_huntsman",
  [3] = "es_knight",
  [4] = "es_questingknight",
  [5] = "dr_ranger",
  [6] = "dr_ironbreaker",
  [7] = "dr_slayer",
  [8] = "dr_holder",
  [9] = "we_waywatcher",
  [10] = "we_maidenguard",
  [11] = "we_shade",
  [12] = "we_holder",
  [13] = "wh_captain",
  [14] = "wh_bountyhunter",
  [15] = "wh_zealot",
  [16] = "wh_holder",
  [17] = "bw_adept",
  [18] = "bw_scholar",
  [19] = "bw_unchained",
  [20] = "bw_holder" 
}
local heroId = {
  ["es_mercenary"] = 1,
  ["es_huntsman"] = 2,
  ["es_knight"] = 3,
  ["es_questingknight"] = 16,
  ["dr_ranger"] = 4,
  ["dr_ironbreaker"] = 5,
  ["dr_slayer"] = 6,
  ["dr_holder"] = 17,
  ["we_waywatcher"] = 7,
  ["we_maidenguard"] = 8,
  ["we_shade"] = 9,
  ["we_holder"] = 18,
  ["wh_captain"] = 10,
  ["wh_bountyhunter"] = 11,
  ["wh_zealot"] = 12,
  ["wh_holder"] = 19,
  ["bw_adept"] = 13,
  ["bw_scholar"] = 14,
  ["bw_unchained"] = 15,
  ["bw_holder"] = 20
}


local function tableContains(table, key) 
  return table[key] ~= nil
end 

-- Apparently # accomplishes this
local function tableSize(table)
  local count = 0
  for _ in pairs(table) do count = count + 1 end
  return count
end

local function getTalentDescription()
  talents = {}
  for key, value in pairs(Talents) do 
    for _, talent in pairs(value) do 
      local nameStatus, nameResponse = pcall(Localize, talent["name"])
      if nameStatus then
        talents[talent["name"]] = {
          description = UIUtils.format_localized_description(talent["description"], talent["description_values"])
        }
        
      end
      
    end
  end
  return talents
end

mod:command("heroes", " Dump Hero Info", function() 

  talentDescriptions = getTalentDescription()

  local heroInfo = {}
  
  for name, settings in pairs(CareerSettings) do 
    if heroId[name] ~= nil then 
      local career = {}
      career["id"] = heroId[name]
      career["name"] = Localize(name)
      career["codeName"] = name
      career["health"] = settings.attributes.max_hp
      career["passive"] = {
        name = Localize(settings.passive_ability.display_name),
        description = Localize(settings.passive_ability.description)
      }
      career["skill"] = {
        name = Localize(settings.activated_ability[1].display_name),
        description = Localize(settings.activated_ability[1].description),
        cooldown = settings.activated_ability[1].cooldown
      }
      perks = {} 
      local numPerks = #settings.passive_ability.perks
      for i = 1, numPerks, 1 do
        perks[i] = {
          name = Localize(settings.passive_ability.perks[i].display_name),
          description = Localize(settings.passive_ability.perks[i].description)
        }
      end

      career["perks"] = perks


      local count = 1
      local allTalents = {}
      for row,talents in pairs(TalentTrees[settings.profile_name][settings.talent_tree_index]) do 
        for _,talent in pairs(talents) do 
          allTalents[count] = {
            name = Localize(talent),
            description = talentDescriptions[talent]["description"]
          }
          count = count + 1
        end
      end

      career["talents"] = allTalents
      heroInfo[name] = career
      -- mod:echo("%s",cjson.encode(career))
    end
    
  end 

  mod:echo("%s", cjson.encode(heroInfo))
  local file = io.open(string.format("%s%s", out_dir, "heros.js"),"w+")
  file:write("[")
  local numHeroes = #heroOrder
  for i = 1, numHeroes, 1 do
    file:write(cjson.encode(heroInfo[heroOrder[i]]))
    file:write(",")
  end
  file:write("]")
  
  file:close() 
end)



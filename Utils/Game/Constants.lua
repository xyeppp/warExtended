local warExtended   = warExtended
local windowLayers  = Window.Layers

local fontList      = {
  "font_chat_text",
  "font_alert_outline_giant",
  "font_alert_outline_gigantic",
  "font_alert_outline_half_giant",
  "font_alert_outline_half_gigantic",
  "font_alert_outline_half_huge",
  "font_alert_outline_half_large",
  "font_alert_outline_half_medium",
  "font_alert_outline_half_small",
  "font_alert_outline_half_tiny",
  "font_alert_outline_huge",
  "font_alert_outline_large",
  "font_alert_outline_medium",
  "font_alert_outline_small",
  "font_alert_outline_tiny",
  "font_chat_text",
  "font_chat_text_bold",
  "font_chat_text_no_outline",
  "font_clear_default",
  "font_clear_large",
  "font_clear_large_bold",
  "font_clear_medium",
  "font_clear_medium_bold",
  "font_clear_small",
  "font_clear_small_bold",
  "font_clear_tiny",
  "font_default_heading",
  "font_default_medium_heading",
  "font_default_sub_heading",
  "font_default_sub_heading_no_outline",
  "font_default_text",
  "font_default_text_giant",
  "font_default_text_gigantic",
  "font_default_text_huge",
  "font_default_text_large",
  "font_default_text_no_outline",
  "font_default_text_small",
  "font_default_war_heading",
  "font_guild_MP_R_17",
  "font_guild_MP_R_19",
  "font_guild_MP_R_23",
  "font_heading_20pt_no_shadow",
  "font_heading_22pt_no_shadow",
  "font_heading_big_noshadow",
  "font_heading_default",
  "font_heading_default_no_shadow",
  "font_heading_huge",
  "font_heading_huge_no_shadow",
  "font_heading_huge_noshadow",
  "font_heading_large",
  "font_heading_large_noshadow",
  "font_heading_medium",
  "font_heading_medium_noshadow",
  "font_heading_rank",
  "font_heading_small_no_shadow",
  "font_heading_target_mouseover_name",
  "font_heading_tiny_no_shadow",
  "font_heading_unitframe_con",
  "font_heading_unitframe_large_name",
  "font_heading_zone_name_no_shadow",
  "font_journal_body",
  "font_journal_body_large",
  "font_journal_heading",
  "font_journal_heading_smaller",
  "font_journal_small_heading",
  "font_journal_sub_heading",
  "font_journal_text",
  "font_journal_text_huge",
  "font_journal_text_italic",
  "font_journal_text_large"
}

local textAligns    = {
  "left",
  "leftcenter",
  "bottomleft",
  "top",
  "center",
  "bottom",
  "right",
  "rightcenter",
  "bottomright"
}

local windowAnchors = {
  "topleft",
  "left",
  "bottomleft",
  "top",
  "center",
  "bottom",
  "topright",
  "right",
  "bottomright"
}

local keepIdList    = {
  ["Dok Karaz"] = 1,
  ["Fangbreaka Swamp"] = 2,
  ["Gnol Baraz"] = 3,
  ["Thickmuck Pit"] = 4,
  ["Karaz Drengi"] = 5,
  ["Kazad Dammaz"] = 6,
  ["Bloodfist Rock"] = 7,
  ["Karak Karag"] = 8,
  ["Ironskin Skar"] = 9,
  ["Badmoon Hole"] = 10,
  ["Mandred's Hold"] = 11,
  ["Stonetroll Keep"] = 12,
  ["Passwatch Castle"] = 13,
  ["Stoneclaw Castle"] = 14,
  ["Wilhelm's Fist"] = 15,
  ["Morr's Repose"] = 16,
  ["Southern Garrison"] = 17,
  ["Garrison of Skulls"] = 18,
  ["Zimmeron's Hold"] = 19,
  ["Charon's Keep"] = 20,
  ["Cascades of Thunder"] = 21,
  ["Spite's Reach "] = 22,
  ["The Well of Qhaysh"] = 23,
  ["Ghrond's Sacristy"] = 24,
  ["Arbor of Light"] = 25,
  ["Pillars of Remembrance"] = 26,
  ["Covenant of Flame"] = 27,
  ["Drakebreaker's Scrouge"] = 28,
  ["Hatred's Way"] = 29,
  ["Wrath's Resolve"] = 30,
}

function warExtended.GetKeepIdList()
  return keepIdList
end

function warExtended.GetWindowAnchors()
  return windowAnchors
end

function warExtended.GetTextAligns()
  return textAligns
end

function warExtended.GetWindowLayers()
  return windowLayers
end

function warExtended.GetFontList()
  return fontList
end
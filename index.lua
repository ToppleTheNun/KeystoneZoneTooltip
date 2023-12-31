local line_added = false
local font_color = "|cffffffff"
local zone_prefix = "Zone: "

local keystone_zone_mapping = {
	-- DF S3
	["168"] = "Gorgrond", -- The Everbloom
	["198"] = "Val'sharah", -- Darkheart Thicket
	["199"] = "Val'sharah", -- Blackrook Hold
	["244"] = "Zuldazar", -- Atal'dazar
	["248"] = "Drustvar", -- Waycrest Manor
	["456"] = "Vashj'ir", -- Throne of the Tides
	["463"] = "Thaldrazus", -- Dawn of the Infinite: Galakrond's Fall
	["464"] = "Thaldrazus" -- Dawn of the Infinite: Murozond's Rise
}

local function GetItemString(parent_string)
	return string.match(parent_string, "keystone[%-?%d:]+")
end

local function GetKeyLevel(parent_string)
	local key_level, _ = select(3, strsplit(":", parent_string))
	return key_level
end

local function OnTooltipSetItem(tooltip)
	local _, link = GameTooltip:GetItem()

	if (link == nil) then return end

	for item_link in link:gmatch("|%x+|Hkeystone:.-|h.-|h|r") do
		local item_string = GetItemString(item_link)
		local mlvl = GetKeyLevel(item_string)
		local zone = keystone_zone_mapping[mlvl]

		if not line_added and zone then
			tooltip:AddLine(font_color .. zone_prefix .. zone)
		end
	end
end

local function OnTooltipCleared()
	line_added = false
end


local function SetHyperlink_Hook(_, hyperlink, _, _)
	local item_string = GetItemString(hyperlink)
	if item_string == nil or item_string == "" then return end
	if strsplit(":", item_string) == "keystone" then
		local mlvl = GetKeyLevel(item_string)
		local zone = keystone_zone_mapping[mlvl]
		if zone then
			ItemRefTooltip:AddLine(font_color .. zone_prefix .. mlvl)
			ItemRefTooltip:Show()
		end
	end
end

GameTooltip:HookScript("OnTooltipCleared", OnTooltipCleared)
hooksecurefunc("ChatFrame_OnHyperlinkShow", SetHyperlink_Hook)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)

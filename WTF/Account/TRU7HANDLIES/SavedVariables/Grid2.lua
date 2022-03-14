
Grid2DB = {
	["namespaces"] = {
		["LibDualSpec-1.0"] = {
		},
		["Grid2Layout"] = {
			["profiles"] = {
				["Thartuk - Area 52"] = {
					["PosY"] = -247.9999163317698,
					["PosX"] = 487.1999109852332,
					["minimapIcon"] = {
						["hide"] = true,
					},
					["extraThemes"] = {
						{
							["BackgroundTexture"] = "None",
							["BorderB"] = 0.5019607843137255,
							["layouts"] = {
								["raid"] = "By Group",
								["party"] = "By Group",
								["solo"] = "By Group",
								["arena"] = "By Group",
							},
							["BackgroundR"] = 0.1019607843137255,
							["ScaleSize"] = 1,
							["FrameDisplay"] = "Always",
							["BorderA"] = 0,
							["BorderR"] = 0.5019607843137255,
							["Spacing"] = 10,
							["anchor"] = "TOPLEFT",
							["clamp"] = true,
							["groupAnchor"] = "TOPLEFT",
							["PosY"] = -193.0665581846261,
							["FrameLock"] = false,
							["BackgroundB"] = 0.1019607843137255,
							["BackgroundA"] = 0,
							["Padding"] = 0,
							["BorderG"] = 0.5019607843137255,
							["BorderTexture"] = "Blizzard Chat Bubble",
							["horizontal"] = false,
							["BackgroundG"] = 0.1019607843137255,
							["PosX"] = 367.7337417805102,
						}, -- [1]
						{
							["BackgroundTexture"] = "None",
							["BorderB"] = 0.5019607843137255,
							["layouts"] = {
								["arena"] = "By Group",
								["raid"] = "By Group",
								["solo"] = "By Group",
								["party"] = "By Group",
							},
							["BackgroundR"] = 0.1019607843137255,
							["ScaleSize"] = 1,
							["FrameLock"] = false,
							["BorderA"] = 0,
							["BorderR"] = 0.5019607843137255,
							["Spacing"] = 10,
							["anchor"] = "TOPLEFT",
							["clamp"] = true,
							["groupAnchor"] = "TOPLEFT",
							["PosY"] = -225.0665574693703,
							["PosX"] = 367.7337027180111,
							["BackgroundG"] = 0.1019607843137255,
							["BackgroundA"] = 0,
							["horizontal"] = false,
							["BorderG"] = 0.5019607843137255,
							["BorderTexture"] = "Blizzard Chat Bubble",
							["Padding"] = 0,
							["BackgroundB"] = 0.1019607843137255,
							["FrameDisplay"] = "Always",
						}, -- [2]
					},
				},
			},
		},
		["Grid2AoeHeals"] = {
		},
		["Grid2Options"] = {
		},
		["Grid2RaidDebuffs"] = {
		},
		["Grid2Frame"] = {
			["profiles"] = {
				["Thartuk - Area 52"] = {
					["extraThemes"] = {
						{
							["frameColor"] = {
								["a"] = 0.8653839528560638,
								["r"] = 0,
								["g"] = 0,
								["b"] = 0,
							},
							["fontSize"] = 11,
							["frameBorder"] = 2,
							["iconSize"] = 14,
							["mouseoverTexture"] = "Blizzard Garrison Background 3",
							["frameBorderDistance"] = 1,
							["frameHeight"] = 51,
							["barTexture"] = "Grid2 Flat",
							["frameBorderTexture"] = "Grid2 Flat",
							["frameWidths"] = {
							},
							["mouseoverHighlight"] = true,
							["mouseoverColor"] = {
								["a"] = 1,
								["r"] = 1,
								["g"] = 1,
								["b"] = 1,
							},
							["orientation"] = "HORIZONTAL",
							["frameHeights"] = {
							},
							["frameContentColor"] = {
								["a"] = 1,
								["r"] = 0,
								["g"] = 0,
								["b"] = 0,
							},
							["frameWidth"] = 100,
							["frameTexture"] = "Grid2 Flat",
						}, -- [1]
						{
							["frameColor"] = {
								["a"] = 0.8653839528560638,
								["b"] = 0,
								["g"] = 0,
								["r"] = 0,
							},
							["fontSize"] = 11,
							["frameBorder"] = 2,
							["iconSize"] = 14,
							["mouseoverTexture"] = "Blizzard Garrison Background 3",
							["frameBorderDistance"] = 1,
							["frameHeight"] = 38,
							["barTexture"] = "Grid2 Flat",
							["mouseoverColor"] = {
								["a"] = 1,
								["b"] = 1,
								["g"] = 1,
								["r"] = 1,
							},
							["frameWidths"] = {
							},
							["frameTexture"] = "Grid2 Flat",
							["mouseoverHighlight"] = true,
							["frameBorderTexture"] = "Grid2 Flat",
							["orientation"] = "HORIZONTAL",
							["frameContentColor"] = {
								["a"] = 1,
								["b"] = 0,
								["g"] = 0,
								["r"] = 0,
							},
							["frameWidth"] = 55,
							["frameHeights"] = {
							},
						}, -- [2]
					},
				},
			},
		},
	},
	["profileKeys"] = {
		["Thartuk - Area 52"] = "Thartuk - Area 52",
	},
	["profiles"] = {
		["Thartuk - Area 52"] = {
			["indicators"] = {
				["corner-top-left"] = {
					["type"] = "text",
					["fontSize"] = 8,
					["level"] = 9,
					["location"] = {
						["y"] = 0,
						["relPoint"] = "TOPLEFT",
						["point"] = "TOPLEFT",
						["x"] = 0,
					},
					["duration"] = true,
					["textlength"] = 12,
					["font"] = "Friz Quadrata TT",
				},
				["side-top"] = {
					["type"] = "text",
					["fontSize"] = 8,
					["level"] = 9,
					["location"] = {
						["y"] = 0,
						["relPoint"] = "TOP",
						["point"] = "TOP",
						["x"] = 0,
					},
					["duration"] = true,
					["textlength"] = 12,
					["font"] = "Friz Quadrata TT",
				},
				["corner-bottom-right"] = {
					["type"] = "icon",
					["location"] = {
						["y"] = 0,
						["relPoint"] = "BOTTOMRIGHT",
						["point"] = "BOTTOMRIGHT",
						["x"] = 0,
					},
					["level"] = 8,
					["fontSize"] = 8,
					["size"] = 12,
				},
				["text-down"] = {
					["type"] = "text",
					["location"] = {
						["y"] = 4,
						["relPoint"] = "BOTTOM",
						["point"] = "BOTTOM",
						["x"] = 0,
					},
					["level"] = 6,
					["textlength"] = 6,
					["fontSize"] = 10,
				},
				["icon-left"] = {
					["type"] = "icon",
					["location"] = {
						["y"] = 0,
						["relPoint"] = "LEFT",
						["point"] = "LEFT",
						["x"] = -2,
					},
					["level"] = 8,
					["fontSize"] = 8,
					["size"] = 12,
				},
				["border"] = {
					["type"] = "border",
					["color1"] = {
						["a"] = 0,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
				},
				["corner-top-right-color"] = {
					["type"] = "text-color",
				},
				["Role"] = {
					["type"] = "icon",
					["location"] = {
						["y"] = 0,
						["relPoint"] = "TOPLEFT",
						["point"] = "TOPLEFT",
						["x"] = 0,
					},
					["level"] = 8,
					["fontSize"] = 8,
					["size"] = 16,
				},
				["text-down-color"] = {
					["type"] = "text-color",
				},
				["side-top-color"] = {
					["type"] = "text-color",
				},
				["icon-center"] = {
					["type"] = "icon",
					["location"] = {
						["y"] = 0,
						["relPoint"] = "CENTER",
						["point"] = "CENTER",
						["x"] = 0,
					},
					["level"] = 8,
					["fontSize"] = 8,
					["size"] = 14,
				},
				["health-color"] = {
					["type"] = "bar-color",
				},
				["test-color"] = {
					["type"] = "bar-color",
				},
				["icon-right"] = {
					["type"] = "icon",
					["location"] = {
						["y"] = 0,
						["relPoint"] = "RIGHT",
						["point"] = "RIGHT",
						["x"] = 2,
					},
					["level"] = 8,
					["fontSize"] = 8,
					["size"] = 12,
				},
				["heals-color"] = {
					["type"] = "bar-color",
				},
				["tooltip"] = {
					["type"] = "tooltip",
					["showDefault"] = false,
					["showTooltip"] = 4,
				},
				["alpha"] = {
					["type"] = "alpha",
				},
				["HealthGray-color"] = {
					["type"] = "bar-color",
				},
				["text-up"] = {
					["type"] = "text",
					["location"] = {
						["y"] = -8,
						["relPoint"] = "TOP",
						["point"] = "TOP",
						["x"] = 0,
					},
					["level"] = 7,
					["textlength"] = 6,
					["fontSize"] = 8,
				},
				["health"] = {
					["height"] = 46,
					["type"] = "bar",
					["location"] = {
						["y"] = 0,
						["relPoint"] = "CENTER",
						["point"] = "CENTER",
						["x"] = 0,
					},
					["level"] = 2,
					["texture"] = "Grid2 Flat",
					["color1"] = {
						["a"] = 1,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
				},
				["heals"] = {
					["type"] = "bar",
					["texture"] = "Gradient",
					["anchorTo"] = "health",
					["location"] = {
						["y"] = 0,
						["relPoint"] = "CENTER",
						["point"] = "CENTER",
						["x"] = 0,
					},
					["level"] = 1,
					["opacity"] = 0.25,
					["color1"] = {
						["a"] = 0,
						["r"] = 0,
						["g"] = 0,
						["b"] = 0,
					},
				},
				["corner-bottom-left"] = {
					["type"] = "square",
					["location"] = {
						["y"] = 0,
						["relPoint"] = "BOTTOMLEFT",
						["point"] = "BOTTOMLEFT",
						["x"] = 0,
					},
					["level"] = 5,
					["size"] = 5,
					["color1"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 1,
						["b"] = 1,
					},
				},
				["text-up-color"] = {
					["type"] = "text-color",
				},
				["corner-top-left-color"] = {
					["type"] = "text-color",
				},
				["corner-top-right"] = {
					["type"] = "text",
					["fontSize"] = 8,
					["level"] = 9,
					["location"] = {
						["y"] = 0,
						["relPoint"] = "TOPRIGHT",
						["point"] = "TOPRIGHT",
						["x"] = 0,
					},
					["duration"] = true,
					["textlength"] = 12,
					["font"] = "Friz Quadrata TT",
				},
			},
			["statuses"] = {
				["debuff-Forbearance"] = {
					["type"] = "debuff",
					["spellName"] = 25771,
					["color1"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 0,
						["b"] = 0,
					},
				},
				["buff-DivineProtection-mine"] = {
					["spellName"] = 498,
					["type"] = "buff",
					["mine"] = true,
					["color1"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 1,
						["b"] = 1,
					},
				},
				["buff-BeaconOfLight-mine"] = {
					["spellName"] = 53563,
					["type"] = "buff",
					["mine"] = true,
					["color1"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 1,
						["b"] = 1,
					},
				},
				["buff-HandOfProtection-mine"] = {
					["spellName"] = 1022,
					["type"] = "buff",
					["mine"] = true,
					["color1"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 1,
						["b"] = 1,
					},
				},
				["buff-HandOfSalvation"] = {
					["type"] = "buff",
					["spellName"] = 1038,
					["color1"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 1,
						["b"] = 1,
					},
				},
				["buff-BeaconOfLight"] = {
					["type"] = "buff",
					["spellName"] = 53563,
					["color1"] = {
						["a"] = 1,
						["r"] = 0.7,
						["g"] = 1,
						["b"] = 1,
					},
				},
				["health-current"] = {
					["quickHealth"] = true,
					["color1"] = {
						["r"] = 0.05098039215686274,
						["g"] = 0.05098039215686274,
						["b"] = 0.05098039215686274,
					},
				},
				["buff-DivineShield-mine"] = {
					["spellName"] = 642,
					["type"] = "buff",
					["mine"] = true,
					["color1"] = {
						["a"] = 1,
						["r"] = 1,
						["g"] = 1,
						["b"] = 1,
					},
				},
				["buff-HandOfSalvation-mine"] = {
					["spellName"] = 1038,
					["type"] = "buff",
					["mine"] = true,
					["color1"] = {
						["a"] = 1,
						["r"] = 0.8,
						["g"] = 0.8,
						["b"] = 0.7,
					},
				},
			},
			["versions"] = {
				["Grid2"] = 6,
				["Grid2RaidDebuffs"] = 4,
			},
			["statusMap"] = {
				["corner-top-left"] = {
					["buff-BeaconOfLight"] = 99,
					["buff-BeaconOfLight-mine"] = 89,
				},
				["side-top"] = {
					["buff-FlashOfLight-mine"] = 99,
				},
				["corner-bottom-right"] = {
					["debuff-Forbearance"] = 99,
				},
				["text-down"] = {
					["name"] = 99,
				},
				["icon-left"] = {
					["raid-icon-player"] = 155,
				},
				["border"] = {
					["debuff-Disease"] = 90,
					["health-low"] = 55,
					["debuff-Poison"] = 80,
					["target"] = 50,
					["debuff-Magic"] = 70,
					["debuff-Curse"] = 60,
				},
				["corner-top-right-color"] = {
					["buff-DivineShield-mine"] = 97,
					["buff-DivineProtection-mine"] = 95,
					["buff-HandOfProtection-mine"] = 93,
				},
				["Role"] = {
					["dungeon-role"] = 51,
				},
				["text-down-color"] = {
					["classcolor"] = 99,
				},
				["side-top-color"] = {
					["buff-FlashOfLight-mine"] = 99,
				},
				["icon-center"] = {
					["ready-check"] = 150,
					["raid-debuffs"] = 155,
					["death"] = 155,
				},
				["health-color"] = {
					["health-current"] = 50,
				},
				["corner-top-right"] = {
					["buff-DivineShield-mine"] = 97,
					["buff-DivineProtection-mine"] = 95,
					["buff-HandOfProtection-mine"] = 93,
				},
				["heals-color"] = {
					["classcolor"] = 99,
				},
				["tooltip"] = {
					["name"] = 50,
				},
				["alpha"] = {
					["offline"] = 97,
					["range"] = 99,
					["death"] = 98,
				},
				["health"] = {
					["health-current"] = 50,
				},
				["text-up"] = {
					["charmed"] = 65,
					["feign-death"] = 96,
					["health-deficit"] = 50,
					["offline"] = 93,
					["death"] = 95,
					["vehicle"] = 70,
				},
				["corner-bottom-left"] = {
					["threat"] = 99,
					["buff-HandOfSalvation-mine"] = 100,
					["buff-HandOfSalvation"] = 101,
				},
				["text-up-color"] = {
					["charmed"] = 65,
					["feign-death"] = 96,
					["health-deficit"] = 50,
					["offline"] = 93,
					["death"] = 95,
					["vehicle"] = 70,
				},
				["corner-top-left-color"] = {
					["buff-BeaconOfLight"] = 99,
					["buff-BeaconOfLight-mine"] = 89,
				},
				["heals"] = {
					["heals-incoming"] = 99,
				},
			},
			["themes"] = {
				["enabled"] = {
					["party"] = 1,
					["default"] = 1,
					["raid"] = 2,
				},
				["indicators"] = {
					{
					}, -- [1]
					{
					}, -- [2]
					[0] = {
					},
				},
				["names"] = {
					"Party", -- [1]
					"Raid", -- [2]
				},
			},
		},
	},
}

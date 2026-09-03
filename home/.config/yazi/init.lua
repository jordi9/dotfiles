require("zoxide"):setup {
  update_db = true,
}

require("git"):setup {
	-- Order of status signs showing in the linemode
	order = 1500,
}

local rose_pine_theme = require("yatline-rosepine"):setup("moon")
local tokyo_night_theme = require("yatline-tokyo-night"):setup("night") -- or moon/storm/day


local yatline = require("yatline")

-- Yatline still uses the deprecated File:icon() API for this component.
function Yatline.string.get:hovered_file_extension(show_icon)
	local hovered = cx.active.current.hovered
	if not hovered then
		return ""
	end

	local name = hovered.cha.is_dir and "dir" or hovered.url.name:match("^.+%.(.+)$") or "null"
	if not show_icon then
		return name
	end

	local icon = th.icon:match(hovered)
	return icon and icon.text .. " " .. name or name
end

yatline:setup({
	theme = tokyo_night_theme,
	header_line = {
		left = {
			section_a = {
	      {type = "line", custom = false, name = "tabs", params = {"left"}},
			},
			section_b = {
				{type = "coloreds", custom = false, name = "githead"},
			}
		},
		right = {
			section_a = {
	      {type = "coloreds", custom = true, name = {{" 󰇥 ", "#3c3836"}}},
			},
			section_c = {
	      {type = "coloreds", custom = false, name = "count"},
			}
		}
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", name = "tab_mode" },
			},
			section_b = {
				{ type = "string", name = "hovered_size" },
			},
			section_c = {
				{ type = "string", name = "hovered_name" },
			},
		},
		right = {
			section_a = {
				{ type = "string", name = "cursor_position" },
			},
			section_b = {
				{ type = "string", name = "cursor_percentage" },
			},
			section_c = {
				{ type = "string", name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", name = "permissions" },
			},
		},
	},

})

require("yatline-githead"):setup()

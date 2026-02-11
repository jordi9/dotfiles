-- Extended video spotter with rich metadata from ffprobe
local M = {}

local function format_duration(secs)
	secs = tonumber(secs) or 0
	local h = math.floor(secs / 3600)
	local m = math.floor((secs % 3600) / 60)
	local s = math.floor(secs % 60)
	if h > 0 then
		return string.format("%d:%02d:%02d", h, m, s)
	end
	return string.format("%d:%02d", m, s)
end

local function format_bitrate(bps)
	bps = tonumber(bps) or 0
	if bps >= 1000000 then
		return string.format("%.1f Mbps", bps / 1000000)
	elseif bps >= 1000 then
		return string.format("%.0f kbps", bps / 1000)
	end
	return string.format("%d bps", bps)
end

local function format_size(bytes)
	bytes = tonumber(bytes) or 0
	if bytes >= 1073741824 then
		return string.format("%.2f GB", bytes / 1073741824)
	elseif bytes >= 1048576 then
		return string.format("%.1f MB", bytes / 1048576)
	end
	return string.format("%.0f KB", bytes / 1024)
end

local function format_framerate(r)
	if not r or r == "0/0" then return nil end
	local num, den = r:match("(%d+)/(%d+)")
	if num and den and tonumber(den) > 0 then
		return string.format("%.2f fps", tonumber(num) / tonumber(den))
	end
	return r
end

function M:spot(job)
	local entries = "format=duration,size,bit_rate"
		.. ":stream=codec_name,codec_type,width,height,r_frame_rate,channels,sample_rate,pix_fmt,color_space,bit_rate"

	local output, err = Command("ffprobe")
		:arg({ "-v", "quiet", "-show_entries", entries, "-of", "json=c=1", tostring(job.file.path) })
		:output()

	if not output then
		ya.err("ffprobe failed: " .. tostring(err))
		return
	end

	local meta = ya.json_decode(output.stdout)
	if not meta then return end

	meta.format = meta.format or {}
	meta.streams = meta.streams or {}

	local rows = {}

	-- File info
	rows[#rows + 1] = ui.Row({ "File" }):style(ui.Style():fg("green"):bold())
	rows[#rows + 1] = ui.Row({ "  Duration:", format_duration(meta.format.duration) })
	rows[#rows + 1] = ui.Row({ "  Size:", format_size(meta.format.size) })
	if meta.format.bit_rate then
		rows[#rows + 1] = ui.Row({ "  Bitrate:", format_bitrate(meta.format.bit_rate) })
	end
	rows[#rows + 1] = ui.Row({})

	for i, s in ipairs(meta.streams) do
		if s.codec_type == "video" then
			rows[#rows + 1] = ui.Row({ string.format("Video #%d", i) }):style(ui.Style():fg("cyan"):bold())
			rows[#rows + 1] = ui.Row({ "  Codec:", s.codec_name or "?" })
			rows[#rows + 1] = ui.Row({ "  Resolution:", string.format("%dx%d", s.width or 0, s.height or 0) })
			local fps = format_framerate(s.r_frame_rate)
			if fps then rows[#rows + 1] = ui.Row({ "  Framerate:", fps }) end
			if s.pix_fmt then rows[#rows + 1] = ui.Row({ "  Pixel fmt:", s.pix_fmt }) end
			if s.color_space then rows[#rows + 1] = ui.Row({ "  Color:", s.color_space }) end
			if s.bit_rate then rows[#rows + 1] = ui.Row({ "  Bitrate:", format_bitrate(s.bit_rate) }) end
		elseif s.codec_type == "audio" then
			rows[#rows + 1] = ui.Row({})
			rows[#rows + 1] = ui.Row({ string.format("Audio #%d", i) }):style(ui.Style():fg("yellow"):bold())
			rows[#rows + 1] = ui.Row({ "  Codec:", s.codec_name or "?" })
			if s.sample_rate then rows[#rows + 1] = ui.Row({ "  Sample rate:", s.sample_rate .. " Hz" }) end
			if s.channels then rows[#rows + 1] = ui.Row({ "  Channels:", tostring(s.channels) }) end
			if s.bit_rate then rows[#rows + 1] = ui.Row({ "  Bitrate:", format_bitrate(s.bit_rate) }) end
		end
	end

	ya.spot_table(
		job,
		ui.Table(rows)
			:area(ui.Pos({ "center", w = 50, h = #rows + 2 }))
			:row(1)
			:col(1)
			:col_style(th.spot.tbl_col)
			:cell_style(th.spot.tbl_cell)
			:widths({ ui.Constraint.Length(14), ui.Constraint.Fill(1) })
	)
end

return M

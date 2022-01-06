module("ical", package.seeall)

-- http://code.matthewwild.co.uk/lua-ical/

local handler = {};

function handler.VEVENT(ical, line)
	local k,v = line:match("^(.-):(.*)$");
	local curr_event = ical[#ical];
	if k and v then
		local is = k:find(";");
		if (is == nil) then 
			curr_event[k] = v;
		else
			curr_event[k:sub(1,is-1)] = v;
			-- more: ;attr=val
		end
	end
	
	if k == "DTSTAMP" then
		local t = {};
		t.year, t.month, t.day, t.hour, t.min, t.sec = v:match("^(%d%d%d%d)(%d%d)(%d%d)T(%d%d)(%d%d)(%d%d)Z$");
		for k,v in pairs(t) do t[k] = tonumber(v); end
		curr_event.when = os.time(t);
	end
end

function load(data)
	local ical, stack = {}, {};
	local line_num = 0;
	
	-- Parse
	for line in data:gmatch("(.-)[\r\n]+") do
		line_num = line_num + 1;
		if line:match("^BEGIN:") then
			local type = line:match("^BEGIN:(%S+)");
			table.insert(stack, type);
			table.insert(ical, { type = type }); 
		elseif line:match("^END:") then
			if stack[#stack] ~= line:match("^END:(%S+)") then
				return nil, "Parsing error, expected END:"..stack[#stack].." before line "..line_num;
			end
			table.remove(stack);
		elseif handler[stack[#stack]] then
			handler[stack[#stack]](ical, line);
		end
	end
	
	-- Return calendar
	return ical;
end


return _M;

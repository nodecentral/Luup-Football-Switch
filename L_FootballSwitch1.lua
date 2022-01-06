module("L_FootballSwitch1", package.seeall)

luup.log("L_FootballSwitch1.lua file loading..")

local ical = require "ical"
local http = require "socket.http"
local https = require 'ssl.https'
local ltn12 = require "ltn12"
local DEBUG_MODE = true 
local footballCAL = {}
 
local PV = "1.4" -- plugin version number
local COM_SID = "urn:nodecentral-net:serviceId:FootballSwitch1"
local switchServiceId = "urn:upnp-org:serviceId:SwitchPower1"
-- D_FootballSwitch1.xml
 
local deviceId
local events
local lastUpdate

local function log(text, level)
	luup.log("FSP: " .. text, (level or 1))
	end

local function debug(text)
	if (DEBUG_MODE == true) then
		log("debug: " .. text, 50)
	end
end

local function removeMyTeamName(string)
	-- facility to remove the team name so just the opponent is shown
	debug("string = " ..string)
	local myteam = luup.variable_get(COM_SID, "My Team", lul_device)
	debug("myteam = " ..myteam)
	if myteam == "<Enter Team Name As Listed>" then 
		return string
	else
		local word1 --local word1 = "Ipswich Town"
		word1 = myteam
		log("word1 = " ..word1)
		local result1 = string:gsub(word1,"")
		local word2 = "-"
		local result2 = result1:gsub(word2,"")
		debug(result2)
		return result2
	end
end 

function dateCONV(str)
	--debug("dateCONV function called")
	local data = {}
	local y,m,d,h,i,s=str:match"(%d%d%d%d)(%d%d)(%d%d)T(%d%d)(%d%d)(%d+)Z"
	data.year=y data.month=m data.day=d data.hour=h data.min=i data.sec=s
	data.sinceEpoch=os.time(data)
 	return data
end

local function processSchedule(events, lul_device)
	debug("processSchedule function called")
	for i, event in ipairs(events) do
		if (event.type == 'VEVENT') then
			local iCalStart = event["DTSTART"]
			local iCalEnd = event["DTEND"]
			local iCalDuration = event["DURATION"]
			local iCalString = event["SUMMARY"]
			local currentTime = os.time()
			if currentTime <= dateCONV(iCalStart).sinceEpoch then
				table.insert(footballCAL, {dateCONV(iCalStart).sinceEpoch, dateCONV(iCalEnd).sinceEpoch,  iCalString})
			end
		end
	end
	local nextmatchteam = footballCAL[1][3]
	local nextmatchdate = footballCAL[1][1]
	local matchafternextteam = footballCAL[2][3]
	local matchafternextdate = footballCAL[2][1]
	local nextmatchdateHR = os.date( "%d/%m @ %H:%M" , nextmatchdate )
	local uilabel = removeMyTeamName(nextmatchteam) .. " - " .. nextmatchdateHR
	
	luup.variable_set(COM_SID, "UI Label", uilabel, lul_device)
	luup.variable_set(COM_SID, "Next Match Team", nextmatchteam, lul_device)
	luup.variable_set(COM_SID, "Next Match Date", nextmatchdate, lul_device)
	luup.variable_set(COM_SID, "Next Match Date HR", nextmatchdateHR, lul_device)
	luup.variable_set(COM_SID, "Match After Next Team", matchafternextteam, lul_device)
	luup.variable_set(COM_SID, "Match After Next Date", matchafternextdate, lul_device)
	--debug(tdebug (footballCAL, 1))
	--debug(footballCAL[1][1], footballCAL[1][3])
	--debug(footballCAL[2][1], footballCAL[2][3])
end

function FootballSwitchPoller(lul_device)
	debug("FootballSwitch periodic check started")
	calendarUri = luup.variable_get(COM_SID, "calendarUri", lul_device)
	--debug("Call URL = " ..calendarUri)
	--if (lastUpdate == nil or os.time() - lastUpdate > 86400) then
		debug("Call URL = " ..calendarUri)
		local r = {} -- init empty table 
		local res, code, headers, status = https.request{
			url = calendarUri,
			sink = ltn12.sink.table( r )
			}
		debug("status= ".. tostring(status) .. "Res = " .. res .. "Code: " .. code)
		local responseBody = table.concat( r, "" )
		local lastUpdate = os.time()
		if (code == 200) then 
			events = ical.load(responseBody)
		else 
			debug("ERROR: calender check failed (URL)")
		end
		processSchedule(events, lul_device)
	--end
	luup.call_timer("FSPolling", 1, "43200", "", "") -- 12 hours
	luup.log("FootballSwitch periodic check completed")
end

--debug(periodic())

local function checkFootballSwitchSetUp(lul_device)
	log("Checking if Football Switch is configured correctly")
	-- provides the ability to specify the team name so it can be removed in the UI
	if luup.variable_get(COM_SID, "My Team", lul_device) == nil or 
			luup.variable_get(COM_SID, "My Team", lul_device) == "" then
				luup.variable_set(COM_SID, "My Team", "<Enter Team Name As Listed>", lul_device)
	end
	-- check if parent device has an ip address assigned
	calendarUri = luup.variable_get(COM_SID, "calendarUri", lul_device) 
	if calendarUri == nil or calendarUri == "" then -- if not stop and present error message
		luup.task('ERROR: calendarUri is missing',2,'Football Switch',-1)
		log("ERROR: calendarUri missing unable to progress")
		luup.variable_set(COM_SID, "calendarUri", "", lul_device)
		luup.variable_set(COM_SID, "Icon", 2, lul_device) -- present error icon
		luup.set_failure(1,lul_device) --it's failing
	else -- if one is provided, present success message and remove any comm failure variables
		luup.task('calendarUri for Football Switch present, setup continues',4,'Football Switch',-1)
		log("SUCCESS: calendarUri present " ..calendarUri )
		luup.set_failure(0,lul_device) --its working
		luup.variable_set(HA_SER, "CommFailure", nil , lul_device)
		luup.variable_set(HA_SER, "CommFailureTime", nil ,lul_device)
		luup.variable_set(HA_SER, "CommFailureAlarm", nil, lul_device)
		luup.variable_set(COM_SID, "Icon", 1, lul_device)
		luup.variable_set(COM_SID, "LastUpdate", os.time(), lul_device)
		FootballSwitchPoller(lul_device)
		luup.log("FootballSwitch initialisation completed")
	end 
end

function FootballSwitchStartup(lul_device)
	-- friendly name, category details, description provided in Device xml file
	luup.log("FootballSwitch is being initialized")
	luup.variable_set(COM_SID, "Icon", 1, lul_device)
	luup.variable_set(COM_SID, "PluginVersion", PV, lul_device)
	checkFootballSwitchSetUp(lul_device)
end


--luup.log("L_FootballSwitch1.lua file loaded..")
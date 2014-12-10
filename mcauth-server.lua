-- mcauth-server
-- KennethD(C)2014

-- Config --

local AuthIRL = ""
local AuthID = ""
local modemio = "top"

-- Users

local localusers = {
  ken = "Aoe1234",
  cyb = "Aoe1234"
}

--

function clock()
  while true do
    localtime = os.time()
    sleep(.5)
  end
end

function log(string)
  local pref = "["..textutils.formatTime(localtime, true).." "..localtime.."] "
  print(pref..string)
end

function auth(usr, pw)
  if localuser[usr] == pw then
    return true
  elseif localuser[usr] == nil then
    return nil
  else
    return false
  end
end

function server()
  rednet.open(modemio)
  while true do
    local rxIP, rxAUTH = rednet.receive()
    for i in string.gmatch(rxAUTH, "%S") do
      
    local auth = auth(rxAUTH, rxPW)
    if auth == true then
      log("User"..rxAUTH.."authenticated successfully from node"..rxIP)
      rednet.send(rxIP, true)
    elseif auth == nil then
      log("Login attempt at"..rxIP.."with invalid login")
      rednet.send(rxIP, 2)
    else
      log("Invalid login at"..rxIP)
      rednet.send(rxIP, false)
    end
  end
end

shell.run("clear")
log("Server started at IP:"..os.getComputerID())
parallel.waitForAny(server, clock)
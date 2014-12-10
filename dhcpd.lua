local netSubnet = 10.
local netSide = "back"

local srvDir = "/dhcp"
local leaseDir = fs.combine(srvDir, "leases")

function server()
  
  if not fs.exists(leaseDir) then
    fs.makeDir(leaseDir)
  end
  
  while true do
    rxID, msg = rednet.receive()
    local leasePath = fs.combine(leaseDir, rxID..".lease")
    
    if msg == "request" then
      if fs.exists(leasePath) then
        lf = fs.open(leasePath, "r")
        local assigned_ip = lf.readLine()
      else
        local assigned_ip = genIP(netSubnet)
        lf = fs.open(leasePath, "w")
        lf.write(clientIP)
      end
      log(assigned_ip)
      rednet.send(rxID, assigned_ip)

    elseif msg == "renew" then
        local assigned_ip = genIP(netSubnet)
        lf = fs.open(leasePath, "w")
        lf.write(clientIP)
      log(assigned_ip)
      rednet.send(rxID, assigned_ip)
    
    elseif msg == "release" then
      fs.delete(leasePath)
      log("Released IP for client"..rxID)
    end
  end
end

function genIP(subnetPref)
  local generated_ip = tostring(subnetPref).."."..tostring(math.random(1,256))
  local generated_ip = tonumber(generated_ip)
  return(generated_ip)
end

function log(string)
  local pref = "["..textutils.formatTime(localtime, true).." "..localtime.."] "
  logFile = fs.open(fs.combine(srvDir, "dhcpd.log"), "a")
  logFile.write(pref..string)
  print(pref..string)
end

function clock()
  while true do
    localtime = os.time()
    sleep(.5)
  end
end

rednet.open(netSide)
parallel.waitForAny(server, clock)
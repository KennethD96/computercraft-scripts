-- frameDoor Server
-- KennethD 2013

-- A simple program for operating and protecting horizontal Support Frame doors.
-- Also includes a Server for remote terminals. Client can be found here: http://pastebin.com/H3utBkAk
-- Note: Uses bundled cables to communicate with the Frame Motors.

-- os.pullEvent = os.pullEventRaw -- Prevents users from terminating the lock. (Remember to uncomment)

-- Config --

local password = "Derp"
local pwMask = "*"

local doorHold = 10 -- The time in seconds to hold the door before closing.
local doorLength = 3 -- The width of the door in blocks.
local doorSpeed = .4 -- Time in seconds between each pulse.

local outputSide = "back"
local outputOpen = colors.white -- The cable connected to the motors opening side.
local outputClose = colors.black -- This output closes the door.

local modem = "right"
local status = "top" -- This side will output a Redstone signal while the door is open.

-- Lang --

local motd = "Welcome To CUBE Science Facility!"
local pwAccepted = "Access Granted"
local pwDenied = "Access Denied"
local pwEnter = "Password: "

-- Code --

function pw()      
  while true do
    shell.run("clear")
    term.setTextColor(colors.blue)
    term.setCursorPos(2,2)
    print(motd)
    term.setCursorPos(5,5)
    term.setTextColor(colors.white)
    write(pwEnter)

    term.setTextColor(colors.cyan)
    local input = read(pwMask)
              
    if input == password then
      shell.run("clear")
      sleep(.1)
      term.setCursorPos(5,5)
      term.setTextColor(colors.lime)
      print(pwAccepted)
      doorCycle()
     
    else
      shell.run("clear")
      sleep(.1)
      term.setCursorPos(5,5)
      term.setTextColor(colors.red)     
      print(pwDenied)
      sleep(4)
    end
  end
end

function doorCycle()
  rs.setOutput(status, true)

  for i = 1,doorLength do
    rs.setBundledOutput(outputSide, outputOpen)
      sleep(doorSpeed)
    rs.setBundledOutput(outputSide, 0)
      sleep(doorSpeed)
  end
  sleep(doorHold)

  for i = 1, doorLength do
    rs.setBundledOutput(outputSide, outputClose)
      sleep(doorSpeed)
    rs.setBundledOutput(outputSide, 0)
      sleep(doorSpeed)
  end
  rs.setOutput(status, false)
end

function server()
  rednet.open(modem)
  while true do
    local rxIP, rxInput = rednet.receive()
    if rxInput == password then
      rednet.send(rxIP, 1)
      parallel.waitForAny(doorCycle, server)

    elseif rxInput == "motd" then
      rednet.send(rxIP, motd)
    elseif rxInput == "pwEnter" then
      rednet.send(rxIP, pwEnter)
    elseif rxInput == "pwAccepted" then
      rednet.send(rxIP, pwAccepted)
    elseif rxInput == "pwDenied" then
      rednet.send(rxIP, pwDenied)
    elseif rxInput == "pwMask" then
      rednet.send(rxIP, pwMask)   
    else
      rednet.send(rxIP, 2)  
    end
  end
end

shell.run("clear")
parallel.waitForAny(pw, server)
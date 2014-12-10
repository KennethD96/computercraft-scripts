-- frameDoor Client
-- KennethD 2013

-- Server: http://pastebin.com/t3GQvyXX

-- os.pullEvent = os.pullEventRaw -- Prevents users from terminating the lock. (Remember to uncomment)

-- Config --

local serverIP = 107 -- Enter the ID of the server here.
local modem = "top"

-- Code --

rednet.open(modem)

function getUI()
  shell.run("clear")
  sleep(.1)

  rednet.send(serverIP, "motd")
    rxIP, motd = rednet.receive()
    term.setTextColor(colors.blue)
    term.setCursorPos(2,2)
    print(motd)
    
  rednet.send(serverIP, "pwEnter")
    rxIP, pwEnter = rednet.receive()
    term.setTextColor(colors.white)
    term.setCursorPos(5,5)
    write(pwEnter)
    
  rednet.send(serverIP, "pwAccepted")
    rxIP, pwAccepted = rednet.receive()
  rednet.send(serverIP, "pwDenied")
    rxIP, pwDenied = rednet.receive()
  rednet.send(serverIP, "pwMask")
    rxIP, pwMask = rednet.receive()
  term.setTextColor(colors.cyan)
end

function pw()
  while true do
    getUI()
    input = read(pwMask)
    rednet.send(serverIP, input)
    local rxIP, ack = rednet.receive()
    
    if ack == 1 then
      sleep(.1)
      shell.run("clear")
      term.setCursorPos(5,5)
      term.setTextColor(colors.lime)
      print(pwAccepted)
        sleep(5)
    
    elseif ack == 2 then
      sleep(.1)
      shell.run("clear")
      term.setCursorPos(5,5)
      term.setTextColor(colors.red)
      print(pwDenied)
        sleep(5)     
    else
      print("Unknown Error")
      sleep(5)
    end
  end
end

shell.run("clear")
pw()
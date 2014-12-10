-- frameDoor v2 copylol KennethD --

 -- os.pullEvent = os.pullEventRaw
	os.loadAPI("kdAPI")

-- Config --

	local mode = "server"
	local modem = "top"
	
	-- Client Options --
	
	local serverIP = 10
	
	-- Server Options --

	local password = "Derp"
	local pwMask = "*"
  
	local doorHold = 10
	local doorLength = 3
	local doorSpeed = .4

	local outputSide = "back"
	local outputOpen = colors.white
	local outputClose = colors.black
  
	local status = false

-- Lang --

	local motd = "Welcome To CUBE Science Facility!"

	local pwAccepted = "Access Granted"
	local pwDenied = "Access Denied"
	local pwEnter = "Password: "
	
	local errNoMode = "Error: Mode not specified!"

-- Server --

  function clock()
      while true do
        local hour = os.time()
          hour = textutils.formatTime(hour, true)
          local time = os.day().." "..hour
            sleep(30)
      end
  end

    function server()
      while true do

        local rxIP, rxInput = rednet.receive()
          if rxInput == password then
            rednet.send(rxIP, 1)
            print(time.." [INFO] "..pwAccepted.." On: "..rxIP)
              parallel.waitForAny(doorCycle, statusOut)

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
              print(time.." [WARNING] "..pwDenied.." On: "..rxIP)

          end
      end
  end
  
	function Xserver()
		-- Code to come
	end
       

-- Client --

  function client()

	if mode == "server" then
		serverIP = os.computerID()
	end

      while true do
        getX()

        input = read(pwMask)
          rednet.send(serverIP, input)
          local rxIP, ack = rednet.receive()

          if ack == 1 then
              sleep(.1)
            shell.run("clear")
              term.setCursorPos(5,5)
              term.setTextColor(colors.lime)
                print(pwAccepted)
                  sleep(15)

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

  function getX()
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
	   
-- Code --

	rednet.open(modem)

		if tArgs == "server" then
			parallel.waitForAny(clock, server)
		elseif tArgs == "client" then
			client()
		elseif mode == "server" then
			parallel.waitForAny(clock, server)
		elseif mode == "client" then
			client()
		else
			print(errNoMode)
  end

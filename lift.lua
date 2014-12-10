-- lift --

	local outputSide = "back"
	local output1 = colors.blue
	local output2 = colors.red
	
	local distance = 5
	
-- Code --

	tArgs = { ... }
	
	function lift()
		if tArgs[1] == "up" then
		
			for i = 1,distance do
				rs.setBundledOutput(outputSide, output1)
					sleep(.4)
				rs.setBundledOutput(outputSide, 0)
					sleep(.4)
		end
		
		elseif tArgs[1] == "down" then
			
			for i = 1,distance do
				rs.setBundledOutput(outputSide, output2)
					sleep(.4)
				rs.setBundledOutput(outputSide, 0)
					sleep(.4)
		end
		
		else
			print("Unkown Argument")
			
			
	lift()
	
	

	function kd.frameLift(outputSide, direction, )
		if direction == "up" then
		
			for i = 1,distance do
				rs.setBundledOutput(outputSide, output1)
					sleep(.4)
				rs.setBundledOutput(outputSide, 0)
					sleep(.4)
		end
		
		elseif direction == "down" then
			
			for i = 1,distance do
				rs.setBundledOutput(outputSide, output2)
					sleep(.4)
				rs.setBundledOutput(outputSide, 0)
					sleep(.4)
		end
	end
	   
    function kd.frameDoor(task)

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
    end

  function statusOut()
    if status == false then
      
    else 
        rs.setOutput(status, true)
          sleep(doorHold)
        rs.setOutput(status, false)
    end
  end
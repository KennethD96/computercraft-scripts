local outputSide = "back"
  
function dance()  
  while true do
    redstone.setBundledOutput(outputSide, math.random(123456789))
    sleep(.1)
  end
end
  
function exit()
  repeat
    key = os.pullEvent("key")
  until key == "key"
end
  
shell.run("clear")
print("Press any key to stop the party!")
  
parallel.waitForAny(dance, exit)
  
redstone.setBundledOutput(outputSide, 0)
sleep(.1)
shell.run("clear")

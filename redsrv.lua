local rSide = "right"
local mSide = "left"
local printerSide = "back" -- "None"

rednet.open(mSide)
if peripheral.isPresent(printerSide) then
  printer = peripheral.wrap(printerSide)
  printer_ispresent = true
  printer.newPage()
  printer.write("[Logging started]")
  printerPos = 1
else
  printer_ispresent = false
end

function rxin()
  print("[TIME, ID]")
  printstr(printer, "[TIME, ID]")
  while true do
    local rxID, msg = rednet.receive()
    local logPref = "["..time..", "..rxID.."]"
    local logOutput = logPref.." Output set: "..msg
    rs.setAnalogOutput(rSide, msg)
    print(logOutput)
    printstr(printer, logOutput)
    sleep(.2)
  end
end

function printstr(printer, input)
  if printer_ispresent then
    printerPos = printerPos + 1
    if printerPos == 22 then
      printer.endPage()
      printer.newPage()
      printerPos = 1
    end
    printer.setCursorPos(1, printerPos)
    printer.write(input)
  end
end

function clock()
  while true do
    time = textutils.formatTime(os.time(), true)
    sleep(.5)
  end
end

function kill()
  repeat
    key = os.pullEvent("key")
  until key == "key"
end

shell.run("clear")
print("Press any key to exit.")
parallel.waitForAny(clock, rxin, kill)
sleep(.1)

rednet.close(mSide)
if printer_ispresent then
  printer.endPage()
end

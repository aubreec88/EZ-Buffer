--!strict
--!optimize 2
--!native

-- all in house type shit [[december]]

local HttpService = game:GetService("HttpService")

local Main = {}

-- Give a string as an argument. [[december]]
function Main.EncodeString(stringInput:string)
	local newBuffer = buffer.create(stringInput:len() + 1)
	buffer.writestring(newBuffer, 0, stringInput)
	
	return newBuffer
end

-- Give a buffer containing a string as an argument. [[december]]
function Main.DecodeString(bufferContainingString:buffer)
	local output = buffer.readstring(bufferContainingString, 0, buffer.len(bufferContainingString))
	
	return output
end

-- Give a table as an argument. [[december]]
function Main.EncodeTable(tableData)
	--[[
	there are possibly better ways to do it rather than using JSONEncode and shit but i wasnt really
	able to find anything that wasnt just true doohickey bullshit plus this does work for now without
	any problems
	]]
	--[[december]]
	
	local encodedData = HttpService:JSONEncode(tableData)
	
	return Main.EncodeString(encodedData)
end

-- Give a buffer containing a table that was encoded using "HttpService:JSONEncode" as an argument. [[december]]
function Main.DecodeTable(bufferContainingTable:buffer)
	local readBufferData = Main.DecodeString(bufferContainingTable)
	
	local output = HttpService:JSONDecode(readBufferData)
	
	return output
end

-- Returns the signed integer function based on the bit amount given and if its supposed to be a write or read function. [[december]]
function Main.determineBitFunction(bitAmount:number, write:boolean)
	local functionToReturn = buffer.writei32
	
	-- really bad way to do it possibly, cant do much about it from what i know [[december]]
	if bitAmount == 8 then
		functionToReturn = (write and buffer.writei8 or buffer.readi8)
	elseif bitAmount == 16 then
		functionToReturn = (write and buffer.writei16 or buffer.readi16)
	elseif bitAmount == 32 then
		functionToReturn = (write and buffer.writei32 or buffer.readi32)
	else
		functionToReturn = (write and buffer.writef64 or buffer.readf64)
	end
	
	return functionToReturn
end

-- Turns the number you input with a signed buffer with the amount of bits you give with automatic buffer size determining. [[december]]
function Main.EncodeNumber(numberInput:number, bitAmount:number?)
	bitAmount = (bitAmount or 32)
	
	local bufferWriteFunction = Main.determineBitFunction(bitAmount, true)
	
	local bufferSize = tostring(numberInput):len()
	local newBuffer = buffer.create(bufferSize)
	
	-- dont mind that its erroring out [[december]]
	bufferWriteFunction(newBuffer, 0, numberInput)
	
	return newBuffer
end

-- Decodes the signed buffer with numbers inside of it with the amount of bits it was created with. [[december]]
function Main.DecodeNumber(bufferContainingNumber:buffer, bitNumber:number)
	local bitFunction = Main.determineBitFunction(bitNumber, false)
	
	-- dont mind that its erroring out [[december]]
	local output = bitFunction(bufferContainingNumber, 0)
	
	return output
end

return Main
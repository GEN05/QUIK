--
-- Created by IntelliJ IDEA.
-- User: 2000a
-- Date: 07.03.2020
-- Time: 11:15
-- To change this template use File | Settings | File Templates.
--

Settings = {
    Name = "Example3",
    period = 5,
    line = {
        Name = "MA",
        Color = RGB(255, 0, 0),
        Type = TYPE_LINE,
        Width = 2
    }
}

function Init()
    return 1
end

function OnCalculate(index)
    if index < Settings.period then
    	return nil
    else
    	local sum = 0
    	for i = index - Settings.period + 1, index do
    		sum = sum + C(i)
    	end
    	return sum / Settings.period
    end
end
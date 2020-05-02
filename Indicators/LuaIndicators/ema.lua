--
-- Created by IntelliJ IDEA.
-- User: 2000a
-- Date: 07.03.2020
-- Time: 11:15
-- To change this template use File | Settings | File Templates.
--

dofile(getWorkingFolder() .. "\\Include\\ma.lua")

Settings = {
    Name = "Two EMA",
    period1 = 50,
    value_type1 = "C",
    period2 = 50,
    value_type2 = "C",
    line = {
        {
            Name = "EMA 1",
            Color = RGB(255, 0, 0),
            Type = TYPE_LINE,
            Width = 2
        },
        {
            Name = "EMA 2",
            Type = TYPE_LINE,
            Width = 2
        }
    }
}

function Init()
    myEMA1 = cached_EMA()
    myEMA2 = cached_EMA()
    return 2
end

function OnCalculate(index)
    ema1 = myEMA1(index, Settings.period1, Settings.value_type1)
    ema2 = myEMA2(index, Settings.period2, Settings.value_type2)
    return round(ema1,2), round(ema2,2)
end
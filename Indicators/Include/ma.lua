function round(num, idp)
    if num == nil then 
        return nil
    end
    local mult = 10 ^ (idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function dValue(index, v_type)
    v_type = v_type or BAR_CLOSE
    if v_type == BAR_OPEN then
        return O(index)
    elseif v_type == BAR_HIGH then
        return H(index)
    elseif v_type == BAR_LOW then
        return L(index)
    elseif v_type == BAR_CLOSE then
        return C(index)
    elseif v_type == BAR_VOLUME then
        return V(index)
    end
    return 0
end

function average(_start, _end, v_type)
    local sum = 0
    for i = _start, _end do
        sum = sum + dValue(i, v_type)
    end
    return sum / (_end - _start + 1)
end

function cached_EMA()
    local cache = {}
    return function(ind, _p, v_t, kk)
        local n = 0
        local p = 0
        local period = _p
        local v_type = v_t
        local index = ind
        local k = kk or 2 / (period + 1)
        if index == 1 then
            cache = {}
        end
        if index < period then
            cache[index] = average(1, index, v_type)
            return nil
        end
        p = cache[index - 1] or dValue(index, v_type)
        n = k * dValue(index, v_type) + (1 - k) * p
        cache[index] = n
        return n
    end
end

function cached_DTEMA() 
    local cache_EMA={}
    local cache_DMA={} 
    local cache_TMA={} 
    return function(ind, _p, v_t, kk) 
        local n_ema = 0 
        local p_ema = 0 
        local n_dma = 0 
        local p_dma = 0 
        local n_tma = 0 
        local p_tma = 0 
        local period = _p 
        local v_type = v_t 
        local index = ind 
        local dv = dValue 
        local k = kk or 2 / (period + 1) 
        if index == 1 then 
            cache_DMA = {} 
            cache_EMA = {} 
            cache_TMA = {} 
        end 
        if index < period then
            cache_EMA[index] = average(1,index, v_type)
             return nil
        end
        p_ema = cache_EMA[index - 1] or dv(index, v_type)
        n_ema = k * dv(index, v_type) + (1 - k) * p_ema 
        cache_EMA[index] = n_ema 
        p_dma = cache_DMA[index - 1] or cache_EMA[index - 1] 
        n_dma = k * n_ema + (1 - k) * p_dma
        cache_DMA[index] = n_dma
        p_tma = cache_TMA[index - 1] or cache_DMA[index - 1] or cache_EMA[index - 1] 
        n_tma = k * n_dma + (1 - k) * p_tma
        cache_TMA[index] = n_tma
        return round(n_dma, 2), round(n_tma, 2) 
    end
end
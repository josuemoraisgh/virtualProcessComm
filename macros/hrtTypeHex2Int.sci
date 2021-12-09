function result=hrtTypeHex2Int(strInt)
    if strInt == '' then
        result = 0;
    else
        number = hex2dec(tokens(strInt,' ')); 
        if bitget(number(1),8)== 1 then 
            result = -1*bitcmp((number(1)*256+number(2))-1,16);        
        else 
            result = number(1)*256+number(2);        
        end
    end
endfunction

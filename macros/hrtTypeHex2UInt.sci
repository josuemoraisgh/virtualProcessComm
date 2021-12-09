function result=hrtTypeHex2UInt(strUInt)
    if strUInt == '' then
        result = 0;
    else
        number = hex2dec(tokens(strUInt,' '));
        if size(number,1) >= 2 then
            result = number(1)*256+number(2);
        else
            result = number;
        end
    end
endfunction

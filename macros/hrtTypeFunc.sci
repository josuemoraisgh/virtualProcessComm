function ret = hrtTypeFunc(trmsData)
    if part(trmsData,1:2) == '$\' then
        ret = trmsData;
    else
        trmsData = part(trmsData,2:$);
        [start, final, match, _] = regexp(trmsData,'/([a-zA-Z]+(_[a-zA-Z]+)+)/i');
        for i=1:size(match,1)
            trmsData = part(trmsData,1:(start(i)-1)+23*(i-1))+'vpcBDReadTranslated('''+match(i)+''')'+part(trmsData,final(i)+1+23*(i-1):$);
        end
        try
        ret = evstr(trmsData);
    catch
        pause;
        end
    end
endfunction

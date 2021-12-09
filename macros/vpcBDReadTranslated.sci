function ret = vpcBDReadTranslated(idVar)
    trmsData = bdVpcGet(idVar,'value');
    DataType = bdVpcGet(idVar,'type');
    if type(trmsData)== 10 then
        if part(trmsData,1) == '$' then
            ret = hrtTypeFunc(trmsData);
            return;
        end
    end
    select DataType
        case 'UNSIGNED' then
            ret = hrtTypeHex2UInt(trmsData);
        case 'FLOAT' then
            ret = hrtTypeHex2SReal(trmsData);
        case 'INTEGER' then
            ret = hrtTypeHex2Int(trmsData);
        case 'DATE' then
            ret = hrtTypeHex2Date(trmsData);
        case 'TIME' then
            ret = hrtTypeHex2Time(trmsData);
        case 'PACKED_ASCII' then
            ret = hrtTypeHex2PAscii(trmsData);
        case 'ENUM'+part(DataType,$-1:$) then
            ret = bdVpcGet(DataType,'value',trmsData,'index');//Recebe um value e retorna um index
        case 'BIT_ENUM'+part(DataType,$-1:$) then
            ret = bdVpcGet(DataType,'value',trmsData,'index');//Recebe um value e retorna um index
        else
            ret = trmsData;
    end
endfunction

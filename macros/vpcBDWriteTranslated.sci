function vpcBDWriteTranslated(idVar, trmsData)
    if type(trmsData) == 10 then 
        DataType = bdVpcGet(idVar,'type');
        if part(bdVpcGet(idVar,'value'),1) == '$' then//Se for um Função
            disp("Não é permitido alterar um campo do tipo a função");
            exit();
        end
    else
        DataType = 'Config';
    end
    select DataType
        case 'UNSIGNED' then
            bdVpcSet(idVar,hrtTypeUInt2Hex(strtod(trmsData)));
        case 'FLOAT' then
            bdVpcSet(idVar,hrtTypeSReal2Hex(trmsData));
        case 'INTEGER' then
            bdVpcSet(idVar,hrtTypeInt2Hex(strtod(trmsData)));
        case 'DATE' then
            bdVpcSet(idVar,hrtTypeDate2Hex(trmsData));
        case 'TIME' then
            bdVpcSet(idVar,hrtTypeTime2Hex(trmsData));
        case 'PACKED_ASCII' then
            bdVpcSet(idVar,hrtTypePAscii2Hex(trmsData+blanks(strtod(bdVpcGet(idVar,'nbytes'))-length(trmsData))));
        case 'ENUM'+part(DataType,$-1:$) then
            bdVpcSet(idVar,bdVpcGet(DataType,'index',trmsData,'value'));//Recebe um index e retorna um value
        case 'BIT_ENUM'+part(DataType,$-1:$) then
            bdVpcSet(idVar,bdVpcGet(DataType,'index',trmsData,'value'));//Recebe um index e retorna um value
        else
            bdVpcSet(idVar,trmsData);
    end
endfunction


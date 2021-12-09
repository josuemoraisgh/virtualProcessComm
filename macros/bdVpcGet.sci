function ret = bdVpcGet(idVar, varargin)
    global varBDados %VirtualProcessCommPath
    process = varBDados.Process
    select argn(2)
        case 1 //Se não informar o que quer -> Fornece o valor da variável
            typeName = 'value';
            selectedProcess = bdVpcGet("process",0,0,0);
            selectedDisp = bdVpcGet("disp",0,0,0);
        case 2
            typeName = varargin(1);
            selectedProcess = bdVpcGet("process",0,0,0);
            selectedDisp = bdVpcGet("disp",0,0,0);
        case 3
            typeName = varargin(1);
            selectedProcess = varargin(2);
            selectedDisp = bdVpcGet("disp",0,0,0);
        case 4
            typeName = varargin(1);
            selectedProcess = varargin(2);
            selectedDisp = varargin(3);
        else
            disp("bdVpcGet - Numero de argumentos incorreto");
            exit();
    end
    select idVar
        case "image"
            if typeName == 'type' then ret = 'config', return, end;
            ret = '$\includegraphics[scale=0.5]{'...
               +%VirtualProcessCommPath+'images\'+bdVpcGet('dispString')(bdVpcGet('disp'))+'.png}$';
        case "size"
            if typeName == 'type' then ret = 'config', return, end;
            ret = process.root.children.size;
        case "porta"
            if typeName == 'type' then ret = 'config', return, end;
            ret = varBDados.Config.root.children(4).children(1).content;
        case "baudRate"
            if typeName == 'type' then ret = 'config', return, end;
            ret = varBDados.Config.root.children(4).children(2).content ;
        case "dataBits"
            if typeName == 'type' then ret = 'config', return, end;
            ret = varBDados.Config.root.children(4).children(3).content;
        case "paridade"
            if typeName == 'type' then ret = 'config', return, end;
            ret = varBDados.Config.root.children(4).children(4).content;
        case "stopBits"
            if typeName == 'type' then ret = 'config', return, end;
            ret = varBDados.Config.root.children(4).children(5).content;
        case "protocolName"
            if typeName == 'type' then ret = 'protocolString', return, end;
            ret = bdVpcGet("protocolNames")(bdVpcGet("protocol"));
        case "protocolString"
            if typeName == 'type' then ret = 'protocolString', return, end;
            ret = tokens(varBDados.Config.root.children(1).children(2).content," ");
        case "protocol"
            if typeName == 'type' then ret = 'protocolString', return, end;
            ret = strtod(varBDados.Config.root.children(1).children(1).content);
        case "processName"
            if typeName == 'type' then ret = 'processString', return, end;
            ret = process.root.children(1).children(selectedProcess+2).name;
        case "processString"
            if typeName == 'type' then ret = 'processString', return, end;
            ret = [];
            for i =3:process.root.children(1).children.size
                ret = [ret process.root.children(1).children(i).name];
            end
        case "process"
            if typeName == 'type' then ret = 'processString', return, end;
            ret = strtod(varBDados.Config.root.children(2).children(1).content);
        case "dispName"
            if typeName == 'type' then ret = 'dispString', return, end;
            ret = process.root.children(1).children(selectedProcess+2).children(selectedDisp).name;
        case "dispString"
            if typeName == 'type' then ret = 'dispString', return, end;
            selectedProcess = bdVpcGet("process",0,0,0);
            ret = [];
            for i =1:process.root.children(1).children(selectedProcess+2).children.size
                ret = [ret process.root.children(1).children(selectedProcess+2).children(i).name];
            end
        case "disp"
            if typeName == 'type' then ret = 'dispString', return, end;
            ret = strtod(varBDados.Config.root.children(3).children(1).content);
        case "ENUM"+part(string(idVar),$-1:$)
            ret = enumBDVpcGet(idVar, typeName, selectedProcess, selectedDisp);
        case "BIT_ENUM"+part(string(idVar),$-1:$)//bdVpcGet('BIT_ENUM','value','n_1') ou bdVpcGet('BIT_ENUM','desc','atm')
            ret = 0;
        else //Caso não for as palavras reservadas anteriores então temos:
            if type(idVar) == 10 then //Se string: idVar = varName
                xp = xmlXPath(process, '/root/'+idVar)(1);
            else//Se não string: idVar = indexVar
                xp = process.root.children(idVar);//Identificador da Variável 
            end
            select typeName
                case 'value'//Processo Selecionado
                    ret = xp.children(selectedProcess+2)...
                            .children(selectedDisp).content//Dispositivo Selecionado
                case 'type'//Tipo da variável
                    ret = xp.children(2).content
                case 'nbytes'//Tamanho em Bytes da variável
                    ret = xp.children(1).content
                case 'name'//Nome da variável
                    ret = xp.name
                else
                    disp("bdVpcGet - Informação inexistente");
                    exit();
            end
    end
endfunction

function ret = enumBDVpcGet(idVar, varargin)
    select typeName
        case 'all'
            xp = xmlXPath(varBDados.Enum,'/root/'+idVar)(1);
            select varargin(2) 
                case 'desc'//Um vetor com toda a descrição é fornecida
                    ret = [];
                    for i =1:xp.children.size
                        ret = [ret xp.children(i).content];
                    end
                case 'value'//Um vetor com todos os valores é fornecida
                    ret = [];
                    for i =1:xp.children.size
                        ret = [ret strsubst(strsubst(xp.children(i).name,'/-(\d+)/','','r'),'n_','')];
                    end
            end
        case 'index'
            xp = xmlXPath(varBDados.Enum,'/root/'+idVar)(1).children(varargin(2));
            if varargin(3) == 'desc' then//O index é fornecido e a descição é retornada
                ret = xp.content;
            else//O index é fornecido e o value é retornado
                ret = strsubst(strsubst(xp.name,'/-(\d+)/','','r'),'n_','');
            end
        case 'desc'
            if varargin(3) == 'index' then//A descição é fornecida e o index é retornado
                ret = xmlXPath(varBDados.Enum,...
                    '/root/'+idVar+'/node()[.='''+varargin(2)+''']/preceding-sibling::*').size+1;
            else//A descição é fornecido e o value é retornado
                xp = xmlXPath(varBDados.Enum,'/root/'+idVar+'[*='''+varargin(2)+''']')(1);
                ret = strsubst(strsubst(xp.name,'/-(\d+)/','','r'),'n_','');
            end
        case 'value'
            xp = xmlXPath(varBDados.Enum,'/root/'+idVar)(1)
            for i=1:xp.children.size
                [_, _, _, foundString] = regexp(xp.children(i).name,'/n_(\d+)-(\d+)/')
                if foundString <> "" then
                    if varargin(2) == "" then
                        id = 1;
                    else
                        id = hex2dec(strsubst(varargin(2)," ",""));
                    end
                    if hex2dec(foundString(1)) < id && id < hex2dec(foundString(2)) then
                        xp = xp.children(i);
                        break;
                    end
                else
                    if part(xp.children(i).name,3:$) == varargin(2) then
                        xp = xp.children(i);
                        break;
                    end
                end
            end
            if varargin(3) == 'index' then//O valor é fornecido e o index é retornado
                ret = i;
            else//O valor é fornecido e a descrição é retornad
                ret = xp.content;
            end
    end
endfunction

function bdVpcSet(idVar, value, varargin)
    global varBDados
    process = varBDados.Process
    select argn(2)
        case 2 //Se não informar o que quer -> Fornece o valor da variável
            typeName = 'value';
            selectedProcess = bdVpcGet("process",0,0,0);
            selectedDisp = bdVpcGet("disp",0,0,0);
        case 3
            typeName = varargin(1);
            selectedProcess = bdVpcGet("process",0,0,0);
            selectedDisp = bdVpcGet("disp",0,0,0);
        case 4
            typeName = varargin(1);
            selectedProcess = varargin(2);
            selectedDisp = bdVpcGet("disp",0,0,0);
        case 5
            typeName = varargin(1);
            selectedProcess = varargin(2);
            selectedDisp = varargin(3);
        else
            disp("bdVpcGet - Numero de argumentos incorreto");
            exit();
    end
    select idVar
        case "porta"
            varBDados.Config.root.children(4).children(1).content = value;
        case "baudRate"
            varBDados.Config.root.children(4).children(2).content = value;
        case "dataBits"
            varBDados.Config.root.children(4).children(3).content = value;
        case "paridade"
            varBDados.Config.root.children(4).children(4).content = value;
        case "stopBits"
            varBDados.Config.root.children(4).children(5).content = value;
        case "protocolName"
            varBDados.Config.root.children(1).children(2).content = ...
                     strsubst(varBDados.Config.root.children(1).children(2).content,...
                              bdVpcGet("protocolName"),...
                              value);
        case "protocol"
            varBDados.Config.root.children(1).children(1).content = string(value); 
        case "processName"
            process.root.children(1).children(selectedProcess+2).name = value;
        case "process"
            varBDados.Config.root.children(2).children(1).content = string(value);
            bdVpcSet("disp",1);
        case "dispName"
            process.root.children(1).children(selectedProcess+2).children(selectedDisp).name = value;
        case "disp"
            varBDados.Config.root.children(3).children(1).content = string(value); 
        else///Caso não for as palavras reservadas anteriores então temos:
            if type(idVar) == 10 then //Se string: idVar = varName
                xp = xmlXPath(process, '/root/'+idVar)(1);
            else//Se não string: idVar = indexVar
                xp = process.root.children(idVar);//Identificador da Variável 
            end
            select typeName
            case 'value'//valor da variável selecionada
                    xp.children(selectedProcess+2)...//Processo Selecionado
                      .children(selectedDisp).content = string(value);
                case 'type'//Tipo da Variável
                    xp.children(2).content = string(value);
                case 'nbytes'//Tamanho em Bytes da Variável
                    xp.children(1).content = string(value);
                case 'name'//Nome da Variável 
                    xp.name = string(value);
                else
                    disp("bdVpcSet - Informação inexistente");
                    exit();
            end
    end
endfunction

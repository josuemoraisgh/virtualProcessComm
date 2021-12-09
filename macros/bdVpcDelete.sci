function bdVpcDelete(elementoType, elementoId, varargin)
    global varBDados
    process = varBDados.Process;
    select elementoType
        case 'Process'
            if type(elementoId) == 10 then //Se string: elementoId=processName
                xp = xmlXPath(process,'child::*/child::'+elementoId);
                xmlRemove(xp);
            else        
                for i=1:process.root.children.size
                    xmlRemove(process.root.children(i)...
                                      .children(elementoId+2));
                end
            end
        case 'Disp'
            if type(elementoId) == 10 then //Se string: elementoId=processName e varargin(1)=dispName
                xp = xmlXPath(process, '//'+elementoId+'/'+varargin(1));
                xmlRemove(xp);
            else 
                if argn(2) > 2 then selectedProcess = varargin(1), else selectedProcess = varBDados.Config.root.children(2).children(1).content, end;
                for i=1:varBDados.Process.root.children.size
                    xmlRemove(process.root.children(i)...
                                      .children(selectedProcess+2)...
                                      .children(elementoId));
                end
             end
        case 'var'
            if type(elementoId) == 10 then //Se string: elementoId=varName
                xp = xmlXPath(process, '/root/'+elementoId);
            else
                elementoName = process.root.children(elementoId).name;
                xp = xmlXPath(process, '/root/'+elementoName);
            end
            xmlRemove(xp);
        else
            disp('bdVpcInsert - Opção não Encontrada!!');
    end
endfunction

function bdVpcInsert(elementoType, elementoName, varargin)
    global varBDados
    process = varBDados.Process;
    select elementoType
        case 'Process'
            sizeProcess = process.root.children(1).children.size;
            for i=1:process.root.children.size //size varbd
                process.root.children(i)...
                        .children(sizeProcess+1) = xmlElement(process,elementoName)
            end
        case 'Disp'
            pause;
            if argn(2) > 2 then selectedProcess = varargin(1), else selectedProcess = varBDados.Config.root.children(2).children(1).content, end;
            sizeDisp = process.root.children(1).children(selectedProcess).children.size;            
            for i=1:process.root.children.size //size var
                process.root.children(i)...
                        .children(selectedProcess+2)...
                        .children(sizeDisp+1) = xmlElement(process,elementoName)
            end
        case 'var'
            sizeVar = process.root.children.size;
            process.root.children(sizeVar+1) = xmlElement(process,elementoName);
            for i=1:process.root.children(1).children.size //size var
                name = process.root.children(1).children(i).name;
                process.root.children(sizeVar+1).children(i) = xmlElement(process,name)
            end
        else
            disp('bdVpcInsert - Opção não Encontrada!!');
    end
endfunction

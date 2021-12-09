function ret = xlsOpen(nomearq)
    if xls_IsExcelRunning() == %f then
        xls_NewExcel();
    else
        xls_RecoverExcel();
    end
    xls_setProperty("Application", "Visible", 0);    
    ret = xls_Open(nomearq); 
endfunction

function worksheet = findWorksheet()
    c = xls_getProperty("Application", "Worksheets", "Count");
    worksheet = emptystr(c, 1);
    for i=1:c
        xls_callMethod("Application", "Worksheets", list(i));
        xls_callMethod("Worksheet", "Activate");
        worksheet(i) = xls_getProperty("Worksheet", "Name");
    end
endfunction

function retorno = getDados(Worksheet,linha,coluna)
    xls_callMethod("Workbook", "Worksheets", list(Worksheet));
    xls_callMethod("worksheet", "Cells", list(linha,coluna));
    retorno = xls_getProperty("Cell", "Value");   
endfunction

function setDados(dados,Worksheet,linha,coluna)
    xls_callMethod("Workbook", "Worksheets", list(Worksheet));
    xls_callMethod("worksheet", "Cells", list(linha,coluna));
    xls_setProperty("Cell", "Value", dados);
endfunction

function [totalLinha, totalColuna] = xlsRegiaoDados(Worksheet,linhaIni)
    xls_callMethod("Workbook", "Worksheets", list(Worksheet))
    for totalLinha = linhaIni:65536
        xls_callMethod("worksheet", "Cells", list(totalLinha,1));
        if isempty(xls_getProperty("Cell", "Value"))
            break;
        end
    end
    totalLinha = totalLinha-1;    
    for totalColuna = 1:65536
        xls_callMethod("worksheet", "Cells", list(1,totalColuna));
        if isempty(xls_getProperty("Cell", "Value"))
            break;
        end
    end
    totalColuna = totalColuna-1;
endfunction

function hrtComand2Xml()
  linhaIni=4;
  path = get_absolute_file_path('hrtComand2Xml.sce');
  ret = xlsOpen(path+filesep()+"hrtComand"+".xls");
  if ret == %f then    
      disp("Não foi possivel abrir o Arquivo!!")
  else
    doc = xmlDocument(path+filesep()+"hrtComand"+".xml");
    root = xmlElement(doc, "root");
    worksheet = findWorksheet();
    for i=2:size(worksheet,1)
        root.children(i-1) = xmlElement(doc,strsubst(worksheet(i)," ",""));
        aux = getDados(worksheet(i),1,1);
        aux1 = getDados(worksheet(i),2,2);
        if aux <> [] && aux1 <> [] then
            root.children(i-1).attributes.desc = aux;
            try
            root.children(i-1).attributes.NBBody = strsubst(strsubst(aux1,'/\([\s\S]+\)/','','r')," ","");
        catch
            pause;
            end
        end
        [totalLinha, totalColuna] = xlsRegiaoDados(worksheet(i),linhaIni)
        if totalLinha > 0 then
            for j=1:totalLinha-linhaIni+1
                root.children(i-1).children(j) = xmlElement(doc,"item_" + string(j));
                aux = getDados(worksheet(i),linhaIni+j-1,2);
                if aux <> [] then
                    root.children(i-1).children(j).content = strsubst(strsubst(aux,'/\([\s\S]+\)/','','r')," ","");
                end
            end
        end
    end
    xls_Close();// close Workbook
    xls_Quit(); // quit excel
    doc.root = root;
    xmlWrite(doc,path+filesep()+"hrtComand"+".xml");
  end
endfunction


hrtComand2Xml();

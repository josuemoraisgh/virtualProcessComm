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

function [totalLinha, totalColuna] = xlsRegiaoDados(Worksheet,linhaIni,colunaIni)
    xls_callMethod("Workbook", "Worksheets", list(Worksheet))
    for totalLinha = linhaIni:65536
        xls_callMethod("worksheet", "Cells", list(totalLinha,colunaIni));
        if isempty(xls_getProperty("Cell", "Value"))
            break;
        end
    end
    totalLinha = totalLinha-1;    
    for totalColuna = colunaIni:65536
        xls_callMethod("worksheet", "Cells", list(linhaIni,totalColuna));
        if isempty(xls_getProperty("Cell", "Value"))
            break;
        end
    end
    totalColuna = totalColuna-1;
endfunction

function hrtProcess2Xml()
  processNameOld = "";processName = "";
  linhaIni=3;colunaIni=1;
  path = get_absolute_file_path('hrtProcess2Xml.sce');
  ret = xlsOpen(path+filesep()+"hrtProcess"+".xls");
  if ret == %f then    
      disp("Não foi possivel abrir o Arquivo!!")
  else
    doc = xmlDocument(path+filesep()+"hrtProcess"+".xml");
    worksheet = findWorksheet();
    root = xmlElement(doc, worksheet(1));
    [totalLinha, totalColuna] = xlsRegiaoDados(worksheet(1),linhaIni+1,colunaIni+1)
    if totalLinha > 0 then
        for j=1:totalLinha
            countProcess = 0;
            if totalColuna > 0 then
                varName = getDados(worksheet(1),linhaIni+j,colunaIni+1);
                if varName <> [] then
                    root.children(j) = xmlElement(doc,strsubst(varName," ",""));
                    for i=2:totalColuna
                        processName = getDados(worksheet(1),linhaIni-1,colunaIni+i);                        
                        desc = getDados(worksheet(1),linhaIni,colunaIni+i);
                        content = getDados(worksheet(1),linhaIni+j,colunaIni+i);
                        if content == [] then
                            content = ""
                        elseif strindex(string(content),'/\$/','r')(1) <> 1
                            content = strsubst(string(content),'/ \([\s\S]+\)/','','r');
                        else
                            content = string(content);
                        end
                        if desc <> [] then
                            if processName == [] || processName == '' then
                                countProcess = countProcess+1;
                                root.children(j).children(countProcess) = xmlElement(doc,strsubst(desc," ",""));
                                root.children(j).children(countProcess).content = content;
                            else
                                if processName <> processNameOld then
                                    processNameOld = processName;
                                    countProcess = countProcess+1;
                                    itens = 0;
                                    root.children(j).children(countProcess)...
                                          = xmlElement(doc,strsubst(processName," ",""));
                                end
                                try
                                    itens=itens+1
                                    root.children(j).children(countProcess).children(itens)...
                                                         = xmlElement(doc,strsubst(desc," ",""));
                                    root.children(j).children(countProcess).children(itens).content = content;
                                catch
                                    pause;
                                end
                            end
                        end
                    end                    
                end
            end
        end
    end
    xls_Close();// close Workbook
    xls_Quit(); // quit excel
    doc.root = root
    xmlWrite(doc, path+filesep()+"hrtProcess"+".xml");
  end
endfunction


hrtProcess2Xml();

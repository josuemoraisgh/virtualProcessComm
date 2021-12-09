function bdVpcConect()
    global %VirtualProcessCommPath varBDados
    path = getlongpathname(%VirtualProcessCommPath)+'xml';
    varBDados.Process = xmlRead(path+filesep()+"hrtProcess"+".xml");
    varBDados.Enum = xmlRead(path+filesep()+"hrtEnum"+".xml");
    varBDados.Config = xmlRead(path+filesep()+"vpcConfig"+".xml");
endfunction

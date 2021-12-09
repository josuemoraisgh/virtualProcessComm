function bdVpcDesconect()
    global %VirtualProcessCommPath varBDados
    path = getlongpathname(%VirtualProcessCommPath)+'xml';
    xmlWrite(varBDados.Process,path+filesep()+"hrtProcess"+".xml");
    xmlWrite(varBDados.Config,path+filesep()+"vpcConfig"+".xml");
    clearglobal varBDados
endfunction

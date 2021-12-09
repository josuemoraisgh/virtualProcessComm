function vpcGuiConectar()
    set('BConectar','Enable','off');
    set('BDesconectar','Enable','on');
    set('porta','Enable','off');
    set('baudRate','Enable','off');
    set('dataBits','Enable','off');
    set('paridade','Enable','off');
    set('stopBits','Enable','off');
    vpcGuiAquisicao(uint8(strtod(bdVpcGet('porta'))),...
                    bdVpcGet('baudRate'),...
                    bdVpcGet('dataBits'),...
                    bdVpcGet('paridade'),...
                    bdVpcGet('stopBits'));
endfunction

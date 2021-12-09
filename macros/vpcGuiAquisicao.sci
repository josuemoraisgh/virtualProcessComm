function vpcGuiAquisicao(varargin)
    global serial
    porta=1;baudRate='19200';dataBits='8';paridade='n';stopBits='1';
    select argn(2)
        case 1 then
            porta     = varargin(1);        
        case 2 then
            porta     = varargin(1);
            baudRate  = varargin(2);
        case 3 then
            porta     = varargin(1);            
            baudRate  = varargin(2);
            dataBits  = varargin(3);
        case 4 then
            porta     = varargin(1);            
            baudRate  = varargin(2);
            dataBits  = varargin(3);
            paridade  = varargin(4);
        case 5 then
            porta     = varargin(1);            
            baudRate  = varargin(2);
            dataBits  = varargin(3);
            paridade  = varargin(4);
            stopBits  = varargin(5);            
    end
    //try
        commCloseAll();
        serial = commOpen(porta,baudRate+','+paridade+','+dataBits+','+stopBits); 
        while get('BConectar','Enable') == 'off' do
            [n,status] = commStatus(serial);
            if(n(1)>0)then
                strFrame=commRead(serial,n(1));
                if hrtFrameCalcCkSum(strFrame,1)==hrtFrameCkSum(strFrame) then
                    str = vpcCommand(string(hex2dec(hrtFrameCommand(strFrame))),strFrame);
                    disp(strFrame+' -> '+str);
                    commWrite(serial,str);
                end
            end
        end
    //catch
    //    disp('Falha na função hrtAquisicao');
    //end
    commClose(serial);
endfunction

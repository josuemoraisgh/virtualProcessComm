function strAnswer = vpcCommand(strCommand,strFrame)
    select strCommand
        case '0' then //Comand 00 - Identity Command
            //01 - LD301
            //02 - TT301
            //03 -
            //04 -
            //05 - 
            //06 - DT301
            //07 - FY400
            str0 = bdVpcGet('manufacturer_id');
            str1 = bdVpcGet('device_type');
            strAnswer = vpcCommandAnswer(strFrame,...
                    '0E 00 00 FE '+str0+' '+str1+' 05 05 04 30 01 00 00 1E 66',...
                    'Identity Command');
        case '1' then //Comand 01 - Read Primary Variable
            str0 = bdVpcGet('PROCESS_VARIABLE');
            strAnswer = vpcCommandAnswer(strFrame,...
                    '07 00 00 20 '+str0,...
                    'Read Primary Variable');
        case '2' then //Comand 02 - Read Loop Current And Percent Of Range
            str0 = bdVpcGet('percent_of_range');
            str1 = bdVpcGet('loop_current');
            strAnswer = vpcCommandAnswer(strFrame,...
                    '0A 00 00 '+str0+' '...
                              +str1,...
                    'Read Loop Current And Percent Of Range');
            //strAnswer = vpcCommandAnswer(strFrame,...
            //        '0A 00 00 40 87 A5 1E 3F BF 20 00',...
            //        'Read Loop Current And Percent Of Range');
        case '3' then //Comand 03 - Read Dynamic Variables And Loop Current
            strAnswer = vpcCommandAnswer(strFrame,..
                    '1A 00 00 40 87 9F D1 20 3F BE 9B 80 20 41 D9 69 10 39 3F BE 9B 80 20 3F BE 9B 80',..
                    'Read Dynamic Variables And Loop Current');
        case '6' then //Comand 06 - Write Polling Address
            strAnswer = vpcCommandAnswer(strFrame,..
                    '',..
                    'Write Polling Address');
        case '7' then //Comand 07 - Read Loop Configuration
            strAnswer = vpcCommandAnswer(strFrame,..
                    '02 40 00 87',..
                    'Read Loop Configuration');
        case '12' then //Comand 0C - Read Message
            str0 = bdVpcGet('message');
            strAnswer = vpcCommandAnswer(strFrame,..
                    '1A 00 00 '+str0,... 
                    'Read Message');
        case '13' then //Comand 0D - Read Tag, Descriptor, Date
            //50 11 E0 82 08 20 0C 80 52 04 35 05 48 54 E0 82 08 20 82 08 20
            str0 = bdVpcGet('tag');
            str1 = bdVpcGet('descriptor');
            str2 = bdVpcGet('date');                        
            strAnswer = vpcCommandAnswer(strFrame,..
                    '17 00 00 '+str0+' '...
                               +str1+' '...
                               +str2,...
                    'Read Tag, Descriptor, Date');
        case '14' then //Comand 0E - Read Primary Variable Transducer Information
            strAnswer = vpcCommandAnswer(strFrame,..
                    '12 00 00 00 00 00 20 44 54 80 00 C3 48 00 00 41 20 00 00',..
                    'Read Primary Variable Transducer Information');
        case '15' then //Comand 0F - Read Device Information
            strAnswer = vpcCommandAnswer(strFrame,..
                    '13 00 00 01 00 23 43 BA 93 33 42 92 4C CC 3F 80 00 00 01 3E',..
                    'Read Device Information');
        case '16' then //Comand 10 - Read Final Assembly Number
            strAnswer = vpcCommandAnswer(strFrame,..
                    '05 00 00 00 FB C6',..
                    'Read Final Assembly Number');
        case '17' then //Comand 11 - Write Message
            strAnswer = vpcCommandAnswer(strFrame,..
                    '',..
                    'Write Message');
        case '18' then //Comand 12 - Write Tag, Descriptor, Date
            strAnswer = vpcCommandAnswer(strFrame,..
                    '',..
                    'Write Tag, Descriptor, Date');
        case '19' then //Comand 13 - Write Final Assembly Number
            strAnswer = vpcCommandAnswer(strFrame,..
                    '',..
                    'Write Final Assembly Number');
        case '33' then //Comand 21 - Read Device Variables
            select hrtFrameBody(strFrame)
                case '00' then
                    str = '08 00 00 00 27 40 EE 2D 42';
                case '01' then
                    str = '08 00 00 01 39 41 AC 26 AA';  
                case '02' then
                    str = '08 00 00 02 20 41 CF 95 40'; 
                case '03' then
                    str = '08 00 00 03 20 41 C8 D9 90';                             
                case '04' then
                    str = '08 00 00 04 39 41 AC 26 21';
                case '05' then
                    str = '08 00 00 05 39 00 00 00 00';          
                case '0C' then//12
                    str = '08 00 00 0C 33 3F 80 00 00';
                case '19' then
                    str = '08 00 40 19 00 42 DD 26 1B';  
            end
            strAnswer = vpcCommandAnswer(strFrame,str,'Read Device Variables');
        case '38' then //Comand 26 - Resetar as Flags de Erro
            strAnswer = vpcCommandAnswer(strFrame,..
                    '02 00 00 E6 3F 3F',..
                    'Resetar as Flags de Erro');
        case '40' then //Comand 28 - Enter/Exit Fixed Current Mode
            strAnswer = vpcCommandAnswer(strFrame,..
                    '28 06 00 40 00 00 00 00',..
                    'Enter/Exit Fixed Current Mode');
        case '41' then //Comand 29 - Perform Self Test
            strAnswer = vpcCommandAnswer(strFrame,..
                    '02 40 20',..
                    'Perform Self Test');
        case '42' then //Comand 30 - Perform Device Reset
            strAnswer = vpcCommandAnswer(strFrame,..
                    '02 00 00',..
                    'Perform Device Reset');
        case '45' then //Comand 2D - Trim/Adjusting the 4 mA 
            strAnswer = vpcCommandAnswer(strFrame,..
                    '02 09 00',..
                    'Trim/Adjusting the 4 mA');
        case '46' then //Comand 2E - Trim/Adjusting the 20 mA
            strAnswer = vpcCommandAnswer(strFrame,..
                    '02 09 00',..
                    'Trim/Adjusting the 20 mA');
        case '80' then //Comand 50 - Read Dynamic Variable Assignments
            strAnswer = vpcCommandAnswer(strFrame,..
                    '50 00',..
                    'Trim/Adjusting the 4 mA');
        case '130' then //Comando 82 - Write Device Variable Trim Point
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '07 00 00 02 01 02 01 01',..
                    'Write Device Variable Trim Point');
        case '132' then //Comando 84 -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '0D 00 00 02 01 25 43 D2 00 00 40 A9 99 99',..
                    '');
        case '135' then //Comando 87 - Write I/O System Master Mode
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '04 00 40 02 01',..
                    'Write I/O System Master Mode');
        case '136' then //Comando 88 -
            //hrtStrBody = '02'    
            strAnswer = vpcCommandAnswer(strFrame,..
                    '06 70 00 02 FF FF FF',..
                    '');
        case '138' then //Comando 8A -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '04 00 00 02 FF',..
                    '');
        case '140' then //Comando 8C -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '19 70 00 02 39 41 AC 33 E9 39 00 00 00 00 39 42 48 00 00 FF FF 39 00 00 00 00',..
                    '');
        case '152' then //Comando 98 -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,'','');
        case '162' then //Comando A2 -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '04 00 00 02 01',..
                    '');
        case '164' then //Comando A4 -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '05 00 00 02 02 00',..
                    '');
        case '166' then //Comando A6 -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '0F 00 00 02 22 04 00 00 13 0A 27 00 00 01 0B 00',..
                    '');
        case '168' then //Comando A8 -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '05 00 00 02 01 FF',..
                    '');
        case '173' then //Comando AD -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '18 00 00 02 54 54 33 30 31 31 31 31 30 2D 42 55 49 31 4C 33 50 30 54 34 59',..
                    '');
        case '185' then //Comando B9 -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '03 00 40 02',..
                    '');
        case '187' then //Comando BB -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '04 00 00 02 FF',..
                    '');
        case '198' then //Comando C6 -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '07 00 00 02 42 48 00 00',..
                    '');
        case '223' then //Comando DF -
            //hrtStrBody = '02'
            strAnswer = vpcCommandAnswer(strFrame,..
                    '13 00 00 02 42 C8 00 00 3B 80 11 32 B5 1B 05 7F AC 93 2D 1D',..
                    '');
        else 
            strAnswer = vpcCommandAnswer(strFrame,..
                    '13 00 00 02 42 C8 00 00 3B 80 11 32 B5 1B 05 7F AC 93 2D 1D',..
                    '');
    end
endfunction


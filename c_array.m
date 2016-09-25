
%%% SD Karte im raw modus mit xmega128a1 beschreiben
%%% sudo dd if=/dev/sdd bs=4k count=1000 | hexdump -d >~/Schreibtisch/outhex1&& cat ~/Schreibtisch/outhex1
%%% hesdump -d: gruppiert zwei bytes und formatiert den uint16_t wert
%%% dezimal
SIZE=512;    % in uint8_t
VREF=2.87;

fd=fopen('/home/mainster/Schreibtisch/outRawGut2');
header=fread(fd, SIZE,'uint8=>char','l')';
[~] = fread(fd, SIZE,'uint8','l');   % Flush empty block
bin16=fread(fd,10*(SIZE/2),'uint16','l');
fclose(fd);

header(1:150)
dec2hex(bin16(1:20))

nonempty=find(bin16);
length(bin16)
length(nonempty)

data=bin16 * VREF/hex2dec('0fff')
plot(data)

return
ADC_BUFFER_SIZE = 512;



header=char(binIn(1:512))';
data=(binIn(2*BUF_SIZ:11*BUF_SIZ));

dataHex=dec2hex(data);

dataHex(1:2*BUF_SIZ)

return
addr = in{1}(1:10);
indStartAddr=find(~cellfun(@isempty,strfind(addr,'0200')))

inData = in;

cll=[];

for row = indStartAddr:indStartAddr + ADC_BUFFER_SIZE/(  2  *  8) - 1
    for k=2:9
       cll=[cll inData{k}(row)]; 

    end
end
cll;


mat=cell2mat( cellfun(@str2num,cll(:),'UniformOutput',false) );
length(mat)

%celldisp(in)
return
ff=linspace(0,2^12,32);

str=[];
for k=1:length(ff)
    if ~mod(k,8)
        str=[str sprintf('%d ,\n',ff(k))];
    else
        str=[str sprintf('%d , ',ff(k))];
    end
end
    
%save('c_array_out', 'tytff', '-ASCII')    
dlmwrite('/media/global_exchange/my_data.out',round(ff+2^15), ',')   
    type '/media/global_exchange/my_data.out'
    
if exist('/media/global_exchange/my_data1.out')    
    in=dlmread('/media/global_exchange/my_data1.out', ',');
end

% inn=[];
% for k=1:4*length(in)
%     inn=[inn in(k:k+4)];
%     k
% end
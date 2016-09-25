%%% SD Karte im raw modus mit xmega128a1 beschreiben
%%% sudo dd if=/dev/sdd bs=4k count=1000 | hexdump -d >~/Schreibtisch/outhex1&& cat ~/Schreibtisch/outhex1
%%% hesdump -d: gruppiert zwei bytes und formatiert den uint16_t wert
%%% dezimal
delete(findall(0,'type','line'));

SIZE=512;    % in uint8_t
VREF=2.87;

fd=fopen('/home/mainster/Schreibtisch/outRawGut3');
header=fread(fd, SIZE,'uint8=>char','l')';
[~] = fread(fd, SIZE,'uint8','l');   % Flush empty block
bin16=fread(fd,100*(SIZE/2),'uint16','l');
%bin8=fread(fd,100*SIZE,'uint8','l');
fclose(fd);

header(1:511)
si = strfind(lower(header), 'adc_sample_rate') + length('ADC_SAMPLE_RATE: ')

% bhex=dec2hex(bin8);
% l=1;
% for k=1:2:length(bhex)/2-1
%     bhex16(l,:)=[bhex(k+1,:) bhex(k,:)];
%     l=l+1;
% end
% 
% plot(hex2dec(bhex16(1:end,:)))
% 
% bhex16(1:10)
% return 
fs=str2num(header(si:si+5));
dec2hex(bin16(1:20));

nonempty=find(bin16);
length(bin16)
length(nonempty)

data=bin16 * VREF/hex2dec('0fff');

f1=figure(1);
subplot(221);
plot(linspace(0, 1/fs*length(bin16),length(data)), data)
ylim([0 3]);
title(sprintf('fs=%i  nSamps=%i',fs,length(data)));
grid on;

subplot(222);
plot(linspace(0, 1/fs*length(bin16),length(bin16)), bin16,'.')
ylim([0 4096]);
title(sprintf('fs=%i  nSamps=%i',fs,length(bin16)));
grid on;

subplot(223);
plot(xcorr(data))
title(sprintf('fs=%i  nSamps=%i',fs,length(data)));
grid on;

subplot(222);
plot(linspace(0, 1/fs*length(bin16),length(bin16)), bin16,'.')
ylim([0 4096]);
title(sprintf('fs=%i  nSamps=%i',fs,length(bin16)));
grid on;


l=1;
ma(1,:)=max(bin16(1:SIZE/2));
mi(1,:)=min(bin16(1:SIZE/2));
for k=2:99
    ma(k,:)=max(bin16(k*SIZE/2:(k+l)*SIZE/2));
    mi(k,:)=min(bin16(k*SIZE/2:(k+l)*SIZE/2));
end

for k=1:98
    di(k,:)=ma(k) - mi(k);
end

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
delete(findall(0,'type','line'));

SEARCHDIR='/media/global_exchange/';

ls=dir(SEARCHDIR);
lsC=struct2cell(ls);
namesC=lsC(1,:);
ind=find(~cellfun(@isempty,strfind(namesC,'output')))

datenums=cell2mat(lsC(end, ind))
[~,b]=sort(datenums)

%b(1)=[];

for k=1:length(b)-1
    movefile([SEARCHDIR ls(ind(k)).name], [SEARCHDIR 'old_hterm_logs/' ls(ind(k)).name])
end

if length(ind) == 0
    error('string output not found')
end
if length(ind) > 1
    warning('only the most new file redirected to parser')
%    ind(2:end)=[];
end

fd=fopen([SEARCHDIR ls(ind(end)).name],'r');
file=fread(fd);
fclose(3);

file2=[];
for k=1:6:length(file)-6
    file2(round(k/6)+1,:)=char(file(k+[1:6])');
end

decValues=hex2dec(char(file2(1:end,1:4)));

decValues(1:15)
length(decValues)

    
sprintf('file2 length: %.0f',length(file2))
f1=figure(1);
hold on;
plot(decValues(1:end),'b.')
plot([0:511], ones(1,512)*6e4,'r')
plot([512:1023], ones(1,512)*1e4,'r')
hold off




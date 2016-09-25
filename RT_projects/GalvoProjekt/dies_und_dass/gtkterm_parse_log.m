%%%%%% GTK term out parser


% ls=dir(SEARCHDIR);
% lsC=struct2cell(ls);
% namesC=lsC(1,:);
% ind=find(~cellfun(@isempty,strfind(namesC,'output')))
% 
% datenums=cell2mat(lsC(end, ind))
% [~,b]=sort(datenums)
% 
% %b(1)=[];
% 
% for k=1:length(b)-1
%     movefile([SEARCHDIR ls(ind(k)).name], [SEARCHDIR 'old_hterm_logs/' ls(ind(k)).name])
% end
% 
% if length(ind) == 0
%     error('string output not found')
% end
% if length(ind) > 1
%     warning('only the most new file redirected to parser')
% %    ind(2:end)=[];
% end
% 
% fd=fopen([SEARCHDIR ls(ind(end)).name],'r');


delete(findall(0,'type','figure'));
SEARCHDIR='/home/mainster/Schreibtisch/galvo_pdfs/gtkterm/12-08-2014/';

gtktermFun1([SEARCHDIR 'adjusting_setpoint_1'],'VAR A',200)
gtktermFun1([SEARCHDIR 'adjusting_setpoint_2'],'ADJ Setpoint',200)

return

fd=fopen([SEARCHDIR 'adjusting_setpoint_2'],'r');
%file=fread(fd);
line=fgetl(fd)
k=1;
while isempty(strfind(line,'W:'))
    line=fgetl(fd);
end

C = textscan(fd, '%s %d %s %d %s %d %s %d');
fclose(3);

f1=figure(1);
clf;

hold all;
plot(C{2});
plot(C{4});
plot(C{6});
plot(C{8});
hold off;
grid on
xlim([0,100]);

legend('W:','Y:','E:','P:');
%din.(strsplit(C{1}{1},':'))=C{2}

return

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




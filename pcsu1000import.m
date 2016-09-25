% Vellmann PCSU100 USB- Scope Export- Dateien parsen und struct
% zurück geben.
%
% 30.05.2014
% Manuel Del Basso
%

function [A]= pcsu1000import(exppath)

stdPath='/media/global_exchange/pcsuExports'
PAT='_P';

if nargin ~= 1
    error('myApp:argChk', 'Wrong number of input arguments');
end

if strfind(exppath,'ind ')~=0 % last als pfad angegeben wurde
%    filesTemp=strsplit(ls(stdPath),' ');
    indToFile=strsplit(exppath,' ');
    filesTemp=strsplit(ls(stdPath));
    for i=1:size(filesTemp,1)
        list{i}=strtrim(filesTemp(i,:));
    end
    
    
    filesExp=strfind(list{:},cell2mat([PAT indToFile(2)]));

    if ~isempty(find(~cellfun(@isempty,filesExp))')
        indfilesTemp{i,1}=find(~cellfun(@isempty,filesExp));
        filename=cell2mat([stdPath '/' filesTemp( indfilesTemp{1})]);
    else
        error('myApp:FileNotFound',...
            sprintf('File with ind %.0f not found',...
            indToFile(2)));
    end
    
else
    filename=exppath;
end    


delimiterIn = '\t';
headerlinesIn = 9;
A = importdata(filename,delimiterIn,headerlinesIn);

inc=strfind(A.textdata(:,1),'TIME STEP');        % indexiere Childes vom type 'axes'
ind=find(~cellfun(@isempty,inc))+1;            % take all children handles of all axes handle into structure
[sampDiv]=strsplit(A.textdata{ind,1},'=');

if find(strfind(sampDiv{1,2},'ms'))
    tmp=strsplit(sampDiv{1,2},'ms');
    samp_tdiv(1)=str2double(tmp{1,1})*1e-3;
elseif find(strfind(sampDiv{1,2},'us'))
    tmp=strsplit(sampDiv{1,2},'us');
    samp_tdiv(1)=str2double(tmp{1,1})*1e-6;
else
    error('myApp:argChk', 'kein ms oder us gefunden');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% header zeilen bleiben gleich --> direkte indexierung

A.channels(1,[2 3])=A.colheaders(1,[2 3]);

samp_tdiv(2)=str2double(sampDiv{1,1});

% Im Log steht z.B.:
%
% TIME STEP
% 125=10ms
%
% Dass heißt nicht Ts=10ms/125 sondern 125 ist der 'Raw' wert
% und stellt Ts auf Ts=10ms ein.
%
% !!! Doch, genau das heißt es. Samplevektor mit 10ms/125 skalieren

%A.dataSkal(:,1)=A.data(:,1)*samp_tdiv(1);%/samp_tdiv(2);
A.Ts=samp_tdiv(1)/samp_tdiv(2);

A.scopeTdiv=samp_tdiv(1);
A.Ts*length(A.data)/19  % 19 Zeitteiler im scope



A.dataSkal(:,1)=A.data(:,1)*A.Ts;

off=strsplit(A.textdata{8,1});

A.offsets(2:3)=str2double(off(2:3));

inc{1,1}=strfind(A.textdata(:,1),'CH1:');        % indexiere Childes vom type 'axes'
inc{1,2}=strfind(A.textdata(:,1),'CH2:');        % indexiere Childes vom type 'axes'
ind=find(~cellfun(@isempty,inc))+1;            % take all children handles of all axes handle into structure
veqsts{1,1}=strsplit(A.textdata{6,1},{'CH1:','=','V'});
veqsts{1,2}=strsplit(A.textdata{7,1},{'CH2:','=','V'});

A.samp_vdiv([1 2],[2 3])=str2double([veqsts{1,1}(2:3);veqsts{1,2}(2:3)] );
A.vDiv(1,1)=A.samp_vdiv(1,3)/A.samp_vdiv(1,2);
A.vDiv(1,2)=A.samp_vdiv(2,3)/A.samp_vdiv(2,2);

A.dataSkal(:,2)=(A.data(:,2)-A.offsets(2))*A.vDiv(1);
A.dataSkal(:,3)=(A.data(:,3)-A.offsets(3))*A.vDiv(2);

% f1=figure(1);
% SUB=110;
% 
% hold all;
% plot(A.data(:,1),A.dataSkal(:,2));
% plot(A.data(:,1),A.dataSkal(:,3));
% hold off;
% grid on;
% 
% legend('y(t)','u(t)');
% ar=sort(findall(0,'type','figure'));
% set(ar,'WindowStyle','docked');
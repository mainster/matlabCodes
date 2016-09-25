%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% @@@MDB
%%          Tips / usefull codesnippets
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (0)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% squeeze  -  Remove singleton dimensions 09-02-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load iddata2 z2;
sys_p = tfest(z2,2);
w = linspace(0,10*pi,128);
[mag,ph,w,sdmag,sdphase] = bode(sys_p,w);
mag = squeeze(mag);
sdmag = squeeze(sdmag);
semilogx(w,mag,'g',w,mag+3*sdmag,'r:',w,mag-3*sdmag,'r:');

return
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Kuchen/Tortendiagramme FSG Praxiss- 09-02-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delete(findall(0,'type','figure'));
colordef('white');
load('mapd');

INP=15;

f1=figure(1);
pie3([1/3,2/3],[0,1],{'statisch','dynamisch'}); 
set(f1,'ColorMap',mapd{1});
shading interp
light; light; 

dyns=[7,8,10,15,10,33,10,7];
dynsExp=[0 1 .1 1 0 0 0 0];
dynNam={'Acceleration',...
   'Business Plan', 'Cost Analysis', 'Engineering Design',...
   'Fuel Economy','Endurance', 'Autocross',...
   'Skid Pad'};

f2=figure(2);
p3=pie3(dyns,dynsExp); 
set(f2,'ColorMap',mapd{2});
shading interp
light; light; 

if INP < 0
   INP=input('Enter Font Size: ');
end

if ~isnumeric(INP) 
   error('Numeric type expected');
else
   if(INP) < 2 || (INP) > 40
      error('out of range');
   end
end


txs=findall(p3,'type','text');
for k=1:length(txs)
   txs(k).FontSize=INP;
end

legend(dynNam,'Location','SouthEast');
[hl,~,~,~]=legend;
hl.Position = hl.Position+[.02 .11 .0 .0];
hl.FontSize = INP-2;
% legend('boxoff');

FTYP={'.bmp','.png','.tif','.jpg'};
for k=2:2 %length(FTYP)
   TFILE=['/home/mainster/grive/psberichtv2/PIES/pie_',...
      sprintf('%g-%g-%g_%g%g%g',clock), FTYP{k}];
   
% saveas(gcf,['/home/mainster/grive/psberichtv2/PIES/pie_',...
%    sprintf('%g-%g-%g_%g%g%g',clock), FTYP{k}]);
print(f2, TFILE,'-dpng','-r200','-opengl')
end

%%
return
h=light;
for az = -150:10:150
   lightangle(h,az,40)
   pause(.2)
end
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erzeugen von testdaten SQL database - worktime - 09-02-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars('-except',INITIALVARS{:})

NN=500;
halbe = round(rand(1,NN))*0.5;
dat={zeros(NN,1)};
lead = 'INSERT INTO "worktime" VALUES (';

%% src and target 
TEMPLATE='/home/mainster/mysql/delBassoInitialDb_sheme_template.sql';
TEMPLATE='/var/lib/mysql/delBassoInitialDb_sheme_template.sql';
[PAT, NAME, EXT]= fileparts (TEMPLATE);
NAMER = [NAME strrep(strrep(char(datetime), ' ','_'),':','')];

TARG=[fullfile(PAT, NAMER), EXT];
copyfile(TEMPLATE, TARG);
%%

fd = fopen(TARG,'at+');
day  = [1 30];
month= [1 12];
year = [2006 2016];
worker = [1 13];
prj = [1 7];
hrs = [0 10];

r = @(x) randi(x);
%%
for k=1:NN
%   dat{k,1} = sprintf('%s%3i, ''2015-%02i-%02i'', %2g, %2g, %3g);',...
%   dat{k,1} = sprintf('%s%3i, ''%02i/%02i/16'', %2g, %2g, %3g);',...
   dat{k,1} = sprintf('%s%3i, ''%4i-%02i-%02i'', %2g, %2g, %3g);',...
   lead, k, r(year), r(month), r(day),... 
   r(worker),r(prj),r(hrs)+halbe(k));
   fprintf(fd, '%s\n', dat{k,1});
end

fclose(fd);
type(TARG)


cmd = ['[ -e $SQL/delbassoSQL.db ] && mv $SQL/delbassoSQL.db $SQL/olddb/delbassoSQL_$(dateForFile).db;',...
   'sqlite3 $SQL/delbassoSQL.db < ', TARG];
[stat, cmdout]=system(cmd)
return

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Import multiple csv files - HWMonitor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars('-except',INITIALVARS{:})

pp='/media/global_exchange/teresa_jan_2016/';
[~, lst] = system('echo dummy && find /media/global_exchange/teresa_jan_2016/ -name "*TMPIN0*.csv"')
%[a,b,c]=fileparts(lst');
lst=strsplit(lst,'\n');

lst(1)=[]

%%
am1=zeros(500,1);
am2=zeros(500,1);

for k=1:length(lst)
   if ~isempty(lst{k})
   	AMD{k,:} = importdata(lst{k});
      if max(size(AMD{k,:})) >= 1000
%          am1=[am1 AMD{k}(:,1)];
%          am2=[am2 AMD{k}(:,2)];
      end
   end
end


figure(1)
hold all
amd=zeros(1,1e3);
amd2=zeros(1,1e3);

for k=1:length(AMD) - 1
	if max(size(AMD{k,:})) >= 1000
      amd=[amd AMD{k}(:,1)'];
      amd2=[amd2 AMD{k}(:,2)'];
   end
end

plot(amd); hold all;
plot(amd2); hold off;
return 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Keep input focus on console window after hitting a breakpoint
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
com.mathworks.services.Prefs.setBooleanPref('EditorGraphicalDebugging',false)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  search text file for string pattern
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read lines from input file
filename=[ol.ltspicePath 'variable_zener_npn.asc'];
fid = fopen(filename, 'r');
Cin = textscan(fid, '%s', 'Delimiter', '\n');
fclose(fid);

% search pattern MATLAB_PARAM=1
C1 = strfind(Cin{1}, 'MATLAB_PARAM=1');

% find index and create cell containing all lines that matches MATLAB...
lines = find(~cellfun('isempty', C1));    
cp=C{1}(lines);   

% cast cp to datatype cell if only one param set found 
if ~iscell(cp)
   cp{1}=cp;
end

% parse each param set into cell
cpk={zeros(1,length(cp))};
for k=1:length(cp)
   cpk{k} = strsplit(cp{k},'\\n+')';
   pset{k} = strsplit(cpk{k},'=')';
end

cpk{1}
cpk{2}
pset

%%

%// Search a specific string and find all rows containing matches
filename=[ol.ltspicePath 'variable_zener_npn.asc'];
C = strfind(C{1}, 'OptimetricsResult');
rows = find(~cellfun('isempty', C));

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  define function handles from struct of function handles and their
%  corresponding fieldnames
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Defined in startup.m for example!
bf.csigma=@(x) heaviside(x);
bf.rect=@(x) csigma(x+0.5)-csigma(x-0.5);
bf.tri=@(x) (x+1).*csigma(x+1)-2.*x.*csigma(x)+(x-1).*csigma(x-1);

setappdata(0,'basefunctions',bf);
clear bf;

%% invoke variables inside a (private) function
   bfc_ = struct2cell( getappdata(0,'basefunctions') );
   na_ = fieldnames( getappdata(0,'basefunctions') );
   
   for k=1:length(na_)
      eval([na_{k} '=' char(bfc_{k})])
   end
	clear *_;

   
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Latex ausgaben in figures 
%     --> Inline parameter des Fonts ändern     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1);

%% Hä, geht doch nicht... egal was man für zahlen bei \fontsize einträgt????
tx0=text(.5,.8,'$$\phi_{ss} weiter$$',...
               'fontsize',15,'interpreter','latex');
%%
tx1=text(.5,.5,'$$\phi_{ss} {\fontsize{100pt}{0} \selectfont Size}$$',...
               'fontsize',15,'interpreter','latex');

            disp('Scaling of interpreted label string holds the aspect ratio !')

tx2=text(.5,.2,'$$\phi_{ss} {\fontsize{50pt}{0} \selectfont Size}$$',...
               'fontsize',15,'interpreter','latex');
tx2.FontSize = tx2.FontSize*1.5;

%%
delete(findall(gcf, 'type','text'))
return
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Draw LTspice symbol model data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ee=[-32    32    32    64
    -32    96    32    64
    -32    32   -32    96
    -28    48   -20    48
    -28    80   -20    80
    -24    84   -24    76
     0    32     0    48
     0    96     0    80
     4    44    12    44
     8    40     8    48
     4    84    12    84];
ee2=ee+100;
figure(1);
hold all;
plot(ee(1:end,[1 3])',ee(1:end,[2 4])','b-')
plot(ee2(1:end,[1 3])',ee2(1:end,[2 4])','g-')
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Signed, unsigned DAC data, alignment ....
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tt=linspace(0,1, 20);   % 20 Werte / Periode


% 0...4095d  -->  0...Aref
sd = 2^11*sin(2*pi*tt);
sdr=sd+2^11;

%subplot(121);
hold all;
plot(sd, 'o-', 'MarkerSize',5);
plot(sdr, 'o-', 'MarkerSize',5);
xlabel('n')
ylabel('Reglerausgang (intern, signed int)')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Signalsequenzen für z.B. C-Arrays erzeugen und dlmwrite
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N_SAMPS = 8;
tt = linspace(0,.5,N_SAMPS)';

%% Sinus
sinseq = round(2^11*sin(2*pi*tt'))

%% Tri-generator
clear tri;

r1 = [ 1:length(tt)/2 ];
r2 = [ length(tt)/2+1:length(tt) ];

tri = round( (2^12-1)*( [ 2*tt(r1).*csigma(tt(r1)); 
                        -2*tt(r2).*csigma(tt(r2))+2 ] - .5) );
              
%% Quadratic 
s2 = round( 2^12*(tt.^2 - 0.5) );
sm2 = round( -2^12*(tt.^2 -.5) );

%% Sawtooth
saw = round(tt*2^12-2^11);

arr.Cosine = sinseq;
arr.CosineN = sin(2*pi*tt)
arr.calcTab = tri;
arr.Quadratic = s2
arr.I_Quadratic = sm2
arr.Sawtooth = saw;

strList = fields(arr);
arrTypes = {'int16_t', 'int16_t', 'int16_t', 'int16_t', 'float', 'int16_t'}
hold all;
for k=1:length(strList) 
    plot(tt', arr.(strList{k}) );
end
hold off

FILE='/media/global_exchange/signalGen.h';
fd = fopen(FILE,'w');
%fprintf(timeDate(1,' '));

CC=75;      % target column char count
fprintf(fd, ['#ifndef __SIGNALGEN_H_ \n',...
            '#define __SIGNALGEN_H_ \n\n',...
            'int16_t *pSeq = NULL; \n',...
            'unsigned short cSeq;\n',...
            '\n#define TABLESIZE %i\n\n'],N_SAMPS);

for m=1:length(strList)
    fprintf(fd,'\n%s %s[TABLESIZE] = {\n', arrTypes{m}, strList{m});
    NC = 0;

    for k=1:length(tt)
        fprintf(fd, '%i, ', arr.(strList{m})(k));
        NC = NC + length(char(sprintf('%i, ', arr.(strList{m})(k))));
        
        if (NC >= CC)
            fprintf(fd, '\n');
            NC=0;
        end
    end

    pos = ftell(fd)
    fseek(fd, -2,'cof');        % remove the last comma
    fprintf(fd,'\n};\n\n');
end

fprintf(fd, '\n\n#endif\n');
fclose(fd);
type(FILE)

return 
%%






%%
export_fig testpics/blaaab -png -eps -pdf -jpg -bmp -tiff -painters -r250 -transparent -nocrop
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   passing functionhandles to other functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x=[0 0.2 0.4 0.6 0.8 1.0];
y=[0 0.2 0.4 0.6 0.8 1.0];
% func2eq = @(x,y)  x+sin(pi*x).*exp(y);
func2 = @(x,y,fhand) fhand(x, y);
func2(x, y, @func2eq)

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Check function arguments by inputParser
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

   p = inputParser;
   expLength = {'equal','none'};
   expNorm = {'db','dB'};
   defaultHeight = 0;

   valSeq = @(x) isnumeric(x) && isrow(x) && ~isscalar(x);
   valLength = @(x) isnumeric(x) || (ischar(x) && any(validatestring(x,expLength)));
   valNorm = @(x) isnumeric(x) || (ischar(x) && ~isempty(strfind(x,expNorm{2}))); 
   

   addRequired(p,'seqCmd',valSeq);
   addRequired(p,'seqRef',valSeq);
   addParamValue(p,'norm',0,valNorm);
   addParamValue(p,'length',0,valLength);
             
             
   parse(p,seqCmd,seqRef,varargin{:});
   a = p.Results     


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   dot-name-reference-on-non-scalar-struct
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myStruct(1).Nested(1).Value = 10;
myStruct(1).Nested(2).Value = 1;
myStruct(2).Nested(1).Value = 5;
myStruct(2).Nested(2).Value = 3;
arrayfun(@(x) x.Nested.Value,myStruct)
% ans =
%    10     5
%% Try
cell2mat(arrayfun(@(x) [x.Nested.Value],myStruct,'uni',0))
% ans =
%    10     1     5     3

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   clear exceptions for vars
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clearvars -except ol 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   mehrere unabhängige linien in matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xa1=1;xa2=xa1;
xb1=3;xb2=xb1;
ya1=-1;ya2=1;
yb1=0;yb2=1;
line([[xa1,xb1];[xa2,xb2]], [[ya1,yb1];[ya2,yb2]],'LineWidth',2,'Color','red');

syms xa1 xa2 xb1 xb2 ya1 ya2 yb1 yb2
[[xa1,xb1];[xa2,xb2]], [[ya1,yb1];[ya2,yb2]]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   set auf mehrere HAndles anwenden mit unterschiedlichen
%   parameterwerten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%          3x1
% set(H,pn,MxN_pv) sets n property values on each of m graphics objects,
% where m = length(H) and n is equal to the number of property names
% contained in the cell array pn. This allows you to set a given group of
% properties to different values on each object.

% pd ist zeilenvektor mit 3 handles zu 3 x plot
pn = {'Color'};
pv = {'red';'green';'blue'};
set(pd, pn,pv);

% su ist zeilenvektor mit 3 handles zu 3 subplots
set(cell2mat(ol.getWrap(su,'Title')'),{'String'},{'A';'B';'C'})


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   save window pos
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% START_OF_MANIPULATION

figpos=[ [1257,555,958,447];
		[3068,-255,718,370];
		[1603,-251,718,370];
		[3101,632,718,370];
		[505,632,718,370];
		[1743,-500,958,447]];

figHdl = zeros(0,1);










%%%%%%%%%%%%%%%%%%%%
%%






hd = findall(0,'type','figure');
hd(hd > 100) = [];

for k=1:length(hd)
    posNew(k,:) = get(hd(k),'Position');
end

options.Interpreter = 'none';
options.Default = 'No';
qstring = 'refresh figure position matrix?';

if questdlg(qstring,'Write access?','Yes','No',options) == 'Yes'
    hd = findall(0,'type','figure');
    hd(hd > 100) = [];
    if isempty(hd)
        break;
    end

    for k=1:length(hd)
        posNew(k,:) = get(hd(k),'Position');
    end
   
	%%%%%%%%%%%%%%
    fd=fopen('TIPS_TRICKS.m', 'rt+');
    str = {};
    ftell(fd);
    for n=1:10
        if ~isempty(strfind(fgetl(fd),'START_OF_MANIPULATION'))
            ftell(fd);
            %%%%%%%%%%%%%%
            str(1) = {sprintf('\r\nfigpos=[ [%i,%i,%i,%i]', posNew(1,:))}

            for m=1:size(posNew,1)-1  % m- positionsvektoren 
                str(m+1) = {sprintf(';\r\n\t\t[%i,%i,%i,%i]',posNew(m+1,:))}
            end
            str(end+1) = {'];'}
            %%%%%%%%%%%%%%
            
            str2 = sprintf('\n\nfigHdl = %s;\r\n\r\n', mat2str(hd))
            %%%%%%%%%%%%%%
            fwrite(fd, [cell2mat(str) str2]);
            break
        end
    end
    fclose(fd);
end
%end
%save(TIPS_TRICKS.m, 'figpos','-append')
%%
for k=1:length(figHdl)
    set(figHdl(k),'Position',figpos(k,1:4))
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Widerstände nach E- Reihe
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Für Ex gilt für den Faktor k folgende Formel:
clear kex REx RFT Rqx Rqxd
fprintf([repmat('-',1,50) '\n\n'])
NORM=[3 6 12 24 48 96];
NORM=[3 6 12 24];
kex=10.^(1./NORM);
% Immer aufrunden
REx=zeros(max(NORM),length(NORM));
for k=1:length(NORM)
    REx(1:NORM(k),k)=ceil(10*kex(k).^[0:NORM(k)-1])/10;
end

disp(REx(1:NORM(4),1:4))
format shortg

% benötigter widerstand Rq
Rqx = 1e4*rand(1,5);
Rqx(1)=4395;
Rqx(5)=154;
Rqx(6)=6900;

Rqx
pw=floor(log10(Rqx));
% alle werte auf die form n.nnnnn... bringen
Rqxd=Rqx.*10.^(-pw);

% wähle spalte mit E3 Normreihe
%RB=REx(1:NORM(3),3);
% wähle spalte mit E6 Normreihe
%REx(1:NORM(4),4)

% resample
% alle resample- werte durch einen skalaren gesuchten widerstand ersetzen

RFT = resample(REx(1:NORM(end),:),2,1);
RFT(2:2:end) = repmat(Rqxd(1), length(RFT)/2,length(NORM));

[minerr, ind]=min(abs(diff(RFT))) % ind bezieht sich auf den geresampelten Vektor
%ind=ind/2;  % Jetzt sind die indizes für REx

se=[];
for k=1:length(NORM)
    se=[se RFT(ind(k)-1,k)];
end
%se

fprintf('select:\nNORM:\t\t%s\n', sprintf(repmat('E%i\t\t\t',1,length(NORM)),NORM) )
fprintf(['RES:\t\t' repmat('%g\t\t\t',1,length(NORM)) '\n'], se)
fprintf(['Err[ohm]:\t' repmat('%g\t\t',1,length(NORM)) '\n'], minerr*100)
% 
% REx(:,4)
% %fprintf([repmat('%.2f  ',2,4)  repmat('\n',2,1)],REx(1:2,:))
% for k=1:length(NORM)
% %    fprintf([repmat('%.2f  ',1,length(REx(k)))  '\n'],REx(:,k))
%     fprintf([repmat('%.2f  ',k,4)  repmat('\n',k,1)],REx(1:4,1:4))
% end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Select outport of xIMO system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S=linmodHighLevel('Test3');
bodeplot(S.ss(find(~cellfun(@isempty,strfind(S.ss.OutputName,'filter'))) ),optb)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Select signal for logging 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FILE = {'Galvo_sys_Cdisc_Pcont_ccvc_FET_SUB_REF_v65'};

clear ph;

blk2log={'Cc(s)', 'Plant Actuator SAT' };
fields = strrep(blk2log, {' '}, {'_'});
fields = strrep(fields, {'('}, {'__'});
fields = strrep(fields, {')'}, {''});

for k=1:length(blk2log)
    ph.cc_old_pwr.(fields{k}) = get_param([FILE{1} '/current ctrl/cc_old_pwr/' blk2log{k}] ,'PortHandles');
    ph.cc_no_vc.(fields{k}) = get_param([FILE{1} '/current ctrl/cc_no_vc/' blk2log{k}] ,'PortHandles');
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Read logging data from model logging 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear l

    for k=1:logsout.numElements  
        l.(strrep( logsout.getElement(k).Values.Name ,'*','_stern'))=logsout.getElement(k).Values.Data;
    end
    l.time = logsout.getElement(1).Values.Time;



%% List all object parameters inkl fieldname, value and a row counter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear objParam objParamField value 
GCS = gcs;
sysStr = strsplit(GCS,'/');
topMod = sysStr{1};

% Objekt für das die set_param liste ausgegeben werden soll
OBJ = topMod;

objParam = get_param(OBJ,'ObjectParameters');
objParamField = fieldnames(objParam(:));

for k=1:length(objParamField)
    try
    	value{k,:}={objParamField{k}, get_param(OBJ, objParamField{k}), num2str(k)};
    catch err
        disp(err.identifier);
    end
end

cat(1,value{:})

%% strsplit und repmat
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

spl = cellfun(@strsplit, FILES(fSel),[repmat({'_';},1,2)], 'UniformOutput', false)

%% convert Gl cell to struct
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear le h str1
le = cell2mat(cellfun(@size, Gl, 'UniformOutput', false)');
S=struct;

fieldnam={'idtf','order','frequencyFocus','fit','rawFile','numerator','denominator','signal','date'};
for k=1:(length(Gl)-1)
	S(k,:).(fieldnam{1}) = Gl{k}{[1:le(k)],1};
	S(k,:).(fieldnam{2}) = Gl{k}{[1:le(k)],2};
	S(k,:).(fieldnam{3}) = Gl{k}{[1:le(k)],3};
	S(k,:).(fieldnam{4}) = Gl{k}{[1:le(k)],4};
	S(k,:).(fieldnam{5}) = Gl{k}{[1:le(k)],5};
    tmp=Gl{k}{1,6};
	S(k,:).(fieldnam{6}) = str2num(tmp{1});
	S(k,:).(fieldnam{7}) = str2num(tmp{2});

    try 
    	S(k,:).(fieldnam{8}) = Gl{k}{[1:le(k)],7};
    catch err
    	S(k,:).(fieldnam{8}) = err.identifier;
    end
        
    try 
        S(k,:).(fieldnam{9}) = Gl{k}{[1:le(k)],8};      
    catch err
    	S(k,:).(fieldnam{9}) = err.identifier;
    end


end
S;

S.fit


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  Deep addressing of cell blocks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Gl{end}([1:end],4,1)
Gl{end}([1:end],[5:7],1)
Gl{end}([1:end],[1,8],1)        % disp estimation fit and date
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  Get pid params from cb
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pms={'P','I','D','N','AntiWindupMode','Kb','Kt','UpperSaturationLimit','LowerSaturationLimit',...
    'LimitOutput','controller','Form','FilterMethod','IntegratorMethod','SampleTime'};
ns=struct('Date',timeAndDate);
for k=1:length(pms)
    ns.(pms{k})=get_param(gcb,pms{k});
end
ns.NOTES='';

if ~exist('pidCfgs','var')
 %   load('pidCfgs_store.m','-mat','pidCfgs');
    disp('pidCfgs loaded')
end
pidCfgs(end+1)=ns;

save('pidCfgs_store.m', 'pidCfgs','-append');
    
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  find / change block sample times
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear syss 

%syss = find_system('type', 'block_diagram');
syss = {gcs}
for n=1:length(syss)
    clear blocks
    if length(syss) > 1
        blocks.name = find_system(syss( n ),'type', 'block')
    end
    if length(syss) == 1
        blocks.name = find_system(syss,'type', 'block')
    end
    
    blocks.handle = cell2mat(get_param(blocks.name,'handle'))

    for k=1:length(blocks.handle)
        try
            blocks.sampleTime(k,:) = {get(blocks.handle(k),'SampleTime')};
        catch err
            blocks.sampleTime(k,:) = {sprintf('catched: %s',err.identifier)};
        end
    end
    blocks.isTsInd = find(cellfun(@isempty, strfind(blocks.sampleTime, 'catched')));
    blocks.sampleTime(blocks.isTsInd);

    set(blocks.handle(blocks.isTsInd),'SampleTime','-1')
end
%%

blocks.obj = get_param(blocks.name,'ObjectParameters');
blocks.fieldnames = cellfun(@fieldnames, blocks.obj, 'UniformOutput', false)
for k=1:length(blocks.fieldnames)
%    blocks.issample(k,:) = find(cellfun(@isempty,(strfind(blocks.fieldnames{k},'SampleTime'))))
	find(cellfun(@isempty,(strfind(blocks.fieldnames{k},'SampleTime'))))
%    blocks.sampletime(k,:) = get(blocks.handle(k),'SampleTime')
end
%blocks.issample = find(~cellfun(@isempty, strfind(blocks.fieldnames,'SampleTime')))
blocks.issample
%%
clear ts fs blocks
blocks = find_system(gcs,'type', 'block');

for k=1:length(blocks)
    ts(k) = Simulink.Block.getSampleTimes(blocks{k});
    fs(k,:) = ts(k).Value;
end
fsEmptyInd = find(cellfun(@isempty, fs))

fs
%cellfun(@get, (), 'SampleTime')
%get(get_param(blocks{1},'handle'), 'SamplingMode')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  close viewer, systems and figures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fig=findall(0,'type','figure')

childs = allchild(0)
sol=strfind(upper(get(allchild(0),'Tag')),'SIMULINK_SIMSCOPE_FIGURE')
if iscell(sol)
   ind=find(~cellfun(@isempty, strfind(upper(get(allchild(0),'Tag')),'SIMULINK_SIMSCOPE_FIGURE')));
else
   ind=sol
end
close(childs(ind))      % clode viewer

syss = find_system('type', 'block_diagram');
if isempty(syss)
    disp('nothing to close')
else
    if iscell(syss)
        ind1=find(cellfun(@isempty, strfind(lower(syss),'eml_lib')))
        ind2=find(cellfun(@isempty, strfind(lower(syss),'simulink')))
        ind3=find(cellfun(@isempty, strfind(lower(syss),'simviewers')))
        indn=[find(diff(ind1)-1)+1, find(diff(ind2)-1)+1 find(diff(ind3)-1)+1]
    else
        ind=sol
    end
    
end
le=[1:length(syss)];
le(indn)=[];

syss;
syss(le);
try
    save_system(syss(le))
catch err
    if strcmpi(err.identifier, 'Simulink:LoadSave:FileWriteError')
        sprintf('Schreiben fehlgeschlagen')
    else
        sprintf('Error: %s',err.identifier)
    end
        
end
close_system(syss(le))
close all


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  Bode Handles
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transfer function
my_tf = tf(1, [1 2 1]);
% create a figure and get the handle of the figure
figHnd = figure;
% draw the bode plot of the transfer function
bode(my_tf)

% get and display the children handles of the figure
childrenHnd =get(figHnd, 'Children')

% select magnitude plot and plot a line
axes(childrenHnd(3))
hold on
plot([1 1], [-20 20], 'r')
hold off

% select phase plot and plot a line
axes(childrenHnd(1))
hold on
plot([1 1], [-20 20], 'r')
hold off

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  Viewer:Scope objekte finden / param
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  set scope time range
T_STOP=str2num(get_param(gcs,'StopTime'));
if numel(T_STOP) > 1
   T_STOP=T_STOP(2);
else
   T_STOP=T_STOP(1);
end
T_STOP=num2str(T_STOP);

%%%%%%  set scope time range in system @init_callback_fct
T_STOP=num2str(str2num(get_param(gcs,'StopTime')));

childs = allchild(0);
sol=strfind(upper(get(allchild(0),'Tag')),'VIEWER_PARAMETERS');

if iscell(sol)
   ind=find(~cellfun(@isempty, strfind(upper(get(allchild(0),'Tag')),'VIEWER_PARAMETERS')));
else
   ind=sol;
end
%ind=find(~cellfun(@isempty, {strfind(upper(get(allchild(0),'Tag')),'VIEWER_PARAMETERS'),[]}))
if ~isempty(ind)
   for k=1:length(childs(ind))
      set_param(getfield(get(childs(ind(k)),'UserData'),'block'),'TimeRange',T_STOP);
      get_param(getfield(get(childs(ind(k)),'UserData'),'block'),'TimeRange');
%    set_param(getfield(get(childs(ind),'UserData'),'block'),'TimeRange',T_STOP);
%    get_param(getfield(get(childs(ind),'UserData'),'block'),'TimeRange');
   end
else
    warning(sprintf('VIEWER_PARAMETERS object not found\nOpen the config dialog by hand for the first sim start'))
end


%%
%%%%%%  set scope time range in system @init_callback_fct
T_STOP=num2str(str2num(get_param(gcs,'StopTime')));

childs = allchild(0);
ind=find(~cellfun(@isempty, {strfind(upper(get(allchild(0),'Tag')),'VIEWER_PARAMETERS'),[]}));
if ~isempty(ind)
    set_param(getfield(get(childs(ind),'UserData'),'block'),'TimeRange',T_STOP);
    get_param(getfield(get(childs(ind),'UserData'),'block'),'TimeRange');
else
    warning(sprintf('VIEWER_PARAMETERS object not found\nOpen the config dialog by hand for the first sim start'))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  char sequenzen n- mal wiederholen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tab_string=repmat('\t',1,60)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%  cellfunction split strings
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
RAWS={ 'powerstage_PushPull_FET_lochraster_KOB.raw',...
       'powerstage_PushPull_FET_ADA4700_hv.raw',...
       'powerstage_PushPull_BJT_MJ1101xG_LT_HvOp_pwrInv.raw'};
sprintf('%s\n%s\n%s\n', RAWS{:}) 
sp = cellfun(@strsplit, RAWS, {'_','_','_'}, 'UniformOutput', false)

% setzt die letzten drei wieder zusammen und gibt nur zwei der gekürzten
% dateinamen wieder aus
jn = cellfun(@strjoin, cellfun(@(x) x(end-2:end),...
             sp(2:3), 'UniformOutput', false), 'UniformOutput', false);
jn{:}
%%    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tfCC=idSpice('galvoscanner/powerstage_PushPull_FET_lochraster_KOB.raw','V(out_A)',[0 2e6],[3 1],0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMO system inkl. Input/Output- Namen aus Blockdiagramm ableiten
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
GvS = linmod('GalvoModel_v31');
GvS = linmod('GalvoModel_v31');
GvS.filename = 'GalvoModel_v31';
u_ = strrep(GvS.InputName, [GvS.filename '/'], '');
y_ = strrep(GvS.OutputName, [GvS.filename '/'], '');
GvS.InputName = u_;
GvS.OutputName = y_;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMO- tf aus linmod-struct (Zustandsraum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[num, den] = ss2tf(GvS.a, GvS.b, GvS.c, GvS.d);
SIMO1 = tf({num(1,:); num(2,:)}, den, 'u', u_, 'y', y_) 

[num, den] = linmod('GalvoModel_v31');
SIMO2 = tf({num(1,:); num(2,:)}, den) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%   Export Blockdiagram to bitmap
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
saveas(get_param('GalvoModel_v3_detailed','Handle'),'RT_projects/topmodel.bmp');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SIMFILES={  'GalvoModel_v31_19082014',...
            'GalvoModel_v31_CC'} ;

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% kleiner workaround wegen Simulink SegFault %%%
%%% bei geöffneten scope- views                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ind=NaN;

ch = allchild(0);
names = get(ch,'Name');
if iscell(names)
    ind=find(~cellfun(@isempty, strfind(lower(names), 'scope')));
else
    ind=find(strfind(lower(names), 'scope'));
end
if ~isnan(ind)
    close(ch(ind));
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% ODER


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% kleiner workaround wegen Simulink SegFault %%%
%%% bei geöffneten scope- views                %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
open_bd = find_system('type', 'block_diagram');
for k=1:length(SIMFILES)
    ind=find(~cellfun(@isempty, strfind(open_bd, SIMFILES{k})))

    if isempty(ind)
        disp('blockdiagram not found')
    else
        save_system(open_bd(ind));
        close_system(open_bd(ind));
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% SIMO systeme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t1=linmod('GalvoModel_v3_SIMO');
[num, den] = linmod('GalvoModel_v3_SIMO');
sys1(:,2)=fieldnames(t1);
sys1(1,1)={t1}
sys1(:,3)=struct2cell(t1);
tf1=tf({num(1,:) ; num(2,:)}, den, 'OutputName',sys1{1}.OutputName );
%--------------- ^ ----------------------------------------
%-------------- | | ----------------------------------------
%-------------- | | ----------------------------------------
%-------------- | | ----------------------------------------
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return
%%%%%%%%%%%%  gen multiple transformation of cont. to discret systems
for k=[10,20,25,50,100], eval( sprintf(['tfGvD%i=c2d(gv.tfGv,%f,''zoh'')'],k,k*1e-6) ), end
for k=[10,20,25,50,100], eval( sprintf(['tfCCp1D%i=c2d(gv.tfCCred1,%f,''zoh'')'],k,k*1e-6) ), end
for k=[10,20,25,50,100], eval(sprintf(['Gp1D%i=gv.tfCCp1D%i*gv.tfGvD%i,%f;'],[1,1,1]*k,k*1e-6)), end
%%%%%%%%%%%%%%%%%%%%%%%%%%%
st=whos;
sc=struct2cell(whos)
%ind1=strfind(ss(1,:),'tf')   %var name
%ind2=strfind(ss(4,:),'tf')   %var class

ind1=find(~cellfun(@isempty,strfind(ss(4,:),'tf')))
ind2=find(~cellfun(@isempty,strfind(ss(4,:),'zpk')))

%%% erzeuge liste mit variablennamen welche zur class 'tf' gehören
Vars=ss(1,find(~cellfun(@isempty,strfind(ss(4,:),'tf'))))


return 
fia=@(x,y)findall(x,y)
fia(f2,{'type','line'})


return

for k=1:5
    G0(k,:)=tf(10,[1 k*8 3 4]);
end

marg=arrayfun(@allmargin, G0)
marg(1:2,1).PhaseMargin

ma1=struct2cell(marg(:))
ma1a=[cell2mat(ma1(3:4,:)); zeros(1,size(ma1,2)); cell2mat(ma1(5,:))] 

Tres=(cell2mat(ma1(3,:))*pi/180)./(cell2mat(ma1(4,:)))

ma2=struct2array(marg(1,1))


return


        clear s p

        num='s^2+3s+p*j';
        den='s^2+g3s+p*js+i';
        num='(s+1)*(s+2)';
        den='(s+4)*(s+1+2*j)*(s+1-2*j)';
        num='(s+1)*(s+2)';
        den='(s+1)*(s+2)*(s+7)';
        
        
        nude={num;den};
        search={'s';'k';'i';'j'};
        for k=1:length(search)
            is=strfind(nude,search{k});
            nude{1}([is{1,:}])=[];    
            nude{2}([is{2,:}])=[];    
        end
        if ~isempty(find(isstrprop(nude{1},'alpha'))) || ~isempty(find(isstrprop(nude{2},'alpha')))
            disp('ffff22 gggg')
            return
        end
        di={num,den}
        
        % -----------------------------------------------------
        % Nullstellen und Pole berechnen
        % -----------------------------------------------------
        solc=cellfun(@solve,di(:),'UniformOutput',false)
        z1=eval(solc{1,1})        
        p1=eval(solc{2,1})

        syms s
        % -----------------------------------------------------
        % Koeffizienten von Zähler- und Nennerpolynom
        % -----------------------------------------------------
        if ~isempty(symvar(num))
            znum=sym2poly(eval(num));
        end
        if ~isempty(symvar(den))
            zden=sym2poly(eval(den));
        end
        
        % -----------------------------------------------------
        % bleiben komplexe Koeffizienten übrig:
        % --> keine konjugiert komplexen pole vorhanen!
        % -----------------------------------------------------
        if ~isempty(find(imag(p1))) || ~isempty(find(imag(z1)))
            disp('imag')
        end
        
%        sym(solc{2,:}(3))
        
%             
%         is2=cell2mat(is)
%         is3=arrayfun(@isempty,is)        
         return
        
%         if cellfun(@find isstrprop(nude{x},'alpha'))
%             disp('unknown non- numeric')
%             return;
%         end
        nude=[];
        di={sym(num); sym(den)};
        solc=cellfun(@solve,di(:),'UniformOutput',false);
        
        return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hh=[1 0 1 1 2 6 0 -j 2];
hh2={1 {''} 1 1 2 6 0 -j 2};
%??????????????
find(~arrayfun(@isempty,hh2'))
find(~cellfun(@isempty,hh2'))
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 cellfun(@isempty, {'';'54';'ef'})
 
 
figChilds=[get(1,'Children') ; get(1,'Children')]

inc=strfind(get(figChilds(:),'type'),'axes')        % indexiere Childes vom type 'axes'
ind=find(~cellfun(@isempty,inc))            % take all children handles of all axes handle into structure

axisChilds=get(figChilds(ind),'Children')'
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
hh=[1 0 1 1 2 6 0 -j 2];
hh2={1 {''} 1 1 2 6 0 -j 2};

find(~arrayfun(@isempty,hh))
find(~cellfun(@isempty,hh2))
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:3, figure; end;

all=findall(0,'type','figure');
getWrap=@(x,y)get(x,y);

cell2mat(getWrap(all,'Position'))

return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms s
di={'s+4','','s+1+j','s+1-j','1','-1','s-3','s+3-2*j','s+3+2*j','7','-3','s-3'}

ind1=cellfun(@symvar,di,'UniformOutput',false)   % Test cell di including pole symbolic 
ind2=~cellfun(@isempty,ind1)
solc=cellfun(@solve,di(ind2),'UniformOutput',false)
sold=cellfun(@eval,solc,'UniformOutput',false)
sole=cell2mat(sold)
cmpxInd=find(arrayfun(@imag, sole))
try
    SOL=[cplxpair(sole(cmpxInd)) sort(sole(reInd))] 
catch err
    SOL=[]
    disp('he error')
end

reInd=find(~arrayfun(@imag, sole))
return
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% @@@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms s
di={'s+4','','s+1+j','s+1-j','1','-1','s-3'};

ind1=cellfun(@symvar,di,'UniformOutput',false)   %<----------
ind2=~cellfun(@isempty,ind1)
solc=cellfun(@solve,di(ind2),'UniformOutput',false)
sold=cellfun(@eval,solc,'UniformOutput',false)
sole=cell2mat(sold)
arrayfun(@imag, sole)

cplxpair(sole(find(arrayfun(@imag, sole)))) % Testen ob konj. komplexes polpar

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return

ed={'s+4','','s+1+j','s+1-j','1','-1','s-3'};


cellfun(@isempty, ed)
dd=cellfun(@symvar, ed,'UniformOutput',false)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cc=cellfun(@symvar,ed,'UniformOutput',false)   %<----------
cellfun(@isempty,cc)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return

clf
subplot(121)
f1=figure(1);
plot(rand(1,10));
hold all;
plot(rand(1,10));

subplot(122)

nyquist(tf([1 2],[1 3 4]));

% for q=1:5
%     buff{q}=get(hpoedit(q),'String');
% end

load('funcStruc')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all=findall(0,'type','text')
get(all(1),'String')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
st=@(x) get(x,'String')

a.string=@(x) get(x,'String');
a.tag=@(x) get(x,'tag');

ge=@(x) symvar(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a.string(all)

%s.a=@(x) arrayfun(@get,x)     % <--------------------------

%b=@(x,y) arrayfun(@(y)get,x,y)     % <--------------------------


return


S.a = @sin;  S.b = @cos;  S.c = @tan;
structfun(@(x)x(linspace(1,4,3)), S, 'UniformOutput', false)


days = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'};
abbrev = cellfun(@(x) x(1:3), days, 'UniformOutput', false)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num='s+1'; den='(s+2)*(s+3)*(s+2+3*j)*(s+2-3*j)'
di={sym(num); sym(den)}
solc=cellfun(@solve,di(:),'UniformOutput',false)
sold=cellfun(@eval,solc,'UniformOutput',false)
sole=cell2mat(sold)
cmpxInd=~isempty(arrayfun(@imag, sole))
reInd=isempty(arrayfun(@imag, sole))

try
    SOL=[cplxpair(sole(cmpxInd)) sort(sole(reInd))]; 
    disp('Alle pole liegen komplex konjugiert vor')
catch err
    SOL=[];
    disp('Nicht alle pole/NS sind konjugiert komplex! --> Komplexwertiges Zeitsignal')
end  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

return

rang=@(x)[min([x{:}]);max([x{:}])]
A={ sqrt(10*(rand(2,10)-0.5)), [sqrt(10*(rand(2,10)-0.5)) sqrt(10*(rand(2,5)-0.5))] }

%min([A{:}])
hh=rang(A(:))
min(hh(1))
max(hh(2))

min(hh(2))
max(hh(1))
return

ed={'s+4','','s+1+j','s+1-j','1','s-3'};
minW=@(x,y)min(x,y)
minW([1 2 3 3], [4 2 5 0.9])

gg=rand(2,10)-0.5;
min( minW(gg(1,:),gg(2,:)) )

return 

ed={'s+4','','s+1+j','s+1-j','1','s-3'};

clf
subplot(121)
f1=figure(1);
plot(rand(1,10));
hold all;
plot(rand(1,10));

subplot(122)

nyquist(tf([1 2],[1 3 4]));

% for q=1:5
%     buff{q}=get(hpoedit(q),'String');
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
all=findall(0,'type','text')
get(all(1),'String')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str=@(x) get(x,'String')
str(all)

a.string=@(x) get(x,'String')
a.tag=@(x) get(x,'tag')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
getWrap= @(x,y)get(x,y)
cell2mat(getWrap(ha,'Position'))/ppc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


s.a=@(x) arrayfun(@get,x)     % <--------------------------

b=@(x,y) arrayfun(@(y)get,x,y)     % <--------------------------


return


S.a = @sin;  S.b = @cos;  S.c = @tan;
structfun(@(x)x(linspace(1,4,3)), S, 'UniformOutput', false)


days = {'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'};
abbrev = cellfun(@(x) x(1:3), days, 'UniformOutput', false)

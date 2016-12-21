
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% @!@MDB
%% Vector frame Generator
% Project: XY-Galvoscanner
% Import csv data from 
% /media/storage/data_notebook/HS_Karlsruhe/xy_galvoscanner/mkv2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FILE = {'/media/storage/data_notebook/HS_Karlsruhe/xy_galvoscanner/mkv2/line1.csv',...
        ''};
FILEWRITE = {'/media/storage/data_notebook/HS_Karlsruhe/xy_galvoscanner/mkv2/line1w.csv'};
line1 = dlmread(FILE{1},',',1,0);

% choice = questdlg(qstring,'Boundary Condition',...
%     'Yes','No','Don''t know',options)

% Zero the y-column (single galvo)
line1(:,3)=0;

dlmwrite(FILEWRITE,line1)
% Normieren auf +-1.25

line1(:,2) = 2.5*line1(:,2)/65535;
%plot(line1(:,2), line1(:,1),'x')
arr.line1 = line1;
%% Write to C-conform header
FILE='/media/global_exchange/frameGen.h';
fd = fopen(FILE,'w');
N_SAMPS = length(line1)
tt=[1:N_SAMPS];
nam=strsplit(FILE,'/');
nam=upper(nam(end));
nam=strjoin(['__' strrep(nam, '.','_') '_'],'');

CC=75;      % target column char count
fprintf(fd, ['#ifndef ' nam ' \n',...
            '#define ' nam ' \n\n',...
            'int16_t *pSeq = NULL; \n',...
            'unsigned short cSeq;\n',...
            '\n#define NROWS %i\n\n'],N_SAMPS);

strList={'line1'};
arrTypes={'double'}
m=1;
%for m=1:length(strList)
    fprintf(fd,'\n%s %s[NROWS][3] = {\n', arrTypes{m}, strList{m});
    NC = 0;

    for k=1:length(tt)
        fprintf(fd, '{% 1.6f, % 1.6f, % 1.6f}\n', arr.(strList{m})(k,1),...
                                            arr.(strList{m})(k,2),...
                                            arr.(strList{m})(k,3));
        NC = NC + length(char(sprintf('%i, ', arr.(strList{m})(k))));
        
        if (NC >= CC)
%             fprintf(fd, '\n');
            NC=0;
        end
    end

    pos = ftell(fd)
    fseek(fd, -2,'cof');        % remove the last comma
    fprintf(fd,'\n};\n\n');
%end

fprintf(fd, '\n\n#endif\n');
fclose(fd);
type(FILE)

return 

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





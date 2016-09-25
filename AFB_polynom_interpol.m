% Polynominterpolation Übertragungsfunktion Sicherungsstrom AFB 
%
% 25-05-2013

clear all;
close all;


% Gemessene Wertetabelle
%I_channel = [1.1;1.276;1.428;1.623;1.878;2.255;2.801;3.7;4.446;5.44;7.132;8.6;9.959]
%U_adc = [0.155;0.225;0.284;0.362;0.46;0.606;0.827;1.178;1.472;1.862;2.4;2.6;2.62];

fid0 = fopen('/media/data/HS_Karlsruhe/highspeed-team/F-107/AFB_kalibrieren/AFB_kalibrierung_vektor_F1.csv','r'); 
fid1 = fopen('/media/data/HS_Karlsruhe/highspeed-team/F-107/AFB_kalibrieren/tableDot.csv','w'); 
fwrite(fid1,strrep(char(fread(fid0))',',','.')); 
fclose(fid0); 
fclose(fid1);

M = dlmread('/media/data/HS_Karlsruhe/highspeed-team/F-107/AFB_kalibrieren/tableDot.csv',';',1,0)

I_channel=M(:,1);
U_adc=M(:,2); 

% ----------------------
%  Uadc = f(I_channel)
% ----------------------
S=sprintf('Koeffizienten für I_channel=f(U_adc)\n');
%disp(S)
% Koeffizienten bestimmen
N=8;
p = polyfit (U_adc, I_channel, N)
%disp(p)

Str = cell(1,(N+1));
S=sprintf(' ');

for k=0:N
    if p(k+1) < 0
        Str{k+1}=sprintf('%f*_pow(V,%i)',p(k+1),(N-k));
    else
        Str{k+1}=sprintf('+%f*_pow(V,%i)',p(k+1),(N-k));
    end
    S=strcat(S,Str{k+1});
end

q=sprintf('\n\nInterpolation polynom: \n\n %s\n\n',S);
disp(q)

% Polynom bilden
f = polyval (p,U_adc);

x=(0: 0.1: 2.7);
%x=(0: 0.1: 600);
f2=polyval(p,x);

fig1=figure(5);
plot(U_adc,I_channel,'o',x,f2,'-')
axis([0  3  0  10])
grid on

% Error Plot
table=[I_channel-f];
fig2=figure(6);
plot(U_adc, table,'-')
axis([0  3  -1  1])
grid on

set(0,'Units','pixels') 
set(fig1,'OuterPosition',[467 547 560 420]);
set(fig2,'OuterPosition',[1045 548 560 420]);

% scnsize = get(0,'ScreenSize');
% position = get(fig1,'Position')
% outerpos = get(fig1,'OuterPosition')
% borders = outerpos - position
% edge = -borders(1)/2;
% pos1 = [edge,...
%         400,...
%         scnsize(3)/2 - edge,...
%         scnsize(4)/3];
% pos2 = [scnsize(3)/2 + edge,...
%         pos1(2),...
%         pos1(3),...
%         pos1(4)];

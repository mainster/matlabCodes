delete(findall(0,'type','line'));

param=loadGalvoParam(4);

evalGalvoParam;

SIMFILES = {'GalvoModel_v42',...
            'Motor_DC_POS_Simscape'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMO system inkl. Input/Output- Namen 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load_system(SIMFILES{1});
S = linmod(SIMFILES{1});
S.filename = SIMFILES{1};
u_ = strrep(S.InputName, [S.filename '/'], '');
y_ = strrep(S.OutputName, [S.filename '/'], '');
S.InputName = u_;
S.OutputName = y_;

G1 = ss(S.a, S.b, S.c, S.d, 'u', u_, 'y', y_);
[num, den] = ss2tf(S.a, S.b, S.c, S.d);
NUM=mat2cell(num, [ones(1, size(num,1))], size(num,2));
G1tf = tf(NUM, den, 'u', u_, 'y', y_); 

S1=S;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SIMO system inkl. Input/Output- Namen 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load_system(SIMFILES{1});
S = linmod(SIMFILES{2});
S.filename = SIMFILES{2};
u_ = strrep(S.InputName, [S.filename '/'], '');
y_ = strrep(S.OutputName, [S.filename '/'], '');
S.InputName = u_;
S.OutputName = y_;

G2 = ss(S.a, S.b, S.c, S.d, 'u', u_, 'y', y_);
[num, den] = ss2tf(S.a, S.b, S.c, S.d);
NUM=mat2cell(num, [ones(1, size(num,1))], size(num,2));
G2tf = tf(NUM, den, 'u', u_, 'y', y_); 

S2=S;

% f1=figure(1);
% hold on;
% step(G1, 50e-3);
% step(G2, 50e-3);
% hold off;

f2=figure(2);
hold on;
bode(G1tf(2)); 
bode(G2tf(2));
hold off;

legend('G1','G2');
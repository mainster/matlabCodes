%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Reference GalvoModel_v31 test SIMO
%%% 19-08-2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SIMU={  'GalvoModel_v31',... % reference model v31
        'GalvoModel_v3_discret_simo',...
        'GalvoModel_v3_PID_tfCC',...
        'GalvoModel_servolike_v2_simpli_B',...
        'GalvoModel_servolike_v2_simpli_B2',...
        'GalvoModel_servolike_v2'};
    
str=sprintf('%s',get(gcbh,'Name'));
vars=get(gcbh,'MaskVariables');
varsSplit=strsplit(vars,';');
i=cell2mat(regexp(varsSplit,'@.*?'))';

Kp_cc=85;
testKp=99;

for k=1:length(i)
    varsSplit{k}(i(k):length(varsSplit{k}))=[];
    varsSplit{k}=[varsSplit{k} sprintf('%i',eval(varsSplit{k}(1:end-1))) '\n'];
end

varsSplit

disp(varsSplit(:))
return

%-----------------------------------------
%---  linmod Galvo tf from simulink model
%-----------------------------------------
SIM_MOD=SIMU{1};
param=loadGalvoParam([]);
%open(SIM_MOD)

t2=linmod(SIM_MOD);
t2.filename=SIM_MOD;
t2.InputName=strrep(t2.InputName, t2.filename, '');
%[num2, den2] = linmod('GalvoModel_v3_discret_simo');
[num den]=ss2tf(t2.a,t2.b,t2.c,t2.d, 1);
sys2(:,2)=fieldnames(t2);
sys2(1,1)={t2};
sys2(:,3)=struct2cell(t2);
Gv=tf({num(1,:); num(2,:)}, den) %,...









%% GalvoModel_v160.slx model initializer script

P=loadGalvoParam(98)
p=struct;

for k=1:length(P)
    p.(P{k,1}).v=P{k,2};
    p.(P{k,1}).unit=P{k,3};
    p.(P{k,1}).desc=P{k,4};
end

JR=str2num(p.JR.v);
KEL=str2num(p.KEL.v);
RL=str2num(p.RL.v);
L=str2num(p.L.v);
KFR=str2num(p.KFR.v);
KTB=str2num(p.KTB.v);
KEMF=str2num(p.KEMF.v);
Rsh=str2num(p.Rsh.v);
KPOS1=str2num(p.KPOS1.v);
KPD=KPOS1;

FS=2e-6;

clear k p P
return

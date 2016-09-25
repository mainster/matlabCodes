% G1=zpk([],[-2, -3],1); G.Name='Plant modell';
% G1=zpk([],[4],3); G.Name='Unstable plant modell';
% G1=zpk([.1 1],[-0.1 -.2 2],1)

G0=-3*(14*s-1)*(s-1)/(s*(s-2)*(53*s+23))

% Single-loop configuration, C in forward path.
T = sisoinit(1);         
% Model for plant G.
T.G.Value = G0; 
% Initial compensator value, Value=1 means Kp=1.
T.C.Value = 1;
% Views for tuning Open-Loop OL1.
T.OL1.View = {'rlocus','nichols','bode'}; 
% Views for tuning Open-Loop OL1.
T.CL1.View = {'bode'}; 
% Launch SISO Design Tool using configuration T
controlSystemDesigner(T)


%Dann rechter-maus im root-locus fenster, add-poles->lead auswählen und im rlocus plott dann ein klick und der pol des lead glieds wird dort platziert. 

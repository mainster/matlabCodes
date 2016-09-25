%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Dominanz von Polen / Nullstellen
% G(s)=1/(s+1)+eps/(s+2)
% eps -1...0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
syms eps

eps=1;
out2=0.1;

f1=figure(1);
SUB=320;
open('RT_poles_epsilon');

for eps=-1:0.2:0
    pb1=tf([1],[1 1]);
    pb2=tf([eps],[1 2]);

    sys=pb1-pb2;
    SUB=SUB+1;
    subplot(SUB);
    h = pzplot(sys);
    axis([-2.2 0 -1 1]);
    p = getoptions(h); % Get options for plot.
    p.Title.String=sprintf('eps= %0.2f',eps);    
    p.YLabel.String='';
    p.XLabel.String='';
    setoptions(h,p); % Apply options to plot.
end

eps=0;
[numA denA]=linmod('RT_poles_epsilon');
[A,b,c]=linmod('RT_poles_epsilon');

% EW von 'sys'
% det(sI-A)
syms s;
ew=det(s*eye(2)-A);
ew1=eig(A);

sprintf('Auch mit eps=0 und dadurch G(s)=1/(s+1) sind die Eigwerte von A, eig(A): %i und %i',ew1(1),ew1(2))
ew

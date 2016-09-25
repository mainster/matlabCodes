% RT Labor S- Schrittantworten
%
% Autotuning PID- Regler beruhen auf der analyse der S- Schrittantwort

delete(findall(0,'type','line'));

MODE=0;

if MODE==0

    K=1;
    T1=0.134;   % <-- numerisch berechnen durch verfahren zur bestimmung der
            % Summenzeitkonstante

    G=zpk([],[-1/T1],K/T1,'Name','G');
    Gt=tf([K],[T1 1],'Name','Gt');


    f1=figure(1);
    hold all;
    step(G);
    legend G;
    step(Gt);
    grid on;
    hold off;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % Methode 1: Summenzeitkonstante
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

    i=2;
    A1v=zeros(1000,1);
    A2v=zeros(1000,1);

    Tx=0.05;
    dTx=0.001;

    while A1v(i-1)<=A2v(i-1)
        A1v(i)=Tx+T1*(exp(-Tx/T1)-1);
        A2v(i)=-T1*(0-exp(-Tx/T1));
        i=i+1;
        Tx=Tx+dTx;
    end

    A1v(1:i);
    A2v(1:i);

    sprintf('Ermitteltes T1 über Summenzeitkonst: T1 = %.3f',Tx-dTx)
    figure(f1);

    line ([(Tx-dTx) (Tx-dTx)],[0 1],'color','red','linestyle','--');

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
    % Methode 2: Zeitprozent- Kennwertmethode
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5

    % Approximation einer PT2-Strecke mittels Summenzeitkonstante Tsum

    T1=7;
    T2=3;

    Gsoll=zpk([],[-1/T1 -1/T2],[1/(T1*T2)],'Name','Gsoll')
    Tsum=4.3;
    Gapp=zpk([],[-1/Tsum],[1/Tsum],'Name','Gapp');
    Gapp2=zpk([],[-1/Tsum -1/Tsum],[1/Tsum*1/Tsum],'Name','Gapp^2');

    f2=figure(2);
    hold all;
    step(Gsoll);
    legend Gsoll;
    step(Gapp);
    step(Gapp2);
    grid on;
    hold off;

    axis([0 50 0 1]);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% Robustheit des RK 17.06.2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
Tsum=8.5;
T=round(10*Tsum/2)/10;
%T=Tsum/2;
Gapp=zpk([],[-T -T],1)

syms Kk;
y1=step(Gapp);
Krc=eval(solve(max(y1)*Kk==1,Kk))
Gapp2=zpk([],[-T -T],Krc);

syms p Kr Td Tn;
CpidSym=Kr*(Td*p^2+p+1./Tn)./p;
Cpid=sym2tf(subs(CpidSym,{'Kr' 'Td' 'Tn'},{10.3 0.5 2.6}));

Cpid=tf([7.21 10.3 4.017],[1 0]);

f3=figure(3);
SUB=120;

subplot(SUB+1);
hold on;
bode(Gapp)
bode(Gapp2)
%bode()
legend('Gapp','Gapp2');
grid on;
hold off;

subplot(SUB+2);
hold on;
bode(Cpid)
bode(Cpid*Gapp)
bode(feedback(Cpid*Gapp,1))
legend('Cpid','Cpid*Gapp','feedback(Cpid*Gapp,1)')
grid on;
hold off;

% f4=figure(4);
% SUB=120;
% 
% subplot(SUB+1);
% P=nyquistoptions;
% P.ShowFullContour='off'
% nyquist(Cpid*Gapp,P);




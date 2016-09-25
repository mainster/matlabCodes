% Estimating Simple Models from Real Laboratory Process Data
% http://www.mathworks.de/de/help/ident/examples/estimating-simple-models-from-real-laboratory-process-data.html?prodcode=ID&language=de

% System Description
% This case study concerns data collected from a laboratory scale
% "hairdryer". (Feedback's Process Trainer PT326; See also page 525 in
% Ljung, 1999). The process works as follows: Air is fanned through a tube
% and heated at the inlet. The air temperature is measured by a
% thermocouple at the outlet. The input (u) is the power over the heating
% device, which is just a mesh of resistor wires. The output is the outlet
% air temperature (or rather the voltage from the thermocouple).


% Vector y2, the output, contains 1000 measurements of temperature in the
% outlet airstream. Vector u2 contains 1000 input data points, consisting
% of the voltage applied to the heater. The input was generated as a binary
% random sequence that switches from one level to the other with
% probability 0.2. The sample time is 0.08 seconds.

delete(findall(0,'type','line'));

load dryer2;
dry = iddata(y2,u2,0.08);

dry

MODE = 1;

if MODE==0
    dry.InputName = 'Power';
    dry.OutputName = 'Temperature';
    dry.TimeUnit = 'seconds';
    dry.InputUnit = 'Watt';
    dry.OutputUnit = '^o C';

    % Now that we have the data set ready, we choose the first 300 data points
    % for model estimation.


    ze = dry(1:300)

    f1=figure(1);
    SUB=120;

    subplot(SUB+1);
    hold all;
    plot(ze(200:300));
    grid on;
    hold off;
    % From the above plot, it can be observed that the data is not zero mean.
    % So let us remove the constant levels and make the data zero mean.

    subplot(SUB+2);
    ze2 = detrend(ze);
    hold all;
    plot(ze2(200:300)) %show samples from 200 to 300 of detrended data
    grid on;
    hold off;

    %return

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Detrended estimation data.

    % Estimating Nonparametric and Parametric Models

    % Now that the dataset has been detrended and there are no obvious
    % outliers, let us first estimate the impulse response of the system by
    % correlation analysis to get some idea of time constants and the like:

    f3=figure(3);
    SUB=120;
    subplot(SUB+1);
    mi = impulseest(ze); % non-parametric (FIR) model
    showConfidence(impulseplot(mi),3); %impulse response with 3 standard
                                       %deviations confidence region
    grid on;

    % The shaded region marks a 99.7% confidence interval. There is a time
    % delay (dead-time) of 3 samples before the output responds to the input
    % (significant output outside the confidence interval). The simplest way to
    % get started on a parametric estimation routine is to build a state-space
    % model where the model-order is automatically determined, using a
    % prediction error method. Let us estimate a model using the ssest
    % estimation technique:

    m1 = ssest(ze);
    m1

    % The display suggests that the model is free-form (all entries of A, B and
    % C matrices were treated as free parameters) and that the estimated model
    % fits the data pretty well (over 90% fit). To retrieve the properties of
    % this model, for example to obtain the A matrix of the discrete
    % state-space object generated above, we can use the dot operator:

    A = m1.a;

    % See the "Data and Model Objects in System Identification Toolbox" example
    % for more information regarding model objects. To find out which
    % properties of the model object can be retrieved, use get command:

    get(m1)



    % To fetch the values of the state-space matrices and their 1 std
    % uncertainties, use the idssdata command:

    [A,B,C,D,K,~,dA,dB,dC,dD,dK] = idssdata(m1)

    subplot(SUB+2);


    h = bodeplot(m1);
    grid on;

    % Right-click on the plot and pick Characteristics->Confidence Region. Or,
    % use the showConfidence command to view the variance of the response

    showConfidence(h,3) % 3 std (99.7%) confidence region

    f4=figure(4);
    SUB=120;
    subplot(SUB+1)
    grid on;

    % Similarly, we can generate the step plot and its associated 3 std
    % confidence region. We can compare the responses and associated variances
    % of the parameteric model m1 with that of the nonparametric model mi:

    showConfidence(stepplot(m1,'b',mi,'r',3),3)


    subplot(SUB+2);
    Opt = nyquistoptions;
    Opt.ShowFullContour = 'off';
    showConfidence(nyquistplot(m1,Opt),3)
    grid on;
end

clf
f5=figure(5);
Ht1=pcsu1000import('ind 6');
Ht2=pcsu1000import('ind 7');
Ht3=pcsu1000import('ind 8');
Ht4=pcsu1000import('ind 10');

Ht1.dataSkal(:,2)=smooth(Ht1.dataSkal(:,2));
Ht1.dataSkal(:,3)=smooth(Ht1.dataSkal(:,3));
Ht2.dataSkal(:,2)=smooth(Ht2.dataSkal(:,2));
Ht2.dataSkal(:,3)=smooth(Ht2.dataSkal(:,3));
Ht3.dataSkal(:,2)=smooth(Ht3.dataSkal(:,2));
Ht3.dataSkal(:,3)=smooth(Ht3.dataSkal(:,3));

Ht4.dataSkal(:,2)=smooth(Ht4.dataSkal(:,2));
%Ht4.dataSkal(:,3)=smooth(Ht4.dataSkal(:,3));
i=1;
while Ht4.dataSkal(i,3) >-0.8
    Ht4.dataSkal(i,3)=0;
    i=i+1;
end

Ht4.dataSkal(:,3)=0;

for k=i+50:length(Ht4.dataSkal(:,3))
    Ht4.dataSkal(k,3)=1;
end

hold all;
plot(Ht1.dataSkal(:,1), smooth(Ht1.dataSkal(:,2)));
plot(Ht1.dataSkal(:,1), smooth(Ht1.dataSkal(:,3)));
grid on;
hold off;
xlabel('time [ms]');

f6=figure(6);

hold all;
plot(Ht2.dataSkal(:,1), smooth(Ht2.dataSkal(:,2)));
plot(Ht2.dataSkal(:,1), smooth(Ht2.dataSkal(:,3)));
grid on;
hold off;
xlabel('time [ms]');

f7=figure(7);

hold all;
plot(Ht3.dataSkal(:,1), smooth(Ht3.dataSkal(:,2)));
plot(Ht3.dataSkal(:,1), smooth(Ht3.dataSkal(:,3)));
grid on;
hold off;
xlabel('time [ms]');
legend('Ht3.dataSkal(:,2)','Ht3.dataSkal(:,3)');

f8=figure(8);
hold all;
plot(Ht4.dataSkal([so:1000+so],1), Ht4.dataSkal([so:1000+so],2));
plot(Ht4.dataSkal([so:1000+so],1), Ht4.dataSkal([so:1000+so],3));
grid on;
hold off;
xlabel('time [ms]');
legend('Ht4.dataSkal(:,2)','Ht4.dataSkal(:,3)');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% identify Galvo Model by h(t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

galv10 = iddata(Ht1.dataSkal(:,2),Ht1.dataSkal(:,3), Ht1.Ts);
galv10.InputName = 'CoilCurrent';
galv10.OutputName = 'AnglePos';
galv10.TimeUnit = 'seconds';
galv10.InputUnit = 'A';
galv10.OutputUnit = 'phi [^o] *skal ';

galv50 = iddata(Ht2.dataSkal(:,3), Ht2.dataSkal(:,2), Ht2.Ts);
galv50.InputName = 'CoilCurrent';
galv50.OutputName = 'AnglePos';
galv50.TimeUnit = 'seconds';
galv50.InputUnit = 'A';
galv50.OutputUnit = 'phi [^o] *skal ';

galv100 = iddata(Ht3.dataSkal(:,3), Ht3.dataSkal(:,2), Ht3.Ts);
galv100.InputName = 'CoilCurrent';
galv100.OutputName = 'AnglePos';
galv100.TimeUnit = 'seconds';
galv100.InputUnit = 'A';
galv100.OutputUnit = 'phi [^o] *skal ';

%Ht4=pcsu1000import('ind 10');

G010 = iddata(Ht4.dataSkal(:,3), Ht4.dataSkal(:,2), Ht4.Ts);
G010.InputName = 'CoilCurrent';
G010.OutputName = 'AnglePos';
G010.TimeUnit = 'seconds';
G010.InputUnit = 'A';
G010.OutputUnit = 'phi [^o] *skal ';

an=Ht4.dataSkal(900:2500,2)-min(Ht4.dataSkal(900:2500,2));
A_tinf=mean(an(600:end));
st=A_tinf*Ht4.dataSkal(900:2500,3);

plot(st); hold all; grid on;
plot(an); hold off;


G010mf = iddata(an*0.1,st,Ht4.Ts);
G010mf.InputName = 'CoilCurrent';
G010mf.OutputName = 'AnglePos';
G010mf.TimeUnit = 'seconds';
G010mf.InputUnit = 'A';
G010mf.OutputUnit = 'phi [^o] *skal ';

tf1=tf([1],[1 2 7])
tt=linspace(0,6,1000);
[out ttout]=step(tf1,tt);

in=ones(1000,10);
in(1:20,:)=0;

clear in;

in(1:1000)=1;
in=in';

for i=1:10
    outv(:,i)=awgn(out,i*25,'measured');
end

plot(outv(5,:)); hold all;
plot(in(5,:)); hold all;


idtest = iddata(awgn(out,50,'measured'),in,6/1000);



% Now that we have the data set ready, we choose the first 300 data points
% for model estimation.


clear ze;
ze = galv50(:)

f9=figure(9);
SUB=120;

subplot(SUB+1);
hold all;
plot(ze(200:300));
grid on;
hold off;

subplot(SUB+2);
ze2 = detrend(ze);
hold all;
plot(ze2(200:300)) %show samples from 200 to 300 of detrended data
grid on;
hold off;

return

f20=figure(20);

Ht4.dataSkal(:,2)=smooth(Ht1.dataSkal(:,2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Detrended estimation data.

% Estimating Nonparametric and Parametric Models

% Now that the dataset has been detrended and there are no obvious
% outliers, let us first estimate the impulse response of the system by
% correlation analysis to get some idea of time constants and the like:

f10=figure(10);
SUB=120;
subplot(SUB+1);
mi = impulseest(ze); % non-parametric (FIR) model
showConfidence(impulseplot(mi),3); %impulse response with 3 standard
                                   %deviations confidence region
grid on;

% The shaded region marks a 99.7% confidence interval. There is a time
% delay (dead-time) of 3 samples before the output responds to the input
% (significant output outside the confidence interval). The simplest way to
% get started on a parametric estimation routine is to build a state-space
% model where the model-order is automatically determined, using a
% prediction error method. Let us estimate a model using the ssest
% estimation technique:

m1 = ssest(ze);
m1

% The display suggests that the model is free-form (all entries of A, B and
% C matrices were treated as free parameters) and that the estimated model
% fits the data pretty well (over 90% fit). To retrieve the properties of
% this model, for example to obtain the A matrix of the discrete
% state-space object generated above, we can use the dot operator:

A = m1.a;

% See the "Data and Model Objects in System Identification Toolbox" example
% for more information regarding model objects. To find out which
% properties of the model object can be retrieved, use get command:

get(m1)



% To fetch the values of the state-space matrices and their 1 std
% uncertainties, use the idssdata command:

[A,B,C,D,K,~,dA,dB,dC,dD,dK] = idssdata(m1)

subplot(SUB+2);


h = bodeplot(m1);
grid on;

% Right-click on the plot and pick Characteristics->Confidence Region. Or,
% use the showConfidence command to view the variance of the response

showConfidence(h,3) % 3 std (99.7%) confidence region

f11=figure(11);
SUB=120;
subplot(SUB+1)
grid on;

% Similarly, we can generate the step plot and its associated 3 std
% confidence region. We can compare the responses and associated variances
% of the parameteric model m1 with that of the nonparametric model mi:

showConfidence(stepplot(m1,'b',mi,'r',3),3)


subplot(SUB+2);
Opt = nyquistoptions;
Opt.ShowFullContour = 'off';
showConfidence(nyquistplot(m1,Opt),3)
grid on;




syms p J psi rho R Kp w;
% Von hand berechneter ss
Ar2=[0 1; 0 -(psi^2+R*rho)/(R*J)];
br2=[0; psi/(J*R)];
cr2=[1;0]';

% tf des servos mit allen parametern als variable
plantSym=ss2sym(Ar2,br2,cr2,0);
% tf des Regelkreises mit allen parametern als variable
cLoopSym=(Kp*plantSym)/(1+Kp*plantSym);   
% tf der Kreisverstärkung mit allen parametern als variable
G0Sym=(Kp*plantSym);  

leadBr=tf([2.667 0.667],[2 1]);
sprintf('Lösung für Lead System von H. Brunner:');
leadBr
[p z]=pzmap(leadBr);
leadBrF=zpk(z,p,2*0.667,'DisplayFormat','frequency')
leadBrR=zpk(z,p,2*0.667,'DisplayFormat','roots')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
J=0.05;         % Trägheitsmoment Rotor
psi=0.5;        % Flussverkettung
rho=2e-4;       % Mech. Dämpfungskonstante
R=10;           % R Spule

G0KpSym=subs(G0Sym,{'psi','J','R','rho'},{psi, J, R, rho});
cLoopKpSym=subs(cLoopSym,{'psi','J','R','rho'},{psi, J, R, rho})
plant=sym2tf(subs(plantSym, {'psi','J','R','rho'},{psi, J, R, rho}));


%step(plant*y);

% 
 ar=sort(findall(0,'type','figure'));
 set(ar,'WindowStyle','docked');
% 



return


% Ident Galvo v1
%



ar=sort(findall(0,'type','figure'));
set(ar,'WindowStyle','docked');








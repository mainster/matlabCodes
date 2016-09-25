%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulate Stationary Processes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 1. Specify a model.
% Specify the AR(2) model where the innovation process is Gaussian with variance 0.1.

model = arima('Constant',0.5,'AR',{0.7,0.25},'Variance',.1);

% Step 2. Generate one sample path.
% Generate one sample path (with 50 observations) from the specified model, and plot.

rng('default')
Y = simulate(model,50);

f1=figure(1);
plot(Y)
xlim([0,50])
title('Simulated AR(2) Process')

% Because presample data was not specified, simulate sets the two required
% presample observations equal to the unconditional mean of the process,

% Step 3. Generate many sample paths.Generate 1000 sample paths, each with
% 50 observations.

rng('default')
Y = simulate(model,50,'numPaths',1000);

f2=figure(2);
subplot(2,1,1)
plot(Y,'Color',[.85,.85,.85])
title('Simulated AR(2) Process')
hold on
h=plot(mean(Y,2),'k','LineWidth',2);
legend(h,'Simulation Mean','Location','NorthWest')
hold off
subplot(2,1,2)
plot(var(Y,0,2),'r','LineWidth',2)
title('Process Variance')
hold on
plot(1:50,.83*ones(50,1),'k--','LineWidth',1.5)
legend('Simulation','Theoretical',...
       'Location','SouthEast')
hold off

% rng('default')
Y = simulate(model,50,'numPaths',1000);

f3=figure(3);
subplot(2,1,1)
plot(Y,'Color',[.85,.85,.85])
title('Simulated AR(2) Process')
hold on
h=plot(mean(Y,2),'k','LineWidth',2);
legend(h,'Simulation Mean','Location','NorthWest')
hold off
subplot(2,1,2)
plot(var(Y,0,2),'r','LineWidth',2)
title('Process Variance')
hold on
plot(1:50,.83*ones(50,1),'k--','LineWidth',1.5)
legend('Simulation','Theoretical',...
       'Location','SouthEast')
hold off

% The simulation mean is constant over time. This is consistent with the
% definition of a stationary process. The process variance is not constant
% over time, however. There are transient effects at the beginning of the
% simulation due to the absence of presample data.The simulated variance
% approaches the theoretical variance, ....... by around the 50th observation.


% Step 4. Oversample the process.To reduce transient effects, one option is
% to oversample the process. For example, to sample 50 observations, you
% can generate paths with more than 50 observations, and discard all but
% the last 50 observations as burn-in. Here, simulate paths of length 150,
% and discard the first 100 observations.

rng('default')
Y = simulate(model,150,'numPaths',1000);
Y = Y(101:end,:);

f4 = figure(4);
subplot(2,1,1)
plot(Y,'Color',[.85,.85,.85])
title('Simulated AR(2) Process')
hold on
h=plot(mean(Y,2),'k','LineWidth',2);
legend(h,'Simulation Mean','Location','NorthWest')
hold off
subplot(2,1,2)
plot(var(Y,0,2),'r','LineWidth',2)
xlim([0,50])
title('Process Variance')
hold on
plot(1:50,.83*ones(50,1),'k--','LineWidth',1.5)
legend('Simulation','Theoretical',...
       'Location','SouthEast')
hold off

% The realizations now look like draws from a stationary stochastic
% process. The simulation variance fluctuates (due to Monte Carlo error)
% around the theoretical variance.





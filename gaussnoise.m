function gaussnoise (NN, RES, varargin)
%% Plot amplitude distribution of a discret white-noise vector  @@@MDB
%
% NN:   length of noise vector
% RES:  length of distribution interval 
if nargin == 3
    h1=varargin{1};
else
    h1=figure(1);
    clf;
end

n0=wgn(1,NN,0); 
resv=linspace(min(n0),max(n0),RES); 

for k=1:RES 
    Gt(k)=eval(sprintf('sum(n0>%.2g), ',resv(k))); 
    St(k)=eval(sprintf('sum(n0<%.2g), ',-resv(k))); 
end; 

figure(h1);
hold all;
plot([fliplr(St),Gt]); grid on;
hold off;


end

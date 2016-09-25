% Programm CFIR_1.m


R = 4;
M = 2;
N = 2;

f1 = 0.1;
f2 = 0.3;
df = 0:0.005:f1;
f = [df, f1, f2, 1];
m = [1./(sinc(df*R*M).^N), 1./(sinc(f1*R*M).^N), 0, 0];

% -------- CFIR-Filter
h = firpm(64,f,m);
[H,w]= freqz(h,1,512,1);

figure(1);    clf;
freqz(h,1,512,1);

%return
% --------
f1 = 0.1;
f2 = 0.3;
df = 0:0.005:f1;
f = [df, f1, f2, 1];
%m = [(sinc(df*R*M).^N),(sinc(f1*R*M).^N), 0, 0];
m = [(sinc(f*R*M).^N)];

h1 = firpm(128,f,m);
[H1,w]= freqz(h,1,512,1);

hold on
freqz(h1,1,512,1);
hold off

figure(2);
plot(f,m);

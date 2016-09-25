clear all;
rect = @(x, wi, tau) heaviside(x+wi/2+tau) - heaviside(x-wi/2+tau)

syms t w;
ttm=[-5:0.02:5];

x1 = @(t) rect(t,1,0);

f1 = figure(1); clf;
SUB=220;
subplot(SUB+1);
plot(ttm, x1(ttm));
hold all;
grid on;

X1 = str2func(['@(w)' char( fourier(x1(t),t, w) )])
X1a = @(w)real( (cos(w/2)*i+sin(w/2))/w-(cos(w/2)*i-sin(w/2))/w )

ww=[-5:0.05:5];
subplot(SUB+2);
ezplot(X1(w));
hold all;
grid on;

subplot(SUB+3);
plot(ww,real(X1(ww)));
hold all;
grid on;

subplot(SUB+4);
plot(ww,real(X1a(ww)));
hold all;
grid on;



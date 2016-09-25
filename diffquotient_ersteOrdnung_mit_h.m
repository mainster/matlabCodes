%Differenzenqutient 1.Ordnung berechnen
%Funktion: z=5.*cos(x)+x.^3-2.*x.^2-6.*x+10;
tic;
x= [0:0.01:4];

%rote Kurve
fs0=-5.*sin(x)+3.*x.^2-4.*x-6;

h=1e-12;%blaue Kurve
fs1=(f(x+h)-f(x-h))/(2*h);

h=0.01;%grüne Kurve
fs2=(f(x+h)-f(x-h))/(2*h);



%plot (x,fs0,'r',x,fs1,'b',x,fs2,'g','linewidth',2)
%plot (x,fs0,'r',x,fs1,'g','linewidth',2)

toc
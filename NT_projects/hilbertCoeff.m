% Compute Hibert FIR Filter coeffi..

colorgrey = [211 ,211 ,211]/255;
N= 51;
n =0:N-1;
h = 2./(pi*(n-(N-1)/2)).*(rem(n,2)~=0);
h(26) = 0;
stem(n,h,'*'),xlabel('n'),ylabel('h[n]')
N = 50;
n = 0:N-1;
h = (1./(2*pi*(n-(N-1)/2))).*(1-cos(pi*(n-(N-1)/2)));
figure, stem(n,h,'*'),xlabel('n'),ylabel('h[n]');




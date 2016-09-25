% 
a=1;b=2;c=3;
[num den]=linmod('symbolic_test');

sys1=tf(num,den);
sys1

nyquist(sys1)
function [sys]=identsys(data)

t=data(1,:);
u=data(2,:)-data(2,5);
y=data(3,:)-data(3,5);

%t=downsample(t,2);
%u=downsample(u,2);
%y=downsample(y,2);

Ts=t(2);

%B=fir2(10,[0 0.05 0.05 1],[1 1 0 0]);
%u=filter(B,1,u);
%y=filter(B,1,y);

plot(u)
hold on
plot(y),grid

region=input('Region: ');
k=input('Delay: ');

theta00 = lls(u(region)', y(region)', 0, 0, k);
theta10 = lls(u(region)', y(region)', 1, 0, k);
theta11 = lls(u(region)', y(region)', 1, 1, k);
theta20 = lls(u(region)', y(region)', 2, 0, k);
theta21 = lls(u(region)', y(region)', 2, 1, k);
theta22 = lls(u(region)', y(region)', 2, 2, k);

sys00=tf([theta00(1)],[1],Ts);
sys10=tf([theta10(2)],[1 theta10(1)],Ts);
sys11=tf([theta11(3) theta11(2)],[1 theta11(1)],Ts);
sys20=tf([theta20(3)],[1 theta20(1) theta20(2)],Ts);
sys21=tf([theta21(4) theta21(3)],[1 theta21(1) theta21(2)],Ts);
sys22=tf([theta22(5) theta22(4) theta22(3)],[1 theta22(1) theta22(2)],Ts);

sys00.InputDelay=k-1;
sys10.InputDelay=k-1;
sys11.InputDelay=k-1;
sys20.InputDelay=k-1;
sys21.InputDelay=k-1;
sys22.InputDelay=k-1;

y00=lsim(sys00,u,t);
y10=lsim(sys10,u,t);
y11=lsim(sys11,u,t);
y20=lsim(sys20,u,t);
y21=lsim(sys21,u,t);
y22=lsim(sys22,u,t);

iae00=iae(y(1000:end)',y00(1000:end));
iae10=iae(y(1000:end)',y10(1000:end));
iae11=iae(y(1000:end)',y11(1000:end));
iae20=iae(y(1000:end)',y20(1000:end));
iae21=iae(y(1000:end)',y21(1000:end));
iae22=iae(y(1000:end)',y22(1000:end));

rt200=rt2(y(1000:end)',y00(1000:end));
rt210=rt2(y(1000:end)',y10(1000:end));
rt211=rt2(y(1000:end)',y11(1000:end));
rt220=rt2(y(1000:end)',y20(1000:end));
rt221=rt2(y(1000:end)',y21(1000:end));
rt222=rt2(y(1000:end)',y22(1000:end));

figure(1)
subplot(6,1,1)
plot(t,y,t,y00,t,y00)
subplot(6,1,2)
plot(t,y,t,y10,t,y10)
subplot(6,1,3)
plot(t,y,t,y11,t,y11)
subplot(6,1,4)
plot(t,y,t,y20,t,y20)
subplot(6,1,5)
plot(t,y,t,y21,t,y21)
subplot(6,1,6)
plot(t,y,t,y22,t,y22)

figure(2)
bar([iae00 iae10 iae11 iae20 iae21 iae22])

figure(3)
bar([rt200 rt210 rt211 rt220 rt221 rt222])

sys=[sys10 sys11; sys20 sys21];
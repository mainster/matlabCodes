clear all, clc, tic, clf;
n=16000
t=linspace(0,2*pi,n);
y=cos(6*t)+sin(4*t);

%find zero crossings
t1=y(1:n-1);
t2=y(2:n);
tt=t1.*t2;
indx=find(tt<0)
plot(tt)

figure

%1) start at first zero crossing going positive 
%2) get 8000 pts 
%3) and after the 8000 points continue appending points until a zero crossing going down section is found
new_y=y(indx(1,1):8000); %start at zero section found get 8000 pts
subplot(2,1,1);plot(y);title('Original Signal')
subplot(2,1,2);plot(new_y);title('New signal')

return
%%
n=16000
t=linspace(0,2*pi,n);
MxN = cos(6*t)+sin(4*t);

ds = diff(MxN(1,:)) / size(MxN,2); 
d2s = del2(MxN(1,:)) / size(MxN,2);  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find zeros, create index vector (>0 ; <0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=size(MxN,2);
zero{1}=find(MxN(1,1:n-1).*MxN(1,2:n)<0)';
idx{1} = {  find( (MxN(1,1:end-1)<0) & (ds>0) )',...
            find( (MxN(1,1:end-1)<0) & (ds<0) )' };

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Find zero crossing of second derivative
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=size(ds,2);
zero{2}=find(ds(1,1:n-1).*ds(1,2:n)<0)';
% idx{2}{1}([ für > 0])  //  idx{2}{2}([ für < 0]
idx{2} = {  find( (ds(1,:)<0) & (d2s(1:end-1)>0) )',...
            find( (ds(1,:)<0) & (d2s(1:end-1)<0) )' }
        
new_y=MxN(idx{1}{1}:8000); %start at zero section found get 8000 pts
subplot(2,1,1);
hold all;
plot(MxN);title('Original Signal')
plot(new_y);title('Original Signal + new_w')
hold off
subplot(2,1,2);plot(new_y);title('New signal')

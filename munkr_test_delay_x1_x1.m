[wavMic, opt] = audioCapture(8000,'select','mic','overwrite','no');

x = wavMic(6000:end-4001);
size(x)
x1=x(1:1000);
x1(400:600)=ones(1,201)*3e-3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% test1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    m1=InputMatFramerAbgespeckt(x1,x1, 1000);
    [~, cost] = munkres(m1)
end

x2=[x1(end-200:end); x1(1:end-201)];
size(x2);

x2(354)
%x2(354:500) = x2(354:500)+10;
x2(354) = x2(354)+3.3;

fn=figure(66); clf;

subplot(211); plot(x1); hold all;
subplot(212); plot(x2); grid on;
ylim([-4 4]*1e-3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% test2 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    m2=InputMatFramerAbgespeckt(x1,x2, 1000);
    [~, cost] = munkres(m2)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% test3 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[wavMic, opt] = audioCapture(8000,'select','mic','overwrite','no');

clear x1r x2r
NN = 100;


x = wavMic(6000:end-4001);
size(x)
x1=x(1:NN);
x1(NN/2:NN/2+30-1)=ones(1,30)*3e-3;
x2=[x1(end-10:end); x1(1:end-11)];

x2(30) = x2(30)+20e-3;

%%
noise = rand(NN,1)*1e-3;
size(x1)
size(x2)
size(noise)

x1r = x1+noise ;
x2r = x2+noise ;

figure(67); clf; plot(x1); hold all; plot(x1r)
figure(68); clf; plot(x2); hold all; plot(x2r)

%%

if 1
    m3=InputMatFramerAbgespeckt(x1,x1r, NN);
    [~, cost1] = munkres(m3)
fn=figure(70); clf;
subplot(211); plot(x1); hold all;
subplot(212); plot(x1r); grid on;
% ylim([-4 4]*1e-3);


    m3=InputMatFramerAbgespeckt(x1,x2r, NN);
    [~, cost2] = munkres(m3)
fn=figure(71); clf;
subplot(211); plot(x1); hold all;
subplot(212); plot(x2r); grid on;

abs(cost1-cost2)
% ylim([-4 4]*1e-3);
end
%%
fmat = InputMatFramer(x1',x1r', 100);

%[~, lags]=xcorr(x1,x2)

% x2=[x1(end-500:end) x1(1:end-499) ]



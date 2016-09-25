% load compensator file and plot random test signal responses of different
% controler connected to plant models tfCC and tfGv

if exist('f10')
    delete(findall(f10,'type','line'));
end
if exist('f11')
    delete(findall(f10,'type','line'));
end

compsStr=load('Cselfs');
load('Cselfs','tfCC','tfGv');
member=struct2array(compsStr);
fields=fieldnames(compsStr);
delInd=[find(~cellfun(@isempty,strfind(fields,'tfCC'))),...
         find(~cellfun(@isempty,strfind(fields,'tfGv')))];
member(delInd) = [];
fields(delInd) = [];


% mfs{1,1}(4)   tf des 4. members
% mfs{1,2}(4)   name des 4. members

opts = pidtuneOptions('PhaseMargin',30);
[tfCTRL_a,info] = pidtune(( tfCC*tfGv ),'pidf',1.84e4,opts);
member(end+1)=tfCTRL_a;
fields(end+1)={'tfCTRL_a'};

N=size(member,2);
mfs={member,fields};

%-------------------------------
%---  random testsignal
%-------------------------------
y=[];
y=-0.5+rand(1,20);

y2=[];
for k=1:20
    y2=[y2 ones(1,500)*y(k)];
end

uw=y2*5;
%-------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f10=figure(10);
n=round(sqrt(N))
marg=[0.03 0.03];

for k=1:N
%    hs(k)=subtightplot(n,n,k,marg);
    hs(k)=subtightplot(2,3,k,marg);
end


st=[];
for k=1:N
    [ysim(k,:) tsim]=lsim(  feedback(mfs{1,1}(k)*tfCC*tfGv,1),...
                            uw,linspace(0,100e-3,length(uw)));
    st=[st ':' mfs{1,2}{k} ];
end
yl=[round(min(min(ysim))),round(max(max(ysim)))]

for k=1:N
    subplot(hs(k));
    hold all;
    plot(tsim,uw,'b--','LineWidth',2)
    plot(tsim,ysim(k,:),'r-','linewidth',1);
    hold off;
    grid on;
    ylim(yl);
    legend('testsig', mfs{1,2}{k})
end
legend(strsplit(st,':'))
grid on;
hold off;

ya=step(feedback(compsStr.tfCTRL_s*tfCC*tfGv,1),linspace(0,1e-3,500));
yb=step(feedback(G0(1,:),1),linspace(0,1e-3,500),'r--');

f11=figure(11);
hold all;
plot(linspace(0,1e-3,500),ya,'linewidth',3)
plot(linspace(0,1e-3,500),yb,'r--')
hold off;
grid on;





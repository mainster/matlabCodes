% RT Klausuraufgabe
% SS2014
% 
% P(s)=(s-1)/((s+2)(s^2+s+2))
% C(s)=?
%
% Anforderung an C(s):
%
% Stabiler RK und die Pole von Gtot sollen reell sein!
% Erst idealer PD- Regler dann realer PD Regler
%
delete(findall(0,'type','line'))
clf


f1=figure(1);
SUB=330;
tt=[0:0.05:20];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subplots erzeugen und handles in vektor ablegen
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:9
    hs(i)=subplot(SUB+i);
end


lightGray=[1 1 1]*0.6;

p1=zpk([2],[-2 -1-j -1+j],1);
c1=zpk([],[],1);
c2=zpk([-2],[],1);
c3=zpk([-0.5],[-20],1);

G0(1)=c1*p1;
G0(2)=c2*p1;
G0(3)=c3*p1;

clear m n rs phi hl dw

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% zähler/nennergrade, rel. systemgrade, wurzelschwerpunkte,
% asymptotenwinkel, xrange min/max  für alle G0's in 
% vektoren schreiben
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[a b]=size(G0);
Ntf=max(a,b);

for i=1:Ntf
    m(i)=length(G0(i).z{:});
    n(i)=length(G0(i).p{:});
    nrel(i)=n(i)-m(i);
    tmp=1/nrel(i)*( sum(real(G0(i).p{:}) )-( sum(real(G0(i).z{:})) ));
    dw(i)=eval(sym(1)*tmp);
    asym{i}=round( (2*[0:1:nrel(i)-1]+1)*pi/nrel(i)*180/pi);
    lo=min(min(min(real(G0(i).p{:}),dw(i))) , min(min(real(G0(i).z{:}),dw(i))) );
    up=max(max(max(real(G0(i).p{:}),dw(i))) , max(max(real(G0(i).z{:}),dw(i))) );
    xRan(i,:)=[lo up];
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alle subplots erzeugen und asymptoten einzeichenn
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
subc=1;
for pp=1:3
    
    subplot(hs(subc));

    for i=1:length(asym{pp})
        line([dw(pp) dw(pp)],[-0.5 0.5]);
        ha(i)=line([dw(pp) 10],[0 0],'LineStyle','-.',...
            'Color',lightGray,'LineWidth',0.2);
       rotate(ha(i),[0 0 1],asym{pp}(i),[dw(pp) 0 0]);
    end
    hold all;
    
    rlocus(G0(pp));
%    legend('q1*p1');
    
    subplot(hs(subc+1));
    hold all;
    %pzmap(c1,'r');
    hold all;
    pzmap(G0(pp),'b');
    pzmap(feedback(G0(pp),1),'r');
    hold off;
%    legend('q1*p1')

    subplot(hs(subc+2));
    step(feedback(G0(pp),1),tt); grid on;
    
    subc=subc+3;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% alle subplots formatieren
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
yRan=[-10 10; -1.5 1.5; -10 10];
sel=[1 2; 4 5; 7 8];
for i=1:3
    set(hs(sel(i,:)),'XLimMode','manual','YLimMode','manual',...
        'XLim',xRan(i,:)*1.2,'YLim',yRan(i,:));
end

return




syms Tv Tp

dwdef=-2.5-(Tv-Tp)/(Tp*Tv);

dw=subs(dwdef,{'Tv','Tp'},{0.5,[1e-6:1e-3:50e-3]'});


plot(dw)

return;
qs=tf(10,[1 20]);
ps=tf(1,[1 1 0]);

Ps=zpk([],[0 -1 -20],10);

Kr=1;
cs1=Kr;
cs2=zpk([-7],[],Kr);
cs3=zpk([-1],[-1/3],Kr);

MODE=3;

if MODE==1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 1 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f1=figure(1);
SUB=330;
tt=[0:0.05:20];

subplot(SUB+1);
rlocus(cs1*Ps)
legend('cs1')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+2);
pzmap(cs1*Ps)
legend('cs1*Ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+3);
step(feedback(cs1*qs*ps,1),tt); grid on;

subplot(SUB+4);
rlocus(cs2*Ps)
legend('cs2*Ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+5);
pzmap(cs2*Ps)
legend('cs2*Ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+6);
step(feedback(cs2*qs*ps,1),tt); grid on;

subplot(SUB+7);
rlocus(cs3*Ps)
legend('cs3*Ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+8);
pzmap(cs3*Ps)
legend('cs3*Ps')
xlim([-30 5])
ylim([-10 10])

subplot(SUB+9);
step(feedback(cs3*Ps,1),tt); grid on;

MODE=2;
end

if MODE==2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% Figure 2 %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f2=figure(2);
S=[4,3];
tt=[0:0.05:20];

Kr=1;
cs2v(1)=zpk([-3],[],Kr);
cs2v(2)=zpk([-5],[],Kr);
cs2v(3)=zpk([-7],[],Kr);
cs2v(4)=zpk([-9],[],Kr);

k=1;
for i=1:4
    subplot(S(1),S(2),k); k=k+1;
    rlocus(cs2v(i)*qs*ps)
    xlabel(''); ylabel(''); title('');

    %    legend(sprintf('cs2v(%i)',i));
    xlim([-30 5])
    ylim([-10 10])

    subplot(S(1),S(2),k); k=k+1;
    pzmap(cs2v(i)*qs*ps)
    xlabel(''); ylabel(''); title('');
    xlim([-30 5])
    ylim([-10 10])

    subplot(S(1),S(2),k); k=k+1;
    step(feedback(cs2v(i)*qs*ps,1),tt); grid on;
    xlabel(''); ylabel(''); title('');
    legend(sprintf('cs2v(%i)*qs*ps',i));

end
    MODE=3;

end

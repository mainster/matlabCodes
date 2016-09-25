%%% Ordnung der Pole/Nullstellen bei pzmap in klammer dazu schreiben

wv=[-20:0.1:20];
P=nyquistoptions;
P.showFullContour='off';


f13=figure(13);
SUB=240;
clf;

%    G0sym=0.4*(p^2-2*p+10)/(p+2)^3;
tf1=zpk([1-3*j 1+3*j],[-2 -2 -2],0.4);  % Original Aufgabe
tf2=zpk([-1-3*j -1+3*j],[-2 -2 -2],0.4);
tf3=zpk([-1 -1],[-2 -2 -2],0.4);
tf4=zpk([1 1],[-2 -2 -2],0.4);

syss(1)=tf1;
syss(2)=tf2;
syss(3)=tf3;
syss(4)=tf4;

clear zRE zIM pRE pIM zC izz izc zhc pC ipp ipc phc

for i=1:length(syss.z)
    zRE(i,:)=real(syss.z{i});
    zIM(i,:)=imag(syss.z{i});
    [zC(i,:) izz(i,:) izc(i,:)]=unique(syss.z{i});
    if sum(abs(imag(syss.z{i}))) == 0
        zhc(i,:)=histc(syss.z{i},zC(i,:));
    else
        zhc(i,:)=histc(angle(syss.z{i}),angle(zC(i,:)));
    end
end

for i=1:length(syss.p)
    pRE(i,:)=real(syss.p{i});
    pIM(i,:)=imag(syss.p{i});
    [pC(i,:) ipp(i,:) ipc(i,:)]=unique(syss.p{i});
    phc(i,:)=histc(syss.p{i},pC(i,:));
end
    
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Alle pzmaps gleich skalieren, suche max und min für Re- und Im-Achse
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    reAx=[min([min(zRE) min(pRE)]) max([max(zRE) max(pRE)])];
    imAx=[min([min(zIM) min(pIM)]) max([max(zIM) max(pIM)])];

    if (diff(reAx)==0 | diff(imAx)==0)
        if diff(reAx)==0
            reAx=[-1 1];
        else
            imAx=[-1 1];
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for i=1:4
        subplot(SUB+i);
        pzmap(syss(i))
        xlim(reAx*1.2)
        ylim(imAx*1.2)
        
        for k=1:length(zC(i,:))
            if zhc(i,k)>1           % NS- ordnung erst bei grad größer 1
                text(zC(i,k),0.1,sprintf('(%d)',zhc(i,k)),...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment','bottom')
            end
        end
        
        for k=1:length(pC(i,:))
            if phc(i,k)>1           % Polordnung erst bei grad größer 1
                text(pC(i,k),-0.1,sprintf('(%d)',phc(i,k)),...
                    'HorizontalAlignment','center',...
                    'VerticalAlignment','top')
            end
        end
        
        
    end
    
    subplot(SUB+5);
    nyquist(syss(1),P);
    legend('syss(1)')
    subplot(SUB+6);
    nyquist(syss(2),P);
    legend('syss(2)')
    subplot(SUB+7);
    nyquist(syss(3),P);
    legend('syss(3)')
    subplot(SUB+8);
    nyquist(syss(4),P);
    legend('syss(4)')

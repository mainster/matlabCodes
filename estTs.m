function estTs (sys, varargin)
% 
% OPEN_LOOP_MODEL (continuous)
% 
% varargs:
% 
% OVERWRITE_FIG
% OPEN_LOOP_MODEL (discret)
%
%////////////////////////////////////////////////////////
%///////    resonanzfrequenz über sprungantwort messen
%////////////////////////////////////////////////////////
if nargin==0,
    error( 'Openloop gain Model needed for raw estimating Samplerate' );
elseif nargin==1,
    overwriteFig = 0;
    sysD = [];
elseif nargin==2,
    overwriteFig = varargin{1};
    sysD = [];
elseif nargin==3,
    overwriteFig = varargin{1};
    sysD = varargin{2};
else
    error('bad parameters')
end
[null tempTime]=step(feedback(sys,1));

[yst ty]=step(feedback(sys,1),linspace(0,max(tempTime),2000)); 
stat=dcgain(feedback(sys,1));

try
    fi(1)=find(yst >= stat, 1);
    fi(2)=find(yst(fi(1)+1:end) <= stat, 1);
    fi(2)=sum(fi(1:2));
    fi(3)=find(yst(fi(2)+1:end) >= stat, 1);
    fi(3)=sum(fi(2:3));
    fi(4)=find(yst(fi(3)+1:end) <= stat, 1);
    fi(4)=sum(fi(3:4));
catch err
    disp('not all dcgain crosses detected')
    fi*max(tempTime)/2000
end

getWrap=@(x,y)get(x,y);

if overwriteFig==0
    if isempty(max(findall(0,'type','figure')))
        fn=figure(1);
    else
        fn=figure(1+max(findall(0,'type','figure')));
    end
else
    hdls=(getWrap(findall(0,'type','figure'), 'Tag' ));
    hdls1= find(~cellfun(@isempty,{ strfind(hdls,'estTs_figure') }));
    figs=findall(0,'type','figure');
    if isempty(figs)
        if isempty(max(findall(0,'type','figure')))
            fn=figure(1);
        else
            fn=figure(1+max(findall(0,'type','figure')));
        end
    else
        fn=figs(hdls1(1));
    end
    
end
    
set(fn,'Tag','estTs_figure');
    
marg=[0.03 0.03];
hs2(1)=subtightplot(2,2,1,marg);
hs2(2)=subtightplot(2,2,2,marg);
hs2(3)=subtightplot(2,2,3:4,marg);

subplot(hs2(3));
hold all;
plot(ty,yst);
plot(ty(fi),stat*ones(1,length(fi)),'rX','MarkerEdgeColor','r',...
                'MarkerFaceColor', 'k', 'MarkerSize',10,...
                'LineWidth',2);
plot(ty([1,end]), stat*ones(1,2),'r--')   
grid on;
hold off;
legend('DCgain','tfCTRL_s * Gp');

per=[];
xy=[];

if length(fi)<=3
    fi(end+1)=0;
end
for k=1:1:length(fi)-1
    if fi(k+1) ~= 0
        per=[per; (abs( diff(ty(fi(k:k+1))) ))];
        xy=[xy; sum(ty(fi(k:k+1)))/2, 0.7*stat];
        text(xy(k,1),xy(k,2), sprintf('%.2f us',per(k)*1e6 ),...
                    'BackgroundColor',[.95 .95 .95],'EdgeColor',[0 0 0],...
                    'HorizontalAlignment','center');
    end
end

if length(per) < 2        
    Tperi=2*per;                
else
    Tperi=sum(per(1:2));                
end

text(ty(end/2),0.55*stat, sprintf('T_{peri}= %.0f us',Tperi*1e6 ),...
            'BackgroundColor',[.8 .9 .7],'EdgeColor',[0 0 0],...
            'HorizontalAlignment','center');
text(ty(end/2),0.4*stat, sprintf('f_r = %.3f kHz',(0.1*Tperi)^(-1)*1e-3 ),...
            'BackgroundColor',[.8 .9 .7],'EdgeColor',[0 0 0],...
            'HorizontalAlignment','center');



text(ty(end/2),0.25*stat, sprintf('In "Mann/ Schiffelgen/ Froriep" S.290 wird als\n Fausformel fuer die Abtastrate ca. 0.1*T_{peri} angegeben'),...
            'BackgroundColor',[.8 .9 .7],'EdgeColor',[0 0 0],...
            'HorizontalAlignment','center');
[sprintf('Tperi = %.3fus\t-->\tTs = 0.1*Tperi = %.3fus',Tperi*1e6, 0.1*Tperi*1e6),...
sprintf('\nfr = %.3fkHz\t-->\tfs = 10*fr = %.3fkHz',(Tperi^(-1))*1-3, ((0.1*Tperi)^(-1))*1e-3)]

end        
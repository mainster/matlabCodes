function [varargs] = classification_2bit(varargin)

%% [CLASS_SEQ] = classification_2bit(MxN)     @@@MDB
% 
% Klassifizierung von M eindimensionalen Sequenzen der länge N. 
%
% MxN:          Eingangsmatrix mit M Sequenzen der länge N
% CLASS_SEQ:	klassifizierte Ausgangsmatrix von MxN
%
% Symbole: 
% R ( 1):   Steigende Flanke
% F (-1):   Fallende Flanke
% V:(-2):   Minimum
% M:( 2):   Maximum 
%
% example usage:
%
% tt=[0:0.002:1];
% classification_2bit(sin(2*pi*1*tt)+sin(2*pi*7*tt),'plot')
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%    Algorithmen und Datenstrukturen - ADS bei Prof. Schäfer     %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%	Sprachanalyse I                                             %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Die Zuordnung verschiedener Signalgruppen innerhalb eines Kurvenzuges
% bestimmen die Problemlösungen sowohl bei der akustischen
% Kommandoerkennung als auch bei der Stereoskopie. Das Finden von
% Zuordnungen kann durch den Einsatz von Matrizen vorgenommen werden, bei
% denen das Referenzsignal auf der einen Achse und das zu bewertende Signal
% auf der anderen Achse aufgetragen wird. Bei der Stereoskopie werden dann
% nur Zeilen eines Bildes betrachtet. Die Verfahren von Munkres [1] und die
% Frequenzmethode von Habr [2] stellen Verfahren da, die eine flexible
% Zuordnung erlauben. Zunächst sollen an einfachen Symbolketten die
% Verfahren getestet werden und anschließend bei Sprachsignalen zur Analyse
% eingesetzt werden. 

% --> Zur Ermittlung der Vergleichssymbole bei den Sprachsignalen soll das
% --> Signal zunächst gleichgerichtet und dann mit einem Tiefpass gefiltert
% --> werden. Danach werden aufeinanderfolgende Werte in ansteigende
% --> Flanke, abfallende Flanke, Minimum und Maximum klassifiziert.
%
% Symbole R: Steigende Flanke, F: Fallende Flanke, V: Minimum, M: Maximum 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% Am 08.11.2014 08:28, schrieb Gerhard Schäfer:
% Hallo herr del Basso,
% 
% Von Kosten ist da keine Rede. Nach der Tiefpassfilterung des Zeitsignals
% haben Sie immer noch ein Zeitsignal. Wenn Sie zwei aufeinanderfolgende
% Werte betrachten, so können Sie entscheiden, ob der erste Wert kleiner
% ist als der zweite. Dann haben Sie entweder eine positive
% Steigung(Flanke) oder eine negative Steigung (Flanke). Bei Maximas oder
% Minimas müssen drei aufeinanderfolgende Werte betrachtet werden.
% 
% Sie können es auch mathematisch angehen:
% 
%  1. und 2. Ableitung bilden =
%     In den mathematischen Formelsammlungen gibt es Formeln, die die
%     Ableitung auch unter Einbeziehung mehrerer Punkte bilden. Verfahren
%     sind auch DOG (Differential of Gauß) oder LOG (Laplacian of Gauß),
%     die Sie auch im Internet finden und in Matlab mehr oder weniger
%     direkt zur Verfügung stehen. Y''==0 ergeben die Maximas und Minimas.
%     y'< 0 negative Flanke Y'0 positive Flanke
% 
% Ich hoffe, Sie können damit etwas anfangen?
% 
% Viele Grüße
% 
% Gerhard Schäfer
% 
% Am 07.11.2014 15:02, schrieb Manuel Del Basso:
% Hallo Herr Schäfer,
% morgen treffe ich mich mit meinem Projektpartner für das ADS- Projekt sodass wir Anfang nächster Woche mit Ihnen unser Thema festlegen können.
% In der Hoffnung dass Sie diese E- Mail zum Wochenende noch beantworten können, habe ich eine Frage zu den Themen der Sprachanalyse:
% 
% Grundsätzlich kann ich mir das Vorgehen in etwa vorstellen, speziell die Frequenzmethode nach Habr erscheint mir auch nach nur kurzer Einlesezeit verständlich. Was ich nicht verstehe ist der letzte Satz der Problembeschreibung in ADS_Aufgws1415.pdf (S. 8/9/10), wie ist die Klassifizierung der Kosten in Flanken zu verstehen?
% 
% 
% Mit freundlichem Gruß
% 
% Manuel Del Basso
% Matr.Nr.: 37399
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
USR = ' ';

if nargin >= 1
    MxN = varargin{1};
    if ~(ismatrix(MxN) && isnumeric(MxN))
        error('Numeric matrix input expected!')
    end
    
    if nargin >= 2
        if sum(~cellfun(@isempty, (regexp(varargin{2},{'dot','noline','plot'} ))))
            USR = varargin{2};
        end
    end
else
	warning('No input argument, running testvector...!')
    MxN=NaN;
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Testsignal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% if isnan(MxN)
%     ts = 10e-3;
%     tt=[0:ts:1];
%     f0=1;
%     MxN=sin(2*pi*f0*tt);
% end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isstr(USR)
    if strfind(lower(USR), 'plot') 
        PLOTG=1;
    else 
        clear PLOTG;
    end
else
    error('Parameter 2 needs to be char array / strin')
end

[M, N] = size(MxN);

if M > N
    warning('M > N  -->  MxN=MxN''')
    MxN = MxN';
    [M, N] = size(MxN);
end


clear idx

for k=1:1 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calc 1. order derivative by diff() or by convolution kernel [1,-1]
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calc 2. order derivative:
    %   - diff(diff()) or 
    %   - convolution kernel [1,-2,1] or
    %   - finite difference approximation del2() of Laplace's 
    %     differential operator
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ds = diff(MxN(1,:)) / max(diff(MxN(1,:))); 
    % d2s = del2(MxN(1,:)) / max(del2(MxN(1,:)));   

%     ds = diff(MxN(1,:)) / size(MxN,2); 
%     d2s = del2(MxN(1,2:end)) / size(MxN,2);   
    ds = conv(MxN(1,1:end-2),[1, -1]) / size(MxN,2); 
    d2s = conv(MxN(1,2:end-2), [1, -2, 1]) / size(MxN,2);   

    if 0
        fprintf('size MxN :\t%i\n', size(MxN));
        fprintf('size ds :\t%i\n', size(ds));
        fprintf('size Gds:\t%i\n', size(Gds));
        fprintf('size d2s:\t%i\n', size(d2s));
        fprintf('size G2s:\t%i\n', size(Gd2s));
    end
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Find zeros, create index vector (>0 ; <0)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    n=size(MxN,2);
    zero{1}=find(MxN(1,1:n-1).*MxN(1,2:n)<0)';
    idx{1} = {  find( (MxN(1,1:end-1)<0) & (ds>0) )',...
                find( (MxN(1,1:end-1)<0) & (ds<0) )' };
%                find( (MxN(1,1:end-1)<0) & (ds<0) )' };

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Find zero crossing of second derivative
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    n=size(ds,2);
    zero{2}=find(ds(1,1:n-1).*ds(1,2:n)<0)';
    % idx{2}{1}([ für > 0])  //  idx{2}{2}([ für < 0]
    idx{2} = {  find( (ds(1,:)<0) & (d2s(1:end)>0) )',...
                find( (ds(1,:)<0) & (d2s(1:end)<0) )' };

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % start classifying, output to sequenz seq
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               | Code |
    % --------------+------+
    % Rising edge   |   1  |
    % Falling edge  |  -1  |
    % Rel. maximum  |   2  |
    % Rel. minimum  |  -2  |
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    slopes = (ds > 0) -(ds < 0);                
    seq = slopes;
    seq(zero{2}) = -2*d2s(zero{2})./abs(d2s(zero{2}));
    
    if cellfun(@isempty,(idx{1}))
        error('1st derivative has no zero crossings?!')
    end    
    if cellfun(@isempty,(idx{2}))
        error('2nd derivative has no zero crossings?!')
    end
    
if exist('PLOTG','var')
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot input and sequenz vector
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear f10;
    f20.fig=figure(20);   clf;
    SUB=310;

    STYLE10 = {'k-.', 'Linewidth',0};
    
    f20.sub(1) = subplot(SUB+1);
    hold all;
    f20.pl(1,:) = stem(MxN,STYLE10{1});
%    f10.pl(2,:) = stem(idx{1}{1}, MxN(idx{1}{1}),'b-.');
%    f10.pl(3,:) = stem(idx{1}{2}, MxN(idx{1}{2}),'b--O');
    hold off;
    
    f20.sub(2) = subplot(SUB+2);
    hold all;
    f20.pl(4,:) = stem(MxN,'kO');
    f20.pl(5,:) = stem(idx{2}{1}, MxN(idx{2}{1}),'r-.');
    f20.pl(6,:) = stem(idx{2}{2}, MxN(idx{2}{2}),'r--O');
    hold off;
    
    f20.sub(3) = subplot(SUB+3);
    hold all;
    stem(seq,'r.');
    hold off;
    
    set(f20.sub(:),'XGrid','on','YGrid','on');
    
    set(f20.sub,'xlim', [0, size(MxN,2)]);
%   mfprintf(tmp(1:end,:)','\t% .2f ')
% 	fprintf(['\n' repmat('\t% .2f  %s ',1,size(tmp,2)+1)], tmp');

    if 1
        f21.fig = figure(21) ;  clf;
        SUB = 210;
        f21.sub(1,:) = subplot(SUB+1);
        hold all;
        f21.pl(1,:) = plot(MxN,'-o','LineWidth',1);
        hold off;
        xlim([0 length(seq)]);
        grid on
        legend('mic in')
        %ylim([-2.5 2.5]);


        f21.sub(2) = subplot(SUB+2);
        hold all;
        NormTo=1/max(abs(MxN(1,:)));
%        f11.pl(2) = stem(1:length(slopes(1:end)), slopes(1:end), 'g-.');
        f21.pl(3,:) = plot(2*NormTo*MxN(1,:),'-o','LineWidth',1);
        f21.pl(4,:) = stem(seq,'.');
        hold off;
        set(gca, 'xlim',[0, size(MxN,2)]);
        set(f21.pl(3), 'Color',[1 0 0]);
        xlim([0 length(seq)]);
%        ylim([-2.5 2.5]);
        title('\fontsize{14} {rel. min: -2   falling edge: -1   rising edge:  1   rel. max: 2}',...
            'interpreter','tex')
        legend(gca,'klassif. Sequenz')
        grid on;
    end
end

end
   
    if nargout > 0
        varargs{1} = seq;
    end

end






















%     
% %    seq(extrema(1:end-1)) = seq(extrema(1:end-1))
% %    fprintf('\tMxN-1\t ds''\td2s-1''  slopes''   extcl-1'' zer  seq\n')
% %    fprintf('\tf(t)\tf''(t)\tf''''(t)\tslopes'' \textr\t zer\tseq\n')
% %    tmp=[ds', d2s(1:end-1)', slopes', extcl(1:end-1)',seq'];
% 
% list1={'MxN(1:end-1)'; ' ds'; ' d2s(1:end-1)'; 'slopes'; 'extcl(1:end-1)'; 'seq'};
% for g=1:length(list1)
% %    eval(sprintf('size(%s)',list1{g}))
% end
% 
%     tmp=[MxN(1:end-1); ds; d2s(1:end-1); slopes; extcl(1:end-1);  seq];
%     mfprintf(tmp(1:end,:)','\t% .2f ')
%     
    
    
    %%
    
%     slopes = (ds > 0) -(ds < 0);                % 1. Abl > 0 --> 1 sonst -1
% %    extcl = -1+abs((d2s<PREC/2) - (d2s>-PREC/2));
% %     disp([(ds<PREC/2)', (ds>-PREC/2)', ((ds<PREC/2) - (ds>-PREC/2))'])
% %     disp([(d2s<PREC/2)', (d2s>-PREC/2)', ((d2s<PREC/2) - (d2s>-PREC/2))'])
%     extcl = -1+abs((d2s<PREC/2) - (d2s>-PREC/2));
%     extrema = find(~((d2s<PREC/2) - (d2s>-PREC/2)));
%     zer=repmat(0,1,length(extcl)-1);
%     zer(extrema(1:end)) = 9;
%     seq = (slopes + extcl(1:end-1));
% %     seq(extrema(1:end-1)) = seq(extrema(1:end-1))
% %    fprintf('\tMxN-1\t ds''\td2s-1''  slopes''   extcl-1'' zer  seq\n')
%     fprintf('\tf(t)\tf''(t)\tf''''(t)\tslopes'' \textr\t zer\tseq\n')
% %    tmp=[ds', d2s(1:end-1)', slopes', extcl(1:end-1)',seq'];
% 
% list1={'MxN(1:end-1)'; ' ds'; ' d2s(1:end-1)'; 'slopes'; 'extcl(1:end-1)'; 'seq'; 'zer(1:end-1)'};
% for g=1:length(list1)
% %    eval(sprintf('size(%s)',list1{g}))
% end

% 	fprintf(['\n' repmat('\t% .2f  %s ',1,size(tmp,2)+1)], tmp');
%     hold all;
%     f10.pl(1) = stem(MxN,'kO');
%     f10.pl(2) = stem(ds,'rx');    
%     f10.pl(3) = stem(d2s,'gx');    
%     hold off;
% 
%     f10.sub(2) = subplot(SUB+2);
%     hold all;
%     stem(seq,'r.')
%     hold off;

%     line(extrema, strrep([0.1,0.9],1,length(extrema),'LineWidth',4,'Color',[.8 .8 .8]);





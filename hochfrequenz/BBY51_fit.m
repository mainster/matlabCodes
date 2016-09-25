%% Polyfit für Cj(Ud) Kennlinie
% http://www.infineon.com/dgdl/Infineon-BBY51SERIES-DS-v01_01-en.pdf?folderId=db3a304313d846880113ddc160d402c0&fileId=db3a304313d846880113ddc3c72702c2
%

function BBY51_fit 

ds = '---------------------------------------';
if 1
    % Varactor- Diode nxp
    % http://www.nxp.com/documents/spice_model/BB141.prm
    % Fit-Range: 0-3.5V
    %
    % nxp:		BB141
    % infineon:	BBY51
    %%%%%%%%%%%%%%%%%%%%%%%%
    % http://www.nxp.com/wcm_documents/products/related/philips_rf_manual_7th_edition.pdf
    %%%%%%%%%%%%%%%%%%%%%%%%
    Rs=.4;
    Cjo=6.79e-12;
    m=0.65;
    Vj=1.03;
    ud = [0:.1:6];
    cjPhil = Cjo./(1-(-ud)/Vj).^m;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Try and error 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Rs=0.37;
    Cjo = 7.5e-12;
    m=0.4;
    Vj=0.6;

    ud = [0:.1:6];
    cjTry = Cjo./(1-(-ud)/Vj).^m;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Werte aus Diagramm Sperrschichtkapazität als funktion von
    % Sperrspannung
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    x = [0.0, 0.25, 0.5, 0.75, 1.0, 1.5, 2.0, 3.0 4.0, 6.0]';
    y = ([7.7, 6.60, 6.1, 5.3, 5.1, 4.4, 4.0, 3.4 3.0, 2.5]*1e-12)';
    %cftool(x,y)
    N = 5;  % grad des polynoms 

    p = polyfit(x,y,N);
    cjFit = polyval(p,x);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
    figure(1); clf;
    hold all;
    plot(ud,cjPhil*1e12)
    plot(ud,cjTry*1e12)
    plot(x,cjFit*1e12,'-o')
    hold off;
    ylabel('Cj / pF')
    legend('philips model', 'try and error', sprintf('polyfit, order: %i',N));
    grid on;

end

return
%%
if 0
    cj0 = 5e-12; 
    m = 0.5; % Siehe pdf

    % Approx. 

    ud = [0:.005:6];
    udiff = linspace(.33, .5, 5);
    clear cj;

    for k=1:length(udiff)
        cj(:,k) = cj0./(1-ud./udiff(k)).^m; 
    end

    abs(cj);
    figure(2);
    plot(ud, abs(cj))
    xlim([0,2]);
end

% .model MyVar D(Rs= 0.37 Cjo = 7.5p Vj=0.6 m=0.4)
%%

if 0
    clearvars -except ol

    Rs=0.37;
    Cjo = 7.5e-12;
    Vj=0.6;
    m=0.4;

    % cj = @(UD, VJ, M) cj0./(1-UD./VJ).^M; 

    ud = [0:.1:6];
    cj = Cjo./(1-(-ud)/Vj).^m

    plot(ud,cj*1e12)
    ylabel('Cj / pF')
    grid on;
end
%%

if 0
    roh = 1.75e-2; % ohm/mm^2
    D_coil = 3e-3;
    N=8;
    A_cu=.3e-3; % Draht

    R_pro_N = pi*D_coil;
    l_cu = pi*D_coil*N;

    % A=pi*(D/2)^2;
    R_cu=roh*l_cu/A_cu;

    fprintf('\n%s\nR_cu / N: %.2g\n', ds, R_pro_N);
    fprintf('l_cu: %.2g\n', l_cu);
    fprintf('R_cu: %.2g\n', R_cu);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% lsq Last square sense - Im sinne des kleinsten fehlerquadrats
if 0
%     clear all; startup;
%     clear Cj;
% 
%     cj0 = 5e-12; 
%     udiff = linspace(.33, .5, 5);
% 
%     Cj = @(m) cj0./(1-ud./udiff(1)).^m
%     xdata = ...
%      [0.9 1.5 13.8 19.8 24.1 28.2 35.2 60.3 74.6 81.3];
%     ydata = ...
%      [455.2 428.6 124.1 67.3 43.2 28.1 13.1 -0.4 -1.3 -1.5];
%     x0 = [100; -1] % Starting guess
%     [x,resnorm] = lsqcurvefit(@Cj,x0,xdata,ydata);
end
%%
end
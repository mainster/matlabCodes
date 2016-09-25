% Programm rekonstr1.m zur Untersuchung der 
% Rekonstruktion des kontinuierlichen Signals 
% nach der Abtstung und D/A-Wandlung
% Arbeitet mit dem Simulink-Modell rekonstr_1.mdl

% --------- Parameter
frausch = 250;        % Bandbreite des Rauschsignals
fs = 1000;            % Abtastfrequenz

% --------- FIR-Kompensationsfilter
h = [-1/16, 9/8, -1/16]

% --------- Aufruf der Simulation
sim('rekonstr_1',[0:1e-4:1]);
% Ergebnisse
% yout(:,1) = verspäŠtetes kontinuierliches Signal
% yout(:,2) = nach dem D/A-Wandler rekonstruiertes Signal
% yout(:,5) = verspäŠtetes Kontinuierliches Signal 
              % füŸr den Fall mit FIR-Kompensation
% yout(:,6) = nach dem D/A-Wandler rekonstruiertes Signal
              % füŸr den Fall mit FIR-Kompensation
[m,n]= size(yout);

% Bestimmung der Optimalen VersäpŠtungen
% füŸr den Fall ohne FIR-Kompensation

nv = 200;    % Anfangs Index 
diff_y = zeros(2*nv,1);

y1 = yout(nv:end-nv,1);
for k = 1:2*nv
    diff_y(k) = sum(abs(yout(k:length(y1)+k-1,2) - y1));
end;
min_diff_1 = min(diff_y);
p1 = find(diff_y == min_diff_1);

%  und füŸr den Fall mit Kompensation
y1 = yout(nv:end-nv,5);
for k = 1:2*nv
    diff_y(k) = sum(abs(yout(k:length(y1)+k-1,6) - y1));
end;
min_diff_2 = min(diff_y);
p2 = find(diff_y == min_diff_2);

gewinn = 100*(min_diff_1 - min_diff_2)/min_diff_1;
disp(['Gewinn = ', num2str(gewinn),' %']); 

% Differenzen an der optimalen VerspäŠtung
diff_y_1 = (yout(p1:length(y1)+p1-1,2) - yout(nv:end-nv,1));    
diff_y_2 = (yout(p2:length(y1)+p2-1,6) - yout(nv:end-nv,5));    
    
% -------- Darstellungen
figure(1),     clf;
nd = nv:3*nv;
plot(tout(nd), yout(nd,3:4));
La = axis;   axis([La(1), max(tout(nd)), La(3:4)]);
title(['Kontinuierliches und abgetastetes Signal (frausch = ',...
        num2str(frausch),' Hz; fs = ', num2str(fs),' Hz)']);
xlabel('Zeit in s');     grid;
%--------------------------------------
nd1 = nv:nv+3*nv;
nd2 = p1:p1+3*nv;

figure(2);     clf;
subplot(221), plot(tout(nd1), [yout(nd1,1), yout(nd2,2)]);
title('Rekonstruktion ohne FIR-Komp.');
La = axis;    
axis([La(1), max(tout(nd)),...
        min(min(yout(nd, 1:2))), max(max(yout(nd, 1:2)))]);
subplot(223), plot(diff_y_1);
title('Fehler (ohne FIR)');
La = axis;    
axis([La(1), length(diff_y_1),...
        min(diff_y_1), max(diff_y_1)]);

nd1 = nv:nv+3*nv;
nd2 = p2:p2+3*nv;
subplot(222), plot(tout(nd1), [yout(nd1,5), yout(nd2,6)]);
title('Rekonstruktion mit FIR-Komp.');
La = axis;    
axis([La(1), max(tout(nd)), ...
        min(min(yout(nd, 5:6))), max(max(yout(nd, 5:6)))]);
subplot(224), plot(diff_y_2);
title('Fehler (mit FIR)');
La = axis;    
axis([La(1), length(diff_y_2),...
        min(diff_y_1), max(diff_y_1)]);



    
    
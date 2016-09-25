function [Ai, phi, k, Aik, phik, ik] = fourier2(delta_tau, imax, flag)
% Funktion (fourier2.m)zur Darstellung des Amplitudenspektrums
% eines periodischen Signal bestehend aus Pulse 
% Parameter: delta_tau = Dauer-Puls / Periode (relative Dauer der Pulse) 
%            imax = Maximaler Index der Harmonischen (z.B. 5/delta_tau)
%            flag = 1 ergibt auch eine Darstellung
%
% Testaufruf: fourier2(0.1, 50, 1);

d_ik = imax/200;                   % Schrittweite für die Hülle

k = 0:imax;                        % Index Harmonischen
ik = 0:d_ik:imax;                  % Index für die Hülle

%------- Darstellung der Hülle
Aik = 2*(delta_tau)*(sin(ik*pi*delta_tau+eps)./(ik*pi*delta_tau+eps));
phik = -(pi/2)*(1-sign(Aik));

%------- Darstellung des Spektrums (Linienspektrums
Ai = 2*(delta_tau)*(sin(k*pi*delta_tau+eps)./(k*pi*delta_tau+eps));
phi = -(pi/2)*(1-sign(Ai));

Aik = abs(Aik);       
Aik(1) = Aik(1)/2;                 % Mittelwert für die Hülle
Ai = abs(Ai);         
Ai(1) = Ai(1)/2;                   % Mittelwert für das Spektrum
%------------------------------------------------------
if flag == 1
  figure(1);        clf;
  subplot(211), plot(ik, Aik);     hold on;
  stem(k, Ai); 
  title('Amplitudenspektrum ');    xlabel('k Index der Harmonischen')
  hold off

  subplot(212), plot(ik, phik);    hold on;
  stem(k, phi);
  title('Phasenspektrum ');        ylabel('rad');      
  xlabel(['k Index der Harmonischen (relative Pulsdauer = ',...
      num2str(delta_tau),' )']);
  hold off;
end;

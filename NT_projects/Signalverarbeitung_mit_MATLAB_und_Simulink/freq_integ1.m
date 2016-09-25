% Frequenzgäng von einfachen Integratoren und Differenzierer

% -------- Integratoren
fs = 1000;      Ts = 1/fs;
% -------- Backward Euler
b1 = Ts*[1];
a1 = [1 -1];

% -------- Forward Euler
b2 = Ts*[0 1];
a2 = [1 -1];

% -------- Trapepezoidal
b3 = Ts*[1 1];
a3 = 2*[1 -1];

% -------- Frequenzgänge
nf = 256;
[H1, w] = freqz(b1, a1, nf); 
[H2, w] = freqz(b2, a2, nf); 
[H3, w] = freqz(b3, a3, nf); 
Hi = -j./(w*fs + eps);

figure(1),   clf;
subplot(221), plot(w(2:end)/pi, 20*log10([abs(H1(2:end)), abs(H2(2:end)), ...
        abs(H3(2:end)), abs(Hi(2:end))]));
legend('Backward-Euler','Forward-Euler','Trapezoidal','Ideal',3);
title('Amplitudengang');  ylabel('dB');   
xlabel('2f/fs');      grid;
subplot(223), plot(w/pi, [angle(H1), angle(H2), angle(H3), angle(Hi)]);
title('Phasengang');
xlabel('2f/fs');      grid;

subplot(122), plot(w(2:end)/pi, ([abs(H1(2:end)), abs(H2(2:end)), ...
        abs(H3(2:end)), abs(Hi(2:end))]));
legend('Backward-Euler','Forward-Euler','Trapezoidal','Ideal');
title('Amplitudengang (linear)');
xlabel('2f/fs');      grid;
La = axis;   axis([La(1:3), max(abs(H1(2:end)))/4]);


% --------- Differenzierer
b4 = [1 -1];
a4 = Ts;

[H4, w] = freqz(b4, a4, nf); 
Hd = j*w*fs;   % Idealer Differenzierer

figure(2),   clf;
subplot(221), plot(w(2:end)/pi, 20*log10([abs(H4(2:end)), abs(Hd(2:end))]));
legend('Differenzierer','Ideal',3);
title('Amplitudengang');  ylabel('dB'); 
xlabel('2f/fs');      grid;
subplot(223), plot(w/pi, [angle(H4), angle(Hd)]);
title('Phasengang');
xlabel('2f/fs');      grid;

subplot(122), plot(w(2:end)/pi, ([abs(H4(2:end)), abs(Hd(2:end))]));
legend('Differenzierer','Ideal');
title('Amplitudengang (linear)');  
xlabel('2f/fs');      grid;





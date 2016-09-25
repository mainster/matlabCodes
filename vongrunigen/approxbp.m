% M-File  APPROXBP.M      Version fuer MATLAB 4.0

%

% Loesung zu Kap.6 Aufgabe No.5 

%

% Das M-file liest die beiden Durchlass- und die beiden Sperrfrequenzen 

% eines gewuenschten, rekursiven Bandpassfilters ein und berechnet die Ordnung

% der vier moeglichen Approximationsarten.

% Fuer eine gewuenschte Approximationsart berechnet es dann die 

% b- und a-Filterkoeffizienten und stellt den Amplituden- und Phasengang dar.



clear, close, clc



I=1;

while I==1



  disp(' '),disp(' '),disp('            Bandpassfilter-Approximation'),

                      disp('            ****************************'),disp(' ')



  L=5;

  while L==5





    % Frequenzen, Rippel und Daempfung einlesen



    fa= input(['Geben Sie die Abtastfrequenz in kHz ein             ',...

               ' fa= ']);disp(' ')

    fSu=input(['Geben Sie die untere Sperrfrequenz in kHz ein       ',... 

               'fSu= ']);disp(' ')

    fDu=input(['Geben Sie die untere Durchlassfrequenz in kHz ein   ',...

               'fDu= ']);disp(' ')

    fDo=input(['Geben Sie die obere Durchlassfrequenz in kHz ein    ',...

               'fDo= ']);disp(' ')

    fSo=input(['Geben Sie die obere Sperrfrequenz in kHz ein        ',...

               'fSo= ']);disp(' ')

    RD= input(['Geben Sie den Rippel in dB im Durchlassbereich ein  ',...

               ' RD= ']);disp(' ')

    RS= input(['Geben Sie die Daempfung in dB im Sperrbereich ein   ',...

               ' RS= ']);disp(' ')

 

 

    % Ordnung der einzelnen Approximationsarten berechnen und ausgeben

 

    Wp=[fDu/(0.5*fa) fDo/(0.5*fa)]; Ws=[fSu/(0.5*fa) fSo/(0.5*fa)];

    [Nbutt, Wnbutt]=buttord(Wp,Ws,RD,RS);

    [Ncheb1, Wncheb1]=cheb1ord(Wp,Ws,RD,RS);

    [Ncheb2, Wncheb2]=cheb2ord(Wp,Ws,RD,RS);

    [Nellip, Wnellip]=ellipord(Wp,Ws,RD,RS);

    disp(' ')

    disp('Die Ordnung N der einzelnen Aproximationsarten betragen:')

    disp(' '),disp(['1. Butterworth:       N= ',num2str(2*Nbutt)])

    disp(' '),disp(['2. Tschebyscheff I:   N= ',num2str(2*Ncheb1)])

    disp(' '),disp(['3. Tschebyscheff II:  N= ',num2str(2*Ncheb2)])

    disp(' '),disp(['4. Cauer:             N= ',num2str(2*Nellip)])

 

    L=menualt('Welche Approximationsart waehlen Sie?',...

              'Butterworth','Tschebyscheff I','Tschebyscheff II','Cauer',...

              'Von vorne anfangen');

  end





  % Die Koeffizienten des Bandpassfilters nach der gewuenschten 

  % Approximationsart bestimmen.



  approxart=['   Butterworth  '

             ' Tschebyscheff I'

             'Tschebyscheff II'

             '      Cauer     ']; approxart=approxart(L,:);



  approx=['[b a]=butter(Nbutt,Wnbutt)       '

          '[b a]=cheby1(Ncheb1,RD,Wncheb1)  '

          '[b a]=cheby2(Ncheb2,RS,Wncheb2)  '

          '[b a]=ellip(Nellip,RD,RS,Wnellip)'];



  disp(' '),disp('Die Bandpassfilter-Koeffizienten lauten:'),disp(' ')

  eval(approx(L,:)),disp(' ')





  % Amplituden- und Phasengang darstellen



  J=1;

  while J==1



    K=menualt(['In welchem Frequenzbereich wollen Sie den Frequenzgang ',...

               'darstellen?'],...

               'Im Nyquistbereich','Im Frequenzbereich   f1  ...  f2');disp('')



    if K==1

      [H,Omega]=freqz(b,a,1024); f=(0.5*fa/pi)*Omega;

    else

      f1=input('Geben Sie die untere Frequenzgrenze in kHz ein  f1= ');disp(' ');

      f2=input('Geben Sie die obere Frequenzgrenze in kHz ein   f2= ');disp(' ');

      Deltaf=(f2-f1)/1023; f=f1:Deltaf:f2; Omega=2*pi*f/fa;

      H=freqz(b,a,Omega);

    end



    AindB=20*log10(abs(H)); Phi=(180/pi)*unwrap(angle(H));

    close,subplot(2,1,1),plot(f,AindB), axis('auto'),grid

    xlabel('Frequenz in kHz'), ylabel('A(f) in dB')

    title(['Amplitudengang des ',approxart,' - Bandpassfilters'])

    subplot(2,1,2),plot(f,Phi), axis('auto'),grid

    xlabel('Frequenz in kHz'), ylabel('Phi(f) in Grad')

    title(['Phasengang des ',approxart,' - Bandpassfilters'])

    set(gcf,'Units','normal','Position',[0 0 1 1]), pause

    clc, set(gcf,'Units','normal','Position',[0.5 0 0.5 0.5])



    J=menu('Wollen Sie neue Frequenzgrenzen eingeben?',...

           'Ja','Nein, aber neu anfangen','Nein, Programm approxbp beenden');

    if J<=2

      I=1;

    else

      I=2;

    end



  end



end



close

clear K L I J Wnbutt Wncheb1 Wncheb2 Wnellip Nbutt Ncheb1 Ncheb2 Nellip ...

      RD RS Wp Ws ans approx approxart fDo fDu fSo fSu f1 f2 Deltaf

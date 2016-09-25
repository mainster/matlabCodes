ball=readfis('ball.fis');  % liest das Files 'ball.fis' in MATLAB Workspace
sim('mag_schwebe_fuzzy_wrv',[0, 20]); % Ergebnisse in tout, yout, Reglersignal
figure(1);                      plot(tout, yout);
title('Ballposition');
xlabel('Zeit in s');            grid on;
input('Drücke RETURN-TASTE') % wartet auf Eingabe, um 2.Figur zu plotten
figure(2);               
plot(Reglersignal(:,1),Reglersignal(:,2));  
title('Reglersignal');
xlabel('Zeit in s');            grid on
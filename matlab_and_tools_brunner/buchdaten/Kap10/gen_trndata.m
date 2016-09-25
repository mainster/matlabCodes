x=[-10:1:10];clf;
y_gen=.05*x'.^3-.02*x'.^2-.3*x'+20;
plot(x,y_gen);
xlabel('Input x');
ylabel('Output y');
title('zu approximierende Funktion'); 
trn=[x' y_gen];
save('trn_data.mat','trn');

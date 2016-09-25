%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Truthtable | boolean algebra | digitale systeme
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SS-2013 - EDS  
% G. Schaefer 
% Aufgabe 2         Logische Funktion mit 2-1 Mux
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear c a b y*
%% Wahrheitstabelle fpr c-a-b
c = boolean([zeros(1,4) ones(1,4)])';
a = boolean([0 0 1 1 0 0 1 1 ])';
b = boolean([0 1 0 1 0 1 0 1 ])';
YY = [0 1 0 0 1 1 0 1]';                % Lösungsvektor
SPACE = repmat('  ',length(YY),1);
cab=[c a b];

%% DNF - Binary decision tree optimieren --> DNF
y.dnf = (b& ~a& ~c) | (~a& c) | (b& a& c);

%% KNF - KV diagramm 
y.knf = (~c|~b) & (~c|a) & (a|~b);

if (y.dnf == YY) & (y.knf == YY)
   fprintf('identisch!\n\n')
else
   fprintf('nicht identisch!:\n')
   fprintf(' Y|y.dnf|y.knf\n----------\n')
   disp([SPACE num2str(YY),...
               num2str(y.dnf),...
               num2str(y.knf)])

   %% KNF + DNF aus gleichem KV Diagramm 
   y2.dnf = (~a& b) | (c& b) | (c& ~a);
   y2not.knf = (~c| ~b) & (a| ~b) & (~c| a);
   y2.knf = ~y2not.knf;
   
   fprintf(' Y|y2.dnf|y2.knf\n----------\n')
   disp([SPACE num2str(YY),...
               num2str(y2.dnf),...
               num2str(y2.knf)])
end
 

   
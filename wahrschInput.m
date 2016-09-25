function ret = wahrschInput (varargin)

if ~nargin 
    disp('Wähle jetzt eine Wahrscheinlichkeit ( 0.0 bis 1.0 ist möglich)') 
    P_user=input('');
else
    P_user = varargin{1};
end

%if (P_user >= 0) & (P_user <= 1) disp "'passt'; else disp 'out of range'; end
%return
if (P_user < 0) | (P_user > 1) 
    
    disp('Ungültig. Es wird eine P_user von 55% angenommen ') 
    
    P_user=0.55 

    
end; 

%...... 
%diverse Programmbestandteile 
%...... 

W=wgn(1,1,0); 

if W <= P_user 
    %führe Funktion aus 
 %   disp('wird ausgeführt')
    ret = 'A';
else 
    %führe Funktion nicht aus, mach dafür was anderes 
%    disp('es passiert was anderes') 
    ret = 'B';
end; 

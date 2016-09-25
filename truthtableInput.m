%%
Bitzahl=3;

for k=0:2^Bitzahl-1
   a=dec2bin( k ,Bitzahl);
   disp(['a=' a])
   for length()
   M(:,k+1) = str2double(a)';
   disp(['M='])
   disp(M)
end
       
%%

function [Mout] = truthtableInput(Bitzahl, varargin) 
% erzeugt eine Wahrheitstabelle im Gray-Code, mit der Anzahl an Bits als 
% Eingangsgröße. Nach der gängigen Formel: 
% Bitshift nach links -> ver-XOR-en -> Bitshift nach rechts 

codename = 'bin';

if nargin == 2
   codename = varargin{1};
end

if ~isempty(find(double(strcmpi(codename, {'gray','graycode','g'})),1))
   Mout=zeros(2^Bitzahl,Bitzahl); 
   for i=0:(2^Bitzahl)-1 % index um 1 verschoben um binär zu bleiben 
       a=dec2bin( i ,Bitzahl+1); % Zahl erzeugen, eine stelle mehr für XOR 
       b=dec2bin(2*i,Bitzahl+1); % Bitshift nach links 
       for k=1:Bitzahl+1 
           c(1,k)=str2double(a(k));
           d(1,k)=str2double(b(k)) 
           e=xor(d,c); % ver-XOR-en 
       end 
       for k=1:Bitzahl % Bitshift rechts passiert automatisch, da for-Schleife eine Stelle weniger 
           if e(k)==true 
               Mout(i+1,k)=1; 
           end 
       end 
   end 
   return
end

if ~isempty(find(double(strcmpi(codename, {'bin','binary','b'})),1))
   Mout=zeros(2^Bitzahl,Bitzahl); 
   for i=0:(2^Bitzahl)-1 % index um 1 verschoben um binär zu bleiben 
       a=dec2bin( i ,Bitzahl+1); % Zahl erzeugen, eine stelle mehr für XOR 
       b=dec2bin(2*i,Bitzahl+1); % Bitshift nach links 
       for k=1:Bitzahl+1 
           c(1,k)=str2num(a(k)); 
           d(1,k)=str2num(b(k)); 
%            e=xor(d,c); % ver-XOR-en 
       end 
       for k=1:Bitzahl % Bitshift rechts passiert automatisch, da for-Schleife eine Stelle weniger 
           if e(k)==true 
               Mout(i+1,k)=1; 
           end 
       end 
   end 
   return
end

return
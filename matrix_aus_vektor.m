% Matrix aus Vektoren

w=[0.5 1 0.5]; 
M=[1:20].'; 
%Zählschleife für Teilvektoren, die aus Vektor w gebildet werden: 
for z=1:20; 
%    a=w(z:z+3); %Bildung des Teilvektors 
%Bilden der Matrix M[zeile, spalte] 
    M=[M;w]; 
end; 
M
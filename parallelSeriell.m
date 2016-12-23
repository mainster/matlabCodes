clear Rs Rp Cs Cp s w
syms Rs Rp Cs Cp positive
syms w real
syms s

% R || C
%%%%%%%%%%%%%%%%%
Zs=@(s) Rs+1/(s*Cs);
Zp=@(s) (Rs/(s*Cs)) / (Rs+1/(s*Cs));
Ys=@(s) (Cs*s)/(Cs*Rs*s + 1);
Yp=@(s) s*Cp+1/Rp;

fprintf(['\n\nR - C:\nZs(s) = ' char(Zs(s)) '\nYs(s) = ' char(Ys(s)) '\n']) 
fprintf(['\n\nR || C:\nZp(s) = ' char(Zp(s)) '\nYp(s) = ' char(Yp(s)) '\n\n']) 




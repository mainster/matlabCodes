function y2 = akkum2(x2)
% Akkumulator für das Modell fcn_1.mdl
% x2(1) = laufender Wert
% x2(2) = dummy

global y2

y2 = y2 + x2(1);

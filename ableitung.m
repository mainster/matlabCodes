%% ********** Nummerische Differentiation ********* %%

function abl=ableitung(g,x)
h=0.0001;

abl=(g(x+h)-g(x-h))/(2+h);
end
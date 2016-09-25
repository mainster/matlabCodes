% Experiment (my_mesh.m) zu den Befehlen mesh und surf

%------- Zufallsmatrix
A = randn(20,20);

%------- Glättern der Matrix
A1 = filter2(ones(5,5), A);

figure(1);
subplot(221), mesh(A1);
title('mesh(A)');

subplot(222), surf(A1);
title('surf(A)');

subplot(223), surf(A1);
shading flat;
title('surf(A) & shading flat');

subplot(224), surf(A1);
shading interp;
title('surf(A) & shading interp');

% Programm avi_beispiel1.m, in dem eine AVI-Sequenz aus 
% einer MATLAB movie-Sequenz kreiert wird. 

colormap('default');
map = colormap;

avi_obj = avifile('my_movie1.avi', 'fps',5);
for k = 1:25
    h = plot(fft(eye(k+16)));
    set(h, 'EraseMode','xor');
    axis equal;
    frame = getframe(gca);
    avi_obj = addframe(avi_obj, frame);
end;
avi_obj = close(avi_obj);

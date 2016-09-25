%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                    %
%            ALIREZA LIAGHAT        AHMADREZA SHAHABINIA             %
%                84133209               84132108                     %
%               Animation of Graphical Convolution                   %
%                                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear
axis_color= [0.5 0.5 0.5];% color of axis constant
s_int = 0.1;
t = [ -10:s_int:10 ];
syms m
x=input('enter x(m).you should enter a function that its variable is m\n');
%.1*m^2*(heaviside(m+10)-heaviside(m-10))
%exp(-2*m)*heaviside(m);
%heaviside(m)-heaviside(m-2.5);
%exp(2*m)*heaviside(-m);
%exp(-2*m)*heaviside(m);

x1=subs(x,m,t);x1=double(x1);
t1 = [-10:s_int:10];
h=input('enter h(m).you should enter a function that its variable is m\n');
%-.1*m^2*(heaviside(m+8)-heaviside(m-8))
%heaviside(m);
%m*(heaviside(m)-heaviside(m-5));
%heaviside(m-3);
%heaviside(m+1)-heaviside(m-1);

h1=subs(h,m,t1);h1=double(h1);


g = fliplr(h1);%flip 'h(t1)' for the graphical convolutions g = h(-t1)
tf = fliplr(-t1);

% slide range of 'g' to discard non-overlapping areas 
%with 'x' in the convolution
tf = tf + ( min(t)-max(tf) );

% get the range of function 'c' which is the convolution of 'x(t)' and
% 'h(t1)'
tc = [ tf t(2:end)];
tc = tc+max(t1);

%% convolve operations
h0=subs(h,'m','n-m');
for i=1:length(tc)
    hh1(i)=h0;
    h2(i)=subs(hh1(i),'n',tc(i));
    y1(i)=h2(i)*x;
    y(i)=int(y1(i),'m',-inf,inf);
end
c=double(y);

%%
% start graphical output with three subplots
a_fig = figure(1);
  set(a_fig, 'Name', 'Animated Convolution', 'unit', 'pixel', ...
             'Position', [250, 00, 550, 550]);
ax_1 = subplot(3,1,1);
  op = plot(t,x1, 'b',  t1, h1, 'r');
  hold on; grid on;
  set(ax_1, 'XColor', axis_color, 'YColor', axis_color, 'Color', 'w', 'Fontsize', 9);
  xlim( [ ( min(t)-abs(max(tf)-min(tf)) - 1 ) ( max(t)+abs(max(tf)-min(tf)) + 1 ) ] );
  title('Graph of x(t) and h(t)', 'Color', axis_color );
  legend({'x(t)' 'h(t)'});
  
  ax_2 = subplot(3,1,2);
  p = plot(t, x1);
  hold on; grid on;
  title('Graphical Convolution: x(t) and g = h(-t1)', 'Color', axis_color );
  
  
% plot g in the subplot number 2
  q = plot(tf, g, 'r');
  xlim( [ ( min(t)-abs(max(tf)-min(tf))-1 ) ( max(t)+abs(max(tf)-min(tf))+1 ) ] );
  u_ym = get(ax_2, 'ylim');

% plot two vertical lines to show the range of overlapped area
  s_l = line( [min(t) min(t)], [u_ym(1) u_ym(2)], 'color', 'g'  );
  e_l = line( [min(t) min(t)], [u_ym(1) u_ym(2)], 'color', 'g'  );
  hold on; grid on;
  set(ax_2, 'XColor', axis_color, 'YColor', axis_color, 'Color', 'w', 'Fontsize', 9);

  % put a yellow shade on overlapped region
  sg = rectangle('Position', [min(t) u_ym(1) 0.0001 u_ym(2)-u_ym(1)], ...
                 'EdgeColor', 'w', 'FaceColor', 'y', ...
                 'EraseMode', 'xor');
  
  
% initialize the plot the convolution result 'c'
  ax_3 = subplot(3,1,3);
  r = plot(tc, c);
  grid on; hold on;
  set(ax_3, 'XColor', axis_color, 'YColor', axis_color, 'Fontsize', 9);
  % xlim( [ min(tc)-1 max(tc)+1 ] );
  xlim( [ ( min(t)-abs(max(tf)-min(tf)) - 1 ) ( max(t)+abs(max(tf)-min(tf)) + 1 ) ] );
  title('Convolutional Product c(t)', 'Color', axis_color );

% animation block
  for i=1:length(tc)
    
    % control speed of animation minimum is 0, the lower the faster
      pause(0.01);
      drawnow;
      
    % update the position of sliding function 'g', its handle is 'q'
      tf=tf+s_int;
      set(q,'EraseMode','xor');
      set(q,'XData',tf,'YData',g);

    % show overlapping regions
    
    % show a vertical line for a left boundary of overlapping region
      sx = min( max( tf(1), min(t) ), max(t) );  
      sx_a = [sx sx];
      set(s_l,'EraseMode','xor');
      set(s_l, 'XData', sx_a);

    % show a second vertical line for the right boundary of overlapping region
      ex = min( tf(end), max(t) );  
      ex_a = [ex ex];
      set(e_l,'EraseMode','xor');
      set(e_l, 'XData', ex_a);
      
    % update shading on overlapped region
      rpos = [sx u_ym(1) max(0.0001, ex-sx) u_ym(2)-u_ym(1)];  
      set(sg, 'Position', rpos);
      
    % update the plot of convolutional product 'c', its handle is r
      set(r,'EraseMode','xor');
      set(r,'XData',tc(1:i),'YData',c(1:i) );
    
  end
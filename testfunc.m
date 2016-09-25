function theStruct = testfunc(filename)
% PARSEXML Convert XML file to a MATLAB structure.
try
   tree = xmlread(filename);
catch
   error('Failed to read XML file %s.',filename);
end

% Recurse over child nodes. This could run into problems 
% with very deeply nested trees.
try
   theStruct = parseChildNodes(tree);
catch
   error('Unable to parse XML file %s.',filename);
end

end

function testfunc2()
global m_pos;

   m_pos=[];
   clf;
   
   f1=figure(1);
   ax=axes; hold on;
   ax.XLimMode='manual';
   ax.YLimMode='manual';
   ax.XLim=[-1,1]*10;
   ax.YLim=[-1,1]*10;

   set(ax,'ButtonDownFcn',@(h,e)(display_click_pos(h,e)));
   set(f1,'KeyPressFcn',@(h,e)(display_key_ev(h,e))) ;
%   uicontrol('Style','slider','Callback',@display_slider_value);
end

function display_click_pos(h,e)   
	global m_pos;
   syms lMice rMice; 
   lMice=1; rMice=3;

   cpos=get(h,'currentpoint');
   ax=findobj(get(h,'Children'),'type', 'line');
   
   if e.Button == lMice
      m_pos(end+1,:)=[cpos(1), cpos(3)];
      plot(m_pos(end,1),m_pos(end,2),'x');
      return
   end

   % Delete an existing sample due to prec % precision
   if e.Button == rMice
      rm = [cpos(1), cpos(3)];
      prec.x = get(h, 'XLim') * .02;  
      prec.y = get(h, 'YLim') * .02;  
      rmSample(ax, rm, 0.05)
      plot(m_pos(end,1),m_pos(end,2),'x');
      return
   end
end

% remove sample
% ax     handle to the processing axes
% data   data.x, data.y to remove
% prec   "rounding". For example means prec=0.02 that the
%        search scope for the double values is 
%        (max(XLim)-min(XLim))*prec=dx so we can use an interval in the range
%        (data.x-dx/2) ... (data.x+dx/2), same cal for y-coordinate
function rmSample(ax, data, prec)
   ch.lines = findobj(ax.Children, 'type','line');
   dc.x = (max(XLim)-min(XLim))*prec;
   dc.y = (max(YLim)-min(YLim))*prec;
   dc.xy = [dc.x, dc.y];
   
   for k=1:length(ch)
      ch.x = ch(k).XData;   
      ch.y = ch(k).YData;
   end

   ch.xy = [ch.x ch.y];
   data.x - dc.x/2 < ch.xy < data.x + dc.x/2
end

function display_key_ev(h,e)
	global m_pos;

   fprintf('e.char: %s  e.Modifier: %s   e.Key:  %s\n',...
      e.Character, e.Modifier{1}, e.Key)
   
   if isempty(e.Character) && ...
         ~isempty(strcmpi(e.Modifier, 'control')) && ...
         ~isempty(strcmpi(e.Key, 'd'))
      delete(findall(h, 'type','line'));
      return
   end

   if isempty(e.Character) && ...
         ~isempty(strcmpi(e.Modifier, 'control')) && ...
         ~isempty(strcmpi(e.Key, 'a'))
      disp(m_pos)
   end
   
end

% % function characteristic_function_to_density (phi,n,a,b) 
% {
% %   phi, % characteristic function; should be vectorized
% %   n,   % Number of points, ideally a power of 2
% %   a, b % Evaluate the density on [a,b[
% 
%   i <- 0:(n-1)            % Indices
%   dx <- (b-a)/n           % Step size, for the density
%   x <- a + i * dx         % Grid, for the density
%   dt <- 2*pi / ( n * dx ) % Step size, frequency space
%   c <- -n/2 * dt          % Evaluate the characteristic function on [c,d]
%   d <-  n/2 * dt          % (center the interval on zero)
%   t <- c + i * dt         % Grid, frequency space
%   phi_t <- phi(t)
%   X <- exp( -(0+1i) * i * dt * a ) * phi_t
%   Y <- fft(X)
%   density <- dt / (2*pi) * exp( - (0+1i) * c * x ) * Y
%   data.frame(...
%     i = i,
%     t = t,
%     characteristic_function = phi_t,
%     x = x,
%     density = Re(density)
%   )
% }
% 
% d <- characteristic_function_to_density(
%   function(t,mu=1,sigma=.5) 
%     exp( (0+1i)*t*mu - sigma^2/2*t^2 ),
%   2^8,
%   -3, 3
% )
% plot(d$x, d$density, las=1)
% curve(dnorm(x,1,.5), add=TRUE)

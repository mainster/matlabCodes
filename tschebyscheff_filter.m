% Tschebyscheff filter entwurf
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% http://www.eit.hs-karlsruhe.de/mesysto/teil-a-zeitkontinuierliche-signale-und-systeme/grundlagen-des-filterentwurfs/standardisierte-entwurfsverfahren-fuer-tiefpass-filter/tschebyscheff-filter.html
% MDB 19-12-2015  Klausurvorbereitung Stochastische Systeme
%

% Tschebyschow-Polynome erster Art sind Lösung der Tschebyschow-
% Differentialgleichung  (1-x^2).y''-x.y'+n^2.y = 0
function tschebyscheff_filter()
   clear Tn* N* 
   syms x y z w wc
   global TN;
   Nmax = 2;

   Tx=str2func(['@(x)' Tn(5,x,'str')]);
   ng=@(eps,w,wc) 1+eps.^2*Tx(x).^2;

   poles = double( solve(ng(.65,x,2)==0) ) 
   plot(real(poles),imag(poles),'x'); 
   xlim([-1,1]); ylim([-1,1])
   %%
   
   line(xlim,[0 0],'color','red','linestyle','--','linewidth', .01)
   line([0 0],ylim,'color','red','linestyle','--','linewidth', .01)
end

% Recursive solution of Tschebyschow 2nd order differential equation
%
function TN = Tn(N,x, varargin)
   handle = 0;
   
   xx=symvar(x);
   if isempty(xx)
      warning('x must be symvar')
   end
   
   if nargin>2
      if max(strcmpi(varargin{1}, {'hdl','handle'})) > 0
         handle = 1;
      end
      if max(strcmpi(varargin{1}, {'string','str'})) > 0
         handle = 2;
      end
   end
   
   if N==0     % Initial condition T0(x) = 1
      TN = 1;
      return
   end

   if N==1     % Initial condition T1(x) = x
      TN = xx;
      return
   end

   switch handle
      case 1
%      TN = @(xx) simplify(2*xx*Tn(N-1,xx,'hdl')-Tn(N-2,xx,'hdl'));
         TN = @(xx) simplify(2*xx*Tn(N-1,xx)-Tn(N-2,xx));
      case 2
         TN = char(simplify(2*xx*Tn(N-1,xx)-Tn(N-2,xx)));
      otherwise
         TN = simplify(2*xx*Tn(N-1,xx)-Tn(N-2,xx));
   end
end




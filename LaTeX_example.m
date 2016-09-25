%% LaTeX Examples--Some well known equations rendered in LaTeX
%
figure('color','white','units','inches','position',[2 2 4 6.5]);
axis off

%% A matrix; LaTeX code is
% \hbox {magic(3) is } \left( {\matrix{ 8 & 1 & 6 \cr 
% 3 & 5 & 7 \cr 4 & 9 & 2 } } \right)
h(1) = text('units','inch', 'position',[.2 5], ...
    'fontsize',14, 'interpreter','latex', 'string',...
    ['$$\hbox {magic(3) is } \left( {\matrix{ 8 & 1 & 6 \cr'...
    '3 & 5 & 7 \cr 4 & 9 & 2 } } \right)$$']);

%% A 2-D rotation transform; LaTeX code is
%  \left[ {\matrix{\cos(\phi) & -\sin(\phi) \cr
%  \sin(\phi) & \cos(\phi) \cr}}
%  \right] \left[ \matrix{x \cr y} \right]  
%  
%  $$ \left[ {\matrix{\cos(\phi) 
%  & -\sin(\phi) \cr \sin(\phi) & \cos(\phi)  % \cr}}
%  \right] \left[ \matrix{x \cr y} \right] $$ 
%
h(2) = text('units','inch', 'position',[.2 4], ...
    'fontsize',14, 'interpreter','latex', 'string',...
    ['$$\left[ {\matrix{\cos(\phi) & -\sin(\phi) \cr'...
    '\sin(\phi) & \cos(\phi) \cr}} \right]'...
    '\left[ \matrix{x \cr y} \right]$$']);

%% The Laplace transform; LaTeX code is
%  L\{f(t)\}  \equiv  F(s) = \int_0^\infty\!\!{e^{-st}f(t)dt}  
%  $$ L\{f(t)\} \equiv  F(s) = \int_0^\infty\!\!{e^{-st}f(t)dt} $$
%  The Initial Value Theorem for the Laplace transform:
%  \lim_{s \rightarrow \infty} sF(s) = \lim_{t \rightarrow 0} f(t)
%  $$ \lim_{s \rightarrow \infty} sF(s) = \lim_{t \rightarrow 0}
%  f(t) $$
%
h(3) = text('units','inch', 'position',[.2 3], ...
    'fontsize',14, 'interpreter','latex', 'string',...
    ['$$L\{f(t)\}  \equiv  F(s) = \int_0^\infty\!\!{e^{-st}'...
    'f(t)dt}$$']);

%% The definition of e; LaTeX code is
%  e = \sum_{k=0}^\infty {1 \over {k!} }
%  $$ e = \sum_{k=0}^\infty {1 \over {k!} } $$
%
h(4) = text('units','inch', 'position',[.2 2], ...
    'fontsize',14, 'interpreter','latex', 'string',...
    '$$e = \sum_{k=0}^\infty {1 \over {k!} } $$');

%% Differential equation
% The equation for motion of a falling body with air resistance
% LaTeX code is
%  m \ddot y = -m g + C_D \cdot {1 \over 2} \rho {\dot y}^2 \cdot A
%  $$ m \ddot y = -m g + C_D \cdot {1 \over 2} \rho {\dot y}^2
%  \cdot A  $$
%
h(5) = text('units','inch', 'position',[.2 1], ...
    'fontsize',14, 'interpreter','latex', 'string',...
    ['$$m \ddot y = -m g + C_D \cdot {1 \over 2}'...
    '\rho {\dot y}^2 \cdot A$$']); 

%% Integral Equation; LaTeX code is
%  \int_{0}^{\infty} x^2 e^{-x^2} dx = \frac{\sqrt{\pi}}{4}  
%  $$ \int_{0}^{\infty} x^2 e^{-x^2} dx = \frac{\sqrt{\pi}}{4} $$  
%  
h(6) = text('units','inch', 'position',[.2 0], ...
    'fontsize',14, 'interpreter','latex', 'string',...
    '$$\int_{0}^{\infty} x^2 e^{-x^2} dx = \frac{\sqrt{\pi}}{4}$$');
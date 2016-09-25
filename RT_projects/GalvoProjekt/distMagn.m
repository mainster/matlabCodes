function [ret] = distMagn (exp, varargin)
%% Magnitude distribution of the experiment exp   @@@MDB
% function [RET] = distMagn (EXP, RES, HOLD)
%
% EXP:      vector includes experi
% RES:      range(EXP) = max(EXP) - min(EXP)
%           resolution of magnitude- Axis = range(EXP) / RES
%           DEFAULT: RES=round(0.1 * length(EXP))
% HOLD:     String for specifying plot 
%           'on':   hold on;
%           'off':  hold off;
%           'all':  hold all;
%
res = round(0.1 * length(exp));
holdstr = 'hold off';

if nargin >=2
    res = varargin{1};
end

if nargin >=3
    holdstr = sprintf('hold %s', varargin{2});
end

magvec = linspace(min(exp), max(exp), res); 

for k=1:res 
    Gt(k)=sum(exp>magvec(k)); 
end; 

if ~nargout 
    figure(1);
    eval(holdstr);
    plot(Gt); grid on;
    hold off;
else
    ret = Gt;
end

end

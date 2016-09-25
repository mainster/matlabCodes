% Get complex Baseband in time domain
%
% t: time- vector
% M: M- valued PSK 
% Ts: Symbol- Time in[s] --> 1/Ts = Baudrate
% symbolBits: mapped symbol vector --> sizeof(symbol) = 1
% Ampl: Baseband Amplitude
%
function [res] = zbb(t,M,Ts,symbolBits,Ampl)
rect=@(t) (0.5*sign(t)+0.5);

% Baseband- Pulse: For M-PSK g(t)=cos(2*pi/(2*Ts))*(sigma(t+Ts)-sigma(t-Ts))
 g=@(t) cos((pi*t)/(2*Ts)).*(rect(t+Ts)-rect(t-Ts));

% Summing complex I-Q pointer
 res=0;

    for k=0:M-1
        res=res + g(t-k*Ts)*( cos(pi/M*(2*(symbolBits)-1)) + i*sin(pi/M*(2*(symbolBits)-1)) );
    end;
    res=Ampl*res;
    
    if real(res)==0
        warndlg('No Real signal part')
    elseif imag(res)==0
        warndlg('No Imaginary signal part')
    end
end
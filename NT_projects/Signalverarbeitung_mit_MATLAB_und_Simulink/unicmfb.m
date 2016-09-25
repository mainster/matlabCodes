function [hpt,h,g] = unicmfb(N,L,df,alpha,Lf,grafo,dspo)
% function [hpt,h,g] = unicmfb(N,L,delta_f,alpha,Nfreq,grafo,dspo)
%
% design of critically sampled uniform N-channel cos-mod. filter banks
% (version with linear equation solving)
%
% N         number of filter bank channels
% L         prototype FIR filter length
% delta_f   transition band width normalized to Fsampl/2 (typ. <= 1/2N)
% alpha     weighting factor for error criterion (typ. 1 - 1e8)
%           (use large values to get a high stop band attenuation)
% Nfreq     number of frequency points in pass band of prototype filter (Nfreq = L typ.)
% grafo     1 to enable graphics output, 0 otherwise
% dspo      1 to create ADSP-2181 and ADSP-21020 coefficient files, 0 otherwise
% hpt       prototype low pass filter impulse response
% h         [h1 h2 ...hN] matrix of analysis filter impulse responses (as column vectors)
% g         [g1 g2 ...gN] matrix of synthesis filter impulse responses (as column vectors)
%
% design example: [hpt,h,g] = unicmfb(32,512,1/64,1e5,256,1,0);
%                 result shows 7e-4 dB pass band ripple, 100 dB stop band attenuation,
%                 computation time is 10 seconds on a 266 MHz Pentium-II PC with 64 MB RAM
%
% (c) copyright 2-1998 by G.Doblinger, TU-Vienna, Austria, gerhard.doblinger@tuwien.ac.at

% references: G. Doblinger, Th. Zeitlhofer, " Improved Design of Uniform and Nonuniform
%             Filter Banks", Proc. NORSIG-96, Helsinki, Sept. 24-27, 1996.
%             C-K. Chen, J-H. Lee, "Design of Quadrature Mirror Filters with Linear Phase
%             in the Frequency Domain", IEEE Trans. CAS-II, Vol. 39, Sept. 1992, pp. 593-605

% special functions used: fir1.m            (MATLAB signal proc. toolbox)

if nargin == 0
   help unicmfb
   return
elseif nargin ~= 7
   error('Wrong number of input arguments');
end
fc = 1/(2*N);
if df < 0 | df > fc
   error('delta_f must be in (0,1/2N)');
end

start = clock;

% compute starting solution

as = 7.95 + 7.18*L*df;                 % estimated stop band attenuation in dB
if as < 21                             % determine parameter beta
   beta = 0;
elseif as < 50
   beta = 0.58417*(as-20.96)^0.4 + 0.07886*(as-20.96);
else
   beta = 0.1102*(as-8.7);
end
hpt = fir1(L-1,fc,kaiser(L,beta));
fs = fc + df;
hpt = sqrt(N)*hpt(:)/sum(hpt);

% find optimum prototype low pass filter

Lh = floor((L+1)/2);
N0 = (L-1)/2;
h0 = hpt(1:Lh);                        % first half of symmetric impulse response
theta = linspace(0,pi*fc,Lf)';         % pass band frequencies
n = [0:Lh-1] - N0;
U1 = 2*cos((theta)*n);
U2 = 2*cos((theta-pi/N)*n);
if rem(L,2)                            % odd filter order
   U1(:,Lh) = 0.5*U1(:,Lh);
   U2(:,Lh) = 0.5*U2(:,Lh);
end
alpha = abs(alpha);

% compute matrix Q for stop band energy Es = h0'*Q*h0 of prototype filter

Lh1 = ceil((L-1)/2);
i = [1:Lh1]';
k = i(:,ones(1,Lh1));
ik = k - k';                           % matrix of indices i-k
fspi = fs*pi;
Q = -2*sin(ik*fspi)./(ik+eps);
ik = L+1-k-k';                         % matrix of indices L+1-i-k
Q = Q - 2*sin(ik*fspi)./ik;
Q = Q + 2*(pi-fspi)*eye(Lh1);          % modify diagonal elements
if rem(L,2)                            % odd filter length
   k = [Lh1:-1:1];
   q = -2*sin(k*fspi)./k;
   Q = [[Q q'];[q pi-fspi]];
end
clear n theta thetas i k ik

Niter = 30;                            % maximum number of iterations
epsil = 1e-5;                          % error limit to terminate iteration
tau = 0.7;                             % forgetting factor for impulse response update
tau1 = 1-tau;
I1 = ones(1,Lh);

for k = 1:Niter
   H1 = U1*h0;
   H2 = U2*h0;
   U = H1(:,I1).*U1 + H2(:,I1).*U2;    % matrix for pass band energy
   g0 = (U'*U + alpha*Q) \ sum(U)';    % solution for synthesis low pass filter
   h0 = tau1*h0 + tau*g0;              % impulse response update
   err = norm(h0-g0)/norm(h0);         % impulse response error
   disp(['Iteration ', int2str(k), ', Error = ', num2str(err)]);
   if err < epsil, break, end
end

clear U U1 U2 I1 Q H1 H2 g0

% form symmetric prototype low pass filter impulse response

if rem(L,2)
   Lh1 = Lh-1;
else
   Lh1 = Lh;
end
hpt = sqrt(N)*[h0 ; h0(Lh1:-1:1)];

disp(sprintf('\n Elapsed time = %f sec.', etime(clock,start)));

% compute modulation matrix (for channel impulse responses)

n = [0:L-1]'-N/2-N0;
i = 2*[1:N]-1;
I = n*i;
Ma = 2*cos(pi*fc*I);
n = n + N;
I = n*i;
Ms = 2*cos(pi*fc*I);
hlp = hpt * ones(1,N);
h = hlp .* Ma;                         % analysis filters
g = hlp .* Ms;                         % synthesis filters

clear n i I Ma Ms hlp

% compute reconstruction error using unit impulse at t = Nd and critical sampling

Nx = 2*L;
Nd = 0;                                % delay of input signal
x = [zeros(1,Nd) 1 zeros(1,Nx-Nd-1)];  % input signal
y = zeros(1,Nx);
for k = 1:N
   ya = filter(h(:,k),1,x);
   m = 1:N:Nx;
   u = zeros(1,Nx);
   u(m) = ya(m);
   y = y + filter(g(:,k),1,u);         % overall output signal
end

% compute and plot transfer function

if grafo
   Nft = max(512,2^(ceil(log2(L))+1));
   f = linspace(0,1,Nft);

   magH = fft(h,2*Nft);
   magH = abs(magH(1:Nft,:));
   magH = magH/max(max(magH));
   eps1 = 1e-7;
   i = find(magH <= eps1);
   if ~isempty(i)
      magH(i) = eps1 * ones(size(i));
   end
   magY = abs(freqz(y,1,pi*f));

   close all
   pos = [0.23 0.21 0.76 0.7];
   fdom = figure('name','Frequency domain (xy-zoom on)','Units','normal','Position',pos);

   xstr = 'f normalized to Fsample/2';
   ystr = 'Magnitude in dB';
   tstr1 = ['Cos-modulated filter bank transfer functions, N = ',int2str(N),', L = ',int2str(L)];
   tstr2 = 'Overall transfer function (input signal = unit impulse)';
   subplot(2,1,1), plot(f(:),20*log10(magH)), ylabel(ystr), title(tstr1), grid on;
   subplot(2,1,2), plot(f(:),20*log10(magY(:))), xlabel(xstr), ylabel(ystr), title(tstr2), grid on;
   zoom(fdom,'on');
end

% create ADSP-21020 and ADSP-2181 coefficient files

if dspo

   % compute chopped impulse response (simplifies modulation)
   % (every other block of 2*N samples has opposite sign)

   N2 = 2*N;
   if rem(L,N2)
      disp('INFO: filter length L must be divisible by 2N for DSP implementation');
      disp('      (no coefficient files created)');
      return
   end
   M = L/N2;
   H = zeros(N2,M);
   H(:) = hpt;             % reshape prototype impulse response vector to matrix
   for k = 2:2:M
      H(:,k) = -H(:,k);    % change sign of every other column
   end
   hc = H(:);              % reshape to vector

   % generate table of 4*N cosine values (for modulation signals)

   ct = cos(pi/N2 * [0:2*N2-1]);
   ct  = ct(:);

   % save design result in file for ADSP-21020 implementation (*.dat files)

   save hqmf.dat hc -ascii -double
   save cosqmf.dat ct -ascii -double

   % save design result in file for ADSP-2101 implementation (*.co files)
   % use 6 digit HEX format for coefficients stored in program memory

   % save chopped impulse response first

   hc = hc*2/sqrt(N);               % scale hc to same value as in qmfbank.m
   t15 = 2^15;
   t16 = 2^16;
   bh = [];
   n = length(hc);
   for k=1:n
      bh = [bh;['000000',13,10]];   % 6 digit hex format with leading zeros,
                                    % and 2 trailing zeros, terminate with
                                    % CR LF
   end
   br = round(hc*t15);              % convert to 16 bit 2-compl. integers
   i = find(br>=t15);
   if ~isempty(i), br(i) = (t15-1)*ones(size(i)); end
   i = find(br<0);
   if ~isempty(i), br(i) = t16+br(i); end
   for k=1:n
      ts = dec2hex(br(k));
      bh(k,5-length(ts):4) = ts;
   end

   fad = fopen('hqmf.co','w');
   fwrite(fad,bh','char');
   fclose(fad);

   % repeat for modulation signal

   bh = [];
   n = length(ct);
   for k=1:n
      bh = [bh;['000000',13,10]];   % 6 digit hex format with leading zeros,
                                    % and 2 trailing zeros, terminate with
                                    % CR LF
   end
   br = round(ct*t15);              % convert to 16 bit 2-compl. integers
   i = find(br>=t15);
   if ~isempty(i), br(i) = (t15-1)*ones(size(i)); end
   i = find(br<0);
   if ~isempty(i), br(i) = t16+br(i); end
   for k=1:n
      ts = dec2hex(br(k));
      bh(k,5-length(ts):4) = ts;
   end

   fad = fopen('cosqmf.co','w');
   fwrite(fad,bh','char');
   fclose(fad);

end

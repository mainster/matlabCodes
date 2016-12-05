 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % MATLAB Code Skeleton for QPSK Digital Transmitter 

  % Generate random bits
  bits_per_symbol=2;
  num_symbols=128;
  numbits=bits_per_symbol*num_symbols;
  bits=rand(1,numbits)>0.5;
  
  Tsymb = 16;                  % symbol length
  omega = pi/2;                % carrier frequency

  %%%%%%%%%%%%%%%%%%%%%%%%
  % Transmitter section
                             % initialize transmit sequence
  t = zeros(1,num_symbols*Tsymb);
  i = 1;                       % initialize bit index
  n = 1;                       % initialize time index
  
  while (n <= num_symbols*Tsymb)
   if ( bits(i:i+1) == [ 0 0])
       Igain = 1/sqrt(2);
      Qgain = 1/sqrt(2);
   % ------>Insert code here<-------
   end;
  i = i+2;                    % next 2 bits
   % Generate symbol to be transmitted
   t(n:n+Tsymb-1) = 1111111111111111;   %------>Insert code here<-------
                  
   n = n+Tsymb;                % next symbol
  end;

  % Show the transmitted signal and its spectrum
  % ------>Insert code here<-------

  % Show the transmitted signal constellation 
  rI = t.*cos(omega*[1:num_symbols*Tsymb]);
  rQ = t.*sin(omega*[1:num_symbols*Tsymb]);

  % Filter out the double-frequency term
  low_pass=fir1(512,0.5);
  rI=conv(rI,low_pass);
  rQ=conv(rQ,low_pass);
  figure;
  plot(rI,rQ);
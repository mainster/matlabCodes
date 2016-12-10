function [ rand_zpk, rand_ss ] = ...
              pzg_rss( ctdt, nr_out, nr_in, ...
                       incl_real_poles, nr_poles, lopole_freq_hz )
%   [ rand_zpk, rand_ss ] = ...
%        pzg_rss( ctdt, nr_out, nr_in, ...
%                 incl_real_poles, nr_poles, lopole_freq_hz )
%
%    with ctdt=0 if continuous-time,
%         ctdt=1 if discrete-time
% Creates a pseudorandom MIMO model with a "flexible structure" flavor,
% having mostly lightly-damped complex pole pairs, and close to zero
% dc gain.  By design, at high frequencies the model loses the "collocated 
% sensor/actuator" nature that it has at low frequencies (i.e., alternating 
% non-minimum-phase poles and zeros, for same-numbered input/output paths).
%
% A model with no real-valued poles (i.e., with only lightly-damped pole pairs)
% can be created by:
%  [ rand_zpk, rand_ss ] = ...
%      pzg_rss( ctdt, nr_out, nr_in, 0, nr_poles, lopole_freq_hz );
%

% The following copyrighted m-files comprise the PZGUI tool:
%    ** The contents of these files may not be included **
%    **  in any other program without explicit written  **
%    **    consent from the author, Mark A. Hopkins     **
%     bodepl.m        pzg_bodex.m     pzg_islink.m     pzg_seltxt.m
%     contents.m      pzg_box.m       pzg_islogx.m     pzg_tools.m
%     contourpl.m     pzg_c2d.m       pzg_isunwrp.m    pzg_tpwr.m
%     dpzgui.m        pzg_cntr.m      pzg_lims.m       pzg_txan.m
%     dupdatep.m      pzg_cphndl.m    pzg_menu.m       pzg_unre.m
%     figopts.m       pzg_d2c.m       pzg_moda.m       pzg_unwrap.m
%     fr_disp.m       pzg_disab.m     pzg_onoff.m      pzg_updtfilt.m
%     freqserv.m      pzg_efmt.m      pzg_pfesim.m     pzg_xtrfrq.m
%     gainfilt.m      pzg_err.m       pzg_prvw.m       pzgcalbk.m
%     helpserv.m      pzg_errvis.m    pzg_ptr.m        pzgui.m
%     ldlgfilt.m      pzg_fndo.m      pzg_recovr.m     pzmvserv.m
%     nicholpl.m      pzg_gle.m       pzg_reptxt.m     resppl.m
%     nyqistpl.m      pzg_grid.m      pzg_res.m        rlocuspl.m
%     pidfilt.m       pzg_inzpk.m     pzg_rsppfe.m     sensplot.m
%     pz_move.m       pzg_isdby.m     pzg_rss.m        updatepl.m
%     pzg_bkup.m      pzg_ishzx.m     pzg_scifmt.m     updtpzln.m
%                                     pzg_sclpt.m      zmimntcpt.m
% (c) 1996 - 2014
%    by Professor Mark A. Hopkins, Ph.D.
%       Electrical and Microelectronic Engineering
%       Rochester Institute of Technology
%       Rochester NY, USA 14623        Email:  mark.hopkins@rit.edu
%
% SHAREWARE INFORMATION:
%               FREE, IF USED ONLY FOR EDUCATIONAL PURPOSES.
%   Otherwise:
%    (corporations, companies, and other for-profit users) 
%    Individual licenses -- US$200 per computer
%    Site license -- US$2000 per industrial site, any number of users
%    Make check payable to "Mark A. Hopkins", and remit to address above
% ----------------------------------------------------------------------

rand_zpk = [];
rand_ss = [];

if ~nargin
  ctdt = 0;
elseif ~isreal(ctdt) || ~isequal( numel(ctdt), 1 ) || ( ctdt < 0 )
  return
end
if isequal( ctdt, 0 )
  Ts = 0;
else
  Ts = 1;
end

if ( nargin < 3 ) ...
  || ~isreal(nr_in) || ~isreal(nr_out) ...
  || ( nr_in < 1 ) || ( nr_out < 1 ) ...
  || ~isequal(nr_in,round(nr_in)) || ~isequal(nr_out,round(nr_out))
  nr_in = 1;
  nr_out = 1;
end

if nargin < 4
  incl_real_poles = 1;
else
  incl_real_poles = ~isequal( incl_real_poles, 0 );
end

if ( nargin < 5 ) || ~isnumeric(nr_poles) || ~isequal( 1, numel(nr_poles) ) ...
  || ~isequal( round(abs(nr_poles)), nr_poles )
  nr_poles = [];
end
if ~isempty(nr_poles) && ( nr_poles < 7 )
  disp('Input argument "nr_poles" is not valid.')
  disp('Cannot generate a model with less than seven poles.')
  return
elseif isempty(nr_poles) && ( nargin >= 5 )
  disp('Input argument "nr_poles" is not valid.')
end

if ( nargin < 6 ) || ~isnumeric(lopole_freq_hz) ...
  || ~isequal( 1, numel(lopole_freq_hz) )
  lopole_freq_hz = [];
end
if ~isempty(lopole_freq_hz) && ( lopole_freq_hz <= 0 )
  disp('Input argument "lopole_freq_hz" is not valid.')
  disp('Lowest resonant pole frequency must be a positive number.');
  return
elseif isempty(lopole_freq_hz) && ( nargin >= 6 )
  disp('Input argument "lopole_freq_hz" is not valid.')
end

final_nr_out = nr_out;
final_nr_in = nr_in;

% Create a square system, and reduce it later.
nr_out = max( nr_out, nr_in );
nr_in = nr_out;

% Generate a random s-plane model with "flexible structure" characteristics.
% These are:
%   1)  Poles are around 0.75% damping factor.
%   2)  Lowest pole is at 20-Hz, slightly stiffer than the others.

if isempty(nr_poles)
  def_nr_poles = 49;
  min_nr_poles = 5;
  if isempty(gcbo)
    max_nr_poles = 5000;
  else
    max_nr_poles = 499;
  end
  input_cell = ...
    inputdlg( ...
      {['Enter the # poles to be in the model ' ... 
        '(from ' num2str(min_nr_poles) ...
        ' to ' num2str(max_nr_poles) '):']}, ...
      'Enter the Model-Order', 1, {num2str(def_nr_poles)} );
  if isempty(input_cell) || ~iscell(input_cell) || isempty(input_cell{1})
    % User canceled.
    return
  else
    nr_poles = str2double( input_cell{1} );
    if isempty(nr_poles) || ~isreal(nr_poles) ...
      || isnan(nr_poles) || ~isequal( round(nr_poles), nr_poles ) ...
      || ( nr_poles < 5 ) || ( nr_poles > max_nr_poles )
      errdlg_h = ...
        errordlg( ...
          {'The number of poles must be an integer no less than five,'; ...
           ['and no greater than ' num2str(max_nr_poles) '.']; ...
           ' ';'  Click "OK" to continue.'}, ...
          'pzgui Error:  Incorrect Input');
      uiwait(errdlg_h)
      return
    end
  end
end
nr_pairs = round( (nr_poles-0.5)/2 );

if isempty(lopole_freq_hz)
  def_lopole_freq_hz = 20;
  min_lopole_freq_hz = 0.01;
  input_cell = ...
    inputdlg( ...
      {'Enter the frequency (Hz) of the first resonant peak:'}, ...
      'Enter First-Mode Frequency', 1, {num2str(def_lopole_freq_hz)} );
  if isempty(input_cell) || ~iscell(input_cell) || isempty(input_cell{1})
    % User canceled.
    return
  else
    lopole_freq_hz = str2double( input_cell{1} );
    if isempty(lopole_freq_hz) || ~isreal(lopole_freq_hz) ...
      || isnan(lopole_freq_hz) || ( lopole_freq_hz < min_lopole_freq_hz )
      errdlg_h = ...
        errordlg( ...
          {['The first resonant peak may be no less than ' ...
             num2str(min_lopole_freq_hz) ' Hz.']; ...
           ' ';'  Click "OK" to continue.'}, ...
          'pzgui Error:  Incorrect Input');
      uiwait(errdlg_h)
      return
    end
  end
  pause(0.1)
  drawnow
end

lopole_freq = lopole_freq_hz*2*pi;

hf_medzeta = 0.01;
lf_medzeta = 0.005;

lopole_zeta = 0.015;
min_polezeta = 0.0005;

hi_pole_freq = 0.47e3*lopole_freq;

% Generate "base freqs", log-scaled across the range.
max_exp = 2;
if incl_real_poles
  base_freqs = exp( linspace( 0.5, max_exp, nr_pairs-2 )' );
else
  base_freqs = exp( linspace( 0.5, max_exp, nr_pairs-1 )' );
end
base_freqs = exp(max_exp) - flipud(base_freqs);
base_freqs = 1 + base_freqs - base_freqs(1);
base_freqs = base_freqs * lopole_freq;
multiplier = linspace( 1, hi_pole_freq/base_freqs(end), numel(base_freqs) )';
base_freqs = base_freqs .* multiplier;
base_freqs = [ base_freqs(1)*[1;2;3]; base_freqs(2:end) ];
for k = 2:numel(base_freqs) 
  base_freqs(k) = base_freqs(k) * ( 1 + randn(1)/20 );
end
base_freqs = sort(base_freqs);
imag_pp = base_freqs;

% Generate the damping factors.
delzeta = ( hf_medzeta - lf_medzeta );
zeta_slope = delzeta/( imag_pp(end) - imag_pp(1) );
pp_zetas = zeros(size(imag_pp));
for k = 1:numel(imag_pp)
  pp_zetas(k) = ...
    lf_medzeta + zeta_slope*( imag_pp(k) - lopole_freq );
end
pp_zetas(1) = lopole_zeta;
for k = 1:numel(imag_pp)
  pp_zetas(k) = pp_zetas(k)*( 1 + randn(1)/5 );
end

% Generate the pole locations
pp = zeros(size(imag_pp));
for k = 1:numel(pp)
  pp(k) = imag_pp(k) * ( -pp_zetas(k) + 1i );
  while real(pp(k)) > -min_polezeta*imag(pp(k))
    pp(k) = -1.05*abs(real(pp(k))) + 1i*imag(pp(k));
  end
end

% Generate the zero locations.
ZZ = cell(nr_out,nr_in);
KK = zeros(nr_out,nr_in);
for k1 = 1:nr_out
  for k2 = 1:nr_in
    noncoll = 0;
    max_nr_tries = 60;
    nr_tries = 0;
    colloc_brkdwn_freq = ...
      lopole_freq * min( 50, max( 10, hi_pole_freq/lopole_freq/10 ) );
    while ( noncoll == 0 ) && ( nr_tries < max_nr_tries )
      nr_tries = nr_tries + 1;
      if incl_real_poles
        zz = zeros(numel(pp),1);
      else
        zz = zeros(numel(pp)-1,1);
      end
      for k = 2:numel(zz)
        zz(k) = ( pp(k) + pp(k-1) )/2;
        if imag(zz(k)) < colloc_brkdwn_freq
          var4_real = abs(real(zz(k)))/4;
          var4_imag = abs( imag( pp(k) - pp(k-1) ) )/4;
          delta_imag = randn(1)*var4_imag;
          while abs(delta_imag) > 1.9*var4_imag
            delta_imag = randn(1)*var4_imag;
          end
        else
          var4_real = abs(real(zz(k)))/2;
          var4_imag = imag( pp(k) - pp(k-1) )/2;
          delta_imag = randn(1)*var4_imag;
        end
        zz(k) = zz(k) + randn(1)*var4_real + 1i*delta_imag;
      end
      if any( real(zz) > 0 )
        noncoll = 1;
      end
    end
    
    noncoll_ndx = find( real(zz) > 0 );
    noncoll_freq = min( abs( imag( zz(noncoll_ndx) ) ) );
    if noncoll_freq > 1.1 * colloc_brkdwn_freq
      [ temp, near_bkdwn_ndx ] = ...
          min( abs( imag(zz)-1.1*colloc_brkdwn_freq ) );   %#ok<ASGLU>
      zz(near_bkdwn_ndx) = ...
        abs(real(zz(near_bkdwn_ndx))) ...
        + 1i*imag(zz(near_bkdwn_ndx));
      zz(noncoll_ndx) = ...
        -abs(real(zz(noncoll_ndx))) ...
        + 1i*imag(zz(noncoll_ndx));
    end
    
    zz = [ zz(:).'; conj(zz(:)).' ];
    zz = zz(:);
    real_ndx = find( imag(zz) == 0 );
    zz(real_ndx(2:end)) = [];
    ZZ{k1,k2} = zz;
  end
end

pp(end) = [];
pp = [ pp(:).'; conj(pp(:)).' ];
pp = pp(:);

% Create a mid-freq real pole.
if incl_real_poles
  if Ts == 0
    if nr_pairs < 50
      mf_real_pp = -(1+rand(1)/2) * 10 * lopole_freq;
    else
      mf_real_pp = -(1+rand(1)/3) * 10 * lopole_freq;
    end
    pp = [ mf_real_pp; pp ];
  end

  % Create a LF real-valued pole/zero pair.
  lfreal_pp = -abs( lopole_freq/(1+rand(1)) );
  lfreal_pp = [ lfreal_pp; 1.2*lfreal_pp ];
  pp = [ lfreal_pp; pp ];
  for k1 = 1:nr_out
    for k2 = 1:nr_in
      lfcplx_zz = lopole_freq/(14+rand(1)/2)*(-0.015+1i);
      ZZ{k1,k2} = ...
        [ ZZ{k1,k2}(1); lfcplx_zz; conj(lfcplx_zz); ZZ{k1,k2}(2:end) ];
    end
  end
end

if Ts > 0
  % Determine the minimum sample period for this D-T model.
  max_imag =  max( imag(pp) );
  for k1 = 1:nr_out
    for k2 = 1:nr_in
      max_imag = max([ max_imag; imag(ZZ{k1,k2}) ] );
    end
  end
  min_nyqfreq = 1.05 * max_imag;
  min_fs = 2*min_nyqfreq / (2*pi);
  max_Ts = 1/min_fs;
  Ts = min( Ts, max_Ts );
  if incl_real_poles
    pp = [ exp( pp * Ts ); 0.2 ];
  else
    pp = exp( pp * Ts );
  end
  for k1 = 1:nr_out
    for k2 = 1:nr_in
      ZZ{k1,k2} = exp( ZZ{k1,k2} * Ts );
      % Determine the gain factor.
      uc_pts = exp( 1i*sort( abs(angle([pp;ZZ{k1,k2}(2:end)])) ) );
      pts_frf = zeros(size(uc_pts));
      for k = 1:numel(pp)
        pts_frf = pts_frf - log( uc_pts - pp(k) );
        if numel(ZZ{k1,k2}) >= k
          pts_frf = pts_frf + log( uc_pts - ZZ{k1,k2}(k) );
        end
      end
      pts_frf = exp(pts_frf);
      max_frf_mag = max( abs(pts_frf) );
      kk = 1;
      while max_frf_mag < 20
        kk = kk * 1.1;
        pts_frf = pts_frf * 1.1;
        max_frf_mag = max_frf_mag * 1.1;
      end
      while max_frf_mag > 30
        kk = kk / 1.1;
        pts_frf = pts_frf / 1.1;
        max_frf_mag = max_frf_mag / 1.1;
      end
      KK(k1,k2) = kk;
    end
  end
else
  % Determine the gain factor.
  for k1 = 1:nr_out
    for k2 = 1:nr_in
      jw_pts = 1i*sort( abs(imag([pp;ZZ{k1,k2}(2:end)])) );
      jw_pts( jw_pts == 0 ) = [];
      pts_frf = zeros(size(jw_pts));
      for k = 1:numel(pp)
        pts_frf = pts_frf - log( jw_pts - pp(k) );
        if numel(ZZ{k1,k2}) >= k
          pts_frf = pts_frf + log( jw_pts - ZZ{k1,k2}(k) );
        end
      end
      pts_frf = exp(pts_frf);
      max_frf_mag = max( abs(pts_frf) );
      kk = 1;
      while max_frf_mag < 25
        kk = kk * 1.1;
        pts_frf = pts_frf * 1.1;
        max_frf_mag = max_frf_mag * 1.1;
      end
      while max_frf_mag > 30
        kk = kk / 1.1;
        pts_frf = pts_frf / 1.1;
        max_frf_mag = max_frf_mag / 1.1;
      end
      if ( k1 ~= k2 ) ...
        && ( k1 <= min(nr_out,nr_in) ) && ( k2 <= min(nr_out,nr_in) )
        kk = kk/2;
      end
      KK(k1,k2) = kk;
    end
  end
end

wb_h = -1;
if ( nr_in == 1 ) && ( nr_out == 1 )
  [ reses, poles, direct ] = pzg_res( ZZ{1}, pp, KK(1) );   %#ok<NASGU>
  A = diag(poles);
  B = zeros(numel(poles),1);
  C = zeros(1,numel(poles));
  for k = 1:numel(poles)
    if isreal(reses(k))
      res_col = sqrt( abs(reses(k)) );
      res_row = res_col * sign(reses(k)+eps);
    else
      res_col = sqrt( reses(k) );
      res_row = res_col;
    end
    B(k) = res_row;
    C(k) = res_col;
  end
  T2x2 = [ (1-1i)/2 (1+1i)/2; (1+1i)/2 (1-1i)/2 ];
  T = eye(size(A));
  for k = 2:numel(poles)
    if ~isreal(poles(k)) && ( abs( poles(k)-conj(poles(k-1)) ) < 1e-12 )
      T(k-1:k,k-1:k) = T2x2;
    end
  end
  A = real( T' * A * T );
  B = real( T' * B );
  C = real( C * T );
  if Ts == 0
    dc_gain = -( C / A ) * B;
  else
    dc_gain = ( C / ( eye(size(A)) - A ) ) * B;
  end
  if incl_real_poles
    D(k1,k2) = -dc_gain;
  else
    D(k1,k2) = 0;
  end
  
else
  pole_reses = zeros( nr_out, nr_in, numel(pp) );
  D = zeros( nr_out, nr_in );
  for k1 = 1:min(nr_out,nr_in)
    for k2 = k1+1:min(nr_out,nr_in)
      zz = ZZ{k1,k2};
      zzpos_ndx = find( imag(zz) > 0 );
      zzneg_ndx = find( imag(zz) < 0 );
      zzpos = zz(zzpos_ndx) ...
           + randn(size(zz(zzpos_ndx))).*abs(real(zz(zzpos_ndx)))/200 ...
           + 1i*randn(size(zz(zzpos_ndx))).*imag(zz(zzpos_ndx))/200;
      zz(zzpos_ndx) = zzpos;
      zz(zzneg_ndx) = conj(zzpos);         %#ok<FNDSB>
      ZZ{k2,k1} = zz;
      KK(k2,k1) = KK(k1,k2);
    end
  end
  
  wbweight = 0.5/(nr_out*nr_in);
  wb_count = 0;
  wb_h = waitbar( 0.01,'Processing the residues, please wait ...');
  set( wb_h,'name','Please Wait ...')
  quiet = 1;
  for k1 = 1:nr_out
    for k2 = 1:nr_in
      [ reses, poles, direct ] = pzg_res( ZZ{k1,k2}, pp, KK(k1,k2),[], quiet );
      pole_reses(k1,k2,:) = reshape( reses, 1, 1, numel(pp) );
      if incl_real_poles
        D(k1,k2) = direct;
      else
        D(k1,k2) = 0;
      end
      wb_count = wb_count + 1;
      if isequal( 1, ishandle(wb_h) );
        waitbar( wb_count*wbweight, wb_h )
      end
    end
  end

  % Force the pole-residues all to be rank-one.
  % This guarantees the same #poles in the state-space model.
  A = diag(poles);
  B = zeros(numel(poles),nr_in);
  C = zeros(nr_out,numel(poles));
  b_first = 0;
  for k = 1:numel(poles)
    if isreal(poles(k))
      res_col = sqrt( abs(diag(pole_reses(:,:,k))) );
      res_row = ( res_col .* sign(diag(pole_reses(:,:,k))+eps) )';
    else
      res_col = sqrt( diag(pole_reses(:,:,k)) );
      res_row = res_col.';
    end
    B(k,:) = res_row;
    C(:,k) = res_col;
    % If the pole frequency is more than 50 times higher than the lowest
    % resonant pole frequency, then bias B and C about the mean,
    % proportional to the frequency.
    if ~isreal(poles(k))
      if ( k > 1 ) && ( abs( poles(k-1) - conj(poles(k)) ) < 1e-13 )
        B(k,:) = conj( B(k-1,:) );
        C(:,k) = conj( C(:,k-1) );
        A(k,k) = conj( A(k-1,k-1) );
      else
        b_first = b_first + 1;
        if Ts == 0
          pole_freq = imag( poles(k) );
        else
          pole_freq = imag( log(poles(k)) )/Ts;
        end
        if pole_freq > 50*lopole_freq
          freq_mult = min( 1.1, 1 + pole_freq / (50*lopole_freq) * 0.01 );
          mult_vec = 1 + freq_mult*rand( 1, size(B,2) );
          mult_vec = mult_vec + 1i*freq_mult*randn( 1, size(B,2) )/5;
          if mod(b_first,2)
            B(k,:) = B(k,:) .* mult_vec;
            C(:,k) = C(:,k) ./ mult_vec';
          else
            B(k,:) = B(k,:) ./ mult_vec;
            C(:,k) = C(:,k) .* mult_vec';
          end
        end
      end
    end
  end
  
  % Put model in modal-canonic form.
  T2x2 = [ (1-1i)/2 (1+1i)/2; (1+1i)/2 (1-1i)/2 ];
  T = eye(size(A));
  for k = 2:numel(poles)
    if ~isreal(poles(k)) && ( abs( poles(k)-conj(poles(k-1)) ) < 1e-12 )
      T(k-1:k,k-1:k) = T2x2;
    end
  end
  A = real( T' * A * T );
  B = real( T' * B );
  C = real( C * T );
  if incl_real_poles
    if Ts == 0
      D = ( C/A ) * B;
    else
      D = -( C/( eye(size(A)) - A ) ) * B;
    end
  else
    D = zeros(size(C,1),size(B,2));
  end
  
  % Recompute the zeros based on the rank-one residues.
  for k1 = 1:nr_out
    for k2 = 1:nr_in
      transZ = tzero( A, B(:,k2), C(k1,:), D(k1,k2) );
      transZ( isinf(transZ) ) = [];
      transZ( isnan(transZ) ) = [];
      smallimag_ndx = ...
        find( ( abs(imag(transZ))./abs(transZ) < 1e-12 ) ...
             |( abs(transZ) < 1e-10 ) ...
             |( abs(transZ-1) < 1e-8 ) );
      transZ(smallimag_ndx) = real( transZ(smallimag_ndx) );
      if Ts == 0
        diff_ndx = find( abs(transZ) < 1e-10 );
        if ~isempty(diff_ndx)
          transZ(diff_ndx) = 0;
        end
      else
        diff_ndx = find( abs(transZ-1) < 1e-10 );
        if ~isempty(diff_ndx)
          transZ(diff_ndx) = 1;
        end
      end
      ZZ{k1,k2} = transZ;
      ZZ{k1,k2}( imag(ZZ{k1,k2}) < 0 ) = ...
          conj( ZZ{k1,k2}( imag(ZZ{k1,k2}) > 0 ) );
      if incl_real_poles
        KK(k1,k2) = D(k1,k2);
      end
      wb_count = wb_count + 1;
      if isequal( 1, ishandle(wb_h) );
        waitbar( wb_count*wbweight, wb_h, ...
                'Processing the transmission zeros, please wait ...')
      end
    end
  end
end

for k1 = 1:nr_out
  for k2 = 1:nr_in
    if Ts == 0
      [ tempz, sortndx ] = sort( -abs( imag(ZZ{k1,k2}) ) ); %#ok<ASGLU>
      ZZ{k1,k2} = ZZ{k1,k2}(sortndx);
    else
      [ tempz, sortndx ] = sort( -abs( angle(ZZ{k1,k2}) ) ); %#ok<ASGLU>
      ZZ{k1,k2} = ZZ{k1,k2}(sortndx);
    end
  end
end

if Ts ~= 0
  rand_zpk = ...
    zpk( ZZ(1:final_nr_out,1:final_nr_in), ...
         poles, real( KK(1:final_nr_out,1:final_nr_in) ), Ts );
  rand_ss = ss( A, B(:,1:final_nr_in), C(1:final_nr_out,:), ...
                D(1:final_nr_out,1:final_nr_in), Ts );
else
  rand_zpk = ...
    zpk( ZZ(1:final_nr_out,1:final_nr_in), ...
         poles, real( KK(1:final_nr_out,1:final_nr_in) ) );
  rand_ss = ss( A, B(:,1:final_nr_in), C(1:final_nr_out,:), ...
                D(1:final_nr_out,1:final_nr_in) );
end

if isequal( 1, ishandle(wb_h) );
  delete( wb_h )
end

return

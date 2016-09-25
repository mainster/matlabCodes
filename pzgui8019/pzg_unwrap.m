function BodePhs = pzg_unwrap( BodeFreqs, BodePhs, Domain, plotname )
% Unwraps pzgui angle data, paying attention to the number of poles
% and zeros that are at zero-frequency (integrators and differentiators),
% as well as other poles and zeros that are located exactly on the
% stability boundary (hence, greatly influencing the Nyquist plot).
% BodePhs must be in units of degrees.

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
global PZG
if isempty(PZG) && ~pzg_recovr 
  return
end
evalin('base','global PZG')

row_wise = 1;
if size(BodePhs,2) == 1
  row_wise = 0;
end

if strcmp('s', Domain )
  BodePhs = local_unwrap( BodePhs, BodeFreqs, 1 );
else
  BodePhs = local_unwrap( BodePhs, BodeFreqs, 2 );
end

if ( isreal(Domain) && isequal( 1, Domain ) ) ...
  ||( ischar(Domain) && isequal( 's', Domain ) )
  dom_ndx = 1;
else
  dom_ndx = 2;
end

% For open-loop plot, offset the phase 
% according to the number integrator poles and zeros.
if ( nargin > 3 ) && ~isempty( strfind( lower(plotname),'open') )
  if dom_ndx == 1
    % CONTINUOUS-TIME
    min_bode_freq = min( 0.0001, BodeFreqs(1) );
    integ_poles = ...
      sum( abs(PZG(1).PoleLocs) < min_bode_freq/10 ) ...
      - sum( abs(PZG(1).ZeroLocs) < min_bode_freq/10 );
    init_phs = -90 * integ_poles;
    % Also account for any RHP (real-valued) poles and zeros.
    rhp_poles = ...
      sum( ( imag(PZG(1).PoleLocs) == 0 ) ...
          &( real(PZG(1).PoleLocs) > 0 ) ) ...
      -sum( ( imag(PZG(1).ZeroLocs) == 0 ) ...
          &( real(PZG(1).ZeroLocs) > 0 ) );
    init_phs = init_phs - 180*rhp_poles;
    if PZG(1).Gain < 0
      %if rhp_poles < 0
        init_phs = init_phs - 180;
      %else
      %  init_phs = init_phs + 180;
      %end
    end

    while BodePhs(1) < ( init_phs - 270 )
      BodePhs = BodePhs + 360;
    end
    while BodePhs(1) > ( init_phs + 270 )
      BodePhs = BodePhs - 360;
    end
  else
    % DISCRETE-TIME
    min_bode_freq = min( 1e-4, PZG(2).BodeFreqs(1) * PZG(2).Ts );
    integ_poles = ...
      sum( abs(1-PZG(2).PoleLocs) < min_bode_freq/10 ) ...
      - sum( abs(1-PZG(2).ZeroLocs) < min_bode_freq/10 );
    init_phs = -90 * integ_poles;
    % Also account for any RHP (real-valued) poles and zeros.
    rhp_poles = ...
      sum( ( imag(PZG(1).PoleLocs) == 0 ) ...
          &( real(PZG(1).PoleLocs) > 1+1e-12 ) ) ...
      -sum( ( imag(PZG(1).ZeroLocs) == 0 ) ...
           &( real(PZG(1).ZeroLocs) > 1+1e-12 ) );
    init_phs = init_phs - 180*rhp_poles;
    if PZG(1).Gain < 0
      %if rhp_poles < 0
        init_phs = init_phs - 180;
      %else
      %  init_phs = init_phs + 180;
      %end
    end
    while BodePhs(1) < ( init_phs - 270 )
      BodePhs = BodePhs + 360;
    end
    while BodePhs(1) > ( init_phs + 270 )
      BodePhs = BodePhs - 360;
    end
  end
end

if ( isreal(Domain) && isequal( 2, Domain ) ) ...
  ||( ischar(Domain) && isequal( 'z', Domain ) )
  nyq_ndx = pzg_gle( BodeFreqs, pi/PZG(2).Ts,'<');
  % For discrete-time,
  % make sure frequencies are set up [ f Fs-flip(f) Fs+f 2Fs-flip(f) ]
  if isequal( numel(BodeFreqs), 4*nyq_ndx )
    fs_ndx = 2*nyq_ndx;
    if row_wise
      BodePhs(nyq_ndx+1:fs_ndx) = -fliplr( BodePhs(1:nyq_ndx) );
      BodePhs(fs_ndx+1:fs_ndx+nyq_ndx) = BodePhs(1:nyq_ndx);
      BodePhs(fs_ndx+nyq_ndx+1:2*fs_ndx) = -fliplr( BodePhs(1:nyq_ndx) );
    else
      BodePhs(nyq_ndx+1:fs_ndx) = -flipud( BodePhs(1:nyq_ndx) );
      BodePhs(fs_ndx+1:fs_ndx+nyq_ndx) = BodePhs(1:nyq_ndx);
      BodePhs(fs_ndx+nyq_ndx+1:2*fs_ndx) = -flipud( BodePhs(1:nyq_ndx) );
    end
  end
end

% Make sure the final phase agrees with the pole-excess.
if dom_ndx == 1
  % Continuous-time
  if isempty(PZG(1).PoleLocs)
    initial_phase = angle( PZG(1).Gain );
  elseif isempty(PZG(1).ZeroLocs)
    initial_phase = ...
      ( angle( PZG(1).Gain ) ...
        - sum( angle( 1i*1e-12-PZG(1).PoleLocs ) ) )/pi*180;
  else
    initial_phase = ...
      ( angle( PZG(1).Gain ) ...
        + sum( angle( 1i*1e-12-PZG(1).ZeroLocs ) ) ...
        - sum( angle( 1i*1e-12-PZG(1).PoleLocs ) ) )/pi*180;
  end
  initial_phase_error = round( BodePhs(1) - initial_phase );
  while ( initial_phase_error > 180 )
    BodePhs = BodePhs - 360;
    initial_phase_error = round( BodePhs(1) - initial_phase );
  end
  while ( initial_phase_error < -180 )
    BodePhs = BodePhs + 360;
    initial_phase_error = round( BodePhs(1) - initial_phase );
  end

  if isempty(PZG(1).PoleLocs)
    final_phase = angle( PZG(1).Gain );
  elseif isempty(PZG(1).ZeroLocs)
    final_phase = ...
      ( angle( PZG(1).Gain ) ...
        - sum( angle( 1i*BodeFreqs(end) - PZG(1).PoleLocs ) ) ...
        - 180/pi*PZG(1).PureDelay*BodeFreqs(end) )/pi*180;
  else
    final_phase = ...
      ( angle( PZG(1).Gain ) ...
        + sum( angle( 1i*BodeFreqs(end) - PZG(1).ZeroLocs ) ) ...
        - sum( angle( 1i*BodeFreqs(end) - PZG(1).PoleLocs ) ) ...
        - 180/pi*PZG(1).PureDelay*PZG(1).BodeFreqs(end) )/pi*180;
  end
  final_phase_error = round( BodePhs(end) - final_phase );
  if abs(final_phase_error) > 180
    % There must be a pole or zero very close to the jW-axis.
    jW_pole_ndxs = find( ( abs(real(PZG(1).PoleLocs)) < 1e-8 ) ...
                        &( imag(PZG(1).PoleLocs) > 1e-12 ) );
    for k = 1:numel(jW_pole_ndxs)
      this_jW_pole = PZG(1).PoleLocs(jW_pole_ndxs(k));
      this_W = imag(this_jW_pole);
      this_Wndx = pzg_gle( BodeFreqs, this_W,'near');
      phase_below = BodePhs( max(1,this_Wndx-2) );
      phase_above = ...
        BodePhs( min( numel(BodeFreqs),this_Wndx+2) );
      if phase_above > ( phase_below+90 )
        BodePhs(this_Wndx+1:end) = ...
          -360 + BodePhs(this_Wndx+1:end);
      end
    end
    jW_zero_ndxs = find( ( abs(real(PZG(1).ZeroLocs)) < 1e-8 ) ...
                        &( imag(PZG(1).ZeroLocs) > 1e-12 ) );
    for k = 1:numel(jW_zero_ndxs)
      this_jW_zero = PZG(1).ZeroLocs(jW_zero_ndxs(k));
      this_W = imag(this_jW_zero);
      this_Wndx = pzg_gle( BodeFreqs, this_W,'near');
      phase_below = BodePhs( max(1,this_Wndx-2) );
      phase_above = ...
        BodePhs( min( numel(BodeFreqs),this_Wndx+2) );
      if phase_above < ( phase_below+90 )
        BodePhs(this_Wndx+1:end) = ...
          360 + BodePhs(this_Wndx+1:end);
      end
    end
  end
else
  % Discrete-time
  if isempty(PZG(2).PoleLocs)
    initial_phase = angle( PZG(2).Gain );
  elseif isempty(PZG(2).ZeroLocs)
    initial_phase = ...
      ( angle( PZG(2).Gain ) ...
        - sum( angle( exp(1i*1e-10)-PZG(2).PoleLocs ) ) )/pi*180;
  else
    initial_phase = ...
      ( angle( PZG(2).Gain ) ...
        + sum( angle( exp(1i*1e-10)-PZG(2).ZeroLocs ) ) ...
        - sum( angle( exp(1i*1e-10)-PZG(2).PoleLocs ) ) )/pi*180;
  end
  initial_phase_error = round( BodePhs(1) - initial_phase );
  while ( initial_phase_error > 180 )
    BodePhs = BodePhs - 360;
    initial_phase_error = round( BodePhs(1) - initial_phase );
  end
  while ( initial_phase_error < -180 )
    BodePhs = BodePhs + 360;
    initial_phase_error = round( BodePhs(1) - initial_phase );
  end

  if isempty(PZG(2).PoleLocs)
    final_phase = angle( PZG(2).Gain );
  elseif isempty(PZG(2).ZeroLocs)
    angles_from_poles = angle( exp(1i*(pi-1e-10))  - PZG(2).PoleLocs );
    neg_pangle = find( angles_from_poles < 0 );
    if ~isempty(neg_pangle)
      angles_from_poles(neg_pangle) = angles_from_poles(neg_pangle) + 2*pi;
    end
    final_phase = ...
      ( angle( PZG(2).Gain ) ...
        - sum(angles_from_poles) ...
        - pi*PZG(2).PureDelay )/pi*180;
  else
    angles_from_zeros = angle( exp(1i*(pi-1e-10))  - PZG(2).ZeroLocs );
    neg_zangle = find( angles_from_zeros < 0 );
    if ~isempty(neg_zangle)
      angles_from_zeros(neg_zangle) = angles_from_zeros(neg_zangle) + 2*pi;
    end
    angles_from_poles = angle( exp(1i*(pi-1e-10))  - PZG(2).PoleLocs );
    neg_pangle = find( angles_from_poles < 0 );
    if ~isempty(neg_pangle)
      angles_from_poles(neg_pangle) = angles_from_poles(neg_pangle) + 2*pi;
    end
    final_phase = ...
      ( angle( PZG(2).Gain ) ...
        + sum(angles_from_zeros) ...
        - sum(angles_from_poles) ...
        - pi*PZG(2).PureDelay )/pi*180;
  end
  nyq_ndx = pzg_gle( BodeFreqs, pi/PZG(2).Ts,'<=');
  final_phase_error = round( BodePhs(nyq_ndx) - final_phase );
  if abs(final_phase_error) > 180
    % There must be a pole or zero very close to the jW-axis.
    ejW_pole_ndxs = ...
      find( ( ( abs(PZG(2).PoleLocs) - 1 ) < 1e-8 ) ...
           &( imag(PZG(2).PoleLocs) > 1e-12 ) );
    for k = 1:numel(ejW_pole_ndxs)
      this_jW_pole = log( PZG(2).PoleLocs(ejW_pole_ndxs(k)) )/PZG(2).Ts;
      this_W = imag(this_jW_pole);
      this_Wndx = pzg_gle( BodeFreqs, this_W,'near');
      phase_below = BodePhs( max(1,this_Wndx-2) );
      phase_above = ...
        BodePhs( min( numel(BodeFreqs),this_Wndx+2) );
      if phase_above > ( phase_below+90 )
        BodePhs(this_Wndx+1:end) = ...
          -360 + BodePhs(this_Wndx+1:end);
      end
    end
    jW_zero_ndxs = find( ( abs(real(PZG(2).ZeroLocs)) < 1e-8 ) ...
                        &( imag(PZG(2).ZeroLocs) > 1e-12 ) );
    for k = 1:numel(jW_zero_ndxs)
      this_jW_zero = PZG(2).ZeroLocs(jW_zero_ndxs(k));
      this_W = imag(this_jW_zero);
      this_Wndx = pzg_gle( BodeFreqs, this_W,'near');
      phase_below = BodePhs( max(1,this_Wndx-2) );
      phase_above = ...
        BodePhs( min( numel(BodeFreqs),this_Wndx+2) );
      if phase_above < ( phase_below+90 )
        BodePhs(this_Wndx+1:end) = ...
          360 + BodePhs(this_Wndx+1:end);
      end
    end
  end    
end
  
return

function  unwrapped_phs = local_unwrap( wrapped_phs, BodeFreqs, Domain )
  
  global PZG
  
  unwrapped_phs = [];
  if ~isreal(wrapped_phs) || ( numel(wrapped_phs) < 3 ) ...
    || ( ndims(wrapped_phs) > 2 ) || ( min(size(wrapped_phs)) > 1 ) %#ok<ISMAT>
    return
  end
  
  unwrapped_phs = wrapped_phs;
  
  if min(unwrapped_phs) < (-180+1e-7)
    pos180_ndxs = find( unwrapped_phs > (180-1e-7) );
    if ~isempty(pos180_ndxs)
      unwrapped_phs(pos180_ndxs) = unwrapped_phs(pos180_ndxs) - 360;
    end
  end
  
  for k = 1:2
    delta_phs = diff(unwrapped_phs);
    jump_ndxs = find( abs(delta_phs) > 270 );
    for k1 = 1:numel(jump_ndxs)
      if delta_phs(jump_ndxs(k1)) > 0
        unwrapped_phs(jump_ndxs(k1)+1:end) = ...
          unwrapped_phs(jump_ndxs(k1)+1:end) - 360;
      else
        unwrapped_phs(jump_ndxs(k1)+1:end) = ...
          unwrapped_phs(jump_ndxs(k1)+1:end) + 360;
      end
    end
  end
  
  phs_diff = diff(unwrapped_phs);
  bkwd_jmp_ndx = 2 + find( abs(phs_diff(2:end)) > 100 );
  for k = 1:numel(bkwd_jmp_ndx)
    this_ndx = bkwd_jmp_ndx(k);
    if ( this_ndx > 1 ) && ( this_ndx < numel(unwrapped_phs) )
      if ( unwrapped_phs(this_ndx) < unwrapped_phs(this_ndx-1) ) ...
        &&( unwrapped_phs(this_ndx) < unwrapped_phs(this_ndx+1) )
        unwrapped_phs(this_ndx:end) = unwrapped_phs(this_ndx:end) + 360; 
      elseif ( unwrapped_phs(this_ndx) > unwrapped_phs(this_ndx-1) ) ...
           &&( unwrapped_phs(this_ndx) > unwrapped_phs(this_ndx+1) )
        unwrapped_phs(this_ndx:end) = unwrapped_phs(this_ndx:end) - 360; 
      end
    end
  end
  
  phs_diff = diff(unwrapped_phs);
  ndx_180jump = find( abs(phs_diff) > 170 );
  
  all_poles = [ PZG(Domain).PoleLocs; PZG(Domain).CLPoleLocs ];
  if Domain == 1
    eff_poles = all_poles( real(all_poles) <= 0 );
    eff_zeros = all_poles( real(all_poles) > 0 );
  else
    eff_poles = all_poles( abs(all_poles) <= 1 );
    eff_zeros = all_poles( abs(all_poles) > 1 );
  end
  
  all_zeros = PZG(Domain).ZeroLocs;
  if Domain == 1
    eff_poles = [ eff_poles; all_zeros( real(all_zeros) > 0 ) ];
    eff_zeros = [ eff_zeros; all_zeros( real(all_zeros) <= 0 ) ];
  else
    eff_poles = [ eff_poles; all_zeros( abs(all_zeros) > 1 ) ];
    eff_zeros = [ eff_zeros; all_zeros( abs(all_zeros) <= 1 ) ];
  end
  
  if ~isempty(ndx_180jump)
    jump_freqs = BodeFreqs(ndx_180jump);
    min_pole_dist = inf;
    min_zero_dist = inf;
    for k = 1:numel(jump_freqs)
      if ~isempty(eff_poles)
        min_pole_dist = ...
          min( min_pole_dist, min( abs( imag(eff_poles) - jump_freqs(k) ) ) );
      end
      if ~isempty(eff_zeros)
        min_zero_dist = ...
          min( min_zero_dist, min( abs( imag(eff_zeros) - jump_freqs(k) ) ) );
      end
      if ( min_pole_dist < min_zero_dist ) && ( phs_diff(ndx_180jump(k)) > 0 )
        unwrapped_phs(ndx_180jump(k)+1:end) = ...
          unwrapped_phs(ndx_180jump(k)+1:end) - 360;
      elseif ( min_pole_dist > min_zero_dist ) && ( phs_diff(ndx_180jump(k)) < 0 )
        unwrapped_phs(ndx_180jump(k)+1:end) = ...
          unwrapped_phs(ndx_180jump(k)+1:end) + 360;
      end
    end
  end
  
  % Look for open-loop poles or zeros that are repeated on the imaginary
  % axis (not including poles and zeros at the origin).
  if Domain == 1
    imag_ax_p_ndx = ...
      find( ( abs(real(PZG(Domain).PoleLocs)) < 1e-6 ) ...
           &( imag(PZG(Domain).PoleLocs) > 1e-6 ) );
    imag_ax_z_ndx = ...
      find( ( abs(real(PZG(Domain).ZeroLocs)) < 1e-6 ) ...
           &( imag(PZG(Domain).ZeroLocs) > 1e-6 ) );
  else
    imag_ax_p_ndx = ...
      find( ( abs( abs(PZG(Domain).PoleLocs) - 1 ) < 1e-6 ) ...
           &( imag(PZG(Domain).PoleLocs) > 1e-6 ) );
    imag_ax_z_ndx = ...
      find( ( abs( abs(PZG(Domain).ZeroLocs) - 1 ) < 1e-6 ) ...
           &( imag(PZG(Domain).ZeroLocs) > 1e-6 ) );
  end
  % Identify repeated poles and zeros.
  imag_ax_poles = PZG(Domain).PoleLocs(imag_ax_p_ndx);
  for k = numel(imag_ax_poles):-1:2
    for k2 = 1:k-1
      if abs(imag_ax_poles(k2)-imag_ax_poles(k)) < 2e-6
        imag_ax_poles(k2) = imag_ax_poles(k);
      end
    end
  end
  unique_imag_ax_poles = unique(imag_ax_poles);
  pole_rep = ones(size(unique_imag_ax_poles));
  for k = 1:numel(pole_rep)
    pole_rep(k) = sum( imag_ax_poles == unique_imag_ax_poles(k) );
    expected_delta_phs = -180*pole_rep(k);
    if Domain == 1
      pole_freq_ndx = ...
        pzg_gle( BodeFreqs, imag(unique_imag_ax_poles(k)),'<=');
    else
      pole_freq_ndx = ...
        pzg_gle( BodeFreqs, ...
                 angle(unique_imag_ax_poles(k))/PZG(2).Ts,'<=');
    end
    ndx1 = max(1,pole_freq_ndx-10);
    ndx2 = min(numel(unwrapped_phs),pole_freq_ndx+10);
    actual_delta_phs = unwrapped_phs(ndx2) - unwrapped_phs(ndx1);
    while ( actual_delta_phs - expected_delta_phs ) > 270
      unwrapped_phs(pole_freq_ndx+1:end) = ...
        unwrapped_phs(pole_freq_ndx+1:end) - 360;
      actual_delta_phs = unwrapped_phs(ndx2) - unwrapped_phs(ndx1);
    end
    while ( actual_delta_phs - expected_delta_phs ) < -270
      unwrapped_phs(pole_freq_ndx+1:end) = ...
        unwrapped_phs(pole_freq_ndx+1:end) + 360;
      actual_delta_phs = unwrapped_phs(ndx2) - unwrapped_phs(ndx1);
    end
  end
  
  imag_ax_zeros = PZG(Domain).ZeroLocs(imag_ax_z_ndx);
  for k = numel(imag_ax_zeros):-1:2
    for k2 = 1:k-1
      if abs(imag_ax_zeros(k2)-imag_ax_zeros(k)) < 2e-6
        imag_ax_zeros(k2) = imag_ax_zeros(k);
      end
    end
  end
  unique_imag_ax_zeros = unique(imag_ax_zeros);
  zero_rep = ones(size(unique_imag_ax_zeros));
  for k = 1:numel(zero_rep)
    zero_rep(k) = sum( imag_ax_zeros == unique_imag_ax_zeros(k) );
    expected_delta_phs = 180*zero_rep(k);
    if Domain == 1
      zero_freq_ndx = ...
        pzg_gle( BodeFreqs, imag(unique_imag_ax_zeros(k)),'<=');
    else
      zero_freq_ndx = ...
        pzg_gle( BodeFreqs, ...
                 angle(unique_imag_ax_zeros(k))/PZG(2).Ts*2,'<=');
    end
    ndx1 = max(1,zero_freq_ndx-10);
    ndx2 = min(numel(unwrapped_phs),zero_freq_ndx+10);
    actual_delta_phs = unwrapped_phs(ndx2) - unwrapped_phs(ndx1);
    while ( actual_delta_phs - expected_delta_phs ) > 270
      unwrapped_phs(zero_freq_ndx+1:end) = ...
        unwrapped_phs(zero_freq_ndx+1:end) - 360;
      actual_delta_phs = unwrapped_phs(ndx2) - unwrapped_phs(ndx1);
    end
    while ( actual_delta_phs - expected_delta_phs ) < -270
      unwrapped_phs(zero_freq_ndx+1:end) = ...
        unwrapped_phs(zero_freq_ndx+1:end) + 360;
      actual_delta_phs = unwrapped_phs(ndx2) - unwrapped_phs(ndx1);
    end
  end
  
return

function [ BodeFreqs, BodePhs, synced_up ] = ...
             local_sync_with_contour( BodeFreqs, BodePhs, Domain ) %#ok<DEFNU>

  % Make sure that Nichols phase data agrees with contour data.

  global PZG
  
  synced_up = 0;

  if Domain == 1
    nic_freqs = BodeFreqs;
    nyq_ndx = numel(nic_freqs);
  else
    nyq_ndx = pzg_gle( BodeFreqs, pi/PZG(2).Ts,'<');
    nic_freqs = BodeFreqs(1:nyq_ndx);
  end

  flag1_ndxs = find( PZG(Domain).cntr_data.contour_flag == 1 );
  flag1_freqs = PZG(Domain).cntr_data.contour_freq(flag1_ndxs);
  [ common_freqs, ndxA, sub_bode_ndxs ] = ...
      intersect( flag1_freqs, nic_freqs );
    
  if ~isequal( numel(common_freqs), nyq_ndx )
    return
  end
  
  if ~isempty(ndxA)
    sub_nyq_ndxs = flag1_ndxs( ndxA );
    this_bode_phs = BodePhs(sub_bode_ndxs);
    tooneg_ndxs = ...
      find( this_bode_phs(:) ...
           < ( PZG(Domain).cntr_data.Nichols_phs(sub_nyq_ndxs) - 270 ) );
    while ~isempty(tooneg_ndxs)
      BodePhs(sub_bode_ndxs(tooneg_ndxs)) = ...
        BodePhs(sub_bode_ndxs(tooneg_ndxs)) + 360;
      this_bode_phs = BodePhs(sub_bode_ndxs);
      tooneg_ndxs = ...
        find( this_bode_phs(:) ...
             < ( PZG(Domain).cntr_data.Nichols_phs(sub_nyq_ndxs) - 270 ) );
    end
    this_bode_phs = BodePhs(sub_bode_ndxs);
    toopos_ndxs = ...
      find( this_bode_phs(:) ...
           > ( PZG(Domain).cntr_data.Nichols_phs(sub_nyq_ndxs) + 270 ) );
    while ~isempty(toopos_ndxs)
      BodePhs(sub_bode_ndxs(toopos_ndxs)) = ...
        BodePhs(sub_bode_ndxs(toopos_ndxs)) - 360;
      this_bode_phs = BodePhs(sub_bode_ndxs);
      toopos_ndxs = ...
        find( this_bode_phs(:) ...
             > ( PZG(Domain).cntr_data.Nichols_phs(sub_nyq_ndxs) + 270 ) );
    end
    whacky_ndxs = 1 + ...
      find( ( abs( BodePhs(sub_bode_ndxs(2:end-1)) ...
                  -BodePhs(sub_bode_ndxs(1:end-2)) ) > 90 ) ...
           &( abs( BodePhs(sub_bode_ndxs(2:end-1)) ...
                  -BodePhs(sub_bode_ndxs(3:end)) ) > 90 ) );
    if ~isempty(whacky_ndxs)
      BodePhs(sub_bode_ndxs(whacky_ndxs)) = ...
        BodePhs(sub_bode_ndxs(whacky_ndxs+1));
    end
  end
  
  if ( Domain == 2 ) && ( numel(BodePhs) == 4* nyq_ndx )
    % Propagate the phase to the other three half-sample-rate segments.
    phase_segment = BodePhs(1:nyq_ndx);
    new_bode_phs = [ phase_segment(:); -flipud( phase_segment(:) ) ];
    new_bode_phs = [ new_bode_phs; new_bode_phs ];
    if size(BodePhs,1) > 1
      BodePhs = new_bode_phs;
    else
      BodePhs = new_bode_phs';
    end
  end
  
  synced_up = 1;
  
return



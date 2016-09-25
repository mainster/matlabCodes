function  cntr_data = pzg_cntr( Domain )
% Computes FRF data needed for Nichols, 
% Nyquist, and Nyquist-contour plots in PZGUI.

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
cntr_data = [];
if isempty(PZG) && ~pzg_recovr 
  return
end

if ~nargin ...
  ||( ~isequal(Domain,1) && ~isequal(Domain,2) ...
     && ~strcmpi(Domain,'s') && ~strcmpi(Domain,'z') )
  return
end
if ischar(Domain) && ~isempty(Domain)
  if strcmpi(Domain(1),'s')
    Domain = 1;
  elseif strcmpi(Domain(1),'z')
    Domain = 2;
  else
    Domain = [];
  end
end
if isempty(Domain) ...
  ||( ~isequal( Domain, 1 ) && ~isequal( Domain, 2 ) )
  disp('PZG_CNTR:  Incorrect input argument.')
  return
end

wb_h = findobj( allchild(0),'name','FRF Computation Progress');
for k = numel(wb_h):-1:1
  pause(0.1)
  if strcmp( get(wb_h(k),'visible'),'off')
    delete(wb_h(k))
    wb_h(k) = [];
  end
end
if ~isempty(wb_h)
  disp( ...
   'pzg_cntr:  Apparently, FRF computation already underway ("waitbar" exists)')
  return
end

init_sel_freq = [];
if ~isempty(PZG(Domain).FrqSelNdx)
  PZG(Domain).BodeFreqs(PZG(Domain).FrqSelNdx);
end

bodeFR = local_refresh_freqs_pz( Domain ); %#ok<NASGU>

PZG(Domain).recompute_frf = 0;
if isempty( PZG(Domain).BodeFreqs )
  return
end

if Domain == 1
  eff_eps = 3e-12;
else
  eff_eps = 3e-9;
end
spiral_factor = 0.15;

PZG(1).stop_movie = 1;
PZG(2).stop_movie = 1;

% Add Nyquist-contour points to the existing bode freqs.
s_poles = [];
s_zeros = [];
if Domain == 1
  s_contour_freqs = PZG(1).BodeFreqs(:);
  if ~isempty(PZG(1).PoleLocs)
    s_poles = PZG(1).PoleLocs;
    if ~isempty(PZG(1).ZeroLocs)
      s_zeros = PZG(1).ZeroLocs;
    end
  end
else
  s_contour_freqs = PZG(2).BodeFreqs(:);
  % Eliminate points above the Nyquist frequency.
  nyq_ndx = pzg_gle( s_contour_freqs, pi/PZG(2).Ts,'>=');
  if ~isempty(nyq_ndx)
    s_contour_freqs(nyq_ndx:end) = [];
  end
  if ~isempty(PZG(2).PoleLocs)
    s_poles = log( PZG(2).PoleLocs )/PZG(2).Ts;
    if ~isempty(PZG(2).ZeroLocs)
      s_zeros = log( PZG(2).ZeroLocs )/PZG(2).Ts;
    else
      s_zeros = [];
    end
    neg1_p_ndxs = ...
      find( ( abs( s_poles + 1i*pi/PZG(2).Ts ) < 1e-8 ) ...
           |( abs( s_poles - 1i*pi/PZG(2).Ts ) < 1e-8 ) );
    if ~isempty(neg1_p_ndxs)
      s_poles(neg1_p_ndxs) = 1i*pi/PZG(2).Ts;
    end
    if ~isempty(s_zeros)
      neg1_z_ndxs = ...
        find( ( abs( s_zeros + 1i*pi/PZG(2).Ts ) < 1e-8 ) ...
             |( abs( s_zeros - 1i*pi/PZG(2).Ts ) < 1e-8 ) );
    else
      neg1_z_ndxs = [];
    end
    if ~isempty(neg1_z_ndxs)
      s_zeros(neg1_z_ndxs) = 1i*pi/PZG(2).Ts;
    end
  end
end
[ temp, sortndx ] = sort( abs(s_poles) ); %#ok<*ASGLU>
s_poles = s_poles(sortndx);
[ temp, sortndx ] = sort( abs(s_zeros) );
s_zeros = s_zeros(sortndx);

if s_contour_freqs(1) <= 100*eff_eps
  lf_ndx = pzg_gle( s_contour_freqs, 100*eff_eps,'<=');
  s_contour_freqs(1:lf_ndx) = [];
end

% Disregard canceling (or near-canceling) poles and zeros.
for k1 = numel(s_poles):-1:1
  this_pole_canceled = 0;
  for k2 = numel(s_zeros):-1:1
    if ~this_pole_canceled ...
      && ( abs( s_poles(k1) - s_zeros(k2) ) < 2*eff_eps )
      this_pole_canceled = 1;
      s_zeros(k2) = [];
      s_poles(k1) = [];
    end
  end
end

% Determine the lightly-damped pole locations.
ld_s_pole_ndxs = ...
  find( ( imag(s_poles) >= 0 ) ...
       &( real(s_poles) > -eff_eps ) ... 
       &( real(s_poles) < eff_eps/10 ) );
ld_s_poles = s_poles(ld_s_pole_ndxs); %#ok<FNDSB>
[ temp, sortndx ] = sort( imag(ld_s_poles) );
ld_s_poles = ld_s_poles(sortndx);
% Round off poles to the same value if the are extremely close.
for k1 = 1:numel(ld_s_poles)-1
  for k2 = 2:numel(ld_s_poles)
    if abs(ld_s_poles(k1)) <= eff_eps
      ld_s_poles(k1) = 0;
    elseif ( Domain == 2 ) ...
          &&( abs( ld_s_poles(k1) - 1i*pi/PZG(2).Ts ) <= eff_eps )
      ld_s_poles(k1) = 1i*pi/PZG(2).Ts;
    end
    if abs( ld_s_poles(k1) - ld_s_poles(k2) ) < 2*eff_eps
      ld_s_poles(k2) = ld_s_poles(k1);
    end
  end
end
[ ld_s_poles, ndx_a, ndx_b ] = unique(ld_s_poles);
ld_s_pole_rep = ones(size(ld_s_poles));
for k = 1:numel(ld_s_pole_rep)
  ld_s_pole_rep(k) = sum( ndx_b == k );
end

% Determine the lightly-damped zero locations.
ld_s_zero_ndxs = ...
  find( ( imag(s_zeros) >= 0 ) ...
       &( real(s_zeros) > -eff_eps ) ... 
       &( real(s_zeros) < eff_eps ) );
ld_s_zeros = s_zeros(ld_s_zero_ndxs); %#ok<FNDSB>
[ temp, sortndx ] = sort( imag(ld_s_zeros) );
ld_s_zeros = ld_s_zeros(sortndx);
% Round off zeros to the same value if the are extremely close.
for k1 = 1:numel(ld_s_zeros)-1
  for k2 = 2:numel(ld_s_zeros)
    if abs(ld_s_zeros(k1)) <= eff_eps
      ld_s_zeros(k1) = 0;
    elseif ( Domain == 2 ) ...
          &&( abs( ld_s_zeros(k1) - 1i*pi/PZG(2).Ts ) <= eff_eps )
      ld_s_zeros(k1) = 1i*pi/PZG(2).Ts;
    end
    if abs( ld_s_zeros(k1) - ld_s_zeros(k2) ) < 2*eff_eps
      ld_s_zeros(k2) = ld_s_zeros(k1);
    end
  end
end
[ ld_s_zeros, ndx_a, ndx_b ] = unique(ld_s_zeros);
ld_s_zero_rep = ones(size(ld_s_zeros));
for k = 1:numel(ld_s_zero_rep)
  ld_s_zero_rep(k) = sum( ndx_b == k );
end

% Begin defining the structure for contour data.
cntr_data = {};
if Domain == 1
  cntr_data.ld_poles = ld_s_poles;
  cntr_data.encirc_dir = cell(size(ld_s_poles));
  cntr_data.ld_zeros = ld_s_zeros;
else
  cntr_data.ld_poles = exp( ld_s_poles * PZG(2).Ts );
  cntr_data.encirc_dir = cell(size(ld_s_poles));
  cntr_data.ld_zeros = exp( ld_s_zeros * PZG(2).Ts );
end
cntr_data.ld_pole_rep = ld_s_pole_rep;
cntr_data.ld_zero_rep = ld_s_zero_rep;

s_contour_pts = 1i * s_contour_freqs;
s_contour_flag = ones(size(s_contour_pts));
% flag == 1, jWpoint; flag == 0, zero-mag; 
% flag = inf, pole-detour; flag = -inf, extra pt by pole-detour
s_contour_angle = NaN*ones(size(s_contour_pts));

% ......................................................................
% Add a quarter-circle, from 0 to +90 degrees, at zero frequency.
% whether or not there are any poles or zeros there.

nr_extra_pts = 200;
nr_qtrcirc_pts = 2000;
nr_integ = sum( abs(s_poles) <= eff_eps ) ...
           -sum( abs(s_zeros) <= eff_eps );
verylow_ndx = pzg_gle( s_contour_freqs, 100*eff_eps,'>=');
if verylow_ndx > 1
  s_contour_freqs(1:verylow_ndx-1) = [];
  s_contour_pts(1:verylow_ndx-1) = [];
  s_contour_flag(1:verylow_ndx-1) = [];
  s_contour_angle(1:verylow_ndx-1) = [];
end
% Include jW points between eff_eps and the lowest frequency.
max_circ_radius = ...
  min( 10^(  log10(eff_eps)/sqrt(max(1,abs(nr_integ))) ), ...
       s_contour_freqs(1)/3 ) * 10^(1+rand*2);
extra_freqs = ...
  logspace( log10(max_circ_radius), ...
            log10( s_contour_freqs(1)-2*eps ), nr_extra_pts )';

s_contour_freqs = [ zeros(size(extra_freqs)); s_contour_freqs ]; 
s_contour_pts = [ 1i*extra_freqs; s_contour_pts ]; 
if nr_integ > 0
  s_contour_flag = [ -inf*ones(size(extra_freqs)); s_contour_flag ]; 
elseif nr_integ < 0
  s_contour_flag = [ zeros(size(extra_freqs)); s_contour_flag ]; 
else
  s_contour_flag = [ ones(size(extra_freqs)); s_contour_flag ]; 
end
s_contour_angle = [ NaN*ones(size(extra_freqs)); s_contour_angle ];

qtrcirc_pts = ...
  max_circ_radius*exp( 1i * linspace( 0, pi/2-2*eps, nr_qtrcirc_pts ) ).' ...
  .* linspace( spiral_factor/max(1,abs(nr_integ)), 1, nr_qtrcirc_pts )';
s_contour_freqs = [ zeros(size(qtrcirc_pts)); s_contour_freqs ]; 
s_contour_pts = [ qtrcirc_pts; s_contour_pts ]; 
if nr_integ > 0
  s_contour_flag = [ inf*ones(size(qtrcirc_pts)); s_contour_flag ]; 
elseif nr_integ < 0
  s_contour_flag = [ zeros(size(qtrcirc_pts)); s_contour_flag ]; 
else
  s_contour_flag = [ ones(size(qtrcirc_pts)); s_contour_flag ]; 
end
s_contour_angle = [ 180/pi*angle(qtrcirc_pts); s_contour_angle ];

% ......................................................................
if Domain == 2
  % Add a quarter-circle, from -90 to 0 degrees, at the Nyquist frequency, 
  % whether or not there are any poles or zeros there.
  nr_nyq_poles = sum( abs(s_poles-1i*pi/PZG(2).Ts) <= eff_eps ) ...
                -sum( abs(s_zeros-1i*pi/PZG(2).Ts) <= eff_eps );
  veryhi_ndx = ...
    pzg_gle( s_contour_freqs, pi/PZG(2).Ts-1e2*eff_eps,'>');
  if ~isempty(veryhi_ndx) && ( veryhi_ndx <= numel(s_contour_freqs) )
    s_contour_freqs(veryhi_ndx:end) = [];
    s_contour_pts(veryhi_ndx:end) = [];
    s_contour_flag(veryhi_ndx:end) = [];
    s_contour_angle(veryhi_ndx:end) = [];
  end
  % Include jW points between the highest frequency and Nyq-eff_eps
  max_circ_radius = ...
    min( 10^(  log10(eff_eps)/sqrt(max(1,abs(nr_nyq_poles))) ), ...
         (pi/PZG(2).Ts-s_contour_freqs(end))/100 ) * 10^(1+rand*2);
  extra_freqs = ...
    pi/PZG(2).Ts ...
    - logspace( log10( pi/PZG(2).Ts-(s_contour_freqs(end)+eff_eps) ), ...
                log10( max_circ_radius ), nr_extra_pts )';
  extra_freqs(end) = extra_freqs(end-1)+3*eps;

  s_contour_freqs = [ s_contour_freqs; extra_freqs ];
  s_contour_pts = [ s_contour_pts; 1i*extra_freqs ]; 
  if nr_nyq_poles > 0
    s_contour_flag = [ s_contour_flag; -inf*ones(size(extra_freqs)) ]; 
  elseif nr_nyq_poles < 0
    s_contour_flag = [ s_contour_flag; zeros(size(extra_freqs)) ]; 
  else
    s_contour_flag = [ s_contour_flag; ones(size(extra_freqs)) ]; 
  end
  s_contour_angle = [ s_contour_angle; NaN*ones(size(extra_freqs)) ]; 

  qtrcirc_pts = ...
    1i*pi/PZG(2).Ts ...
    + ( max_circ_radius ...
        *exp( 1i * linspace( -pi/2+2*eps, 100*eps, nr_qtrcirc_pts ) ).' ) ...
      .* linspace( 1, spiral_factor/max(1,abs(nr_nyq_poles)), nr_qtrcirc_pts )';
  s_contour_freqs = [ s_contour_freqs; ...
                      pi/PZG(2).Ts*ones(size(qtrcirc_pts)) ]; 
  s_contour_pts = [ s_contour_pts; qtrcirc_pts ]; 
  if nr_nyq_poles > 0
    s_contour_flag = [ s_contour_flag; inf*ones(size(qtrcirc_pts)) ]; 
  elseif nr_nyq_poles < 0
    s_contour_flag = [ s_contour_flag; zeros(size(qtrcirc_pts)) ]; 
  else
    s_contour_flag = [ s_contour_flag; ones(size(qtrcirc_pts)) ]; 
  end
  s_contour_angle = ...
    [ s_contour_angle; 180/pi*angle(qtrcirc_pts-1i*pi/PZG(2).Ts) ];
end

% ......................................................................
% Add a semicircle contour, from -90 to +90 degrees,
% for each non-integrator (and DT non-Nyq-freq) pole location.
for k = 1:numel(ld_s_poles)
  if ( abs(ld_s_poles(k)) > eff_eps ) ...
    &&( ( Domain == 1 ) ...
       ||( ( Domain == 2 ) ...
          &&( abs(ld_s_poles(k)-1i*pi/PZG(2).Ts) > eff_eps ) ) )
    % Get the indexes above and below the pole frequency.
    this_pole_freq = abs(ld_s_poles(k));
    
    lo_mindist = 10^(-1-2*rand) ...
      *min( 10^(0.5+ld_s_pole_rep(k)), 1e5 ) * eff_eps / sqrt(spiral_factor);
    hi_mindist = lo_mindist * sqrt(spiral_factor);
    
    lo_ndx = pzg_gle( s_contour_freqs, this_pole_freq-lo_mindist,'<');
    hi_ndx = pzg_gle( s_contour_freqs, this_pole_freq+hi_mindist,'>');
    
    if ( hi_ndx - lo_ndx ) > 1
      s_contour_freqs(lo_ndx+1:hi_ndx-1) = [];
      s_contour_pts(lo_ndx+1:hi_ndx-1) = [];
      s_contour_flag(lo_ndx+1:hi_ndx-1) = [];
      s_contour_angle(lo_ndx+1:hi_ndx-1) = [];
      lo_ndx = pzg_gle( s_contour_freqs, this_pole_freq-lo_mindist,'<');
      hi_ndx = pzg_gle( s_contour_freqs, this_pole_freq+hi_mindist,'>');
    end
    
    extra_lo_pts = ...
      this_pole_freq ...
      - logspace( log10( this_pole_freq-s_contour_freqs(lo_ndx) ), ...
                  log10(lo_mindist), ...
                  nr_extra_pts )';
    extra_hi_pts = ...
      this_pole_freq ...
      + logspace( log10( hi_mindist ), ...
                  log10(s_contour_freqs(hi_ndx)-this_pole_freq), ...
                  nr_extra_pts )';
    semicirc_pts = ...
      1i*this_pole_freq ...
      + lo_mindist* ...
        exp( 1i*linspace( -(pi/2-1e-2), pi/2-1e-2, 2*nr_qtrcirc_pts ) ).' ...
        .* linspace( 1, spiral_factor/ld_s_pole_rep(k), 2*nr_qtrcirc_pts )';
    s_contour_freqs = [ s_contour_freqs(1:lo_ndx); ...
                        this_pole_freq*ones(size(extra_lo_pts)); ...
                        this_pole_freq*ones(size(semicirc_pts)); ...
                        this_pole_freq*ones(size(extra_hi_pts)); ...
                        s_contour_freqs(hi_ndx:end) ]; 
    s_contour_pts = [ s_contour_pts(1:lo_ndx); ...
                      1i*extra_lo_pts; ...
                      semicirc_pts; ...
                      1i*extra_hi_pts; ...
                      s_contour_pts(hi_ndx:end) ]; 
    s_contour_flag = [ s_contour_flag(1:lo_ndx); ...
                      -inf*ones(size(extra_lo_pts)); ...
                      inf*ones(size(semicirc_pts)); ...
                      -inf*ones(size(extra_hi_pts)); ...
                      s_contour_flag(hi_ndx:end) ]; 
    s_contour_angle = [ s_contour_angle(1:lo_ndx); ...
                        NaN*ones(size(extra_lo_pts)); ...
                        180/pi*angle(semicirc_pts-1i*this_pole_freq); ...
                        NaN*ones(size(extra_hi_pts)); ...
                        s_contour_angle(hi_ndx:end) ]; 
  end
end

% ......................................................................
% Add a semicircle contour, from -90 to +90 degrees,
% for each non-integrator (and DT non-Nyq-freq) zero location.
for k = 1:numel(ld_s_zeros)
  if ( abs(ld_s_zeros(k)) > eff_eps ) ...
    &&( ( Domain == 1 ) ...
       ||( ( Domain == 2 ) ...
          &&( abs(ld_s_zeros(k)-1i*pi/PZG(2).Ts) > eff_eps ) ) )
    % Get the indexes above and below the zero frequency.
    this_zero_freq = abs(ld_s_zeros(k));
    
    lo_mindist = 10^(-1-2*rand)*100*eff_eps;
    hi_mindist = spiral_factor*lo_mindist;
      
    lo_ndx = pzg_gle( s_contour_freqs, this_zero_freq-lo_mindist,'<');
    if isempty(lo_ndx)
      lo_ndx = 1;
    end
    hi_ndx = pzg_gle( s_contour_freqs, this_zero_freq+hi_mindist,'>');
    if isempty(hi_ndx)
      hi_ndx = numel(s_contour_freqs);
    end
    if ( hi_ndx - lo_ndx ) > 1
      s_contour_freqs(lo_ndx+1:hi_ndx-1) = [];
      s_contour_pts(lo_ndx+1:hi_ndx-1) = [];
      s_contour_flag(lo_ndx+1:hi_ndx-1) = [];
      s_contour_angle(lo_ndx+1:hi_ndx-1) = [];
      lo_ndx = pzg_gle( s_contour_freqs, this_zero_freq-lo_mindist,'<');
      if isempty(lo_ndx)
        lo_ndx = 1;
      end
      hi_ndx = pzg_gle( s_contour_freqs, this_zero_freq+hi_mindist,'>');
      if isempty(hi_ndx)
        hi_ndx = numel(s_contour_freqs);
      end
    end
    
    extra_lo_pts = ...
      this_zero_freq ...
      - logspace( log10( this_zero_freq-s_contour_freqs(lo_ndx)-10*eps ), ...
                  log10(lo_mindist), ...
                  nr_extra_pts )';
    extra_hi_pts = ...
      this_zero_freq ...
      + logspace( log10( hi_mindist ), ...
                  log10(s_contour_freqs(hi_ndx)-10*eps-this_zero_freq), ...
                  nr_extra_pts )';

    semicirc_pts = ...
      1i*this_zero_freq ...
      + lo_mindist ...
        *exp( 1i*linspace( -pi/2+1e-2, pi/2-1e-2, 2*nr_qtrcirc_pts ) ).' ...
        .* linspace( 1, spiral_factor/ld_s_zero_rep(k), 2*nr_qtrcirc_pts )';
    s_contour_freqs = [ s_contour_freqs(1:lo_ndx); ...
                        this_zero_freq*ones(size(extra_lo_pts)); ...
                        this_zero_freq*ones(size(semicirc_pts)); ...
                        this_zero_freq*ones(size(extra_hi_pts)); ...
                        s_contour_freqs(hi_ndx:end) ]; 
    s_contour_pts = [ s_contour_pts(1:lo_ndx); ...
                      1i * extra_lo_pts; ...
                      semicirc_pts; ...
                      1i * extra_hi_pts; ...
                      s_contour_pts(hi_ndx:end) ]; 
    s_contour_flag = [ s_contour_flag(1:lo_ndx); ...
                      zeros(size(extra_lo_pts)); ...
                      zeros(size(semicirc_pts)); ...
                      zeros(size(extra_hi_pts)); ...
                      s_contour_flag(hi_ndx:end) ]; 
    s_contour_angle = [ s_contour_angle(1:lo_ndx); ...
                        NaN*ones(size(extra_lo_pts)); ...
                        180/pi*angle(semicirc_pts-1i*this_zero_freq); ...
                        NaN*ones(size(extra_hi_pts)); ...
                        s_contour_angle(hi_ndx:end) ]; 
  end
end

% For s-domain, positive Nyquist contour 
% includes "infinite" quarter-circle, from +90 to 0 degrees.
if Domain == 1
  hi_freq = s_contour_freqs(end);
  if numel(PZG(Domain).PoleLocs) > numel(PZG(Domain).ZeroLocs)
    radial_freq = 2*hi_freq;
    extra_freqs = ...
      radial_freq * logspace( log10(1000*eps+1/2), 0, nr_extra_pts )';
  else
    radial_freq = hi_freq;
    extra_freqs = [];
  end
  pole_excess = ...
    max( 1, numel(PZG(Domain).PoleLocs)-numel(PZG(Domain).ZeroLocs) );
  this_nr_pts = pole_excess*nr_qtrcirc_pts;
  qtrcirc_pts = ...
    radial_freq ...
    *exp( 1i*[ linspace( pi/2, pi/2-3e-4, 30 ) ...
               linspace( pi/2-3e-4, 10*eps, max(30,this_nr_pts-30) ) ] ).' ...
    .* linspace( 1, 6, max(60,this_nr_pts) )';
  
  if isempty(extra_freqs)
    s_contour_freqs = [ s_contour_freqs; ...
                        inf*ones(size(qtrcirc_pts)) ]; 
    s_contour_pts = [ s_contour_pts; ...
                      qtrcirc_pts ]; 
    if numel(PZG(Domain).PoleLocs) > numel(PZG(Domain).ZeroLocs)
      s_contour_flag = [ s_contour_flag; ...
                         zeros(size(qtrcirc_pts)) ]; 
    else
      s_contour_flag = [ s_contour_flag; ...
                         ones(size(qtrcirc_pts)) ]; 
    end
    s_contour_angle = [ s_contour_angle; 
                        180/pi*angle(qtrcirc_pts) ];
  else
    s_contour_freqs = [ s_contour_freqs; ...
                        inf*ones(size(extra_freqs)); ...
                        inf*ones(size(qtrcirc_pts)) ]; 
    s_contour_pts = [ s_contour_pts; ...
                      1i*extra_freqs; ...
                      qtrcirc_pts ]; 
    if numel(PZG(Domain).PoleLocs) > numel(PZG(Domain).ZeroLocs)
      s_contour_flag = [ s_contour_flag; ...
                         zeros(size(extra_freqs)); ...
                         zeros(size(qtrcirc_pts)) ]; 
    else
      s_contour_flag = [ s_contour_flag; ...
                         ones(extra_freqs); ...
                         ones(size(qtrcirc_pts)) ]; 
    end
    s_contour_angle = [ s_contour_angle; 
                        NaN*ones(size(extra_freqs)); ...
                        180/pi*angle(qtrcirc_pts) ];
  end
end


if Domain == 1
  cntr_data.contour_pts = s_contour_pts;
else
  cntr_data.contour_pts = exp( s_contour_pts * PZG(2).Ts );
  % Check that the D-T contour does not go below the neg real axis.
  del_ndx = find( imag( cntr_data.contour_pts ) < 0 );
  if ~isempty(del_ndx)
    if del_ndx(end) == ( numel(cntr_data.contour_pts) - 1 )
      del_ndx(end+1) = numel(cntr_data.contour_pts);
    end
    cntr_data.contour_pts(del_ndx) = [];
    s_contour_freqs(del_ndx) = [];
    s_contour_flag(del_ndx) = [];
    s_contour_angle(del_ndx) = [];
  end
end
cntr_data.contour_freq = s_contour_freqs;
cntr_data.contour_flag = s_contour_flag;
cntr_data.contour_angle = s_contour_angle;

% Compute the contour mapping.
wb_h = -1;
if numel(PZG(Domain).PoleLocs) > 50
  if Domain == 1
    wb_h = waitbar( 0.01,'Computing C-T Nyquist-Contour Mapping ...', ...
                    'name','FRF Computation Progress');
  else
    wb_h = waitbar( 0.01,'Computing D-T Nyquist-Contour Mapping ...', ...
                    'name','FRF Computation Progress');
  end
  %drawnow
  %pause(0.01)
end

[ bode_freqs, bf_ndxs, bf_cntr_ndxs ] = ...
   intersect( PZG(Domain).BodeFreqs, cntr_data.contour_freq );

non_bf_cntr_ndxs = ...
  setdiff( (1:numel(cntr_data.contour_freq)), bf_cntr_ndxs );

contour_mapping = log(PZG(Domain).Gain) * ones(numel(cntr_data.contour_pts),1);
for k = 1:numel(PZG(Domain).PoleLocs)
  contour_mapping = ...
    contour_mapping ...
    - log( cntr_data.contour_pts - PZG(Domain).PoleLocs(k) );
  if numel(PZG(Domain).ZeroLocs) >= k
    contour_mapping = ...
      contour_mapping ...
      + log( cntr_data.contour_pts - PZG(Domain).ZeroLocs(k) );
  end
  if ~mod( k, 10 )
    if ishandle(wb_h)
      waitbar( 0.95*k/numel(PZG(2).PoleLocs), wb_h )
    end
  end
end
contour_mapping = exp(contour_mapping);

% Set W-axis points to NaN
cntr_data.bode_nan_ndxs = [];
for k = 1:numel(ld_s_poles)
  this_pole = ld_s_poles(k);
  if abs(this_pole) > 1e-8
    [ mindist, minndx ] = min( abs( this_pole - 1i*bode_freqs ) );
    if mindist < 1e-10
      contour_mapping(bf_cntr_ndxs(minndx)) = NaN;
      cntr_data.bode_nan_ndxs = [ cntr_data.bode_nan_ndxs; minndx(:) ];
    end
  end
end
for k = 1:numel(ld_s_zeros)
  this_zero = ld_s_zeros(k);
  if abs(this_zero) > 1e-8
    [ mindist, minndx ] = min( abs( this_zero - 1i*bode_freqs ) );
    if mindist < 1e-10
      contour_mapping(bf_cntr_ndxs(minndx)) = NaN;
      cntr_data.bode_nan_ndxs = [ cntr_data.bode_nan_ndxs; minndx(:) ];
    end
  end
end

if ( Domain == 1 ) ...
  && isequal( numel(PZG(1).PoleLocs), numel(PZG(1).ZeroLocs) )
  % Set the contour mapping to the same real value,
  % for the infinite semicircle
  inffreq_ndxs = find( isinf(cntr_data.contour_freq) );
  contour_mapping(inffreq_ndxs) = real( contour_mapping(inffreq_ndxs(1)) );
end

% Make sure infinite points actually got mapped outside the UC.
% contour flags indicate infinite magnitude (inf's)
% contour angles indicate extra points (nan's)
noninf_inf_ndx = find( ( abs(contour_mapping) < 1e4 ) ...
                      & isinf(cntr_data.contour_flag) );
if ~isempty(noninf_inf_ndx)
  % Isolate groups of indexes that are complete segments.
  start_ndxs = [ 1; ...
    1 + find( ( noninf_inf_ndx(2:end) - noninf_inf_ndx(1:end-1) ) > 1 ) ];
  end_ndxs = [ start_ndxs(2:end)-1; numel(noninf_inf_ndx) ];
  seg_lgth = end_ndxs - start_ndxs + 1;
  fullseg_ndx = ...
    find( ( seg_lgth == (nr_qtrcirc_pts+nr_extra_pts) ) ...
         |( seg_lgth == 2*(nr_qtrcirc_pts+nr_extra_pts) ) );
  for k = 1:numel(fullseg_ndx)
    ndx1 = noninf_inf_ndx(start_ndxs(fullseg_ndx(k)));
    ndx2 = noninf_inf_ndx(end_ndxs(fullseg_ndx(k)));
    these_pts = contour_mapping(ndx1:ndx2);
    new_pts = zeros(size(these_pts));
    maxmag = max(abs(these_pts));
    newmaxmag = 2e4/maxmag*(abs(randn(1))+1);
    xtra_lo = these_pts(1:nr_extra_pts);
    xtra_lo = ...
      xtra_lo .* logspace( 0, log10(newmaxmag/maxmag), nr_extra_pts )';
    new_pts(1:nr_extra_pts) = xtra_lo;
    if (ndx2-ndx1+1) == (nr_qtrcirc_pts+nr_extra_pts)
      new_pts(nr_extra_pts+1:end) = ...
        these_pts(nr_extra_pts+1:end) * (newmaxmag/maxmag);
    else
      xtra_hi = these_pts(end-nr_extra_pts+1:end);
      xtra_hi = ...
        xtra_hi.*flipud(logspace( 0, log10(newmaxmag/maxmag), nr_extra_pts )');
      new_pts(end-nr_extra_pts+1:end) = xtra_hi;
      new_pts(nr_extra_pts+1:end-nr_extra_pts) = ...
        these_pts(nr_extra_pts+1:end-nr_extra_pts) * (newmaxmag/maxmag);
    end
    contour_mapping(ndx1:ndx2) = new_pts;
  end
end

% Apply delay, if any.
if Domain == 1
  if PZG(1).PureDelay > 0
    contour_mapping(non_bf_cntr_ndxs) = ...
      contour_mapping(non_bf_cntr_ndxs) ...
      .* exp( -1i*abs(cntr_data.contour_pts(non_bf_cntr_ndxs)) ...
             * PZG(1).PureDelay );
    contour_mapping(bf_cntr_ndxs) = ...
      contour_mapping(bf_cntr_ndxs) ...
      .* exp( -PZG(1).PureDelay * cntr_data.contour_pts(bf_cntr_ndxs) );
  end
else
  if ( PZG(2).PureDelay > 0 ) ...
    && isequal( PZG(2).PureDelay, round(PZG(2).PureDelay) )
    for k = 1:PZG(2).PureDelay
      % Delay poles are at z = 0;
      contour_mapping(non_bf_cntr_ndxs) = ...
        contour_mapping(non_bf_cntr_ndxs) ...
        ./( cntr_data.contour_pts(non_bf_cntr_ndxs) );
      contour_mapping(bf_cntr_ndxs) = ...
        contour_mapping(bf_cntr_ndxs) ...
        ./( cntr_data.contour_pts(bf_cntr_ndxs) );
    end
  end
end

cntr_data.contour_mapping = contour_mapping;

% Scale data for the Nichols and Nyquist plots.
if Domain == 1
  cntr_data.bode2nyq_freqs = PZG(1).BodeFreqs;
  cntr_data.bode2nyq_pts = ...
    10.^(PZG(1).BodeMag/20) .* exp(1i*pi/180*PZG(1).BodePhs);
  % Interrupt the line-plot across w-axis poles and zeros.
  imag_axis_ndxs = ...
    find( ( abs(real(PZG(1).PoleLocs)) < 1e-8 ) ...
         &( imag(PZG(1).PoleLocs) > 1e-8 ) );
  for k = 1:numel(imag_axis_ndxs)
    waxis_pole_freq = imag(PZG(1).PoleLocs(imag_axis_ndxs(k)));
    waxis_pole_freq_ndx = pzg_gle( PZG(1).BodeFreqs, waxis_pole_freq,'near');
    cntr_data.bode2nyq_pts(waxis_pole_freq_ndx) = NaN;
  end
  imag_axis_ndxs = ...
    find( ( abs(real(PZG(1).ZeroLocs)) < 1e-8 ) ...
         &( imag(PZG(1).ZeroLocs) > 1e-8 ) );
  for k = 1:numel(imag_axis_ndxs)
    waxis_zero_freq = imag(PZG(1).ZeroLocs(imag_axis_ndxs(k)));
    waxis_zero_freq_ndx = pzg_gle( PZG(1).BodeFreqs, waxis_zero_freq,'near');
    cntr_data.bode2nyq_pts(waxis_zero_freq_ndx) = NaN;
  end
else
  nyq_ndx = pzg_gle( PZG(2).BodeFreqs, pi/PZG(2).Ts,'<');
  cntr_data.bode2nyq_freqs = PZG(2).BodeFreqs(1:nyq_ndx);
  cntr_data.bode2nyq_pts = ...
    10.^(PZG(2).BodeMag(1:nyq_ndx)/20) ...
    .* exp(1i*pi/180*PZG(2).BodePhs(1:nyq_ndx));
  % Interrupt the line-plot across unit-circle poles and zeros.
  imag_axis_ndxs = ...
    find( ( abs(1-abs(PZG(2).PoleLocs)) < 1e-8 ) ...
         &( imag(PZG(2).PoleLocs) > 1e-8 ) );
  for k = 1:numel(imag_axis_ndxs)
    waxis_pole_freq = angle(PZG(2).PoleLocs(imag_axis_ndxs(k)))/PZG(2).Ts;
    waxis_pole_freq_ndx = pzg_gle( PZG(2).BodeFreqs, waxis_pole_freq,'near');
    cntr_data.bode2nyq_pts(waxis_pole_freq_ndx) = NaN;
  end
  imag_axis_ndxs = ...
    find( ( abs(1-abs(PZG(2).ZeroLocs)) < 1e-8 ) ...
         &( imag(PZG(2).ZeroLocs) > 1e-8 ) );
  for k = 1:numel(imag_axis_ndxs)
    waxis_zero_freq = angle(PZG(2).ZeroLocs(imag_axis_ndxs(k)))/PZG(2).Ts;
    waxis_zero_freq_ndx = pzg_gle( PZG(2).BodeFreqs, waxis_zero_freq,'near');
    cntr_data.bode2nyq_pts(waxis_zero_freq_ndx) = NaN;
  end
end

cntr_data.bode2nyq_scaled_pts = pzg_sclpt( cntr_data.bode2nyq_pts );
  
cntr_data.Nichols_mag = 20*log10(abs(cntr_data.contour_mapping));

cntr_data.Nichols_phs = ...
  180/pi*unwrap( angle( cntr_data.contour_mapping ) );
num_ndxs = find( ~isinf(cntr_data.contour_mapping) ...
                &~isnan(cntr_data.contour_mapping) );
cntr_data.Nichols_phs(num_ndxs) = ...
  180/pi*unwrap( angle( cntr_data.contour_mapping(num_ndxs) ) );

% Start the phase either at zero or -180, 
% depending upon sign of gain and nr of real-valued poles to the right.
if Domain == 1
  nr_180s = sum( numel( find( ( real(PZG(1).ZeroLocs) > 0 ) ...
                             &( imag(PZG(1).ZeroLocs) == 0 ) ) ) ) ...
            - sum( numel( find( ( real(PZG(1).PoleLocs) > 0 ) ...
                               &( imag(PZG(1).PoleLocs) == 0 ) ) ) );
else
  nr_180s = sum( numel( find( ( real(PZG(1).ZeroLocs) > 1 ) ...
                             &( imag(PZG(1).ZeroLocs) == 0 ) ) ) ) ...
            - sum( numel( find( ( real(PZG(1).PoleLocs) > 1 ) ...
                                &( imag(PZG(1).PoleLocs) == 0 ) ) ) );
end
if sign( PZG(Domain).Gain ) < 0
  if nr_180s < 0
    nr_180s = nr_180s + 1;
  elseif nr_180s > 0
    nr_180s = nr_180s - 1;
  else
    nr_180s = 1;
  end
end

if mod( nr_180s, 2 )
  if nr_180s < 0
    % Phase should start at -180
    while cntr_data.Nichols_phs(1) > 90
      cntr_data.Nichols_phs = cntr_data.Nichols_phs - 360;
    end
    while cntr_data.Nichols_phs(1) < -270
      cntr_data.Nichols_phs = cntr_data.Nichols_phs + 360;
    end
  else
    % Phase should start at +180
    while cntr_data.Nichols_phs(1) < -90
      cntr_data.Nichols_phs = cntr_data.Nichols_phs + 360;
    end
    while cntr_data.Nichols_phs(1) > 270
      cntr_data.Nichols_phs = cntr_data.Nichols_phs - 360;
    end
  end
else
  % Phase should start at zero
  while cntr_data.Nichols_phs(1) > 270
    cntr_data.Nichols_phs = cntr_data.Nichols_phs - 360;
  end
  while cntr_data.Nichols_phs(1) < -90
    cntr_data.Nichols_phs = cntr_data.Nichols_phs + 360;
  end
end

if Domain == 2
  nyq_ndx = pzg_gle( PZG(2).BodeFreqs, pi/PZG(2).Ts,'<');
  % For discrete-time,
  % make sure frequencies are set up [ f Fs-flip(f) Fs+f 2Fs-flip(f) ]
  if isequal( numel(PZG(2).BodeFreqs), 4*nyq_ndx )
    fs_ndx = 2*nyq_ndx;
    if size(PZG(2).BodePhs,1) == 1
      PZG(2).BodePhs(nyq_ndx+1:fs_ndx) = ...
        -fliplr( PZG(2).BodePhs(1:nyq_ndx) );
      PZG(2).BodePhs(fs_ndx+1:fs_ndx+nyq_ndx) = ...
        PZG(2).BodePhs(1:nyq_ndx);
      PZG(2).BodePhs(fs_ndx+nyq_ndx+1:2*fs_ndx) = ...
        -fliplr( PZG(2).BodePhs(1:nyq_ndx) );
    else
      PZG(2).BodePhs(nyq_ndx+1:fs_ndx) = ...
        -flipud( PZG(2).BodePhs(1:nyq_ndx) );
      PZG(2).BodePhs(fs_ndx+1:fs_ndx+nyq_ndx) = ...
        PZG(2).BodePhs(1:nyq_ndx);
      PZG(2).BodePhs(fs_ndx+nyq_ndx+1:2*fs_ndx) = ...
        -flipud( PZG(2).BodePhs(1:nyq_ndx) );
    end
  end
end

outlier_ndxs = ...
  find( ( abs( cntr_data.Nichols_phs(2:end-1) ...
              -cntr_data.Nichols_phs(1:end-2) ) > 270 ) ...
       &( abs( cntr_data.Nichols_phs(2:end-1) ...
              -cntr_data.Nichols_phs(3:end) ) > 270 ) ...
       &( abs( cntr_data.Nichols_phs(1:end-2) ...
              -cntr_data.Nichols_phs(3:end) ) < 90 ) );
for k = 1:numel(outlier_ndxs)
  ndx = 1+outlier_ndxs(k);
  cntr_data.Nichols_phs(ndx) = ...
    0.5*( cntr_data.Nichols_phs(ndx+1) + cntr_data.Nichols_phs(ndx-1) );
end
cntr_data.Nichols_phs(end) = 0;

cntr_data.Nyquist_pts = cntr_data.contour_mapping;
cntr_data.Nyquist_scaled_pts = pzg_sclpt( cntr_data.contour_mapping );

% Determine the encirclement direction at each ld pole.
rhp_contour_ndxs = find( cntr_data.contour_flag == inf );
sep_ndxs = find( diff(rhp_contour_ndxs) > 1 );
for k = 1:numel(cntr_data.ld_poles)
  if k == 1
    ndx1 = 1;
    if isempty(sep_ndxs)
      ndx2 = numel(rhp_contour_ndxs);
    else
      ndx2 = sep_ndxs(1);
    end
  else
    ndx1 = sep_ndxs(k-1) + 1;
    if numel(sep_ndxs) >= k
      ndx2 = sep_ndxs(k);
    else
      ndx2 = numel(rhp_contour_ndxs);
    end
  end
  cntr_ndx1 = rhp_contour_ndxs(ndx1);
  cntr_ndx2 = rhp_contour_ndxs(ndx2);
  diff_angle = ...
    cntr_data.Nichols_phs(cntr_ndx1) - cntr_data.Nichols_phs(cntr_ndx2);
  if diff_angle > 0
    % Final angle is more negative than initial angle.
    cntr_data.encirc_dir{k} = 'CW';
  else
    cntr_data.encirc_dir{k} = 'CCW';
  end
end

indent_pz = [ cntr_data.ld_poles; cntr_data.ld_zeros ];
if isempty(indent_pz)
  cntr_data.ld_pseudo_pole_freqs = [];
  cntr_data.ld_pseudo_zero_freqs = [];
  cntr_data.upper_pseudo_cntr = cntr_data.contour_pts;
  if Domain == 1
    if max( abs(cntr_data.upper_pseudo_cntr) ) > 10
      mag_gt1_ndxs = find( abs(cntr_data.upper_pseudo_cntr) > 1 );
      cntr_data.upper_pseudo_cntr(mag_gt1_ndxs) = ...
        ( 1 + log10(abs(cntr_data.upper_pseudo_cntr(mag_gt1_ndxs))) ) ...
        .* exp( 1i*angle(cntr_data.upper_pseudo_cntr(mag_gt1_ndxs)) );
    end
  end
else
  if Domain == 1
    indent_pz = 1i*sort( abs(indent_pz) );
  else
    indent_pz = exp( 1i*sort( angle(indent_pz) ) );
  end
  finite_contour_ndxs = ...
    find( ~isnan( cntr_data.contour_angle ) ...
         & ~isinf( cntr_data.contour_freq) );
  if Domain == 1
    indent_freqs = sort( abs(indent_pz) );
    infinite_contour_ndxs = ...
      find( ~isnan( cntr_data.contour_angle ) ...
           & isinf( cntr_data.contour_freq) );
    jw_axis = zeros( infinite_contour_ndxs(1)-1, 1 );
  else
    indent_freqs = sort( abs( log(indent_pz)/PZG(2).Ts ) );
    infinite_contour_ndxs = [];
    jw_axis = zeros( finite_contour_ndxs(end), 1 );
  end

  nr_indents = numel(indent_pz);
  if any( indent_pz == 0 )
    nr_indents = nr_indents - 1;
  end
  max_w = 20 + 4 * nr_indents;

  gap_start_ndxs = 1 + ...
    find( finite_contour_ndxs(2:end) ...
           ~= ( finite_contour_ndxs(1:end-1) + 1 ) );
  if finite_contour_ndxs(1) == 1
    gap_start_ndxs = [ 1; gap_start_ndxs ];
  end
  contour_start_ndxs = finite_contour_ndxs(gap_start_ndxs);

  offset_ndx = 1;
  if Domain == 1
    if ~any( abs(indent_pz) < 1e-9 )
      offset_ndx = 0;
    end
  else
    if ~any( abs( indent_pz - 1 ) < 1e-9 )
      offset_ndx = 0;
    end
  end

  cntr_data.ld_pseudo_pole_freqs = zeros(size(cntr_data.ld_poles));
  cntr_data.ld_pseudo_zero_freqs = zeros(size(cntr_data.ld_zeros));
  ndx2 = 0;
  ndx2_prev = 0;
  centerfreq_prev = -1;
  for k = 1:numel(indent_pz)
    centerfreq = 4*(k-offset_ndx);
    if Domain == 1
      nyq_centerfreq = imag( indent_pz(k) );
    else
      nyq_centerfreq = imag( log(indent_pz(k))/PZG(2).Ts );
    end
    contour_ndxs = ...
      find( ( abs( cntr_data.contour_freq - nyq_centerfreq ) < 3e-11 ) ...
           &( ~isnan(cntr_data.contour_angle) ) );
    contourpad_ndxs = ...
      find( ( abs( cntr_data.contour_freq - nyq_centerfreq ) < 3e-11 ) ...
           & isnan(cntr_data.contour_angle) );
    if nyq_centerfreq == 0
      nr_lowerpad = 0;
      nr_upperpad = numel(contourpad_ndxs);
      ndx1 = contour_ndxs(1);
      ndx2 = ndx1 - 1 + numel(contourpad_ndxs) + numel(contour_ndxs);
    else
      gap_ndx = find( diff(contourpad_ndxs) > 1 );
      if isempty(gap_ndx)
        if isempty(contourpad_ndxs)
          nr_lowerpad = 0;
          nr_upperpad = 0;
        else
          if contourpad_ndxs(1) < contour_ndxs(1)
            nr_lowerpad = numel(contourpad_ndxs);
            nr_upperpad = 0;
          else
            nr_lowerpad = 0;
            nr_upperpad = numel(contourpad_ndxs);
          end
        end
      else
        nr_lowerpad = gap_ndx;
        nr_upperpad = numel(contourpad_ndxs) - gap_ndx;
        ndx1 = min( contourpad_ndxs(1), contour_ndxs(1) );
        ndx2 = ndx1 - 1 + numel(contourpad_ndxs) + numel(contour_ndxs);
      end
    end
    if abs(centerfreq) < 1e-10
      % Determine how many points are on the contour, itself.
      this_contour = exp( 1i*linspace( 0, pi/2, numel(contour_ndxs) )' );
      this_contour = ...
        [ this_contour; ...
          this_contour(end)*ones(nr_upperpad,1) ];     %#ok<AGROW>
      ndx1 = 1;
      ndx2 = numel(this_contour);
    elseif ( Domain == 2 ) ...
         &&( abs( indent_freqs(k) - pi/PZG(2).Ts ) < 1e-6 )
      % This can only happen at the highest-freq (Nyq freq) D-T pole or zero.
      if ( numel(indent_freqs) > 1 ) && ( indent_freqs(end-1) > 0 )
        multiplier = min( 3, indent_freqs(end) / indent_freqs(end-1) );
        centerfreq = multiplier * centerfreq;
      end
      if Domain == 2
        this_contour = ...
          1i*(max_w-1) ...
          + exp( 1i*linspace( -pi/2, 0, numel(contour_ndxs) )' );
        centerfreq = max_w - 1;
      else
        this_contour = ...
          1i*centerfreq ...
          + exp( 1i*linspace( -pi/2, 0, numel(contour_ndxs) )' );
      end
      this_contour = ...
        [ this_contour(1)*ones(nr_lowerpad,1); this_contour ];    %#ok<AGROW>
      ndx2 = numel(jw_axis);
      ndx1 = ndx2 + 1 - numel(this_contour);
    else
      this_contour = ...
        1i*centerfreq + exp( 1i*linspace( -pi/2, pi/2, numel(contour_ndxs) )');
      this_contour = ...
        [ this_contour(1)*ones(nr_lowerpad,1); ...
          this_contour; ...
          this_contour(end)*ones(nr_upperpad,1) ];     %#ok<AGROW>
    end
    if ~isempty(ndx1) && ~isempty(ndx2) && ( ndx2 > ndx1 )
      jw_axis(ndx1:ndx2) = this_contour;
    end
    % Put in values between the contours.
    if ndx1 > 1
      jw_ndx1 = max( 1, ndx2_prev );
      jw_ndx2 = ndx1 - 1;
      jw_nr_pts = jw_ndx2 - jw_ndx1 + 1;
      jw_axis(jw_ndx1:jw_ndx2) = ...
        1i*linspace( abs(jw_axis(jw_ndx1)), abs(jw_axis(ndx1)), jw_nr_pts )';
      
      if Domain == 1
        actual_pts = cntr_data.contour_pts(jw_ndx1:jw_ndx2);
      else
        actual_pts = ...
          log( cntr_data.contour_pts(jw_ndx1:jw_ndx2) ) / PZG(2).Ts;
      end
      shift0_pts = actual_pts - actual_pts(1);
      scale_factor = ( abs(jw_axis(ndx1)) ) - ( abs(jw_axis(jw_ndx1)) );
      shift0_pts = shift0_pts / abs(shift0_pts(end)) * scale_factor;
      alt_pts = shift0_pts + 1i*abs(jw_axis(jw_ndx1));
      jw_axis(jw_ndx1:jw_ndx2) = alt_pts;
    end

    p_ndx = find( abs( indent_pz(k) - cntr_data.ld_poles ) < 1e-12 );
    if ~isempty(p_ndx)
        cntr_data.ld_pseudo_pole_freqs(p_ndx) = centerfreq;
    else
      z_ndx = find( abs( indent_pz(k) - cntr_data.ld_zeros ) < 1e-12 );
      if ~isempty(z_ndx)
        cntr_data.ld_pseudo_zero_freqs(z_ndx) = centerfreq;
      end
    end

    ndx2_prev = ndx2;
    centerfreq_prev = centerfreq;
  end

  if ( ndx2 > 0 ) && ( ndx2 < numel(jw_axis) )
    jw_ndx1 = ndx2_prev + 1;
    jw_ndx2 = numel(jw_axis);
    jw_nr_pts = jw_ndx2 - jw_ndx1 + 1;
    jw_axis(jw_ndx1:jw_ndx2) = ...
      1i*linspace( centerfreq_prev+1, max_w, jw_nr_pts )';
  end
  if max(abs(jw_axis)) == 0
    jw_axis = 1i*linspace( 0, max_w, numel(jw_axis) )';
  end
  if Domain == 1
    rhp_contour = ...
      max_w ...
      * exp( 1i * linspace( pi/2, 0, numel(infinite_contour_ndxs) )' );
    cntr_data.upper_pseudo_cntr = [ jw_axis; rhp_contour ];
  else
    if max( abs(jw_axis) ) > 1-1e-7
      % If the last points are not part of an indent, spread out the
      % last frequency range over non-contour points.
      if ( contour_start_ndxs(end) < numel(jw_axis) ) ...
        &&( max( real(jw_axis(contour_start_ndxs(end):end)) ) < 1e-12 ) ...
        && all( isreal(cntr_data.contour_angle(contour_start_ndxs(end):end)) )
        ndx1 = contour_start_ndxs(end);
        ndx2 = numel(jw_axis);
        ndx0 = max( find( real(jw_axis(1:ndx1)) ~= 0 ) );       %#ok<MXFND>
        lo_freq = imag(jw_axis(ndx0));
        hi_freq = imag(jw_axis(end));
        jw_axis(ndx0:ndx1) = 1i*linspace( lo_freq, hi_freq, ndx1-ndx0+1 )';
        jw_axis(ndx1+1:ndx2) = 1i*hi_freq * ones(ndx2-ndx1,1);
      end
      hi_freq = imag(jw_axis(end));
      jw_axis = pi * jw_axis / hi_freq;
      cntr_data.upper_pseudo_cntr = exp( jw_axis );
      cntr_data.ld_pseudo_pole_freqs = ...
        cntr_data.ld_pseudo_pole_freqs / hi_freq * pi;
      cntr_data.ld_pseudo_zero_freqs = ...
        cntr_data.ld_pseudo_zero_freqs / hi_freq * pi;
    else
      % No poles or zeros on the unit circle.
      cntr_data.upper_pseudo_cntr = cntr_data.contour_pts;
    end
  end
end

if ishandle(wb_h)
  delete( wb_h )
  drawnow
  pause(0.01)
end

if Domain == 1
  scale_factor = 24/max(abs(cntr_data.upper_pseudo_cntr));
  cntr_data.upper_pseudo_cntr = scale_factor * cntr_data.upper_pseudo_cntr;
  if ~isempty(cntr_data.ld_pseudo_pole_freqs)
    cntr_data.ld_pseudo_pole_freqs = ...
      scale_factor * cntr_data.ld_pseudo_pole_freqs;
  end
  if ~isempty(cntr_data.ld_pseudo_zero_freqs)
    cntr_data.ld_pseudo_zero_freqs = ...
      scale_factor * cntr_data.ld_pseudo_zero_freqs;
  end
end

% contour_nan_ndxs = find( isnan(cntr_data.contour_mapping) );
% if ~isempty(contour_nan_ndxs)
%   cntr_data.contour_pts(contour_nan_ndxs) = NaN;
%   cntr_data.upper_pseudo_cntr(contour_nan_ndxs) = NaN;
% end

PZG(Domain).cntr_data = cntr_data;

% ------------------------------------------------------------

% Make sure that Nichols phase data agrees with contour data.
if Domain == 1
  nic_freqs = PZG(1).BodeFreqs;
else
  nyq_ndx = pzg_gle( PZG(2).BodeFreqs, pi/PZG(2).Ts,'<');
  nic_freqs = PZG(2).BodeFreqs(1:nyq_ndx);
end
flag1_ndxs = find( PZG(Domain).cntr_data.contour_flag == 1 );
flag1_freqs = PZG(Domain).cntr_data.contour_freq(flag1_ndxs);
[ common_freqs, ndxA, sub_bode_ndxs ] = ...
    intersect( flag1_freqs, nic_freqs );
if ~isempty(ndxA)
  sub_nyq_ndxs = flag1_ndxs( ndxA );
  this_bode_phs = PZG(Domain).BodePhs(sub_bode_ndxs);
  tooneg_ndxs = ...
    find( this_bode_phs(:) ...
         < ( PZG(Domain).cntr_data.Nichols_phs(sub_nyq_ndxs) - 270 ) );
  while ~isempty(tooneg_ndxs)
    PZG(Domain).BodePhs(sub_bode_ndxs(tooneg_ndxs)) = ...
      PZG(Domain).BodePhs(sub_bode_ndxs(tooneg_ndxs)) + 360;
    this_bode_phs = PZG(Domain).BodePhs(sub_bode_ndxs);
    tooneg_ndxs = ...
      find( this_bode_phs(:) ...
           < ( PZG(Domain).cntr_data.Nichols_phs(sub_nyq_ndxs) - 270 ) );
  end
  this_bode_phs = PZG(Domain).BodePhs(sub_bode_ndxs);
  toopos_ndxs = ...
    find( this_bode_phs(:) ...
         > ( PZG(Domain).cntr_data.Nichols_phs(sub_nyq_ndxs) + 270 ) );
  while ~isempty(toopos_ndxs)
    PZG(Domain).BodePhs(sub_bode_ndxs(toopos_ndxs)) = ...
      PZG(Domain).BodePhs(sub_bode_ndxs(toopos_ndxs)) - 360;
    this_bode_phs = PZG(Domain).BodePhs(sub_bode_ndxs);
    toopos_ndxs = ...
      find( this_bode_phs(:) ...
           > ( PZG(Domain).cntr_data.Nichols_phs(sub_nyq_ndxs) + 270 ) );
  end
  for kwhk = 1:3
    whacky_ndxs = 1 + ...
      find( ( abs( PZG(Domain).BodePhs(2:end-1) ...
                  -PZG(Domain).BodePhs(1:end-2) ) > 150 ) ...
           &( abs( PZG(Domain).BodePhs(2:end-1) ...
                  -PZG(Domain).BodePhs(3:end) ) > 150 ) ...
           &( abs( PZG(Domain).BodePhs(1:end-2) ...
                  -PZG(Domain).BodePhs(3:end) ) < 90 ) );
    if ~isempty(whacky_ndxs)
      PZG(Domain).BodePhs(whacky_ndxs) = ...
        ( PZG(Domain).BodePhs(whacky_ndxs+1) ...
         +PZG(Domain).BodePhs(whacky_ndxs-1) )/2;
    end
  end
end

if ~any( PZG(Domain).cntr_data.contour_flag(1:2) == 1 ) ...
  && PZG(Domain).cntr_data.Nichols_phs(1) ~= 0
  PZG(Domain).cntr_data.Nichols_phs(1) = 0;
end

local_adjust_dt_bodephs;

PZG(Domain).cntr_data = cntr_data;

if ~isempty(init_sel_freq)
  PZG(Domain).FrqSelNdx = ...
    pzg_gle( PZG(Domain).BodeFreqs, init_sel_freq,'near');
  if PZG(Domain).pzg_show_frf_computation
    updtpzln(Domain)
    pzg_seltxt(Domain)
    if ( Domain == 1 ) ...
      && isfield( PZG,'frcomp_fig') && ~isempty(PZG(1).frcomp_fig) ...
      && isequal( 1, ishandle(PZG(1).frcomp_fig) )
      fr_disp;
    end
  end
end

return


function  bodeFR = local_refresh_freqs_pz(dom_ndx)
  
global PZG
  
if dom_ndx == 1
  % CONTINUOUS-TIME
  if ~PZG(1).PureDelay
    PZG(1).pade.N = 1;
    PZG(1).pade.D = 1;
    PZG(1).pade.Z = [];
    PZG(1).pade.P = [];
    PZG(1).pade.K = 1;
  else
    [ PZG(1).pade.N, PZG(1).pade.D ] = pade( PZG(1).PureDelay, 4 );
    PZG(1).pade.Z = roots(PZG(1).pade.N);
    PZG(1).pade.P = roots(PZG(1).pade.D);
    PZG(1).pade.K = 1;
  end
  
  % Update closed-loop poles
  modalss = pzg_moda( 1, 1, 1, 0,'', 1 );
  if ~isempty(modalss)
    PZG(1).CLPoleLocs = ...
      tzero( modalss.a, modalss.b, modalss.c, modalss.d+1 );
    PZG(1).Dc = [];
  else
    PZG(1).N = [];
    PZG(1).D = [];
    PZG(1).Dc = [];
    PZG(1).CLPoleLocs = [];
  end
  PZG(1).CLZeroLocs = [ PZG(1).ZeroLocs; PZG(1).pade.Z ];
  PZG(1).CLGain = PZG(1).Gain;
  
  min_PZ_freq = 1;
  max_PZ_freq = 1;
  if ~isempty(PZG(1).PoleLocs)
    nonzeroP = PZG(1).PoleLocs( PZG(1).PoleLocs ~= 0 );
    if ~isempty(nonzeroP)
      min_PZ_freq = min(abs(nonzeroP));
      max_PZ_freq = max(abs(nonzeroP));
    end
    if ~isempty(PZG(1).ZeroLocs)
      nonzeroZ = PZG(1).ZeroLocs( PZG(1).ZeroLocs ~= 0 );
      if ~isempty(nonzeroZ)
        min_PZ_freq = min( min_PZ_freq, min(abs(nonzeroZ)) );
        max_PZ_freq = max( max_PZ_freq, max(abs(nonzeroZ)) );
      end
    end
  end
  min_PZ_freq = 10^( floor( log10(min_PZ_freq/300+1e-10) ) );
  max_PZ_freq = 10^( ceil( log10( max_PZ_freq*300) ) );

  if ~isempty(PZG(1).TFEFreqs)
    PZG(1).BodeFreqs = PZG(1).TFEFreqs(:);
  else
    nr_decades = ceil( log10(max_PZ_freq) - log10(min_PZ_freq) );
    nr_pts = max( 3000, 500*nr_decades );
    PZG(1).BodeFreqs = ...
      logspace( log10(min_PZ_freq), log10(max_PZ_freq), nr_pts );
    % Extra points in the region of very lightly-damped poles and zeros.
    ld_ndxs = ...
      find( ( imag(PZG(1).PoleLocs) ...
             ./max(1e-10,abs(real(PZG(1).PoleLocs))) > 5 ) ...
           |( abs(PZG(1).PoleLocs) < 1e-12 ) );
    ld_pzs = PZG(1).PoleLocs(ld_ndxs);
    ld_freqs = imag(PZG(1).PoleLocs(ld_ndxs));
    ld_ndxs = ...
      find( ( imag(PZG(1).CLPoleLocs) ...
             ./max(1e-10,abs(real(PZG(1).CLPoleLocs))) > 5 ) ...
           |( abs(PZG(1).CLPoleLocs) < 1e-12 ) );
    ld_pzs = [ ld_pzs; PZG(1).CLPoleLocs(ld_ndxs) ];
    ld_freqs = [ ld_freqs; imag(PZG(1).CLPoleLocs(ld_ndxs)) ];
    ld_ndxs = ...
      find( ( imag(PZG(1).ZeroLocs) ...
             ./max(1e-10,abs(real(PZG(1).ZeroLocs))) > 5 ) ...
           |( abs(PZG(1).ZeroLocs) < 1e-12 ) );
    ld_pzs = [ ld_pzs; PZG(1).ZeroLocs(ld_ndxs) ];
    ld_freqs = [ld_freqs; imag(PZG(1).ZeroLocs(ld_ndxs))];
    if numel(ld_freqs) > 1
      [ ld_freqs, sortndx ] = sort( ld_freqs );
      ld_pzs = ld_pzs(sortndx);
      for k = numel(ld_freqs):-1:2
        if min( abs( ld_freqs(k) - ld_freqs(1:k-1) )) ...
               /max(1,abs(ld_freqs(k))) < 1e-8
          ld_freqs(k) = [];
          ld_pzs(k) = [];
        end
      end
    end
    for k = 1:numel(ld_freqs)
      ld_xtrafreqs = ...
        pzg_xtrfrq( 1, ld_pzs(k), [ min_PZ_freq max_PZ_freq ] );
      PZG(1).BodeFreqs = [ PZG(1).BodeFreqs, ld_xtrafreqs ];
    end
    PZG(1).BodeFreqs = unique( PZG(1).BodeFreqs );
    while numel(PZG(1).BodeFreqs) > 20000
     PZG(1).BodeFreqs = PZG(1).BodeFreqs(1:2:end);
    end
  end
  
  PZG(1).BodeMag = [];
  PZG(1).BodePhs = [];
  PZG(1).CLBodeFreqs = PZG(1).BodeFreqs;
  PZG(1).CLBodeMag = [];
  PZG(1).CLBodePhs = [];

  wb_h = -1;
  if numel(PZG(1).PoleLocs) > 50
    wb_h = waitbar( 0.01,'Computing C-T Frequency Response ...', ...
                    'name','FRF Computation Progress');
  end
    
  bodeFR = log(PZG(1).Gain)*ones(size(PZG(1).BodeFreqs));
  jwaxis_pts = 1i*PZG(1).BodeFreqs;
  for Fk = 1:numel(PZG(1).PoleLocs)
    bodeFR = bodeFR - log( jwaxis_pts - PZG(1).PoleLocs(Fk) );
    if numel(PZG(1).ZeroLocs) >= Fk
      bodeFR = bodeFR + log( jwaxis_pts - PZG(1).ZeroLocs(Fk) );
    end
    if ~mod( Fk, 10 )
      if isequal( 1, ishandle(wb_h) )
        waitbar( 0.95*Fk/numel(PZG(1).PoleLocs), wb_h )
      end
    end
  end 
  bodeFR = exp(bodeFR);
  
  if isfield( PZG(dom_ndx),'cntr_data')
    if ~isfield( PZG(dom_ndx).cntr_data,'bode_nan_ndxs')
      PZG(dom_ndx).cntr_data.bode_nan_ndxs = [];
    end
    if ~isempty(PZG(dom_ndx).cntr_data.bode_nan_ndxs)
      bodeFR(PZG(dom_ndx).cntr_data.bode_nan_ndxs) = NaN;
    end
  end
  
  bode_inf_ndxs = find( isinf(bodeFR) );
  if ~isempty(bode_inf_ndxs)
    bodeFR(bode_inf_ndxs) = NaN;
    PZG(dom_ndx).cntr_data.bode_nan_ndxs = ...
      [ PZG(dom_ndx).cntr_data.bode_nan_ndxs; bode_inf_ndxs(:) ];
  end
  max_mag = max(abs(bodeFR));
  bode_zero_ndxs = find( abs(bodeFR) < max_mag*eps  );
  
  if ~isempty(bode_zero_ndxs)
    bodeFR(bode_zero_ndxs) = NaN;
    PZG(dom_ndx).cntr_data.bode_nan_ndxs = ...
      [ PZG(dom_ndx).cntr_data.bode_nan_ndxs; bode_zero_ndxs(:) ];
  end

  if isequal( 1, ishandle(wb_h) )
    delete( wb_h )
    drawnow
    pause(0.01)
  end

  bodeFR_angle = angle(bodeFR);
  real_roundoff = ...
    find( ( abs(bodeFR_angle) < 1e-12 ) ...
         |( abs( abs(bodeFR_angle)-pi ) < 1e-12 ) );
  if ~isempty(real_roundoff)
    bodeFR(real_roundoff) = real( bodeFR(real_roundoff) );
  end
  
  PZG(1).BodeMag = 20*log10( abs( bodeFR ) );
  % PZG(1).BodePhs = ...
  %   pzg_unwrap( PZG(1).BodeFreqs, 180/pi*angle(bodeFR), 1,'open');
  unwrapped_phase_wo_delay = ...
    pzg_unwrap( PZG(1).BodeFreqs, 180/pi*angle(bodeFR), 1,'open');
  if PZG(1).PureDelay > 0
    bodeFR = bodeFR .* exp(-1i*PZG(1).BodeFreqs*PZG(1).PureDelay);
    PZG(1).BodePhs = ...
      unwrapped_phase_wo_delay ...
      - (180/pi)*PZG(1).BodeFreqs*PZG(1).PureDelay;
  else
    PZG(1).BodePhs = unwrapped_phase_wo_delay;
  end
  

  % If poles and/or zeros are on the jW-axis,
  % set nearests FRF data to NaN's, to create plot gaps.
  if ~isempty(PZG(1).PoleLocs)
    ldpole_ndx = ...
      find( ( abs( real(PZG(1).PoleLocs) ) < 1e-10 ) ...
           &( imag(PZG(1).PoleLocs) > 0 ) );
    for kld = 1:numel(ldpole_ndx)
      bdy_freq = imag( PZG(1).PoleLocs(ldpole_ndx(kld)) );
      [ temp, bdyfreq_ndx ] = min( abs( PZG(1).BodeFreqs - bdy_freq ) );
      PZG(1).BodeMag(bdyfreq_ndx) = NaN;
    end
  end
  if ~isempty(PZG(1).ZeroLocs)
    ldzero_ndx = ...
      find( ( abs( real(PZG(1).ZeroLocs) ) < 1e-10 ) ...
           &( imag(PZG(1).ZeroLocs) > 0 ) );
    for kld = 1:numel(ldzero_ndx)
      bdy_freq = imag( PZG(1).ZeroLocs(ldzero_ndx(kld)) );
      [ temp, bdyfreq_ndx ] = min( abs( PZG(1).BodeFreqs - bdy_freq ) );
      PZG(1).BodeMag(bdyfreq_ndx) = NaN;
    end
  end
  
  if sum( real(PZG(1).CLPoleLocs) > 0 ) ...
    ||sum( ( real(PZG(1).CLPoleLocs) == 0 ) ...
          &( imag(PZG(1).CLPoleLocs) ~= 0 ) )
    PZG(1).CLBodeFreqs = 1;
    PZG(1).CLBodeMag = 1;
    PZG(1).CLBodePhs = 0;
  else
     CLFreqResp = bodeFR ./ (1+bodeFR);
     PZG(1).CLBodeFreqs = PZG(1).BodeFreqs;
     PZG(1).CLBodeMag = 20 * log10( abs( CLFreqResp ) );
     PZG(1).CLBodePhs = ...
       pzg_unwrap( PZG(1).CLBodeFreqs, 180/pi*angle(CLFreqResp), 1,'closed');
  end
    
else
  % DISCRETE-TIME
  % Update the closed-loop poles
  modalss = pzg_moda( 2, 1, 1, 0,'', 1 );
  if ~isempty(modalss)
    PZG(2).CLPoleLocs = ...
      tzero( modalss.a, modalss.b, modalss.c, modalss.d+1 );
    PZG(2).Dc = [];
  else
    PZG(2).N = [];
    PZG(2).D = [];
    PZG(2).Dc = [];
    PZG(2).CLPoleLocs = [];
  end
  PZG(2).CLZeroLocs = PZG(2).ZeroLocs;
  PZG(2).CLGain = PZG(2).Gain;
  
  splane_p = [];
  splane_z = [];
  max_PZ_freq = pi/PZG(2).Ts * 0.99999;
  min_PZ_freq = max_PZ_freq/1e4;
  if ~isempty(PZG(2).PoleLocs)
    splane_p = log( PZG(2).PoleLocs ) / PZG(2).Ts;
    nonzeroP = splane_p( splane_p ~= 0 );
    if ~isempty(nonzeroP)
      min_PZ_freq = min(abs(nonzeroP));
    end
    if ~isempty(PZG(2).ZeroLocs)
      splane_z = log( PZG(2).ZeroLocs ) / PZG(2).Ts;
      bdy_z = find( abs(1-abs(PZG(2).ZeroLocs)) < 1e-11 );
      for kbdy = 1:numel(bdy_z)
        if abs(imag(splane_z(bdy_z(kbdy)))) < 1e-11
          splane_z(bdy_z(kbdy)) = 0;
        else
          splane_z(bdy_z(kbdy)) = 1i * imag( splane_z(bdy_z(kbdy)) );
        end
      end
      nonzeroZ = splane_z( splane_z ~= 0 );
      if ~isempty(nonzeroZ)
        min_PZ_freq = min( min_PZ_freq, min(abs(nonzeroZ)) );
      end
    end
    min_PZ_freq = 10^( floor( log10(min_PZ_freq/300+1e-10) ) );
  end
  min_PZ_freq = min( min_PZ_freq, max_PZ_freq*1e-4 );

  if ~isempty(PZG(2).TFEFreqs)
    PZG(2).BodeFreqs = PZG(2).TFEFreqs(:);
  else
    nr_decades = ceil( log10(max_PZ_freq) - log10(min_PZ_freq) );
    nr_pts = max( 3000, 500*nr_decades );
    PZG(2).BodeFreqs = ...
      logspace( log10(min_PZ_freq), log10(max_PZ_freq), nr_pts );
    % Extra points in the region of very lightly-damped poles and zeros.
    cl_splane_p = log( PZG(2).CLPoleLocs ) / PZG(2).Ts;
    
    ld_ndxs = ...
      find( imag(splane_p) ...
           ./max(1e-10,abs(real(splane_p))) > 5 );
    ld_pzs = splane_p(ld_ndxs);
    ld_freqs = imag(splane_p(ld_ndxs));
    ld_ndxs = ...
      find( imag(cl_splane_p) ...
           ./max(1e-10,abs(real(cl_splane_p))) > 5 );
    ld_pzs = [ ld_pzs; cl_splane_p(ld_ndxs) ];
    ld_freqs = [ ld_freqs; imag(cl_splane_p(ld_ndxs)) ];
    if ~isempty(splane_z)
      ld_ndxs = ...
        find( imag(splane_z) ...
             ./max(1e-10,abs(real(splane_z))) > 5 );
      ld_pzs = [ ld_pzs; splane_z(ld_ndxs) ];
      ld_freqs = [ ld_freqs; imag(splane_z(ld_ndxs)) ];
    end
    for k = numel(ld_freqs):-1:2
      if min( abs( ld_freqs(k) - ld_freqs(1:k-1) )) ...
             /max(1,abs(ld_freqs(k))) < 0.01
        ld_freqs(k) = [];
        ld_pzs(k) = [];
      end
    end
    for k = 1:numel(ld_freqs)
      ld_xtrafreqs = ...
        pzg_xtrfrq( 1, ld_pzs(k), [ PZG(2).BodeFreqs(1), max_PZ_freq ] );
      PZG(2).BodeFreqs = [ PZG(2).BodeFreqs, ld_xtrafreqs ];
    end
    if any( diff(PZG(2).BodeFreqs) <= 0 )
      PZG(2).BodeFreqs = unique( PZG(2).BodeFreqs(:) );
    end
    while numel(PZG(2).BodeFreqs) > 30000
      PZG(2).BodeFreqs = PZG(2).BodeFreqs(1:2:end);
    end
  end
    
  wb_h = [];
  if numel(PZG(2).PoleLocs) > 50
    wb_h = waitbar( 0.01,'Computing D-T Frequency Response ...', ...
                    'name','FRF Computation Progress');
  end

  uc_pts = exp(1i*PZG(2).BodeFreqs*PZG(2).Ts);
  bodeFR = zeros(size(uc_pts)) + log(PZG(2).Gain);
  for Fk = 1:numel(PZG(2).PoleLocs)
    bodeFR = bodeFR -log( uc_pts - PZG(2).PoleLocs(Fk) );
    if numel(PZG(2).ZeroLocs) >= Fk
      bodeFR = bodeFR + log( uc_pts - PZG(2).ZeroLocs(Fk) );
    end
    if ~mod( Fk, 10 )
      if isequal( 1, ishandle(wb_h) )
        waitbar( 0.95*Fk/numel(PZG(2).PoleLocs), wb_h )
      end
    end
  end
  bodeFR = exp(bodeFR(:));
  
  if isfield( PZG(dom_ndx),'cntr_data') ...
    && isfield( PZG(dom_ndx).cntr_data,'bode_nan_ndxs') ...
    && ~isempty(PZG(dom_ndx).cntr_data.bode_nan_ndxs)
    bodeFR(PZG(dom_ndx).cntr_data.bode_nan_ndxs) = NaN;
  else
    PZG(dom_ndx).cntr_data.bode_nan_ndxs = [];
  end
  bode_inf_ndxs = find( isinf(bodeFR) );
  if ~isempty(bode_inf_ndxs)
    bodeFR(bode_inf_ndxs) = NaN;
    PZG(dom_ndx).cntr_data.bode_nan_ndxs = ...
      [ PZG(dom_ndx).cntr_data.bode_nan_ndxs; bode_inf_ndxs(:) ];
  end
  max_mag = max(abs(bodeFR));
  bode_zero_ndxs = find( abs(bodeFR) < max_mag*eps  );
  if ~isempty(bode_zero_ndxs)
    bodeFR(bode_zero_ndxs) = NaN;
    PZG(dom_ndx).cntr_data.bode_nan_ndxs = ...
      [ PZG(dom_ndx).cntr_data.bode_nan_ndxs; bode_zero_ndxs(:) ];
  end
  
  if isequal( 1, ishandle(wb_h) )
    delete( wb_h )
    drawnow
    pause(0.01)
  end

  if PZG(2).PureDelay > 0
    bodeFR = ...
      bodeFR .* exp( -1i*PZG(2).BodeFreqs * PZG(2).PureDelay*PZG(2).Ts );
  end
  bodeFR_angle = angle(bodeFR);
  real_roundoff = ...
    find( ( abs(bodeFR_angle) < 1e-8 ) ...
         |( abs( abs(bodeFR_angle)-pi ) < 1e-8 ) );
  if ~isempty(real_roundoff)
    bodeFR(real_roundoff) = real( bodeFR(real_roundoff) );
  end
  
  if size(PZG(2).BodeFreqs,1) ~= 1
    PZG(2).BodeFreqs = PZG(2).BodeFreqs';
  end

  if size(bodeFR,1) ~= 1
    bodeFR = bodeFR.';
  end
  PZG(2).BodeMag = 20*log10( abs( bodeFR ) );
  PZG(2).BodePhs = ...
    pzg_unwrap( PZG(2).BodeFreqs, 180/pi*angle(bodeFR), 2,'open');

  % If poles and/or zeros are on the unit-circle,
  % set nearest FRF data to NaN's, to create plot gaps.
  if ~isempty(PZG(2).PoleLocs)
    ldpole_ndx = ...
      find( ( abs( abs(PZG(2).PoleLocs) - 1 ) < 1e-10 ) ...
           &( imag(PZG(2).PoleLocs) > 0 ) );
    for kld = 1:numel(ldpole_ndx)
      bdy_freq = angle( PZG(2).PoleLocs(ldpole_ndx(kld)) )/PZG(2).Ts;
      [ temp, bdyfreq_ndx ] = min( abs( PZG(2).BodeFreqs - bdy_freq ) );
      PZG(2).BodeMag(bdyfreq_ndx) = NaN;
    end
  end
  if ~isempty(PZG(2).ZeroLocs)
    ldzero_ndx = ...
      find( ( abs( abs(PZG(2).ZeroLocs) - 1 ) < 1e-10 ) ...
           &( imag(PZG(2).ZeroLocs) > 0 ) );
    for kld = 1:numel(ldzero_ndx)
      bdy_freq = angle( PZG(2).ZeroLocs(ldzero_ndx(kld)) )/PZG(2).Ts;
      [ temp, bdyfreq_ndx ] = min( abs( PZG(2).BodeFreqs - bdy_freq ) );
      PZG(2).BodeMag(bdyfreq_ndx) = NaN;
    end
  end
  
  PZG(2).BodeMag = ...
    [ PZG(2).BodeMag, fliplr(PZG(2).BodeMag), ...
      PZG(2).BodeMag, fliplr(PZG(2).BodeMag) ];
  PZG(2).BodePhs = ...
    [ PZG(2).BodePhs, -fliplr(PZG(2).BodePhs), ...
      PZG(2).BodePhs, -fliplr(PZG(2).BodePhs) ];
  PZG(2).BodeFreqs = ...
   [ PZG(2).BodeFreqs, ...
     2*pi/PZG(2).Ts-fliplr(PZG(2).BodeFreqs), ...
     2*pi/PZG(2).Ts+PZG(2).BodeFreqs, ...
     4*pi/PZG(2).Ts-fliplr(PZG(2).BodeFreqs) ];

  if sum( abs(PZG(2).CLPoleLocs) > 1 ) ...
    ||sum( ( abs(PZG(2).CLPoleLocs) == 1 ) ...
          &( real(PZG(2).CLPoleLocs) ~= 1 ) )
    PZG(2).CLBodeFreqs = 1;
    PZG(2).CLBodeMag = 1;
    PZG(2).CLBodePhs = 0;
  else
    PZG(2).CLBodeFreqs = PZG(2).BodeFreqs;
    CLFreqResp = bodeFR ./ (1+bodeFR);
    if size(CLFreqResp,1) ~= 1
      CLFreqResp = CLFreqResp.';
    end
    PZG(2).CLBodeMag = 20 * log10( abs( CLFreqResp ) );
    PZG(2).CLBodePhs = ...
      pzg_unwrap( PZG(2).BodeFreqs(1:numel(CLFreqResp)), ...
                  180/pi*angle(CLFreqResp), 2,'closed');
    tempP = 180/pi*( angle(bodeFR(1)) - angle(1+bodeFR(1)) ) ...
            - PZG(2).CLBodePhs(1);
    PZG(2).CLBodePhs = PZG(2).CLBodePhs + tempP;
    PZG(2).CLBodeMag = ...
      [ PZG(2).CLBodeMag, fliplr(PZG(2).CLBodeMag), ...
        PZG(2).CLBodeMag, fliplr(PZG(2).CLBodeMag) ];
    PZG(2).CLBodePhs = ...
      [ PZG(2).CLBodePhs, -fliplr(PZG(2).CLBodePhs), ...
        PZG(2).CLBodePhs, -fliplr(PZG(2).CLBodePhs) ];
  end
end
  
return


function  local_adjust_dt_bodephs
  global PZG
  % For discrete-time,
  % make sure frequencies are set up [ f Fs-flip(f) Fs+f 2Fs-flip(f) ]
  nyq_ndx = pzg_gle( PZG(2).BodeFreqs, pi/PZG(2).Ts,'<');
  if isequal( numel(PZG(2).BodeFreqs), 4*nyq_ndx )
    fs_ndx = 2*nyq_ndx;
    if size( PZG(2).BodePhs, 1 ) == 1
      PZG(2).BodePhs(nyq_ndx+1:fs_ndx) = ...
        -fliplr( PZG(2).BodePhs(1:nyq_ndx) );
      PZG(2).BodePhs(fs_ndx+1:fs_ndx+nyq_ndx) = ...
        PZG(2).BodePhs(1:nyq_ndx);
      PZG(2).BodePhs(fs_ndx+nyq_ndx+1:2*fs_ndx) = ...
        -fliplr( PZG(2).BodePhs(1:nyq_ndx) );
    else
      PZG(2).BodePhs(nyq_ndx+1:fs_ndx) = ...
        -flipud( PZG(2).BodePhs(1:nyq_ndx) );
      PZG(2).BodePhs(fs_ndx+1:fs_ndx+nyq_ndx) = ...
        PZG(2).BodePhs(1:nyq_ndx);
      PZG(2).BodePhs(fs_ndx+nyq_ndx+1:2*fs_ndx) = ...
        -flipud( PZG(2).BodePhs(1:nyq_ndx) );
    end
  end
  
  nyq_ndx = pzg_gle( PZG(2).CLBodeFreqs, pi/PZG(2).Ts,'<');
  if isequal( numel(PZG(2).CLBodeFreqs), 4*nyq_ndx ) ...
    && isequal( numel(PZG(2).CLBodePhs), 4*nyq_ndx )
    fs_ndx = 2*nyq_ndx;
    if size( PZG(2).CLBodePhs, 1 ) == 1
      PZG(2).CLBodePhs(nyq_ndx+1:fs_ndx) = ...
        -fliplr( PZG(2).CLBodePhs(1:nyq_ndx) );
      PZG(2).CLBodePhs(fs_ndx+1:fs_ndx+nyq_ndx) = ...
        PZG(2).CLBodePhs(1:nyq_ndx);
      PZG(2).CLBodePhs(fs_ndx+nyq_ndx+1:2*fs_ndx) = ...
        -fliplr( PZG(2).CLBodePhs(1:nyq_ndx) );
    else
      PZG(2).CLBodePhs(nyq_ndx+1:fs_ndx) = ...
        -flipud( PZG(2).CLBodePhs(1:nyq_ndx) );
      PZG(2).CLBodePhs(fs_ndx+1:fs_ndx+nyq_ndx) = ...
        PZG(2).CLBodePhs(1:nyq_ndx);
      PZG(2).CLBodePhs(fs_ndx+nyq_ndx+1:2*fs_ndx) = ...
        -flipud( PZG(2).CLBodePhs(1:nyq_ndx) );
    end
  end
return


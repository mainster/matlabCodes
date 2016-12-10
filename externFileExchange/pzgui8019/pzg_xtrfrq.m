function xtra_freqs = pzg_xtrfrq( dom_ndx, crit_pt, freq_range, nr_xtra_pts )

% Determines the appropriate extra frequencies to compute for the FRF, 
% based on how close the critical point is to the stability boundary.

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

xtra_freqs = [];
if ( nargin < 3 )
  return
elseif ~isequal( dom_ndx, 1 ) && ~isequal( dom_ndx, 2 )
  return
elseif ~isequal( 1, numel(crit_pt) ) || ~isnumeric(crit_pt)
  return
elseif ~isequal( 2, numel(freq_range) ) || ~isnumeric(freq_range)
  freq_range = sort( abs(freq_range(:)) )';
  if diff(freq_range) <= 1e-5
    return
  end
else
  crit_pt = crit_pt(:);
end
if ( nargin < 4 ) ...
  || ~isequal( 1, numel(nr_xtra_pts) ) ...
  || ~isnumeric(nr_xtra_pts)
  if real(crit_pt) == 0
    nr_xtra_pts = 200;
  else
    nr_xtra_pts = ...
      max( 20, min( 200, 2*round( abs(imag(crit_pt)/real(crit_pt))/2 ) ) );
  end
else
  nr_xtra_pts = nr_xtra_pts(:);
end
% Assign numbers of points to get tangentially (vs. logarithmically)
tan_proportion = 0.5;
nr_tan_pts = 2*ceil( tan_proportion*nr_xtra_pts / 2 );
nr_log_pts = nr_xtra_pts - nr_tan_pts;

if dom_ndx == 1
  s_crit_pt = crit_pt;
  s_freq = imag(crit_pt);
else
  s_crit_pt = log( crit_pt )/PZG(2).Ts;
  s_freq = angle(crit_pt)/PZG(2).Ts;
end
this_imag = abs( imag(s_crit_pt) );
this_real = abs( real(s_crit_pt) );

min_bode_freq = min( freq_range(1), abs( imag(s_crit_pt) )*0.96 );
max_bode_freq = max( freq_range(end), abs( imag(s_crit_pt) )*1.04 );
if ( this_imag/this_real < 10 ) && ( abs(s_freq) > min_bode_freq )
  % The critical point is not lightly-damped, i.e., > ~10% zeta.
  return
end

if abs(s_crit_pt) < min_bode_freq
  % Add low-frequency points.
  xtra_freqs = ...
    logspace( log10(min_bode_freq), log10(min_bode_freq)+2, nr_xtra_pts );
else
  % Limit the real part below, for reasonable tangent distribution.
  this_real = max( 1e-4, this_real );
  % Find the frequency (jW) points whose phase effect
  % varies from -pi/2 to pi/2 radians.
  ld_angles = logspace( log10(pi/3000), log10(pi/4), ceil( nr_tan_pts/2 ) );
  ld_angles = [ -fliplr(ld_angles), 0, ld_angles ];
  xtra_freqs = this_imag + this_real*tan(ld_angles);
  if xtra_freqs(end) > 1.04*this_imag
    % Compute all the extra points by tangent method.
    ld_angles = ...
      logspace( log10(pi/3000), log10(0.25*pi), ceil( nr_xtra_pts/2 ) );
    ld_angles = [ -fliplr(ld_angles), 0, ld_angles ];
    xtra_freqs = this_imag + this_real*tan(ld_angles);
  else
    % Fill in with log-spacing out to +/- 4% of the center frequency.
    more_freqs = ...
      logspace( log10( diff(xtra_freqs(1:2)) ), log10( 0.04*this_imag ), ...
                floor(nr_log_pts/2) );
    more_freqs = [ xtra_freqs(1)-more_freqs, xtra_freqs(end)+more_freqs ];
    xtra_freqs = [ xtra_freqs, more_freqs ];
  end
  if abs(real(s_crit_pt)) < 1e-10
    % Include the critical point,
    % if it is essentially right on the stability boundary.
    xtra_freqs = [ xtra_freqs, s_crit_pt ];
  end
  xtra_freqs = sort(xtra_freqs);
  xtra_freqs( ( xtra_freqs < 0.96*this_imag ) ...
             |( xtra_freqs > 1.04*this_imag ) ) = [];
end

xtra_freqs( ( xtra_freqs < min_bode_freq ) ...
           |( xtra_freqs > max_bode_freq ) ) = [];

crit_rep = abs( sum( abs( PZG(dom_ndx).PoleLocs - crit_pt ) < 1e-12 ) ...
               +sum( abs( PZG(dom_ndx).CLPoleLocs - crit_pt ) < 1e-12 ) ...
               -sum( abs( PZG(dom_ndx).ZeroLocs - crit_pt ) < 1e-12 ) );
crit_rep = max( 1, crit_rep );
log_lim = -5.5+rand;
if log10(abs(real(s_crit_pt))) < log_lim/sqrt(crit_rep)
  xtra_freqs( log10(abs( xtra_freqs-s_freq )) < log_lim/sqrt(crit_rep) ) = [];
end

xtra_freqs = sort(xtra_freqs);
xtra_freqs( ( xtra_freqs < freq_range(1) ) ...
           |( xtra_freqs > freq_range(2) ) ) = [];

return

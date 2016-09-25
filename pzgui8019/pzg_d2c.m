function [ ct_res, ct_poles, ct_direct, used_builtin ] = pzg_d2c( cnv_method )
% Converts the current dpzgui zero/pole/gain model from discrete-time to 
% continuous-time partial-fraction-expansion form, by the indicated method.
% Residues and poles use the same convention as Matlab's "residue" function.

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
ct_res = [];
ct_poles = [];
ct_direct = [];
used_builtin = 0;
if isempty(PZG) && ~pzg_recovr 
  return
end

wb_h = findobj( allchild(0),'name','D-T to C-T Conversion Progress');
for k = numel(wb_h):-1:1
  pause(0.1)
  if strcmp( get(wb_h(k),'visible'),'off')
    delete(wb_h(k))
    wb_h(k) = [];
  end
end
if ~isempty(wb_h)
  disp( ...
    'pzg_d2c:  Apparently, D2C computation already underway ("waitbar" exists)')
  return
end

if ~isstruct(PZG) ...
  ||~isfield(PZG,'PoleLocs') ...
  ||~isfield(PZG,'ZeroLocs') ...
  ||~isfield(PZG,'Gain') ...
  ||~isfield(PZG,'Ts')
  errdlg_h = ...
    errordlg( ...
      {'Cannot find a valid PZGUI data structure.'; ...
       'Return argument will be empty.'; ...
       ' ';'    Click "OK" to continue.'}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
end

if ~nargin
  cnv_method = 'zoh';
end

if ~ischar(cnv_method) ...
  ||( ~strcmpi( cnv_method,'zoh') ...
     && ~strcmpi( cnv_method,'bilinear') ...
     && ~strcmpi( cnv_method,'tustin') )
  errdlg_h = ...
    errordlg( ...
      {'Input argument must be a character string,'; ...
       'either ''zoh'' or ''bilinear''.'; ...
       'Return argument will be empty.'; ...
       ' ';'    Click "OK" to continue.'}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
end

switch lower(cnv_method)
  case 'zoh'
    [ ct_res, ct_poles, ct_direct ] = local_d2c_zoh;

  case {'bilinear','tustin'}
    [ ct_res, ct_poles, ct_direct ] = local_d2c_bilin;
end
% Note:  all return arguments empty means PFE failed,
%        probably due to too many repeated poles.

wb_h = findobj( allchild(0),'name','D-T to C-T Conversion Progress');
if ~isempty(wb_h)
  delete(wb_h)
  drawnow
  pause(0.01)
end

return



function [ ct_res, ct_poles, ct_direct ] = local_d2c_zoh

global PZG
Ts = PZG(2).Ts;

ct_res = [];
ct_poles = [];
ct_direct = [];

[ dt_res, dt_poles, dt_direct ] = pzg_res(2);

if any( ( real(dt_poles) <= 0 ) & ( imag(dt_poles) == 0 ) )
  errdlg_h = ...
    errordlg( ...
      {'The model cannot be processed under the ZOH-equivalent,'; ...
       'because there is at least one non-positive real-valued pole'; ...
       'in the Z-plane.  There is no S-plane ZOH-equivalent.'; ...
       ' ';'Return arguments will be empty.'; ...
       ' ';'    Click "OK" to continue.'}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
end

if isempty(dt_res) && isempty(dt_poles) && isempty(dt_direct)
  return
end

if isempty(dt_direct)
  dt_direct = 0;
end
ct_direct = dt_direct;

if isempty(dt_poles)
  return
end

block_ndxs = cell(size(dt_poles));
block_sizes = zeros(size(dt_poles));
block_ndxs{1} = 1;
block_sizes(1) = 1;
ptr = 1;
for k = 2:numel(dt_poles)
  if abs( dt_poles(k) - dt_poles(k-1) ) < 1e-10
    block_ndxs{ptr} = [ block_ndxs{ptr}; k ];
    block_sizes(ptr) = block_sizes(ptr) + 1;
  else
    ptr = ptr + 1;
    block_ndxs{ptr} = k;
    block_sizes(ptr) = 1;
  end
end
if ptr < numel(block_ndxs)
  block_ndxs(ptr+1:end) = [];
  block_sizes(ptr+1:end) = [];
end

ct_res = zeros(size(dt_poles));
ct_poles = log( dt_poles ) / Ts;
neglg_imag_ndx = find( abs(imag(ct_poles)) < 100*eps*abs(ct_poles) );
if ~isempty(neglg_imag_ndx)
  ct_poles(neglg_imag_ndx) = real(ct_poles(neglg_imag_ndx));
end
neglg_real_ndx = find( abs(real(ct_poles)) < 100*eps*abs(ct_poles) );
if ~isempty(neglg_real_ndx)
  ct_poles(neglg_real_ndx) = 1i * imag(ct_poles(neglg_real_ndx));
end

wb_h = -1;
if numel(block_ndxs) > 20
  wb_h = waitbar( 0.01,'Converting D-T Model to C-T ...', ...
                  'name','D-T to C-T Conversion Progress');
  drawnow
  pause(0.01)
end

for kb = 1:numel(block_ndxs)
  ndxs = block_ndxs{kb};
  Q = block_sizes(kb);
  if Q == 1
    if dt_poles(ndxs(1)) ~= 0
      if abs(1-dt_poles(ndxs(1))) > 1e-12
        ct_res(ndxs) = ...
          dt_res(ndxs)*ct_poles(ndxs(1))/(dt_poles(ndxs(1))-1);
      else
        ct_res(ndxs) = dt_res(ndxs)/PZG(2).Ts;
      end
    else
      ct_res(ndxs) = dt_res(ndxs);
    end
  end
  
  if ishandle(wb_h)
    waitbar( 0.98*kb/numel(block_ndxs), wb_h )
  end
end

if numel(PZG(2).ZeroLocs) < numel(PZG(2).PoleLocs)
  ct_direct = 0;
else
  ct_direct = PZG(2).Gain;
end

% Equalize the very low-frequency gain sign.
lf_uc_pt = exp(1i*1e-6);
lf_jw_pt = 1i*imag( log( lf_uc_pt )/PZG(2).Ts );
if ~any( abs( PZG(2).PoleLocs - lf_uc_pt ) < 1e-7 ) ...
  && ~any( abs( PZG(2).ZeroLocs - lf_uc_pt ) < 1e-7 )
  dt_LFgain = PZG(2).Gain;
  num_angles = angle( lf_uc_pt - PZG(2).ZeroLocs );
  den_angles = angle( lf_uc_pt - PZG(2).PoleLocs );
  [ temp, sortndx ] = sort( abs(num_angles) ); %#ok<ASGLU>
  num_angles = num_angles(sortndx);
  [ temp, sortndx ] = sort( abs(den_angles) ); %#ok<ASGLU>
  den_angles = den_angles(sortndx);
  dt_LFangle = angle(dt_LFgain) + sum(num_angles) - sum(den_angles);
  dt_LFangle = angle( exp(1i*dt_LFangle) );
  
  ct_LFgain = ct_direct;
  ct_terms = ct_res ./ ( lf_jw_pt - ct_poles );
  for k = 2:numel(ct_poles)
    rep_nr = ...
      sum( abs( ct_poles(1:k-1) - ct_poles(k) )/max(1,abs(ct_poles(k))) ...
          < 1e-14 );
    if rep_nr > 0
      ct_terms(k) = ct_terms(k) / ( lf_jw_pt - ct_poles(k) )^rep_nr;      
    end
  end
  [ temp, sortndx ] = sort( abs(ct_terms) ); %#ok<ASGLU>
  ct_terms = ct_terms(sortndx);
  ct_LFgain = ct_LFgain + sum(ct_terms);
  ct_LFangle = angle(ct_LFgain);
  
  if ( abs( dt_LFangle - ct_LFangle ) > pi/2 ) ...
    && ( abs( dt_LFangle - ct_LFangle ) < 3*pi/2 )
    ct_direct = -ct_direct;
    ct_res = -ct_res;
  end
end

if isequal( 1, ishandle( wb_h ) )
  delete(wb_h)
  drawnow
  pause(0.01)
end

return


function [ ct_res, ct_poles, ct_direct ] = local_d2c_bilin

global PZG
Ts = PZG(2).Ts;

ct_res = [];
ct_poles = [];
ct_direct = [];

[ dt_res, dt_poles, dt_direct ] = pzg_res(2);

prewarping = 1;
if prewarping
  pole_rep = 1;
  for k = 1:numel(dt_poles)
    if ( k > 1 ) && ( abs(dt_poles(k)-dt_poles(k-1)) < 1e-14 )
      pole_rep = pole_rep + 1;
    else
      pole_rep = 1;
    end
    if abs( imag(dt_poles(k)) ) > 1e-10
      normalized_pole_freq = abs(angle(dt_poles(k)))/2;
      normalized_prewarp_pole_freq = atan(normalized_pole_freq);
      T2_T1_ratio = normalized_prewarp_pole_freq / normalized_pole_freq;
      this_pole = dt_poles(k);
      warped_pole = ...
        abs( this_pole )^T2_T1_ratio * exp( 1i*angle(this_pole)*T2_T1_ratio );
      dt_res(k) = dt_res(k) * ((warped_pole-1)/(this_pole-1))^pole_rep;
      dt_poles(k) = warped_pole;
    end
  end
end

if isempty(dt_res) && isempty(dt_poles) && isempty(dt_direct)
  return
end

dt_zeros = PZG(2).ZeroLocs;

if isempty(dt_direct)
  dt_direct = 0;
end

if isempty(dt_poles)
  ct_direct = dt_direct;
  return
end

if any( abs( dt_poles + 1 ) < 1e-10 )
  errdlg_h = ...
    errordlg( ...
      {'The model cannot be processed under the bilinear transform,'; ...
       'because there is at least one pole at z = -1, corresponding'; ...
       'to a pole at infinity in the s-domain.'; ...
       ' ';'Return arguments will be empty.'; ...
       ' ';'    Click "OK" to continue.'}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
end

block_ndxs = cell(size(dt_poles));
block_sizes = zeros(size(dt_poles));
block_ndxs{1} = 1;
block_sizes(1) = 1;
ptr = 1;
for k = 2:numel(dt_poles)
  if abs( dt_poles(k) - dt_poles(k-1) ) < 1e-14
    block_ndxs{ptr} = [ block_ndxs{ptr}; k ];
    block_sizes(ptr) = block_sizes(ptr) + 1;
  else
    ptr = ptr + 1;
    block_ndxs{ptr} = k;
    block_sizes(ptr) = 1;
  end
end
if ptr < numel(block_ndxs)
  block_ndxs(ptr+1:end) = [];
  block_sizes(ptr+1:end) = [];
end

ct_res = zeros(size(dt_res));
ct_poles = 2/Ts *( dt_poles - 1 ) ./ ( dt_poles + 1 );
neglg_imag_ndx = find( abs(imag(ct_poles)) < 100*eps*abs(ct_poles) );
if ~isempty(neglg_imag_ndx)
  ct_poles(neglg_imag_ndx) = real(ct_poles(neglg_imag_ndx));
end
neglg_real_ndx = find( abs(real(ct_poles)) < 100*eps*abs(ct_poles) );
if ~isempty(neglg_real_ndx)
  ct_poles(neglg_real_ndx) = 1i * imag(ct_poles(neglg_real_ndx));
end

ct_direct = dt_direct;

wb_h = -1;
if numel(block_ndxs) > 20
  wb_h = waitbar( 0.01,'Converting D-T Model to C-T ...', ...
                  'name','D-T to C-T Conversion Progress');
  drawnow
  pause(0.01)
end

for kb = 1:numel(block_ndxs)
  ndxs = block_ndxs{kb};
  Q = block_sizes(kb);
  mu = ct_poles(ndxs(1));
  mu_minus2_T = mu - 2/Ts;
  minus1_pplus1 = -1 / ( dt_poles(ndxs(1)) + 1 );

  % Compute the direct term:  j = 0 and k goes from 1 to #ndxs in block.
  for kk = 1:Q
    ct_direct = ct_direct + minus1_pplus1^kk * dt_res(ndxs(kk));
  end
  
  % Compute each of the residues for this block.
  for jj = 1:Q
    for kk = jj:Q
      fctrl_prod = factorial(kk)/factorial(jj)/factorial(kk-jj);
      ct_res(ndxs(jj)) = ...
        ct_res(ndxs(jj)) ...
        + minus1_pplus1^kk * dt_res(ndxs(kk)) * fctrl_prod * mu_minus2_T^jj;
    end
  end
  if ishandle(wb_h)
    waitbar( 0.98*kb/numel(block_ndxs), wb_h )
  end
end

ct_direct = real(ct_direct);
if any( abs( dt_zeros + 1 ) < 1e-10 )
  if abs(ct_direct) > 1e-12
    errdlg_h = ...
      errordlg( ...
        {'There seems to be significant computation error'; ...
         'in the D-T to C-T bilinear transformation,'; ...
         'because the direct term was significantly non-zero.'; ...
         ' ';'    Click "OK" to continue.'}, ...
        [mfilename ' Error'],'modal');
    uiwait(errdlg_h)
  end
  ct_direct = 0;
end

if isequal( 1, ishandle( wb_h ) )
  delete(wb_h)
  drawnow
  pause(0.01)
end

return


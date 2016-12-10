function [ dt_res, dt_poles, dt_direct ] = ...
               pzg_c2d( cnv_method, ct_res, ct_poles, ct_direct, Ts )
%   [ dt_res, dt_poles, dt_direct ] = ...
%       pzg_c2d( method, ct_res, ct_poles, ct_direct, Ts );
%                  with method = 'zoh'
%                    or method = 'bilinear'
% Converts a partial-fraction-expansion transfer function model 
% from continuous-time to discrete-time, using the specified method.
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
dt_res = [];
dt_poles = [];
dt_direct = [];
if isempty(PZG) && ~pzg_recovr
  return
end


if ( nargin < 5 ) ...
  &&( ~isstruct(PZG) ...
     ||~isfield(PZG,'PoleLocs') ...
     ||~isfield(PZG,'ZeroLocs') ...
     ||~isfield(PZG,'Gain') ...
     ||~isfield(PZG,'Ts') )
  errdlg_h = ...
    errordlg( ...
      {'Cannot find a valid PZGUI data structure.'; ...
       'Return arguments will be empty.'; ...
       ' ';'    Click "OK" to continue.'}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
end

if ( nargin < 5 ) || ~isnumeric(Ts) || ( numel(Ts) ~= 1 )
  Ts = PZG.Ts;
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

if nargin < 4
  switch lower(cnv_method)
    case 'zoh'
      [ dt_res, dt_poles, dt_direct ] = local_c2d_zoh;
    case {'bilinear','tustin'}
      [ dt_res, dt_poles, dt_direct ] = local_c2d_bilin;
  end
else
  switch lower(cnv_method)
    case 'zoh'
      [ dt_res, dt_poles, dt_direct ] = ...
          local_c2d_zoh( ct_res, ct_poles, ct_direct, Ts );
      if isempty(ct_direct) || isequal( 0, ct_direct )
        dt_direct = 0;
      end
      
    case {'bilinear','tustin'}
      [ dt_res, dt_poles, dt_direct ] = ...
          local_c2d_bilin( ct_res, ct_poles, ct_direct, Ts );
  end
end


return


function [ dt_res, dt_poles, dt_direct ] = ...
             local_c2d_zoh( ct_res, ct_poles, ct_direct, Ts )

global PZG

dt_res = [];
dt_poles = [];
dt_direct = [];

if nargin < 3
  if isempty(PZG(1).PoleLocs)
    dt_res = [];
    dt_poles = [];
    dt_direct = PZG(1).Gain;
    return
  end
  
  ZZ = PZG(1).ZeroLocs;
  PP = PZG(1).PoleLocs;
  KK = PZG(1).Gain;
  [ ct_res, ct_poles ] = pzg_res( ZZ, PP, KK );
  ct_ss = pzg_moda([],ZZ,PP,KK);
  if isequal( numel(PZG(1).ZeroLocs), numel(PZG(1).PoleLocs) )
    ct_direct = PZG(1).Gain;
  else
    ct_direct = 0;
  end
end
if nargin < 4
  Ts = PZG(2).Ts;
end
if isempty(ct_res) && isempty(ct_poles) && isempty(ct_direct)
  return
end

if isempty(ct_direct)
  ct_direct = 0;
end

dt_direct = ct_direct;
if isempty(ct_poles)
  return
end

block_ndxs = cell(size(ct_poles));
block_sizes = zeros(size(ct_poles));
block_ndxs{1} = 1;
block_sizes(1) = 1;
ptr = 1;
for k = 2:numel(ct_poles)
  if abs( ct_poles(k) - ct_poles(k-1) ) < 1e-10
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
end

dt_res = zeros(size(ct_res));
dt_poles = exp( ct_poles * Ts );
neglg_imag_ndx = find( abs(imag(dt_poles)) < 100*eps*abs(dt_poles) );
if ~isempty(neglg_imag_ndx)
  dt_poles(neglg_imag_ndx) = real(dt_poles(neglg_imag_ndx));
end
neglg_real_ndx = find( abs(real(dt_poles)) < 100*eps*abs(dt_poles) );
if ~isempty(neglg_real_ndx)
  dt_poles(neglg_real_ndx) = 1i * imag(dt_poles(neglg_real_ndx));
end

max_block_size = 1;
for kb = 1:numel(block_ndxs)
  max_block_size = max( max_block_size, numel(block_ndxs{kb}) );
end

use_matlab_fcn = 0;
if ( max_block_size == 1 ) && ( nargin < 3 ) && use_matlab_fcn
  % Use Matlab's ZOH-equiv function.
  [ Ad, Bd, Cd, Dd ] = c2dm( ct_ss.a, ct_ss.b, ct_ss.c, ct_ss.d, Ts,'zoh');
  [ ZZ, PP, KK ] = ss2zp( Ad, Bd, Cd, Dd, 1 );
  [ dt_res, dt_poles ] = pzg_res( ZZ, PP, KK );
else
  for kb = 1:numel(block_ndxs)
    ndxs = block_ndxs{kb};
    if ( kb > 1 ) ...
      && isequal( numel(block_ndxs{kb-1}), numel(block_ndxs{kb}) ) ...
      && isequal( dt_poles(block_ndxs{kb-1}), conj(dt_poles(block_ndxs{kb})) )
      dt_res(ndxs) = conj( dt_res(block_ndxs{kb-1}) );
      continue
    end
    if numel(ndxs) == 1
      if ct_poles(ndxs) ~= 0
        dt_res(ndxs) = ct_res(ndxs) * ( dt_poles(ndxs) - 1 ) / ct_poles(ndxs);
      else
        dt_res(ndxs) = ct_res(ndxs) * Ts;
      end
    else
      this_pole = dt_poles(ndxs(1));
      this_pole_rep = numel(ndxs);
      this_pole_ct_res = ct_res(ndxs);

      pole_rep_resid = pzg_tpwr( this_pole, this_pole_rep, 1 );
      pole_rep_resid = ...
        this_pole_ct_res(:)*ones(1,this_pole_rep+1) .* pole_rep_resid;

      for kres = 1:this_pole_rep
        dt_res(ndxs(kres)) = sum( pole_rep_resid(:,kres+1) );
      end
      for k_nndx = 1:numel(ndxs)
        dt_res(ndxs) = dt_res(ndxs) * PZG(2).Ts;
      end
    end
  end
end

if numel(PZG(1).ZeroLocs) < numel(PZG(1).PoleLocs)
  dt_direct = 0;
else
  dt_direct = ct_direct;
end

return


function [ dt_res, dt_poles, dt_direct ] = ...
               local_c2d_bilin( ct_res, ct_poles, ct_direct, Ts )

global PZG


dt_res = [];
dt_poles = [];
dt_direct = [];

if nargin < 3
  [ ct_res, ct_poles, ct_direct ] = pzg_res(1);
end
if nargin < 4
  Ts = PZG(2).Ts;
end

if isempty(ct_direct)
  ct_direct = 0;
end
if isempty(ct_poles)
  dt_direct = ct_direct;
  return
end

if any( abs( ct_poles - 2/Ts ) < 1e-10 )
  errdlg_h = ...
    errordlg( ...
      {'The model cannot be processed under the bilinear transform,'; ...
       'because there is at least one pole at s = +2/T.'; ...
       ' ';'Return arguments will be empty.'; ...
       ' ';'    Click "OK" to continue.'}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
end

block_ndxs = cell(size(ct_poles));
block_sizes = zeros(size(ct_poles));
block_ndxs{1} = 1;
block_sizes(1) = 1;
ptr = 1;
for k = 2:numel(ct_poles)
  if abs( ct_poles(k) - ct_poles(k-1) ) < 1e-14
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

dt_res = zeros(size(ct_res));
dt_poles = ( 2 + Ts*ct_poles ) ./ ( 2 - Ts*ct_poles );
neglg_imag_ndx = find( abs(imag(dt_poles)) < 100*eps*abs(dt_poles) );
if ~isempty(neglg_imag_ndx)
  dt_poles(neglg_imag_ndx) = real(dt_poles(neglg_imag_ndx));
end
neglg_real_ndx = find( abs(real(dt_poles)) < 100*eps*abs(dt_poles) );
if ~isempty(neglg_real_ndx)
  dt_poles(neglg_real_ndx) = 1i * imag(dt_poles(neglg_real_ndx));
end

dt_direct = ct_direct;

for kb = 1:numel(block_ndxs)
  ndxs = block_ndxs{kb};
  Q = block_sizes(kb);
  mu = dt_poles(ndxs(1));
  T_2minusTp = Ts / ( 2 - Ts*ct_poles(ndxs(1)) );

  % Compute the direct term:  j = 0 and k goes from 1 to #ndxs in block.
  for kq = 1:Q
    dt_direct = dt_direct + T_2minusTp^kq * ct_res(ndxs(kq));
  end
  
  % Compute each of the residues for this block.
  for jj = 1:Q
    for kk = jj:Q
      sub_res = 0;
      for mm = kk-jj:kk
        fctrl_prod = ...
          factorial(kk)/factorial(kk-mm) ...
             /factorial(mm-kk+jj)/factorial(kk-jj);
        sub_res = sub_res + fctrl_prod * mu^(mm-kk+jj);
      end
      dt_res(ndxs(jj)) = ...
        dt_res(ndxs(jj)) + T_2minusTp^kk * ct_res(ndxs(kk)) * sub_res;
    end
  end
end

dt_direct = real(dt_direct);

postwarping = 1;
if postwarping
  pole_rep = 1;
  for k = 1:numel(dt_poles)
    if ( k > 1 ) && ( abs(dt_poles(k)-dt_poles(k-1)) < 1e-14 )
      pole_rep = pole_rep + 1;
    else
      pole_rep = 1;
    end
    if abs( imag(dt_poles(k)) ) > 1e-10
      normalized_pole_freq = abs(angle(dt_poles(k)))/2;
      normalized_prewarp_pole_freq = tan(normalized_pole_freq);
      T2_T1_ratio = normalized_prewarp_pole_freq / normalized_pole_freq;
      this_pole = dt_poles(k);
      warped_pole = ...
        abs( this_pole )^T2_T1_ratio * exp( 1i*angle(this_pole)*T2_T1_ratio );
      dt_res(k) = dt_res(k) * ((warped_pole-1)/(this_pole-1))^pole_rep;
      dt_poles(k) = warped_pole;
    else
      % Adjust for the frequency of real-valued poles.
      
    end
  end
end

return


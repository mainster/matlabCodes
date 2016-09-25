function [ all_res, all_poles, direct, used_builtin ] = ...
             pzg_res( PZGndx, include_pade, include_prvw, pole_loc, quiet )
%   [ reses, poles, direct ] = pzg_res( ZZ, PP, KK );
% Converts specified zpk model to partial-fraction-expansion form.
% Residues and poles use the same convention as Matlab's "residue" function.
% Algorithm based on 
%  Westreich, D.,"Partial fraction expansion without derivative evaluation,"
%   IEEE Transactions on Circuits and Systems, v.38, no.6 (1991), pp.658-660.

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

all_res = [];
all_poles = [];
direct = [];
used_builtin = 0;

allfig_h = findobj( allchild(0),'type','figure');
wb_h = [ findobj( allfig_h,'name','Computing C-T Pole-Residues'); ...
         findobj( allfig_h,'name','Computing D-T Pole-Residues') ];
for k = numel(wb_h):-1:1
  pause(0.1)
  if strcmp( get(wb_h(k),'visible'),'off')
    delete(wb_h(k))
    wb_h(k) = [];
  end
end
if ~isempty(wb_h)
  disp('pzg_res comp in progress.')
  return
end

if nargin < 5
  quiet = 0;
else
  quiet = ~isequal( quiet, 0 );
end


if ( ( nargin == 3 ) ...
    ||( ( nargin == 5 ) && isempty(pole_loc) ) ...
    ||( ( nargin > 3 ) && ~isempty(pole_loc) ) ) ...
  && isnumeric(PZGndx) && isnumeric(include_pade) ...
  && isnumeric(include_prvw) && ~isempty(include_prvw)
  % Requesting residue of a specific pole, or all of the residues.
  % First three args are Z, P, and K.
  ZZ = PZGndx;
  PP = include_pade;
  KK = include_prvw;
  
  if ( nargin > 3 ) ...
    && isnumeric(pole_loc) && ( numel(pole_loc) >= 1 ) ...
    &&( numel(pole_loc) <= numel(PP) ) ...
    &&( numel(KK) == 1 ) ...
    && ~isempty(PP) && sum( PP == pole_loc(1) ) ...
    &&( numel(PP) >= numel(ZZ) )
    for k = numel(pole_loc):-1:2
      % Eliminate non-unique poles from the list.
      if any(abs( pole_loc(k)-pole_loc(1:k-1) )/max(1,abs(pole_loc(k)))) < 1e-14
        pole_loc(k) = [];
      end
    end
    all_res = [];
    all_poles = [];
    for k = 1:numel(pole_loc)
      ret_res = residues_of_p1( ZZ, PP, KK, pole_loc(k) );
      all_res = [ all_res; ret_res ];           %#ok<AGROW>
      all_poles = ...
        [ all_poles; pole_loc(k)*ones(size(ret_res)) ];     %#ok<AGROW>
    end
  else
    [ all_res, all_poles, direct ] = zpk2pfe2( ZZ, PP, KK, quiet );
    if numel(ZZ) < numel(PP)
      direct = 0;
    end
  end
  return
end

if ~isstruct(PZG) ...
  ||~isfield(PZG,'PoleLocs') ...
  ||~isfield(PZG,'ZeroLocs') ...
  ||~isfield(PZG,'Gain')
  errdlg_h = ...
    errordlg( ...
      {'Cannot find a valid PZGUI main structure.'; ...
       'Return arguments will be empty.'; ...
       ' ';'    Click "OK" to continue.'}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
end

if ~nargin
  errdlg_h = ...
    errordlg( ...
      {'Not enough input arguments for this function.'; ...
       ' ';'    Click "OK" to continue.'}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
elseif ~isequal( PZGndx, 1 ) && ~isequal( PZGndx, 2 )
  errdlg_h = ...
    errordlg( ...
      {'Input argument "PZGndx" must be either 1 or 2.'; ...
       ' ';'    Click "OK" to continue.'}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
end

if nargin < 2
  include_pade = 0;
else
  include_pade = ~isequal( include_pade, 0 );
end

if ( nargin < 3 ) || isempty(include_prvw)
  include_prvw = '';
end
[ curr_tools, dsnfig_h, preview_on ] = pzg_tools(PZGndx);
if ~ischar(include_prvw)
  if isequal(include_prvw, 0 )
    include_prvw = '';
  else
    if isempty(dsnfig_h) || ~preview_on
      include_prvw = '';
    else
      if PZGndx == 1
        Domain = 's';
      else
        Domain = 'z';
      end
      if curr_tools(1)
        include_prvw = [ Domain 'Gain'];
      elseif curr_tools(2)
        include_prvw = [ Domain 'LDLG'];
      elseif curr_tools(3)
        include_prvw = [ Domain 'PID'];
      else
        include_prvw = '';
      end
    end
  end
end

ZZ = PZG(PZGndx).ZeroLocs;
PP = PZG(PZGndx).PoleLocs;
KK = PZG(PZGndx).Gain;

if include_pade && ( PZG(PZGndx).PureDelay > 0 )
  if PZGndx == 1
    [ delayN, delayD ] = pade( PZG(1).PureDelay, 4 );
    ZZ = [ ZZ; roots(delayN) ];
    PP = [ PP; roots(delayD) ];
  else
    PP = [ PP; zeros( PZG(2).PureDelay, 1 ) ];
  end
end

if ~isempty(dsnfig_h) && ~isempty(include_prvw) && ischar(include_prvw)
  % Get the pole, zero, and gain.
  if curr_tools(1)
    gain_h = findobj( dsnfig_h,'tag','Gain');
    this_k = str2double( get(gain_h,'string') );
    KK = KK * this_k;
  elseif curr_tools(2)
    % LEAD-LAG
    zero_h = findobj( dsnfig_h,'tag','Zero');
    this_z = str2double( get(zero_h,'string') );
    pole_h = findobj( dsnfig_h,'tag','Pole');
    this_p = str2double( get(pole_h,'string') );
    gain_h = findobj( dsnfig_h,'tag','Gain');
    this_k = str2double( get(gain_h,'string') );
    if ~isequal( this_p, this_z )
      if ~isempty(this_z) && ~isempty(this_p) && ~isempty(this_k) ...
        && ~isnan(this_z) && ~isnan(this_p) && ~isnan(this_k) ...
        && ~isinf(this_z) && ~isinf(this_p) && ~isinf(this_k)
        if ~isempty(PP)
          [ mindist, minndx ] = min( abs( PP - this_z ) );
          if mindist < 1e-12
            PP(minndx) = [];
            this_z = [];
          end
        end
        ZZ = [ ZZ; this_z ];
        if ~isempty(ZZ)
          [ mindist, minndx ] = min( abs(ZZ-this_p) );
          if mindist < 1e-12
            ZZ(minndx) = [];
            this_p = [];
          end
        end
        PP = [ PP; this_p ];
      end
      KK = KK * this_k;
    end
  else
    % PID
    zero1_h = findobj( dsnfig_h,'tag','Zero1');
    zero2_h = findobj( dsnfig_h,'tag','Zero2');
    these_z = [ str2double( get(zero1_h,'string') ); ...
                str2double( get(zero2_h,'string') ) ];
    gain_h = findobj( dsnfig_h,'tag','Gain');
    this_k = str2double( get(gain_h,'string') );
    p2mult_h = findobj( dsnfig_h,'tag','pole2_multiplier');
    p2mult = str2double( get(p2mult_h,'string') );
    if isempty(p2mult)
      set( p2mult_h,'string','10');
      p2mult = 10;
    end
    if ~isempty(these_z(1)) && ~isempty(these_z(2)) && ~isempty(this_k) ...
      && ~isnan(these_z(1)) && ~isnan(these_z(2)) && ~isnan(this_k) ...
      && ~isinf(these_z(1)) && ~isinf(these_z(2)) && ~isinf(this_k)
      if PZGndx == 1
        these_p = [ 0; -p2mult*max(abs(these_z)) ];
        this_k = this_k * abs(these_p(2));
      else
        these_p = [ 1; 0 ];
      end
      for ktp = 2:-1:1
        if ~isempty(PP)
          [ mindist, minndx ] = min( abs( PP - these_z(ktp) ) );
          if mindist < 1e-12
            PP(minndx) = [];
            these_z(ktp) = [];
          end
        end
      end
      ZZ = [ ZZ; these_z ];
      for ktp = 2:-1:1
        if ~isempty(ZZ)
          [ mindist, minndx ] = min( abs( ZZ - these_p(ktp) ) );
          if mindist < 1e-12
            ZZ(minndx) = [];
            these_p(ktp) = [];
          end
        end
      end
      PP = [ PP; these_p ];
      KK = KK * this_k;
    end
  end
end

% Delete any canceling pole/zero pairs.
cancel_dist = 1e-14;
canceled_poles = [];
if ~isempty(ZZ)
  for k = numel(PP):-1:1
    cancel_ndxs = ...
      find( abs( ZZ - PP(k) )./max(1,abs(PP(k))) < cancel_dist );
    if numel(cancel_ndxs) > 1
      % Identify the closest zero.
      [ tempdist, sort_ndxs ] = ...
          sort( abs( ZZ(cancel_ndxs) - PP(k) ) ); %#ok<ASGLU>
      ZZ(cancel_ndxs(sort_ndxs(1))) = [];
      canceled_poles(end+1) = PP(k); %#ok<AGROW>
      PP(k) = [];
    elseif numel(cancel_ndxs) == 1
      canceled_poles(end+1) = PP(k); %#ok<AGROW>
      ZZ(cancel_ndxs) = [];
      PP(k) = [];
    end
  end
end

[ all_res, all_poles, direct ] = zpk2pfe2( ZZ, PP, KK, quiet );
if numel(ZZ) < numel(PP)
  direct = 0;
end

if ~isempty(canceled_poles)
  all_poles = [ all_poles; canceled_poles(:) ];
  all_res = [ all_res; zeros(numel(canceled_poles),1) ];
end

return

function [ reses, poles, direct ] = zpk2pfe2( ZZ, PP, KK, quiet )

% Convert a zero/pole/gain model into partial-fraction expansion (PFE) form.
% Format:
%           [ reses, poles, direct ] = zpk2pfe( ZZ, PP, KK );
%    OR
%           [ reses, poles, direct ] = zpk2pfe( zpk_object );
%
% -------------------------------------------
%  (c) 2011, Mark A. Hopkins, EME Dept., RIT
%
% Algorithm based on 
%  Westreich, D.,"Partial fraction expansion without derivative evaluation,"
%   IEEE Transactions on Circuits and Systems, v.38, no.6 (1991), pp.658-660.
% -------------------------------------------

reses = [];
poles = [];
direct = [];

if ( nargin < 3 )
  if ( nargin == 1 ) && isa( ZZ,'zpk')
    zpk_mdl = ZZ;
    ZZ = zpk_mdl.z;
    if iscell(ZZ)
      ZZ = ZZ{1};
    end
    PP = zpk_mdl.p;
    if iscell(PP)
      PP = PP{1};
    end
    KK = zpk_mdl.k;
  else
    errdlg_h = ...
      errordlg( ...
        {'ZPK2PFE:  Not enough input arguments.'; ...
         '  This function requires pole-vector, zero-vector, and gain'; ...
         '  as input arguments, or ZPK-object as a single input argument.'; ...
         ' ';'        Click "OK" to continue'}, ...
        'zpk2pfe Error','modal');
    uiwait(errdlg_h)
    return
  end
end

if ~isnumeric(ZZ) || ~isnumeric(PP) || ~isnumeric(KK) ...
  || any(isinf(ZZ)) || any(isinf(PP)) ...
  || any(isnan(ZZ)) || any(isnan(PP))
  errdlg_h = ...
    errordlg( ...
      {'ZPK2PFE:  Incorrect input arguments:'; ...
       ' '; ...
       'The pole-vector, zero-vector, and gain must all be numeric types,'; ...
       'and all poles and zeros must be finite well-defined numbers.'; ...
       ' ';'        Click "OK" to continue'}, ...
      'zpk2pfe Error','modal');
  uiwait(errdlg_h)
  return
elseif numel(ZZ) > numel(PP)
  errdlg_h = ...
    errordlg( ...
      {'ZPK2PFE:  Incorrect input arguments:'; ...
       ' '; ...
       'There are more zeros than poles -- this does not have a PFE.'; ...
       ' ';'        Click "OK" to continue'}, ...
      'zpk2pfe Error','modal');
  uiwait(errdlg_h)
  return
elseif ( numel(KK) ~= 1 ) || isinf(KK) || isnan(KK)
  errdlg_h = ...
    errordlg( ...
      {'ZPK2PFE:  Incorrect input argument:  The gain must be scalar,'; ...
       '                numeric, and finite.'; ...
       ' ';'        Click "OK" to continue'}, ...
      'zpk2pfe Error','modal');
  uiwait(errdlg_h)
  return
end

ZZ = ZZ(:);
PP = PP(:);
KK = KK(1);

if numel(ZZ) == numel(PP)
  direct = KK;
else
  direct = 0;
end
if isempty(PP)
  return
end
poles = zeros(size(PP));
reses = zeros(size(PP));

unique_poles = PP(:);
pole_rep = ones(size(PP));
for k = numel(unique_poles):-1:2
  this_pole = unique_poles(k);
  samepole_ndxs = ...
    find( abs( unique_poles - this_pole ) < 1e-14*max(1,abs(this_pole)) );
  if numel(samepole_ndxs) > 1
    incr_pole_ndx = min(samepole_ndxs);
    pole_rep(incr_pole_ndx) = ...
      pole_rep(incr_pole_ndx) + pole_rep(k);
    pole_rep(k) = [];
    unique_poles(k) = [];
  end
end

% See if all poles occur in cplx-conj pairs.
matched_pairs = 1;
for k = 1:numel(unique_poles)
  if abs(imag(unique_poles(k))) > 1e-15*abs(real(unique_poles(k)))
    % Does it have a matching cplx-conj?
    [ mindist, mindist_ndx ] = min( conj(unique_poles(k)) - unique_poles );
    if ( mindist > 1e-14*abs(unique_poles(k)) ) ...
      || ~isequal( pole_rep(k), pole_rep(mindist_ndx) )
      matched_pairs = 0;
    end
  end
end

% Sort by sum of absolute value and absolute angle,
% to put complex-conjugate poles next to each other.
[ junk, sort_rep_ndx ] = ...
    sort( abs(unique_poles) + abs(angle(unique_poles)) );   %#ok<ASGLU>
pole_rep = pole_rep(sort_rep_ndx);
unique_poles = unique_poles(sort_rep_ndx);

% Sort by decreasing reps.
[ junk, sort_rep_ndx ] = sort( -pole_rep );   %#ok<ASGLU>
pole_rep = pole_rep(sort_rep_ndx);
unique_poles = unique_poles(sort_rep_ndx);

% Put negative-imag part in front of pos-imag part
% because these get reversed in the residue computation loop.
for k = 2:numel(unique_poles)
  if ( ( abs( unique_poles(k) - conj(unique_poles(k-1)) ) ...
         / abs(unique_poles(k) ) < 3e-15 ) ) ...
    && ( imag(unique_poles(k)) < 0 )
    unique_poles(k-1:k) = unique_poles([k;k-1]);
  end
end

wb_h = -1;
if ( numel(unique_poles) > 100 ) && ~quiet
  wb_h = waitbar( 0.01,'Computing pole residues ...', ...
                  'name','Partial-Fraction Expansion Progress');
  drawnow
  pause(0.01)
end

pndx = numel(PP) + 1;
for k = 1:numel(unique_poles)
  this_pole = unique_poles(k);
  this_pole_rep = pole_rep(k);
  
  if ( k > 1 ) && matched_pairs ...
    &&( abs( conj(this_pole) - unique_poles(k-1) )/abs(this_pole) < 1e-14 )
    res_of_p1 = conj(res_of_p1);
  else
    res_of_p1 = residues_of_p1( ZZ, PP, KK, this_pole );
  end
  
  pndx = pndx - this_pole_rep;
  ndx1 = pndx;
  ndx2 = pndx+this_pole_rep-1;
  poles(ndx1:ndx2) = this_pole;
  reses(ndx1:ndx2) = res_of_p1;
  
  if ~mod( k, 15 ) && isequal( 1, ishandle(wb_h) )
    waitbar( 0.99*k/numel(unique_poles), wb_h );
  end
end

if isequal( 1, ishandle(wb_h) )
  delete(wb_h)
end

pos_imag_ndx = find( imag(poles) > 0 );
neg_imag_ndx = find( imag(poles) < 0 );
if isequal( numel(pos_imag_ndx), numel(neg_imag_ndx) )
  for k = numel(pos_imag_ndx):-1:1
    [ mindist, matchndx ] = ...
        min( abs( poles(pos_imag_ndx(k)) - conj(poles(neg_imag_ndx)) ) );
    if mindist/abs(poles(pos_imag_ndx(k))) < 1e-14
      pos_imag_ndx(k) = [];
      neg_imag_ndx(matchndx) = [];
    end
  end
  if isempty(pos_imag_ndx)
    for k = 1:numel(poles)
      if imag(poles(k)) == 0
        reses(k) = real(reses(k));
      end
    end
  end
end

return

function res_of_p1 = residues_of_p1( ZZ, PP, KK, p1 )

res_of_p1 = [];

if nargin < 4
  errdlg_h = ...
    errordlg( ...
      {['Not enough input arguments (nargin = ' num2str(nargin) ').']}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
else
  ZZ = ZZ(:);
  PP = PP(:);
end

p1_ndx = find( abs(PP-p1) < 1e-14*max(1,abs(p1)) );
if isempty(p1_ndx)
  errdlg_h = ...
    errordlg( ...
      {'The indicated pole is not in the vector of poles.'}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
elseif numel(p1_ndx) == 1
  % This is the simplest case, a non-repeated pole.
  N = numel(PP);
  M = numel(ZZ);
  
  % Compute residues by multiply-and-accumulate.
  % Reorder the poles and zeros so that computation alternates
  % between pole-diff division, and zero-diff multiplication.
  [ ZZ, PP ] = reorder_ZZ_PP( ZZ, PP, p1 );
  
  p1_ndx = find( abs(PP-p1) < 1e-14*max(1,abs(p1)) );
  
  res_of_p1 = KK;
  for k = 1:max( N, M )
    if ( k <= N ) && ( k ~= p1_ndx )
      res_of_p1 = res_of_p1 / ( p1 - PP(k) );
    end
    if k <= M
      res_of_p1 = res_of_p1 * ( p1 - ZZ(k) );
    end
    if isnan(res_of_p1) || isinf(res_of_p1)
      break
    end
  end
  if isnan(res_of_p1) || isinf(res_of_p1)
    logs_to_sum = [ -log( p1 - PP ); log( p1 - ZZ ) ];
    logs_to_sum(p1_ndx) = [];
    log_sum = local_sum_terms( logs_to_sum );
    res_of_p1 = KK * exp(log_sum);
  end
  if isinf(res_of_p1)
    disp(' zpk2pfe -> residues_of_p1:  Computation failed --  "Inf" residue')
  elseif isnan(res_of_p1)
    disp(' zpk2pfe -> residues_of_p1:  Computation failed -- "NaN" residue')
  end
else
  res_of_p1 = rep_pole_reses( ZZ, PP, KK, p1 );
end

return

function [ rep_reses, direct ] = rep_pole_reses( ZZ, PP, KK, rep_pole )

init_ZZ = ZZ; %#ok<NASGU>

% Put repeated pole at beginning of the pole-vector.
rep_pole_ndx = find( abs( PP - rep_pole )/max(1,abs(rep_pole)) < 1e-14 );
nr_reps = numel(rep_pole_ndx);
PP(rep_pole_ndx) = [];
PP = [ rep_pole*ones(nr_reps,1); PP(:) ];

if numel(PP) == numel(ZZ)
  direct = KK;
else
  direct = 0;
end

% Sort zeros by farthest distance from rep_pole.
if ~isempty(ZZ)
  abs_log_dist_ZtoPrep = abs( log( abs( ZZ - rep_pole ) ) );
  [ temp, sortndx ] = sort( -abs_log_dist_ZtoPrep );      %#ok<ASGLU>
  ZZ = ZZ(sortndx);
end
used_ZZ = NaN*ones(size(ZZ));

% Find the PFE of the N-rep pole with the first N-1 zeros.
alt_rep_reses = zeros( nr_reps, 1 );
alt_rep_reses(1) = 1;
terms_to_sum = zeros(nr_reps, nr_reps+1 );
terms_to_sum(1,end) = 1;
for k = 2:nr_reps
  if numel(ZZ) < (k-1)
    terms_to_sum(2:k,:) = terms_to_sum(1:k-1,:);
    terms_to_sum(1,:) = 0;
    alt_rep_reses(2:k) = alt_rep_reses(1:k-1);
    alt_rep_reses(1) = 0;
  else
    this_zero = ZZ(k-1);
    used_ZZ(k-1) = this_zero;
    ZZ(k-1) = Inf;
    for k2 = k:-1:2
      terms_to_sum(k2,k) = alt_rep_reses(k2-1)*( rep_pole - this_zero );
    end
  end
  for ku = 1:size(terms_to_sum,1)
    alt_rep_reses(ku) = local_sum_terms( terms_to_sum(ku,:) );
  end
end

% Now factor in the remaining poles and zeros.
%
% At this point, the remaining poles should be re-ordered
% so that the distance from pole to rep-pole goes farthest to nearest.
% That will cause the reciprocal to be smallest at the beginning.
remaining_poles = PP(nr_reps+1:end);
abs_diff_pq_to_pk = abs( remaining_poles - rep_pole );
[ temp, sortndx ] = sort( -abs_diff_pq_to_pk );      %#ok<ASGLU>
remaining_poles = remaining_poles(sortndx);
PP(nr_reps+1:end) = remaining_poles;

for k = nr_reps+1:numel(PP)
  this_pole = PP(k);
  terms_to_sum = zeros(nr_reps,nr_reps+1);
  if numel(ZZ) < (k-1)
    % There are no more zeros, so factor in this pole by itself.
    terms_to_sum(:,end) = alt_rep_reses/( rep_pole - this_pole );
    for k2 = 1:nr_reps
      multiplier = 1/( rep_pole - this_pole );
      for k3 = k2+1:nr_reps
        multiplier = -multiplier / ( rep_pole - this_pole );
        terms_to_sum(k2,k3) = alt_rep_reses(k3)*multiplier;
      end
    end
  else
    % Find the zero that is closest to this pole.
    % (Experimentation showed this works better than finding
    %  the zero that is nearest to the repeated pole.)
    remz_ndxs = find( ~isinf(ZZ) );
    [ temp, the_ndx ] = min( abs( ZZ(remz_ndxs)-this_pole ) );      %#ok<ASGLU>
    this_zero = ZZ(remz_ndxs(the_ndx));
    used_ZZ(k-1) = this_zero;
    ZZ(remz_ndxs(the_ndx)) = Inf;
    
    terms_to_sum(:,end) = ...
      alt_rep_reses*( rep_pole - this_zero )/( rep_pole - this_pole );
    for k2 = 1:nr_reps
      multiplier = ( this_pole - this_zero )/( rep_pole - this_pole );
      for k3 = k2+1:nr_reps
        multiplier = -multiplier / ( rep_pole - this_pole );
        terms_to_sum(k2,k3) = alt_rep_reses(k3)*multiplier;
      end
    end
  end
  for ka = 1:size(terms_to_sum,1)
    alt_rep_reses(ka) = local_sum_terms( terms_to_sum(ka,:) );
  end
end

rep_reses = alt_rep_reses;

if numel(ZZ) == numel(PP)
  % Handle the last zero, if there is one.
  % Note that all poles have already been processed.
  [ temp, min_ndx ] = min( abs( ZZ-rep_pole ) );     %#ok<ASGLU>
  this_zero = ZZ(min_ndx);
  used_ZZ(min_ndx) = this_zero;                      %#ok<NASGU>
  ZZ(end) = Inf;                                     %#ok<NASGU>
  for k = 1:nr_reps
    if k > 1
      rep_reses(k-1) = rep_reses(k-1) + rep_reses(k);
    end
    rep_reses(k) = rep_reses(k) * ( rep_pole - this_zero );
  end
end

rep_reses = KK * rep_reses;

return

function [ ZZ, PP ] = reorder_ZZ_PP( ZZ, PP, p1 )
  % Reorder the poles and zeros by distance from p1.
  if numel(PP) < 3
    return
  end
  
  % Sort from largest distance to smallest.
  [ dist, sortndx ] = sort( -abs( p1 - ZZ ) ); %#ok<ASGLU>
  ZZ = ZZ(sortndx);
  [ dist, sortndx ] = sort( -abs( p1 - PP ) ); %#ok<ASGLU>
  PP = PP(sortndx);
  
  % If more than a few zeros have significantly greater magnitude 
  % than any of the poles, sort from smallest distance to largest.
  nr_z_chk = 12;
  if numel(ZZ) > nr_z_chk
    integ_loc = 0;
    if ( max(abs(PP)) < 2 ) && ( max(imag(PP)) > 0.2 )
      integ_loc = 1;
    end
    absZ_to_Pmax_ratio = abs(integ_loc-ZZ) ./ max( 1, abs(integ_loc-p1) );
    if ( sum( absZ_to_Pmax_ratio > 10 ) > nr_z_chk/2 ) ...
      ||( sum( absZ_to_Pmax_ratio > 5 ) > nr_z_chk )
      % Special case is where many of the zeros are far greater than the 
      % biggest pole:  sorting by nearest distance to farthest is best.
      [ dist, sortndx ] = sort( abs( p1 - ZZ ) ); %#ok<ASGLU>
      ZZ = ZZ(sortndx);
      [ dist, sortndx ] = sort( abs( p1 - PP ) ); %#ok<ASGLU>
      PP = PP(sortndx);
    end
  end

return

function sum_of_terms = local_sum_terms( terms_to_sum )
  sum_of_terms = 0;
  real_terms = real(terms_to_sum);
  [ abs_real_terms, sortndx ] = sort( abs(real_terms) );
  real_terms = real_terms(sortndx);
  max_abs_real = abs_real_terms(end);
  if max_abs_real > 0
    ndx20 = sum( abs_real_terms < max_abs_real*1e-20 );
    ndx16 = sum( abs_real_terms < max_abs_real*1e-16 );
    ndx12 = sum( abs_real_terms < max_abs_real*1e-12 );
    ndx8 = sum( abs_real_terms < max_abs_real*1e-8 );
    ndx4 = sum( abs_real_terms < max_abs_real*1e-4 );
    if ndx20 > 0
      sum_of_terms = sum(real_terms(1:ndx20));
    end
    if ndx16 > 0
      sum_of_terms = sum_of_terms + sum(real_terms(ndx20+1:ndx16));
    end
    if ndx12 > 0
      sum_of_terms = sum_of_terms + sum(real_terms(ndx16+1:ndx12));
    end
    if ndx8 > 0
      sum_of_terms = sum_of_terms + sum(real_terms(ndx12+1:ndx8));
    end
    if ndx4 > 0
      sum_of_terms = sum_of_terms + sum(real_terms(ndx8+1:ndx4));
    end
    sum_of_terms = sum_of_terms + sum(real_terms(ndx4+1:end));    
  end
  
  if ~isreal( terms_to_sum )
    imag_terms = imag(terms_to_sum);
    [ abs_imag_terms, sortndx ] = sort( abs(imag_terms) );
    imag_terms = imag_terms(sortndx);
    max_abs_imag = abs_imag_terms(end);
    if max_abs_imag > 0
      ndx20 = sum( abs_imag_terms < max_abs_imag*1e-20 );
      ndx16 = sum( abs_imag_terms < max_abs_imag*1e-16 );
      ndx12 = sum( abs_imag_terms < max_abs_imag*1e-12 );
      ndx8 = sum( abs_imag_terms < max_abs_imag*1e-8 );
      ndx4 = sum( abs_imag_terms < max_abs_imag*1e-4 );
      if ndx20 > 0
        sum_of_terms = sum_of_terms + 1i*sum(imag_terms(1:ndx20));
      end
      if ndx16 > 0
        sum_of_terms = sum_of_terms + 1i*sum(imag_terms(ndx20+1:ndx16));
      end
      if ndx12 > 0
        sum_of_terms = sum_of_terms + 1i*sum(imag_terms(ndx16+1:ndx12));
      end
      if ndx8 > 0
        sum_of_terms = sum_of_terms + 1i*sum(imag_terms(ndx12+1:ndx8));
      end
      if ndx4 > 0
        sum_of_terms = sum_of_terms + 1i*sum(imag_terms(ndx8+1:ndx4));
      end
      sum_of_terms = sum_of_terms + 1i*sum(imag_terms(ndx4+1:end));    
    end
  end

return

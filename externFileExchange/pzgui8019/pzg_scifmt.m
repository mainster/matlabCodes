function dec_str = pzg_scifmt( val, ndig )
%     value_str = pzg_scifmt( value, nr_digits );
% Converts a real-valued scalar to a text string in scientific notation,
% using standard prefixes, 'T' (tera), 'G' (giga),'M' (mega),
% 'k' (kilo), 'm' (milli), and '\mu' (micro), or engineering-notation 
% powers-of-ten (e-9, e-12, e-15, etc.) in more extreme cases.
% Extreme cases are returned in strings such as '57.6x10^-^9',
% so they display in Matlab as superscripted exponents of ten.

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

dec_str = '';
if ~nargin || ~isreal(val) || ~isequal( numel(val), 1 )
  return
elseif isinf(val)
  if val > 0
    dec_str = '\infty';
  else
    dec_str = '-\infty';
  end
  return
elseif isnan(val)
  return
end

if ( nargin < 2 ) || ~isreal(ndig) || ~isequal( numel(ndig), 1 ) ...
  || ~isequal( round(ndig), ndig ) || ( ndig < 1 )
  ndig = 3;
else
  ndig = max( 3, ndig );
end

if abs(val) >= 1
  log10_val = floor( log10(abs(val)) );
  eng_offset = 1+mod(log10_val,3);
  if log10_val >= 15
    div_pwr10 = floor( log10_val/3 )*3;
    dec_str = ...
      num2str( round( val/10^(div_pwr10-ndig+eng_offset) ) ...
               /10^(ndig-eng_offset), ndig );
    div_pwr_str = num2str(div_pwr10);
    power_str = [ '^'*ones(size(div_pwr_str)); div_pwr_str ];
    power_str = power_str(:)';
    dec_str = [ dec_str 'x10' power_str ' '];
  elseif log10_val >= 12
    dec_str = num2str( round( val/10^(12-ndig+eng_offset) ) ...
               /10^(ndig-eng_offset), ndig );
    if isempty( strfind( dec_str,'.') )
      if numel(dec_str) == 1
        dec_str = [ dec_str '.00' ];
      elseif numel(dec_str) == 2
        dec_str = [ dec_str '.0' ];
      end
    elseif ( numel(dec_str) == 3 ) ...
      ||( ( numel(dec_str) == 4 ) && strcmp( dec_str(1),'-') )
      dec_str = [ dec_str '0' ];
    end
    dec_str = [ dec_str ' T' ];
  elseif log10_val >= 9
    dec_str = num2str( round( val/10^(9-ndig+eng_offset) ) ...
               /10^(ndig-eng_offset), ndig );
    if isempty( strfind( dec_str,'.') )
      if numel(dec_str) == 1
        dec_str = [ dec_str '.00' ];
      elseif numel(dec_str) == 2
        dec_str = [ dec_str '.0' ];
      end
    elseif ( numel(dec_str) == 3 ) ...
      ||( ( numel(dec_str) == 4 ) && strcmp( dec_str(1),'-') )
      dec_str = [ dec_str '0' ];
    end
    dec_str = [ dec_str ' G' ];
  elseif log10_val >= 6
    dec_str = num2str( round( val/10^(6-ndig+eng_offset) ) ...
               /10^(ndig-eng_offset), ndig );
    if isempty( strfind( dec_str,'.') )
      if numel(dec_str) == 1
        dec_str = [ dec_str '.00' ];
      elseif numel(dec_str) == 2
        dec_str = [ dec_str '.0' ];
      end
    elseif ( numel(dec_str) == 3 ) ...
      ||( ( numel(dec_str) == 4 ) && strcmp( dec_str(1),'-') )
      dec_str = [ dec_str '0' ];
    end
    dec_str = [ dec_str ' M' ];
  elseif log10_val >= 3
    dec_str = num2str( round( val/10^(3-ndig+eng_offset) ) ...
               /10^(ndig-eng_offset), ndig );
    if isempty( strfind( dec_str,'.') )
      if numel(dec_str) == 1
        dec_str = [ dec_str '.00' ];
      elseif numel(dec_str) == 2
        dec_str = [ dec_str '.0' ];
      end
    elseif ( numel(dec_str) == 3 ) ...
      ||( ( numel(dec_str) == 4 ) && strcmp( dec_str(1),'-') )
      dec_str = [ dec_str '0' ];
    end
    dec_str = [ dec_str ' k' ];
  else
    dec_str = ...
      num2str( round(val/10^(-ndig+eng_offset) )*10^(-ndig+eng_offset), ndig );
    if isempty( strfind( dec_str,'.') )
      if numel(dec_str) == 1
        dec_str = [ dec_str '.00' ];
      elseif numel(dec_str) == 2
        dec_str = [ dec_str '.0' ];
      end
    elseif ( numel(dec_str) == 3 ) ...
      ||( ( numel(dec_str) == 4 ) && strcmp( dec_str(1),'-') )
      dec_str = [ dec_str '0' ];
    end
    dec_str = [ dec_str ' ' ];
  end
  
elseif abs(val) < 1e-1
  sign_val = '';
  if val < 0
    sign_val = '-';
  end
  val = abs(val);
  if abs(val) >= 1e-3
    dec_str = local_ndig_str( num2str( 1e3*val, ndig ), ndig );
    dec_str = [ dec_str ' m'];
  elseif abs(val) >= 1e-6
    dec_str = local_ndig_str( num2str( 1e6*val, ndig ), ndig );
    dec_str = [ dec_str ' \mu'];
  elseif abs(val) >= 1e-9
    dec_str = local_ndig_str( num2str( 1e9*val, ndig ), ndig );
    dec_str = [ dec_str 'x10^-^9'];
  elseif abs(val) >= 1e-12
    dec_str = local_ndig_str( num2str( 1e12*val, ndig ), ndig );
    dec_str = [ dec_str 'x10^-^1^2 '];
  elseif abs(val) >= 1e-15
    dec_str = local_ndig_str( num2str( 1e15*val, ndig ), ndig );
    dec_str = [ dec_str 'x10^-^1^5 '];
  elseif abs(val) >= 1e-18
    dec_str = local_ndig_str( num2str( 1e18*val, ndig ), ndig );
    dec_str = [ dec_str 'x10^-^1^8 '];
  elseif abs(val) >= 1e-21
    dec_str = local_ndig_str( num2str( 1e21*val, ndig ), ndig );
    dec_str = [ dec_str 'x10^-^2^1 '];
  else
    dec_str = '0';
  end
  dec_str = [ sign_val dec_str ];
  
elseif abs(val) >= 0.1
  sign_val = '';
  if val < 0
    sign_val = '-';
  end
  val = abs(val);
  dec_str = num2str( val, ndig );
  if isempty( strfind( dec_str,'.') )
    dec_str = [ dec_str '.0'];
  end
  while numel(dec_str) < (ndig+2)
    dec_str(end+1) = '0';              %#ok<AGROW>
  end
  if ~isempty(sign_val)
    dec_str = [ sign_val  dec_str ];
  end
  dec_str = [ dec_str ' '];
end

return


function dec_str = local_ndig_str( dec_str, ndig )
  if ( numel(dec_str) < ndig ) ...
    ||( ( numel(dec_str) == ndig ) && ~isempty( strfind( dec_str,'.') ) )
    if isempty( strfind( dec_str,'.') )
      dec_str = [ dec_str '.'];
    end
    while numel(dec_str) < (ndig+1)
      dec_str = [ dec_str '0']; %#ok<AGROW>
    end
  end
return


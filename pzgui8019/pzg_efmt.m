function  gain_str = pzg_efmt( gain, ndig )
%       value_str = pzg_efmt( value, nr_digits );
% Returns formatted string for a complex number, in power-of-ten 
% notation when appropriate, rounded to the specified number of digits.

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

  gain_str = '';
  
  if ~nargin
    return
  elseif nargin < 2
    ndig = 4;
  elseif ~isreal(ndig) || ( ndig < 0 ) || ~isequal( ndig, round(ndig) )
    ndig = 4;
  end
  ndig = max( 1, ndig );
  if isnumeric(gain) && numel(gain) > 1
    gain_str = cell(size(gain));
    for k = 1:numel(gain)
      gain_str{k} = pzg_efmt( gain(k), ndig );
    end
    return
  end
  
  if isempty(gain)
    return
  elseif ~isnumeric(gain)
    disp('pzg_efmt:  Input argument must be numeric.')
    return
  elseif isequal( gain, 0 )
    gain_str = '0';
    return
  elseif isnan(gain)
    gain_str = 'NaN';
    return
  elseif isinf(gain)
    gain_str = 'Inf';
    return
  end
  
  if ~isreal(gain)
    real_str = local_num2str( real(gain), ndig );
    imag_str = local_num2str( abs(imag(gain)), ndig );
    if imag(gain) > 0
      gain_str = [ real_str '+' imag_str 'i' ];
    elseif imag(gain) < 0
      gain_str = [ real_str '-' imag_str 'i' ];
    else
      gain_str = real_str;
    end
  else
    gain_str = local_num2str( gain, ndig );
  end
  
return



function gain_str = local_num2str( gain, ndig )

  if isequal( gain, 0 )
    gain_str = '0';
    return
  end
  
  neg_gain = 0;
  if gain < 0
    neg_gain = 1;
    gain = abs(gain);
  end
  
  scale10 = floor( log10(gain) );
  scaled_gain = gain/10^scale10;
  rounded_scaled_gain = round( scaled_gain * 10^(ndig-1) ) / 10^(ndig-1);
  gain = rounded_scaled_gain * 10^scale10;
  
  if ( abs(gain) < 1e5 ) && ( abs(gain) >= (1e-1-100*eps) ) ...
    && ( abs( gain - str2double( num2str(gain,ndig) ) )/abs(gain) ...
         < max( 100*eps, 10^(-2*ndig) ) )
    gain_str = num2str(gain,ndig);
    if isempty( strfind( gain_str,'e') )
      if neg_gain
        gain_str = [ '-' gain_str ];
      end
      return
    end
  end
  gain_str = num2str( gain,['%10.' num2str(ndig) 'e']);
  while ~isempty( strfind( gain_str,'e+0') )
    e_ndx = strfind( gain_str,'e+0');
    gain_str(e_ndx+2) = '';
    if numel(gain_str) == ( e_ndx + 1 )
      gain_str = gain_str(1:e_ndx-1);
    end
  end
  while ~isempty( strfind( gain_str,'e-0') )
    e_ndx = strfind( gain_str,'e-0');
    gain_str(e_ndx+2) = '';
    if numel(gain_str) == ( e_ndx + 1 )
      gain_str = gain_str(1:e_ndx-1);
    end
  end
  if ~isempty( strfind( gain_str,'e') )
    e_ndx = strfind( gain_str,'e');
    e_str = gain_str(e_ndx:end);
  else
    e_ndx = numel(gain_str+1);
    e_str = '';
  end
  if ~isempty( strfind( gain_str,'.') )
    pt_ndx = strfind( gain_str,'.');
    prept_str = gain_str(1:pt_ndx);
  else
    pt_ndx = 0;
    prept_str = '';
  end
  frac_part = gain_str(pt_ndx+1:e_ndx-1);
  while ~isempty(frac_part) && strcmp( frac_part(end),'0')
    frac_part(end) = '';
  end
  if isempty(frac_part) && strcmp( prept_str(end),'.')
    prept_str(end) = '';
  end
  gain_str = [ prept_str frac_part e_str ];
  
  if neg_gain
    gain_str = [ '-' gain_str ];
  end

return

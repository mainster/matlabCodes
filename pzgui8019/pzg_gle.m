function  gle_ndx = pzg_gle( monovec, val, direc )
%        gle_ndx = pzg_gle( monovec, value, direction )
% where
%     monovec    is a vector of real-valued non-decreasing values
%     value      is a scalar real-valued comparison value
%     direction  is either '<', '<=', '>', '>=', or 'near'
% Identifies the index of the element in "monovec" that is closest to
% "value", according to the specified "direction".
% The return index can be empty, except when direction=='near'.

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

gle_ndx = [];

if ( nargin < 3 ) ...
  || ~ischar(direc) || ~ismember( direc,{'<','<=','>','>=','near'}) ...
  || ~isreal(val) || ( numel(val) ~= 1 ) ...
  || ~isreal(monovec) || isempty(monovec) || ( monovec(end) < monovec(1) )
  return
end

max_ndx = numel(monovec);

switch direc
  case '=='
    eq_ndx = find( monovec == val );
    if isempty(eq_ndx)
      gle_ndx = [];
    else
      gle_ndx = eq_ndx(1);
    end
    
  case {'<','<=','near'}
    if ( monovec(end) <= val ) && ~strcmp( direc,'<')
      gle_ndx = max_ndx;
      return
    elseif ( monovec(end) < val ) && strcmp( direc,'<')
      gle_ndx = max_ndx;
      return
    elseif monovec(1) >= val
      if strcmpi( direc,'near') || strcmpi( direc,'<=')
        gle_ndx = 1;
      else
        gle_ndx = [];
      end
      return
    end
    if max_ndx == 1
      gle_ndx = 1;
      return
    end
    
    div_ndx = ceil( max_ndx/2 );
    delta_ndx = div_ndx;
    max_cuts = 3 + round( log(max_ndx) / log(2) );
    nr_cuts = 0;
    while ( ( monovec(div_ndx) >= val ) ...
           ||( monovec(div_ndx+1) < val ) ) ...
         && ( nr_cuts < max_cuts )
      delta_ndx = max( 1, ceil(delta_ndx/2) );
      if monovec(div_ndx) > val
        div_ndx = max( 1, div_ndx - delta_ndx );
      elseif monovec(div_ndx+1) < val
        div_ndx = min( max_ndx-1, div_ndx + delta_ndx );
      end
      nr_cuts = nr_cuts + 1;
    end
    if strcmp( direc,'<')
      if monovec(div_ndx) >= val
        div_ndx = max( 1, div_ndx-1 );
      end
    elseif strcmp( direc,'<=')
      if monovec(div_ndx) > val
        if div_ndx == 1
          div_ndx = [];
        else
          div_ndx = div_ndx - 1;
        end
      elseif monovec(min(max_ndx,div_ndx+1)) <= val
        div_ndx = min( max_ndx, div_ndx + 1 );
      end
    else % 'near'
      if abs( monovec(div_ndx) - val ) ...
        >abs( monovec(min(max_ndx,div_ndx+1)) - val )
        div_ndx = div_ndx + 1;
      end
    end
    gle_ndx = div_ndx;
    
  case {'>','>='}
    if ( monovec(1) >= val ) && strcmp( direc,'>=')
      gle_ndx = 1;
      return
    elseif ( monovec(1) > val ) && strcmp( direc,'>')
      gle_ndx = 1;
      return
    elseif monovec(end) == val
      if strcmpi( direc,'>=')
        gle_ndx = max_ndx;
      else
        gle_ndx = [];
      end
      return
    end
    if max_ndx == 1
      gle_ndx = 1;
      return
    end
    
    div_ndx = ceil( max_ndx/2 );
    delta_ndx = div_ndx;
    max_cuts = 3 + round( log(max_ndx) / log(2) );
    nr_cuts = 0;
    while ( ( monovec(div_ndx) <= val ) ...
           ||( monovec(min(max_ndx,div_ndx+1)) > val ) ) ...
         && ( nr_cuts < max_cuts )
      delta_ndx = max( 1, ceil(delta_ndx/2) );
      if monovec(div_ndx) < val
        div_ndx = min( max_ndx, div_ndx + delta_ndx );
      elseif monovec(min(max_ndx,div_ndx+1)) > val
        div_ndx = max( 1, div_ndx - delta_ndx );
      end
      nr_cuts = nr_cuts + 1;
    end
    if strcmp( direc,'>')
      if monovec(div_ndx) <= val
        if div_ndx < max_ndx
          div_ndx = min( max_ndx, div_ndx+1 );
        else
          div_ndx = [];
        end
      end
    else % '>='
      if monovec(div_ndx) < val
        if div_ndx == numel(monovec)
          div_ndx = [];
        else
          div_ndx = div_ndx + 1;
        end
      end
    end
    gle_ndx = div_ndx;
    
  otherwise
    gle_ndx = [];
end

return

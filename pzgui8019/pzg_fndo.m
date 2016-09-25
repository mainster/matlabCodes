function these_hndls = ...
            pzg_fndo( dom_ndxs, fig_ndxs, fld_name, obj_tag, obj_type )
% hndls = pzg_fndo( domndx, ploth_ndx, field_name, obj_tag, obj_type );
%
% The first three args are required.
% "domndx" can be 1, 2, or [1,2]; if empty, [1,2] is assumed.
% "ploth_ndx" refers to indexes of cell-array PZG(domndx).plot_h
%   This can be either a single index, or a vector of indexes.
%   Alternatively, ploth_ndx can be a single figure-handle.
% "field_name" is a field name within PZG(domndx).plot_h{ploth_ndx}.hndl
%   or within PZG(domndx).plot_h{ploth_ndx}
%   Function looks for field_name in the following order:
%   First, looks in PZG(domndx).plot_h{ploth_ndx}.hndl 
%   Second if not already found, looks in figure appdata 'hndl';
%   Third, if not already found, looks in PZG(domndx).plot_h{}
%   Finally, if not already found, and if "obj_tag" "obj_type" are args,
%   searches the figures directly using Matlab's "findobj()".
  
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
these_hndls = [];
if ~isfield( PZG,'plot_h')
  return
end

if ( nargin < 5 )
  obj_type = '';
elseif ~ischar(obj_type) || ~isequal( 1, size(obj_type,1) )
  disp('pzg_fndo.m: invalid 5th arg (object-type must be a string)')
  return
end
if ( nargin < 4 )
  obj_tag = '';
elseif ~ischar(obj_tag) || ~isequal( 1, size(obj_tag,1) )
  disp('pzg_fndo.m: invalid 4th arg (tag must be a string)')
  return
end
if ( nargin < 3 )
  return
end
if ~ischar(fld_name) || isempty(fld_name) ...
  || ~isequal( 1, size(fld_name,1) )
  disp('pzg_fndo.m: invalid 3rd arg (field name must be a string)')
  return
end
if isempty(fig_ndxs) || ~isreal(fig_ndxs) ...
  || ~isequal( round(fig_ndxs), fig_ndxs ) ...
  || any( fig_ndxs(:) < 1 ) || any( fig_ndxs > 14 )
  disp('pzg_fndo.m: invalid 2nd arg (plot_h index must be between 1 & 14)')
  return
end
if isempty(dom_ndxs) ...
  ||( ~isequal( dom_ndxs, 1 ) && ~isequal( dom_ndxs, 2 ) ...
     && ~isequal( dom_ndxs(:), [1;2] ) && ~isequal( dom_ndxs(:), [2;1] ) )
  disp('pzg_fndo.m: invalid 1st arg (domain index is either 1 or 2 or both)')
  return
end  

for kdom = 1:numel(dom_ndxs)
  dom_ndx = dom_ndxs(kdom);
  for k_fndx = 1:numel(fig_ndxs)
    ndx = fig_ndxs(k_fndx);
    if ( ndx > numel( PZG(dom_ndx).plot_h ) )...
      || isempty( PZG(dom_ndx).plot_h{ndx} )
     continue
    end
    try
      new_hndls =  PZG(dom_ndx).plot_h{ndx}.hndl.(fld_name);
      is_hndl = ishandle(new_hndls);
      if any( ishandle(is_hndl) )
        new_hndls = new_hndls( is_hndl );
      end
      in_hndl = 1;
    catch
      in_hndl = 0;
      new_hndls = [];
    end
    if ~in_hndl
      try
        new_hndls = PZG(dom_ndx).plot_h{ndx}.(fld_name);
        in_ploth = 1;
        new_hndls = new_hndls( ishandle(new_hndls) );
      catch
        in_ploth = 0;
      end
    else
      in_ploth = 0;
    end
    if ~isempty(obj_tag)
      if ~isempty(obj_type)
        if ( strcmp( obj_type,'line') || strcmp( obj_type,'text') ) ...
          && isfield( PZG(dom_ndx).plot_h{ndx},'ax_h')
          new_hndls = ...
            findobj( PZG(dom_ndx).plot_h{ndx}.ax_h, ...
                    'type', obj_type,'tag', obj_tag );
        else
          new_hndls = ...
            findobj( PZG(dom_ndx).plot_h{ndx}.fig_h, ...
                    'type', obj_type,'tag', obj_tag );
        end
      else
        new_hndls = ...
          findobj( PZG(dom_ndx).plot_h{ndx}.fig_h,'tag', obj_tag );
      end
    end

    if ~isempty(new_hndls)
      if in_ploth
        PZG(dom_ndx).plot_h{ndx}.(fld_name) = new_hndls;
      elseif in_hndl
        PZG(dom_ndx).plot_h{ndx}.hndl.(fld_name) = new_hndls;
      else
        try
          PZG(dom_ndx).plot_h{ndx}.hndl.(fld_name) = new_hndls;
        catch
          disp(['pzg_fndo: can''t write "' fld_name '" handle to "hndl"'])
          disp([' at  plot_h index = ' num2str(ndx) ...
                ', and  domain index = ' num2str(dom_ndx) ])
        end
      end
      these_hndls = [ these_hndls; new_hndls(:) ]; %#ok<AGROW>
    end
  end
end
return

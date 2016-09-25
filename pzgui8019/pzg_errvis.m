function pzg_errvis( fig_h )

% Adjusts the error-line visibility in "tools" plots.

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

if ~nargin
  return
end

if ~ishandle(fig_h) || isempty(fig_h) || ~isequal( 1, numel(fig_h) ) ...
  || ~isappdata( fig_h,'hndl')
  return
end
hndl = getappdata( fig_h,'hndl');
if ~isstruct(hndl) || ~isfield( hndl,'show_io_difference') ...
  || ~isfield( hndl,'input_type_popupmenu')
  return
end
dom_ndx = hndl.dom_ndx;
ploth_ndx = hndl.ploth_ndx;

input_type = get( hndl.input_type_popupmenu,'value');
show_error = get( hndl.show_io_difference,'value');

err_h = [];
if isfield( hndl,'pzgui_resppl_error_line')
  err_h = [ err_h; hndl.pzgui_resppl_error_line(:) ];
end
if isfield( hndl,'error_cursor')
  err_h = [ err_h; hndl.error_cursor(:) ];
end
if isfield( hndl,'parameter_K_effect_line')
  pk_line = hndl.parameter_K_effect_line;
  if numel(pk_line) > 1
    err_h = [ err_h; pk_line(end) ];
  end
end
if isfield( hndl,'parameter_K_effect_prvw_line')
  pk_line = hndl.parameter_K_effect_prvw_line;
  if numel(pk_line) > 1
    err_h = [ err_h; pk_line(end) ];
  end
end

[ curr_tools, toolfig_h, preview_on ] = pzg_tools(dom_ndx);   %#ok<ASGLU>
if any(curr_tools) && preview_on
  if curr_tools(1)
    prvw_h = pzg_fndo( dom_ndx, ploth_ndx,'Gain_Preview');
  elseif curr_tools(2)
    prvw_h = pzg_fndo( dom_ndx, ploth_ndx,'LDLG_Preview');
  else
    prvw_h = pzg_fndo( dom_ndx, ploth_ndx,'PID_Preview');
  end
  if numel(prvw_h) > 1
    err_h = [ err_h; prvw_h(end) ];
  end
end

if ( input_type > 1 ) 
  set( hndl.show_io_difference,'visible','on');
  if show_error
    set( err_h,'visible','on');
  else
    set( err_h,'visible','off');
  end
else
  set( hndl.show_io_difference,'visible','off');  
  set( err_h,'visible','off');
end

return

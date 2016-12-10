function preview_type = pzg_prvw(dom_ndx)
% Update whatever design-tool preview is current.
% All other design-tool preview lines should be made non-visible.

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

preview_type = [];

if ~nargin || ( ~isequal( 1, dom_ndx ) && ~isequal( 2, dom_ndx ) ) 
  disp('pzg_prvw.m error: Requires an input argument.');
  disp('  Valid domain index must be specified (1 or 2).');
  return
elseif isequal( dom_ndx, 1 )
  Domain = 's';
else
  Domain = 'z';
end
% Look for a preview figure.
curr_tools = pzg_tools(dom_ndx);
if ~sum(curr_tools)
  return
end
preview_type = find( curr_tools == 1 );

if isequal( preview_type, 1 )
  these_hndls = pzg_fndo( 1, (1:14),'LDLG_Preview');
  if ~isempty(these_hndls)
    set( these_hndls(:),'visible','off');
  end
  these_hndls = pzg_fndo( 1, (1:14),'PID_Preview');
  if ~isempty(these_hndls)
    set( these_hndls(:),'visible','off');
  end
  gainfilt( [ Domain '-Domain Pure Gain Design GUI'] );
  
elseif isequal( preview_type, 2 )
  these_hndls = pzg_fndo( 1, (1:14),'PureGain_Preview');
  if ~isempty(these_hndls)
    set( these_hndls(:),'visible','off');
  end
  these_hndls = pzg_fndo( 1, (1:14),'PID_Preview');
  if ~isempty(these_hndls)
    set( these_hndls(:),'visible','off');
  end
  ldlgfilt([ Domain '-Domain Lead Lag Design GUI'] );
  
else
  these_hndls = pzg_fndo( 1, (1:14),'PureGain_Preview');
  if ~isempty(these_hndls)
    set( these_hndls(:),'visible','off');
  end
  these_hndls = pzg_fndo( 1, (1:14),'LDLG_Preview');
  if ~isempty(these_hndls)
    set( these_hndls(:),'visible','off');
  end
  pidfilt([ Domain '-Domain PID Design GUI'] );
  
end

return

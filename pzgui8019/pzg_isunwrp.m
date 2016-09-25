function unwrp = pzg_isunwrp( dom_ndx, ploth_ndx )
% Returns the value of "Unwrap" checkbox in specified figure.

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

unwrp = 0;
if ~nargin || isempty(dom_ndx) || ~isreal(dom_ndx) ...
  ||( ~isequal(dom_ndx,1) && ~isequal(dom_ndx,2) ...
     && ~isequal(sort(dom_ndx(:)),[1;2]) )
  dom_ndx = (1:2);
end
if ( nargin < 2 ) || isempty(ploth_ndx) ...
  || ~isreal(ploth_ndx) ...
  || ~isequal( round(ploth_ndx), ploth_ndx )
  ploth_ndx = [2;4];
end  
ploth_ndx = ploth_ndx( ( ploth_ndx == 2 ) & ( ploth_ndx == 4 ) );
if isempty(ploth_ndx)
  ploth_ndx = [2;4];
end
  
unwrp_cb_h = pzg_fndo( dom_ndx, ploth_ndx,'UnwrapChkbox');
if ~isempty(unwrp_cb_h)
  unwrp = get( unwrp_cb_h(1),'value');
end

return

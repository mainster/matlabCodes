function pzg_bodex( dom_ndx )

% Adjusts FRF plot x-axes highlight lines.

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
ploth_ndxs = pzg_fndo( dom_ndx,(1:5),'ploth_ndx');
for kp = 1:numel(ploth_ndxs)
  k = ploth_ndxs(kp);
  if k < 3
    x_lims = PZG(dom_ndx).BodeFreqs([1,end]);
  else
    x_lims = PZG(dom_ndx).CLBodeFreqs([1,end]);
  end
  if pzg_ishzx
    x_lims = x_lims/2/pi;
  end
  if any( [1;3;5] == k )
    xhilite_h = pzg_fndo( dom_ndx, k,'unity_gain_line');
    if ~isempty(xhilite_h)
      set( xhilite_h,'xdata', x_lims );
    end
    xzero_h = pzg_fndo( dom_ndx, k,'zero_gain_line');
    if ~isempty(xzero_h)
      set( xzero_h,'xdata', x_lims );
    end
  else
    xhilite_h = ...
      [ pzg_fndo( dom_ndx, k,'zero_degree_line') ; ...
        pzg_fndo( dom_ndx, k,'negative_180degree_line'); ...
        pzg_fndo( dom_ndx, k,'positive_180degree_line') ];
    if ~isempty(xhilite_h)
      set( xhilite_h,'xdata', x_lims );
    end
  end
end

return

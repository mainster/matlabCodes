function pzg_reptxt( dom_ndx, x_lim, y_lim )
% If any repeated pole/zero text in the contour plot, adjust its position.

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

reptext_h = [ pzg_fndo( dom_ndx, 14,'contour_reppole_text'); ...
              pzg_fndo( dom_ndx, 14,'contour_repzero_text') ];
for krp = 1:numel(reptext_h)
  this_pseudo_loc = get( reptext_h(krp),'userdata');
  this_pos = get( reptext_h(krp),'position');
  if dom_ndx == 1
    this_pos(1) = -0.1*diff(x_lim);
    if imag(this_pseudo_loc) > 0
      this_pos(2) = imag(this_pseudo_loc) + 0.025*diff(y_lim);
    else
      this_pos(2) = imag(this_pseudo_loc) - 0.025*diff(y_lim);
    end
  else
    if ( imag(this_pseudo_loc) > 0 ) ...
      && ( real(this_pseudo_loc) > 0 ) % 1st quadrant
      new_cplx_pos = ...
        real(this_pseudo_loc)-0.08*diff(x_lim) ...
        +1i*( imag(this_pseudo_loc)-0.05*diff(y_lim) );
    elseif ( imag(this_pseudo_loc) > 0 ) ...
      && ( real(this_pseudo_loc) < 0 ) % 2nd quadrant
      new_cplx_pos = ...
        real(this_pseudo_loc)+0.01*diff(x_lim) ...
        +1i*( imag(this_pseudo_loc)-0.05*diff(y_lim) );
    elseif ( imag(this_pseudo_loc) < 0 ) ...
      && ( real(this_pseudo_loc) < 0 ) % 3rd quadrant
      new_cplx_pos = ...
        real(this_pseudo_loc)+0.01*diff(x_lim) ...
        +1i*( imag(this_pseudo_loc)+0.05*diff(y_lim) );
    else                               % 4th quadrant
      new_cplx_pos = ...
        real(this_pseudo_loc)-0.08*diff(x_lim) ...
        +1i*( imag(this_pseudo_loc)+0.05*diff(y_lim) );
    end
    this_pos = [ real(new_cplx_pos), imag(new_cplx_pos), 0 ];
  end
  set( reptext_h(krp),'position', this_pos );
end

return

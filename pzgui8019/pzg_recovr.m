function ok = pzg_recovr
% Recover the PZG global data from userdata in front-panel object.

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

ok = 1;
if isempty(PZG)
  ok = 0;
  verrel_h = findobj( allchild(0),'style','text','tag','pzgui ver & rel');
  if isempty(verrel_h)
    return
  else
    PZG = get(verrel_h(1),'userdata');
    pzgui_plots_h = findobj( allchild(0),'tag','PZGUI plot');
    delete(pzgui_plots_h)
    for k = 1:2
      for m = [(1:11),14]
        PZG(k).plot_h{m} = [];
      end
    end
    if ~isempty( PZG(1).plot_h{12} ) ...
      &&( ~isfield( PZG(1).plot_h{12},'fig_h') ...
         || ~isfield( PZG(1).plot_h{12},'ax_h') ...
         || ~isequal( 1, ishandle(PZG(1).plot_h{12}.fig_h) ) )
      PZG(1).plot_h{12} = [];
      PZG(2).plot_h{12} = [];
    elseif ~isempty( PZG(1).plot_h{12} )
      PZG(2).plot_h{12} = PZG(1).plot_h{12};
      set( PZG(1).plot_h{12}.hndl.OLbode_checkbox,'value', 0 );
      set( PZG(1).plot_h{12}.hndl.CLbode_checkbox,'value', 0 );
      set( PZG(1).plot_h{12}.hndl.Nichols_checkbox,'value', 0 );
      set( PZG(1).plot_h{12}.hndl.Nyquist_checkbox,'value', 0 );
      set( PZG(1).plot_h{12}.hndl.OLresp_checkbox,'value', 0 );
      set( PZG(1).plot_h{12}.hndl.CLresp_checkbox,'value', 0 );
      set( PZG(1).plot_h{12}.hndl.RtLoc_checkbox,'value', 0 );
      set( PZG(1).plot_h{12}.hndl.Sensitivity_checkbox,'value', 0 );
    end
    if ~isempty( PZG(2).plot_h{13} ) ...
      &&( ~isfield( PZG(2).plot_h{13},'fig_h') ...
         || ~isfield( PZG(2).plot_h{13},'ax_h') ...
         || ~isequal( 1, ishandle(PZG(1).plot_h{13}.fig_h) ) )
      PZG(1).plot_h{13} = [];
      PZG(2).plot_h{13} = [];
    elseif ~isempty( PZG(2).plot_h{13} )
      PZG(1).plot_h{13} = PZG(2).plot_h{13};
      set( PZG(2).plot_h{13}.hndl.OLbode_checkbox,'value', 0 );
      set( PZG(2).plot_h{13}.hndl.CLbode_checkbox,'value', 0 );
      set( PZG(2).plot_h{13}.hndl.Nichols_checkbox,'value', 0 );
      set( PZG(2).plot_h{13}.hndl.Nyquist_checkbox,'value', 0 );
      set( PZG(2).plot_h{13}.hndl.OLresp_checkbox,'value', 0 );
      set( PZG(2).plot_h{13}.hndl.CLresp_checkbox,'value', 0 );
      set( PZG(2).plot_h{13}.hndl.RtLoc_checkbox,'value', 0 );
      set( PZG(2).plot_h{13}.hndl.Sensitivity_checkbox,'value', 0 );
    end
    if isempty(PZG(1).plot_h{12}) && isempty(PZG(2).plot_h{13})
      return
    else
      evalin('base','global PZG')
      ok = 1;
    end
  end
end

return

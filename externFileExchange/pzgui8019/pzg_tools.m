function [ which_tool, toolfig_h, preview ] = pzg_tools(dom_ndx)
% Call format:  
%   [ which_tools, toolfig_h, preview_on ] = pzg_tools( domain_ndx )
% where
%        domain_ndx == 1 for continuous-time, domain_ndx == 2 for discrete-time
% and
%        current_tools is 3x1 indicator of which design tool is open
%                     [ gain_tool   leadlag_tool   pid_tool ]'
%              in which each element is either 1 or 0, 
%                 and 1 indicates the corresponding tool is open.

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
which_tool = zeros(3,1);
toolfig_h = [];
preview = 0;
if isempty(PZG) && ~pzg_recovr 
  return
end

if ~nargin ...
  ||( ~isequal(dom_ndx,1) && ~isequal(dom_ndx,2) )
  return
end

if isfield(PZG(dom_ndx),'Gain_fig') ...
  && ~isempty(PZG(dom_ndx).Gain_fig) ...
  && isequal( 1, ishandle(PZG(dom_ndx).Gain_fig) )
  which_tool(1) = 1;
  toolfig_h = PZG(dom_ndx).Gain_fig;
else
  PZG(dom_ndx).Gain_fig = [];
end
if isfield(PZG(dom_ndx),'LDLG_fig') ...
  && ~isempty(PZG(dom_ndx).LDLG_fig) ...
  && isequal( 1, ishandle(PZG(dom_ndx).LDLG_fig) )
  which_tool(2) = 1;
  toolfig_h = PZG(dom_ndx).LDLG_fig;
else
  PZG(dom_ndx).LDLG_fig = [];
end
if isfield(PZG(dom_ndx),'PID_fig') ...
  && ~isempty(PZG(dom_ndx).PID_fig) ...
  && isequal( 1, ishandle(PZG(dom_ndx).PID_fig) )
  which_tool(3) = 1;
  toolfig_h = PZG(dom_ndx).PID_fig;
else
  PZG(dom_ndx).PID_fig = [];
end

if ~isempty(toolfig_h)
  hndl = getappdata( toolfig_h,'hndl');
  if isfield( hndl,'clear_preview_pushbutton');
    if strcmp( get( hndl.clear_preview_pushbutton,'visible'),'on')
      preview = 1;
    end
  end
end

return

function  pzg_unre
% Cleans up the "undo" and "redo" stacks in pzgui.

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
if isempty(PZG) && ~pzg_recovr 
  return
end

CT_PZGUI = pzg_fndo( 1, 12,'fig_h');
DT_PZGUI = pzg_fndo( 2, 13,'fig_h');

if ~isempty(CT_PZGUI)
  filemenu_h = pzg_fndo( 1, 12,'file_menu');
  if strcmp( get( filemenu_h,'enable'),'on')
    curr_info = [];
    curr_info.PoleLocs = PZG(1).PoleLocs;
    curr_info.ZeroLocs = PZG(1).ZeroLocs;
    curr_info.Gain = PZG(1).Gain;
    curr_info.Ts = PZG(1).Ts;
    curr_info.PureDelay = PZG(1).PureDelay;
    curr_info.DCgain = PZG(1).DCgain;
    if isfield( PZG(1),'undo_info') && ~isempty(PZG(1).undo_info)
      if local_equal_strucs( PZG(1).undo_info{end}, curr_info )
        PZG(1).undo_info(end) = [];
      end
    end
    if isfield( PZG(1),'redo_info') && ~isempty(PZG(1).redo_info)
      if local_equal_strucs( PZG(1).redo_info{end}, curr_info )
        PZG(1).redo_info(end) = [];
      end
    end
    
    if ~isfield(PZG(1),'undo_info')
      PZG(1).undo_info = {};
    end
    for k = numel(PZG(1).undo_info):-1:2
      if local_equal_strucs( PZG(1).undo_info{k}, PZG(1).undo_info{k-1} )
        PZG(1).undo_info(k) = [];
      end
    end
    if isfield(PZG(1),'redo_info')
      for k = numel(PZG(1).redo_info):-1:2
        if local_equal_strucs( PZG(1).redo_info{k}, PZG(1).redo_info{k-1} )
          PZG(1).redo_info(k) = [];
        end
      end
    end
    
    undo_h = pzg_fndo( 1, 12,'pzgui_UNDO_pushbutton');
    if isfield( PZG(1),'undo_info') && ~isempty(PZG(1).undo_info)
      set( undo_h,'enable','on')
    else
      set( undo_h,'enable','off')
    end
    redo_h = pzg_fndo( 1, 12,'pzgui_REDO_pushbutton');
    if isfield( PZG(1),'redo_info') && ~isempty(PZG(1).redo_info)
      set( redo_h,'enable','on')
    else
      set( redo_h,'enable','off')
    end
  end
end

if ~isempty(DT_PZGUI)
  filemenu_h = pzg_fndo( 2, 13,'file_menu');
  if strcmp( get( filemenu_h,'enable'),'on')
    curr_info = [];
    curr_info.PoleLocs = PZG(2).PoleLocs;
    curr_info.ZeroLocs = PZG(2).ZeroLocs;
    curr_info.Gain = PZG(2).Gain;
    curr_info.Ts = PZG(2).Ts;
    curr_info.PureDelay = PZG(2).PureDelay;
    curr_info.DCgain = PZG(2).DCgain;
    if isfield( PZG(2),'undo_info') && ~isempty(PZG(2).undo_info)
      if local_equal_strucs( PZG(2).undo_info{end}, curr_info )
        PZG(2).undo_info(end) = [];
      end
    end
    if isfield( PZG(2),'redo_info') && ~isempty(PZG(2).redo_info)
      if local_equal_strucs( PZG(2).redo_info{end}, curr_info )
        PZG(2).redo_info(end) = [];
      end
    end
    
    if ~isfield(PZG(2),'undo_info')
      PZG(2).undo_info = {};
    end
    for k = numel(PZG(2).undo_info):-1:2
      if local_equal_strucs( PZG(2).undo_info{k}, PZG(2).undo_info{k-1} )
        PZG(2).undo_info(k) = [];
      end
    end
    if isfield(PZG(1),'redo_info')
      for k = numel(PZG(2).redo_info):-1:2
        if local_equal_strucs( PZG(2).redo_info{k}, PZG(2).redo_info{k-1} )
          PZG(2).redo_info(k) = [];
        end
      end
    end
    
    undo_h = pzg_fndo( 2, 13,'dpzgui_UNDO_pushbutton');
    if isfield( PZG(2),'undo_info') && ~isempty(PZG(2).undo_info)
      set( undo_h,'enable','on')
    else
      set( undo_h,'enable','off')
    end
    redo_h = pzg_fndo( 2, 13,'dpzgui_REDO_pushbutton');
    if isfield( PZG(2),'redo_info') && ~isempty(PZG(2).redo_info)
      set( redo_h,'enable','on')
    else
      set( redo_h,'enable','off')
    end
  end
end

return

function equal_strucs = local_equal_strucs( struc1, struc2 )
  equal_strucs = 0;
  if ~isstruct(struc1) || ~isstruct(struc1)
    return
  end
  fields1 = fieldnames(struc1);
  fields2 = fieldnames(struc2);
  if numel( intersect( fields1, fields2 ) ) ~= numel( fields1 )
    return
  end
  for k = 1:numel( fields1 )
    fn = fields1{k};
    if ~isempty(struc1.(fn)) || ~isempty(struc2.(fn))
      if ~isequal( isempty(struc1.(fn)), isempty(struc2.(fn)) ) ...
        ||( numel( struc1.(fn) ) ~= numel( struc2.(fn) ) ) ...
        ||( max( max( abs( struc1.(fn) - struc2.(fn) ) ) ) ...
            > 1e-10*max(max(abs( struc1.(fn) ))) )
        return
      end
    end
  end
  % If execution reaches here, structures are essentially equal.
  equal_strucs = 1;
return

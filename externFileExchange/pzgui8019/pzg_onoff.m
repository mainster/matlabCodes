function pzg_onoff( ui_on )
% Disables or enables PZGUI and DPZGUI UI-controls

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
global PZG PZMoving
PZMoving = 0;
if isempty(PZG)
  return
end

if ~nargin || ~isnumeric(ui_on) || ~isequal( numel(ui_on), 1 )
  ui_on = 1;
end

gui_h = [ pzg_fndo( 1, 12,'fig_h'); pzg_fndo( 2, 13,'fig_h') ];
ui_h = findobj( gui_h,'type','uicontrol');

resppl_h = pzg_fndo( (1:2),(8:9),'fig_h');
respui_h = findobj( resppl_h,'type','uicontrol');
stdyst_h = pzg_fndo( (1:2),(8:9),'pzgui_resppl_steadystate_only_checkbox'); 

other_h = [];
new_h = pzg_fndo( (1:2),6,'rlocuspl_gain_text');
if ~isempty(new_h)
  other_h = [ other_h; new_h( ishandle(new_h) ) ];
end
if ~isempty(new_h)
  other_h = [ other_h; new_h( ishandle(new_h) ) ];
end
new_h = pzg_fndo( (1:2),6,'rlocuspl_apply_gain');
if ~isempty(new_h)
  other_h = [ other_h; new_h( ishandle(new_h) ) ];
end
new_h = pzg_fndo( (1:2),7,'nyq_movie_pushbutton');
if ~isempty(new_h)
  other_h = [ other_h; new_h( ishandle(new_h) ) ];
end
new_h = pzg_fndo( (1:2),[1;3],'BodeDBChkbox');
if ~isempty(new_h)
  other_h = [ other_h; new_h( ishandle(new_h) ) ];
end
new_h = pzg_fndo( (1:2),[2;4],'UnwrapChkbox');
if ~isempty(new_h)
  other_h = [ other_h; new_h( ishandle(new_h) ) ];
end
new_h = pzg_fndo( (1:2),(1:5),'BodeHZChkbox');
if ~isempty(new_h)
  other_h = [ other_h; new_h( ishandle(new_h) ) ];
end
new_h = pzg_fndo( (1:2),(1:5),'BodeAxesLinLogChkbox');
if ~isempty(new_h)
  other_h = [ other_h; new_h( ishandle(new_h) ) ];
end
new_h = pzg_fndo([1;2],(1:14),'file_menu');
if ~isempty(new_h)
  other_h = [ other_h; new_h( ishandle(new_h) ) ];
end
new_h = pzg_fndo([1;2],(1:14),'mdl_menu');
if ~isempty(new_h)
  other_h = [ other_h; new_h( ishandle(new_h) ) ];
end
new_h = pzg_fndo([1;2],(1:14),'tool_menu');
if ~isempty(new_h)
  other_h = [ other_h; new_h( ishandle(new_h) ) ];
end
new_h = pzg_fndo([1;2],(1:14),'help_menu');
if ~isempty(new_h)
  other_h = [ other_h; new_h( ishandle(new_h) ) ];
end
    
if ui_on
  set( ui_h,'enable','on');
  for k = 1:numel(gui_h)
    if strcmpi( get(gui_h(k),'name'), PZG(1).PZGUIname )
      domndx = 1;
    else
      domndx = 2;
    end
    if ~isfield( PZG(domndx),'undo_info') || isempty( PZG(domndx).undo_info )
      undo_h = findobj( gui_h(k),'string','Undo');
      if ~isempty(undo_h)
        set( undo_h,'enable','off')
      end
    end
    if ~isfield( PZG(domndx),'redo_info') || isempty( PZG(domndx).redo_info )
      redo_h = findobj( gui_h(k),'string','Redo');
      if ~isempty(redo_h)
        set( redo_h,'enable','off')
      end
    end
  end
  for k = 1:numel(other_h)
    if isequal( 1, ishandle(other_h(k)) )
      set( other_h(k),'enable','on')
    end
  end
  for k = 1:numel(respui_h)
    if isequal( 1, ishandle(respui_h(k)) )
      set( respui_h(k),'enable','on')
    end
  end
  for k = 1:numel(stdyst_h)
    % Max time control disabled if showing only steady-state.
    if get(stdyst_h(k),'value') ...
      && strcmp('on',get(stdyst_h(k),'visible') )
      temp0 = get( get(stdyst_h(k),'parent'),'userdata');
      set( temp0(2,2),'enable','off');
    end
  end
  
else
  set( ui_h,'enable','off');
  for k = 1:numel(other_h)
    if isequal( 1, ishandle(other_h(k)) )
      set( other_h(k),'enable','off')
    end
  end
  for k = 1:numel(respui_h)
    if isequal( 1, ishandle(respui_h(k)) )
      set( respui_h(k),'enable','off')
    end
  end
end

return

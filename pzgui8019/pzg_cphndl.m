function pzg_cphndl( fig_h, dom_ndx, ploth_ndx )

% Call format:
%    pzg_cphndl( fig_h, dom_ndx, ploth_ndx )
%
% Copy all fields in the figure fig_h appdata 'hndl' 
% to PZG{domndx).plot_h{ploth_ndx}.hndl
% fig_h, dom_ndx, and ploth_ndx must all be single elements.
%
% Third arg, ploth_ndx, is optional.
% If no ploth_ndx is specified, plot_h{}.fig_h is searched for a match.
% This takes longer, but sometimes the index is not easily determined.
%
% If ploth_ndx IS specified but plot_h{ploth_ndx} is empty,
% the appropriate cell contents will be created.

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

if isfield(PZG,'PoleLocs')
  if ~isfield( PZG(dom_ndx),'plot_h')
    PZG(dom_ndx).plot_h = cell(14,1);
  elseif numel(PZG(dom_ndx).plot_h) < 14
    PZG(dom_ndx).plot_h = ...
      [ PZG(dom_ndx).plot_h(:), ...
        cell( 14-numel(PZG(dom_ndx).plot_h), 1 ) ];
  end
else
  disp('Invalid pzgui global variable, "PZG"')
  return
end

if nargin < 2
  disp('Must have at least two input args calling "pzg_cphndl.m"')
  return
end
if ~isequal( dom_ndx, 1 ) && ~isequal( dom_ndx, 2 )
  disp('Invalid input arg domain index calling "pzg_cphndl.m"')
  return
end
if  ~isequal( numel(fig_h), 1 ) || ~isequal( 1, ishandle(fig_h) )
  disp('"pzg_cphndl.m": input arg "fig_h" is not a valid figure handle')
  return
end

if ( nargin < 3 ) || ~isequal( numel(ploth_ndx), 1 ) ...
  || ~isreal(ploth_ndx) || ~isequal( ploth_ndx, round(ploth_ndx) ) ...
  || ( ploth_ndx < 1 ) || ( ploth_ndx > 14 )
  ploth_ndx = [];
end
if isempty(ploth_ndx)
  for k = 1:numel(PZG(dom_ndx).plot_h)
    if ~isempty(PZG(dom_ndx).plot_h{k}) ...
      && isfield( PZG(dom_ndx).plot_h{k},'fig_h') ...
      && isequal( fig_h, PZG(dom_ndx).plot_h{k}.fig_h )
      ploth_ndx = k;
      break
    end
  end
  if isempty(ploth_ndx)
    disp('"pzg_cphndl.m": invalid input arg, plot_h index')
    return
  end
end

if ~isappdata( fig_h,'hndl')
  disp(['"pzg_cphndl.m": figure has no appdata to copy, ndx=' ...
         num2str(ploth_ndx)])
  return
end
hndl = getappdata( fig_h,'hndl');
if isempty(hndl) || ~isfield( hndl,'ax')
  disp(['"pzg_cphndl.m": appdata not recognized, ndx=' num2str(ploth_ndx)])
  return
end

if any( ploth_ndx == (10:13) )
  % The main GUIs (C-T and D-T) are kept in plot_h in both elements of PZG().
  domndxs = [1;2];
else
  domndxs = dom_ndx;
end
  
mod_hndl = 0;
for kdom = 1:numel(domndxs)
  dndx = domndxs(kdom);
  
  PZG(dndx).plot_h{ploth_ndx}.fig_h = fig_h;
  PZG(dndx).plot_h{ploth_ndx}.plot_name = hndl.plot_name;
  PZG(dndx).plot_h{ploth_ndx}.ax_h = hndl.ax;
  
  if isfield( hndl,'BodeDBChkbox')
    PZG(dndx).plot_h{ploth_ndx}.dB_cb = get(hndl.BodeDBChkbox,'value');
  end
  if isfield( hndl,'BodeHZChkbox')
    PZG(dndx).plot_h{ploth_ndx}.Hz_cb = get(hndl.BodeHZChkbox,'value');
  end
  if isfield( hndl,'BodeAxesLinLogChkbox')
    PZG(dndx).plot_h{ploth_ndx}.Log_cb = ...
      get(hndl.BodeAxesLinLogChkbox,'value');
  end
  if isfield( hndl,'UnwrapChkbox')
    PZG(dndx).plot_h{ploth_ndx}.unwrap_cb = get(hndl.UnwrapChkbox,'value');
  end

  PZG(dndx).plot_h{ploth_ndx}.neg_freq = 0;
  if isfield( hndl,'ax_xlim')
    PZG(dndx).plot_h{ploth_ndx}.xlim = hndl.ax_xlim;
  end
  if isfield( hndl,'ax_ylim')
    PZG(dndx).plot_h{ploth_ndx}.ylim = hndl.ax_ylim;
  else
    disp(['"hndl" is missing field "ax_ylim" for ndx ' num2str(ploth_ndx)])
  end
  if ~isfield( PZG(dndx).plot_h{ploth_ndx},'CurrPt')
    PZG(dndx).plot_h{ploth_ndx}.CurrPt = [];
  end

  PZG(dndx).ax_h = hndl.ax;
  if isstruct(hndl) && isfield( hndl,'ax_xlim')
    PZG(dndx).plot_h{ploth_ndx}.xlim = hndl.ax_xlim;
  end
  if isstruct(hndl) && isfield( hndl,'ax_ylim')
    PZG(dndx).plot_h{ploth_ndx}.ylim = hndl.ax_ylim;
  else
    disp(['"hndl" is missing field "ax_ylim" for ndx ' num2str(ploth_ndx)])
  end
  
  if ( ~isfield( PZG(dndx).plot_h{ploth_ndx},'hndl') ...
      || isempty(PZG(dndx).plot_h{ploth_ndx}.hndl) ) ...
    && ~isempty(hndl) && isstruct(hndl) && isfield( hndl,'file_menu')
    PZG(dndx).plot_h{ploth_ndx}.hndl = hndl;
  elseif isstruct(hndl)
    hndl_fn = fieldnames(hndl);
    for k = 1:numel(hndl_fn)
      PZG(dndx).plot_h{ploth_ndx}.hndl.(hndl_fn{k}) = hndl.(hndl_fn{k});
    end
  end
  
  if ~isfield( PZG(dndx).plot_h{ploth_ndx}.hndl,'parameter_K_effect_line')
    PZG(dndx).plot_h{ploth_ndx}.hndl.parameter_K_effect_line = [];
    hndl.parameter_K_effect_line = [];
    mod_hndl = 1;
  end
  
  if ploth_ndx == 6
    PZG(dndx).plot_h{ploth_ndx}.nyq_data_cb = 0;
    if isfield( hndl,'show_nyq_mapping_checkbox')
      PZG(dndx).plot_h{ploth_ndx}.nyq_data_cb = ...
        get( hndl.show_nyq_mapping_checkbox,'value');
    end
    PZG(dndx).plot_h{ploth_ndx}.cl_grid_cb = 1;
    if isfield( hndl,'CL_mag_phase_grid_checkbox')
      PZG(dndx).plot_h{ploth_ndx}.cl_grid_cb = ...
        get( hndl.CL_mag_phase_grid_checkbox,'value');
    end
    PZG(dndx).plot_h{ploth_ndx}.hilite_cb = 0;
    if isfield( hndl,'Nichols_hilite_cursor_checkbox')
      PZG(dndx).plot_h{ploth_ndx}.hilite_cb = ...
        get( hndl.Nichols_hilite_cursor_checkbox,'value');
    end
  elseif ploth_ndx == 7
    PZG(dndx).plot_h{ploth_ndx}.hybrid_scaling_cb = 0;
    if isfield( hndl,'rescale_checkbox')
      PZG(dndx).plot_h{ploth_ndx}.hybrid_scaling_cb = ...
        get( hndl.rescale_checkbox,'value');
    end
  end
  
  if ( ploth_ndx ~= 8 ) && ( ploth_ndx ~= 9 )
    if ~isfield( PZG(dndx).plot_h{ploth_ndx},'mm_line_h')
      PZG(dndx).plot_h{ploth_ndx}.mm_line_h = [];
    end
    if ~isfield( PZG(dndx).plot_h{ploth_ndx},'mm_mark_h')
      PZG(dndx).plot_h{ploth_ndx}.mm_mark_h = [];
    end
    if ~isfield( PZG(dndx).plot_h{ploth_ndx},'mm_mag_h')
      PZG(dndx).plot_h{ploth_ndx}.mm_mag_h = [];
    end
    if ~isfield( PZG(dndx).plot_h{ploth_ndx},'mm_phs_h')
      PZG(dndx).plot_h{ploth_ndx}.mm_phs_h = [];
    end
    if ~isfield( PZG(dndx).plot_h{ploth_ndx},'mm_freq_h')
      PZG(dndx).plot_h{ploth_ndx}.mm_freq_h = [];
    end
  end
end

if mod_hndl
  setappdata( fig_h,'hndl', hndl );
end

return

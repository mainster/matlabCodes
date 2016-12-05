function pzg_seltxt( dom_ndx, sel_freq, sel_fig_ndx, neg_freq )
% Services text strings for selected frequency

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

if ( nargin < 1 ) || ( ~isequal(dom_ndx,1) && ~isequal(dom_ndx,2) )
  return
end

if ( nargin < 2 ) ...
  ||( ~isempty(sel_freq) ...
     &&( ~isreal(sel_freq) || ~isequal( 1, numel(sel_freq) ) ) )
  if ~isempty( PZG(dom_ndx).FrqSelNdx ) ...
    && ( PZG(dom_ndx).FrqSelNdx > 0 ) ...
    && ( PZG(dom_ndx).FrqSelNdx <= numel(PZG(dom_ndx).BodeFreqs) )
    sel_freq = PZG(dom_ndx).BodeFreqs( PZG(dom_ndx).FrqSelNdx );
  elseif ~isempty( PZG(dom_ndx).NyqSelNdx ) ...
    && ( PZG(dom_ndx).NyqSelNdx > 0 ) ...
    && ( PZG(dom_ndx).NyqSelNdx ...
         <= numel(PZG(dom_ndx).cntr_data.contour_freq) )
    sel_freq = PZG(dom_ndx).cntr_data.contour_freq( PZG(dom_ndx).NyqSelNdx );
  else
    sel_freq = [];
  end
end

if nargin < 3
  sel_fig_ndx = [];
end
if nargin < 4
  neg_freq = PZG(dom_ndx).NegSelect;
end

plot_h = PZG(dom_ndx).plot_h;
if isempty(sel_freq) || ~PZG(dom_ndx).pzg_show_frf_computation
  local_orig_xaxislabels( plot_h, dom_ndx )
  return
end

if ( nargin < 3 ) || ~isequal( 1, numel(sel_fig_ndx) ) ...
  || ~isreal(sel_fig_ndx) ...
  || ( sel_fig_ndx < 1 ) || ( sel_fig_ndx > 14 ) ...
  || ~isequal( round(sel_fig_ndx), sel_fig_ndx )
  hndl = getappdata( gcbf,'hndl');
  if isfield( hndl,'ploth_ndx')
    sel_fig_ndx = hndl.ploth_ndx;
  else
    sel_fig_ndx = [];
  end
end
if isempty(sel_fig_ndx)
  return
end

if ( nargin < 4 ) || ~isequal( 1, numel(neg_freq) ) ...
  ||( ~isnumeric(neg_freq) && ~isa( neg_freq,'boolean') )
  neg_freq = PZG(dom_ndx).NegSelect;
else
  neg_freq = ~isequal( 0, neg_freq );
end
if sel_fig_ndx < 6
  neg_freq = 0;
end

frequnits = 'rad/s';

if isinf( sel_freq )
  bode_sel_str = '';
else
  if neg_freq && ( dom_ndx == 1 )
    bode_sel_str = '';
  elseif dom_ndx == 2
    bode_sel_freq = mod( abs(sel_freq), 2*pi/PZG(2).Ts );
    if neg_freq && ( bode_sel_freq < pi/PZG(2).Ts )
      bode_sel_freq = 2*pi/PZG(2).Ts - bode_sel_freq;
    end
    bode_sel_str = ...
      ['<select= ' pzg_scifmt( bode_sel_freq, 3 ) frequnits '>    '];
  else
    bode_sel_freq = abs(sel_freq);
    bode_sel_str = ...
      ['<select= ' pzg_scifmt( bode_sel_freq, 3 ) frequnits '>    '];
  end
end
if dom_ndx == 2
  nyq_sel_freq = bode_sel_freq;
  if nyq_sel_freq > pi/PZG(2).Ts
    nyq_sel_freq = abs( nyq_sel_freq - 2*pi/PZG(2).Ts );
  end
else
  nyq_sel_freq = sel_freq;
end
nyq_sel_freq = abs(nyq_sel_freq);
if isinf(nyq_sel_freq)
  nyq_sel_str = '<select= infinite >    ';
else
  if neg_freq
    if strcmp( PZG(1).DefaultBackgroundColor,'k')
      nyq_sel_str = ...
        ['\color[rgb]{0 1 1}<select= -' ...
          pzg_scifmt( nyq_sel_freq, 3 ) frequnits ...
          '>\color[rgb]{1 1 1}    '];
    else
      nyq_sel_str = ...
        ['\color[rgb]{0 0.6 0.6}<select= -' ...
          pzg_scifmt( nyq_sel_freq, 3 ) frequnits ...
          '>\color[rgb]{0 0 0}    '];
    end
  else
    if strcmp( PZG(1).DefaultBackgroundColor,'k')
      nyq_sel_str = ...
        ['\color[rgb]{0 1 1}<select= ' ...
          pzg_scifmt( nyq_sel_freq, 3 ) frequnits ...
          '>\color[rgb]{1 1 1}    '];
    else
      nyq_sel_str = ...
        ['\color[rgb]{0 0.6 0.6}<select= ' ...
          pzg_scifmt( nyq_sel_freq, 3 ) frequnits ...
          '>\color[rgb]{0 0 0}    '];
    end
    %nyq_sel_str = ...
    %  ['<select= ' pzg_scifmt( nyq_sel_freq, 3 ) frequnits '>    '];
  end
end

if strcmp( PZG(1).DefaultBackgroundColor,'k')
  bode_sel_str = ['\color[rgb]{0 1 1}' bode_sel_str '\color[rgb]{1 1 1}'];
else
  bode_sel_str = ['\color[rgb]{0 0.6 0.6}' bode_sel_str '\color[rgb]{0 0 0}'];
end

local_xaxislabels( dom_ndx, plot_h, bode_sel_str, bode_sel_str )

return

function local_orig_xaxislabels( plot_h, dom_ndx )

  hzchk = pzg_ishzx;
  frequnits = ' (rad/s)';
  if hzchk
    frequnits = ' (hertz)';
  end
  for k = 1:numel(plot_h)
    if ~isempty(plot_h{k}) && isstruct(plot_h{k}) ...
      && isfield( plot_h{k},'ax_h') ...
      && isequal( 1, ishandle(plot_h{k}.ax_h) )
      set( plot_h{k}.hndl.ax_xlabel, ...
          'color', 1-get(plot_h{k}.ax_h,'color') )
      if k < 5
        set( plot_h{k}.hndl.ax_xlabel,'string',['Frequency ' frequnits ] );
      elseif k == 6
        set( plot_h{k}.hndl.ax_xlabel,'string','Phase (degrees)');
      elseif k == 7
        set( plot_h{k}.hndl.ax_xlabel,'string','Real Part of FRF');
      elseif ( ( k == 10 ) || ( k == 12 ) || ( k == 14 ) ) && ( dom_ndx == 1 )
        set( plot_h{k}.hndl.ax_xlabel,'string','Real(S), rad/s');
      elseif ( ( k == 11 ) || ( k == 13 ) || ( k == 14 ) ) && ( dom_ndx == 2 )
        set( plot_h{k}.hndl.ax_xlabel,'string','Real(Z)');
      end
    end
  end
return

function local_xaxislabels( dom_ndx, plot_h, bode_sel_str, nyq_sel_str )
  
  global PZG
  
  hzchk = pzg_ishzx;
  frequnits = ' (rad/s)';
  if hzchk
    frequnits = ' (hertz)';
  end
  for k = 1:numel(plot_h)
    if ~isempty(plot_h{k}) && isstruct(plot_h{k}) ...
      && isfield( plot_h{k},'ax_h') ...
      && isequal( 1, ishandle(plot_h{k}.ax_h) )
      set( plot_h{k}.hndl.ax_xlabel, ...
          'color', 1-get(plot_h{k}.ax_h,'color') )
      if k < 6
        set( plot_h{k}.hndl.ax_xlabel, ...
            'string',[ bode_sel_str 'Frequency ' frequnits ] );
      elseif k == 6
        nyq_data_cb_h = findobj( plot_h{6}.fig_h,'string','Nyq Mapping');
        if isempty(nyq_data_cb_h)
          nyq_data_cb = 0;
        else
          nyq_data_cb = get(nyq_data_cb_h(1),'value');
        end
        if nyq_data_cb ...
          ||( ~isempty(bode_sel_str) ...
              && ~PZG(dom_ndx).NegSelect ...
              && isempty( strfind( nyq_sel_str,'-') ) )
          set( plot_h{k}.hndl.ax_xlabel, ...
              'string',[ bode_sel_str 'Phase (degrees)']);
        else
          set( plot_h{k}.hndl.ax_xlabel,'string','Phase (degrees)');
        end
      elseif k == 7
        set( plot_h{k}.hndl.ax_xlabel, ...
            'string',[ bode_sel_str 'Real Part of FRF']);
      elseif ( ( k == 10 ) || ( k == 12 ) || ( k == 14 ) ) && ( dom_ndx == 1 )
        if isempty( strfind( nyq_sel_str,'inf') ) || ( k == 14 )
          set( plot_h{k}.hndl.ax_xlabel, ...
              'string',[ bode_sel_str 'Real(S), rad/s']);
        else
          set( plot_h{k}.hndl.ax_xlabel,'string','Real(S), rad/s');
        end
      elseif ( ( k == 11 ) || ( k == 13 ) || ( k == 14 ) ) && ( dom_ndx == 2 )
        set( plot_h{k}.hndl.ax_xlabel, ...
            'string',[ bode_sel_str 'Real(Z)']);
      end
    end
  end
return


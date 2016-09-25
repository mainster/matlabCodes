function [ pd, plot_h, dom_ndx, fig_h_ndx ] = ...
           freqserv( fig_h, service_button, not_zooming )
% Services frequency-response text info during mouse movement,
% and runs the "Nyquist movie", if active.

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

if nargin && isequal( 1, ishandle(fig_h) ) ...
  && strcmp( get(fig_h,'type'),'figure')
  % Determine the domain and plot_h index.
  figh_hndl = getappdata( fig_h,'hndl');
  fig_h_ndx = figh_hndl.ploth_ndx;
  dom_ndx = figh_hndl.dom_ndx;  
else
  fig_h_ndx = [];
  dom_ndx = [];
end
plot_h = [];
pd = [];
if isempty(PZG) && ~pzg_recovr
  return
end
evalin('base','global PZG')

% Max (normed) distance from nearest line, to be near.
dDst = 0.05;

if nargin < 3
  not_zooming = [];
end

% Not moving a pole or zero, and not in a time-response plot.
temppzmove_h = ...
  [ pzg_fndo( 1,[(1:10),12,14],'pzmove_temporary_line'); ...
    pzg_fndo( 2,[(1:9),11,13,14],'pzmove_temporary_line'); ...
    pzg_fndo( (1:2),(8:9),'pzmove_temporary_forc_line'); ...
    pzg_fndo( (1:2),(8:9),'pzmove_temporary_natl_line'); ...
    pzg_fndo( (1:2),(8:9),'input_cursor'); ...
    pzg_fndo( (1:2),(8:9),'resp_cursor'); ...
    pzg_fndo( (1:2),(8:9),'error_cursor') ];
if ~isempty(temppzmove_h)
  set(temppzmove_h(ishandle(temppzmove_h)),'visible','off')
end

if ~nargin 
  disp([ mfilename ':  No input argument.'])
  return
elseif isempty(fig_h)
  disp([ mfilename ':  Empty figure handle.'])
  return
elseif ischar(fig_h)
  switch lower(fig_h)
    case('refresh_plot_h')
      % In this call, 2nd input arg is figure handle.
      if isequal( 1, ishandle(service_button) ) ...
        && strcmpi( get(service_button,'type'),'figure')
        if ~isempty( strfind( get(service_button,'name'),'iscrete') )
          local_get_pzg_fig_data( 2, [] );
        else
          local_get_pzg_fig_data( 1, [] );
        end
      end
    case('deselect frequency')
      if ~isempty(gcbo) ...
        &&( strcmp( get(gcbo,'tag'),'D-T LinkMethod') ...
           ||strcmp( get(gcbo,'tag'),'C-T LinkMethod') )
        local_get_pzg_fig_data( 1, [] );
        local_update_selected_freq( 1 )
        local_get_pzg_fig_data( 2, [] );
        local_update_selected_freq( 2 )
      end
      if ~isempty( strfind( get(gcbf,'name'),'iscrete') ) ...
        ||( ~isempty(gcbo) ...
           && ~isempty( strfind( get(gcbo,'tag'),'Set TS') ) )
        local_get_pzg_fig_data( 2, [] );
        local_update_selected_freq( 2 )
        local_get_pzg_fig_data( 1, [] );
        local_update_selected_freq( 1 )
      end
      if ~isempty( strfind( get(gcbf,'name'),'ontinuous') ) ...
        &&( isempty(gcbo) ...
           || isempty( strfind( get(gcbo,'tag'),'Set TS') ) )
        local_get_pzg_fig_data( 1, [] );
        local_update_selected_freq( 1 )
        local_get_pzg_fig_data( 2, [] );
        local_update_selected_freq( 2 )
      end

    case 'refresh selected_freq'
      % Called when switching from Hz to rad/s in bode plots.
      if ~PZG(1).pzg_show_frf_computation
        blank_h = ...
          [ pzg_fndo( (1:2),(1:14),'Bode_selection_marker'); ...
            pzg_fndo( (1:2), (1:14),'implicit_freq_marker') ];
        if ~isempty(blank_h)
          set( blank_h,'visible','off')
        end
      else
        ploth_ndx = pzg_fndo( 1,[(1:10),12,14],'ploth_ndx');
        if any( ploth_ndx == 12 )
          local_get_pzg_fig_data( 1, [] );
          local_update_selected_freq( 1, PZG(1).plot_h, ploth_ndx(1), 0 );
        else
          blank_h = ...
            [ pzg_fndo( 1,[(1:10),12,14],'Bode_selection_marker'); ...
              pzg_fndo( 1,[(1:10),12,14],'implicit_freq_marker') ];
          if ~isempty(blank_h)
            set( blank_h,'visible','off')
          end
        end
        ploth_ndx = pzg_fndo( 2,[(1:9),11,13,14],'ploth_ndx');
        if any( ploth_ndx == 13 )
          local_get_pzg_fig_data( 2, [] );
          local_update_selected_freq( ...
            2, PZG(2).plot_h, ploth_ndx(1), PZG(2).NegSelect );
        else
          blank_h = ...
            [ pzg_fndo( 2,[(1:9),11,13,14],'Bode_selection_marker'); ...
              pzg_fndo( 2,[(1:9),11,13,14],'implicit_freq_marker') ];
          if ~isempty(blank_h)
            set( blank_h,'visible','off')
          end
        end
      end

    case 'run nyquist movie'
      local_run_nyquist_movie

    otherwise
  end
  return
  
elseif ( numel(fig_h) ~= 1 ) || ~isequal( 1, ishandle(fig_h) ) ...
  || ~strcmp( get(fig_h,'type'),'figure') ...
  || ~isappdata( fig_h,'hndl')
  return
end

if nargin < 2
  service_button = 0;
end

if ~isfield( PZG(dom_ndx),'recompute_frf')
  return
end
if ~isequal( PZG(dom_ndx).recompute_frf, 0 ) ...
  || ~isfield( PZG(dom_ndx),'cntr_data') ...
  || isempty( PZG(dom_ndx).cntr_data ) ...
  ||~isstruct( PZG(dom_ndx).cntr_data ) ...
  ||~isfield( PZG(dom_ndx).cntr_data,'contour_freq')
  PZG(dom_ndx).recompute_frf = 0;
  pzg_cntr(dom_ndx);
  pzg_bodex(dom_ndx);
end

[ plot_h, fig_h_ndx ] = ...
    local_get_pzg_fig_data( dom_ndx, fig_h, fig_h_ndx );


if ( ( dom_ndx == 1 ) ...
    &&( isempty( plot_h{10} ) || ~isfield( plot_h{10},'fig_h') ...
       || ~isequal( gcbf, plot_h{10}.fig_h ) ) ) ...
  ||( ( dom_ndx == 2 ) ...
    &&( isempty( plot_h{11} ) || ~isfield( plot_h{11},'fig_h') ...
       || ~isequal( gcbf, plot_h{11}.fig_h ) ) )
  pKeff_line_h = ...
    [ pzg_fndo( 1,[(1:10),12,14],'parameter_K_effect_line'); ...
      pzg_fndo( 2,[(1:9),11,13,14],'parameter_K_effect_line'); ...
      pzg_fndo( 1,[(1:10),12,14],'parameter_K_effect_prvw_line'); ...
      pzg_fndo( 2,[(1:9),11,13,14],'parameter_K_effect_prvw_line') ];
  if ~isempty(pKeff_line_h)
    set( pKeff_line_h(ishandle(pKeff_line_h)),'visible','off')
  end
end

if isempty(fig_h_ndx)
  local_all_cursor_hilites_off( plot_h, fig_h_ndx, dom_ndx );
  local_plot_clbode_nich_mag_phs( plot_h, fig_h_ndx, dom_ndx );
  return
else
  dmptxt_h = pzg_fndo( dom_ndx, (10:13),'damping_natural_freq_text');
  if ~isempty(dmptxt_h)
    set(dmptxt_h,'visible','off')
  end
end

CurrPt = plot_h{fig_h_ndx}.CurrPt;
if service_button || ( nargin > 1 )
  local_service_button( plot_h, fig_h_ndx, dom_ndx, CurrPt, not_zooming );
  return
end

if isempty( plot_h{fig_h_ndx}.bodedata_ndx ) ...
  && isempty( plot_h{fig_h_ndx}.nyqdata_ndx )
  % Cursor is outside of the axes limits.
  local_all_cursor_hilites_off( plot_h, fig_h_ndx, dom_ndx  );
  return
elseif plot_h{fig_h_ndx}.mindist > dDst
  local_all_cursor_hilites_off( plot_h, fig_h_ndx, dom_ndx );
  local_plot_clbode_nich_mag_phs( plot_h, fig_h_ndx, dom_ndx );
  return
end
local_plot_clbode_nich_mag_phs( plot_h, fig_h_ndx, dom_ndx );
plot_h = PZG(dom_ndx).plot_h;

pd = local_initialize_pd( plot_h, fig_h_ndx, dom_ndx );
plot_h = PZG(dom_ndx).plot_h;

if isempty(pd.ol_ndx) && isempty(pd.nyq_ndx)
  local_all_cursor_hilites_off( plot_h, fig_h_ndx, dom_ndx );
else
  [ pd, plot_h ] = local_update_frequency_hilites( pd, plot_h, dom_ndx );
  PZG(dom_ndx).plot_h = plot_h;
end

% If C-T and D-T are linked, update the other domain.
bilinear_mapg = 0;
if dom_ndx == 1
  link_method_h = pzg_fndo( 1,12,'LinkMethod');
else
  link_method_h = pzg_fndo( 2,13,'LinkMethod');
end
if ~isempty(link_method_h) && get( link_method_h,'value') == 3
  bilinear_mapg = 1;
end
linked = pzg_islink;

if linked && ~isempty(fig_h_ndx)
  other_dom_ndx = 2;
  if dom_ndx == 2
    other_dom_ndx = 1;
  end
  other_plot_h = local_get_pzg_fig_data( other_dom_ndx, [] );

  % P/Z maps are already up-to-date.
  other_plot_h(10:13) = cell(4,1);

  nyqdata_ndx = plot_h{fig_h_ndx}.nyqdata_ndx;
  if isempty(nyqdata_ndx)
    local_fig_freqhilites_off( other_plot_h );
    return
  end

  neg_freq = plot_h{fig_h_ndx}.neg_freq;
  cntr_freq = PZG(dom_ndx).cntr_data.contour_freq(nyqdata_ndx);
  %bodedata_ndx = plot_h{fig_h_ndx}.bodedata_ndx;
  bodedata_ndx = PZG(dom_ndx).FrqSelNdx;
  bode_freq = [];
  if ~isempty(bodedata_ndx) ...
    && ( bodedata_ndx > 0 ) ...
    && ( bodedata_ndx <= numel(PZG(dom_ndx).BodeFreqs) )
    bode_freq = PZG(dom_ndx).BodeFreqs(bodedata_ndx);
  elseif ( dom_ndx == 1 ) && ~isinf(cntr_freq)
    bode_freq = cntr_freq;
  end
  if dom_ndx == 2
    bode_freq = mod( bode_freq, 2*pi/PZG(2).Ts );
  end

  cntr_flag = PZG(dom_ndx).cntr_data.contour_flag(nyqdata_ndx);
  cntr_angle = PZG(dom_ndx).cntr_data.contour_angle(nyqdata_ndx);

  if bilinear_mapg
    if dom_ndx == 1
      % C-T to D-T
      z_pt = ...
        ( 2 + PZG(2).Ts*1i*bode_freq ) / ( 2 - PZG(2).Ts*1i*bode_freq );
      bode_freq = angle(z_pt)/PZG(2).Ts;
      if neg_freq
        bode_freq = 2*pi/PZG(2).Ts - bode_freq;
      end
      z_pt = ...
        ( 2 + PZG(2).Ts*1i*cntr_freq ) / ( 2 - PZG(2).Ts*1i*cntr_freq );
      cntr_freq = angle(z_pt)/PZG(2).Ts;
    else
      % D-T to C-T
      s_pt = ...
        2/PZG(2).Ts * ( exp(1i*bode_freq*PZG(2).Ts) - 1 ) ...
                    / ( exp(1i*bode_freq*PZG(2).Ts) + 1 );
      bode_freq = imag(s_pt);
      s_pt = ...
        2/PZG(2).Ts * ( exp(1i*cntr_freq*PZG(2).Ts) - 1 ) ...
                    / ( exp(1i*cntr_freq*PZG(2).Ts) + 1 );
      cntr_freq = imag(s_pt);
      if ( cntr_freq ...
          >= ( PZG(1).BodeFreqs(end) ...
              +diff( PZG(1).BodeFreqs(end-1:end) )/2 ) ) ...
        && isequal( cntr_flag, 1 )
        other_plot_h = PZG(1).plot_h;
        other_plot_h{11} = [];
        other_plot_h{13} = [];
        local_fig_freqhilites_off( other_plot_h );
        return
      end
    end
  else
    if dom_ndx == 1
      if ~isinf(cntr_freq)
        % Alias C-T contour frequency down to D-T range.
        % Bode frequency might be valid for any finite contour freq.
        cntr_freq = mod( cntr_freq, 2*pi/PZG(2).Ts );
        if neg_freq
          bode_freq = 2*pi/PZG(2).Ts - cntr_freq;
        else
          bode_freq = cntr_freq;
        end
        if cntr_freq > pi/PZG(2).Ts
          cntr_freq = 2*pi/PZG(2).Ts - cntr_freq;
          if ~isequal( 0, neg_freq )
            neg_freq = 0;
          else
            neg_freq = 1;
          end
        end
      end
    else
      bode_freq = cntr_freq;
      if fig_h_ndx < 6
        neg_freq = 0;
      end
    end
  end

  other_bode_ndx = [];
  if isempty(bode_freq) || isinf(cntr_flag) || isequal( cntr_flag, 0 )
    local_fig_freqhilites_off( other_plot_h, (1:5) )
    other_plot_h(1:5) = cell(5,1);
  else
    other_bode_ndx = ...
      pzg_gle( PZG(other_dom_ndx).BodeFreqs, bode_freq,'near');
  end

  other_nyq_ndx = [];
  if ~isempty(cntr_freq) && ~isinf(cntr_freq) ...
    && isfield( PZG(other_dom_ndx),'cntr_data') ...
    && isstruct( PZG(other_dom_ndx).cntr_data) ...
    && isfield( PZG(other_dom_ndx).cntr_data,'contour_freq')
    other_nyq_ndx = [];
    if cntr_flag == 1
      % Ordinary point.
      if ( ( dom_ndx == 2 ) && isequal( 0, neg_freq ) ) ...
        || bilinear_mapg
        [ temp, other_nyq_ndx ] = ...
           min( abs( PZG(other_dom_ndx).cntr_data.contour_freq ...
                     - abs(cntr_freq) ) );                      %#ok<ASGLU>
      else
        cmpr_freq = mod( abs(cntr_freq), 2*pi/PZG(2).Ts );
        if cmpr_freq > pi/PZG(2).Ts
          cmpr_freq = 2*pi/PZG(2).Ts - cmpr_freq;
        end
        [ temp, other_nyq_ndx ] = ...
           min( abs( PZG(other_dom_ndx).cntr_data.contour_freq ...
                    - cmpr_freq ) );                            %#ok<ASGLU>
      end
    elseif ~isnan(cntr_angle)
      % Point on an indent, flag is either zero or inf
      % With linked planes, cntr_freq will be in nyq range.
      if ( abs(cntr_freq) < pi/PZG(2).Ts ) ...
        ||( dom_ndx == 2 ) || bilinear_mapg
        cmpr_freq = abs(cntr_freq);
      else
        cmpr_freq = pi/PZG(2).Ts - abs(cntr_freq);
      end
      same_freq_ndxs = ...
        find( ( abs( PZG(other_dom_ndx).cntr_data.contour_freq ...
                    - cmpr_freq ) < 1e-7 ) ...
             &( ~isnan(PZG(other_dom_ndx).cntr_data.contour_angle) ) );
      if ~isempty(same_freq_ndxs)
        [ temp, min_ndx ] = ...
           min( ...
             abs( PZG(other_dom_ndx).cntr_data ...
                 .contour_angle(same_freq_ndxs) - cntr_angle ) ); %#ok<ASGLU>
        other_nyq_ndx = same_freq_ndxs(min_ndx);
      end 
    elseif isnan(cntr_angle) ...
      && ( isinf(cntr_flag) || isequal( 0, cntr_flag ) )
      if isequal( fig_h_ndx, 6 )
        % One of the extra points:  must be in the Nichols plot.
        % Determine which end of the contour.
        extra_ndxs = ...
          find( isnan( PZG(dom_ndx).cntr_data.contour_angle ) ...
               &( isinf(PZG(dom_ndx).cntr_data.contour_flag) ...
                 |isequal(0,PZG(dom_ndx).cntr_data.contour_flag) ) );
        nic_contour = PZG(dom_ndx).cntr_data.Nichols_phs ...
                      +1i*PZG(dom_ndx).cntr_data.Nichols_mag;
        nic_neg_contour = -PZG(dom_ndx).cntr_data.Nichols_phs ...
                          +1i*PZG(dom_ndx).cntr_data.Nichols_mag;
        [ mindist1, mindist_ndx1 ] = ...
            min( abs( nic_contour(extra_ndxs) - CurrPt ) );
        [ mindist2, mindist_ndx2 ] = ...
            min( abs( nic_neg_contour(extra_ndxs) - CurrPt ) );
        if mindist1 < mindist2
          other_nyq_ndx = extra_ndxs(mindist_ndx1);
          neg_freq = 0;
        else
          other_nyq_ndx = extra_ndxs(mindist_ndx2);
          neg_freq = 1;
        end
      elseif isequal( fig_h_ndx, 7 )
        extra_ndxs = ...
          find( isnan( PZG(dom_ndx).cntr_data.contour_angle ) ...
               &( isinf(PZG(dom_ndx).cntr_data.contour_flag) ...
                 |isequal(0,PZG(dom_ndx).cntr_data.contour_flag) ) );
        if plot_h{7}.hybrid_scaling_cb
          cmpr_pts = PZG(dom_ndx).cntr_data.Nyquist_scaled_pts;
        else
          cmpr_pts = PZG(dom_ndx).cntr_data.Nyquist_pts;
        end
        [ mindist1, mindist_ndx1 ] = ...
            min( abs( cmpr_pts(extra_ndxs) - CurrPt ) );
        [ mindist2, mindist_ndx2 ] = ...
            min( abs( cmpr_pts(extra_ndxs) - conj(CurrPt) ) );
        if mindist1 < mindist2
          other_nyq_ndx = extra_ndxs(mindist_ndx1);
          neg_freq = 0;
        else
          other_nyq_ndx = extra_ndxs(mindist_ndx2);
          neg_freq = 1;
        end
      elseif isequal( fig_h_ndx, 14 )
        extra_ndxs = ...
          find( isnan( PZG(dom_ndx).cntr_data.contour_angle ) ...
               &( isinf(PZG(dom_ndx).cntr_data.contour_flag) ...
                 |isequal(0,PZG(dom_ndx).cntr_data.contour_flag) ) );
        cmpr_pts = PZG(dom_ndx).cntr_data.contour_pts;
        [ mindist1, mindist_ndx1 ] = ...
            min( abs( cmpr_pts(extra_ndxs) - CurrPt ) );
        [ mindist2, mindist_ndx2 ] = ...
            min( abs( cmpr_pts(extra_ndxs) - conj(CurrPt) ) );
        if mindist1 < mindist2
          other_nyq_ndx = extra_ndxs(mindist_ndx1);
          neg_freq = 0;
        else
          other_nyq_ndx = extra_ndxs(mindist_ndx2);
          neg_freq = 1;
        end
      end
    end
  end
  if isempty(other_nyq_ndx)
    local_fig_freqhilites_off( other_plot_h );
    return
  end

  cntr_mapg = PZG(other_dom_ndx).cntr_data.contour_mapping(other_nyq_ndx);
  Sens_pt = 1/(1+cntr_mapg);

  other_fig_h_ndx = [];
  if ~isempty(fig_h_ndx) ...
    && ~isempty( other_plot_h{fig_h_ndx} ) ...
    && isstruct( other_plot_h{fig_h_ndx} ) ...
    && isfield( other_plot_h{fig_h_ndx},'fig_h')
    other_fig_h_ndx = fig_h_ndx;
  elseif ~isempty(other_bode_ndx)
    for k = 1:5
      if ~isempty( other_plot_h{k} ) ...
        && isstruct( other_plot_h{k} ) ...
        && isfield( other_plot_h{k},'fig_h')
        other_fig_h_ndx = k;
        break
      end
    end
  end
  if ~isempty(other_nyq_ndx) && isempty(other_fig_h_ndx)
    for k = 6:7
      if ~isempty( other_plot_h{k} ) ...
        && isstruct( other_plot_h{k} ) ...
        && isfield( other_plot_h{k},'fig_h')
        other_fig_h_ndx = k;
        break
      end
    end
  end
  if isempty(other_fig_h_ndx)
    local_fig_freqhilites_off( other_plot_h );
    return
  end
  x_pt = [];
  y_pt = [];
  switch other_fig_h_ndx
    case 1
      if ~isempty(bode_freq) && ~isempty(other_bode_ndx) ...
        && ( numel(PZG(other_dom_ndx).BodeMag) >= other_bode_ndx )
        x_pt = bode_freq;
        y_pt = PZG(other_dom_ndx).BodeMag(other_bode_ndx);
      end
    case 2
      if ~isempty(bode_freq) && ~isempty(other_bode_ndx) ...
        && ( numel(PZG(other_dom_ndx).BodePhs) >= other_bode_ndx )
        x_pt = bode_freq;
        y_pt = PZG(other_dom_ndx).BodePhs(other_bode_ndx);
      end
    case 3
      if ~isempty(bode_freq) && ~isempty(other_bode_ndx) ...
        && ( numel(PZG(other_dom_ndx).CLBodeMag) >= other_bode_ndx )
        x_pt = bode_freq;
        y_pt = PZG(other_dom_ndx).CLBodeMag(other_bode_ndx);
      end
    case 4
      if ~isempty(bode_freq) && ~isempty(other_bode_ndx) ...
        && ( numel(PZG(other_dom_ndx).CLBodePhs) >= other_bode_ndx )
        x_pt = bode_freq;
        y_pt = PZG(other_dom_ndx).CLBodePhs(other_bode_ndx);
      end
    case 5
      if ~isempty(bode_freq) && ~isempty(Sens_pt)
        x_pt = bode_freq;
        y_pt = 20*log10(abs(Sens_pt));
      end
    case 6
      x_pt = PZG(other_dom_ndx).cntr_data.Nichols_phs(other_nyq_ndx);
      y_pt = PZG(other_dom_ndx).cntr_data.Nichols_mag(other_nyq_ndx);
      if neg_freq
        y_pt = -y_pt;
      end
    case 7
      if other_plot_h{7}.hybrid_scaling_cb
        x_pt = real( PZG(other_dom_ndx).cntr_data ...
                     .Nyquist_scaled_pts(other_nyq_ndx) );
        y_pt = imag( PZG(other_dom_ndx).cntr_data ...
                     .Nyquist_scaled_pts(other_nyq_ndx) );
      else
        x_pt = real( PZG(other_dom_ndx).cntr_data ...
                     .Nyquist_pts(other_nyq_ndx) );
        y_pt = imag( PZG(other_dom_ndx).cntr_data ...
                     .Nyquist_pts(other_nyq_ndx) );
      end
      if neg_freq
        y_pt = -y_pt;
      end

    otherwise
      x_pt = [];
      y_pt = [];
  end

  other_plot_h{other_fig_h_ndx}.neg_freq = neg_freq;
  other_plot_h{other_fig_h_ndx}.CurrPt = x_pt + 1i*y_pt;
  other_plot_h{other_fig_h_ndx}.mindist = 0;
  other_plot_h{other_fig_h_ndx}.bodedata_ndx = other_bode_ndx;
  other_plot_h{other_fig_h_ndx}.nyqdata_ndx = other_nyq_ndx;
  other_plot_h{other_fig_h_ndx}.nearest_freq = ...
    PZG(other_dom_ndx).cntr_data.contour_freq(other_nyq_ndx);

  other_pd = ...
    local_initialize_pd( other_plot_h, other_fig_h_ndx, other_dom_ndx );

  if isempty(other_pd.ol_ndx) && isempty(other_pd.nyq_ndx)
    local_all_cursor_hilites_off( [], [], other_dom_ndx );
  else
    if other_dom_ndx == 2
      other_pd = ...
        local_update_frequency_hilites( ...
           other_pd, other_plot_h, other_dom_ndx ); %#ok<NASGU>
    else
      % Update bode plots separate from Nyquist-style plots.
      plot_h_1 = other_plot_h;
      plot_h_1(6:end) = cell( numel(plot_h_1)-5, 1 );
      if isequal( other_pd.neg_freq, 0 )
        other_pd = ...
          local_update_frequency_hilites( other_pd, plot_h_1, other_dom_ndx );
      else
        local_fig_freqhilites_off( plot_h_1, (1:5) )
      end
      other_pd.neg_freq = neg_freq;
      plot_h_2 = other_plot_h;
      plot_h_2(1:5) = cell(5,1);
      other_pd = ...
        local_update_frequency_hilites( ...
            other_pd, plot_h_2, other_dom_ndx ); %#ok<NASGU>
    end
  end
end
  
return

% LOCAL FUNCTIONS

function [ pd, plot_h ] = ...
             local_update_frequency_hilites( pd, plot_h, dom_ndx ) %#ok<*INUSD>
  
  global PZG
  
  if numel(plot_h) < 14
    if ~isempty(plot_h)
      disp(' ... partial "plot_h" only -- unable to process it')
    end
    return
  end
  
  mm_fontsize = 12;
  mm_fontweight = 'bold';
  
  mm_mag_line_color = [ 0.8 0 0.8];
  mm_mag_line_width = 3;
  mm_mag_line_style = '-';
  
  mm_phs_line_color = [ 0 0.8 0.8];
  mm_phs_line_width = 3;
  mm_phs_line_style = '-';
  
  mm_frq_line_width = 2;
  mm_frq_line_style = '--';
  
  mm_cl_marker = 'o';
  mm_cl_markersize = 4;
  mm_cl_linewidth = 4;
  
  bg_color = [ 0 0 0 ];
  if ~strcmp( PZG(1).DefaultBackgroundColor,'k')
    bg_color = [ 1 1 1 ];
  end
  
  bode_freq_units = 'rad/s';

  for kxy = 1:numel(plot_h)
    if ~isempty(plot_h{kxy}) ...
      && isfield(plot_h{kxy},'fig_h')
      if isfield(plot_h{kxy},'xlim') ...
        && isfield(plot_h{kxy},'ylim') ...
        && isequal( 2, numel(plot_h{kxy}.xlim) ) ...
        && isequal( 2, numel(plot_h{kxy}.ylim) )
        if ~isfield( plot_h{kxy},'hndl')
          plot_h{kxy}.hndl = [];
        end
        plot_h{kxy}.hndl.ax_xlim = plot_h{kxy}.xlim;
        plot_h{kxy}.hndl.ax_ylim = plot_h{kxy}.ylim;
      elseif isfield(plot_h{kxy},'hndl') ...
        && isfield(plot_h{kxy}.hndl,'ax_xlim') ...
        && isfield(plot_h{kxy}.hndl,'ax_ylim') ...
        && isequal(2,numel(plot_h{kxy}.hndl.ax_xlim)) ...
        && isequal(2,numel(plot_h{kxy}.hndl.ax_ylim))
        plot_h{kxy}.xlim = plot_h{kxy}.hndl.ax_xlim;
        plot_h{kxy}.ylim = plot_h{kxy}.hndl.ax_ylim;
      else
        plot_h{kxy}.xlim = get( plot_h{kxy}.ax_h,'xlim');
        plot_h{kxy}.ylim = get( plot_h{kxy}.ax_h,'ylim');
        if ~isfield( plot_h{kxy},'hndl')
          plot_h{kxy}.hndl = [];
        end
        plot_h{kxy}.hndl.ax_xlim = plot_h{kxy}.xlim;
        plot_h{kxy}.hndl.ax_ylim = plot_h{kxy}.ylim;  
      end
    end
  end
  
  if ~isempty(plot_h{1}) && isfield(plot_h{1},'fig_h')
    if isempty(pd.ol_mag_db) ...
      ||( isequal( PZG(1).stop_movie, 0 ) && pd.neg_freq )
      mm_h = [ plot_h{1}.mm_line_h; plot_h{1}.mm_mark_h; ...
               plot_h{1}.mm_mag_h; plot_h{1}.mm_freq_h ];
      if ~isempty(mm_h)
        set( mm_h,'visible','off');
      end
    else
      xpos = pd.ol_freq_w;
      freq_str = [ pzg_scifmt(xpos/2/pi,4) 'Hz'];
      if plot_h{1}.Hz_cb
        xpos = pd.ol_freq_w/2/pi;
        bode_freq_units = 'hertz';
      else
        freq_str = ...
          {['   ' pzg_scifmt(xpos,4) 'rad/s']; ...
           ['   ' freq_str ]};
      end
      mag_str = [ local_tenths_str(pd.ol_mag_db) ' dB'];
      if plot_h{1}.dB_cb
        ypos = pd.ol_mag_db;
      else
        ypos = 10^(pd.ol_mag_db/20);
        mag_str = [ pzg_scifmt(ypos) '  (' mag_str ')'];
      end
      
      if ( xpos < plot_h{1}.xlim(1) ) ...
        ||( xpos > plot_h{1}.xlim(2) ) ...
        ||( ypos < plot_h{1}.ylim(1) ) ...
        ||( ypos > plot_h{1}.ylim(2) )
        mm_h = [ plot_h{1}.mm_line_h; plot_h{1}.mm_mark_h; ...
                 plot_h{1}.mm_mag_h; plot_h{1}.mm_freq_h ];
        if ~isempty(mm_h)
          set( mm_h,'visible','off');
        end
      else
        pd.olbodemag_freq_str_pos = ...
          [ xpos, plot_h{1}.ylim(1)+0.08*diff(plot_h{1}.ylim), 0 ];
        if plot_h{1}.Log_cb
          lo_freq_margin = ( plot_h{1}.xlim(2) / plot_h{1}.xlim(1) )^0.15;
          hi_freq_margin = ( plot_h{1}.xlim(2) / plot_h{1}.xlim(1) )^0.25;
          pd.olbodemag_freq_str_pos(1) = ...
            min( max( pd.olbodemag_freq_str_pos(1), ...
                      plot_h{1}.xlim(1)*lo_freq_margin ), ...
                 plot_h{1}.xlim(2)/hi_freq_margin );
        else
          pd.olbodemag_freq_str_pos(1) = ...
            min( max( pd.olbodemag_freq_str_pos(1), ...
                      plot_h{1}.xlim(1)+0.15*diff(plot_h{1}.xlim) ), ...
                 plot_h{1}.xlim(2)-0.25*diff(plot_h{1}.xlim) );
        end
        if isempty( plot_h{1}.mm_freq_h )
          plot_h{1}.mm_freq_h = ...
            text( pd.olbodemag_freq_str_pos(1), ...
                  pd.olbodemag_freq_str_pos(2), ...
                  freq_str, ...
                  'parent', plot_h{1}.ax_h, ...
                  'color', 1-bg_color, ...
                  'fontsize', mm_fontsize, ...
                  'fontweight', mm_fontweight, ...
                  'tag','mouse motion freq text');
          PZG(dom_ndx).plot_h{1}.mm_freq_h = plot_h{1}.mm_freq_h;
        else
          set( plot_h{1}.mm_freq_h, ...
              'string', freq_str, ...
              'position', pd.olbodemag_freq_str_pos, ...
              'color', 1-bg_color, ...
              'fontsize', mm_fontsize, ...
              'fontweight', mm_fontweight, ...
              'visible','on');
        end

        pd.olbodemag_mag_str_pos = ...
          [ plot_h{1}.xlim(1), ...
            ypos+0.04*diff(plot_h{1}.ylim), 0 ];
        if isempty( plot_h{1}.mm_mag_h )
          plot_h{1}.mm_mag_h = ...
            text( pd.olbodemag_mag_str_pos(1), ...
                  pd.olbodemag_mag_str_pos(2), ...
                  mag_str, ...
                  'parent', plot_h{1}.ax_h, ...
                  'color', 1-bg_color, ...
                  'fontsize', mm_fontsize, ...
                  'fontweight', mm_fontweight, ...
                  'tag','mouse motion mag text');
          PZG(dom_ndx).plot_h{1}.mm_mag_h = plot_h{1}.mm_mag_h;
        else
          set( plot_h{1}.mm_mag_h, ...
              'string', mag_str, ...
              'position', pd.olbodemag_mag_str_pos, ...
              'color', 1-bg_color, ...
              'visible','on');
        end

        if isempty( plot_h{1}.mm_mark_h )
          plot_h{1}.mm_mark_h = ...
            plot( [ xpos; xpos ], ...
                  [ plot_h{1}.ylim(1); ypos ], ...
                  'parent', plot_h{1}.ax_h, ...
                  'color', 1-bg_color, ...
                  'linestyle', mm_frq_line_style, ...
                  'linewidth', mm_frq_line_width, ...
                  'tag','mouse motion freq marker');
          PZG(dom_ndx).plot_h{1}.mm_mark_h = plot_h{1}.mm_mark_h;
        else
          set( plot_h{1}.mm_mark_h, ...
              'xdata', [ xpos; xpos ], ...
              'ydata', [ plot_h{1}.ylim(1); ypos ], ...
              'color', 1-bg_color, ...
              'visible','on');
        end

        if isempty( plot_h{1}.mm_line_h )
          plot_h{1}.mm_line_h = ...
            plot( [ plot_h{1}.xlim(1); xpos ], ...
                  [ ypos; ypos ], ...
                  'parent', plot_h{1}.ax_h, ...
                  'color', mm_mag_line_color, ...
                  'linestyle', mm_mag_line_style, ...
                  'linewidth', mm_mag_line_width, ...
                  'tag','mouse motion freq line');
          PZG(dom_ndx).plot_h{1}.mm_line_h = plot_h{1}.mm_line_h;
        else
          set( plot_h{1}.mm_line_h, ...
              'xdata', [ plot_h{1}.xlim(1); xpos ], ...
              'ydata', [ ypos; ypos ], ...
              'color', mm_mag_line_color, ...
              'visible','on');
        end
      end
    end
  end
  
  
  if ~isempty(plot_h{2}) ...
    && isfield(plot_h{2},'fig_h')
    if isempty(pd.ol_phs_deg_wrapped) ...
      ||( isequal( PZG(1).stop_movie, 0 ) && pd.neg_freq )
      mm_h = [ plot_h{2}.mm_line_h; plot_h{2}.mm_mark_h; ...
               plot_h{2}.mm_phs_h; plot_h{2}.mm_freq_h ];
      if ~isempty(mm_h)
        set( mm_h, 'visible','off');
      end
    else
      xpos = pd.ol_freq_w;
      freq_str = [ pzg_scifmt(xpos/2/pi,4) 'Hz'];
      if plot_h{2}.Hz_cb
        xpos = pd.ol_freq_w/2/pi;
        bode_freq_units = 'hertz';
      else
        freq_str = ...
          {['   ' pzg_scifmt(xpos,4) 'rad/s']; ...
           ['   ' freq_str ]};
      end
      if ~isfield( plot_h{2},'unwrap_cb')
        plot_h{2}.unwrap_cb = ...
          get( PZG(dom_ndx).plot_h{2}.hndl.UnwrapChkbox,'value');
        PZG(dom_ndx).plot_h{2}.plot_h{2}.unwrap_cb = plot_h{2}.unwrap_cb;
      end
      if plot_h{2}.unwrap_cb
        pd.olbodephs_phs_str = ...
          ['   ' local_tenths_str( pd.ol_phs_deg_unwrapped ) '^o'];
        ypos = pd.ol_phs_deg_unwrapped;
      else
        pd.olbodephs_phs_str = ...
          ['   ' local_tenths_str( pd.ol_phs_deg_wrapped ) '^o'];
        ypos = pd.ol_phs_deg_wrapped;
      end
      
      if ( xpos < plot_h{2}.xlim(1) ) ...
        ||( xpos > plot_h{2}.xlim(2) ) ...
        ||( ypos < plot_h{2}.ylim(1) ) ...
        ||( ypos > plot_h{2}.ylim(2) )
        mm_h = [ plot_h{2}.mm_line_h; plot_h{2}.mm_mark_h; ...
                 plot_h{2}.mm_mag_h; plot_h{2}.mm_freq_h ];
        if ~isempty(mm_h)
          set( mm_h,'visible','off');
        end
        
      else
        pd.olbodephs_freq_str_pos = ...
          [ xpos, plot_h{2}.ylim(1)+0.08*diff(plot_h{2}.ylim), 0 ];
        if plot_h{2}.Log_cb
          lo_freq_margin = ( plot_h{2}.xlim(2) / plot_h{2}.xlim(1) )^0.10;
          hi_freq_margin = ( plot_h{2}.xlim(2) / plot_h{2}.xlim(1) )^0.25;
          pd.olbodephs_freq_str_pos(1) = ...
            min( max( pd.olbodephs_freq_str_pos(1), ...
                      plot_h{2}.xlim(1)*lo_freq_margin ), ...
                 plot_h{2}.xlim(2)/hi_freq_margin );
        else
          pd.olbodephs_freq_str_pos(1) = ...
            min( max( pd.olbodephs_freq_str_pos(1), ...
                      plot_h{2}.xlim(1)+0.10*diff(plot_h{2}.xlim) ), ...
                 plot_h{2}.xlim(2)-0.25*diff(plot_h{2}.xlim) );
        end
        
        if isempty( plot_h{2}.mm_freq_h )
          plot_h{2}.mm_freq_h = ...
            text( pd.olbodephs_freq_str_pos(1), ...
                  pd.olbodephs_freq_str_pos(2), ...
                  freq_str, ...
                  'parent', plot_h{2}.ax_h, ...
                  'color', 1-bg_color, ...
                  'fontsize', mm_fontsize, ...
                  'fontweight', mm_fontweight, ...
                  'tag','mouse motion freq text');
          PZG(dom_ndx).plot_h{2}.mm_freq_h = plot_h{2}.mm_freq_h;
        else
          set( plot_h{2}.mm_freq_h, ...
              'string', freq_str, ...
              'position', pd.olbodephs_freq_str_pos, ...
              'color', 1-bg_color, ...
              'visible','on');
        end

        pd.olbodemag_phs_str_pos = ...
          [ plot_h{2}.xlim(1), ypos+0.05*diff(plot_h{2}.ylim), 0 ];
        if isempty( plot_h{2}.mm_phs_h )
          plot_h{2}.mm_phs_h = ...
            text( pd.olbodemag_phs_str_pos(1), ...
                  pd.olbodemag_phs_str_pos(2), ...
                  pd.olbodephs_phs_str, ...
                  'parent', plot_h{2}.ax_h, ...
                  'color', 1-bg_color, ...
                  'fontsize', mm_fontsize, ...
                  'fontweight', mm_fontweight, ...
                  'tag','mouse motion phs text');
          PZG(dom_ndx).plot_h{2}.mm_phs_h = plot_h{2}.mm_phs_h;
        else
          set( plot_h{2}.mm_phs_h, ...
              'string', pd.olbodephs_phs_str, ...
              'position', pd.olbodemag_phs_str_pos, ...
              'color', 1-bg_color, ...
              'visible','on');
        end

        if isempty( plot_h{2}.mm_mark_h )
          plot_h{2}.mm_mark_h = ...
            plot( [ xpos; xpos ], ...
                  [ plot_h{2}.ylim(1); ypos ], ...
                  'parent', plot_h{2}.ax_h, ...
                  'color', 1-bg_color, ...
                  'linestyle', mm_frq_line_style, ...
                  'linewidth', mm_frq_line_width, ...
                  'tag','mouse motion freq marker');
          PZG(dom_ndx).plot_h{2}.mm_mark_h = plot_h{2}.mm_mark_h;
        else
          set( plot_h{2}.mm_mark_h, ...
              'xdata', [ xpos; xpos ], ...
              'ydata', [ plot_h{2}.ylim(1); ypos ], ...
              'color', 1-bg_color, ...
              'visible','on');
        end

        if isempty( plot_h{2}.mm_line_h )
          plot_h{2}.mm_line_h = ...
            plot( [ plot_h{2}.xlim(1); xpos ], ...
                  [ ypos; ypos ], ...
                  'parent', plot_h{2}.ax_h, ...
                  'color', mm_phs_line_color, ...
                  'linestyle', mm_phs_line_style, ...
                  'linewidth', mm_phs_line_width, ...
                  'tag','mouse motion freq line');
          PZG(dom_ndx).plot_h{2}.mm_line_h = plot_h{2}.mm_line_h;
        else
          set( plot_h{2}.mm_line_h, ...
              'xdata', [ plot_h{2}.xlim(1); xpos ], ...
              'ydata', [ ypos; ypos ], ...
              'color', mm_phs_line_color, ...
              'visible','on');
        end
      end
    end
  end
  
  
  if ~isempty(plot_h{3}) ...
    && isfield(plot_h{3},'fig_h')
    if isempty(pd.cl_mag_db) ...
      ||( isequal( PZG(1).stop_movie, 0 ) && pd.neg_freq )
      mm_h = [ plot_h{3}.mm_line_h; plot_h{3}.mm_mark_h; ...
               plot_h{3}.mm_mag_h; plot_h{3}.mm_freq_h ];
      if ~isempty(mm_h)
        set( mm_h,'visible','off');
      end
    else
      xpos = pd.ol_freq_w;
      freq_str = [ pzg_scifmt(xpos/2/pi,4) 'Hz'];
      if plot_h{3}.Hz_cb
        xpos = pd.ol_freq_w/2/pi;
        bode_freq_units = 'hertz';
      else
        freq_str = ...
          {['   ' pzg_scifmt(xpos,4) 'rad/s']; ...
           ['   ' freq_str ]};
      end
      clmag_str = [ '   ' local_tenths_str(pd.cl_mag_db) ' dB'];
      if plot_h{3}.dB_cb
        ypos = pd.cl_mag_db;
      else
        ypos = 10^(pd.cl_mag_db/20);
        clmag_str = ...
          [ '   ' pzg_scifmt(ypos) '  (' local_tenths_str(pd.cl_mag_db) ' dB)'];
      end
      
      if ( xpos < plot_h{3}.xlim(1) ) ...
        ||( xpos > plot_h{3}.xlim(2) ) ...
        ||( ypos < plot_h{3}.ylim(1) ) ...
        ||( ypos > plot_h{3}.ylim(2) )
        mm_h = [ plot_h{3}.mm_line_h; plot_h{3}.mm_mark_h; ...
                 plot_h{3}.mm_mag_h; plot_h{3}.mm_freq_h ];
        if ~isempty(mm_h)
          set( mm_h,'visible','off');
        end
      else
        if ypos < ( plot_h{3}.ylim(2)-0.20*diff(plot_h{3}.ylim) )
          pd.clbodemag_freq_str_pos = ...
            [ xpos, ypos+0.10*diff(plot_h{3}.ylim), 0 ];
        else
          pd.clbodemag_freq_str_pos = ...
            [ xpos, plot_h{3}.ylim(2)-0.10*diff(plot_h{3}.ylim), 0 ];
        end
        if plot_h{3}.Log_cb
          lo_freq_margin = ( plot_h{3}.xlim(2) / plot_h{3}.xlim(1) )^0.03;
          if plot_h{3}.dB_cb
            hi_freq_margin = ( plot_h{3}.xlim(2) / plot_h{3}.xlim(1) )^0.25;
          else
            hi_freq_margin = ( plot_h{3}.xlim(2) / plot_h{3}.xlim(1) )^0.45;
          end
          pd.clbodemag_freq_str_pos(1) = ...
            min( max( pd.clbodemag_freq_str_pos(1), ...
                      plot_h{3}.xlim(1)*lo_freq_margin ), ...
                 plot_h{3}.xlim(2)/hi_freq_margin );
        else
          pd.clbodemag_freq_str_pos(1) = ...
            min( max( pd.clbodemag_freq_str_pos(1), ...
                      plot_h{3}.xlim(1)+0.1*diff(plot_h{3}.xlim) ), ...
                 plot_h{3}.xlim(2)-0.25*diff(plot_h{3}.xlim) );
          if ~plot_h{3}.dB_cb
            pd.clbodemag_freq_str_pos(1) = ...
              min( pd.clbodemag_freq_str_pos(1), ...
                   plot_h{3}.xlim(2)-0.40*diff(plot_h{3}.xlim) );
          end
        end
        
        if isempty( plot_h{3}.mm_freq_h )
          plot_h{3}.mm_freq_h = ...
            text( pd.clbodemag_freq_str_pos(1), ...
                  pd.clbodemag_freq_str_pos(2), ...
                  { freq_str; clmag_str }, ...
                  'parent', plot_h{3}.ax_h, ...
                  'color', 1-bg_color, ...
                  'fontsize', mm_fontsize, ...
                  'fontweight', mm_fontweight, ...
                  'tag','mouse motion freq text');
          PZG(dom_ndx).plot_h{3}.mm_freq_h = plot_h{3}.mm_freq_h;
        else
          set( plot_h{3}.mm_freq_h, ...
              'string', { freq_str; clmag_str }, ...
              'position', pd.clbodemag_freq_str_pos, ...
              'color', 1-bg_color, ...
              'visible','on');
        end
        
        if isempty( plot_h{3}.mm_mark_h )
          plot_h{3}.mm_mark_h = ...
            plot( xpos, ypos, ...
                  'parent', plot_h{3}.ax_h, ...
                  'color', [0 0.7 0.7], ...
                  'marker', mm_cl_marker, ...
                  'markersize', mm_cl_markersize, ...
                  'linewidth', mm_cl_linewidth, ...
                  'tag','mouse motion freq marker');
          PZG(dom_ndx).plot_h{3}.mm_mark_h = plot_h{3}.mm_mark_h;
        else
          set( plot_h{3}.mm_mark_h, ...
              'xdata', xpos, ...
              'ydata', ypos, ...
              'color', [0 0.7 0.7], ...
              'visible','on');
        end
      end
    end
  end
  
  if ~isempty(plot_h{4}) ...
    && isfield(plot_h{4},'fig_h')
    if isempty(pd.cl_mag_db) ...
      ||( isequal( PZG(1).stop_movie, 0 ) && pd.neg_freq )
      mm_h = [ plot_h{4}.mm_line_h; plot_h{4}.mm_mark_h; ...
               plot_h{4}.mm_mag_h; plot_h{4}.mm_freq_h ];
      if ~isempty(mm_h)
        set( mm_h,'visible','off');
      end
    else
      xpos = pd.ol_freq_w;
      freq_str = [ pzg_scifmt(xpos/2/pi,4) 'Hz'];
      if plot_h{4}.Hz_cb
        xpos = pd.ol_freq_w/2/pi;
        bode_freq_units = 'hertz';
      else
        freq_str = ...
          {['   ' pzg_scifmt(xpos,4) 'rad/s']; ...
           ['   ' freq_str ]};
      end
      
      if ~isfield( plot_h{4},'unwrap_cb')
        plot_h{4}.unwrap_cb = ...
          get( PZG(dom_ndx).plot_h{4}.hndl.UnwrapChkbox,'value');
        PZG(dom_ndx).plot_h{4}.plot_h{4}.unwrap_cb = plot_h{4}.unwrap_cb;
      end
      if plot_h{4}.unwrap_cb
        ypos = pd.cl_phs_deg_unwrapped;
        pd.clbodephs_phs_str = ...
          ['   ' local_tenths_str( pd.cl_phs_deg_unwrapped ) '^o'];
      else
        ypos = pd.cl_phs_deg_wrapped;
        pd.clbodephs_phs_str = ...
          ['   ' local_tenths_str( pd.cl_phs_deg_wrapped ) '^o'];
      end
      
      if ( xpos < plot_h{4}.xlim(1) ) ...
        ||( xpos > plot_h{4}.xlim(2) ) ...
        ||( ypos < plot_h{4}.ylim(1) ) ...
        ||( ypos > plot_h{4}.ylim(2) )
        mm_h = [ plot_h{4}.mm_line_h; plot_h{4}.mm_mark_h; ...
                 plot_h{4}.mm_mag_h; plot_h{4}.mm_freq_h ];
        if ~isempty(mm_h)
          set( mm_h,'visible','off');
        end
      else
        if ypos < ( plot_h{4}.ylim(2)-0.20*diff(plot_h{4}.ylim) )
          pd.clbodephs_freq_str_pos = ...
            [ xpos, ypos+0.10*diff(plot_h{4}.ylim), 0 ];
        else
          pd.clbodephs_freq_str_pos = ...
            [ xpos, plot_h{4}.ylim(2)-0.10*diff(plot_h{4}.ylim), 0 ];
        end
        if plot_h{4}.Log_cb
          lo_freq_margin = ( plot_h{4}.xlim(2) / plot_h{4}.xlim(1) )^0.03;
          hi_freq_margin = ( plot_h{4}.xlim(2) / plot_h{4}.xlim(1) )^0.25;
          pd.clbodephs_freq_str_pos(1) = ...
            min( max( pd.clbodephs_freq_str_pos(1), ...
                      plot_h{4}.xlim(1)*lo_freq_margin ), ...
                 plot_h{4}.xlim(2)/hi_freq_margin );
        else
          pd.clbodephs_freq_str_pos(1) = ...
            min( max( pd.clbodephs_freq_str_pos(1), ...
                      plot_h{4}.xlim(1)+0.03*diff(plot_h{4}.xlim) ), ...
                 plot_h{4}.xlim(2)-0.25*diff(plot_h{4}.xlim) );
        end
        
        if isempty( plot_h{4}.mm_freq_h )
          plot_h{4}.mm_freq_h = ...
            text( pd.clbodephs_freq_str_pos(1), ...
              pd.clbodephs_freq_str_pos(2), ...
              { freq_str; pd.clbodephs_phs_str }, ...
              'parent', plot_h{4}.ax_h, ...
              'color', 1-bg_color, ...
              'fontsize', mm_fontsize, ...
              'fontweight', mm_fontweight, ...
              'tag','mouse motion freq text');
          PZG(dom_ndx).plot_h{4}.mm_freq_h = plot_h{4}.mm_freq_h;
        else
          set( plot_h{4}.mm_freq_h, ...
            'string', { freq_str; pd.clbodephs_phs_str }, ...
            'position', pd.clbodephs_freq_str_pos, ...
            'color', 1-bg_color, ...
            'visible','on');
        end
        
        if isempty( plot_h{4}.mm_mark_h )
          plot_h{4}.mm_mark_h = ...
            plot( xpos, ypos, ...
              'parent', plot_h{4}.ax_h, ...
              'color', [0 0.7 0.7], ...
              'marker', mm_cl_marker, ...
              'markersize', mm_cl_markersize, ...
              'linewidth', mm_cl_linewidth, ...
              'tag','mouse motion freq marker');
          PZG(dom_ndx).plot_h{4}.mm_mark_h = plot_h{4}.mm_mark_h;
        else
          set( plot_h{4}.mm_mark_h, ...
            'xdata', xpos, ...
            'ydata', ypos, ...
            'color', [0 0.7 0.7], ...
            'visible','on');
        end
      end
    end
  end

  
  if ~isempty(plot_h{5}) ...
    && isfield(plot_h{5},'fig_h')
    if isempty(pd.sens_mag_db) ...
      ||( isequal( PZG(1).stop_movie, 0 ) && pd.neg_freq )
      mm_h = [ plot_h{5}.mm_line_h; plot_h{5}.mm_mark_h; ...
               plot_h{5}.mm_mag_h; plot_h{5}.mm_freq_h ];
      if ~isempty(mm_h)
        set( mm_h,'visible','off');
      end
    else
      xpos = pd.ol_freq_w;
      freq_str = [ pzg_scifmt(xpos/2/pi,4) 'Hz'];
      if plot_h{5}.Hz_cb
        xpos = pd.ol_freq_w/2/pi;
        bode_freq_units = 'hertz';
      else
        freq_str = ...
          {['   ' pzg_scifmt(xpos,4) 'rad/s']; ...
           ['   ' freq_str ]};
      end
      ypos = pd.sens_mag_db;
      
      if ( xpos < plot_h{5}.xlim(1) ) ...
        ||( xpos > plot_h{5}.xlim(2) ) ...
        ||( ypos < plot_h{5}.ylim(1) ) ...
        ||( ypos > plot_h{5}.ylim(2) )
        mm_h = [ plot_h{5}.mm_line_h; plot_h{5}.mm_mark_h; ...
                 plot_h{5}.mm_mag_h; plot_h{5}.mm_freq_h ];
        if ~isempty(mm_h)
          set( mm_h,'visible','off');
        end
      else
        if ypos < ( plot_h{5}.ylim(2)-0.14*diff(plot_h{5}.ylim) )
          pd.clsens_freq_str_pos = ...
            [ xpos, ypos+0.07*diff(plot_h{5}.ylim), 0 ];
        else
          pd.clsens_freq_str_pos = ...
            [ xpos, plot_h{5}.ylim(2)-0.07*diff(plot_h{5}.ylim), 0 ];
        end
        if plot_h{5}.Log_cb
          lo_freq_margin = ( plot_h{5}.xlim(2) / plot_h{5}.xlim(1) )^0.03;
          hi_freq_margin = ( plot_h{5}.xlim(2) / plot_h{5}.xlim(1) )^0.25;
          pd.clsens_freq_str_pos(1) = ...
            min( max( pd.clsens_freq_str_pos(1), ...
                      plot_h{5}.xlim(1)*lo_freq_margin ), ...
                 plot_h{5}.xlim(2)/hi_freq_margin );
        else
          pd.clsens_freq_str_pos(1) = ...
            min( max( pd.clsens_freq_str_pos(1), ...
                      plot_h{5}.xlim(1)+0.03*diff(plot_h{5}.xlim) ), ...
                 plot_h{5}.xlim(2)-0.25*diff(plot_h{5}.xlim) );
        end
        
        if isempty( plot_h{5}.mm_freq_h )
          plot_h{5}.mm_freq_h = ...
            text( pd.clsens_freq_str_pos(1), ...
              pd.clsens_freq_str_pos(2), ...
              freq_str, ...
              'parent', plot_h{5}.ax_h, ...
              'color', 1-bg_color, ...
              'fontsize', mm_fontsize, ...
              'fontweight', mm_fontweight, ...
              'tag','mouse motion freq text');
          PZG(dom_ndx).plot_h{5}.mm_freq_h = plot_h{5}.mm_freq_h;
        else
          set( plot_h{5}.mm_freq_h, ...
              'string', freq_str, ...
              'position', pd.clsens_freq_str_pos, ...
              'color', 1-bg_color, ...
              'visible','on');
        end
        
        if isempty( plot_h{5}.mm_mark_h )
          plot_h{5}.mm_mark_h = ...
            plot( xpos, ypos, ...
              'parent', plot_h{5}.ax_h, ...
              'color', [0 0.7 0.7], ...
              'marker', mm_cl_marker, ...
              'markersize', mm_cl_markersize, ...
              'linewidth', mm_cl_linewidth, ...
              'tag','mouse motion freq marker');
          PZG(dom_ndx).plot_h{5}.mm_mark_h = plot_h{5}.mm_mark_h;
        else
          set( plot_h{5}.mm_mark_h, ...
            'xdata', xpos, ...
            'ydata', ypos, ...
            'visible','on');
        end
      end
    end
  end
  
  if ~isfield( pd,'contour_flag')
    return
  end
  if isinf( pd.contour_flag ) || isequal( pd.contour_flag, 0 )
    pd = local_get_contour_text( pd );
  else
    if ischar(pd.nicnyq_freqstr) && ~isempty(pd.nicnyq_freqstr) ...
      &&( size( pd.nicnyq_freqstr, 1 ) == 1 )
      negsign_ndx = strfind( pd.nicnyq_freqstr,'--');
      hzstr_ndx = strfind( pd.nicnyq_freqstr,'Hz');
      if ~isempty(negsign_ndx) && ~isempty(hzstr_ndx)
        strfreqhz = ...
          str2double( pd.nicnyq_freqstr(negsign_ndx+2:hzstr_ndx-1) );
      elseif ~isempty(hzstr_ndx)
        strfreqhz = str2double( pd.nicnyq_freqstr(1:hzstr_ndx-1) );
      else
        strfreqhz = str2double( pd.nicnyq_freqstr );
      end
      pd.nicnyq_freqstr = ['    ' pd.nicnyq_freqstr ];
      if strcmpi( bode_freq_units, 'rad/s') ...
        && ~isempty(pd.ol_freq_w) ...
        && ~isinf(pd.contour_freq) ...
        && ~isempty(strfreqhz)
        aliased_freq_hz = mod( abs(pd.ol_freq_w)/2/pi, 1/PZG(2).Ts );
        if isempty(negsign_ndx)
          if abs( strfreqhz - abs(pd.ol_freq_w)/2/pi ) ...
            > abs( strfreqhz - ( 1/PZG(2).Ts-aliased_freq_hz ) )
            pd.nicnyq_freqstr = ...
              {['    ' pzg_scifmt(aliased_freq_hz*2*pi,4) 'rad/s']; ...
               pd.nicnyq_freqstr };
          else
            pd.nicnyq_freqstr = ...
              {['    ' pzg_scifmt(pd.ol_freq_w,4) 'rad/s']; ...
               pd.nicnyq_freqstr };
          end
        else
          if abs( strfreqhz - abs(pd.ol_freq_w)/2/pi ) ...
            > abs( strfreqhz - ( 1/PZG(2).Ts-aliased_freq_hz ) )
            pd.nicnyq_freqstr = ...
              {['  --' pzg_scifmt(2*pi/PZG(2).Ts-pd.ol_freq_w,4) 'rad/s']; ...
               pd.nicnyq_freqstr };
          else
            pd.nicnyq_freqstr = ...
              {['  --' pzg_scifmt(pd.ol_freq_w,4) 'rad/s']; ...
               pd.nicnyq_freqstr };
          end
        end
      end
    end
  end
  
  if ~isempty(plot_h{6}) ...
    && isfield(plot_h{6},'fig_h')
    if isempty(pd.nic_mag_db) ...
      ||( ~plot_h{6}.nyq_data_cb ...
         && ( pd.neg_freq ...
             || isinf(pd.contour_flag) ...
             || isequal( pd.contour_flag, 0 ) ) )
       mm_h = [ plot_h{6}.mm_line_h; plot_h{6}.mm_mark_h; ...
                plot_h{6}.mm_mag_h; plot_h{6}.mm_phs_h; ...
                plot_h{6}.mm_freq_h ];
      if ~isempty(mm_h)
        set( mm_h,'visible','off');
      end
    else
      xpos = pd.nic_phs_deg;
      ypos = pd.nic_mag_db;
      if ( xpos < plot_h{6}.xlim(1) ) ...
        ||( xpos > plot_h{6}.xlim(2) ) ...
        ||( ypos < plot_h{6}.ylim(1) ) ...
        ||( ypos > plot_h{6}.ylim(2) )
        mm_h = [ plot_h{6}.mm_line_h; plot_h{6}.mm_mark_h; ...
                 plot_h{6}.mm_mag_h; plot_h{6}.mm_phs_h; ...
                 plot_h{6}.mm_freq_h ];
        if ~isempty(mm_h)
          set( mm_h,'visible','off');
        end
        
      else
        % Highlight the Nichols chart frequency point.
        if ~isempty( strfind( plot_h{6}.plot_name,'Continuous-Time') )
          %namestr = 's-Domain ';
          dom_ndx = 1;
        else
          %namestr = 'z-Domain ';
          dom_ndx = 2;
        end
        
        which_tools = pzg_tools(dom_ndx);
        if ~which_tools(2)
          % Make the lead-lag phase distance line & text non-visible
          if ~isempty(PZG(dom_ndx).plot_h{6}) ...
            && isfield( PZG(dom_ndx).plot_h{6}.hndl,'CL_0dB_contour') ...
            && isfield( PZG(dom_ndx).plot_h{6}.hndl,'LeadLag_Text')
            lldist_h = ...
              [ PZG(dom_ndx).plot_h{6}.hndl.CL_0dB_contour; ...
                PZG(dom_ndx).plot_h{6}.hndl.LeadLag_Text ];
          else
            lldist_h = [];
          end
          if ~isempty(lldist_h)
            set( lldist_h,'visible','off')
          end
        elseif ~pd.neg_freq
          % Lead-lag controller is active, and frequency is positive.
          nic_hilite_pt = xpos + 1i*ypos;
          plot_h = ...
            local_ldlg_zerodbCL_dist( ...
              plot_h, dom_ndx, nic_hilite_pt, pd.neg_freq );
        end
        
        if isempty( plot_h{6}.mm_mark_h )
          plot_h{6}.mm_mark_h = ...
            plot( [ plot_h{6}.xlim(1); xpos(1) ], ...
                  [ ypos(1); ypos(1) ], ...
                  'parent', plot_h{6}.ax_h, ...
                  'color', mm_mag_line_color, ...
                  'linestyle', mm_mag_line_style, ...
                  'linewidth', mm_mag_line_width, ...
                  'tag','mouse motion freq marker');
          PZG(dom_ndx).plot_h{6}.mm_mark_h = plot_h{6}.mm_mark_h;
        else
          set( plot_h{6}.mm_mark_h, ...
              'xdata', [ plot_h{6}.xlim(1); xpos(1) ], ...
              'ydata', [ ypos(1); ypos(1) ], ...
              'color', mm_mag_line_color, ...
              'visible','on');
        end
        if isempty( plot_h{6}.mm_line_h )
          plot_h{6}.mm_line_h = ...
            plot( [ xpos(1); xpos(1) ], ...
                  [ plot_h{6}.ylim(1); ypos(1) ], ...
                  'parent', plot_h{6}.ax_h, ...
                  'color', mm_phs_line_color, ...
                  'linestyle', mm_phs_line_style, ...
                  'linewidth', mm_phs_line_width, ...
                  'tag','mouse motion freq line');
          PZG(dom_ndx).plot_h{6}.mm_line_h = plot_h{6}.mm_line_h;
        else
          set( plot_h{6}.mm_line_h, ...
              'xdata', [ xpos(1); xpos(1) ], ...
              'ydata', [ plot_h{6}.ylim(1); ypos(1) ], ...
              'color', mm_phs_line_color, ...
              'visible','on');
        end
        if iscell(pd.nicnyq_freqstr) && ( numel(pd.nicnyq_freqstr) == 2 )
          pd.nic_freq_str_pos = ...
            [ xpos+0.02*diff(plot_h{6}.xlim), ...
              ypos+0.08*diff(plot_h{6}.ylim), 0 ];
          if pd.nyq_mag_is_zero || pd.nyq_mag_is_inf
            pd.nic_freq_str_pos(1) = ...
              min( pd.nic_freq_str_pos(1), ...
                   plot_h{6}.xlim(1)+0.3*diff(plot_h{6}.xlim) );
          end
        else
          pd.nic_freq_str_pos = ...
            [ xpos+0.02*diff(plot_h{6}.xlim), ...
              ypos+0.08*diff(plot_h{6}.ylim), 0 ];
        end
        pd.nic_freq_str_pos(1) = ...
          max( min( pd.nic_freq_str_pos(1), ...
                    plot_h{6}.xlim(1)+0.8*diff(plot_h{6}.xlim) ), ...
               plot_h{6}.xlim(1)+0.08*diff(plot_h{6}.xlim) );
        pd.nic_freq_str_pos(2) = ...
          min( max( pd.nic_freq_str_pos(2), ...
                    plot_h{6}.ylim(1)+0.24*diff(plot_h{6}.ylim) ), ...
               plot_h{6}.ylim(2)-0.08*diff(plot_h{6}.ylim) );
        if any( bg_color > 0.5 )
          nicnyqfreqstr_color = [ 0 0.65 0.65 ];
        else
          nicnyqfreqstr_color = [ 0 0.90 0.90 ];
        end
        if isempty( plot_h{6}.mm_freq_h )
          plot_h{6}.mm_freq_h = ...
            text( pd.nic_freq_str_pos(1), ...
                  pd.nic_freq_str_pos(2), ...
                  pd.nicnyq_freqstr, ...
                  'parent', plot_h{6}.ax_h, ...
                  'color', nicnyqfreqstr_color, ...
                  'fontsize', mm_fontsize, ...
                  'fontweight', mm_fontweight, ...
                  'tag','mouse motion freq text');
          PZG(dom_ndx).plot_h{6}.mm_freq_h = plot_h{6}.mm_freq_h;
        else
          set( plot_h{6}.mm_freq_h, ...
              'string', pd.nicnyq_freqstr, ...
              'position', pd.nic_freq_str_pos, ...
              'color', nicnyqfreqstr_color, ...
              'visible','on');
        end
        
        pd.nic_mag_str_pos = ...
          [ plot_h{6}.xlim(1)+0.02*diff(plot_h{6}.xlim), ...
            ypos-0.04*diff(plot_h{6}.ylim), 0 ];
        if isempty( plot_h{6}.mm_mag_h )
          plot_h{6}.mm_mag_h = ...
            text( pd.nic_mag_str_pos(1), ...
                pd.nic_mag_str_pos(2), ...
                pd.nic_mag_str, ...
                'parent', plot_h{6}.ax_h, ...
                'color', 1-bg_color, ...
                'fontsize', mm_fontsize, ...
                'fontweight', mm_fontweight, ...
                'tag','mouse motion mag text');
          PZG(dom_ndx).plot_h{6}.mm_mag_h = plot_h{6}.mm_mag_h;
        else
          set( plot_h{6}.mm_mag_h, ...
              'string', pd.nic_mag_str, ...
              'position', pd.nic_mag_str_pos, ...
              'color', 1-bg_color, ...
              'visible','on');
        end

        pd.nic_phs_str_pos = ...
          [ xpos+0.04*diff(plot_h{6}.xlim), ...
            plot_h{6}.ylim(1)+0.02*diff(plot_h{6}.ylim), 0 ];
        if pd.nic_mag_str_pos(2) ...
          < ( plot_h{6}.ylim(1)+0.20*diff(plot_h{6}.ylim) )
          pd.nic_phs_str_pos(1) = ...
            max( pd.nic_phs_str_pos(1), ...
                 plot_h{6}.xlim(1)+0.20*diff(plot_h{6}.xlim) );
        end
        if isempty( plot_h{6}.mm_phs_h )
          plot_h{6}.mm_phs_h = ...
            text( pd.nic_phs_str_pos(1), ...
                  pd.nic_phs_str_pos(2), ...
                  pd.nicnyq_phs_str, ...
                  'parent', plot_h{6}.ax_h, ...
                  'color', 1-bg_color, ...
                  'fontsize', mm_fontsize, ...
                  'fontweight', mm_fontweight, ...
                  'rotation', 90, ...
                  'tag','mouse motion phs text');
          PZG(dom_ndx).plot_h{6}.mm_phs_h = plot_h{6}.mm_phs_h;
        else
          set( plot_h{6}.mm_phs_h, ...
              'string', pd.nicnyq_phs_str, ...
              'position', pd.nic_phs_str_pos, ...
              'color', 1-bg_color, ...
              'visible','on');
        end
      end
    end
  end

  if ~isempty(plot_h{7}) ...
    && isfield(plot_h{7},'fig_h')
    plot_h{7}.hybrid_scaling_cb = ...
      get( plot_h{7}.hndl.rescale_checkbox,'value');
    if plot_h{7}.hybrid_scaling_cb
      plot_point = pd.nyq_scaled_pt;
    else
      plot_point = pd.nyq_unscaled_pt;
    end
    
    text_xlim = ...
      [ plot_h{7}.xlim(1)+0.10*diff(plot_h{7}.xlim), ...
        plot_h{7}.xlim(2)-0.20*diff(plot_h{7}.xlim) ];
    text_ylim = ...
      [ plot_h{7}.ylim(1)+0.10*diff(plot_h{7}.ylim), ...
        plot_h{7}.ylim(2)-0.10*diff(plot_h{7}.ylim) ];
      
    if isequal( pd.contour_flag, 1 )
      freq_text_xlim = text_xlim;
      freq_text_ylim = text_ylim;
    else
      freq_text_xlim = ...
        [ plot_h{7}.xlim(1)+0.10*diff(plot_h{7}.xlim), ...
          plot_h{7}.xlim(2)-0.60*diff(plot_h{7}.xlim) ];
      freq_text_ylim = ...
        [ plot_h{7}.ylim(1)+0.10*diff(plot_h{7}.ylim), ...
          plot_h{7}.ylim(2)-0.10*diff(plot_h{7}.ylim) ];
    end
    
    if ( real(plot_point) < text_xlim(2) ) ...
      &&( real(plot_point) > text_xlim(1) ) ...
      &&( imag(plot_point) < text_ylim(2) ) ...
      &&( imag(plot_point) > text_ylim(1) )
      % Plot point is well within text area.
      fm_str_point = plot_point;
    else
      % Plot point is near outer edge of plot.
      fm_str_point = ...
        max( text_xlim(1), min( text_xlim(2), real(plot_point) ) ) ...
        + 1i*max( text_ylim(1), min( text_ylim(2), imag(plot_point) ) );
    end
    
    pd.nyq_magphs_str_tilt = ...
      pzg_txan( plot_point, plot_h{7}.xlim, plot_h{7}.ylim, plot_h{7}.ax_h );
    
    adj_angle = pd.nyq_magphs_str_tilt*pi/180;
    if abs(adj_angle) < pi/6
      if adj_angle < 0
        adj_angle = -pi/6;
      else
        adj_angle = pi/6;
      end
    elseif abs(adj_angle) > 2*pi/6
      if adj_angle < 0
        adj_angle = -2*pi/6;
      else
        adj_angle = 2*pi/6;
      end
    end
    if isequal( pd.contour_flag, 1 )
      mag_diff_mult = 0.08;
      freq_diff_mult = 0.08;
      %diff_mult = 0.08;
    else
      if abs(fm_str_point) < 0.5
        mag_diff_mult = 0.04;
        freq_diff_mult = 0.11;
      else
        mag_diff_mult = 0.14;
        freq_diff_mult = 0.06;
      end
    end
    
    pd.nyq_mag_str_pos = ...
      [ ( real(fm_str_point) ...
         - mag_diff_mult*diff(plot_h{7}.xlim)*(cos(adj_angle)) ), ...
        ( imag(fm_str_point) ...
         + mag_diff_mult*diff(plot_h{7}.ylim)*(sin(adj_angle)) ), 0 ];
    pd.nyq_mag_str_pos(1) = ...
      max( text_xlim(1), min( pd.nyq_mag_str_pos(1), text_xlim(2) ));
    pd.nyq_mag_str_pos(2) = ...
      max( text_ylim(1), min( pd.nyq_mag_str_pos(2), text_ylim(2) ) );
    
    pd.nyq_freq_str_pos = ...
      [ ( real(fm_str_point) ...
         + freq_diff_mult*diff(plot_h{7}.xlim)*(cos(adj_angle)) ), ...
        ( imag(fm_str_point) ...
         - freq_diff_mult*diff(plot_h{7}.ylim)*(sin(adj_angle)) ), 0 ];
    pd.nyq_freq_str_pos(1) = ...
      max( freq_text_xlim(1), min(pd.nyq_freq_str_pos(1), freq_text_xlim(2)) );
    pd.nyq_freq_str_pos(2) = ...
      max( freq_text_ylim(1), min(pd.nyq_freq_str_pos(2), freq_text_ylim(2)) );
    
    % Determine line extension
    if real(plot_point) > 0
      x_extension = ...
        min( abs( plot_h{7}.xlim(2) - real(plot_point) )*0.8, ...
             0.8*diff(plot_h{7}.xlim) );
    else
      x_extension = ...
        min( abs( real(plot_point) - plot_h{7}.xlim(1) )*0.8, ...
             0.8*diff(plot_h{7}.xlim) );
    end
    if imag(plot_point) > 0
      y_extension = ...
        min( abs( plot_h{7}.ylim(2) - imag(plot_point) )*0.8, ...
             0.8*diff(plot_h{7}.ylim) );
    else
      y_extension = ...
        min( abs( imag(plot_point) - plot_h{7}.ylim(1) )*0.8, ...
             0.8*diff(plot_h{7}.ylim) );
    end
    extension = min( x_extension, y_extension );
    if abs(plot_point) < 0.5
      extension = max( 2*abs(plot_point), 0.5 );
    end
    pd.extended_plot_point = ...
      plot_point + extension*exp(1i*angle(plot_point));
    pd.extended_plot_point = ...
      max( plot_h{7}.xlim(1), ...
           min( real(pd.extended_plot_point), ...
                plot_h{7}.xlim(2)-0.02*diff(plot_h{7}.xlim) ) ) ...
      +1i*max( plot_h{7}.ylim(1), ...
           min( imag(pd.extended_plot_point), ...
                plot_h{7}.ylim(2)-0.02*diff(plot_h{7}.ylim) ) );
    
    xpos = real(plot_point);
    ypos = imag(plot_point);
    if isinf(xpos) || isinf(ypos)
      mm_h = [ plot_h{7}.mm_line_h; plot_h{7}.mm_mark_h; ...
               plot_h{7}.mm_mag_h; plot_h{7}.mm_phs_h; ...
               plot_h{7}.mm_freq_h ];
      if ~isempty(mm_h)
        set( mm_h,'visible','off');
      end
    else
      if any( bg_color > 0.5 )
        nyq_text_color = [ 0 0.65 0.65 ];
        nyq_phs_text_color = [ 0.7 0.7 0 ];
      else
        nyq_text_color = [ 0 0.90 0.90 ];
        nyq_phs_text_color = [ 0.90 0.90 0 ];
      end
      
      if isempty( plot_h{7}.mm_mark_h )
        plot_h{7}.mm_mark_h = ...
          plot( [ 0; real(pd.extended_plot_point) ], ...
                [ 0; imag(pd.extended_plot_point) ], ...
                'parent', plot_h{7}.ax_h, ...
                'color',[0.75 0.75 0], ...
                'linestyle','-.', ...
                'linewidth', 2, ...
                'tag','mouse motion freq marker');
          PZG(dom_ndx).plot_h{7}.mm_mark_h = plot_h{7}.mm_mark_h;
      else
        set( plot_h{7}.mm_mark_h, ...
            'xdata', [ 0; real(pd.extended_plot_point) ], ...
            'ydata', [ 0; imag(pd.extended_plot_point) ], ...
            'visible','on');
      end
      if isempty( plot_h{7}.mm_line_h )
        plot_h{7}.mm_line_h = ...
          plot( [ 0; xpos ], ...
                [ 0; ypos ], ...
                'parent', plot_h{7}.ax_h, ...
                'color', mm_mag_line_color, ...
                'linestyle','-', ...
                'linewidth', 1.5*mm_mag_line_width, ...
                'tag','mouse motion freq line');
          PZG(dom_ndx).plot_h{7}.mm_line_h = plot_h{7}.mm_line_h;
      else
        set( plot_h{7}.mm_line_h, ...
            'xdata', [ 0; xpos ], ...
            'ydata', [ 0; ypos ], ...
            'color', mm_mag_line_color, ...
            'visible','on');
      end

      if numel(pd.nyq_freq_str_pos) < 2
        disp('uninitialized nyq freq str pos')
      end

      if isempty( plot_h{7}.mm_freq_h )
        plot_h{7}.mm_freq_h = ...
          text( pd.nyq_freq_str_pos(1), ...
                pd.nyq_freq_str_pos(2), ...
                pd.nicnyq_freqstr, ...
                'parent', plot_h{7}.ax_h, ...
                'color', nyq_text_color, ...
                'fontsize', mm_fontsize, ...
                'fontweight', mm_fontweight, ...
                'tag','mouse motion freq text');
          PZG(dom_ndx).plot_h{7}.mm_freq_h = plot_h{7}.mm_freq_h;
      else
        set( plot_h{7}.mm_freq_h, ...
            'string', pd.nicnyq_freqstr, ...
            'position', pd.nyq_freq_str_pos, ...
            'color', nyq_text_color, ...
            'visible','on');
      end
            
      if isempty( plot_h{7}.mm_mag_h )
        plot_h{7}.mm_mag_h = ...
          text( pd.nyq_mag_str_pos(1), ...
                pd.nyq_mag_str_pos(2), ...
                pd.nic_mag_str, ...
                'parent', plot_h{7}.ax_h, ...
                'color', nyq_text_color, ...
                'fontsize', mm_fontsize, ...
                'fontweight', mm_fontweight, ...
                'rotation', pd.nyq_magphs_str_tilt, ...
                'tag','mouse motion mag text');
          PZG(dom_ndx).plot_h{7}.mm_mag_h = plot_h{7}.mm_mag_h;
      else
        set( plot_h{7}.mm_mag_h, ...
            'string', pd.nic_mag_str, ...
            'position', pd.nyq_mag_str_pos, ...
            'color', nyq_text_color, ...
            'rotation', pd.nyq_magphs_str_tilt, ...
            'visible','on');
            % 'fontsize', mm_fontsize, ...
            % 'fontweight', mm_fontweight, ...
      end
      pd.nyq_phs_str_pos = ...
        [ real(pd.extended_plot_point) imag(pd.extended_plot_point) 0 ];
      if isempty( plot_h{7}.mm_phs_h )
        plot_h{7}.mm_phs_h = ...
          text( pd.nyq_phs_str_pos(1), ...
                pd.nyq_phs_str_pos(2), ...
                pd.nicnyq_phs_str, ...
                'parent', plot_h{7}.ax_h, ...
                'color', nyq_phs_text_color, ...
                'fontsize', mm_fontsize, ...
                'fontweight', mm_fontweight, ...
                'rotation', pd.nyq_magphs_str_tilt, ...
                'tag','mouse motion phs text');
          PZG(dom_ndx).plot_h{7}.mm_phs_h = plot_h{7}.mm_phs_h;
      else
        set( plot_h{7}.mm_phs_h, ...
            'string', pd.nicnyq_phs_str, ...
            'position', pd.nyq_phs_str_pos, ...
            'color', nyq_phs_text_color, ...
            'rotation', pd.nyq_magphs_str_tilt, ...
            'visible','on');
            % 'fontsize', mm_fontsize, ...
            % 'fontweight', mm_fontweight, ...
      end
    end
  end
  
  
  % 0000000000000000000000000000000000000000000000000000000000000000000
  % Update the freq-hilites in CONTINUOUS-TIME p/z map and root loci.
  
  if ~isempty(plot_h{10}) ...
    && isfield(plot_h{10},'fig_h')
    if isempty(pd.ct_bndry_pt) ...
      ||( plot_h{10}.xlim(1) > 0 ) || ( plot_h{10}.xlim(2) < 0 ) ...
      ||( imag(pd.ct_bndry_pt) < plot_h{10}.ylim(1) ) ...
      ||( imag(pd.ct_bndry_pt) > plot_h{10}.ylim(2) )
      if ~isempty(plot_h{10}.mm_freq_h)
        set( plot_h{10}.mm_freq_h,'visible','off')
      end
      if ~isempty(plot_h{10}.mm_mark_h)
        set( plot_h{10}.mm_mark_h,'visible','off')
      end
    else
      if isempty(plot_h{10}.mm_mark_h)
        plot_h{10}.mm_mark_h = ...
          plot([ plot_h{10}.xlim(1), 0 ], ...
               [ imag(pd.ct_bndry_pt), imag(pd.ct_bndry_pt) ], ...
               'color', 1-bg_color, ...
               'linestyle','--', ...
               'linewidth', 2, ...
               'parent', plot_h{10}.ax_h, ...
               'tag','mouse motion freq marker');
        PZG(1).plot_h{10}.mm_mark_h = plot_h{10}.mm_mark_h;
        PZG(2).plot_h{10}.mm_mark_h = plot_h{10}.mm_mark_h;
      else
        set( plot_h{10}.mm_mark_h, ...
            'xdata', [ plot_h{10}.xlim(1), 0 ], ...
            'ydata', [ imag(pd.ct_bndry_pt), imag(pd.ct_bndry_pt) ], ...
            'color', 1-bg_color, ...
            'visible','on');
      end
      pd.ctpzmap_freq_str_pos = ...
        [ 0.02*diff(plot_h{10}.xlim), ...
          imag(pd.ct_bndry_pt)+0.04*diff(plot_h{10}.ylim), 0 ];
      pd.ctpzmap_freq_str_pos(1) = ...
        min( pd.ctpzmap_freq_str_pos(1), ...
             plot_h{10}.xlim(2)-0.2*diff(plot_h{10}.xlim) );
      if ( pd.ctpzmap_freq_str_pos(1) ...
          < ( plot_h{10}.xlim(1) + 0.8*diff(plot_h{10}.xlim) ) ) ...
        &&( pd.ctpzmap_freq_str_pos(2) ...
          < ( plot_h{10}.ylim(1) + 0.3*diff(plot_h{10}.ylim) ) )
        pd.ctpzmap_freq_str_pos(2) = ...
          plot_h{10}.ylim(1) + 0.3*diff(plot_h{10}.ylim);
      end
      if isempty(plot_h{10}.mm_freq_h)
        plot_h{10}.mm_freq_h = ...
          text( pd.ctpzmap_freq_str_pos(1), ...
                pd.ctpzmap_freq_str_pos(2), ...
                pd.ctpzmap_freq_str, ...
               'fontsize', 12, ...
               'fontweight','bold', ...
               'color', 1-bg_color, ...
               'parent', plot_h{10}.ax_h, ...
               'tag','mouse motion freq text');
          PZG(1).plot_h{10}.mm_freq_h = plot_h{10}.mm_freq_h;
          PZG(2).plot_h{10}.mm_freq_h = plot_h{10}.mm_freq_h;
      else
        set( plot_h{10}.mm_freq_h, ...
            'position', pd.ctpzmap_freq_str_pos, ...
            'string', pd.ctpzmap_freq_str, ...
            'color', 1-bg_color, ...
            'visible','on');
            % 'fontsize', 12, ...
            % 'fontweight','bold', ...
      end
    end
  end

  % C-T POLE/ZERO MAP
  if ~isempty(plot_h{12}) ...
    && isfield(plot_h{12},'fig_h')
    if ~isempty(pd.ct_bndry_pt) ...
      &&( plot_h{12}.xlim(1) <= 0 ) && ( plot_h{12}.xlim(2) >= 0 ) ...
      &&( plot_h{12}.ylim(1) <= imag(pd.ct_bndry_pt) ) ...
      &&( plot_h{12}.ylim(2) >= imag(pd.ct_bndry_pt) )
      if isempty(plot_h{12}.mm_mark_h)
        plot_h{12}.mm_mark_h = ...
          plot([ plot_h{12}.xlim(1), 0 ], ...
               [ imag(pd.ct_bndry_pt), imag(pd.ct_bndry_pt) ], ...
               'color', 1-bg_color, ...
               'linestyle','--', ...
               'linewidth', 1, ...
               'marker','.', ...
               'markersize', 12, ...
               'color', 1-bg_color, ...
               'tag','mouse motion freq marker', ...
               'parent', plot_h{12}.ax_h );
        PZG(1).plot_h{12}.mm_mark_h = plot_h{12}.mm_mark_h;
        PZG(2).plot_h{12}.mm_mark_h = plot_h{12}.mm_mark_h;
      else
        set( plot_h{12}.mm_mark_h, ...
            'xdata', [ plot_h{12}.xlim(1), 0 ], ...
            'ydata', [ imag(pd.ct_bndry_pt), imag(pd.ct_bndry_pt) ], ...
            'color', 1-bg_color, ...
            'visible','on');
      end
      pd.ctpzmap_freq_str_pos = ...
        [ 0.02*diff(plot_h{12}.xlim), ...
          imag(pd.ct_bndry_pt)+0.04*diff(plot_h{12}.ylim), 0 ];
      pd.ctpzmap_freq_str_pos(1) = ...
        min( pd.ctpzmap_freq_str_pos(1), ...
             plot_h{12}.xlim(2)-0.22*diff(plot_h{12}.xlim) );
      if ( pd.ctpzmap_freq_str_pos(1) ...
          < ( plot_h{12}.xlim(1) + 0.6*diff(plot_h{12}.xlim) ) ) ...
        &&( pd.ctpzmap_freq_str_pos(2) ...
          < ( plot_h{12}.ylim(1) + 0.25*diff(plot_h{12}.ylim) ) )
        pd.ctpzmap_freq_str_pos(2) = ...
          plot_h{12}.ylim(1) + 0.25*diff(plot_h{12}.ylim);
      end
      pd.ctpzmap_freq_str_pos(2) = ...
        max( ( PZG(1).plot_h{12}.ylim(1)+0.05*diff(PZG(1).plot_h{12}.ylim) ), ...
          min( pd.ctpzmap_freq_str_pos(2), ...
            ( PZG(1).plot_h{12}.ylim(2)-0.05*diff(PZG(1).plot_h{12}.ylim) ) ) );
      if isempty(plot_h{12}.mm_freq_h)
        plot_h{12}.mm_freq_h = ...
          text( pd.ctpzmap_freq_str_pos(1), ...
                pd.ctpzmap_freq_str_pos(2), ...
                pd.ctpzmap_freq_str, ...
               'fontsize', 12, ...
               'fontweight','bold', ...
               'color', 1-bg_color, ...
               'parent', plot_h{12}.ax_h, ...
               'tag','mouse motion freq text');
          PZG(1).plot_h{12}.mm_freq_h = plot_h{12}.mm_freq_h;
          PZG(2).plot_h{12}.mm_freq_h = plot_h{12}.mm_freq_h;
      else
        set( plot_h{12}.mm_freq_h, ...
            'position', pd.ctpzmap_freq_str_pos, ...
            'string', pd.ctpzmap_freq_str, ...
            'color', 1-bg_color, ...
            'visible','on');
      end
      if PZG(dom_ndx).pzg_show_frf_computation
        if imag(pd.ct_bndry_pt) > 0
          if pd.ctpzmap_freq_str_pos(2) ...
            > ( PZG(1).plot_h{12}.ylim(1)+0.2*diff(PZG(1).plot_h{12}.ylim) )
            pd.ctpzmap_freq_str_pos(2) = ...
              pd.ctpzmap_freq_str_pos(2) ...
              - 0.13*diff(PZG(1).plot_h{12}.ylim);
          else
            pd.ctpzmap_freq_str_pos(2) = ...
              pd.ctpzmap_freq_str_pos(2) ...
              + 0.05*diff(PZG(1).plot_h{12}.ylim);
          end
          set( plot_h{12}.mm_freq_h,'position', pd.ctpzmap_freq_str_pos )
        elseif ( imag(pd.ct_bndry_pt) ...
                > -0.1*diff(PZG(1).plot_h{12}.ylim) ) ...
          &&( imag(pd.ct_bndry_pt) ...
             > ( PZG(1).plot_h{12}.ylim(1)+0.1*diff(PZG(1).plot_h{12}.ylim) ) )
            pd.ctpzmap_freq_str_pos(2) = ...
              min( pd.ctpzmap_freq_str_pos(2), ...
                  -0.08*diff(PZG(1).plot_h{12}.ylim) );
        end
        set( plot_h{12}.mm_freq_h,'position', pd.ctpzmap_freq_str_pos );
      end
    else
      if ~isempty(plot_h{12}.mm_freq_h)
        set( plot_h{12}.mm_freq_h,'visible','off')
      end
      if ~isempty(plot_h{12}.mm_mark_h)
        set( plot_h{12}.mm_mark_h,'visible','off')
      end
    end
  end
  
  % 0000000000000000000000000000000000000000000000000000000000000000000
  % Update the freq-hilites in DISCRETE-TIME p/z map and root loci.
  
  % D-T ROOT LOCUS
  if ~isempty(plot_h{11}) ...
    && isfield(plot_h{11},'fig_h')
    if isempty(pd.dt_bndry_pt) ...
      ||( real(pd.dt_bndry_pt) < plot_h{11}.xlim(1) ) ...
      ||( real(pd.dt_bndry_pt) > plot_h{11}.xlim(2) ) ...
      ||( imag(pd.dt_bndry_pt) < plot_h{11}.ylim(1) ) ...
      ||( imag(pd.dt_bndry_pt) > plot_h{11}.ylim(2) )
      if ~isempty(plot_h{11}.mm_freq_h)
        set( plot_h{11}.mm_freq_h,'visible','off')
      end
      if ~isempty(plot_h{11}.mm_mark_h)
        set( plot_h{11}.mm_mark_h,'visible','off')
      end
    else
      if isempty(plot_h{11}.mm_mark_h)
        plot_h{11}.mm_mark_h = ...
          plot([ 0; real(pd.dt_bndry_pt) ], ...
               [ 0; imag(pd.dt_bndry_pt) ], ...
               'color', 1-bg_color, ...
               'linestyle','--', ...
               'linewidth', 2, ...
               'parent', plot_h{11}.ax_h, ...
               'tag','mouse motion freq marker');
        PZG(1).plot_h{11}.mm_mark_h = plot_h{11}.mm_mark_h;
        PZG(2).plot_h{11}.mm_mark_h = plot_h{11}.mm_mark_h;
      else
        set( plot_h{11}.mm_mark_h, ...
            'xdata', [ 0; real(pd.dt_bndry_pt) ], ...
            'ydata', [ 0; imag(pd.dt_bndry_pt) ], ...
            'color', 1-bg_color, ...
            'visible','on');
      end
      pd.dt_rtloc_freq_str_pos = ...
        [ real(pd.dt_bndry_pt), ( imag(pd.dt_bndry_pt) ...
            + 0.03*sign(imag(pd.dt_bndry_pt+eps))*diff(plot_h{11}.ylim) ), 0 ];
      pd.dt_rtloc_freq_str_pos(1) = ...
        min( pd.dt_rtloc_freq_str_pos(1), ...
             plot_h{11}.xlim(2)-0.15*diff(plot_h{11}.xlim) );
      if ( pd.dt_rtloc_freq_str_pos(1) ...
           < ( plot_h{11}.xlim(1)+0.75*diff(plot_h{11}.xlim) ) ) ...
        && ( pd.dt_rtloc_freq_str_pos(2) ...
           < ( plot_h{11}.ylim(1)+0.35*diff(plot_h{11}.xlim) ) )
        pd.dt_rtloc_freq_str_pos(1) = ...
          max( min( plot_h{11}.xlim(2)-0.25*diff(plot_h{11}.xlim), ...
                    0.75*pd.dt_rtloc_freq_str_pos(1) ), ...
               plot_h{11}.xlim(1) ...
               +0.5*(pd.dt_rtloc_freq_str_pos(1)-plot_h{11}.xlim(1)) );
        pd.dt_rtloc_freq_str_pos(2) = ...
          max( pd.dt_rtloc_freq_str_pos(2), ...
               plot_h{11}.ylim(1)+0.35*diff(plot_h{11}.ylim) );
      end
      pd.dt_rtloc_freq_str_pos(1) = ...
        min( pd.dt_rtloc_freq_str_pos(1), ...
             plot_h{11}.xlim(2)-0.2*diff(plot_h{11}.xlim) );
      if isempty(plot_h{11}.mm_freq_h)
        plot_h{11}.mm_freq_h = ...
          text( pd.dt_rtloc_freq_str_pos(1), ...
                pd.dt_rtloc_freq_str_pos(2), ...
                pd.dtpzmap_freq_str, ...
               'fontsize', 12, ...
               'fontweight','bold', ...
               'color', 1-bg_color, ...
               'parent', plot_h{11}.ax_h, ...
               'tag','mouse motion freq text');
        PZG(1).plot_h{11}.mm_freq_h = plot_h{11}.mm_freq_h;
        PZG(2).plot_h{11}.mm_freq_h = plot_h{11}.mm_freq_h;
      else
        set( plot_h{11}.mm_freq_h, ...
            'position', pd.dt_rtloc_freq_str_pos, ...
            'string', pd.dtpzmap_freq_str, ...
            'color', 1-bg_color, ...
            'visible','on');
      end
    end
  end
  
  % D-T POLE/ZERO MAP
  if ~isempty(plot_h{13}) ...
    && isfield(plot_h{13},'fig_h')
    if ~isempty(pd.dt_bndry_pt) ...
      &&( plot_h{13}.xlim(1) <= real(pd.dt_bndry_pt) ) ...
      && ( plot_h{13}.xlim(2) >= real(pd.dt_bndry_pt) ) ...
      &&( plot_h{13}.ylim(1) <= imag(pd.dt_bndry_pt) ) ...
      &&( plot_h{13}.ylim(2) >= imag(pd.dt_bndry_pt) )
      if isempty(plot_h{13}.mm_mark_h)
        plot_h{13}.mm_mark_h = ...
          plot([ 0; real(pd.dt_bndry_pt) ], ...
               [ 0; imag(pd.dt_bndry_pt) ], ...
               'color', 1-bg_color, ...
               'linestyle','--', ...
               'marker','.', ...
               'markersize', 12, ...
               'linewidth', 1, ...
               'parent', plot_h{13}.ax_h, ...
               'tag','mouse motion freq marker');
        PZG(1).plot_h{13}.mm_mark_h = plot_h{13}.mm_mark_h;
        PZG(2).plot_h{13}.mm_mark_h = plot_h{13}.mm_mark_h;
      else
        set( plot_h{13}.mm_mark_h, ...
            'xdata', [ 0; real(pd.dt_bndry_pt) ], ...
            'ydata', [ 0; imag(pd.dt_bndry_pt) ], ...
            'color', 1-bg_color, ...
            'visible','on');
      end
      pd.dt_rtloc_freq_str_pos = ...
        [ real(pd.dt_bndry_pt), ( imag(pd.dt_bndry_pt) ...
            + 0.03*sign(imag(pd.dt_bndry_pt+eps))*diff(plot_h{13}.ylim) ), 0 ];
      if( pd.dt_rtloc_freq_str_pos(1) ...
           < ( plot_h{13}.xlim(1)+0.75*diff(plot_h{13}.xlim) ) ) ...
        && ( pd.dt_rtloc_freq_str_pos(2) ...
           < ( plot_h{13}.ylim(1)+0.35*diff(plot_h{13}.xlim) ) )
        pd.dt_rtloc_freq_str_pos(1) = ...
          max( min( plot_h{13}.xlim(2)-0.25*diff(plot_h{13}.xlim), ...
                    0.75*pd.dt_rtloc_freq_str_pos(1) ), ...
               plot_h{13}.xlim(1) ...
               +0.5*(pd.dt_rtloc_freq_str_pos(1)-plot_h{13}.xlim(1)) );
        pd.dt_rtloc_freq_str_pos(2) = ...
          max( pd.dt_rtloc_freq_str_pos(2), ...
               plot_h{13}.ylim(1)+0.2*diff(plot_h{13}.ylim) );
      end
      pd.dt_rtloc_freq_str_pos(1) = ...
        min( pd.dt_rtloc_freq_str_pos(1), ...
             plot_h{13}.xlim(2)-0.2*diff(plot_h{13}.xlim) );
      if isempty(plot_h{13}.mm_freq_h)
        plot_h{13}.mm_freq_h = ...
          text( pd.dt_rtloc_freq_str_pos(1), ...
                pd.dt_rtloc_freq_str_pos(2), ...
                pd.dtpzmap_freq_str, ...
               'fontsize', 12, ...
               'fontweight','bold', ...
               'color', 1-bg_color, ...
               'parent', plot_h{13}.ax_h, ...
               'tag','mouse motion freq text');
        PZG(1).plot_h{13}.mm_freq_h = plot_h{13}.mm_freq_h;
        PZG(2).plot_h{13}.mm_freq_h = plot_h{13}.mm_freq_h;
      else
        set( plot_h{13}.mm_freq_h, ...
            'position', pd.dt_rtloc_freq_str_pos, ...
            'string', pd.dtpzmap_freq_str, ...
            'color', 1-bg_color, ...
            'visible','on');
      end
      if PZG(dom_ndx).pzg_show_frf_computation
        if real(pd.dt_bndry_pt) > 0
          if imag(pd.dt_bndry_pt) > 0.4
            pd.dt_rtloc_freq_str_pos(1) = ...
              pd.dt_rtloc_freq_str_pos(1) ...
              + 0.1*diff(PZG(2).plot_h{13}.xlim);
            pd.dt_rtloc_freq_str_pos(2) = ...
              pd.dt_rtloc_freq_str_pos(2) ...
              - 0.06*diff(PZG(2).plot_h{13}.ylim);
          elseif imag(pd.dt_bndry_pt) > 0
            pd.dt_rtloc_freq_str_pos(1) = ...
              pd.dt_rtloc_freq_str_pos(1) ...
              + 0.05*diff(PZG(2).plot_h{13}.xlim);
            pd.dt_rtloc_freq_str_pos(2) = ...
              pd.dt_rtloc_freq_str_pos(2) ...
              - 0.06*diff(PZG(2).plot_h{13}.ylim);
          elseif imag(pd.dt_bndry_pt) > -0.4
            pd.dt_rtloc_freq_str_pos(1) = ...
              pd.dt_rtloc_freq_str_pos(1) ...
              + 0.03*diff(PZG(2).plot_h{13}.xlim);
            pd.dt_rtloc_freq_str_pos(2) = ...
              pd.dt_rtloc_freq_str_pos(2) ...
              + 0.1*diff(PZG(2).plot_h{13}.ylim);
          else
            pd.dt_rtloc_freq_str_pos(1) = ...
              pd.dt_rtloc_freq_str_pos(1) ...
              + 0.2*diff(PZG(2).plot_h{13}.xlim);
            pd.dt_rtloc_freq_str_pos(2) = ...
              pd.dt_rtloc_freq_str_pos(2) ...
              + 0.03*diff(PZG(2).plot_h{13}.ylim);
          end
          pd.dt_rtloc_freq_str_pos(1) = ...
            min( pd.dt_rtloc_freq_str_pos(1), ...
                 PZG(2).plot_h{13}.xlim(2)-0.15*diff(PZG(2).plot_h{13}.xlim) );
          set( plot_h{13}.mm_freq_h,'position', pd.dt_rtloc_freq_str_pos )
        end
      end
    else
      if ~isempty(plot_h{13}.mm_freq_h)
        set( plot_h{13}.mm_freq_h,'visible','off')
      end
      if ~isempty(plot_h{13}.mm_mark_h)
        set( plot_h{13}.mm_mark_h,'visible','off')
      end
    end
  end
  
  if ~isempty(plot_h{14}) ...
    && isfield(plot_h{14},'fig_h')
    if isempty( pd.pseudo_contour_pt ) ...
      ||( real(pd.pseudo_contour_pt) < plot_h{14}.xlim(1) ) ...
      ||( real(pd.pseudo_contour_pt) > plot_h{14}.xlim(2) ) ...
      ||( imag(pd.pseudo_contour_pt) < plot_h{14}.ylim(1) ) ...
      ||( imag(pd.pseudo_contour_pt) > plot_h{14}.ylim(2) )
      set( plot_h{14}.mm_freq_h,'visible','off')
      set( plot_h{14}.mm_mark_h,'visible','off')
      set( plot_h{14}.mm_line_h,'visible','off')
    else
      if iscell(pd.nicnyq_freqstr) ...
        &&( numel(pd.nicnyq_freqstr) > 1 ) ...
        && ~isinf( pd.nyq_freq_w ) ...
        && ~isempty( strfind( pd.nicnyq_freqstr{1},':') )
        pd.pseudo_freq_str = pd.nicnyq_freqstr{1};
        colon_ndx = strfind( pd.pseudo_freq_str,':');
        if numel(colon_ndx) == 1
          pd.pseudo_freq_str = ...
            { ['   ' pd.pseudo_freq_str(1:colon_ndx)]; ...
              pd.pseudo_freq_str(colon_ndx+1:end) };
        end
      elseif isinf( pd.nyq_freq_w ) ...
            && iscell(pd.nicnyq_freqstr) ...
            &&( numel(pd.nicnyq_freqstr) > 1 ) ...
            && ~isempty( strfind( pd.nicnyq_freqstr{1},'circ. at') )
        pd.pseudo_freq_str = pd.nicnyq_freqstr{1};
        rhp_ndx = strfind( pd.pseudo_freq_str,'RHP');
        semicirc_ndx = strfind( pd.pseudo_freq_str,'circ. at');
        if ~isempty(rhp_ndx) && ( numel(semicirc_ndx) == 1 )
          semicirc_ndx = semicirc_ndx + 4;
          pd.pseudo_freq_str = ...
            {['   ' pd.pseudo_freq_str(1:rhp_ndx-1) ]; ...
             [' ' pd.pseudo_freq_str(rhp_ndx:semicirc_ndx) ]; ...
             pd.pseudo_freq_str(semicirc_ndx+1:end) };
        end
      else
        pd.pseudo_freq_str = pd.nicnyq_freqstr;
      end
      if imag(pd.pseudo_contour_pt) >= 0
        pd.pseudo_freq_str_loc = ...
          [ real(pd.pseudo_contour_pt)+0.04*diff(plot_h{14}.xlim), ...
            imag(pd.pseudo_contour_pt)+0.10*diff(plot_h{14}.ylim), 0 ];
      else
        pd.pseudo_freq_str_loc = ...
          [ real(pd.pseudo_contour_pt)+0.01*diff(plot_h{14}.xlim), ...
            imag(pd.pseudo_contour_pt)-0.10*diff(plot_h{14}.ylim), 0 ];
      end
      if pd.dom_ndx == 1
        if ( abs( real(pd.contour_pt) ) < 1e-12 ) ...
          &&( isempty(pd.contour_angle) ...
             || isnan(pd.contour_angle) ...
             ||( pd.contour_angle < -89.9 ) ...
             ||( pd.contour_angle > 89.9 ) )
          center_pt = 1i * abs(imag(pd.pseudo_contour_pt));
        else
          if isinf( pd.nyq_freq_w )
            % On the infinite-radius contour
            center_pt = 0;
          else
            if isempty( PZG(1).cntr_data.ld_pseudo_pole_freqs )
              min_pdist = inf;
              min_pdist_ndx = [];
            else
              [ min_pdist, min_pdist_ndx ] = ...
                 min( abs( abs(imag(pd.pseudo_contour_pt)) ...
                          -PZG(1).cntr_data.ld_pseudo_pole_freqs ) );
            end
            if isempty(PZG(1).cntr_data.ld_pseudo_zero_freqs)
              min_zdist = inf;
              min_zdist_ndx = [];
            else
              [ min_zdist, min_zdist_ndx ] = ...
                 min( abs( abs(imag(pd.pseudo_contour_pt)) ...
                          -PZG(1).cntr_data.ld_pseudo_zero_freqs ) );
            end
            if ~isinf(min_zdist) && ( min_zdist < min_pdist )
              center_pt = ...
                1i * PZG(1).cntr_data.ld_pseudo_zero_freqs(min_zdist_ndx);
            elseif ~isinf(min_pdist)
              center_pt = ...
                1i * PZG(1).cntr_data.ld_pseudo_pole_freqs(min_pdist_ndx);
            else
              center_pt = 0;
            end
          end
        end
        other_end = plot_h{14}.xlim(1) + center_pt;
        
      else
        % Discrete-time
        if abs( abs(pd.pseudo_contour_pt) - 1 ) < 1e-10
          center_pt = real(pd.pseudo_contour_pt) ...
                     +1i*abs(imag(pd.pseudo_contour_pt));
        elseif abs( abs(pd.contour_pt) + 1 ) < 1e-10
          center_pt = real(pd.contour_pt) ...
                     +1i*abs(imag(pd.contour_pt));
        else
          if isempty( PZG(2).cntr_data.ld_pseudo_pole_freqs )
            min_pdist = inf;
            min_pdist_ndx = [];
          else
            [ min_pdist, min_pdist_ndx ] = ...
               min( abs( abs(angle(pd.pseudo_contour_pt)) ...
                        - PZG(2).cntr_data.ld_pseudo_pole_freqs ) );
          end
          if isempty(PZG(2).cntr_data.ld_pseudo_zero_freqs)
            min_zdist = inf;
            min_zdist_ndx = [];
          else
            [ min_zdist, min_zdist_ndx ] = ...
               min( abs( abs(angle(pd.pseudo_contour_pt)) ...
                        -PZG(2).cntr_data.ld_pseudo_zero_freqs ) );
          end
          if ~isinf(min_zdist) && ( min_zdist < min_pdist )
            center_pt = ...
              exp(1i*PZG(2).cntr_data.ld_pseudo_zero_freqs(min_zdist_ndx));
          elseif ~isinf(min_pdist)
            center_pt = ...
              exp(1i*PZG(2).cntr_data.ld_pseudo_pole_freqs(min_pdist_ndx));
          else
            center_pt = 1;
          end
        end
        other_end = 0;
      end
      
      line_pts = [ center_pt; other_end ];
      if pd.neg_freq || ( imag(pd.pseudo_contour_pt) < 0 )
        line_pts = conj(line_pts);
        center_pt = conj(center_pt);
      end
      if ischar(pd.pseudo_freq_str)
        pseudo_freq_str_1 = pd.pseudo_freq_str;
      elseif iscell(pd.pseudo_freq_str)
        pseudo_freq_str_1 = pd.pseudo_freq_str{1};
      else
        pseudo_freq_str_1 = '';
      end
      if ( pd.dom_ndx == 1 ) && isinf( pd.nyq_freq_w ) ...
        && isempty( strfind( pseudo_freq_str_1,'infinity rad/s') )
        if ~isempty(plot_h{14}.mm_line_h)
          set( plot_h{14}.mm_line_h,'visible','off');
        end
      else
        if isempty(plot_h{14}.mm_line_h)
          plot_h{14}.mm_line_h = ...
            plot( real(line_pts), imag(line_pts), ...
              'color', 1-bg_color, ...
              'linestyle','-', ...
              'linewidth', 2, ...
              'marker','o', ...
              'markersize', 4, ...
              'markerfacecolor', 1-bg_color, ...
              'parent', plot_h{14}.ax_h, ...
              'tag','mouse motion freq line');
          PZG(dom_ndx).plot_h{14}.mm_line_h = plot_h{14}.mm_line_h;
        else
          set( plot_h{14}.mm_line_h, ...
              'xdata', real(line_pts), ...
              'ydata', imag(line_pts), ...
              'color', 1-bg_color, ...
              'visible','on');
        end
      end
      
      line_pts = [ center_pt; pd.pseudo_contour_pt ];
      if ischar(pd.pseudo_freq_str)
        pseudo_freq_str_1 = pd.pseudo_freq_str;
      elseif iscell(pd.pseudo_freq_str)
        pseudo_freq_str_1 = pd.pseudo_freq_str{1};
      else
        pseudo_freq_str_1 = '';
      end
      if pd.nyq_mag_is_inf || pd.nyq_mag_is_zero ...
        || ~isempty( strfind( pseudo_freq_str_1,'infinity rad/s') )
        % Point on an indent
        if isempty(plot_h{14}.mm_mark_h)
          plot_h{14}.mm_mark_h = ...
            plot( real(line_pts), ...
                  imag(line_pts), ...
                 'color', 1-bg_color, ...
                 'linestyle','-', ...
                 'linewidth', 2, ...
                 'marker','o', ...
                 'markersize', 4, ...
                 'parent', plot_h{14}.ax_h, ...
                 'tag','mouse motion freq marker');
          PZG(dom_ndx).plot_h{14}.mm_mark_h = plot_h{14}.mm_mark_h;
        else
          set( plot_h{14}.mm_mark_h, ...
              'xdata', real(line_pts), ...
              'ydata', imag(line_pts), ...
              'color', 1-bg_color, ...
              'visible','on');
        end
      else
        % Point on stability boundary
        if ~isempty(plot_h{14}.mm_mark_h)
          set( plot_h{14}.mm_mark_h,'visible','off');
        end
      end
      if isequal( 1, pd.contour_flag )
        pd.pseudo_freq_str_loc(1) = ...
          min( pd.pseudo_freq_str_loc(1), ...
               plot_h{14}.xlim(2)-0.2*diff(plot_h{14}.xlim) );
        pd.pseudo_freq_str_loc(2) = ...
          max( min( pd.pseudo_freq_str_loc(2), ...
                    plot_h{14}.ylim(2)-0.08*diff(plot_h{14}.ylim) ), ...
               plot_h{14}.ylim(1)+0.08*diff(plot_h{14}.ylim) );
      else
        pd.pseudo_freq_str_loc(1) = ...
          min( pd.pseudo_freq_str_loc(1), ...
               plot_h{14}.xlim(2)-0.5*diff(plot_h{14}.xlim) );
        pd.pseudo_freq_str_loc(2) = ...
          max( min( pd.pseudo_freq_str_loc(2), ...
                    plot_h{14}.ylim(2)-0.15*diff(plot_h{14}.ylim) ), ...
               plot_h{14}.ylim(1)+0.15*diff(plot_h{14}.ylim) );
      end
      if ~isequal( pd.contour_flag, 1 )
        if( real(pd.pseudo_contour_pt) ...
           >( plot_h{14}.xlim(1)+0.7*diff(plot_h{14}.xlim) ) )
          pd.pseudo_freq_str_loc(1) = ...
            max( plot_h{14}.xlim(1)+0.01*diff(plot_h{14}.xlim), ...
                 real(pd.pseudo_contour_pt)-0.7*diff(plot_h{14}.xlim) );
        elseif ( imag(pd.pseudo_contour_pt) ...
                <( plot_h{14}.ylim(1)+0.35*diff(plot_h{14}.ylim) ) )
          pd.pseudo_freq_str_loc(2) = ...
            plot_h{14}.ylim(1)+0.3*diff(plot_h{14}.ylim); 
        end
      end
      if isempty(plot_h{14}.mm_freq_h)
        plot_h{14}.mm_freq_h = ...
          text( pd.pseudo_freq_str_loc(1), ...
                pd.pseudo_freq_str_loc(2), ...
                pd.pseudo_freq_str, ...
               'fontsize', 12, ...
               'fontweight','bold', ...
               'color', 1-bg_color, ...
               'parent', plot_h{14}.ax_h, ...
               'tag','mouse motion freq text');
        PZG(dom_ndx).plot_h{14}.mm_freq_h = plot_h{14}.mm_freq_h;
      else
        set( plot_h{14}.mm_freq_h, ...
            'position', pd.pseudo_freq_str_loc, ...
            'string', pd.pseudo_freq_str, ...
            'color', 1-bg_color, ...
            'visible','on');
      end
    end
  end
  
return

function [ plot_h, curr_ploth_ndx ] = ...
             local_get_pzg_fig_data( dom_ndx, curr_fig_h, fig_h_ndx )
  global PZG
  
  curr_ploth_ndx = [];
  if ~nargin
    plot_h = [];
    return
  elseif ( nargin == 1 ) || isempty(curr_fig_h)
    plot_h = PZG(dom_ndx).plot_h;
    return
  end
  
  if isequal( 1, numel(curr_fig_h) ) ...
    && isequal( 1, ishandle(curr_fig_h) ) ...
    && strcmp( get(curr_fig_h,'type'),'figure') ...
    && isappdata( curr_fig_h,'hndl')
    currfig_hndl = getappdata( curr_fig_h,'hndl');
    curr_ploth_ndx = currfig_hndl.ploth_ndx;
  else
    if ( nargin < 3 ) || isempty(fig_h_ndx)
      for dom_ndx = 1:2
        for ph_ndx = 1:numel(PZG(dom_ndx).plot_h)
          if isfield( PZG(dom_ndx).plot_h{ph_ndx},'fig_h') ...
            && isequal( 1, numel(PZG(dom_ndx).plot_h{ph_ndx}.fig_h) ) ...
            && ( curr_fig_h == PZG(dom_ndx).plot_h{ph_ndx}.fig_h )
            curr_ploth_ndx = ph_ndx;
            break
          end
        end
        if ~isempty(curr_ploth_ndx)
          break
        end
      end
    else
      curr_ploth_ndx = fig_h_ndx;
    end
  end
  
  plot_h = PZG(dom_ndx).plot_h;
  
  for k = 1:numel(plot_h)
    if isempty( plot_h{k}) || ~isfield( plot_h{k},'fig_h') ...
      || isempty(plot_h{k}.fig_h)
      continue
    elseif ~isfield( PZG(dom_ndx).plot_h{k},'fig_h') ...
      || ~isfield( PZG(dom_ndx).plot_h{k},'hndl')
      continue
    end
    if strcmp( PZG(dom_ndx).DefaultBackgroundColor,'w')
      plot_h{k}.bg_color = [1 1 1];
    else
      plot_h{k}.bg_color = [0 0 0];
    end
    
    switch k
      case 1
        plot_h{1}.plot_name = [ PZG(dom_ndx).OLBodeName ' Magnitude'];
        plot_h{1}.dB_cb = get( plot_h{1}.hndl.BodeDBChkbox,'value');
        plot_h{1}.Hz_cb = get( plot_h{1}.hndl.BodeHZChkbox,'value');
        plot_h{1}.Log_cb = get( plot_h{1}.hndl.BodeAxesLinLogChkbox,'value');
        if k == curr_ploth_ndx
          plot_h{1}.neg_freq = 0;
        end
       
      case 2
        plot_h{2}.plot_name = [ PZG(dom_ndx).OLBodeName ' Phase'];
        plot_h{2}.unwrap_cb = get( plot_h{2}.hndl.UnwrapChkbox,'value');
        plot_h{2}.Hz_cb = get( plot_h{2}.hndl.BodeHZChkbox,'value');
        plot_h{2}.Log_cb = get( plot_h{2}.hndl.BodeAxesLinLogChkbox,'value');
        if k == curr_ploth_ndx
          plot_h{2}.neg_freq = 0;
        end
        
      case 3
        plot_h{3}.plot_name = [ PZG(dom_ndx).CLBodeName ' Magnitude'];
        plot_h{3}.dB_cb = get( plot_h{3}.hndl.BodeDBChkbox,'value');
        plot_h{3}.Hz_cb = get( plot_h{3}.hndl.BodeHZChkbox,'value');
        plot_h{3}.Log_cb = get( plot_h{3}.hndl.BodeAxesLinLogChkbox,'value');
        if k == curr_ploth_ndx
          plot_h{3}.neg_freq = 0;
        end
       
      case 4
        plot_h{4}.plot_name = [ PZG(dom_ndx).CLBodeName ' Phase'];
        plot_h{4}.unwrap_cb = get( plot_h{4}.hndl.UnwrapChkbox,'value');
        plot_h{4}.Hz_cb = get( plot_h{4}.hndl.BodeHZChkbox,'value');
        plot_h{4}.Log_cb = get( plot_h{4}.hndl.BodeAxesLinLogChkbox,'value');
        if k == curr_ploth_ndx
          plot_h{4}.neg_freq = 0;
        end
        
      case 5
        plot_h{5}.plot_name = PZG(dom_ndx).SensPlotName;
        if isfield( plot_h{5}.hndl,'BodeHZChkbox')
          plot_h{5}.Hz_cb = get( plot_h{5}.hndl.BodeHZChkbox,'value');
        else
          plot_h{5}.Hz_cb = 0;
        end
        if isfield( plot_h{5}.hndl,'BodeAxesLinLogChkbox')
          plot_h{5}.Log_cb = get( plot_h{5}.hndl.BodeAxesLinLogChkbox,'value');
        else
          plot_h{5}.Log_cb = 1;
        end
        if k == curr_ploth_ndx
          plot_h{5}.neg_freq = 0;
        end

      case 6
        plot_h{6}.plot_name = PZG(dom_ndx).NicholsName;
        plot_h{6}.nyq_data_cb = ...
          get( PZG(dom_ndx).plot_h{6}.hndl.show_nyq_mapping_checkbox,'value');
        plot_h{6}.cl_grid_cb = ...
          get( PZG(dom_ndx).plot_h{6}.hndl.CL_mag_phase_grid_checkbox,'value');
        plot_h{6}.hilite_cb = ...
          get( PZG(dom_ndx).plot_h{6}.hndl.Nichols_hilite_cursor_checkbox,'value');

      case 7
        plot_h{7}.plot_name = PZG(dom_ndx).NyquistName;
        plot_h{7}.hybrid_scaling_cb = ...
          get( PZG(dom_ndx).plot_h{7}.hndl.rescale_checkbox,'value');
        
      case 8
        plot_h{8}.plot_name = PZG(dom_ndx).OLTimeRespName;
        intype_h = PZG(dom_ndx).plot_h{8}.hndl.input_type_popupmenu;
        plot_h{8}.input_type = get( intype_h,'value');
        
      case 9
        plot_h{9}.plot_name = PZG(dom_ndx).CLTimeRespName;
        intype_h = PZG(dom_ndx).plot_h{9}.hndl.input_type_popupmenu;
        plot_h{9}.input_type = get( intype_h,'value');
        
      case 10
        plot_h{10}.plot_name = PZG(1).RootLocusName;
        
      case 11
        plot_h{11}.plot_name = PZG(2).RootLocusName;
        
      case 12
        plot_h{12}.plot_name = PZG(1).PZGUIname;
        
      case 13
        plot_h{13}.plot_name = PZG(2).PZGUIname;
        
      case 14
        plot_h{14}.plot_name = PZG(dom_ndx).NyqContourPlotName;

      otherwise
    end
  end
  
  for k = 1:numel(plot_h)
    if isempty(plot_h{k}) || ~isfield( plot_h{k},'fig_h') ...
      || isempty(plot_h{k}.fig_h)
      continue
    elseif ~isequal( 1, ishandle(plot_h{k}.fig_h) )
      for kdel = numel(plot_h{k}.fig_h):-1:2
        if isequal( 1, ishandle(plot_h{k}.fig_h(kdel)) )
          delete( plot_h{k}.fig_h(kdel) )
          plot_h{k}.fig_h(kdel) = [];
        end
      end
      if ~isequal( 1, ishandle(plot_h{k}.fig_h) )
        plot_h{k} = [];
        continue
      end
    end
        
    if ~isempty(plot_h{k}) ...
      && isfield( plot_h{k},'fig_h') && ~isempty(plot_h{k}.fig_h) ...
      && isfield( plot_h{k},'ax_h') && ~isempty(plot_h{k}.ax_h)
      if isempty(plot_h{k}.fig_h) || isempty(plot_h{k}.ax_h)
        plot_h{k} = [];
      else
        if ~isfield( plot_h{k},'xlim')
          if isfield( plot_h{k}.hndl,'ax_xlim')
            plot_h{k}.xlim = plot_h{k}.hndl.ax_xlim;
          else
            plot_h{k}.xlim = get( plot_h{k}.ax_h,'xlim');
          end
        end
        if ~isfield( plot_h{k},'ylim')
          if isfield( plot_h{k}.hndl,'ax_ylim')
            plot_h{k}.ylim = plot_h{k}.hndl.ax_ylim;
          else
            plot_h{k}.ylim = get( plot_h{k}.ax_h,'ylim');
          end
        end
        
        try
          if numel(plot_h{k}.mm_freq_h) > 1
            delete( plot_h{k}.mm_freq_h )
            plot_h{k}.mm_freq_h = [];
            PZG(dom_ndx).plot_h{k}.mm_freq_h = [];
          end
        catch
          plot_h{k}.mm_freq_h = [];
          PZG(dom_ndx).plot_h{k}.mm_freq_h = [];
        end
        
        try
          if numel(plot_h{k}.mm_mag_h) > 1
            delete( plot_h{k}.mm_mag_h )
            plot_h{k}.mm_mag_h = [];
            PZG(dom_ndx).plot_h{k}.mm_mag_h = [];
          end
        catch
          plot_h{k}.mm_mag_h = [];
          PZG(dom_ndx).plot_h{k}.mm_mag_h = [];
        end
        
        try
          if numel(plot_h{k}.mm_phs_h) > 1
            delete( plot_h{k}.mm_phs_h )
            plot_h{k}.mm_phs_h = [];
            PZG(dom_ndx).plot_h{k}.mm_phs_h = [];
          end
        catch
          plot_h{k}.mm_phs_h = [];
          PZG(dom_ndx).plot_h{k}.mm_phs_h = [];
        end
        
        try
          if numel(plot_h{k}.mm_line_h) > 1
            delete( plot_h{k}.mm_line_h )
            plot_h{k}.mm_line_h = [];
            PZG(dom_ndx).plot_h{k}.mm_line_h = [];
          end
        catch
          plot_h{k}.mm_line_h = [];
          PZG(dom_ndx).plot_h{k}.mm_line_h = [];
        end
        
        try
          if numel(plot_h{k}.mm_mark_h) > 1
            delete( plot_h{k}.mm_mark_h )
            plot_h{k}.mm_mark_h = [];
            PZG(dom_ndx).plot_h{k}.mm_mark_h = [];
          end
        catch
          plot_h{k}.mm_mark_h = [];
          PZG(dom_ndx).plot_h{k}.mm_mark_h = [];
        end

        if ( isreal(curr_fig_h) && isequal( plot_h{k}.fig_h, curr_fig_h ) ) ...
          ||( ~isreal(curr_fig_h) && isequal( 1, ishandle(curr_fig_h) ) ...
             && isequal( 1, ishandle(plot_h{k}.fig_h) ) ...
             && ( plot_h{k}.fig_h == curr_fig_h ) )
          curr_ploth_ndx = k;
          plot_h = local_get_mm_freqs( plot_h, dom_ndx, curr_ploth_ndx );
        end
      end
    end
  end
  
  if ~isempty(curr_ploth_ndx) ...
    &&( numel(plot_h) >= curr_ploth_ndx ) ...
    && ~isempty( plot_h{curr_ploth_ndx} ) ...
    && isstruct( plot_h{curr_ploth_ndx}) ...
    && isfield( plot_h{curr_ploth_ndx},'ax_h') ...
    && isfield( plot_h{curr_ploth_ndx},'CurrPt') ...
    && isempty( plot_h{curr_ploth_ndx}.CurrPt )
    currentpoint = get( plot_h{curr_ploth_ndx}.ax_h,'currentpoint');
    if isequal( size(currentpoint), [2 3])
      plot_h{curr_ploth_ndx}.CurrPt = currentpoint(1,1) + 1i*currentpoint(1,2);
    end
  end
  
  if numel(plot_h) < 14
    plot_h = [ plot_h, cell( 1, 14-numel(plot_h) ) ];
  end
  
  PZG(dom_ndx).plot_h = plot_h;
  
  if ( dom_ndx == 1 )
    if ~isfield(PZG(2),'plot_h') || isempty( PZG(2).plot_h )
      PZG(2).plot_h = cell(14,1);
    end
    PZG(2).plot_h(10) = PZG(1).plot_h(10);
    PZG(2).plot_h(12) = PZG(1).plot_h(12);
  else
    if ~isfield(PZG(1),'plot_h') || isempty( PZG(1).plot_h )
      PZG(1).plot_h = cell(14,1);
    end
    PZG(1).plot_h(13) = PZG(2).plot_h(13);
    PZG(2).plot_h(12) = PZG(1).plot_h(12);
  end

return

function plot_h = local_get_mm_freqs( plot_h, dom_ndx, curr_ploth_ndx )
  
  global PZG
  
  plot_h{curr_ploth_ndx}.CurrPt = [];
  plot_h{curr_ploth_ndx}.neg_freq = 0;
  plot_h{curr_ploth_ndx}.mindist = inf;
  plot_h{curr_ploth_ndx}.bodedata_ndx = [];
  plot_h{curr_ploth_ndx}.nyqdata_ndx = [];
  plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = [];
  plot_h{curr_ploth_ndx}.ct_pzmap_freq = [];
  plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = [];
  plot_h{curr_ploth_ndx}.dt_pzmap_freq = [];
  plot_h{curr_ploth_ndx}.nearest_freq = [];
  
  plotdata = plot_h{curr_ploth_ndx};
    
  CurrPt = get(plotdata.ax_h,'currentpoint');
  CurrPt = CurrPt(1,1) + 1i*CurrPt(1,2);
  if ( real(CurrPt) < plotdata.xlim(1) ) ...
    ||( real(CurrPt) > plotdata.xlim(2) ) ...
    ||( imag(CurrPt) < plotdata.ylim(1) ) ...
    ||( imag(CurrPt) > plotdata.ylim(2) )
    
    return
  end
  plot_h{curr_ploth_ndx}.CurrPt = CurrPt;
  
  if ~isempty( plot_h{12} ) ...
    && isfield( plot_h{12},'fig_h')
    % Determine C-T mapping method.
    menu_h = PZG(1).plot_h{12}.hndl.LinkMethod;
    if ~isempty(menu_h) && isequal( get(menu_h,'value'), 3 )
      bilinear_mapg = 1;
    else
      bilinear_mapg = 0;
    end
    plot_h{12}.bilinear = bilinear_mapg;
    if ~isempty(plot_h{13}) ...
      && isfield( plot_h{13},'fig_h')
      plot_h{13}.bilinear = bilinear_mapg;
    end
  end
  if ( numel(plot_h) > 12 ) && ~isempty( plot_h{13} ) ...
    && isfield( plot_h{13},'fig_h')
    % Determine C-T mapping method.
    menu_h = PZG(2).plot_h{13}.hndl.LinkMethod;
    if ~isempty(menu_h) && isequal( get(menu_h,'value'), 3 )
      bilinear_mapg = 1;
    else
      bilinear_mapg = 0;
    end
    plot_h{13}.bilinear = bilinear_mapg;
    if ~isempty(plot_h{12}) ...
      && isfield( plot_h{12},'fig_h')
      plot_h{12}.bilinear = bilinear_mapg;
    end
  end

  
  switch curr_ploth_ndx
    case {1,2,3,4,5}
      % Bode plots (positive frequency).
      line_h = PZG(dom_ndx).plot_h{curr_ploth_ndx}.hndl.Bode_Line;
      if numel(line_h) > 1
        delete( line_h(2:end) )
        line_h = line_h(1);
      end
      xdata0 = get( line_h(1),'xdata');
      ydata0 = get( line_h(1),'ydata');
      if ~isequal( numel(xdata0), numel(PZG(dom_ndx).BodeFreqs) )
        return
      end
      % Restrict analysis to points within the plot X-limits.
      ndx1 = pzg_gle( xdata0, plotdata.xlim(1),'near');
      ndx2 = pzg_gle( xdata0, plotdata.xlim(2),'near');
      xdata = xdata0( min(ndx1+1,ndx2):max(ndx1,ndx2-1) );
      ydata = ydata0( min(ndx1+1,ndx2):max(ndx1,ndx2-1) );
      
      if ~isempty(xdata) && ~isempty(ydata)
        if plotdata.Log_cb
          dist = ( abs( log10(real(CurrPt)) - log10(xdata) ) ...
                   /diff( log10(plotdata.xlim)) ).^2 ...
                 +( abs( imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
        else
          dist = ( abs( real(CurrPt) - xdata )/diff(plotdata.xlim) ).^2 ...
                +( abs( imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
        end
        [ mindist, mindist_ndx ] = min( dist );
        mindist_ndx = mindist_ndx + ndx1 - 1;
        mindist_ndx = min( mindist_ndx, numel(PZG(dom_ndx).BodeFreqs) );
        
        if abs( real(CurrPt) - xdata0(min(mindist_ndx+1,numel(xdata0))) ) ...
          < abs( real(CurrPt) - xdata0(mindist_ndx) )
          mindist_ndx = min(mindist_ndx+1,numel(xdata0));
        elseif abs( real(CurrPt) - xdata0(max(mindist_ndx-1,numel(xdata0))) ) ...
              < abs( real(CurrPt) - xdata0(mindist_ndx) )
          mindist_ndx = min(mindist_ndx+1,numel(xdata0));
        end
        
        bode_freq = PZG(dom_ndx).BodeFreqs(mindist_ndx);
        plot_h{curr_ploth_ndx}.bodedata_ndx = mindist_ndx;
        plot_h{curr_ploth_ndx}.mindist = sqrt(mindist);
        plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = 1i * bode_freq;
        plot_h{curr_ploth_ndx}.ct_pzmap_freq = bode_freq;
        plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = ...
          exp( 1i* bode_freq * PZG(2).Ts );
        plot_h{curr_ploth_ndx}.dt_pzmap_freq = bode_freq;
        
        nyq_freq = bode_freq;
        if dom_ndx == 1
          plot_h{curr_ploth_ndx}.nyqdata_ndx = ...
            pzg_gle( PZG(dom_ndx).cntr_data.contour_freq, ...
                     bode_freq,'near');
        else
          nyq_freq = mod( nyq_freq, 2*pi/PZG(2).Ts );
          if nyq_freq < pi/PZG(2).Ts
            plot_h{curr_ploth_ndx}.nyqdata_ndx = ...
              pzg_gle( PZG(dom_ndx).cntr_data.contour_freq, ...
                       nyq_freq,'near');
          else
            plot_h{curr_ploth_ndx}.nyqdata_ndx = ...
              pzg_gle( PZG(dom_ndx).cntr_data.contour_freq, ...
                       ( 2*pi/PZG(2).Ts - nyq_freq ),'near');
            plot_h{curr_ploth_ndx}.neg_freq = 1;
          end
        end
        if ~isinf( nyq_freq )
          plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = 1i * bode_freq;
          plot_h{curr_ploth_ndx}.ct_pzmap_freq = bode_freq;
          plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = ...
            exp( 1i* nyq_freq * PZG(2).Ts );
          plot_h{curr_ploth_ndx}.dt_pzmap_freq = bode_freq;
        end
      end
      
      
    case 6
      % Nichols plot
      if plotdata.nyq_data_cb
        % Nyquist lines are turned on.
        xdata = PZG(dom_ndx).cntr_data.Nichols_phs;
        ydata = PZG(dom_ndx).cntr_data.Nichols_mag;
        freqdata = PZG(dom_ndx).cntr_data.contour_freq;
        if dom_ndx == 2
          nyq_ndx = pzg_gle( freqdata, 2*pi/PZG(2).Ts,'<');
          xdata = xdata(1:nyq_ndx);
          ydata = ydata(1:nyq_ndx);
          freqdata = freqdata(1:nyq_ndx);
        end
        dist1 = ( ( real(CurrPt) - xdata )/diff(plotdata.xlim) ).^2 ...
               +( ( imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
        [ mindist1, mindist_ndx1 ] = min( dist1 );
        dist2 = ( ( -real(CurrPt) - xdata )/diff(plotdata.xlim) ).^2 ...
               +( ( imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
        [ mindist2, mindist_ndx2 ] = min( dist2 );
        if mindist1 < mindist2
          % Positive frequency.
          plot_h{curr_ploth_ndx}.mindist = sqrt(mindist1);
          plot_h{curr_ploth_ndx}.nyqdata_ndx = mindist_ndx1;
          %nyq_freq = PZG(dom_ndx).cntr_data.contour_freq(mindist_ndx1);
          if numel(PZG(dom_ndx).cntr_data.contour_freq) >= mindist_ndx1
            nyq_freq = PZG(dom_ndx).cntr_data.contour_freq(mindist_ndx1);
          elseif numel(freqdata) >= mindist_ndx1
            nyq_freq = freqdata(mindist_ndx1);
          else
            nyq_freq = inf;
          end
          if ~isinf( nyq_freq )
            plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = 1i * nyq_freq;
            plot_h{curr_ploth_ndx}.ct_pzmap_freq = nyq_freq;
            plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = ...
              exp( 1i* nyq_freq * PZG(2).Ts );
            plot_h{curr_ploth_ndx}.dt_pzmap_freq = nyq_freq;
          end
          contour_flag = PZG(dom_ndx).cntr_data.contour_flag(mindist_ndx1);
          if ~isinf( contour_flag ) && ( contour_flag ~= 0 ) ...
            && ~isnan( contour_flag )
            plot_h{curr_ploth_ndx}.bodedata_ndx = ...
              pzg_gle( PZG(dom_ndx).BodeFreqs, nyq_freq,'near');
          end
        else
          % Negative frequency
          plot_h{curr_ploth_ndx}.neg_freq = 1;
          plot_h{curr_ploth_ndx}.mindist = sqrt(mindist2);
          plot_h{curr_ploth_ndx}.nyqdata_ndx = mindist_ndx2;
          if dom_ndx == 2
            plot_h{curr_ploth_ndx}.bodedata_ndx = ...
              pzg_gle( PZG(2).BodeFreqs, ...
                2*pi/PZG(2).Ts ...
                - PZG(2).cntr_data.contour_freq(mindist_ndx2),'near');
          end
          if numel(PZG(dom_ndx).cntr_data.contour_freq) >= mindist_ndx2
            nyq_freq = PZG(dom_ndx).cntr_data.contour_freq(mindist_ndx2);
          elseif numel(freqdata) >= mindist_ndx2
            nyq_freq = freqdata(mindist_ndx2);
          else
            nyq_freq = inf;
          end
          if ~isinf( nyq_freq )
            plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = -1i * nyq_freq;
            plot_h{curr_ploth_ndx}.ct_pzmap_freq = -nyq_freq;
            plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = ...
              exp( -1i* nyq_freq * PZG(2).Ts );            
            plot_h{curr_ploth_ndx}.dt_pzmap_freq = -nyq_freq;
          end
        end
      else
        % Nyquist lines are turned off.
        xdata = PZG(dom_ndx).BodePhs;
        ydata = PZG(dom_ndx).BodeMag;
        freqdata = PZG(dom_ndx).BodeFreqs;
        if dom_ndx == 2
          nyq_ndx = pzg_gle( freqdata, pi/PZG(2).Ts,'<');
          xdata = xdata(1:nyq_ndx);
          ydata = ydata(1:nyq_ndx);
          freqdata = freqdata(1:nyq_ndx);
        end
        dist = ( ( real(CurrPt) - xdata )/diff(plotdata.xlim) ).^2 ...
              +( ( imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
        [ mindist, mindist_ndx ] = min( dist );
        plot_h{curr_ploth_ndx}.mindist = sqrt(mindist);
        plot_h{curr_ploth_ndx}.bodedata_ndx = mindist_ndx;
        bode_freq = freqdata(mindist_ndx);
        plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = 1i * bode_freq;
        plot_h{curr_ploth_ndx}.ct_pzmap_freq = bode_freq;
        plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = ...
          exp( 1i* bode_freq * PZG(2).Ts );
        plot_h{curr_ploth_ndx}.dt_pzmap_freq = bode_freq;
        plot_h{curr_ploth_ndx}.nyqdata_ndx = ...
          pzg_gle( PZG(dom_ndx).cntr_data.contour_freq, bode_freq,'near');
      end
      
      if ( plot_h{curr_ploth_ndx}.nyqdata_ndx ...
           == numel(PZG(dom_ndx).cntr_data.contour_flag) ) ...
        && all( PZG(dom_ndx).cntr_data.contour_flag(end-1:end) ~= 1 ) ...
        &&( abs(diff( PZG(dom_ndx).cntr_data.Nichols_phs(end-1:end))) > 90 )
        plot_h{curr_ploth_ndx}.nyqdata_ndx = [];
        plot_h{curr_ploth_ndx}.bodedata_ndx = [];
        plot_h{curr_ploth_ndx}.mindist = inf;
      elseif ( plot_h{curr_ploth_ndx}.nyqdata_ndx == 1 ) ...
            && all( PZG(dom_ndx).cntr_data.contour_flag(1:2) ~= 1 ) ...
            &&( diff( PZG(dom_ndx).cntr_data.Nichols_phs(1:2) ) > 90 )
        plot_h{curr_ploth_ndx}.nyqdata_ndx = [];
        plot_h{curr_ploth_ndx}.bodedata_ndx = [];
        plot_h{curr_ploth_ndx}.mindist = inf;
      end
      
    case 7
      % Nyquist plot
      line_h = PZG(dom_ndx).plot_h{7}.hndl.Nyquist_Plot;
      xdata = get( line_h(1),'xdata');
      ydata = get( line_h(1),'ydata');
      dist1 = ( ( real(CurrPt) - xdata )/diff(plotdata.xlim) ).^2 ...
             +( ( imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
      [ mindist1, mindist_ndx1 ] = min( dist1 );
      dist2 = ( ( real(CurrPt) - xdata )/diff(plotdata.xlim) ).^2 ...
             +( ( -imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
      [ mindist2, mindist_ndx2 ] = min( dist2 );
      if mindist1 < mindist2
        % Positive frequency.
        plot_h{curr_ploth_ndx}.mindist = sqrt(mindist1);
        plot_h{curr_ploth_ndx}.nyqdata_ndx = mindist_ndx1;
        nyq_freq = PZG(dom_ndx).cntr_data.contour_freq(mindist_ndx1);
        if ~isinf( nyq_freq )
          plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = 1i * nyq_freq;
          plot_h{curr_ploth_ndx}.ct_pzmap_freq = nyq_freq;
          plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = ...
            exp( 1i* nyq_freq * PZG(2).Ts );            
          plot_h{curr_ploth_ndx}.dt_pzmap_freq = nyq_freq;
        end
        contour_flag = PZG(dom_ndx).cntr_data.contour_flag(mindist_ndx1);
        if ~isinf( contour_flag ) && ( contour_flag ~= 0 ) ...
          && ~isnan( contour_flag )
          plot_h{curr_ploth_ndx}.bodedata_ndx = ...
            pzg_gle( PZG(dom_ndx).BodeFreqs, nyq_freq,'near');
        end
      else
        % Negative frequency.
        plot_h{curr_ploth_ndx}.neg_freq = 1;
        plot_h{curr_ploth_ndx}.mindist = sqrt(mindist2);
        plot_h{curr_ploth_ndx}.nyqdata_ndx = mindist_ndx2;
        nyq_freq = PZG(dom_ndx).cntr_data.contour_freq(mindist_ndx2);
        if ( dom_ndx == 2 ) %...
          %&& isequal( 1, PZG(2).cntr_data.contour_flag(mindist_ndx2) )
          plot_h{curr_ploth_ndx}.bodedata_ndx = ...
            pzg_gle( PZG(2).BodeFreqs, 2*pi/PZG(2).Ts-nyq_freq,'near');
        else
          plot_h{curr_ploth_ndx}.bodedata_ndx = [];
        end
        if ~isinf( nyq_freq )
          plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = -1i * nyq_freq;
          plot_h{curr_ploth_ndx}.ct_pzmap_freq = -nyq_freq;
          plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = ...
            exp( -1i* nyq_freq * PZG(2).Ts );            
          plot_h{curr_ploth_ndx}.dt_pzmap_freq = -nyq_freq;
        end
      end
      
    case {8,9}
      % These are time-domain plots, not freq-domain.
      
    case {10,12}
      % C-T P/Z Map
      ydata = PZG(1).BodeFreqs;
      mouse_freq = imag(CurrPt);
      if abs(mouse_freq) <= ydata(end);
        dist1 = ( real(CurrPt)/diff(plotdata.xlim) ).^2 ...
               +( ( imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
        [ mindist1, mindist_ndx1 ] = min( dist1 );
        dist2 = ( real(CurrPt)/diff(plotdata.xlim) ).^2 ...
               +( ( -imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
        [ mindist2, mindist_ndx2 ] = min( dist2 );
        if mindist1 < mindist2
          plot_h{curr_ploth_ndx}.mindist = sqrt(mindist1);
          plot_h{curr_ploth_ndx}.bodedata_ndx = mindist_ndx1;
          bode_freq = PZG(1).BodeFreqs(mindist_ndx1);
          plot_h{curr_ploth_ndx}.nyqdata_ndx = ...
            pzg_gle( PZG(dom_ndx).cntr_data.contour_freq, bode_freq,'near');
        else
          plot_h{curr_ploth_ndx}.neg_freq = 1;
          plot_h{curr_ploth_ndx}.mindist = sqrt(mindist2);
          bode_freq = PZG(1).BodeFreqs(mindist_ndx2);
          plot_h{curr_ploth_ndx}.nyqdata_ndx = ...
            pzg_gle( PZG(dom_ndx).cntr_data.contour_freq, bode_freq,'near');
        end
      end
      plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = 1i * mouse_freq;
      plot_h{curr_ploth_ndx}.ct_pzmap_freq = mouse_freq;

      if bilinear_mapg
        % z = (2+Tw)/(2-Tw)
        plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = ...
          ( 2 + 1i*mouse_freq*PZG(2).Ts ) / ( 2 - 1i*mouse_freq*PZG(2).Ts );
        plot_h{curr_ploth_ndx}.dt_pzmap_freq = ...
          angle(plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt) / PZG(2).Ts;
      else
        % z = exp(sT)
        plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = ...
          exp( 1i* mouse_freq * PZG(2).Ts );            
        plot_h{curr_ploth_ndx}.dt_pzmap_freq = mouse_freq;
      end
      
      
    case {11,13}
      % D-T P/Z Map
      nyq_ndx = pzg_gle( PZG(2).BodeFreqs, pi/PZG(2).Ts,'<');
      linedata = exp( 1i*PZG(2).BodeFreqs(1:nyq_ndx) * PZG(2).Ts );
      xdata = real(linedata);
      ydata = imag(linedata);
      dist1 = ( ( real(CurrPt) - xdata )/diff(plotdata.xlim) ).^2 ...
             +( ( imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
      [ mindist1, mindist_ndx1 ] = min( dist1 );
      dist2 = ( ( real(CurrPt) - xdata )/diff(plotdata.xlim) ).^2 ...
             +( ( -imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
      [ mindist2, mindist_ndx2 ] = min( dist2 );
      if mindist1 < mindist2
        plot_h{curr_ploth_ndx}.mindist = sqrt(mindist1);
        plot_h{curr_ploth_ndx}.bodedata_ndx = mindist_ndx1;
        bode_freq = PZG(2).BodeFreqs(mindist_ndx1);
        plot_h{curr_ploth_ndx}.nyqdata_ndx = ...
          pzg_gle( PZG(dom_ndx).cntr_data.contour_freq, bode_freq,'near');
        mouse_freq = bode_freq;
      else
        % Bottom half of unit-circle, translate to positive freq.
        plot_h{curr_ploth_ndx}.neg_freq = 1;
        plot_h{curr_ploth_ndx}.mindist = sqrt(mindist2);
        mouse_freq = -PZG(2).BodeFreqs(mindist_ndx2);
        bode_freq = mouse_freq + 2*pi/PZG(2).Ts;
        plot_h{curr_ploth_ndx}.bodedata_ndx = ...
          pzg_gle( PZG(2).BodeFreqs, bode_freq,'near');
        plot_h{curr_ploth_ndx}.nyqdata_ndx = ...
          pzg_gle( PZG(dom_ndx).cntr_data.contour_freq, ...
                   abs(mouse_freq),'near');
      end
      plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = ...
        exp( 1i* bode_freq * PZG(2).Ts );
      plot_h{curr_ploth_ndx}.dt_pzmap_freq = bode_freq;
      
      if bilinear_mapg
        % s = 2(z-1)/[T(z+1)]
        z_pt = plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt;
        plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = ...
          2*( z_pt - 1 ) / PZG(2).Ts / ( z_pt + 1 );
        plot_h{curr_ploth_ndx}.ct_pzmap_freq = ...
          imag(plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt);
      else
        plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = 1i * mouse_freq;
        plot_h{curr_ploth_ndx}.ct_pzmap_freq = mouse_freq;
      end
      
    case 14
      % Nyquist contour plot
      plot_h{curr_ploth_ndx}.bodedata_ndx = [];
      line_h = PZG(dom_ndx).plot_h{14}.hndl.nyq_contour_all_parts;
      xdata = get( line_h(1),'xdata');
      ydata = get( line_h(1),'ydata');
      dist1 = ( ( real(CurrPt) - xdata )/diff(plotdata.xlim) ).^2 ...
             +( ( imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
      [ mindist1, mindist_ndx1 ] = min( dist1 );
      dist2 = ( ( real(CurrPt) - xdata )/diff(plotdata.xlim) ).^2 ...
             +( ( -imag(CurrPt) - ydata )/diff(plotdata.ylim) ).^2;
      [ mindist2, mindist_ndx2 ] = min( dist2 );
      if mindist1 < mindist2
        % Positive frequency.
        plot_h{curr_ploth_ndx}.mindist = sqrt(mindist1);
        plot_h{curr_ploth_ndx}.nyqdata_ndx = mindist_ndx1;
        nyq_freq = PZG(dom_ndx).cntr_data.contour_freq(mindist_ndx1);
        nyq_flag = PZG(dom_ndx).cntr_data.contour_flag(mindist_ndx1);
        if ~isinf( nyq_freq )
          plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = 1i * nyq_freq;
          plot_h{curr_ploth_ndx}.ct_pzmap_freq = nyq_freq;
          plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = ...
            exp( 1i* nyq_freq * PZG(2).Ts );            
          plot_h{curr_ploth_ndx}.dt_pzmap_freq = nyq_freq;
          if isequal( nyq_flag, 1 )
            plot_h{curr_ploth_ndx}.bodedata_ndx = ...
              pzg_gle( PZG(dom_ndx).BodeFreqs, nyq_freq,'near');
          end
        end
        contour_flag = PZG(dom_ndx).cntr_data.contour_flag(mindist_ndx1);
        if ~isinf( contour_flag ) && ( contour_flag ~= 0 ) ...
          && ~isnan( contour_flag )
          plot_h{curr_ploth_ndx}.bodedata_ndx = ...
            pzg_gle( PZG(dom_ndx).BodeFreqs, nyq_freq,'near');
        end
      else
        % Negative frequency.
        plot_h{curr_ploth_ndx}.neg_freq = 1;
        plot_h{curr_ploth_ndx}.mindist = sqrt(mindist2);
        plot_h{curr_ploth_ndx}.nyqdata_ndx = mindist_ndx2;
        nyq_freq = PZG(dom_ndx).cntr_data.contour_freq(mindist_ndx2);
        if ( dom_ndx == 2 ) %...
          %&& isequal( 1, PZG(2).cntr_data.contour_flag(mindist_ndx2) )
          plot_h{curr_ploth_ndx}.bodedata_ndx = ...
            pzg_gle( PZG(2).BodeFreqs, 2*pi/PZG(2).Ts-nyq_freq,'near');
        else
          plot_h{curr_ploth_ndx}.bodedata_ndx = [];
        end
        if ~isinf( nyq_freq )
          plot_h{curr_ploth_ndx}.ct_pzmap_bndry_pt = -1i * nyq_freq;
          plot_h{curr_ploth_ndx}.ct_pzmap_freq = -nyq_freq;
          plot_h{curr_ploth_ndx}.dt_pzmap_bndry_pt = ...
            exp( -1i* nyq_freq * PZG(2).Ts );            
          plot_h{curr_ploth_ndx}.dt_pzmap_freq = -nyq_freq;
        end
      end
      
    otherwise
  end
  
  if ~isempty( plot_h{curr_ploth_ndx}.bodedata_ndx )
    plot_h{curr_ploth_ndx}.nearest_freq = ...
      PZG(dom_ndx).BodeFreqs(plot_h{curr_ploth_ndx}.bodedata_ndx);
  elseif ~isempty( plot_h{curr_ploth_ndx}.nyqdata_ndx )
    plot_h{curr_ploth_ndx}.nearest_freq = ...
      PZG(dom_ndx).cntr_data.contour_freq(plot_h{curr_ploth_ndx}.nyqdata_ndx);
    if plot_h{curr_ploth_ndx}.neg_freq
      plot_h{curr_ploth_ndx}.nearest_freq = -plot_h{curr_ploth_ndx}.nearest_freq;
    end
  end
  
return

function local_all_cursor_hilites_off( plot_h, fig_h_ndx, dom_ndx )

  global PZG
  
  if ( nargin < 3 ) || ( ~isequal(dom_ndx,1) && ~isequal(dom_ndx,2) )
    get_ndx = [1;2];
  else
    get_ndx = dom_ndx;
  end
  if isempty(fig_h_ndx)
    fig_h_ndx = (1:14)';
  end
  
  try
    startmovie_h = PZG(dom_ndx).plot_h{14}.hndl.nyq_movie_pushbutton;
    stopmovie_h = PZG(dom_ndx).plot_h{14}.hndl.nyq_stop_movie_pushbutton;
  catch
    startmovie_h = [];
    stopmovie_h = [];
  end
  if ( isempty(startmovie_h) && isempty(stopmovie_h) ) ...
    ||( strcmp( get(stopmovie_h,'visible'),'off') ...
       && strcmp( get(startmovie_h,'visible'),'on') )
    d_ndxs = (1:2);
    f_ndxs = [(1:7),(10:14)];
    hilite_h = ...
      [ pzg_fndo( d_ndxs, f_ndxs,'mm_mark_h'); ...
        pzg_fndo( d_ndxs, f_ndxs,'mm_line_h'); ...
        pzg_fndo( d_ndxs, f_ndxs,'mm_freq_h'); ...
        pzg_fndo( d_ndxs, f_ndxs,'mm_mag_h'); ...
        pzg_fndo( d_ndxs, f_ndxs,'mm_phs_h'); ...
        pzg_fndo( d_ndxs, 6,'dynamic_gain_marker'); ...
        pzg_fndo( d_ndxs, f_ndxs,'damping_natural_freq_text') ];
    if ~isempty(hilite_h)
      set( hilite_h,'visible','off')
    end
  end
  
  hilite_h = ...
    [ pzg_fndo( (1:2), [3;4;6],'Nichols_CL_track_line'); ...
      pzg_fndo( (1:2), [3;4;6],'Nichols_CL_track_text') ];       
  if ~isempty(hilite_h)
    if ( numel(fig_h_ndx) > 1 ) || ( numel(get_ndx) > 1 ) ...
      || ~any( fig_h_ndx == [3;4;6] )
      set( hilite_h,'visible','off')
    elseif ( numel(fig_h_ndx) == 1 ) && ( numel(get_ndx) == 1 )
      xlim = plot_h{fig_h_ndx}.xlim;
      ylim = plot_h{fig_h_ndx}.ylim;
      CurrPt = get( plot_h{fig_h_ndx}.ax_h,'currentpoint');
      xpt = CurrPt(1,1);
      ypt = CurrPt(1,2);
      if ( xpt < xlim(1) ) || ( xpt > xlim(2) ) ...
        ||( ypt < ylim(1) ) || ( ypt > ylim(2) )
        set( hilite_h,'visible','off')
      end
    end
  end
  
return

function tenths_str = local_tenths_str( val )
  if isempty(val)
    tenths_str = '';
    return
  end
  if abs(val) < 0.05
    tenths_str = '0';
  elseif abs(val) > 0.095
    tenths_str = int2str( round( 10*val ) );
    if numel(tenths_str) == 1
      tenths_str = [ '0.' tenths_str ];
    elseif ( numel(tenths_str) == 2 ) && strcmp( tenths_str(1),'-')
      tenths_str = [ '-0.' tenths_str(2) ];
    else
      tenths_str = ...
        [ tenths_str(1:end-1) '.' tenths_str(end) ];
    end
  else
    if val < 0
      tenths_str = '-0.0';
    else
      tenths_str = '0.0';
    end
  end
return

function  local_update_selected_freq( dom_ndx, plot_h, fig_h_ndx, neg_freq_in )
  
  global PZG PZMoving
  
  if isequal( PZMoving, 1 )
    return
  end
  
  if nargin < 4
    neg_freq_in = [];
  end
  
  if ~isfield(PZG(dom_ndx),'NyqSelNdx')
    PZG(dom_ndx).NyqSelNdx = [];
  end
  if ~isfield(PZG(dom_ndx),'FrqSelNdx')
    PZG(dom_ndx).FrqSelNdx = [];
  end
  if ~isfield(PZG(dom_ndx),'NegSelect')
    PZG(dom_ndx).NegSelect = 0;
  end
  if ~isfield(PZG(dom_ndx),'plot_h')
    PZG(dom_ndx).plot_h = cell(14,1);
  end
  
  if nargin < 2
    plot_h = [];
  end
  if nargin < 3
    fig_h_ndx = [];
  end
  
  if nargin == 3
    if isempty(plot_h)
      plot_h = PZG(dom_ndx).plot_h;
    end
    if isempty(fig_h_ndx) ...
      && ~isempty(plot_h) && iscell(plot_h)
      for k = 1:numel(plot_h)
        if isfield( plot_h{k},'bodedata_ndx')
          fig_h_ndx = k;
        end
      end
    end
  end
  if ~isempty(fig_h_ndx) ...
    && isstruct(plot_h{fig_h_ndx}) ...
    && isfield(plot_h{fig_h_ndx},'ct_pzmap_bndry_pt') ...
    && isfield(plot_h{fig_h_ndx},'dt_pzmap_bndry_pt')
    if dom_ndx == 1
      if ~isempty( PZG(1).FrqSelNdx )
        CurrFreq_w = PZG(1).BodeFreqs( PZG(1).FrqSelNdx );
      else
        CurrFreq_w = imag( plot_h{fig_h_ndx}.ct_pzmap_bndry_pt );
      end
    else
      if ~isempty( PZG(1).FrqSelNdx )
        CurrFreq_w = PZG(2).BodeFreqs( PZG(2).FrqSelNdx );
      else
        CurrFreq_w = angle(plot_h{fig_h_ndx}.dt_pzmap_bndry_pt)/PZG(2).Ts;
      end
    end
  else
    if dom_ndx == 1
      if ~isempty( PZG(1).FrqSelNdx )
        CurrFreq_w = PZG(1).BodeFreqs( PZG(1).FrqSelNdx );
      else
        CurrFreq_w = [];
      end
    else
      if ~isempty( PZG(1).FrqSelNdx )
        CurrFreq_w = PZG(2).BodeFreqs( PZG(2).FrqSelNdx );
      else
        CurrFreq_w = [];
      end
    end
  end
  
  line_h = ...
    [ pzg_fndo( 2, 13,'bode_comp_zero_lines'); ...
      pzg_fndo( 2, 13,'bode_comp_pole_lines'); ...
      pzg_fndo( 2, 13,'bode_comp_zero_text'); ...
      pzg_fndo( 2, 13,'bode_comp_pole_text'); ...
      pzg_fndo( 2, 13,'bode_comp_freq_text') ];
  if ~isempty(line_h)
    if isempty(PZG(2).FrqSelNdx)
      set(line_h,'visible','off')
    elseif isequal( 0, PZG(2).pzg_show_frf_computation )
      set( line_h,'visible','off')
    else
      set( line_h,'visible','on')
    end
  end
  
  line_h = ...
    [ pzg_fndo( 1, 12,'bode_comp_zero_lines'); ...
      pzg_fndo( 1, 12,'bode_comp_pole_lines'); ...
      pzg_fndo( 1, 12,'bode_comp_zero_text'); ...
      pzg_fndo( 1, 12,'bode_comp_pole_text'); ...
      pzg_fndo( 1, 12,'bode_comp_freq_text') ];
  if ~isempty(line_h)
    if isempty(PZG(1).FrqSelNdx)
      set(line_h,'visible','off')
      cmp_h = findobj( allchild(0),'name','C-T O.L. Freq-Response Computation');
      delete(cmp_h)
    elseif isequal( 1, PZG(1).pzg_show_frf_computation )
      set( line_h,'visible','on')
    else
      set( line_h,'visible','off')
    end
  end
  
  if ~isfield( PZG,'pzg_show_frf_computation')
    PZG(1).pzg_show_frf_computation = 0;
    PZG(2).pzg_show_frf_computation = 0;
  end
  if isequal( 1, PZG(1).pzg_show_frf_computation ) ...
    ||isequal( 2, PZG(1).pzg_show_frf_computation )
    PZG(1).pzg_show_frf_computation = 1;
    PZG(2).pzg_show_frf_computation = 1;
  else
    PZG(1).pzg_show_frf_computation = 0;
    PZG(2).pzg_show_frf_computation = 0;
  end
  
  if ( nargin < 3 ) ...
    ||( isempty(fig_h_ndx) ...
       && isempty(PZG(dom_ndx).FrqSelNdx) ...
       && isempty(PZG(dom_ndx).NyqSelNdx) ) ...
    ||( isempty(plot_h) || ~iscell(PZG(dom_ndx).plot_h) )
    sel_ndx = [];
    nyq_sel_ndx = [];
    if isempty(neg_freq_in)
      neg_freq = 0;
    else
      neg_freq = neg_freq_in;
    end
    if isfield( PZG(dom_ndx),'plot_h') ...
      && ~isempty( PZG(dom_ndx).plot_h )
      plot_h = PZG(dom_ndx).plot_h;
    else
      plot_h = local_get_pzg_fig_data( dom_ndx, fig_h_ndx );
    end
    
  elseif isempty(fig_h_ndx) ...
        ||~isfield( plot_h{fig_h_ndx},'nyqdata_ndx') ...
        ||isempty(plot_h{fig_h_ndx}.nyqdata_ndx)
    sel_ndx = PZG(dom_ndx).FrqSelNdx;
    nyq_sel_ndx = PZG(dom_ndx).NyqSelNdx;
    if isempty(neg_freq_in)
      neg_freq = PZG(dom_ndx).NegSelect;
    else
      neg_freq = neg_freq_in;
      PZG(dom_ndx).NegSelect = neg_freq;
    end
  else
    %sel_ndx = plot_h{fig_h_ndx}.bodedata_ndx;
    %nyq_sel_ndx = plot_h{fig_h_ndx}.nyqdata_ndx;
    sel_ndx = PZG(dom_ndx).FrqSelNdx;
    plot_h{fig_h_ndx}.bodedata_ndx = sel_ndx;
    nyq_sel_ndx = PZG(dom_ndx).NyqSelNdx;
    plot_h{fig_h_ndx}.nyqdata_ndx = nyq_sel_ndx;
    if isempty(neg_freq_in)
      neg_freq = plot_h{fig_h_ndx}.neg_freq;
    else
      neg_freq = neg_freq_in;
      plot_h{fig_h_ndx}.neg_freq = neg_freq;
    end
  end
  if ~isempty(CurrFreq_w)
    if ( abs(CurrFreq_w) < PZG(dom_ndx).BodeFreqs(1) ) ...
      ||( abs(CurrFreq_w) > PZG(dom_ndx).BodeFreqs(end) )
      sel_ndx = [];
      PZG(dom_ndx).FrqSelNdx = sel_ndx;
    end
  end
  PZG(dom_ndx).NyqSelNdx = nyq_sel_ndx;
  if ( dom_ndx == 1 )
    PZG(dom_ndx).NegSelect = neg_freq;
  elseif ( numel(nyq_sel_ndx) == 1 ) ...
    && ~isempty(PZG(dom_ndx).cntr_data) ...
    && isfield( PZG(dom_ndx).cntr_data,'contour_flag') ...
    && ~isequal( 1, PZG(dom_ndx).cntr_data.contour_flag(nyq_sel_ndx) )
    sel_ndx = [];
    PZG(dom_ndx).FrqSelNdx = sel_ndx;
    PZG(dom_ndx).NegSelect = neg_freq;
  else
    PZG(dom_ndx).NegSelect = neg_freq;
  end
  
  if isempty(sel_ndx) && ~isempty(nyq_sel_ndx) ...
    && ( dom_ndx == 2 ) ...
    && isequal( 1, PZG(2).cntr_data.contour_flag(nyq_sel_ndx) )
    if neg_freq
      sel_ndx = ...
        pzg_gle( ...
          PZG(2).BodeFreqs, ...
          2*pi/PZG(2).Ts-PZG(2).cntr_data.contour_freq(nyq_sel_ndx),'near');
    else
      sel_ndx = pzg_gle( PZG(2).BodeFreqs, ...
                         PZG(2).cntr_data.contour_freq(nyq_sel_ndx),'near');
    end
  end
  
  if ( numel(nyq_sel_ndx) == 1 ) && ( nyq_sel_ndx > 0 ) ...
    && ( nyq_sel_ndx <= numel(PZG(dom_ndx).cntr_data.contour_freq) )
    nyq_selected_freq_w = PZG(dom_ndx).cntr_data.contour_freq(nyq_sel_ndx);
  else
    nyq_selected_freq_w = [];
  end
  
  if ~isempty(fig_h_ndx) && isfield(plot_h{fig_h_ndx},'ct_pzmap_bndry_pt') ...
    && ~isempty(plot_h{fig_h_ndx}.ct_pzmap_bndry_pt)
    ct_pzmap_sel_point = plot_h{fig_h_ndx}.ct_pzmap_bndry_pt;
    dt_pzmap_sel_point = plot_h{fig_h_ndx}.dt_pzmap_bndry_pt;
  elseif ~isempty(nyq_selected_freq_w)
    ct_pzmap_sel_point = 1i * nyq_selected_freq_w;
    dt_pzmap_sel_point = exp( ct_pzmap_sel_point * PZG(2).Ts );
    if neg_freq
      ct_pzmap_sel_point = -ct_pzmap_sel_point;
      dt_pzmap_sel_point = conj(dt_pzmap_sel_point);
    end
  else
    ct_pzmap_sel_point = [];
    dt_pzmap_sel_point = [];
  end
  
  sf_width = 4;
  bode_freq_units = 'rad/s';  % Default units.
  
  for k = 1:14
    if ( numel(plot_h) >= k ) ...
      && ~isempty(plot_h{k}) && isstruct(plot_h{k}) ...
      && isfield( plot_h{k},'ax_h')
      if strcmp( PZG(dom_ndx).DefaultBackgroundColor,'k')
        sf_cyan = [ 0 0.8 0.8 ];
      else
        sf_cyan = [ 0 0.7 0.7 ];
      end
      bodemarker_h = pzg_fndo( dom_ndx, k,'Bode_selection_marker');
      implicit_h = pzg_fndo( dom_ndx, k,'implicit_freq_marker');
    else
      bodemarker_h = [];
      implicit_h = [];
    end
    
    if ( k <= 5 ) && ~isempty(plot_h{k}) ...
      && isfield( plot_h{k},'ax_h')
      if plot_h{k}.Hz_cb
        freq_mult = 0.5/pi;
      else
        freq_mult = 1;
      end
      if isempty(sel_ndx) ...
        || ( sel_ndx < 1 ) ...
        ||( sel_ndx > numel(PZG(dom_ndx).BodeFreqs) ) 
        if ~isempty(implicit_h) || ~isempty(bodemarker_h)
            set( [bodemarker_h;implicit_h],'visible','off')
        end
        if plot_h{k}.Hz_cb
          set( plot_h{k}.hndl.ax_xlabel, ...
              'string','Frequency (hertz)', ...
              'visible','on')
          bode_freq_units = 'hertz';
        else
          set( plot_h{k}.hndl.ax_xlabel, ...
              'string','Frequency (rad/s)', ...
              'visible','on')
        end
      else
        if numel(PZG(dom_ndx).BodeFreqs) >= sel_ndx
          this_x = PZG(dom_ndx).BodeFreqs(sel_ndx);
          switch k
            case 1
              this_y = PZG(dom_ndx).BodeMag(sel_ndx);
              if ~pzg_isdby
                this_y = 10^(this_y/20);
              end
            case 2
              this_y = PZG(dom_ndx).BodePhs(sel_ndx);
              if ~pzg_isunwrp
                this_y = 180/pi*angle( exp(1i*this_y/180*pi ) );
              end
            case 3
              this_y = PZG(dom_ndx).CLBodeMag(sel_ndx);
              if ~pzg_isdby
                this_y = 10^(this_y/20);
              end
            case 4
              this_y = PZG(dom_ndx).CLBodePhs(sel_ndx);
              if ~pzg_isunwrp
                this_y = 180/pi*angle( exp(1i*this_y/180*pi ) );
              end
            case 5
              this_val = ...
                10.^(PZG(dom_ndx).BodeMag(sel_ndx)/20) ...
                *exp( 1i * pi/180*PZG(dom_ndx).BodePhs(sel_ndx) );
              this_y = 20*log10( abs( 1/(1+this_val) ) );
            otherwise
              this_x = [];
              this_y = [];
          end
          if PZG(dom_ndx).pzg_show_frf_computation
            tempVis = 'on';
          else
            tempVis = 'off';
          end
          if ( dom_ndx == 2 ) ...
            && ~isempty(CurrFreq_w) && ( CurrFreq_w < 0 )
            draw_freq = this_x*freq_mult;
          else
            draw_freq = this_x*freq_mult;
          end
          if isempty(bodemarker_h)
            bodemarker_h = ...
              plot( draw_freq, this_y, ...
                 'marker','o', ...
                 'markersize', 6, ...
                 'color', sf_cyan, ...
                 'linewidth', sf_width, ...
                 'parent', PZG(dom_ndx).plot_h{k}.ax_h, ...
                 'visible', tempVis, ...
                 'tag','Bode selection marker');
            plot_h{k}.hndl.Bode_selection_marker = bodemarker_h;
            PZG(dom_ndx).plot_h{k}.hndl.Bode_selection_marker = ...
              bodemarker_h;
          else
            set( bodemarker_h, ...
                'xdata', draw_freq, ...
                'ydata', this_y, ...
                'visible', tempVis );
          end
        elseif ~isempty(bodemarker_h)
          set( bodemarker_h,'xdata',[],'ydata',[],'visible','off');
        end
      end
      if plot_h{k}.Hz_cb
        bode_freq_units = 'hertz';
      end
      
    elseif ( k == 6 ) && ~isempty(plot_h{k}) ...
      && isfield( plot_h{k},'ax_h')
      % Nichols plot
      nic_select_pt = [];
      if isempty( PZG(dom_ndx).FrqSelNdx )
        % No selection.
        if ~isempty(implicit_h)
          set( implicit_h,'visible','off')
        end
        set( plot_h{k}.hndl.ax_xlabel,'string','Phase (degrees)');
      else
        nic_select_pt = ...
          PZG(dom_ndx).BodePhs(PZG(dom_ndx).FrqSelNdx) ...
          + 1i*PZG(dom_ndx).BodeMag(PZG(dom_ndx).FrqSelNdx);
        sel_vis = 'off';
        if PZG(dom_ndx).pzg_show_frf_computation && ~isempty(nic_select_pt)
          
          if ( get( PZG(dom_ndx).plot_h{k} ...
                   .hndl.show_nyq_mapping_checkbox,'value') && neg_freq ) ...
            || ~neg_freq
            sel_vis = 'on';
          end
        end
        
        if isempty(implicit_h) || ~isequal( 1, ishandle(implicit_h) )
          implicit_h = ...
            plot( real(nic_select_pt), imag(nic_select_pt), ...
               'marker','o', ...
               'markersize', 6, ...
               'color', sf_cyan, ...
               'linewidth', sf_width, ...
               'visible', sel_vis, ...
               'parent', PZG(dom_ndx).plot_h{k}.ax_h, ...
               'tag','implicit freq marker');
          PZG(dom_ndx).plot_h{k}.hndl.implicit_freq_marker = implicit_h;
          plot_h{k}.hndl.implicit_freq_marker = implicit_h;
        else
          set( implicit_h, ...
              'xdata', real(nic_select_pt), ...
              'ydata', imag(nic_select_pt), ...
              'visible', sel_vis );
        end
      end
      
      plot_h = ...
        local_ldlg_zerodbCL_dist( ...
          plot_h, dom_ndx, nic_select_pt, neg_freq );
      
    elseif ( k == 7 ) && ~isempty(plot_h{k}) ...
      && isfield( plot_h{k},'ax_h')
      % Nyquist plot
      if isempty(nyq_sel_ndx)
        % No selection.
        if ~isempty(implicit_h)
          set( implicit_h,'visible','off')
        end
        set( plot_h{k}.hndl.ax_xlabel,'string','Real Part of FRF')
      else
        if plot_h{7}.hybrid_scaling_cb
          nyq_select_pt = ...
            PZG(dom_ndx).cntr_data.Nyquist_scaled_pts(nyq_sel_ndx);
        else
          nyq_select_pt = ...
            PZG(dom_ndx).cntr_data.Nyquist_pts(nyq_sel_ndx);
        end
        if neg_freq
          nyq_select_pt = conj(nyq_select_pt);
        end
        if isempty(implicit_h) || ~isequal( 1, ishandle(implicit_h) )
          PZG(dom_ndx).plot_h{7}.hndl.implicit_freq_marker = ...
            plot( real(nyq_select_pt), imag(nyq_select_pt), ...
               'marker','o', ...
               'markersize', 6, ...
               'color', sf_cyan, ...
               'linewidth', sf_width, ...
               'parent', plot_h{k}.ax_h, ...
               'tag','implicit freq marker');
          plot_h{7}.hndl.implicit_freq_marker = ...
            PZG(dom_ndx).plot_h{7}.hndl.implicit_freq_marker;
        else
          set( implicit_h, ...
              'xdata', real(nyq_select_pt), ...
              'ydata', imag(nyq_select_pt), ...
              'visible','on');
        end
        if strcmp(bode_freq_units,'hertz')
          bode_freq_units = 'hertz';
        end
      end
      
    elseif ( k == 8 ) && ~isempty(sel_ndx) ...
      && ~isempty(plot_h{8}) && isfield( plot_h{8},'ax_h')
      if plot_h{8}.input_type == 5 % sinusoid
        % Update the sinusoid frequency
        selected_freq_hz = PZG(dom_ndx).BodeFreqs(sel_ndx)/2/pi;
        if ~isequal( PZG(dom_ndx).NegSelect, 0 )
          selected_freq_hz = -abs(selected_freq_hz);
        end
        if ( selected_freq_hz > 0 ) ...
          &&( ( dom_ndx == 1 ) ...
             ||( selected_freq_hz < 0.5/PZG(2).Ts ) )
          temp0 = get( plot_h{8}.fig_h,'UserData');
          if ( dom_ndx == 2 ) ...
            &&( mod( abs(selected_freq_hz), 1/PZG(2).Ts ) > 0.5/PZG(2).Ts )
            selfreq_str = pzg_efmt( abs(selected_freq_hz)-1/PZG(2).Ts, 3 );
          else
            selfreq_str = pzg_efmt( selected_freq_hz, 3 );
          end
          set( temp0(8,2),'string', selfreq_str ); 
          resppl( get(temp0(2,1),'UserData'), ...
                  get(temp0(4,1),'UserData'), 1, ...
                  get( plot_h{8}.fig_h,'Name'),'', ...
                  get( plot_h{8}.ax_h,'UserData'), ...
                  get( get(plot_h{8}.ax_h,'xlabel'),'userdata') );
        end
      end

    elseif ( k == 9 ) && ~isempty(sel_ndx) ...
      && ~isempty(plot_h{9}) && isfield( plot_h{9},'ax_h')
      if plot_h{9}.input_type == 5 % sinusoid
        % Update the sinusoid frequency
        selected_freq_hz = PZG(dom_ndx).BodeFreqs(sel_ndx)/2/pi;
        if ~isequal( PZG(dom_ndx).NegSelect, 0 )
          selected_freq_hz = -abs(selected_freq_hz);
        end
        if ( selected_freq_hz > 0 ) ...
          &&( ( dom_ndx == 1 ) ...
             ||( selected_freq_hz < 0.5/PZG(2).Ts ) )
          temp0 = get( plot_h{9}.fig_h,'UserData');
          if ( dom_ndx == 2 ) ...
            &&( mod( abs(selected_freq_hz), 1/PZG(2).Ts ) > 0.5/PZG(2).Ts )
            selfreq_str = pzg_efmt( abs(selected_freq_hz)-1/PZG(2).Ts, 3 );
          else
            selfreq_str = pzg_efmt( selected_freq_hz, 3 );
          end
          set( temp0(8,2),'string', selfreq_str );
          resppl( get(temp0(2,1),'UserData'), ...
                  get(temp0(4,1),'UserData'), 1, ...
                  get( plot_h{9}.fig_h,'Name'),'', ...
                  get( plot_h{9}.ax_h,'UserData'), ...
                  get( get(plot_h{9}.ax_h,'xlabel'),'userdata') );
        end
      end

    elseif ( ( k == 10 ) || ( k == 12 ) ) && ~isempty(plot_h{k}) ...
      && isfield( plot_h{k},'ax_h') ...
      && isequal( dom_ndx, 1 )
      % C-T P/Z map
      try
        selfreq = PZG(1).BodeFreqs( PZG(1).FrqSelNdx );
      catch
        selfreq = [];
      end
      if isempty(selfreq)
        selfreq = NaN;
      end
      if ~isempty(ct_pzmap_sel_point) && ~isempty(selfreq)
        if ~isequal( 1, ishandle(bodemarker_h) )
          delete(bodemarker_h)
          bodemarker_h = ...
            plot( 0, selfreq, ...
              'marker','o', ...
              'markersize', 6, ...
              'color', sf_cyan, ...
              'linewidth', sf_width, ...
              'parent', PZG(dom_ndx).plot_h{k}.ax_h, ...
              'tag','Bode selection marker');
          PZG(dom_ndx).plot_h{k}.hndl.Bode_selection_marker = bodemarker_h;
          plot_h{k}.hndl.Bode_selection_marker = bodemarker_h;
        else
          set( bodemarker_h, ...
            'xdata', 0, ...
            'ydata', selfreq, ...
            'visible','on');
        end
        if strcmp(bode_freq_units,'hertz')
          bode_freq_units = 'hertz';
        end
      else
        if ~isempty(bodemarker_h)
          set( bodemarker_h,'visible','off')
        end
        set( PZG(1).plot_h{k}.hndl.ax_xlabel,'string','Real(S), rad/s');
      end
      
    elseif ( ( k == 11 ) || ( k == 13 ) ) && ~isempty(plot_h{k}) ...
      && isfield( plot_h{k},'ax_h') ...
      && isequal( dom_ndx, 2 )
      % D-T P/Z map
      if ~isempty(dt_pzmap_sel_point)
        if isempty(bodemarker_h) || ~isequal( 1, ishandle(bodemarker_h) )
          bodemarker_h = ...
            plot( real(dt_pzmap_sel_point), imag(dt_pzmap_sel_point), ...
               'marker','o', ...
               'markersize', 6, ...
               'color', sf_cyan, ...
               'linewidth', sf_width, ...
               'parent', PZG(dom_ndx).plot_h{k}.ax_h, ...
               'tag','Bode selection marker');
          PZG(dom_ndx).plot_h{k}.hndl.Bode_selection_marker = bodemarker_h;
          plot_h{k}.hndl.Bode_selection_marker = bodemarker_h;
        else
          set( bodemarker_h, ...
              'xdata', real(dt_pzmap_sel_point), ...
              'ydata', imag(dt_pzmap_sel_point), ...
              'visible','on');
        end
        if strcmp(bode_freq_units,'hertz')
          bode_freq_units = 'hertz';
        end
      else
        if ~isempty(bodemarker_h)
          set( bodemarker_h,'visible','off')
        end
        set( PZG(2).plot_h{k}.hndl.ax_xlabel,'string','Real(Z)')
      end
      
      
    elseif ( k == 14 ) && ( numel(plot_h) >= 14 ) ...
      && ~isempty(plot_h{k}) ...
      && isfield( plot_h{k},'ax_h')
    
      if isempty( nyq_sel_ndx )
        if ~isempty(bodemarker_h)
          set( bodemarker_h,'visible','off')
        end
        if dom_ndx == 1
          set( PZG(1).plot_h{k}.hndl.ax_xlabel,'string','Real(S)');
        else
          set( PZG(2).plot_h{k}.hndl.ax_xlabel,'string','Real(Z)');
        end
      else
        pseudo_contour_pt = ...
          PZG(dom_ndx).cntr_data.upper_pseudo_cntr(nyq_sel_ndx);
        if neg_freq
          pseudo_contour_pt = conj( pseudo_contour_pt );
        end
        if isempty(bodemarker_h) || ~isequal( 1, ishandle(bodemarker_h) )
          bodemarker_h = ...
            plot( real(pseudo_contour_pt), imag(pseudo_contour_pt), ...
               'marker','o', ...
               'markersize', 6, ...
               'color', sf_cyan, ...
               'linewidth', sf_width, ...
               'parent', plot_h{k}.ax_h, ...
               'tag','Bode selection marker');
          PZG(dom_ndx).plot_h{k}.hndl.Bode_selection_marker = bodemarker_h;
          plot_h{k}.hndl.Bode_selection_marker = bodemarker_h;
        else
          set( bodemarker_h, ...
              'xdata', real(pseudo_contour_pt), ...
              'ydata', imag(pseudo_contour_pt), ...
              'visible','on');
        end
      end
    end
  end
  
  if dom_ndx == 1
    updtpzln('s')
  else
    updtpzln('z')
  end
  pzg_seltxt( dom_ndx )
  
return

function local_adjust_nicnyq_hilite_extent( plot_h, fig_h_ndx, dom_ndx )
  
  if fig_h_ndx == 6
    xaxishilite_h = plot_h{6}.hndl.pzg_Nichols_xaxis_hilite;
    set( xaxishilite_h, ...
        'xdata', plot_h{6}.xlim(:), ...
        'ydata',[0;0], ...
        'handlevisibility','off', ...
        'visible','on');
    yaxishilite_h = plot_h{6}.hndl.pzg_Nichols_yaxis_hilite;
    set( yaxishilite_h, ...
        'xdata',[0;0], ...
        'ydata', plot_h{6}.ylim(:), ...
        'handlevisibility','off', ...
        'visible','on');
  
  elseif fig_h_ndx == 7
    xaxishilite_h = plot_h{7}.hndl.Nyquist_Plot_Xaxis_Highlight;
    yaxishilite_h = plot_h{7}.hndl.Nyquist_Plot_Yaxis_Highlight;
    set( xaxishilite_h, ...
        'xdata', plot_h{7}.xlim, ...
        'ydata',[0 0], ...
        'visible','on');
    set( yaxishilite_h, ...
        'xdata',[0 0], ...
        'ydata', plot_h{7}.ylim, ...
        'visible','on');
      
  elseif fig_h_ndx == 14
    xaxishilite_h = plot_h{14}.hndl.nyq_contour_xaxis_hilite;
    yaxishilite_h = plot_h{14}.hndl.nyq_contour_yaxis_hilite;
    set( xaxishilite_h, ...
        'xdata', plot_h{14}.xlim, ...
        'ydata',[0 0], ...
        'handlevisibility','off', ...
        'visible','on');
    set( yaxishilite_h, ...
        'xdata',[0 0], ...
        'ydata', plot_h{14}.ylim, ...
        'handlevisibility','off', ...
        'visible','on');
  end
  
return

function pd = local_initialize_pd( plot_h, curr_ploth_ndx, dom_ndx )

  global PZG
  
  pd = [];
  
  if ~isempty(curr_ploth_ndx)
    plotdata = plot_h{curr_ploth_ndx};
  elseif iscell(plot_h)
    for k = 1:numel(plot_h)
      if ~isempty(plot_h{k})
        plotdata = plot_h{k};
        break
      end
    end
  end
  
  pd.ol_ndx = plotdata.bodedata_ndx;
  pd.nyq_ndx = plotdata.nyqdata_ndx;

  % Open-loop bode plots.
  pd.ol_freq_w = [];
  pd.ol_fr_pt = [];
  pd.ol_mag_db = [];
  pd.ol_phs_deg_wrapped = [];
  pd.ol_phs_deg_unwrapped = [];
  % Closed-loop bode plots.
  pd.cl_ndx = [];
  pd.cl_freq_w = [];
  pd.cl_fr_pt = [];
  pd.cl_mag_db = [];
  pd.cl_phs_deg_wrapped = [];
  pd.cl_phs_deg_unwrapped = [];
  % Sensitivity plot
  pd.sens_mag_db = [];
  % Nichols and Nyquist plots
  pd.nicnyq_freq_w = [];
  if ~isfield(plotdata,'neg_freq') || ~plotdata.neg_freq
    pd.neg_freq = 0;
  else
    pd.neg_freq = 1;
  end
  pd.nic_mag_db = [];
  pd.nic_phs_deg = [];
  pd.nyq_unscaled_pt = [];
  pd.nyq_scaled_pt = [];
  % P/Z maps
  pd.ct_bndry_pt = [];
  pd.dt_bndry_pt = [];
  
  if isempty(pd.ol_ndx) && isempty(pd.nyq_ndx)
    return
  end
  
  if ~isempty(pd.ol_ndx)
    if ( numel(PZG(dom_ndx).BodeFreqs) < pd.ol_ndx ) ...
      ||( numel(PZG(dom_ndx).BodeMag) < pd.ol_ndx )
      return
    end
    pd.ol_freq_w = PZG(dom_ndx).BodeFreqs(pd.ol_ndx);
    pd.ol_mag_db = PZG(dom_ndx).BodeMag(pd.ol_ndx);
    pd.ol_phs_deg_unwrapped = PZG(dom_ndx).BodePhs(pd.ol_ndx);
    pd.ol_phs_deg_wrapped = ...
      180/pi*angle( exp(1i*pi/180*pd.ol_phs_deg_unwrapped ) );
    pd.ol_fr_pt = ...
      10^(pd.ol_mag_db/20) * exp(1i*pi/180*pd.ol_phs_deg_wrapped);
    
    unstable_cl = 0;
    if dom_ndx == 1
      if any( real(PZG(1).CLPoleLocs) >= 0 )
        unstable_cl = 1;
      end
    else
      if any( abs(PZG(2).CLPoleLocs) >= 1 )
        unstable_cl = 1;
      end
    end
    if unstable_cl
      pd.cl_ndx = [];
      pd.cl_freq_w = [];
      pd.cl_fr_pt = [];
      pd.cl_mag_db = [];
      pd.cl_phs_deg_wrapped = [];
      pd.cl_phs_deg_unwrapped = [];
      pd.sens_mag_db = [];
    else
      pd.cl_ndx = pd.ol_ndx;
      pd.cl_freq_w = pd.ol_freq_w;
      pd.cl_fr_pt = pd.ol_fr_pt/( 1 + pd.ol_fr_pt );
      pd.cl_mag_db = 20*log10(abs(pd.cl_fr_pt));
      pd.cl_phs_deg_wrapped = 180/pi*angle(pd.cl_fr_pt);
      if numel(PZG(dom_ndx).CLBodePhs) >= pd.cl_ndx
        pd.cl_phs_deg_unwrapped = PZG(dom_ndx).CLBodePhs(pd.cl_ndx);
      else
        pd.cl_phs_deg_unwrapped = pd.cl_phs_deg_wrapped;
      end
      pd.sens_mag_db = 20*log10( abs( 1/(1+pd.ol_fr_pt) ) );
    end
  end
  if isempty(pd.ol_freq_w)
    pd.ct_bode_freq_str = '';
    pd.dt_bode_freq_str = '';
  else
    pd.ct_bode_freq_str = [ pzg_scifmt( abs(pd.ol_freq_w)/2/pi, 4 ) 'Hz'];
    pd.dt_bode_freq_str = pd.ct_bode_freq_str;
  end
   
  if isempty(pd.nyq_ndx)
    pd.nyq_ndx = ...
      pzg_gle( PZG(dom_ndx).cntr_data.contour_freq, pd.ol_freq_w,'near');
  end
  
  pd.dom_ndx = dom_ndx;
  pd.nyq_freq_w = PZG(dom_ndx).cntr_data.contour_freq(pd.nyq_ndx);
  pd.contour_pt = PZG(dom_ndx).cntr_data.contour_pts(pd.nyq_ndx);
  pd.pseudo_contour_pt = ...
    PZG(dom_ndx).cntr_data.upper_pseudo_cntr(pd.nyq_ndx);
  pd.contour_freq = PZG(dom_ndx).cntr_data.contour_freq(pd.nyq_ndx);
  pd.contour_flag = PZG(dom_ndx).cntr_data.contour_flag(pd.nyq_ndx);
  pd.contour_angle = PZG(dom_ndx).cntr_data.contour_angle(pd.nyq_ndx);
  pd.nyq_mag_is_inf = isinf( pd.contour_flag );
  pd.nyq_mag_is_zero = isequal( 0, pd.contour_flag );
  pd.nic_mag_db = PZG(dom_ndx).cntr_data.Nichols_mag(pd.nyq_ndx);
  pd.nic_phs_deg = PZG(dom_ndx).cntr_data.Nichols_phs(pd.nyq_ndx);
  pd.nyq_unscaled_pt = PZG(dom_ndx).cntr_data.Nyquist_pts(pd.nyq_ndx);
  pd.nyq_scaled_pt = PZG(dom_ndx).cntr_data.Nyquist_scaled_pts(pd.nyq_ndx);

  pd.ct_bndry_pt = [];
  pd.dt_bndry_pt = [];
  bilinear_mapg = 0;
  if ~isempty(plot_h{12}) && isfield( plot_h{12},'bilinear')
    bilinear_mapg = plot_h{12}.bilinear;
  elseif ~isempty(plot_h{13}) && isfield( plot_h{13},'bilinear')
    bilinear_mapg = plot_h{13}.bilinear;
  end
  
  if isempty(pd.ct_bndry_pt)
    if dom_ndx == 1
      if ~isinf(pd.nyq_freq_w)
        if pd.neg_freq
          pd.ct_bndry_pt = -1i * abs(pd.nyq_freq_w);
        else        
          pd.ct_bndry_pt = 1i * abs(pd.nyq_freq_w);
        end
        if bilinear_mapg
          pd.dt_bndry_pt = ( 2 + PZG(2).Ts * pd.ct_bndry_pt ) ...
                           /( 2 - PZG(2).Ts * pd.ct_bndry_pt );
        else
           pd.dt_bndry_pt = exp( pd.ct_bndry_pt * PZG(2).Ts );
        end
      end
    else
      % Z-domain figure.
      if pd.neg_freq
        pd.dt_bndry_pt = exp( -1i * abs(pd.nyq_freq_w) * PZG(2).Ts );
        pd.ct_bndry_pt = -1i * abs(pd.nyq_freq_w);
      else        
        pd.dt_bndry_pt = exp( 1i * abs(pd.nyq_freq_w) * PZG(2).Ts );
        pd.ct_bndry_pt = 1i * abs(pd.nyq_freq_w);
      end
      
      if bilinear_mapg
        pd.ct_bndry_pt = 2 / PZG(2).Ts ...
                        *( pd.dt_bndry_pt - 1 ) / ( pd.dt_bndry_pt + 1 );
      end
    end
  end
  pd.ctpzmap_freq = imag( pd.ct_bndry_pt );
  pd.dtpzmap_freq = abs(angle(pd.dt_bndry_pt)) / PZG(2).Ts;
  if ( ( curr_ploth_ndx == 11 )||( curr_ploth_ndx == 13 ) ) ...
    && pd.neg_freq
    pd.dtpzmap_freq = 2*pi/PZG(2).Ts - pd.dtpzmap_freq;
  end
  
  if isinf( pd.nyq_freq_w )
    pd.ctpzmap_freq_str = '';
    pd.dtpzmap_freq_str = '';
  else
    pd.ctpzmap_freq_str = [ pzg_scifmt( abs(pd.ctpzmap_freq)/2/pi, 4 ) 'Hz'];
    pd.dtpzmap_freq_str = [ pzg_scifmt( abs(pd.dtpzmap_freq)/2/pi, 4 ) 'Hz'];
    if pd.neg_freq
      pd.ctpzmap_freq_str = ['-' pd.ctpzmap_freq_str ];
    end
    if ( curr_ploth_ndx ~= 11 ) && ( curr_ploth_ndx ~= 13 )
      if imag(pd.dt_bndry_pt) < 0
        pd.dtpzmap_freq_str = ['-' pd.dtpzmap_freq_str ];
      end
    end
  end
  
  if dom_ndx == 2 
    if ( imag(pd.dt_bndry_pt) < 0 )
      pd.contour_freq = -abs(pd.contour_freq);
    end
  end
  
  if pd.neg_freq || ( pd.contour_freq < 0 )
    pd.contour_freq = -abs(pd.contour_freq);
    pd.contour_pt = conj( pd.contour_pt );
    pd.pseudo_contour_pt = conj( pd.pseudo_contour_pt );
    pd.contour_angle = -pd.contour_angle;
    pd.nic_phs_deg = -pd.nic_phs_deg;
    pd.nyq_scaled_pt = conj(pd.nyq_scaled_pt);
    pd.nyq_unscaled_pt = conj(pd.nyq_unscaled_pt);
  end
  
  if ~isinf(pd.nyq_freq_w)
    pd.nicnyq_freqstr = [ pzg_scifmt( abs(pd.nyq_freq_w)/2/pi, 4 ) 'Hz'];
  elseif isequal( numel(PZG(dom_ndx).PoleLocs), numel(PZG(dom_ndx).ZeroLocs) )
    % On the infinite RHP-semicircle
    pd.nicnyq_freqstr = 'infinity rad/s';
    pd.nyq_unscaled_pt = real(pd.nyq_unscaled_pt);
    pd.nyq_scaled_pt = real(pd.nyq_scaled_pt);
    pd.ol_fr_pt = real(pd.ol_fr_pt);
    pd.cl_fr_pt = real(pd.cl_fr_pt);
    pd.ol_phs_deg_wrapped = round(pd.ol_phs_deg_wrapped);
    pd.ol_phs_deg_unwrapped = round(pd.ol_phs_deg_unwrapped);
    pd.cl_phs_deg_wrapped = round(pd.cl_phs_deg_wrapped);
    pd.cl_phs_deg_unwrapped = round(pd.cl_phs_deg_unwrapped);
    pd.nic_phs_deg = round(pd.nic_phs_deg);
  end
  
  if pd.neg_freq && ~isinf(pd.nyq_freq_w)
    pd.nicnyq_freqstr = ['-' pd.nicnyq_freqstr ];
  end
  
  if isinf(pd.nyq_freq_w) ...
    && isequal( numel(PZG(dom_ndx).PoleLocs), numel(PZG(dom_ndx).ZeroLocs) )
    if real(pd.nyq_unscaled_pt) < 0
      pd.nicnyq_phs_str = '180^o';
    else
      pd.nicnyq_phs_str = '0^o';
    end
  else
    pd.nicnyq_phs_str = [ local_tenths_str(pd.nic_phs_deg) '^o'];
  end
  
  if isinf( pd.contour_flag )
    % FRF magnitude is infinite.
    pd.ol_mag_db = [];
    pd.ol_fr_pt = [];
    pd.ol_phs_deg_wrapped = [];
    pd.ol_phs_deg_unwrapped = [];
    pd.nic_mag_str = '(infinite magnitude)';   
    pd.nyq_mag_str = '(infinite magnitude)';   
    
  elseif pd.contour_flag == 0
    % FRF magnitude is zero.
    pd.ol_mag_db = [];
    pd.ol_fr_pt = [];
    pd.ol_phs_deg_wrapped = [];
    pd.ol_phs_deg_unwrapped = [];
    pd.nic_mag_str = '(zero magnitude)';   
    pd.nyq_mag_str = '(zero magnitude)';
  else
    % Magnitude is greater than zero and finite.
    pd.nic_mag_str = [ local_tenths_str(pd.nic_mag_db) ' dB'];   
    pd.nyq_mag_str = pd.nic_mag_str;
  end
  
return

function local_service_button( plot_h, fig_h_ndx, dom_ndx, CurrPt, not_zooming )

  global PZG
  
  click_type = get( gcbf,'selectiontype');
  ylim_mode = '';

  if ~isfield( PZG(dom_ndx),'pzg_click_time') ...
    || isempty( PZG(dom_ndx).pzg_click_time )
    PZG(dom_ndx).pzg_click_time = clock;
  else
    click_etime = etime( clock, PZG(dom_ndx).pzg_click_time );
    PZG(dom_ndx).pzg_click_time = clock;
    if click_etime < 0.8
      click_type = 'open';
      not_zooming = 1;
    end
  end
  
  plotdata = plot_h{fig_h_ndx};
  
  if ( real(plotdata.CurrPt) < plotdata.xlim(1) ) ...
    ||( real(plotdata.CurrPt) > plotdata.xlim(2) ) ...
    ||( imag(plotdata.CurrPt) < plotdata.ylim(1) ) ...
    ||( imag(plotdata.CurrPt) > plotdata.ylim(2) )
    return
  end
  
  linked = pzg_islink(dom_ndx);
  
  hz_cbval = 0;
  hz_h = pzg_fndo( (1:2),(1:5),'BodeHZChkbox');
  if ~isempty(hz_h)
    hz_cbval = get( hz_h(1),'value');
  end
      
  freq_selection = 0; %#ok<NASGU>
  Zoomed = 1;
  
  if ~isempty(not_zooming)
    Zoomed = ~not_zooming;
  end
  
  if strcmpi( click_type,'open')
    % Zoom all the way out in the current figure.
    if fig_h_ndx <= 5
      xdata = PZG(dom_ndx).BodeFreqs;
      if ( numel(xdata) > 2 ) && ( xdata(end) > xdata(1)+0.01 )
        x_lim = [ xdata(1), xdata(end) ];
        if hz_cbval
          x_lim = x_lim/2/pi;
        end
        set( plotdata.ax_h,'xlim', x_lim )
      else
        if ~isempty(hz_h)
          if hz_cbval
            x_lim = PZG(dom_ndx).BodeFreqs([1, end])/2/pi;
          else
            x_lim = PZG(dom_ndx).BodeFreqs([1, end]);
          end
          set( plotdata.ax_h,'xlim', x_lim );
        else
          xdata = get( PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.Bode_Line,'xdata');
          x_lim = [ xdata(1) xdata(end) ];
          set( plotdata.ax_h,'xlim', x_lim );
        end
      end
      set( plotdata.ax_h,'ylimmode','auto')
      ylim_mode = 'auto';
      y_lim = get( plotdata.ax_h,'ylim');
      plot_h{fig_h_ndx}.xlim = x_lim;
      plot_h{fig_h_ndx}.ylim = y_lim;
      PZG(dom_ndx).plot_h{fig_h_ndx}.xlim = x_lim;
      PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_xlim = x_lim;
      PZG(dom_ndx).plot_h{fig_h_ndx}.ylim = y_lim;
      PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_ylim = y_lim;
      temp_hndl = getappdata(PZG(dom_ndx).plot_h{fig_h_ndx}.fig_h,'hndl');
      temp_hndl.ax_xlim = x_lim;
      temp_hndl.ax_ylim = y_lim;
      setappdata(PZG(dom_ndx).plot_h{fig_h_ndx}.fig_h,'hndl', temp_hndl );
      set( plotdata.ax_h,'ylimmode','manual')
      
    elseif fig_h_ndx == 6
      % Turn off x-axis highlights, tracking lines, and grids before auto-out
      gridlines_h = ...
        [ plot_h{6}.hndl.pzgui_nichols_grid; ...
          plot_h{6}.hndl.equimargin_grid; ...
          plot_h{6}.hndl.equimargin_text; ...
          pzg_fndo( dom_ndx, 6,'CL_0dB_contour'); ...
          pzg_fndo( dom_ndx, 6,'LeadLag_Text') ];
      xaxishilite_h = plot_h{6}.hndl.pzg_Nichols_xaxis_hilite;
      yaxishilite_h = plot_h{6}.hndl.pzg_Nichols_yaxis_hilite;
      neg1_vertlines_h = plot_h{6}.hndl.pzgui_m1_vertical_marker;
      neg1_markers_h = plot_h{6}.hndl.pzgui_nichols_m1_markers;
      try
        nich_cl_track_h = ...
          [ plot_h{6}.hndl.Nichols_CL_track_line(:); ...
            plot_h{6}.hndl.Nichols_CL_track_text(:) ];
      catch
        nich_cl_track_h = [];
      end
      set( [ gridlines_h; xaxishilite_h; nich_cl_track_h; ...
             yaxishilite_h; neg1_vertlines_h; neg1_markers_h ], ...
           'visible','off')
      set( plot_h{6}.ax_h,'xlimmode','auto','ylimmode','auto');
      x_lim = get( plot_h{6}.ax_h,'xlim');
      y_lim = get( plot_h{6}.ax_h,'ylim');
      if ( x_lim(1) > -320 ) || ( x_lim(2) < 120 ) ...
        ||( y_lim(1) > -40 ) || ( y_lim(2) < 50 )
        x_lim(1) = min( x_lim(1), -320 );
        x_lim(2) = max( x_lim(2), 120 );
        y_lim(1) = min( y_lim(1), -40 );
        y_lim(2) = max( y_lim(2), 50 );
        set( plot_h{6}.ax_h,'xlim', x_lim,'ylim', y_lim );
      end
      set( plot_h{6}.ax_h,'xlimmode','manual','ylimmode','manual');
      PZG(dom_ndx).plot_h{6}.xlim = x_lim;
      PZG(dom_ndx).plot_h{6}.hndl.ax_xlim = x_lim;
      PZG(dom_ndx).plot_h{6}.ylim = y_lim;
      PZG(dom_ndx).plot_h{6}.hndl.ax_ylim = y_lim;
      temp_hndl = getappdata(PZG(dom_ndx).plot_h{6}.fig_h,'hndl');
      temp_hndl.ax_xlim = x_lim;
      temp_hndl.ax_ylim = y_lim;
      setappdata(PZG(dom_ndx).plot_h{6}.fig_h,'hndl', temp_hndl );
      
      set( [ xaxishilite_h; yaxishilite_h; ...
             neg1_markers_h; neg1_vertlines_h ], ...
          'visible','on');      
      if plot_h{6}.cl_grid_cb
        set( gridlines_h,'visible','on')
      end
      if ~get( plot_h{6}.hndl.equimargin_checkbox,'value')
        set( [ plot_h{6}.hndl.equimargin_grid; ...
               plot_h{6}.hndl.equimargin_text],'visible','off'); ...
      end
      
    elseif fig_h_ndx == 7
      % Turn off x-axis highlights and grids before auto-out
        xaxishilite_h = pzg_fndo( dom_ndx, 7,'Nyquist_Plot_Xaxis_Highlight');
        yaxishilite_h = pzg_fndo( dom_ndx, 7,'Nyquist_Plot_Yaxis_Highlight');
      set([xaxishilite_h;yaxishilite_h],'visible','off');
      set( plotdata.ax_h,'xlimmode','auto','ylimmode','auto');

    elseif fig_h_ndx == 14
      % Turn off x-axis highlights and grids before auto-out
      xaxishilite_h = pzg_fndo( dom_ndx, 14,'nyq_contour_xaxis_hilite');
      yaxishilite_h = pzg_fndo( dom_ndx, 14,'nyq_contour_yaxis_hilite');
      set([xaxishilite_h;yaxishilite_h],'visible','off');
      set( plotdata.ax_h,'xlimmode','auto','ylimmode','auto');
      drawnow
      if dom_ndx == 1
        x_lim = get( plotdata.ax_h,'xlim');
        x_lim(1) = min( x_lim(1), -diff(x_lim)*0.1 );
        y_lim = get( plotdata.ax_h,'ylim');
      else
        x_lim = [-1.2 1.2];
        y_lim = [-1.05 1.05];
      end
      set( plotdata.ax_h,'xlimmode','manual','xlim', x_lim );
      set( plotdata.ax_h,'ylimmode','manual','ylim', y_lim );
      
      % If any rep-text, adjust its position.
      pzg_reptxt( dom_ndx, x_lim, y_lim );
      
      rep_text_h = pzg_fndo( dom_ndx, 14,'contour_rep_text');
      if ~isempty(rep_text_h)
        if dom_ndx == 1
          x_lim(1) = -2.1;
          set( plotdata.ax_h,'xlimmode','manual','xlim', x_lim );
          for kr = 1:numel(rep_text_h)
            pos = get( rep_text_h(kr),'position');
            pos(1) = -2;
            set( rep_text_h(kr),'position', pos );
          end
        else
          for kr = 1:numel(rep_text_h)
            pz_loc = get( rep_text_h(kr),'userdata');
            if isempty(pz_loc)
              continue
            end
            pos_radius = 1 - max( diff(x_lim), diff(y_lim) )/12; 
            pos_pt = pos_radius * pz_loc;
            pos = ...
              [ real(pos_pt)-0.01*diff(x_lim)*sign(real(pos_pt)+eps), ...
                imag(pos_pt)+0.01*diff(y_lim)*sign(imag(pos_pt)+eps), 0 ];
            set( rep_text_h(kr),'position', pos );
          end
        end
      end
    end
    
    % Update xlim and ylim fields.
    x_lim = get( PZG(dom_ndx).plot_h{fig_h_ndx}.ax_h,'xlim');
    y_lim = get( PZG(dom_ndx).plot_h{fig_h_ndx}.ax_h,'ylim');
    PZG(dom_ndx).plot_h{fig_h_ndx}.xlim = x_lim;
    PZG(dom_ndx).plot_h{fig_h_ndx}.ylim = y_lim;
    PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_xlim = x_lim;
    PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_ylim = y_lim;
    this_hndl = getappdata( PZG(dom_ndx).plot_h{fig_h_ndx}.fig_h,'hndl');
    this_hndl.ax_xlim = x_lim;
    this_hndl.ax_ylim = y_lim;
    setappdata( PZG(dom_ndx).plot_h{fig_h_ndx}.fig_h,'hndl', this_hndl );
    plot_h{fig_h_ndx} = PZG(dom_ndx).plot_h{fig_h_ndx};
    
    local_adjust_nicnyq_hilite_extent( plot_h, fig_h_ndx, dom_ndx )

    
  elseif strcmpi( click_type,'alt')
    
    if isempty( CurrPt )
      currentpoint = get( plot_h{fig_h_ndx}.ax_h,'currentpoint');
      if isequal( size(currentpoint), [2 3] )
        CurrPt = currentpoint(1,1) + 1i*currentpoint(1,2);
      else
        return
      end
    end
    new_x_midpt = real(CurrPt);
    new_y_midpt = imag(CurrPt);
    if fig_h_ndx <= 5
      if plotdata.Log_cb
        old_xlim = plotdata.xlim;
        log_new_xlim = ...
          [ ( log10(new_x_midpt) - 0.7*log10(old_xlim(2)/old_xlim(1)) ), ...
            ( log10(new_x_midpt) + 0.7*log10(old_xlim(2)/old_xlim(1)) ) ];
        new_xlim = 10.^log_new_xlim;
      else
        new_xlim = [ ( new_x_midpt - 0.6666*diff(plotdata.xlim) ), ...
                     ( new_x_midpt + 0.6666*diff(plotdata.xlim) ) ];
      end
      new_xlim(1) = min( new_xlim(1), plotdata.xlim(1) );
      new_xlim(2) = max( new_xlim(2), plotdata.xlim(2) );
      xdata = PZG(dom_ndx).BodeFreqs;
      switch fig_h_ndx
        case 1
          ydata = PZG(dom_ndx).BodeMag;
        case 2
          ydata = PZG(dom_ndx).BodePhs;
        case 3
          ydata = PZG(dom_ndx).CLBodeMag;
        case 4
          ydata = PZG(dom_ndx).CLBodePhs;
        case 5
          ydata = abs( 1./(1+PZG(dom_ndx).BodeMag) );
        otherwise
      end
      if numel(xdata) > 2
        new_xlim(1) = max( new_xlim(1), xdata(1) );
        new_xlim(2) = min( new_xlim(2), xdata(end) );
      end
      ndx1 = pzg_gle( xdata, new_xlim(1),'near');
      ndx2 = pzg_gle( xdata, new_xlim(2),'near');
      
      new_ylim = [ ( new_y_midpt - 0.7*diff(plotdata.ylim) ), ...
                   ( new_y_midpt + 0.7*diff(plotdata.ylim) ) ];
      if numel(ydata) > 2
        new_ylim(1) = max( new_ylim(1), 0.98*min( ydata(ndx1:ndx2) ) );
        new_ylim(2) = min( new_ylim(2), 1.02*max( ydata(ndx1:ndx2) ) );
      end
    else
      new_xlim = [ ( new_x_midpt - 0.7*diff(plotdata.xlim) ), ...
                   ( new_x_midpt + 0.7*diff(plotdata.xlim) ) ];
      new_xlim(1) = min( new_xlim(1), plotdata.xlim(1) );
      new_xlim(2) = max( new_xlim(2), plotdata.xlim(2) );
      new_ylim = [ ( new_y_midpt - 0.7*diff(plotdata.ylim) ), ...
                   ( new_y_midpt + 0.7*diff(plotdata.ylim) ) ];
    end
    if linked
      min_freqw = min( PZG(1).BodeFreqs(1), PZG(1).BodeFreqs(1) );
      max_freqw = min( PZG(1).BodeFreqs(end), PZG(1).BodeFreqs(end) );
      if fig_h_ndx < 6
        if hz_cbval
          new_xlim(1) = max( new_xlim(1), min_freqw/2/pi );
          new_xlim(2) = min( new_xlim(2), max_freqw/2/pi );
        else
          new_xlim(1) = max( new_xlim(1), min_freqw );
          new_xlim(2) = min( new_xlim(2), max_freqw );
        end
      end
    else
      if fig_h_ndx < 6
        if hz_cbval
          new_xlim(1) = max( new_xlim(1), PZG(dom_ndx).BodeFreqs(1)/2/pi );
          new_xlim(2) = min( new_xlim(2), PZG(dom_ndx).BodeFreqs(end)/2/pi );
        else
          new_xlim(1) = max( new_xlim(1), PZG(dom_ndx).BodeFreqs(1) );
          new_xlim(2) = min( new_xlim(2), PZG(dom_ndx).BodeFreqs(end) );
        end
      end
    end
    new_ylim(1) = min( new_ylim(1), plotdata.ylim(1) );
    new_ylim(2) = max( new_ylim(2), plotdata.ylim(2) );
    if ( diff(new_xlim) > 0 ) && ( diff(new_ylim) > 0 )
      set( plotdata.ax_h,'xlim', new_xlim,'ylim', new_ylim );
    end
    
    if ( fig_h_ndx == 14 )
      % If any rep-text, adjust its position.
      pzg_reptxt( dom_ndx, new_xlim, new_ylim );
      
      rep_text_h = pzg_fndo( dom_ndx, 14,'contour_rep_text');
      if ~isempty(rep_text_h)
        if ( dom_ndx == 1 ) && ( new_xlim(1) <= 0 ) && ( new_xlim(2) >= 0 )
          xpos = -diff(new_xlim)/12;
          new_xlim(1) = min( new_xlim(1), xpos );
          set( plotdata.ax_h,'xlim', new_xlim );
          for kr = 1:numel(rep_text_h)
            pos = get( rep_text_h(kr),'position');
            pos(1) = xpos;
            set( rep_text_h(kr),'position', pos );
          end
        elseif dom_ndx == 2
          for kr = 1:numel(rep_text_h)
            pz_loc = get( rep_text_h(kr),'userdata');
            if isempty(pz_loc)
              continue
            end
            pos_radius = 1 - max( diff(new_xlim), diff(new_ylim) )/12; 
            pos_pt = pos_radius * pz_loc;
            pos = ...
              [ real(pos_pt)-0.01*diff(new_xlim)*sign(real(pos_pt)+eps), ...
                imag(pos_pt)+0.01*diff(new_ylim)*sign(imag(pos_pt)+eps), 0 ];
            set( rep_text_h(kr),'position', pos );
          end
        end        
      end
    end
    
    % Update xlim and ylim fields.
    x_lim = get( PZG(dom_ndx).plot_h{fig_h_ndx}.ax_h,'xlim');
    y_lim = get( PZG(dom_ndx).plot_h{fig_h_ndx}.ax_h,'ylim');
    PZG(dom_ndx).plot_h{fig_h_ndx}.xlim = x_lim;
    PZG(dom_ndx).plot_h{fig_h_ndx}.ylim = y_lim;
    PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_xlim = x_lim;
    PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_ylim = y_lim;
    this_hndl = getappdata( PZG(dom_ndx).plot_h{fig_h_ndx}.fig_h,'hndl');
    this_hndl.ax_xlim = x_lim;
    this_hndl.ax_ylim = y_lim;
    setappdata( PZG(dom_ndx).plot_h{fig_h_ndx}.fig_h,'hndl', this_hndl );
    plot_h{fig_h_ndx} = PZG(dom_ndx).plot_h{fig_h_ndx};
    
    local_adjust_nicnyq_hilite_extent( plot_h, fig_h_ndx, dom_ndx )


  elseif strcmpi( click_type,'normal') || strcmpi( click_type,'extend')
    
    % 2013: DISABLE THIS TYPE OF FREQUENCY SELECTION (neg min distance)
    if isequal( not_zooming, 1 )
      % User is selecting a frequency, not zooming.
      % local_update_selected_freq( dom_ndx, plot_h, fig_h_ndx );
      
      % If the domains are connected, update the other domain
      % to the same selected frequency.
      % if linked
      %   bode_freq = [];
      %   cntr_freq = [];
      %   if ~isempty( PZG(dom_ndx).FrqSelNdx )
      %     bode_freq = PZG(dom_ndx).BodeFreqs(PZG(dom_ndx).FrqSelNdx);
      %     cntr_freq = bode_freq;
      %   elseif ~isempty( PZG(dom_ndx).NyqSelNdx )
      %     cntr_freq = ...
      %       PZG(dom_ndx).cntr_data.contour_freq(PZG(dom_ndx).NyqSelNdx);
      %   end
      %   cntr_flag = PZG(dom_ndx).cntr_data.contour_flag(PZG(dom_ndx).NyqSelNdx);
      %   neg_freq = PZG(dom_ndx).NegSelect;
      % 
      %   % Determine transformation method.
      %   linkmenu_h = pzg_fndo( 1,(12:13),'LinkMethod');
      %   if get(linkmenu_h(1),'value') == 3
      %     % Bilinear transformation.
      %     if dom_ndx == 1
      %       % C-T to D-T
      %       z_pt = ...
      %         ( 2 + PZG(2).Ts*1i*bode_freq ) ...
      %         /( 2 - PZG(2).Ts*1i*bode_freq );
      %       bode_freq = angle(z_pt)/PZG(2).Ts;
      %       z_pt = ...
      %         ( 2 + PZG(2).Ts*1i*cntr_freq ) ...
      %         /( 2 - PZG(2).Ts*1i*cntr_freq );
      %       cntr_freq = angle(z_pt)/PZG(2).Ts;
      %     else
      %       % D-T to C-T
      %       if ~isempty(bode_freq)
      %         s_pt = ...
      %           2/PZG(2).Ts * ( exp(1i*bode_freq*PZG(2).Ts) - 1 ) ...
      %                       / ( exp(1i*bode_freq*PZG(2).Ts) + 1 );
      %         bode_freq = imag(s_pt);
      %       end
      %       s_pt = ...
      %         2/PZG(2).Ts * ( exp(1i*cntr_freq*PZG(2).Ts) - 1 ) ...
      %                     / ( exp(1i*cntr_freq*PZG(2).Ts) + 1 );
      %       cntr_freq = imag(s_pt);
      %       if cntr_freq < 0
      %         cntr_freq = abs(cntr_freq);
      %         bode_freq = abs(bode_freq);
      %         neg_freq = 1;
      %       end
      %       if ( cntr_freq ...
      %           >= ( PZG(1).BodeFreqs(end) ...
      %               +diff( PZG(1).BodeFreqs(end-1:end) )/2 ) ) ...
      %         && isequal( cntr_flag, 1 )
      %         bode_freq = [];
      %         cntr_freq = [];
      %       end
      %     end
      %   else
      %     % Not bilinear, 
      %     if dom_ndx == 2
      %       % D-T to C-T
      %       bode_freq = mod( abs(bode_freq), 2*pi/PZG(2).Ts );
      %       if abs(bode_freq) > pi/PZG(2).Ts
      %         bode_freq = 2*pi/PZG(2).Ts - bode_freq;
      %         %neg_freq = isequal( 0, neg_freq );
      %       end
      %       cntr_freq = bode_freq;
      %     elseif ( dom_ndx == 1 ) && ~isinf(cntr_freq)
      %       % Alias C-T contour frequency down to D-T range.
      %       % Bode frequency might be valid for any finite contour freq.
      %         % if ~isempty(bode_freq) && ( bode_freq > 4*pi/PZG(2).Ts )
      %         %   bode_freq = mod( bode_freq, 2*pi/PZG(2).Ts );
      %         % end
      %       cntr_freq = mod( abs(cntr_freq), 2*pi/PZG(2).Ts );
      %       if neg_freq
      %         bode_freq = 2*pi/PZG(2).Ts - cntr_freq;
      %       else
      %         bode_freq = cntr_freq;
      %       end
      %       if cntr_freq > pi/PZG(2).Ts
      %         cntr_freq = 2*pi/PZG(2).Ts - cntr_freq;
      %         neg_freq = isequal( 0, neg_freq ); % toggle
      %       end
      %     end
      %   end
      %   other_dom_ndx = 1;
      %   if dom_ndx == 1
      %     other_dom_ndx = 2;
      %   end
      %   %PZG(other_dom_ndx).FrqSelNdx = [];
      %   PZG(other_dom_ndx).NyqSelNdx = [];
      %   if ~isempty(bode_freq)
      %     if other_dom_ndx == 1
      %       if bode_freq ...
      %         <= ( PZG(1).BodeFreqs(end) ...
      %             +diff( PZG(1).BodeFreqs(end-1:end) )/2 )
      %         PZG(1).FrqSelNdx = ...
      %           pzg_gle( PZG(1).BodeFreqs, bode_freq,'near');
      %       else
      %         cntr_freq = [];
      %       end
      %     else
      %       if bode_freq <= PZG(2).BodeFreqs(end)
      %         PZG(2).FrqSelNdx = ...
      %           pzg_gle( PZG(2).BodeFreqs, bode_freq,'near');
      %       end
      %     end
      %   end
      %   if ~isempty(cntr_freq)
      %     if ( other_dom_ndx == 1 ) && ~isinf(cntr_freq)
      %       if cntr_freq <= ...
      %           ( PZG(1).BodeFreqs(end) ...
      %            +diff( PZG(1).BodeFreqs(end-1:end) )/2 )
      %         PZG(1).NyqSelNdx = ...
      %           pzg_gle( PZG(1).cntr_data.contour_freq, cntr_freq,'near');
      %       end
      %     else
      %       PZG(2).NyqSelNdx = ...
      %         pzg_gle( PZG(2).cntr_data.contour_freq, cntr_freq,'near');
      %     end
      %   end
      %   PZG(other_dom_ndx).NegSelect = neg_freq;
      % 
      %   other_plot_h = PZG(other_dom_ndx).plot_h;
      %   if dom_ndx == 1
      %     other_plot_h{10} = [];
      %     other_plot_h{12} = []; %#ok<NASGU>
      %   else
      %     other_plot_h{11} = [];
      %     other_plot_h{13} = []; %#ok<NASGU>
      %   end
      %   %local_update_selected_freq( ...
      %   %   other_dom_ndx, other_plot_h, [], PZG(other_dom_ndx).NegSelect );
      % end
      % 
      % return
    else
      old_xlim = get( plot_h{fig_h_ndx}.ax_h,'xlim');
      old_ylim = get( plot_h{fig_h_ndx}.ax_h,'ylim');
      oldCurrPt = get( plot_h{fig_h_ndx}.ax_h,'currentpoint');
      
      zoom('down')
      
      new_ylim = get( plot_h{fig_h_ndx}.ax_h,'ylim');
      new_xlim = get( plot_h{fig_h_ndx}.ax_h,'xlim');
      if ( fig_h_ndx < 6 ) ...
        &&( ( new_xlim(1) < PZG(dom_ndx).BodeFreqs(1) ) ...
           ||( new_xlim(2) > PZG(dom_ndx).BodeFreqs(end) ) )
        test_xdata = ...
          get( PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.Bode_Line,'xdata');
        if dom_ndx == 1
          other_bode_h = pzg_fndo( 2,(1:5),'Bode_Line');
        else
          other_bode_h = pzg_fndo( 1,(1:5),'Bode_Line');
        end
        if isempty(other_bode_h)
          other_test_xdata = test_xdata;
        else
          other_test_xdata = get( other_bode_h(1),'xdata');
        end
        min_xdata = min( min(test_xdata), min(other_test_xdata) );
        max_xdata = max( max(test_xdata), max(other_test_xdata) );
        new_xlim(2) = min( new_xlim(2), max_xdata );
        new_xlim(1) = max( new_xlim(1), min_xdata );
        if diff( new_xlim ) <= 0
          new_xlim = [ min_xdata max_xdata ];
        end
        set( plot_h{fig_h_ndx}.ax_h,'xlim', new_xlim );
      end
      
      newCurrPt = get( plot_h{fig_h_ndx}.ax_h,'currentpoint');
      newCurrPt(1,1) = max( newCurrPt(1,1), new_xlim(1) );
      
      if ( ~isempty(not_zooming) && ~isequal( 0, not_zooming ) ) ...
        ||( norm( abs(newCurrPt(1,1:2)-oldCurrPt(1,1:2) ) ...
                 ./[ diff(old_xlim), diff(old_ylim) ] ) < 0.01 )
        Zoomed = 0;
      end
      
      CurrPt = get( plot_h{fig_h_ndx}.ax_h,'currentpoint');
      CurrPt = CurrPt(1,1) + 1i*CurrPt(1,2);
      plot_h{fig_h_ndx}.CurrPt = CurrPt;
      if ( min( abs(real(CurrPt)-new_xlim)/diff(new_xlim) ) < 0.01 ) ...
        &&( min( abs(imag(CurrPt)-new_ylim)/diff(new_ylim) ) < 0.01 )
        % The "zoom" function was used to draw a zoom-box.
        % Enforce x-limits.
        if fig_h_ndx <= 5
          bodeline_h = plot_h{fig_h_ndx}.hndl.Bode_Line;
          if numel(bodeline_h) > 1
            bodeline_h = bodeline_h(1);
          end
          xdata = get( bodeline_h,'xdata');
          if numel(xdata) > 2
            new_xlim(1) = max( new_xlim(1), xdata(1) );
            new_xlim(2) = min( new_xlim(2), xdata(end) );
          end
          if isequal( numel(new_xlim), 2 ) ...
            && ~any(isinf(new_xlim)) && ~any(isnan(new_xlim))
            new_xlim = sort(new_xlim);
            set( plot_h{fig_h_ndx}.ax_h,'xlim', new_xlim );
          end
        end
      else
        if ~Zoomed
          % User is using a left-button-click to zoom in.
          old_xlim = plot_h{fig_h_ndx}.xlim;
          old_ylim = plot_h{fig_h_ndx}.ylim;
          if ( fig_h_ndx <= 5 ) && plot_h{fig_h_ndx}.Log_cb
            log_new_xlim = ...
              log10(real(CurrPt)) + 0.35*[-1 1]*log10(old_xlim(2)/old_xlim(1));
            new_xlim = 10.^log_new_xlim;
          else
            new_xlim = real(CurrPt) + 0.35*[-1 1]*diff(old_xlim);
          end
          new_ylim = imag(CurrPt) + 0.35*[-1 1]*diff(old_ylim);
          new_xlim(1) = max( 0.99*old_xlim(1), new_xlim(1) );
          new_xlim(2) = min( 1.01*old_xlim(2), new_xlim(2) );
          new_ylim(1) = max( 0.99*old_ylim(1), new_ylim(1) );
          new_ylim(2) = min( 1.01*old_ylim(2), new_ylim(2) );
          new_xlim = sort(new_xlim);
          new_ylim = sort(new_ylim);
          if diff(new_xlim) <= 1e-7
            new_xlim = old_xlim;
          end
          if diff(new_ylim) <= 1e-7
            new_ylim = old_ylim;
          end
          if isequal( numel(new_xlim), 2 ) && isequal( numel(new_ylim), 2 ) ...
            && ~any(isinf(new_xlim)) && ~any(isinf(new_ylim)) ...
            && ~any(isnan(new_xlim)) && ~any(isnan(new_ylim))
            new_xlim = sort(new_xlim);
            new_ylim = sort(new_ylim);
            set( plot_h{fig_h_ndx}.ax_h, ...
                'xlim', new_xlim, ...
                'ylim', new_ylim );
          else
            new_xlim = old_xlim;
            new_ylim = old_ylim;
          end
        end
      end
      
      if fig_h_ndx == 14
        % If any rep-text, adjust its position.
        pzg_reptxt( dom_ndx, new_xlim, new_ylim );

        rep_text_h = pzg_fndo( dom_ndx, 14,'contour_rep_text');
        if ~isempty(rep_text_h)
          if ( dom_ndx == 1 ) && ( new_xlim(1) <= 0 ) ...
            && ( new_xlim(2) >= 0 )
            xpos = -diff(new_xlim)/12;
            new_xlim(1) = min( new_xlim(1), xpos );
            set( plotdata.ax_h,'xlim', new_xlim );
            for kr = 1:numel(rep_text_h)
              pos = get( rep_text_h(kr),'position');
              pos(1) = xpos;
              set( rep_text_h(kr),'position', pos );
            end
          elseif dom_ndx == 2
            for kr = 1:numel(rep_text_h)
              pz_loc = get( rep_text_h(kr),'userdata');
              if isempty(pz_loc)
                continue
              end
              pos_radius = 1 - max( diff(new_xlim), diff(new_ylim) )/12; 
              pos_pt = pos_radius * pz_loc;
              pos = ...
                [ real(pos_pt)-0.01*diff(new_xlim)*sign(real(pos_pt)+eps), ...
                  imag(pos_pt)+0.01*diff(new_ylim)*sign(imag(pos_pt)+eps), 0 ];
              set( rep_text_h(kr),'position', pos );
            end
          end
        end
      end
      
      % Update xlim and ylim fields.
      x_lim = get( PZG(dom_ndx).plot_h{fig_h_ndx}.ax_h,'xlim');
      y_lim = get( PZG(dom_ndx).plot_h{fig_h_ndx}.ax_h,'ylim');
      PZG(dom_ndx).plot_h{fig_h_ndx}.xlim = x_lim;
      PZG(dom_ndx).plot_h{fig_h_ndx}.ylim = y_lim;
      PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_xlim = x_lim;
      PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_ylim = y_lim;
      this_hndl = getappdata( PZG(dom_ndx).plot_h{fig_h_ndx}.fig_h,'hndl');
      this_hndl.ax_xlim = x_lim;
      this_hndl.ax_ylim = y_lim;
      setappdata( PZG(dom_ndx).plot_h{fig_h_ndx}.fig_h,'hndl', this_hndl );
      plot_h{fig_h_ndx} = PZG(dom_ndx).plot_h{fig_h_ndx};
    
      local_adjust_nicnyq_hilite_extent( plot_h, fig_h_ndx, dom_ndx )
    end
  end

  if fig_h_ndx <= 5
    % Link in the other bode plots, in the x-axis sense.
    % If user has double-clicked, zoom all y-axes all the way out.
    this_xlim = plot_h{fig_h_ndx}.xlim;
    for kdom = 1:2
      for kp = 1:5
        if ( ( kdom ~= dom_ndx ) || ( fig_h_ndx ~= kp ) ) ...
          && ~isempty(plot_h{kp}) ...
          && isfield( PZG(kdom).plot_h{kp},'fig_h')
          set( PZG(kdom).plot_h{kp}.ax_h,'xlim', this_xlim )
          if strcmp( ylim_mode,'auto')
            set( PZG(kdom).plot_h{kp}.ax_h,'ylimmode','auto')
            y_lim = get( PZG(kdom).plot_h{kp}.ax_h,'ylim');
            PZG(kdom).plot_h{kp}.ylim = y_lim;
            PZG(kdom).plot_h{kp}.hndl.ax_ylim = y_lim;
            set( PZG(kdom).plot_h{kp}.ax_h,'ylimmode','manual')
            if kdom == dom_ndx
              plot_h{kp}.ylim = y_lim;
              plot_h{kp}.hndl.ax_ylim = y_lim;
            end
          end
          PZG(kdom).plot_h{kp}.xlim = x_lim;
          PZG(kdom).plot_h{kp}.hndl.ax_xlim = x_lim;
          if kdom == dom_ndx
            plot_h{kp}.xlim = x_lim;
            plot_h{kp}.hndl.ax_xlim = x_lim;
          end
          if isappdata( PZG(kdom).plot_h{kp}.fig_h,'hndl')
            this_hndl = getappdata( PZG(kdom).plot_h{kp}.fig_h,'hndl');
            this_hndl.ax_xlim = x_lim;
            if strcmp( ylim_mode,'auto')
              this_hndl.ax_ylim = y_lim;
            end
            setappdata( PZG(kdom).plot_h{kp}.fig_h,'hndl', this_hndl );
          end
        end
      end
    end
  end

  if fig_h_ndx == 7
    % Nyquist plot
    xline_h = pzg_fndo( dom_ndx, 7, 'Nyquist_Plot_Xaxis_Highlight');
    yline_h = pzg_fndo( dom_ndx, 7, 'Nyquist_Plot_Yaxis_Highlight');
    if ~isempty(xline_h)
      plotdata.xlim = plot_h{fig_h_ndx}.xlim;
      set( xline_h,'xdata', plot_h{fig_h_ndx}.xlim );
    end
    if ~isempty(yline_h)
      plotdata.ylim = plot_h{fig_h_ndx}.ylim;
      set( yline_h,'ydata', plot_h{fig_h_ndx}.ylim );
    end
    hyb_h = PZG(dom_ndx).plot_h{7}.hndl.rescale_checkbox;
    if ~isempty(hyb_h)
      if get( hyb_h,'value')
        set( plotdata.ax_h,'xticklabel','','xticklabelmode','manual', ...
            'yticklabel','','yticklabelmode','manual')
      else
        set( plotdata.ax_h,'xticklabelmode','auto','yticklabelmode','auto')
      end
    end
    return

  elseif fig_h_ndx == 6
    % Nichols plot
    local_adjust_nicnyq_hilite_extent( plot_h, fig_h_ndx, dom_ndx )
    return
  end
  % end      

return

function pd = local_get_contour_text( pd )

  global PZG
  
  encirc_dir_str = [];
  
  if isinf(pd.contour_flag)
    % Pole detour
    
    if ~isnan( pd.contour_angle )
      if pd.dom_ndx == 1
        [ min_dist, min_dist_ndx ] = ...
            min( abs( 1i*abs(pd.nyq_freq_w) ...
                     - PZG(1).cntr_data.ld_poles ) ); %#ok<ASGLU>
        encirc_dir_str = ...
          [ '(' PZG(1).cntr_data.encirc_dir{min_dist_ndx} ')'];
      else
        [ min_dist, min_dist_ndx ] = ...
            min( abs( exp( 1i*abs(pd.nyq_freq_w) * PZG(2).Ts) ...
                     - PZG(2).cntr_data.ld_poles ) ); %#ok<ASGLU>
        encirc_dir_str = ...
          [ '(' PZG(2).cntr_data.encirc_dir{min_dist_ndx} ')'];
      end
    end
    
    if pd.contour_freq == 0
      if pd.dom_ndx == 1
        if isnan(pd.contour_angle)
          if pd.neg_freq
            pd.nicnyq_freqstr = ...
             {['indent at a pole:   ' ...
               '\epsilon \angle -90^o']; ...
              [' maps to:  ' ...
               '\infty \angle' pd.nicnyq_phs_str ]};
          else
            pd.nicnyq_freqstr = ...
             {['indent at a pole:   ' ...
               '\epsilon \angle 90^o']; ...
              [' maps to:  ' ...
               '\infty \angle' pd.nicnyq_phs_str ]};
          end
        else
          pd.nicnyq_freqstr = ...
           {['indent at a pole:   ' ...
             '\epsilon \angle' ...
                       local_tenths_str(pd.contour_angle) '^o']; ...
            [' maps to:  ' ...
             '\infty \angle' pd.nicnyq_phs_str ]};
        end
      else
        if isnan(pd.contour_angle)
          if pd.neg_freq
            angle90_str = '-90';
          else
            angle90_str = '90';
          end
          pd.nicnyq_freqstr = ...
           {['indent at a pole:   ' ...
             '1 + \epsilon \angle ' angle90_str '^o']; ...
            [' maps to:  ' ...
             '\infty \angle' pd.nicnyq_phs_str ]};
        else
          pd.nicnyq_freqstr = ...
           {['indent at a pole:   ' ...
             '1 + \epsilon \angle' ...
                          local_tenths_str(pd.contour_angle) '^o']; ...
            [' maps to:  ' ...
             '\infty \angle' pd.nicnyq_phs_str ]};
        end
      end
    elseif ( pd.dom_ndx == 2 ) ...
         &&( abs( abs(pd.contour_freq) - pi/PZG(2).Ts ) < 1e-8 )
      if isnan( pd.contour_angle )
        if pd.neg_freq
          angle90_str = '-90';
        else
          angle90_str = '90';
        end
        pd.nicnyq_freqstr = ...
         {['indent at a pole:   ' ...
           '-1 + \epsilon \angle' angle90_str '^o']; ...
          [' maps to:  \infty \angle' pd.nicnyq_phs_str ]};
      elseif pd.neg_freq
        pd.nicnyq_freqstr = ...
         {['indent at a pole:   ' ...
           '-1 + \epsilon \angle' ...
                        local_tenths_str(-180+pd.contour_angle) '^o']; ...
          [' maps to:  \infty \angle' pd.nicnyq_phs_str ]};
      else
        pd.nicnyq_freqstr = ...
         {['indent at a pole:   ' ...
           '-1 + \epsilon \angle' ...
                        local_tenths_str(180+pd.contour_angle) '^o']; ...
          [' maps to:  \infty \angle' pd.nicnyq_phs_str ]};
      end
    else
      if pd.dom_ndx == 1
        if isnan( pd.contour_angle )
          if imag( pd.contour_pt ) < pd.contour_freq
            pd.nicnyq_freqstr = ...
             {['indent at a pole:  ' ...
               num2str(pd.contour_freq) 'i '...
               '+ \epsilon \angle -90^o']; ...
              [' maps to:  ' ...
               '\infty \angle' pd.nicnyq_phs_str ]};
          else
            pd.nicnyq_freqstr = ...
             {['indent at a pole:  ' ...
               num2str(pd.contour_freq) 'i '...
               '+ \epsilon \angle 90^o']; ...
              [' maps to:  ' ...
               '\infty \angle' pd.nicnyq_phs_str ]};
          end
        else
          pd.nicnyq_freqstr = ...
           {['indent at a pole:  ' ...
             num2str(pd.contour_freq) 'i '...
             '+ \epsilon \angle' ...
                   local_tenths_str(pd.contour_angle) '^o']; ...
            [' maps to:  ' ...
             '\infty \angle' pd.nicnyq_phs_str ]};
        end
      else
        if isnan( pd.contour_angle )
          uc_pole_loc = exp( 1i*pd.contour_freq*PZG(2).Ts );
          if abs(angle(pd.contour_pt)) < abs(angle(uc_pole_loc))
            if pd.neg_freq
              angle90_str = '90';
            else
              angle90_str = '-90';
            end
          else
            if pd.neg_freq
              angle90_str = '-90';
            else
              angle90_str = '90';
            end
          end
          if abs( abs(pd.contour_freq)*PZG(2).Ts - pi ) < 1e-3
            contourloc_str = ...
              ['indent at a pole:  -1 + \epsilon \angle' angle90_str '^o)'];
          elseif pd.contour_freq > 0
            contourloc_str = ...
              ['indent at a pole:  ' ...
               'exp( j ' num2str(abs(pd.contour_freq)) ' T )'...
               'x( 1 + \epsilon \angle' angle90_str '^o)'];
          else
            contourloc_str = ...
              ['indent at a pole:  ' ...
               'exp( -j ' num2str(abs(pd.contour_freq)) ' T )'...
               'x( 1 + \epsilon \angle' angle90_str '^o)'];
          end
          pd.nicnyq_freqstr = ...
           { contourloc_str; ...
            ['  maps to:  \infty \angle' pd.nicnyq_phs_str ]};
        else
          if abs( abs(pd.contour_freq)*PZG(2).Ts - pi ) < 1e-3
            contourloc_str = ...
              ['indent at a pole:  -1 + \epsilon \angle' ...
                  local_tenths_str(pd.contour_angle) '^o)'];
          elseif pd.contour_freq > 0
            contourloc_str = ...
              ['indent at a pole:  ' ...
               'exp( j ' num2str(pd.contour_freq) ' T )'...
               'x( 1 + \epsilon \angle' ...
                          local_tenths_str(pd.contour_angle) '^o)'];
          else
            contourloc_str = ...
              ['indent at a pole:  ' ...
               'exp( -j ' num2str(abs(pd.contour_freq)) ' T )'...
               'x( 1 + \epsilon \angle' ...
                          local_tenths_str(pd.contour_angle) '^o)'];
          end
          pd.nicnyq_freqstr = ...
           { contourloc_str; ...
            ['  maps to:  \infty \angle' pd.nicnyq_phs_str ]};
        end
      end
    end
  elseif isequal( pd.contour_flag, 0 )
    % Zero detour
    if isinf(pd.contour_freq)
      if isnan( pd.contour_angle )
        if pd.neg_freq
        pd.nicnyq_freqstr = ...
           {'\infty neg. j\omega-axis: '; ...
            [' maps to:  ' ...
             'zero mag. at \angle' pd.nicnyq_phs_str ]};
        else
        pd.nicnyq_freqstr = ...
           {'\infty pos. j\omega-axis: '; ...
            [' maps to: ' ...
             'zero mag. at \angle' pd.nicnyq_phs_str ]};
        end
      else
        pd.nicnyq_freqstr = ...
         {['\infty-radius RHP-semicirc. at ' ...
            '\angle' local_tenths_str(pd.contour_angle) '^o']; ...
          [' maps to:  ' ...
           'zero mag. at \angle' pd.nicnyq_phs_str ]};
      end
    elseif pd.contour_freq == 0
      if pd.dom_ndx == 1
        if isnan(pd.contour_angle)
          if pd.neg_freq
            pd.nicnyq_freqstr = ...
             {['indent at a zero:   ' ...
               '\epsilon \angle -90^o']; ...
              [' maps to:  ' ...
               'zero mag. at \angle' pd.nicnyq_phs_str ]};
          else
            pd.nicnyq_freqstr = ...
             {['indent at a zero:   ' ...
               '\epsilon \angle 90^o']; ...
              [' maps to:  ' ...
               'zero mag. at \angle' pd.nicnyq_phs_str ]};
          end
        else
          pd.nicnyq_freqstr = ...
           {['indent at a zero:   ' ...
             '\epsilon \angle' ...
                       local_tenths_str(pd.contour_angle) '^o']; ...
            [' maps to:  ' ...
             'zero mag. at \angle' pd.nicnyq_phs_str ]};
        end
      else
        if isnan( pd.contour_angle )
          if pd.neg_freq
            angle90_str = '-90';
          else
            angle90_str = '90';
          end
          pd.nicnyq_freqstr = ...
           {['indent at a zero:   ' ...
             '1 + \epsilon \angle' angle90_str '^o']; ...
            [' maps to:  ' ...
             'zero mag. at \angle' pd.nicnyq_phs_str ]};
        else
          pd.nicnyq_freqstr = ...
           {['indent at a zero:   ' ...
             '1 + \epsilon \angle' ...
                          local_tenths_str(pd.contour_angle) '^o']; ...
            [' maps to:  ' ...
             'zero mag. at \angle' pd.nicnyq_phs_str ]};
        end
      end
    elseif ( pd.dom_ndx == 2 ) ...
         &&( abs( abs(pd.contour_freq) - pi/PZG(2).Ts ) < 1e-5 )
      if isnan( pd.contour_angle )
        if pd.neg_freq
          angle90_str = '-90';
        else
          angle90_str = '90';
        end
        pd.nicnyq_freqstr = ...
         {['indent at a zero:   ' ...
           '-1 + \epsilon \angle' angle90_str '^o']; ...
          [' maps to:  ' ...
           'zero mag. at \angle' pd.nicnyq_phs_str ]};
      elseif pd.neg_freq
        pd.nicnyq_freqstr = ...
         {['indent at a zero:   ' ...
           '-1 + \epsilon \angle' ...
                        local_tenths_str(-180+pd.contour_angle) '^o']; ...
          [' maps to:  ' ...
           'zero mag. at \angle' pd.nicnyq_phs_str ]};
      else
        pd.nicnyq_freqstr = ...
         {['indent at a zero:   ' ...
           '-1 + \epsilon \angle' ...
                        local_tenths_str(180+pd.contour_angle) '^o']; ...
          [' maps to:  ' ...
           'zero mag. at \angle' pd.nicnyq_phs_str ]};
      end
    else
      if pd.dom_ndx == 1
        pd.nicnyq_freqstr = ...
         {['indent at a zero:  ' ...
           num2str(pd.contour_freq) 'i '...
           '+ \epsilon \angle' ...
                 local_tenths_str(pd.contour_angle) '^o']; ...
          ['  maps to:  ' ...
           'zero mag. at \angle' pd.nicnyq_phs_str ]};
      else
        if isnan( pd.contour_angle )
          uc_pole_loc = exp( 1i*pd.contour_freq*PZG(2).Ts );
          if abs(angle(pd.contour_pt)) < abs(angle(uc_pole_loc))
            if pd.neg_freq
              angle90_str = '90';
            else
              angle90_str = '-90';
            end
          else
            if pd.neg_freq
              angle90_str = '-90';
            else
              angle90_str = '90';
            end
          end
          if abs( abs(pd.contour_freq)*PZG(2).Ts - pi ) < 1e-3
            contourloc_str = ...
              ['indent at a zero:  -1 + \epsilon \angle' angle90_str '^o)'];
          elseif pd.contour_freq > 0
            contourloc_str = ...
              ['indent at a zero:  ' ...
               'exp( j ' num2str(abs(pd.contour_freq)) ' T )'...
               'x( 1 + \epsilon \angle' angle90_str '^o)'];
          else
            contourloc_str = ...
              ['indent at a zero:  ' ...
               'exp( -j ' num2str(abs(pd.contour_freq)) ' T )'...
               'x( 1 + \epsilon \angle' angle90_str '^o)'];
          end
          pd.nicnyq_freqstr = ...
           { contourloc_str; ...
            ['  maps to:  zero mag. at \angle' pd.nicnyq_phs_str ]};
        else
          if abs( abs(pd.contour_freq)*PZG(2).Ts - pi ) < 1e-3
            contourloc_str = ...
              ['indent at a zero:  -1 + \epsilon \angle' ...
                  local_tenths_str(pd.contour_angle) '^o)'];
          elseif pd.contour_freq > 0
            contourloc_str = ...
              ['indent at a zero:  ' ...
               'exp( j ' num2str(pd.contour_freq) ' T )'...
               'x( 1 + \epsilon \angle' ...
                          local_tenths_str(pd.contour_angle) '^o)'];
          else
            contourloc_str = ...
              ['indent at a zero:  ' ...
               'exp( -j ' num2str(abs(pd.contour_freq)) ' T )'...
               'x( 1 + \epsilon \angle' ...
                          local_tenths_str(pd.contour_angle) '^o)'];
          end
          pd.nicnyq_freqstr = ...
           { contourloc_str; ...
            ['  maps to:  zero mag. at \angle' pd.nicnyq_phs_str ]};
        end
      end
    end
  end
  
  if isinf(pd.contour_flag) && iscell(pd.nicnyq_freqstr) ...
    && ischar( encirc_dir_str )
    pd.nicnyq_freqstr{end} = ...
      [ pd.nicnyq_freqstr{end} '  ' encirc_dir_str ];
  elseif isinf(pd.nyq_freq_w) && isequal( 0, pd.contour_flag )
    % In this case, the HF magnitude does not go to zero
    % because number of poles equals number of zeros.
  end
  
return

function local_plot_clbode_nich_mag_phs( plot_h, fig_h_ndx, dom_ndx )
 
  global PZG
  
  track_hilites = 1;
  if ( ~isequal( fig_h_ndx, 3 ) ...
      && ~isequal( fig_h_ndx, 4 ) ...
      && ~isequal( fig_h_ndx, 6 ) ) ...
    || isempty(plot_h{6}) ...
    || ~isfield( plot_h{6},'fig_h') ...
    || ~plot_h{6}.cl_grid_cb ...
    || ~plot_h{6}.hilite_cb
    track_hilites = 0;
  elseif isempty(plot_h{fig_h_ndx}) ...
      || ~isfield( plot_h{fig_h_ndx},'fig_h') ...
      || ~isfield( plot_h{fig_h_ndx},'CurrPt') ...
      || isempty(plot_h{fig_h_ndx}.CurrPt)
    track_hilites = 0;
  end
  
  if track_hilites
    CurrPt = plot_h{fig_h_ndx}.CurrPt;
    if ( numel(CurrPt) ~= 1 ) ...
      ||( real(CurrPt) < plot_h{fig_h_ndx}.xlim(1) ) ...
      ||( real(CurrPt) > plot_h{fig_h_ndx}.xlim(2) ) ...
      ||( imag(CurrPt) < plot_h{fig_h_ndx}.ylim(1) ) ...
      ||( imag(CurrPt) > plot_h{fig_h_ndx}.ylim(2) )
      track_hilites = 0;
    end
  end
  
  if ~track_hilites
    nich_cl_track_h = ...
      [ pzg_fndo( (1:2),[3;4;6],'Nichols_CL_track_line'); ...
        pzg_fndo( (1:2),[3;4;6],'Nichols_CL_track_text') ];
    if ~isempty(nich_cl_track_h)
      set( nich_cl_track_h,'visible','off');
    end
    return
  end
  
  % If execution reaches here, Nichols-grid hilites are on.
  himag_track_vis = 'on';
  if fig_h_ndx == 6
    OLfr_pt = 10^(imag(CurrPt)/20) * exp(1i*real(CurrPt)/180*pi);
    CLfr_pt = OLfr_pt / ( 1 + OLfr_pt );
    mag_track_vis = 'on';
    phs_track_vis = 'on';
    mag_track_linewidth = 2;
    %phs_track_linewidth = 1;
  elseif fig_h_ndx == 3
    CurrCLMag = imag(CurrPt);
    if plot_h{fig_h_ndx}.dB_cb
      CurrCLMag = 10^(CurrCLMag/20); 
    end
    CLfr_pt = CurrCLMag * exp(-1i*pi/4);
    mag_track_vis = 'on';
    phs_track_vis = 'off';
    mag_track_linewidth = 2;
    %phs_track_linewidth = 1;
  elseif fig_h_ndx == 4
    CurrCLPhs = imag(CurrPt);
    CLfr_pt = 0.1 * exp(1i*CurrCLPhs/180*pi);
    mag_track_vis = 'off';
    phs_track_vis = 'on';
    mag_track_linewidth = 2;
    %phs_track_linewidth = 1;
  else
    mag_track_vis = 'off';
    phs_track_vis = 'off';
    mag_track_linewidth = 2;
    %phs_track_linewidth = 1;
  end
  
  if plot_h{fig_h_ndx}.mindist < 0.05
    if numel( PZG(dom_ndx).CLBodeMag ) < 3
      mag_track_vis = 'off';
      phs_track_vis = 'off';
      freq_ndx = [];
    else
      mag_track_vis = 'on';
      phs_track_vis = 'on';
      if ( fig_h_ndx == 3 ) || ( fig_h_ndx == 4 ) || ( fig_h_ndx == 6 )
        % Get the open and closed-loop data at the selected frequency.
        this_freq = PZG(dom_ndx).plot_h{fig_h_ndx}.nearest_freq;
        [ temp, freq_ndx ] = ...
            min( abs( PZG(dom_ndx).BodeFreqs - abs(this_freq) ) );     %#ok<ASGLU>
        if isempty(freq_ndx) ...
          || ( freq_ndx > numel(PZG(dom_ndx).cntr_data.bode2nyq_pts) )
          return
        end
        OLfr_pt = PZG(dom_ndx).cntr_data.bode2nyq_pts(freq_ndx);
        if plot_h{fig_h_ndx}.neg_freq
          OLfr_pt = conj(OLfr_pt);
        end
        CLfr_pt = OLfr_pt / ( 1 + OLfr_pt );
        CurrCLPhs = PZG(dom_ndx).CLBodePhs(freq_ndx);
        if PZG(dom_ndx).plot_h{fig_h_ndx}.neg_freq
          CurrCLPhs = -CurrCLPhs;
        end
      end
    end
  else
    if fig_h_ndx == 4
      himag_track_vis = 'off';
    end
  end
  
  nich_h = plot_h{6}.fig_h;
  nich_ax_h = plot_h{6}.ax_h;
  x_lim = plot_h{6}.xlim;
  y_lim = plot_h{6}.ylim;
  
  nr_pts = 5000;
  if ( abs(angle(CLfr_pt)) > 0.01 ) ...
    &&( abs(20*log10(abs(CLfr_pt))) > 0.095 )
    d_mag = ...
      [ logspace( min( -3, log10(abs(CLfr_pt)) ), 0, nr_pts ), ...
        logspace( 0, max( 3, log10(abs(CLfr_pt)) ), nr_pts ) ]';
    phs1 = exp( 1i*angle(CLfr_pt) ) * d_mag;
    phs_map = phs1./( 1 - phs1 );
    d_phs = logspace( -3, log10(pi/2-1e-3), nr_pts )';
    d_phs = [ d_phs; pi-flipud(d_phs) ];
    mag1 = abs(CLfr_pt) * exp( 1i*d_phs );
    mag_map = mag1./( 1 - mag1 );
  else
    d_angle = logspace( -8, log10(pi/2-1e-8), nr_pts/2 );
    d_angle = [ d_angle, NaN, pi-fliplr(d_angle) ]';
    this_ang = angle(CLfr_pt);
    if this_ang > 0
      this_ang = mod( this_ang, 2*pi );
    else
      this_ang = -mod( -this_ang, 2*pi );
    end
    d_mag = 1 + abs( sin(d_angle) / this_ang );
    if this_ang > 0
      phs_map = d_mag .* exp(1i*d_angle);
    else
      phs_map = d_mag .* exp(-1i*d_angle);
    end
    mag1 = abs(CLfr_pt) * exp( 1i*d_angle );
    mag_map = mag1./( 1 - mag1 );
    phs_map(1:2) = phs_map(1:2)/1000;
  end
  mag_map(1) = NaN;
  mag_map(end) = NaN;
  phs_map(1) = NaN;
  phs_map(end) = NaN;

  ol_pts = [ mag_map(1:numel(phs_map)), phs_map ];

  ol_mag_db = 20*log10(abs(ol_pts));
  ol_mag_db = [ ol_mag_db; ...
                flipud(ol_mag_db); ...
                NaN NaN ];
  ol_mag_db = [ ol_mag_db; ...
                ol_mag_db; ...
                ol_mag_db; ...
                ol_mag_db ];

  ol_phs_deg = 180/pi*angle(ol_pts);
  ol_phs_deg = [ ol_phs_deg; ...
                 360-flipud(ol_phs_deg(:,1)), flipud(ol_phs_deg(:,2)); ...
                 NaN NaN ];

  if max(ol_phs_deg(:,1)) > 1
    ol_phs_deg = ...
      [ ol_phs_deg(:,1)-2*360, ol_phs_deg(:,2); ...
        ol_phs_deg(:,1)-360, ol_phs_deg(:,2); ...
        ol_phs_deg(:,1), ol_phs_deg(:,2); ...
        ol_phs_deg(:,1)+360, ol_phs_deg(:,2) ];
  else
    ol_phs_deg(:,1) = ...
      [ ol_phs_deg(:,1)-360, ol_phs_deg(:,2); ...
        ol_phs_deg(:,1), ol_phs_deg(:,2); ...
        ol_phs_deg(:,1)+360, ol_phs_deg(:,2); ...
        ol_phs_deg(:,1)+2*360, ol_phs_deg(:,2) ];
  end
  
  comp_phase = ol_phs_deg(:,2);
  comp_phase = comp_phase( ~isnan(comp_phase) );
  if fig_h_ndx == 6
    min_comp_phase = min( comp_phase );
    while ( min_comp_phase - real(CurrPt) ) > 180
      ol_phs_deg(:,2) = ol_phs_deg(:,2) - 360;
      min_comp_phase = min_comp_phase - 360;
    end
    while ( min_comp_phase - real(CurrPt) ) < -180
      ol_phs_deg(:,2) = ol_phs_deg(:,2) + 360;
      min_comp_phase = min_comp_phase + 360;
    end
  elseif ( fig_h_ndx == 4 )
    med_comp_phase = median( comp_phase );
    while ( med_comp_phase - CurrCLPhs ) > 270
      ol_phs_deg(:,2) = ol_phs_deg(:,2) - 360;
      med_comp_phase = med_comp_phase - 360;
    end
    while ( med_comp_phase - CurrCLPhs ) < -270
      ol_phs_deg(:,2) = ol_phs_deg(:,2) + 360;
      med_comp_phase = med_comp_phase + 360;
    end
  elseif ( fig_h_ndx == 3 ) && ( plot_h{3}.mindist < 0.05 )
    CurrCLPhs = PZG(dom_ndx).CLBodePhs(freq_ndx);
    if plot_h{fig_h_ndx}.neg_freq
      CurrCLPhs = -CurrCLPhs;
    end
    med_comp_phase = median( comp_phase );
    while ( med_comp_phase - CurrCLPhs ) > 270
      ol_phs_deg(:,2) = ol_phs_deg(:,2) - 360;
      med_comp_phase = med_comp_phase - 360;
    end
    while ( med_comp_phase - CurrCLPhs ) < -270
      ol_phs_deg(:,2) = ol_phs_deg(:,2) + 360;
      med_comp_phase = med_comp_phase + 360;
    end
  end

  clbode_mag_h = [];
  if ~isempty(plot_h{3}) ...
    && isfield(plot_h{3},'fig_h')
    clbode_mag_h = plot_h{3}.fig_h;
  end

  clbode_phs_h = [];
  if ~isempty(plot_h{4}) ...
    && isfield(plot_h{4},'fig_h')
    clbode_phs_h = plot_h{4}.fig_h;
  end
  
  if max( get(nich_h,'color') ) < 0.5
    mag_str_color = [ 0 0.9 0.9 ];
    phs_str_color = [ 0.9 0.9 0 ];
  else
    mag_str_color = [ 0 0.7 0.7 ];
    phs_str_color = [ 0.6 0.6 0 ];
  end

  % Determine which parts of the Nichols and CL Mag plots to highlight.
  hilite_ndx = find( PZG(dom_ndx).CLBodeMag > 20*log10(abs(CLfr_pt)) );

  if ~isempty(hilite_ndx) && ~isempty(clbode_mag_h)
    mag_line_h = pzg_fndo( dom_ndx, 3,'Bode_Line');
    xdata = get( mag_line_h,'xdata');
    ydata = get( mag_line_h,'ydata');
    clbode_hilite_x = xdata(hilite_ndx);
    clbode_hilite_y = ydata(hilite_ndx);
  else
    clbode_hilite_x = [];
    clbode_hilite_y = [];
  end

  if ~isempty(hilite_ndx) && ~isempty(nich_ax_h)
    nich_line_h = pzg_fndo( dom_ndx, 6,'nicholpl_mag_phase_line');
    xdata = get( nich_line_h,'xdata');
    ydata = get( nich_line_h,'ydata');
    use_ndx = find( hilite_ndx <= numel(xdata) );
    nichol_hilite_x = xdata(hilite_ndx(use_ndx));
    nichol_hilite_y = ydata(hilite_ndx(use_ndx));
  else
    nichol_hilite_x = [];
    nichol_hilite_y = [];
  end
  
  nich_cl_track_h = pzg_fndo( dom_ndx, 6,'Nichols_CL_track_line');
  colors = [ 0 0.9 0.9; 0.9 0.9 0 ];
  if numel(nich_cl_track_h) ~= 3
    delete(nich_cl_track_h)
    nich_cl_track_h = [];
    for k = 1:2
      this_color = colors(k,:);
      this_markersize = 1;
      if k == 1
        this_vis = mag_track_vis;
        if mag_track_linewidth > 0.5
          this_markersize = 2;
        end
      else
        this_vis = phs_track_vis;
      end
      nich_cl_track_h(end+1) = ...
        plot( ol_phs_deg(:,k), ol_mag_db(:,k), ...
           'color', this_color, ...
           'linestyle','--', ...
           'linewidth', 2, ...
           'marker','none', ...
           'markersize', this_markersize, ...
           'visible', this_vis, ...
           'parent', nich_ax_h, ...
           'tag','Nichols CL track line'); %#ok<AGROW>
    end
    nich_cl_track_h(end+1) = ...
      plot( nichol_hilite_x, nichol_hilite_y, ...
         'color', 1-get(nich_ax_h,'color'), ...
         'linestyle','-', ...
         'linewidth', 2, ...
         'marker','none', ...
         'markersize', 2, ...
         'visible', himag_track_vis, ...
         'parent', nich_ax_h, ...
         'tag','Nichols CL track line');
    plot_h{6}.hndl.Nichols_CL_track_line = nich_cl_track_h(:);
    PZG(dom_ndx).plot_h{6}.hndl.Nichols_CL_track_line = nich_cl_track_h(:);
  else
    for k = 1:2
      this_color = colors(k,:);
      this_markersize = 1;
      if k == 1
        this_vis = mag_track_vis;
        if mag_track_linewidth > 0.5
          this_markersize = 2;
        end
      else
        this_vis = phs_track_vis;
      end
      set( nich_cl_track_h(k), ...
           'xdata', ol_phs_deg(:,k), ...
           'ydata', ol_mag_db(:,k), ...
           'color', this_color, ...
           'linestyle','--', ...
           'linewidth', 2, ...
           'marker','none', ...
           'markersize', this_markersize, ...
           'visible', this_vis )
    end
    set( nich_cl_track_h(3), ...
         'xdata', nichol_hilite_x, ...
         'ydata', nichol_hilite_y, ...
         'color', 1-get(nich_ax_h,'color'), ...
         'linestyle','-', ...
         'linewidth', 2, ...
         'marker','none', ...
         'markersize', 1, ...
         'visible', himag_track_vis )
  end

  % Create text for the C.L. mag and phase.
  clmag_db = 20*log10(abs(CLfr_pt));
  if abs(clmag_db) >= 0.095
    round_mag_db = round( 10*clmag_db )/10;
    cl_mag_str = [ num2str( round_mag_db, 4 ) ' dB'];
  elseif abs(clmag_db) >= 0.0095
    round_mag_db = round( 100*clmag_db )/100;
    cl_mag_str = [ num2str( round_mag_db, 5 ) ' dB'];
  elseif abs(clmag_db) >= 0.00095
    round_mag_db = round( 1000*clmag_db )/1000;
    cl_mag_str = [ num2str( round_mag_db, 6 ) ' dB'];
  elseif abs(clmag_db) >= 0.000095
    round_mag_db = round( 10000*clmag_db )/10000;
    cl_mag_str = [ num2str( round_mag_db, 7 ) ' dB'];
  elseif abs(clmag_db) >= 0.0000095
    round_mag_db = round( 100000*clmag_db )/100000;
    digit_str = num2str( abs(round( 100000*clmag_db )) );
    if clmag_db < 0
      cl_mag_str = [ '-0.0000' digit_str ' dB'];
    else
      cl_mag_str = [ '0.0000' digit_str ' dB'];
    end
  elseif abs(clmag_db) >= 0.00000095
    round_mag_db = round( 1000000*clmag_db )/1000000;
    digit_str = num2str( abs(round( 1000000*clmag_db )) );
    if clmag_db < 0
      cl_mag_str = [ '-0.00000' digit_str ' dB'];
    else
      cl_mag_str = [ '0.00000' digit_str ' dB'];
    end
  else
    round_mag_db = 0;
    cl_mag_str = '0 dB';
  end

  phs_angle_deg = 180/pi*angle(CLfr_pt);
  if phs_angle_deg > 0
    phs_angle_deg = phs_angle_deg - 360;
  end
  if ( abs(phs_angle_deg) > 0.095 ) ...
    &&( abs(phs_angle_deg) < 359.905 )
    phs_angle_deg = round( 10*phs_angle_deg )/10;
    cl_phs_str = [ num2str( phs_angle_deg, 4 ) '^o'];
  elseif ( abs(phs_angle_deg) > 0.0095 ) ...
    &&( abs(phs_angle_deg) < 359.9905 )
    phs_angle_deg = round( 100*phs_angle_deg )/100;
    cl_phs_str = [ num2str( phs_angle_deg, 5 ) '^o'];
  elseif ( abs(phs_angle_deg) > 0.00095 ) ...
    &&( abs(phs_angle_deg) < 359.99905 )
    phs_angle_deg = round( 1000*phs_angle_deg )/1000;
    cl_phs_str = [ num2str( phs_angle_deg, 6 ) '^o'];
  elseif ( abs(phs_angle_deg) > 0.000095 ) ...
    &&( abs(phs_angle_deg) < 359.999905 )
    phs_angle_deg = round( 10000*phs_angle_deg )/10000;
    cl_phs_str = [ num2str( phs_angle_deg, 7 ) '^o'];
  else
    phs_angle_deg = round( phs_angle_deg );
    cl_phs_str = [ num2str( phs_angle_deg, 4 ) '^o'];
  end
  
  mid_x = median(x_lim);
  mid_y = median(y_lim);

  del_x = 0.1 * diff(x_lim);
  del_y = 0.1 * diff(y_lim);
  if fig_h_ndx == 6
    CurrNichPt = CurrPt;
  elseif fig_h_ndx == 3
    mid_x = median(x_lim);
    mid_y = max( ol_mag_db(:,1) ) + del_y/2;
    mid_y = min( mid_y, y_lim(2)-del_y );
    CurrNichPt = mid_x + 1i*mid_y;
  else
    mid_x = median( ol_mag_db(:,2) );
    mid_y = max( ol_mag_db(:,2) ) + 2*del_y;
    mid_y = min( mid_y, y_lim(2)-del_y );
    CurrNichPt = mid_x + 1i*mid_y;
  end
  if round_mag_db > 0
    if ( phs_angle_deg > -180 ) && ( phs_angle_deg < -0 )
      mag_xloc = max( x_lim(1), real(CurrNichPt) - del_x );
      mag_yloc = min( y_lim(2), imag(CurrNichPt) + del_y );
      phs_xloc = ...
        max( x_lim(1), ...
             min( real(CurrNichPt)-del_x, ( -180*0.3+real(CurrNichPt)*0.7 ) ) );
      phs_yloc = max( y_lim(1), imag(CurrNichPt) - del_y );
    elseif imag(CurrNichPt) > 0
      mag_xloc = max( x_lim(1), real(CurrNichPt) - del_x );
      mag_yloc = max( y_lim(1), imag(CurrNichPt) - del_y );
      phs_xloc = max( x_lim(1), real(CurrNichPt) - del_x );
      phs_yloc = min( y_lim(2)-del_y, imag(CurrNichPt) + del_y );
    else
      phs_xloc = max( x_lim(1), real(CurrNichPt) - del_x );
      phs_yloc = max( y_lim(1), imag(CurrNichPt) - del_y );
      mag_xloc = max( x_lim(1), real(CurrNichPt) - del_x );
      mag_yloc = min( y_lim(2)-del_y, imag(CurrNichPt) );
    end
  elseif ( real(CurrNichPt) < mid_x ) && ( imag(CurrNichPt) < mid_y )
    % 3rd quadrant
    mag_xloc = max( x_lim(1), real(CurrNichPt) - del_x );
    mag_yloc = imag(CurrNichPt) + del_y;
    phs_xloc = real(CurrNichPt) + del_x/3;
    phs_yloc = max( y_lim(1), imag(CurrNichPt) - del_y );
  elseif ( real(CurrNichPt) > mid_x ) && ( imag(CurrNichPt) > mid_y )
    % 1st quadrant
    mag_xloc = min( x_lim(2)-del_x/2, real(CurrNichPt) + del_x );
    mag_yloc = min( y_lim(2), imag(CurrNichPt) + del_y );
    phs_xloc = min( x_lim(2)-del_x/2, real(CurrNichPt) + del_x/3 );
    phs_yloc = imag(CurrNichPt) - del_y;
  elseif ( real(CurrNichPt) > mid_x ) && ( imag(CurrNichPt) < mid_y )
    % 4th quadrant
    mag_xloc = min( x_lim(2)-del_x/2, real(CurrNichPt) + del_x/3 );
    mag_yloc = imag(CurrNichPt) + del_y;
    phs_xloc = min( x_lim(2)-del_x/2, real(CurrNichPt) + del_x/3 );
    phs_yloc = max( y_lim(1), imag(CurrNichPt) - del_y );
  elseif ( real(CurrNichPt) < mid_x ) && ( imag(CurrNichPt) > mid_y )
    % 2nd quadrant
    mag_xloc = max( x_lim(1), real(CurrNichPt) - del_x );
    mag_yloc = min( y_lim(2), imag(CurrNichPt) + del_y );
    phs_xloc = max( x_lim(1), real(CurrNichPt) - del_x );
    phs_yloc = imag(CurrNichPt) - del_y;
  else
    % u quadrant
    mag_xloc = real(CurrNichPt) - del_x;
    mag_yloc = imag(CurrNichPt) + del_y;
    phs_xloc = real(CurrNichPt) + del_x/3;
    phs_yloc = imag(CurrNichPt) - del_y;
  end
  mag_text_vis = mag_track_vis;
  phs_text_vis = phs_track_vis;
  if fig_h_ndx == 3
    if max(ol_mag_db(:,1)) < y_lim(1)
      mag_text_vis = 'off';
    end
    %mag_yloc = max( min(ol_mag_db(:,1))-del_y, y_lim(1) );
  elseif fig_h_ndx == 4
    phs_xloc = CurrCLPhs;
    if ( CurrCLPhs < x_lim(1) ) || ( CurrCLPhs > x_lim(2) )
      phs_text_vis = 'off';
    end
  end
  
  nich_cl_text_h = pzg_fndo( dom_ndx, 6,'Nichols_CL_track_text');
  if ~isequal( 2, numel(nich_cl_text_h) )
    delete(nich_cl_text_h);
    nich_cl_text_h = ...
      text( mag_xloc, mag_yloc, cl_mag_str, ...
         'parent', nich_ax_h, ...
         'color', mag_str_color, ...
         'fontweight','bold', ...
         'fontsize', 12, ...
         'visible', mag_text_vis, ...
         'tag','Nichols CL track text');
  else
    set( nich_cl_text_h(1), ...
        'position',[mag_xloc mag_yloc 0], ...
        'string', cl_mag_str, ...
        'color', mag_str_color, ...
        'fontweight','bold', ...
        'fontsize', 12, ...
        'visible', mag_text_vis );
  end
  if ~isequal( 2, numel(nich_cl_text_h) )
    nich_cl_text_h(2) = ...
      text( phs_xloc, phs_yloc, cl_phs_str, ...
         'parent', nich_ax_h, ...
         'color', phs_str_color, ...
         'fontweight','bold', ...
         'fontsize', 12, ...
         'visible', phs_text_vis, ...
         'tag','Nichols CL track text');
    plot_h{6}.hndl.Nichols_CL_track_text = nich_cl_text_h(:);
    PZG(dom_ndx).plot_h{6}.hndl.Nichols_CL_track_text = nich_cl_text_h(:);
  else
    set( nich_cl_text_h(2), ...
        'position',[phs_xloc phs_yloc 0], ...
        'string', cl_phs_str, ...
        'color', phs_str_color, ...
        'fontweight','bold', ...
        'fontsize', 12, ...
        'visible', phs_text_vis );
  end

  % Highlight the corresponding lines in the closed-loop bode plots.
  if ~isempty(clbode_mag_h)
    CLmag_db = 20*log10(abs(CLfr_pt));
    clbode_mag_ax_h = plot_h{3}.ax_h;
    xlims = plot_h{3}.xlim;
    ylims = plot_h{3}.ylim;
    nich_mag_h = pzg_fndo( dom_ndx, 3,'Nichols_CL_track_line');
    nich_mag_text_h =  pzg_fndo( dom_ndx, 3,'Nichols_CL_track_text');
    
    % Check whether any part of the highlight is visible in the plot.
    if ( CLmag_db > ylims(2) ) ...
      || ( CLmag_db < ylims(1) ) ...
      ||( ( fig_h_ndx == 4 ) && ( plot_h{fig_h_ndx}.mindist > 0.05 ) )
      if ~isempty(nich_mag_h)
        set( nich_mag_h,'visible','off')
      end
      if ~isempty(nich_mag_text_h) 
        set( nich_mag_text_h,'visible','off')
      end
    else
      if ~isequal( numel(nich_mag_h), 2 ) ...
        || ~isequal( 2, sum( ishandle(nich_mag_h) ) )
        delete(nich_mag_h)
        nich_mag_h = ...
          [ plot( xlims, ones(size(xlims))*CLmag_db, ...
              'color',[0 0.9 0.9], ...
              'linestyle','--', ...
              'linewidth', 2, ...
              'marker','none', ...
              'markersize', 2, ...
              'visible', mag_track_vis, ...
              'parent', clbode_mag_ax_h, ...
              'tag','Nichols CL track line'); ...
            plot( clbode_hilite_x, clbode_hilite_y, ...
              'color', 1-get(clbode_mag_ax_h,'color'), ...
              'linestyle','-', ...
              'linewidth', 2, ...
              'marker','none', ...
              'markersize', 2, ...
              'visible', mag_track_vis, ...
              'parent', clbode_mag_ax_h, ...
              'tag','Nichols CL track line') ];
        PZG(dom_ndx).plot_h{3}.hndl.Nichols_CL_track_line = nich_mag_h;
        %plot_h{3}.hndl.Nichols_CL_track_line = nich_mag_h;
      else
        set( nich_mag_h(1), ...
            'xdata', xlims, ...
            'ydata', ones(size(xlims))*CLmag_db, ...
            'color',[0 0.9 0.9], ...
            'visible', mag_track_vis );
        set( nich_mag_h(2), ...
            'xdata', clbode_hilite_x, ...
            'ydata', clbode_hilite_y, ...
            'color', 1-get(clbode_mag_ax_h,'color'), ...
            'visible', mag_track_vis )
      end
      
      if numel(nich_mag_text_h) > 1
        delete(nich_mag_text_h)
        nich_mag_text_h = [];
      end
      if strcmpi( get( clbode_mag_ax_h,'xscale'),'log')
        xloc = xlims(1) * ( xlims(2)/xlims(1) )^0.1;
      else
        xloc = mean(xlims);
      end
      yloc = CLmag_db;
      if yloc < ylims(1)+0.5*diff(ylims)
        yloc = yloc + 0.05*diff(ylims);
      else
        yloc = yloc - 0.05*diff(ylims);
      end
      %hi_contrast_color = 1 - get(clbode_mag_ax_h,'color');
      if ~isequal( 1, numel(nich_mag_text_h) )
        nich_mag_text_h = ...
          text( xloc, yloc, cl_mag_str, ...
             'parent', clbode_mag_ax_h, ...
             'color', [0 0.9 0.9], ...
             'fontsize', 12, ...
             'fontweight','bold', ...
             'visible', mag_track_vis, ...
             'tag','Nichols CL track text');
        %plot_h{3}.hndl.Nichols_CL_track_text = nich_mag_text_h;
        PZG(dom_ndx).plot_h{3}.hndl.Nichols_CL_track_text = nich_mag_text_h;
      else
        set( nich_mag_text_h, ...
            'position',[xloc yloc 0], ...
            'string', cl_mag_str, ...
            'color', [0 0.9 0.9], ...
            'fontsize', 12, ...
            'fontweight','bold', ...
            'visible', mag_track_vis );
      end
    end
  end
  
  if ~isempty(clbode_phs_h)
    nich_phs_h = pzg_fndo( dom_ndx, 4,'Nichols_CL_track_line');
    nich_phs_text_h = pzg_fndo( dom_ndx, 4,'Nichols_CL_track_text');
    unwrap_value = plot_h{4}.unwrap_cb;
    if fig_h_ndx == 4
      CLplot_phs_deg = CurrCLPhs;
      if ~unwrap_value && ( plot_h{fig_h_ndx}.mindist < 0.05 )
        while( CLplot_phs_deg > 180 )
          CLplot_phs_deg = CLplot_phs_deg - 360;
        end
        while( CLplot_phs_deg < -180 )
          CLplot_phs_deg = CLplot_phs_deg + 360;
        end
      end
    elseif plot_h{fig_h_ndx}.mindist > 0.05
      if fig_h_ndx == 3
        CLplot_phs_deg = [];
        if ~isempty(nich_phs_h) || ~isempty(nich_phs_text_h)
          set([nich_phs_h;nich_phs_text_h],'visible','off')
        end
      else
        CLplot_phs_deg = 180/pi*angle(CLfr_pt);
      end
    else
      CLplot_phs_deg = PZG(dom_ndx).CLBodePhs(freq_ndx);
      if plot_h{fig_h_ndx}.neg_freq
        CLplot_phs_deg = -CLplot_phs_deg;
      end
    end
    if ~isempty(CLplot_phs_deg)
      if ( fig_h_ndx ~= 4 )
        if ~unwrap_value
          while( CLplot_phs_deg > 180 )
            CLplot_phs_deg = CLplot_phs_deg - 360;
          end
          while( CLplot_phs_deg < -180 )
            CLplot_phs_deg = CLplot_phs_deg + 360;
          end
        end
      end
      if isempty(cl_phs_str)
        cl_phs_text_str = [ local_tenths_str( CLplot_phs_deg ) '^o'];
      else
        cl_phs_text_str = cl_phs_str;
      end
      clbode_phs_ax_h = plot_h{4}.ax_h;
      xlims = plot_h{4}.xlim;
      ylims = plot_h{4}.ylim;
      if ( numel(xlims) ~= 2 ) || ( numel(ylims) ~= 2 )
        return
      end
      if ( CLplot_phs_deg > ylims(2) ) ...
        || ( CLplot_phs_deg < ylims(1) )
        if ~isempty(nich_phs_h) || ~isempty(nich_phs_text_h)
          set([nich_phs_h;nich_phs_text_h],'visible','off')
        end
      else
        if ~isequal( numel(nich_phs_h), 1 ) ...
          || ~isequal( sum(ishandle(nich_phs_h)), 1 )
          delete(nich_phs_h)
          nich_phs_h = ...
            plot( xlims, ones(size(xlims))*CLplot_phs_deg, ...
               'color',[0.9 0.9 0], ...
               'linestyle','--', ...
               'linewidth', 2, ...
               'visible', phs_track_vis, ...
               'parent', clbode_phs_ax_h, ...
               'tag','Nichols CL track line');
          %plot_h{4}.hndl.Nichols_CL_track_line = nich_phs_h;
          PZG(dom_ndx).plot_h{4}.hndl.Nichols_CL_track_line = nich_phs_h;
        else
          set( nich_phs_h, ...
              'xdata', xlims, ...
              'ydata', ones(size(xlims))*CLplot_phs_deg, ...
              'color',[0.9 0.9 0], ...
              'linestyle','--', ...
              'linewidth', 2, ...
              'visible', phs_track_vis );
        end

        if ~isequal( numel(nich_phs_text_h), 1 )
          delete(nich_phs_text_h)
          nich_phs_text_h = [];
        end
        if plot_h{4}.Log_cb
          xloc = xlims(1) * ( xlims(2)/xlims(1) )^0.1;
        else
          xloc = mean(xlims);
        end
        yloc = CLplot_phs_deg;
        if yloc < ylims(1)+0.5*diff(ylims)
          yloc = yloc + 0.07*diff(ylims);
        else
          yloc = yloc - 0.05*diff(ylims);
        end
        if isempty(nich_phs_text_h)
          %hi_contrast_color = 1 - get(clbode_phs_ax_h,'color');
          nich_phs_text_h = ...
            text( xloc, yloc, cl_phs_text_str, ...
               'parent', clbode_phs_ax_h, ...
               'color', [0.9 0.9 0], ...
               'fontsize', 12, ...
               'fontweight','bold', ...
               'visible', phs_track_vis, ...
               'tag','Nichols CL track text');
          %plot_h{4}.hndl.Nichols_CL_track_text = nich_phs_text_h;
          PZG(dom_ndx).plot_h{4}.hndl.Nichols_CL_track_text = nich_phs_text_h;
        else
          set( nich_phs_text_h, ...
              'position',[xloc yloc 0], ...
              'string', cl_phs_text_str, ...
              'color', [0.9 0.9 0], ...
              'fontsize', 12, ...
              'fontweight','bold', ...
              'visible', phs_track_vis );
        end
      end
    else
      if ~isempty(nich_phs_h) && ~isempty(nich_phs_text_h)
        set( [ nich_phs_h; nich_phs_text_h ],'visible','off')
      end
    end
  end

return

function  local_run_nyquist_movie
  
  global PZG
  
  if isempty(gcbf)
    return
  end
  if ~isempty( strfind( get(gcbf,'name'),'iscrete') )
    dom_ndx = 2;
  else
    dom_ndx = 1;
  end
  
  init_cntr_data = PZG(dom_ndx).cntr_data;
  inf_ndxs = find( isinf(init_cntr_data.Nichols_mag) );
  for ki = 1:numel(inf_ndxs)
    this_inf_ndx = inf_ndxs(ki);
    if this_inf_ndx == 1
      init_cntr_data.Nichols_mag(1) = init_cntr_data.Nichols_mag(2);
    else
      init_cntr_data.Nichols_mag(this_inf_ndx) = ...
        init_cntr_data.Nichols_mag(this_inf_ndx-1);
    end
  end
  
  plot_h = local_get_pzg_fig_data( dom_ndx, gcbf );
  
  % Identify crucial indexes.
  % Compute the delta phase and delta magnitude.
  % delta_mag = abs( diff(log(init_cntr_data.Nichols_mag)) );
  % delta_mag = delta_mag/max( 1, max(delta_mag) );
  % delta_phs = abs( diff(init_cntr_data.Nichols_phs) );
  % delta_phs = delta_phs/max( 1, max(delta_phs) );
  % delta_mp = max( delta_mag, delta_phs/2 );
  %incl_ndx = zeros(size(delta_mp));
  %incl_ndx( ( delta_mp > 0.01 ) & ( delta_phs > 1e-12 ) ) = 1;
  %hit_ndxs = find( incl_ndx == 1 );
  hit_ndxs = (1:25:numel(init_cntr_data.Nichols_mag))';
  hit_ndxs(end+1) = numel(init_cntr_data.Nichols_mag);
  
  inffreq_ndxs = find( isinf(init_cntr_data.contour_freq) );
  if isempty(inffreq_ndxs)
    finitefreq_hit_ndxs = hit_ndxs;
    infinitefreq_hit_ndxs = [];
  else
    lf_ndxs = find( hit_ndxs < inffreq_ndxs(1) );
    finitefreq_hit_ndxs = hit_ndxs(lf_ndxs);         %#ok<FNDSB>
    inf_ndxs = find( hit_ndxs >= inffreq_ndxs(1) );
    infinitefreq_hit_ndxs = hit_ndxs(inf_ndxs);      %#ok<FNDSB>
  end
  if ~isempty(infinitefreq_hit_ndxs) ...
    && ( infinitefreq_hit_ndxs(end) == numel(init_cntr_data.contour_freq) )
    infinitefreq_hit_ndxs(end) = [];
  end
  if finitefreq_hit_ndxs(end) == numel(init_cntr_data.contour_freq)
    finitefreq_hit_ndxs(end) = [];
  end
  
  if dom_ndx == 1
    freqrange_str = ...
      inputdlg('Enter the frequency range (in Hz) for the "movie":', ...
               'Enter the Frequency Range', 1, {'         -Inf   Inf'} );
  else
    freqrange_str = ...
      inputdlg('Enter the frequency range (in Hz) for the "movie":', ...
               'Enter the Frequency Range', 1, ...
               {['        ' num2str(-0.5/PZG(2).Ts) ...
                 '   '  num2str(0.5/PZG(2).Ts) ]} );
  end
  if isempty(freqrange_str)
    return
  end
  freqrange = str2num( freqrange_str{1} ); %#ok<ST2NM>
  if ( numel(freqrange) == 1 ) && isreal(freqrange)
    freqrange = freqrange * [ 1 1 ];
  elseif ( numel(freqrange) ~= 2 ) || any( ~isreal(freqrange) )
    errdlg_h = ...
      errordlg( ...
        {'The frequency range cannot be more than two real numbers.'; ...
         ' ';'    Click "OK" to continue ...';' '}, ...
        [mfilename ' Error'],'modal');
    uiwait(errdlg_h)
    return
  elseif ( dom_ndx == 2 ) && any( abs(freqrange) > 0.5/PZG(2).Ts )
    errdlg_h = ...
      errordlg( ...
        {'Neither frequency may exceed the half-sample frequency,'; ...
         ['which is ' num2str( 0.5/PZG(2).Ts ) ' (Hz).']; ...
         ' ';'    Click "OK" to continue ...';' '}, ...
        [mfilename ' Error'],'modal');
    uiwait(errdlg_h)
    return
  end
  
  if ~isempty(plot_h{14}) && isfield(plot_h{14},'fig_h')
    stop_h = plot_h{14}.hndl.nyq_stop_movie_pushbutton;
    if ~isempty(stop_h)
      set( stop_h,'visible','on')
    end
  else
    return
  end
  
  freqrange = 2*pi*freqrange;
  
  indexes = cell(6,1);
  if isinf(freqrange(1)) && isinf( freqrange(2))
    % The full movie.
    indexes{1} = -flipud( finitefreq_hit_ndxs );
    indexes{2} = finitefreq_hit_ndxs;
    indexes{3} = infinitefreq_hit_ndxs;
    indexes{4} = -flipud( infinitefreq_hit_ndxs );
  elseif ~freqrange(1) && ~freqrange(2)
    % The full movie, but starting and ending at zero freq.
    indexes{1} = finitefreq_hit_ndxs;
    indexes{2} = infinitefreq_hit_ndxs;
    indexes{3} = -flipud( infinitefreq_hit_ndxs );
    indexes{4} = -flipud( finitefreq_hit_ndxs );
  elseif ( freqrange(1) == freqrange(2) ) ...
    && ( freqrange(1) > 0 )
    % Get the start index.
    start_ndx = ...
      pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
               freqrange(1),'near');
    indexes{1} = finitefreq_hit_ndxs(start_ndx:end);
    indexes{2} = infinitefreq_hit_ndxs;
    indexes{3} = -flipud( infinitefreq_hit_ndxs );
    indexes{4} = -flipud( finitefreq_hit_ndxs );
    indexes{5} = finitefreq_hit_ndxs(1:start_ndx);
    
  elseif ( freqrange(1) == freqrange(2) ) ...
    && ( freqrange(1) < 0 )
    % Get the start index.
    start_ndx = ...
      pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
               abs(freqrange(1)),'near');
    indexes{1} = -flipud( finitefreq_hit_ndxs(1:start_ndx) );
    indexes{2} = finitefreq_hit_ndxs;
    indexes{3} = infinitefreq_hit_ndxs;
    indexes{4} = -flipud( infinitefreq_hit_ndxs );
    indexes{5} = -flipud( finitefreq_hit_ndxs(start_ndx:end) );
    
  elseif isinf( freqrange(1) ) && ~isinf( freqrange(2) )
    if freqrange(1) < 0
      % From -j\infty to a finite freq.
      if freqrange(2) <= 0
        % Only up to a neg finite freq.
        ndx1 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                       -freqrange(2),'near');
        indexes{1} = -flipud( finitefreq_hit_ndxs(ndx1:end) );
      else
        % Up thru the negs, to a positive finite freq.
        indexes{1} = -flipud( finitefreq_hit_ndxs );
        ndx2 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                        freqrange(2),'near');
        indexes{2} = finitefreq_hit_ndxs(1:ndx2);
      end
    else
      % From +j\infty around the inf-radius RHP, then up to a finite freq.
      indexes{3} = infinitefreq_hit_ndxs;
      indexes{4} = -flipud( infinitefreq_hit_ndxs );
      if freqrange(2) < 0
        % Up to a negative finite freq.
        ndx1 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                       -freqrange(2),'near');
        indexes{5} = -flipud( finitefreq_hit_ndxs(ndx1:end) );
      else
        % Up thru the negs, to a positive finite freq.
        indexes{5} = -flipud( finitefreq_hit_ndxs );
        ndx2 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                        freqrange(2),'near');
        indexes{6} = finitefreq_hit_ndxs(1:ndx2);
      end
    end
  elseif ~isinf( freqrange(1) ) && isinf( freqrange(2) )
    if freqrange(1) < 0
      % Starting at a neg finite freq.
      ndx2 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                     -freqrange(1),'near');
      indexes{1} = -flipud( finitefreq_hit_ndxs(1:ndx2) );
      indexes{2} = finitefreq_hit_ndxs;
    else
      % Starting at a pos finite freq.
      ndx1 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                      freqrange(1),'near');
      indexes{2} = finitefreq_hit_ndxs(ndx1:end);
    end
    if freqrange(2) < 0
      % Ending at -j\infty, must go around the RHP semicirc
      indexes{3} = infinitefreq_hit_ndxs;
      indexes{4} = -flipud( infinitefreq_hit_ndxs );
    end
  else
    % Two finite frequencies.
    if ( freqrange(1) < 0 ) && ( freqrange(2) <= 0 )
      % From a finite neg to another finite neg.
      freqrange = sort(freqrange);
      ndx1 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                     -freqrange(2),'near');
      ndx2 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                     -freqrange(1),'near');
      indexes{1} = -flipud( finitefreq_hit_ndxs(ndx1:ndx2) );
    elseif ( freqrange(1) >= 0 ) && ( freqrange(2) > 0 )
      % From a finite pos to another finite pos.
      freqrange = sort(freqrange);
      ndx1 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                      freqrange(1),'near');
      ndx2 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                      freqrange(2),'near');
      indexes{2} = finitefreq_hit_ndxs(ndx1:ndx2);
    elseif ( freqrange(1) < 0 ) && ( freqrange(2) > 0 )
      % From a finite neg to a finite pos.
      ndx2 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                     -freqrange(1),'near');
      indexes{1} = -flipud( finitefreq_hit_ndxs(1:ndx2) );
      ndx2 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                      freqrange(2),'near');
      indexes{2} = finitefreq_hit_ndxs(1:ndx2);
    elseif ( freqrange(1) >= 0 ) && ( freqrange(2) <= 0 )
      % Start a pos-finite, around the \infty RHP, up to a neg-finite 
      ndx1 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                      freqrange(1),'near');
      indexes{2} = finitefreq_hit_ndxs(ndx1:end);
      indexes{3} = infinitefreq_hit_ndxs;
      indexes{4} = -flipud( infinitefreq_hit_ndxs );
      ndx1 = pzg_gle( init_cntr_data.contour_freq(finitefreq_hit_ndxs), ...
                     -freqrange(2),'near');
      indexes{5} = -flipud( finitefreq_hit_ndxs(ndx1:end) );
    end
  end
  
  for k = 1:numel(indexes)
    while numel(indexes{k}) > 1500
      indexes{k} = [ indexes{k}(1:2:end-1); indexes{k}(end) ];
    end
  end
  
  PZG(dom_ndx).stop_movie = 0;
  
  for kcell = 1:numel(indexes)
    if isempty(indexes{kcell})
      continue
    end
    cntr_fig_h = pzg_fndo( dom_ndx, 14,'fig_h');
    if isempty(cntr_fig_h) ...
      ||~isequal( numel(init_cntr_data.contour_pts), ...
                  numel(PZG(dom_ndx).cntr_data.contour_pts) ) ...
      ||~isequal( numel(init_cntr_data.ld_poles), ...
                  numel(PZG(dom_ndx).cntr_data.ld_poles) ) ...
      ||~isequal( numel(init_cntr_data.ld_zeros), ...
                  numel(PZG(dom_ndx).cntr_data.ld_zeros) ) ...
      ||~isequal( init_cntr_data.ld_pole_rep, ...
                  PZG(dom_ndx).cntr_data.ld_pole_rep ) ...
      ||~isequal( init_cntr_data.ld_zero_rep, ...
                  PZG(dom_ndx).cntr_data.ld_zero_rep )
      break
    end
    if isempty( plot_h{14} )
      break
    end
    if isempty( plot_h{7} )
      break
    end
    
    neg_freq = 0;
    these_ndxs = indexes{kcell};
    if these_ndxs(1) < 0
      neg_freq = 1;
      these_ndxs = abs(these_ndxs);
    end
    % Extend x-axis and y-axis highlights.
    set( plot_h{14}.ax_h,'xlimmode','manual','ylimmode','manual');
    cntr_h = pzg_fndo( dom_ndx, 14,'nyq_contour_all_parts');
    x_hilite_h = pzg_fndo( dom_ndx, 14,'nyq_contour_xaxis_hilite');
    y_hilite_h = pzg_fndo( dom_ndx, 14,'nyq_contour_yaxis_hilite');
    if dom_ndx == 1
      max_cntr_val = ...
        max( max( abs(get(cntr_h,'xdata')) ), max( abs(get(cntr_h,'ydata')) ) );
      set( x_hilite_h, ...
          'xdata', 1.25*max_cntr_val*[-0.1; 1],'ydata', [0;0] );
      set( y_hilite_h, ...
          'xdata', [0; 0],'ydata', 1.25*max_cntr_val*[-1; 1] );
    else
      set( x_hilite_h, ...
          'xdata', [-1.5; 1.5],'ydata', [0;0] );
      set( y_hilite_h, ...
          'xdata', [0; 0],'ydata', [-1.5; 1.5] );
    end
    
    zoom_contour = 0;
    if ( dom_ndx == 1 ) ...
      &&( ~isempty(PZG(dom_ndx).cntr_data.ld_poles) ...
         ||~isempty(PZG(dom_ndx).cntr_data.ld_zeros) )
      zoom_contour = 1;
    end
    for kn = 1:numel(these_ndxs)
      [ plot_h, curr_ploth_ndx ] = local_get_pzg_fig_data( dom_ndx, gcbf );
      if PZG(dom_ndx).stop_movie
        stop_h = pzg_fndo( dom_ndx, 14,'nyq_stop_movie_pushbutton');
        if ~isempty(stop_h)
          set( stop_h,'visible','off')
        end
        local_all_cursor_hilites_off( plot_h, curr_ploth_ndx, dom_ndx )
        return
      end
      nyqdata_ndx = these_ndxs(kn);
      plot_h{14}.nyqdata_ndx = nyqdata_ndx;
      plot_h{14}.neg_freq = neg_freq;
      plot_h{14}.CurrPt = init_cntr_data.upper_pseudo_cntr(nyqdata_ndx);
      if neg_freq
        plot_h{14}.CurrPt = conj(plot_h{14}.CurrPt);
      end
      
      % Now adjust the Nyquist-mapping scale.
      if plot_h{7}.hybrid_scaling_cb
        nyq_pt = PZG(dom_ndx).cntr_data.Nyquist_scaled_pts(nyqdata_ndx);
      else
        nyq_pt = PZG(dom_ndx).cntr_data.Nyquist_pts(nyqdata_ndx);
      end
      new_xlim = plot_h{7}.xlim;
      new_ylim = plot_h{7}.ylim;
      if ( abs(nyq_pt) > 1.2*max(abs(new_xlim)) ) ...
        ||( abs(nyq_pt) < 1.1*max(abs(new_xlim)) ) ...
        ||( abs(nyq_pt) > 1.2*min(abs(new_ylim)) ) ...
        ||( abs(nyq_pt) < 1.1*min(abs(new_ylim)) )
        if max(new_xlim) > 1.25*abs(nyq_pt)
          new_xlim = ...
            0.75*new_xlim ...
            + 0.25*max( 0.8, 1.25*abs(nyq_pt) )* [ -1 1 ];
        else
          new_xlim = max( 0.8, 1.25*abs(nyq_pt) )* [ -1 1 ];
        end
        new_ylim = new_xlim;
        set( plot_h{7}.ax_h,'xlim', new_xlim,'ylim', new_ylim )
        plot_h{7}.xlim = new_xlim;
        plot_h{7}.ylim = new_ylim;
        PZG(dom_ndx).plot_h{7}.xlim = new_xlim;
        PZG(dom_ndx).plot_h{7}.ylim = new_ylim;
        PZG(dom_ndx).plot_h{7}.hndl.ax_xlim = new_xlim;
        PZG(dom_ndx).plot_h{7}.hndl.ax_ylim = new_ylim;
        drawnow
      end      
      
      min_ydist = 1.6;
      if zoom_contour
        new_xlim = plot_h{14}.xlim;
        new_ylim = plot_h{14}.ylim;
        if ( abs(plot_h{14}.CurrPt) > 1.2*max(abs(new_xlim)) ) ...
          ||( abs(plot_h{14}.CurrPt) < 1.1*max(abs(new_xlim)) ) ...
          ||( abs(plot_h{14}.CurrPt) > 1.2*min(abs(new_ylim)) ) ...
          ||( abs(plot_h{14}.CurrPt) < 1.1*min(abs(new_ylim)) ) ...
          ||( ( dom_ndx == 1 ) ...
             && any( abs( abs(imag(plot_h{14}.CurrPt)) - abs(new_ylim) ) ...
                    < min_ydist ) ) 
          if dom_ndx == 1
            if abs(real(plot_h{14}.CurrPt)) < 2.5
              if max(new_xlim) > 1.05*abs(plot_h{14}.CurrPt)
                new_xlim = ...
                  0.75*new_xlim ...
                  +0.25*max( 2.5, 1.05*abs(plot_h{14}.CurrPt) ) * [ -0.10 0.5 ];
              else
                new_xlim = ...
                  max( 2.5, 1.05*abs(plot_h{14}.CurrPt) ) * [ -0.10 0.5 ];
              end
            else
              if max(new_xlim) > 1.05*abs(plot_h{14}.CurrPt)
                new_xlim = ...
                  0.95*new_xlim ...
                  +0.05*max( 1.25, 1.05*abs(plot_h{14}.CurrPt) ) * [ -0.20 1.0 ];
              else
                new_xlim = ...
                  max( 1.25, 1.05*abs(plot_h{14}.CurrPt) ) * [ -0.20 1.0 ];
              end
            end
            if max(new_ylim) > max(new_xlim)
              new_ylim = 0.75*new_ylim + 0.25*new_xlim(2) * [ -1 1 ];
            else
              new_ylim = new_xlim(2) * [ -1 1 ];
            end
            if ( imag(plot_h{14}.CurrPt) < 0 ) ...
              &&( abs(real(plot_h{14}.CurrPt)) < 1.1 )
              new_ylim(1) = min( new_ylim(1), imag(plot_h{14}.CurrPt)-1.6 );
              new_ylim(2) = min( new_ylim(2), plot_h{14}.ylim(2) );
              if ( abs(new_ylim(2)) > min_ydist ) && ( kn > 1 )
                new_ylim(2) = max( min_ydist, 0.99 * abs(new_ylim(2)) );
              else
                new_ylim(2) = ...
                  min( 0.75*abs(new_ylim(1)), 1.01 * plot_h{14}.ylim(2) );
              end
              new_ylim(2) = max( new_ylim(2), new_ylim(1)+min_ydist );
            elseif ( imag(plot_h{14}.CurrPt) > 0 ) ...
              &&( abs(real(plot_h{14}.CurrPt)) < 1.1 )
              new_ylim(2) = min( new_ylim(2), imag(plot_h{14}.CurrPt)+1.6 );
              new_ylim(1) = max( -abs(new_ylim(2)), -abs(plot_h{14}.ylim(1)) );
              if ( new_ylim(1) < -min_ydist ) && ( kn > 1 )
                new_ylim(1) = min( -min_ydist, 0.99 * plot_h{14}.ylim(1) );
              else
                new_ylim(1) = ...
                  max( -abs(new_ylim(2)), 1.01 * plot_h{14}.ylim(1) );
              end
              new_ylim(1) = min( new_ylim(1), new_ylim(2)-min_ydist );
            end
            new_ylim(1) = min( new_ylim(1), imag(plot_h{14}.CurrPt)-min_ydist );
            new_ylim(2) = max( new_ylim(2), imag(plot_h{14}.CurrPt)+min_ydist );
            
            if abs(real(plot_h{14}.CurrPt)) > 1.1   
              if abs(new_ylim(1)) < abs(plot_h{14}.CurrPt)
                new_ylim(1) = -1.01*abs(new_ylim(1));
              end
              if abs(new_ylim(2)) < abs(plot_h{14}.CurrPt)
                new_ylim(2) = 1.01*abs(new_ylim(2));
              end
              if new_xlim(2) < abs(plot_h{14}.CurrPt)
                new_xlim = 1.01*new_xlim;
              end
            end
            
            % If any rep-text, adjust its position.
            pzg_reptxt( dom_ndx, new_xlim, new_ylim );

            text_h = pzg_fndo( dom_ndx, 14,'contour_rep_text');
            for ktx = 1:numel(text_h)
              txt_pos = get( text_h(ktx),'position');
              txt_pos(1) = -0.15*diff(plot_h{14}.xlim);
              set( text_h(ktx),'position', txt_pos,'visible','on');
            end
          else
            new_xlim = 1.25*abs(real(plot_h{14}.CurrPt)) * [ -1 1 ];
            new_ylim = new_xlim(2)*[-1 1];
          end
        end
        if ~isequal( plot_h{14}.xlim, new_xlim ) ...
          ||~isequal( plot_h{14}.ylim, new_ylim )
          set( plot_h{14}.ax_h,'xlim', new_xlim,'ylim', new_ylim )
          pzg_reptxt( dom_ndx, new_xlim, new_ylim );
          drawnow
          plot_h{14}.xlim = new_xlim;
          plot_h{14}.ylim = new_ylim;
          PZG(dom_ndx).plot_h{14}.xlim = new_xlim;
          PZG(dom_ndx).plot_h{14}.ylim = new_ylim;
          PZG(dom_ndx).plot_h{14}.hndl.ax_xlim = new_xlim;
          PZG(dom_ndx).plot_h{14}.hndl.ax_ylim = new_ylim;
        end
      end
      
      plot_h{14}.mindist = 0;
      plot_h{14}.nearest_freq = init_cntr_data.contour_freq(nyqdata_ndx);
      %if ( init_cntr_data.contour_flag(nyqdata_ndx) == 1 ) && ~neg_freq
      if ( init_cntr_data.contour_flag(nyqdata_ndx) == 1 )
        plot_h{14}.bodedata_ndx = ...
          pzg_gle( PZG(dom_ndx).BodeFreqs, plot_h{14}.nearest_freq,'near');
      else
        plot_h{14}.bodedata_ndx = [];
      end
      
      pd = local_initialize_pd( plot_h, 14, dom_ndx );
      if ( dom_ndx == 2 ) && ( pd.neg_freq == 1 ) ...
        &&( pd.dtpzmap_freq < pi/PZG(2).Ts ) ...
        &&( pd.dtpzmap_freq > 0 )
        pd.dtpzmap_freq = -pd.dtpzmap_freq;
        pd.ol_freq_w = 2*pi/PZG(2).Ts - abs(pd.dtpzmap_freq);
        pd.dt_bode_freq_str = ['-' pd.dt_bode_freq_str ];
        freq_for_ndx = 2*pi/PZG(2).Ts - abs(pd.dtpzmap_freq);
        pd.ol_ndx = pzg_gle( PZG(2).BodeFreqs, freq_for_ndx,'near');
        pd.ol_phs_deg_wrapped = -pd.ol_phs_deg_wrapped;
        pd.ol_phs_deg_unwrapped = -pd.ol_phs_deg_unwrapped;
        pd.cl_phs_deg_wrapped = -pd.cl_phs_deg_wrapped;
        pd.cl_phs_deg_unwrapped = -pd.cl_phs_deg_unwrapped;
      end
      local_update_frequency_hilites( pd, plot_h, dom_ndx );
      drawnow
    end
  end
return

function local_fig_freqhilites_off( plot_h, ndxs )
  %global PZG
  if ~nargin || ~iscell(plot_h) || isempty(plot_h)
    return
  end
  if ( nargin == 1 ) || ~isnumeric(ndxs)
    ndxs = (1:numel(plot_h))';
  end
  for k = 1:numel(ndxs)
    ndx = ndxs(k);
    if isempty( plot_h{ndx} ) || ~isstruct(plot_h{ndx})
      continue
    end
    if ( ndx > 0 ) && ( ndx <= numel(plot_h) ) ...
      && isfield( plot_h{ndx},'fig_h')
      if isfield( plot_h{ndx},'mm_freq_h') ...
        && ~isempty(plot_h{ndx}.mm_freq_h)
        set( plot_h{ndx}.mm_freq_h,'visible','off')
      end
      if isfield( plot_h{ndx},'mm_mag_h') ...
        && ~isempty(plot_h{ndx}.mm_mag_h)
        set( plot_h{ndx}.mm_mag_h,'visible','off')
      end
      if isfield( plot_h{ndx},'mm_phs_h') ...
        && ~isempty(plot_h{ndx}.mm_phs_h)
        set( plot_h{ndx}.mm_phs_h,'visible','off')
      end
      if isfield( plot_h{ndx},'mm_line_h') ...
        && ~isempty(plot_h{ndx}.mm_line_h)
        set( plot_h{ndx}.mm_line_h,'visible','off')
      end
      if isfield( plot_h{ndx},'mm_mark_h') ...
        && ~isempty(plot_h{ndx}.mm_mark_h)
        set( plot_h{ndx}.mm_mark_h,'visible','off')
      end
    end
    if ndx == 6
      dom_ndx = plot_h{ndx}.hndl.dom_ndx;
      design_line_h = pzg_fndo( dom_ndx, 6,'CL_0dB_contour');
      if ~isempty(design_line_h)
        set( design_line_h,'xdata',[],'ydata',[],'visible','off');
      end
      design_text_h = pzg_fndo( dom_ndx, 6,'LeadLag_Text');
      if ~isempty(design_text_h)
        set( design_text_h,'string','','visible','off');
      end
    end
  end
return

function plot_h = local_ldlg_zerodbCL_dist( ...
             plot_h, dom_ndx, nic_select_pt, neg_freq )
  global PZG
  
  if ~nargin || ~iscell(plot_h) || ( numel(plot_h) < 6 ) ...
    || isempty(plot_h{6}) || ~isstruct(plot_h{6}) ...
    || ~isfield(plot_h{6},'fig_h')
    return
  end
  if nargin < 2
    if isempty( strfind( plot_h{6}.plot_name,'Continuous-Time') )
      dom_ndx = 1;
    else
      dom_ndx = 2;
    end
  end
  if nargin < 3
    nic_select_pt = plot_h{6}.CurrPt;
  end
  if nargin < 4
    neg_freq = plot_h{6}.neg_freq;
  end
  
  desn_tools = pzg_tools(dom_ndx);
  if desn_tools(2)
    LL_hilite_line_h = pzg_fndo( dom_ndx, 6,'CL_0dB_contour');
    LL_hilite_text_h = pzg_fndo( dom_ndx, 6,'LeadLag_Text');
    ax_color = get(plot_h{6}.ax_h,'color');
    LL_color = [0.85 0.85 0 ] - 0.2*[ ax_color(1:2), 0 ];
  
    if isempty(nic_select_pt)
      if ~isempty(LL_hilite_line_h) 
        set(LL_hilite_line_h,'xdata',[],'ydata',[],'visible','off');
      end
      if ~isempty(LL_hilite_text_h) 
        set(LL_hilite_text_h,'string','','visible','off');
      end
    else
      select_mag = 10^( imag(nic_select_pt)/20 );
      select_phs = real(nic_select_pt);
      ol_phase_for_unity_clmag = acos( -0.5 / select_mag )/pi*180;
      if ol_phase_for_unity_clmag > 0
        ol_phase_for_unity_clmag = -ol_phase_for_unity_clmag;
      end
      while select_phs < ( ol_phase_for_unity_clmag - 180 )
        ol_phase_for_unity_clmag = ol_phase_for_unity_clmag - 360;
      end
      while select_phs > ( ol_phase_for_unity_clmag + 180 )
        ol_phase_for_unity_clmag = ol_phase_for_unity_clmag + 360;
      end
      delta_phase = ol_phase_for_unity_clmag - select_phs;
      if neg_freq ...
        || ( select_mag <= 0.5 ) || ~plot_h{6}.cl_grid_cb ...
        ||( abs(delta_phase) > 90 )
        if ~isempty(LL_hilite_line_h) 
          set( LL_hilite_line_h,'xdata',[],'ydata',[],'visible','off');
        end
        if ~isempty(LL_hilite_text_h) 
          set(LL_hilite_text_h,'string','','visible','off');
        end
      else
        line_pts = [ nic_select_pt; ...
                     ol_phase_for_unity_clmag+1i*imag(nic_select_pt) ];
        if ~isequal( 1, numel(LL_hilite_line_h) )
          delete(LL_hilite_line_h)
          PZG(dom_ndx).plot_h{6}.hndl.CL_0dB_contour = ...
            plot( real(line_pts), imag(line_pts), ...
                'linewidth', 3, ...
                'linestyle','-.', ...
                'color', LL_color, ...
                'parent', plot_h{6}.ax_h, ...
                'tag','CL 0-dB contour');
          plot_h{6}.hndl.CL_0dB_contour = ...
            PZG(dom_ndx).plot_h{6}.hndl.CL_0dB_contour;
        else
          set( LL_hilite_line_h, ...
              'xdata', real(line_pts), ...
              'ydata', imag(line_pts), ...
              'color', LL_color, ...
              'linewidth', 3, ...
              'linestyle','-.', ...
              'visible','on')
        end
        if delta_phase > 0
          text_pos = [ select_phs+delta_phase/5, ...
                       imag(nic_select_pt)-0.03*diff(plot_h{6}.ylim), 0 ];
        else
          text_pos = [ select_phs+delta_phase*2/3, ...
                       imag(nic_select_pt)+0.04*diff(plot_h{6}.ylim), 0 ];
        end
        if ~isequal( 1, numel(LL_hilite_text_h) )
          delete(LL_hilite_text_h)
          PZG(dom_ndx).plot_h{6}.hndl.LeadLag_Text = ...
            text( text_pos(1), text_pos(2), ...
                [local_tenths_str(delta_phase) '^o'], ...
                'color', LL_color, ...
                'fontsize', 14, ...
                'fontweight','bold', ...
                'parent', plot_h{6}.ax_h, ...
                'tag','Lead-Lag Text');
          plot_h{6}.hndl.LeadLag_Text = ...
            PZG(dom_ndx).plot_h{6}.hndl.LeadLag_Text;
        else
          set( LL_hilite_text_h, ...
              'position', text_pos, ...
              'string', [local_tenths_str(delta_phase) '^o'], ...
              'color', LL_color, ...
              'fontsize', 14, ...
              'fontweight','bold', ...
              'visible','on');
        end
      end
    end
  end
return

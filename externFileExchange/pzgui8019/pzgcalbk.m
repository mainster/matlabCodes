function pzgcalbk( GCBO, ReqStr )
% This function services certain callbacks from the main PZGUI plots
% and the root-locus plots.

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
global pzg_drawbox
if isempty(PZG) && ~pzg_recovr 
  return
end
evalin('base','global PZG')

if nargin > 2
  return;
elseif ~ischar(ReqStr)
  return
elseif ~ishandle(GCBO)
  return
end

if strcmp( get(GCBO,'type'),'uicontrol') || strcmp( get(GCBO,'type'),'axes')
  FigH = get(GCBO,'parent');
elseif strcmp( get(GCBO,'type'),'figure')
  FigH = GCBO;
else
  GCBO = gcbf;
end
if isempty( strfind( get( FigH,'name'),'iscrete') )
  Domain = 's';
  dom_ndx = 1;
else
  Domain = 'z';
  dom_ndx = 2;
end

if isempty(PZG(dom_ndx).Selection)
  PZMoving = 0;
end

hndl = getappdata( FigH,'hndl');

if isfield( hndl,'ax')
  AxH = hndl.ax;
else
  AxH = findobj( FigH,'type','axes');
  if numel(AxH) > 1
    for k = numel(AxH):-1:1
      if strcmp( get(AxH(k),'tag'),'legend')
        AxH(k) = [];
      end
    end
  end
end
if isfield( hndl,'ax_xlim') && isfield( hndl,'ax_ylim') ...
  && isequal( 2, numel(hndl.ax_xlim) ) ...
  && isequal( 2, numel(hndl.ax_ylim) )
  XLim = hndl.ax_xlim;
  YLim = hndl.ax_ylim;
else
  YLim = get( AxH,'ylim');
  XLim = get( AxH,'xlim');
  hndl.ax_xlim = XLim;
  hndl.ax_ylim = YLim;
  setappdata( FigH,'hndl', hndl );
  if strcmp( get(FigH,'name'), PZG(dom_ndx).PZGUIname )
    pzg_cphndl( FigH, 1, 11+dom_ndx )
  elseif strcmp( get(FigH,'name'), PZG(dom_ndx).RootLocusName )
    pzg_cphndl( FigH, 1, 9+dom_ndx )
  end
end

if numel(PZG) ~= 2
  return
elseif ~isfield( PZG(2),'Ts')
  return
else
  Fs = 1/PZG(2).Ts;
end

% Check whether or not the "Help" checkbox is checked.
temp_A = get(FigH,'userdata');
if ( size(temp_A,1) >= 9 ) && ( size(temp_A,2) >= 2 ) ...
  && ishandle(temp_A(9,2)) && isequal( get(temp_A(9,2),'type'),'uicontrol') ...
  && get( temp_A(9,2),'value')
  helpserv( get(FigH,'name') )
end

CLpoles = [];

switch ReqStr 
case 'mouse motion'
  if isempty(gcbf) || ~isappdata( gcbf,'hndl')
    return
  end
  hndl = getappdata( gcbf,'hndl');
  if isfield( hndl,'dom_ndx')
    dom_ndx = hndl.dom_ndx;
  else
    disp('what figure is this ???')
  end
  ploth_ndx = hndl.ploth_ndx;
  if ~isequal( ploth_ndx, 9+dom_ndx ) ...
    && ~isequal( ploth_ndx, 11+dom_ndx )
    return
  end
  gcbf_ui_h = pzg_fndo( dom_ndx, ploth_ndx,'file_menu');
  if isempty(gcbf_ui_h) || strcmp( get(gcbf_ui_h,'enable'),'off')
    % Don't run this if file menu is disabled.
    return
  end
  
  % Not in a time-response plot.
  tempresp_h = ...
    [ pzg_fndo( (1:2),(8:9),'input_cursor'); ...
      pzg_fndo( (1:2),(8:9),'resp_cursor'); ...
      pzg_fndo( (1:2),(8:9),'error_cursor') ];
  if ~isempty(tempresp_h)
    set(tempresp_h(ishandle(tempresp_h)),'visible','off')
  end
  
  for k_trk = [3 4 6]
    if isempty(PZG(dom_ndx).plot_h{k_trk}) ...
      || ~isfield( PZG(dom_ndx).plot_h{k_trk},'ax_h')
      continue
    end
    if ~isempty( PZG(dom_ndx).plot_h{k_trk} ) ...
      && isfield( PZG(dom_ndx).plot_h{k_trk},'hndl')
      this_hndl = PZG(dom_ndx).plot_h{k_trk}.hndl;
    else
      this_hndl = [];
    end
    if isempty(this_hndl)
      continue
    end
    nich_cl_track_h = pzg_fndo( dom_ndx, k_trk,'Nichols_CL_track_line');
    if ~isempty(nich_cl_track_h) && all( ishandle(nich_cl_track_h(:)) )
      set( nich_cl_track_h,'visible','off')
    end
    nich_cl_text_h = pzg_fndo( dom_ndx, k_trk,'Nichols_CL_track_text');
    if ~isempty(nich_cl_text_h) && all(ishandle(nich_cl_text_h))
      set( nich_cl_text_h,'visible','off')
    end
  end
  
  % Get minimum distance for frequency-point display.
  currPt = get( AxH,'currentpoint');
  x_lim = XLim;
  y_lim = YLim; 
  if ( currPt(1,1) < x_lim(1) ) ...
    ||( currPt(1,1) > x_lim(2) ) ...
    ||( currPt(1,2) < y_lim(1) ) ...
    ||( currPt(1,2) > y_lim(2) )
    mindist = inf;
  else
    if dom_ndx == 1
      % Normalized distance from the jW-axis
      mindist = abs(currPt(1,1))/diff(x_lim);
    else
      % Normalized distance from the unit-circle
      curr_angle = atan2( currPt(1,2), currPt(1,1) );
      curr_ucpt = exp(1i*curr_angle);
      normalized_dist = ...
        ( currPt(1,1)-real(curr_ucpt) )/diff(x_lim) ...
        + 1i*( currPt(1,2)-imag(curr_ucpt) )/diff(y_lim);
      mindist = abs( normalized_dist );
    end
  end
  
  if mindist > 0.05
    startmovie_h = pzg_fndo( dom_ndx, 14,'nyq_movie_pushbutton');
    stopmovie_h = pzg_fndo( dom_ndx, 14,'nyq_stop_movie_pushbutton');
    if ( isempty(startmovie_h) && isempty(stopmovie_h) ) ...
      ||( strcmp( get(stopmovie_h,'visible'),'off') ...
         && strcmp( get(startmovie_h,'visible'),'on') )
      hilite_h = ...
        [ pzg_fndo( (1:2), (1:14),'mm_mark_h'); ...
          pzg_fndo( (1:2), (1:14),'mm_line_h'); ...
          pzg_fndo( (1:2), (1:14),'mm_freq_h'); ...
          pzg_fndo( (1:2), (1:14),'mm_mag_h'); ...
          pzg_fndo( (1:2), (1:14),'mm_phs_h'); ...
          pzg_fndo( (1:2), (1:14),'dynamic_gain_marker'); ...
          pzg_fndo( (1:2), (1:14),'damping_natural_freq_text') ];
      if ~isempty(hilite_h)
        set( hilite_h,'visible','off')
      end
    end

  else
    if isempty(PZG(dom_ndx).BodeMag) ...
      ||isempty(PZG(dom_ndx).BodePhs) ...
      ||isempty(PZG(dom_ndx).BodeFreqs)
      if dom_ndx == 1
        pzgui
      else
        dpzgui
      end
    end
    
    freqserv(gcbf);

    if dom_ndx == 1
      track_freq = currPt(1,2);
      if track_freq < 0
        PZG(1).NegSelect = 0;
      else
        PZG(1).NegSelect = 0;
      end
    else
      track_angle = angle( currPt(1,1)+1i*currPt(1,2) );
      track_freq = abs(track_angle)/PZG(2).Ts;
      if currPt(1,2) < 0
        PZG(2).NegSelect = 1;
      else
        PZG(2).NegSelect = 0;
      end
      uc_sel_pt = exp( 1i*track_angle );
    end
    if ~isempty( PZG(dom_ndx).plot_h{11+dom_ndx} ) ...
      && PZG(dom_ndx).pzg_show_frf_computation
      % Force selected frequency (in rad/s) to track the mouse motion.
      freqsel_ndx = ...
        pzg_gle( PZG(dom_ndx).BodeFreqs, abs(track_freq),'near');
      [ nyqdist, nyqsel_ndx ] = ...
         min( abs( PZG(dom_ndx).cntr_data.contour_freq - track_freq ) ); ... 
         %#ok<ASGLU>
      if ~isempty(freqsel_ndx) && ~isempty(nyqsel_ndx) ...
        && ( track_freq >= 0 )
        if ~isequal( PZMoving, 1 )
          PZG(dom_ndx).FrqSelNdx = freqsel_ndx;
        end
        PZG(dom_ndx).NyqSelNdx = nyqsel_ndx;
        if dom_ndx == 1
          set( PZG(1).plot_h{12}.hndl.Bode_selection_marker, ...
              'xdata', 0,'ydata', track_freq,'visible','on');
          updtpzln('s');
          % pzg_seltxt( dom_ndx, sel_freq, sel_fig_ndx, neg_freq );
          pzg_seltxt( ...
             1, PZG(1).BodeFreqs(freqsel_ndx), gcbf, PZG(1).NegSelect); 
          freqserv('refresh selected_freq');
          set( PZG(1).plot_h{12}.hndl.Bode_selection_marker, ...
              'xdata', 0, ...
              'ydata', PZG(1).BodeFreqs(freqsel_ndx), ...
              'visible','on');
        else
          set( PZG(2).plot_h{13}.hndl.Bode_selection_marker, ...
              'xdata', real(uc_sel_pt), ...
              'ydata', imag(uc_sel_pt),'visible','on');
          updtpzln('z');
          pzg_seltxt( ...
             2, PZG(2).BodeFreqs(freqsel_ndx), gcbf, PZG(2).NegSelect);
          freqserv('refresh selected_freq');
        end
      end
    end
  end
  if ~PZG(dom_ndx).pzg_show_frf_computation
    % Blank the selection vectors
    if dom_ndx == 1
      bodecomp_h = ...
        [ pzg_fndo( 1,[10;12],'bode_comp_pole_lines'); ...
          pzg_fndo( 1,[10;12],'bode_comp_zero_lines'); ...
          pzg_fndo( 1,[10;12],'bode_comp_zero_text'); ...
          pzg_fndo( 1,[10;12],'bode_comp_pole_text'); ...
          pzg_fndo( 1,[10;12],'bode_comp_freq_text') ];
      if ~isempty(bodecomp_h)
        set( bodecomp_h,'visible','off');
      end
      if isempty( strfind( ReqStr,'mouse motion') )
        pzmvserv('s',[],'Erase');
        pzg_seltxt( 1, [] );
      end
    else
      bodecomp_h = ...
        [ pzg_fndo( 2,[11;13],'bode_comp_pole_lines'); ...
          pzg_fndo( 2,[11;13],'bode_comp_zero_lines'); ...
          pzg_fndo( 2,[11;13],'bode_comp_zero_text'); ...
          pzg_fndo( 2,[11;13],'bode_comp_pole_text'); ...
          pzg_fndo( 2,[11;13],'bode_comp_pole_text') ];
      if ~isempty(bodecomp_h)
        set( bodecomp_h,'visible','off');
      end
      if isempty( strfind( ReqStr,'mouse motion') )
        pzmvserv('z',[],'Erase');
        pzg_seltxt( 2, [] );
      end
    end
  end
  
  if isstruct(pzg_drawbox) ...
    &&isfield( pzg_drawbox,'button_down') ...
    &&( pzg_drawbox.button_down == 1 )
    drawbox_h = pzg_fndo( dom_ndx, 11+dom_ndx,'draw_box_checkbox');
    if ~isempty(drawbox_h) && get(drawbox_h,'value')
      pzg_drawbox.corner2 = ...
        get( get(gcbf,'currentaxes'),'currentpoint');
      pzg_box
    else
      pzg_drawbox.button_down = 0;
      pzg_drawbox.corner1 = [];
      pzg_drawbox.corner2 = [];
    end
    return
  end
   
  temp = get( AxH,'currentpoint');
  if ( temp(1,1) > XLim(1) ) && ( temp(1,1) < XLim(2) ) ...
    &&( temp(1,2) > YLim(1) ) && ( temp(1,2) < YLim(2) )
    CurrPt = temp(1,1) + 1i*temp(1,2);
    linkmethod_h = pzg_fndo( 1,(12:13),'LinkMethod');
    if isempty(linkmethod_h)
      linkmethod = 2;
    else
      linkmethod = get( linkmethod_h(1),'value');
    end
    if Domain == 'z'
      if linkmethod < 3
        sPlaneLoc = Fs*log(CurrPt);
      else
        w_den = CurrPt+1;
        if w_den ~= 0
          sPlaneLoc = 2*Fs*(CurrPt-1)/w_den;
        else
          sPlaneLoc = inf;
        end
      end
    else
      sPlaneLoc = CurrPt;
      
      % Adjust the s-plane point when the grid is either 
      % periodic or the W-plane.
      grid_type = 's-plane';
      dtpzg_h = pzg_fndo( 2, 13,'fig_h');
      if ~isempty(dtpzg_h)
        if linkmethod == 3
          grid_type = 'w-plane';
        else
          grid_type = 'periodic s-plane';
        end
      end
      switch grid_type
        case 'periodic s-plane'
          Ws = 2*pi/PZG(1).Ts;
          subtract_integer = round( imag(sPlaneLoc)/Ws );
          sPlaneLoc = real(sPlaneLoc) + 1i*(imag(sPlaneLoc)-subtract_integer*Ws);
        case 'w-plane'
          wPlaneLoc = sPlaneLoc;
          w_den = 2/PZG(1).Ts - wPlaneLoc;
          if abs(w_den) < 1e-8
            w_den = 1e-8;
          end
          z_from_w = ( 2/PZG(1).Ts + wPlaneLoc)/w_den;
          sPlaneLoc = log(z_from_w)/PZG(1).Ts;
        otherwise
      end
    end
    
    % If the motion is in s-plane, but z-plane pz-map is open,
    % bring the s-plane point into the primary strip.
    if ~isempty(gcbf) && ( dom_ndx == 1 ) && ~isempty( dtpzg_h ) ...
      && strcmp( grid_type,'periodic s-plane')
      while imag(sPlaneLoc) > pi/PZG(2).Ts
        sPlaneLoc = sPlaneLoc - 1i*2*pi/PZG(2).Ts;
      end
      while imag(sPlaneLoc) < -pi/PZG(2).Ts
        sPlaneLoc = sPlaneLoc + 1i*2*pi/PZG(2).Ts;
      end
    end
    
    Zeta = 100 * cos( atan2( imag(sPlaneLoc), -real(sPlaneLoc) ) );
    NatFrqHz = abs(sPlaneLoc)/2/pi;
    if imag(sPlaneLoc) < 0
      NatFrqHz = -NatFrqHz;
    end
    DispStr = {['\zeta = ' num2str(Zeta,4) '%']; ...
               ['{\it\omega_n}= ' num2str(NatFrqHz,4) ' Hz']};
    
    if ~isempty( strfind( get( FigH,'name'),'Root Locus') )
      show_paramK_effect = 0;
      neg_loci_vis = 'off';
      if isfield( hndl,'rlocuspl_neg_root_loci') ...
        && all(ishandle(hndl.rlocuspl_neg_root_loci(:)))
        negrlocline_h = hndl.rlocuspl_neg_root_loci;
      else
        negrlocline_h = pzg_fndo( dom_ndx, 9+dom_ndx,'rlocuspl_neg_root_loci');
      end
      if ~isempty(negrlocline_h)
        negloci_xdata = get( negrlocline_h(1),'xdata');
        if numel( negloci_xdata ) > 1
          neg_loci_vis = get( negrlocline_h(1),'visible');
        end
      end

      %set( gcbf,'pointer','arrow');
      % Compute the open-loop complex value at the cursor location, "CurrPt".
      if Domain == 'z'
        all_poles = [ PZG(2).PoleLocs; zeros(PZG(2).PureDelay,1) ];
        all_zeros = PZG(2).ZeroLocs;
        all_gain = PZG(2).Gain;
        % cplx_ol_at_currpt = ...
        %   PZG(2).Gain ...
        %   * exp( sum( log( CurrPt - PZG(2).ZeroLocs ) ) ...
        %         -sum( log( CurrPt - all_poles ) ) );
      else
        all_zeros = PZG(1).ZeroLocs;
        all_poles = PZG(1).PoleLocs;
        all_gain = PZG(1).Gain;
        if PZG(1).PureDelay > 0
          [ pade_N, pade_D ] = pade( PZG(1).PureDelay, 4 );
          all_zeros = [ all_zeros; roots(pade_N) ];
          all_poles = [ all_poles; roots(pade_D) ];
          if pade_N(1) ~= 1
            all_gain = all_gain * pade_N(1);
          end
        end
        % cplx_ol_at_currpt = ...
        %   all_gain ...
        %   * exp( sum( log( CurrPt - all_zeros ) ) ...
        %         -sum( log( CurrPt - all_poles ) ) );
      end
      all_pdiff = CurrPt - all_poles;
      [ temp1, sortndx ] = sort(abs(all_pdiff)); %#ok<ASGLU>
      all_pdiff = all_pdiff(sortndx);
      all_zdiff = CurrPt - all_zeros;
      [ temp1, sortndx ] = sort(abs(all_zdiff)); %#ok<ASGLU>
      all_zdiff = all_zdiff(sortndx);
      cplx_ol_at_currpt = 1;
      for k_p = 1:numel(all_poles)
        if numel(all_zeros) >= k_p
          cplx_ol_at_currpt = cplx_ol_at_currpt * all_zdiff(k_p);
        end
        cplx_ol_at_currpt = cplx_ol_at_currpt / all_pdiff(k_p);
      end
      cplx_ol_at_currpt = all_gain * cplx_ol_at_currpt;
      
      cplx_ol_mag = abs(cplx_ol_at_currpt); 
      cplx_ol_angle = 180/pi*angle( cplx_ol_at_currpt );
      if cplx_ol_angle > 0
        cplx_ol_angle = mod( cplx_ol_angle, 360 );
      else
        cplx_ol_angle = -mod( -cplx_ol_angle, 360 );
      end
      
      if imag(CurrPt) > 0
        extra_line = ...
          {[ Domain '_o = ' ...
             num2str(real(CurrPt),4) ' + ' num2str(imag(CurrPt),4)  'i']};
      elseif imag(CurrPt) < 0
        extra_line = ...
          {[ Domain '_o = ' ...
             num2str(real(CurrPt),4) ' - ' num2str(abs(imag(CurrPt)),4)  'i']};
      else
        extra_line = {[ Domain '_o = ' num2str(real(CurrPt),4) ]};
      end
      DispStr = { extra_line{1}; ...
                  ['        ( ' DispStr{1} '     ' DispStr{2} ' )' ] };
      extra_line = ...
        {['|G_O_L(' Domain '_o)| = ' num2str(cplx_ol_mag,4) ...
          '      \angleG_O_L(' Domain '_o) =' ...
                        num2str(cplx_ol_angle,4) '^o']};
      DispStr = [ DispStr; extra_line ];
      
      % Update the dynamic gain marker.
      if isfield( hndl,'ax') && all(ishandle(hndl.ax))
        rl_ax_h = hndl.ax;
      else
        rl_ax_h = PZG(dom_ndx).plot_h{9+dom_ndx}.ax;
      end
      
      if isfield( hndl,'dynamic_gain_marker') ...
         && isequal( 1, ishandle(hndl.dynamic_gain_marker(:)) )
        dg_h = hndl.dynamic_gain_marker(:);
      else
        dg_h = PZG(dom_ndx).plot_h{9+dom_ndx}.hndl.dynamic_gain_marker;
      end
      
      ang180 = abs(cplx_ol_angle);
      while ang180 > 360
        ang180 = ang180 - 360;
      end
      ang0 = abs(cplx_ol_angle);
      while ang0 > 180
        ang0 = ang0 - 360;
      end
      
      % Compute the closed-loop poles at the given gain.
      mouse_cl_vis = 'on';
      if Domain == 'z'
        this_gain = 1 / cplx_ol_mag;
        ax_ud = get( rl_ax_h,'userdata');
        if ~isempty(ax_ud) && isstruct(ax_ud) ...
          && isfield( ax_ud,'AA') && isfield( ax_ud,'BC') ...
          && isfield( ax_ud,'DD')
          AA = ax_ud.AA;
          BC = ax_ud.BC;
          DD = ax_ud.DD;
        else
          modalss = pzg_moda( 2, 1, 1, 0,'', 1 );
          AA = modalss.a;
          BC = modalss.b * modalss.c;
          DD = modalss.d;
        end
        if ~isempty(AA)
          if this_gain == 0
            CLpoles = PLocs;
          else
            CLpoles = eig( AA-BC/(DD+1/this_gain) );
          end
        else
          N = poly( PZG(2).ZeroLocs ) * this_gain;
          P = [ PZG(2).PoleLocs; zeros(PZG(2).PureDelay,1) ];
          D = poly(P);
          D(end-numel(N)+1:end) =  D(end-numel(N)+1:end) + N;
          CLpoles = roots(D);
        end

        purejordan = 1;
        include_pade = 1;
        include_prvw = 1;
        design_modalss = ...
          pzg_moda( 2, purejordan, include_pade, include_prvw,'', 1 );
        dsn.AA = design_modalss.a;
        dsn.BC = design_modalss.b * design_modalss.c;
        dsn.DD = design_modalss.d;
        if this_gain == 0
          design_CLpoles = eig( dsn.AA );
        else
          if abs( dsn.DD + 1/this_gain ) < 1e-14
            design_CLpoles = inf*ones(size(dsn.AA,1),1);
          else
            design_CLpoles = eig( dsn.AA-dsn.BC/(dsn.DD+1/this_gain) );
          end
        end
      else
        this_gain = 1 / cplx_ol_mag;
        ax_ud = get( rl_ax_h,'userdata');
        if ~isempty(ax_ud) && isstruct(ax_ud) ...
          && isfield( ax_ud,'AA') && isfield( ax_ud,'BC') ...
          && isfield( ax_ud,'DD')
          AA = ax_ud.AA;
          BC = ax_ud.BC;
          DD = ax_ud.DD;
        else
          modalss = pzg_moda( 1, 1, 1, 0,'', 1 );
          AA = modalss.a;
          BC = modalss.b * modalss.c;
          DD = modalss.d;
        end

        if ~isempty(AA)
          if this_gain == 0
            CLpoles = PLocs;
          else
            CLpoles = eig( AA-BC/(DD+1/this_gain) );
          end
        else
          Z = PZG(1).ZeroLocs;
          P = PZG(1).PoleLocs;
          if PZG(1).PureDelay > 0
            this_gain = this_gain * PZG(1).pade.K;
            Z = [ Z; PZG(1).pade.Z ];
            P = [ P; PZG(1).pade.P ];
          end
          N = this_gain * poly(Z);
          D = poly(P);
          % Close the loop.
          D(end-numel(N)+1:end) =  D(end-numel(N)+1:end) + N;
          CLpoles = roots(D);
        end
        % Check that the computed CLpoles satisfy angle requirements,
        % when gain exceeds 1e6.
        if this_gain > 1e6
          for k_p = 1:numel(CLpoles)
            this_CLpole_pt = all_gain;
            for k_olp = 1:numel(all_poles)
              if numel(all_zeros) >= k_olp
                this_CLpole_pt = ...
                  this_CLpole_pt * ( CLpoles(k_p) - all_zeros(k_olp) );
              end
              this_CLpole_pt = ...
                this_CLpole_pt / ( CLpoles(k_p) - all_poles(k_olp) );
            end
            this_pt_angle = angle(this_CLpole_pt)/pi*180;
            this_pt_angle = mod( abs(this_pt_angle), 360 );
            if abs( 180 - this_pt_angle ) > 45
              mouse_cl_vis = 'off';
            end
            if strcmp( mouse_cl_vis,'off')
              break
            end
          end
        end      
      end
      
      % Determine closest distance to a root loci point.
      if isfield( hndl,'rlocuspl_root_loci') ...
         && all(ishandle(hndl.rlocuspl_root_loci(:)))
        rl_h = hndl.rlocuspl_root_loci(:);
      else
        rl_h = findobj( rl_ax_h,'tag','rlocuspl root loci');
      end
      rl_x = [];
      rl_y = [];
      for krl = 1:numel(rl_h)
        rl_x = [ rl_x, get( rl_h(krl),'xdata') ]; %#ok<AGROW>
        rl_y = [ rl_y, get( rl_h(krl),'ydata') ]; %#ok<AGROW>
      end
      rl_x = [ rl_x(:); real(CLpoles(:)) ];
      rl_y = [ rl_y(:); imag(CLpoles(:)) ];
      
      thisPt = currPt(1)+1i*currPt(1,2);
      % unscaled_Dist = thisPt - rl_x+1i*rl_y;
      
      % Scale the distance by the x- and y-axes limits.
      x_scale = diff( x_lim );
      y_scale = diff( y_lim );
      
      scaled_Dist = ...
        ( real(thisPt)-rl_x )/x_scale + 1i*( imag(thisPt)-rl_y )/y_scale;
      
      scaled_dist = min( abs(scaled_Dist) );
      min_dist = scaled_dist;
      
      below_min_dist = ...
        ( ~isempty(min_dist) && ( min_dist < 0.07 ) ...
          &&( abs( abs(ang180)-180 ) < 10 ) );
      
      if below_min_dist 
        local_smallcirc_ptr( gcbf )
        extra_line = ...
          {['Parameter K = ' num2str( 1/cplx_ol_mag, 4 )]};
        DispStr = [ extra_line;{' '}; DispStr;{' '}];
        show_paramK_effect = 1/cplx_ol_mag;
        if ~isempty(dg_h)
          set(dg_h,'visible','on')
        end
      else
        % Set the cursor back to the "magnifying glass".
        pzg_ptr;
      end
      
      if below_min_dist && ( numel(PZG(dom_ndx).PoleLocs) <= 1000 )
        % Compute the closed-loop poles at the given gain.
        mouse_cl_vis = 'on';
        if Domain == 'z'
          this_gain = 1 / cplx_ol_mag;
          ax_ud = get( rl_ax_h,'userdata');
          if ~isempty(ax_ud) && isstruct(ax_ud) ...
            && isfield( ax_ud,'AA') && isfield( ax_ud,'BC') ...
            && isfield( ax_ud,'DD')
            AA = ax_ud.AA;
            BC = ax_ud.BC;
            DD = ax_ud.DD;
          else
            modalss = pzg_moda( 2, 1, 1, 0,'', 1 );
            AA = modalss.a;
            BC = modalss.b * modalss.c;
            DD = modalss.d;
          end
          if ~isempty(AA)
            if this_gain == 0
              CLpoles = PLocs;
            else
              CLpoles = eig( AA-BC/(DD+1/this_gain) );
            end
          else
            N = poly( PZG(2).ZeroLocs ) * this_gain;
            P = [ PZG(2).PoleLocs; zeros(PZG(2).PureDelay,1) ];
            D = poly(P);
            D(end-numel(N)+1:end) =  D(end-numel(N)+1:end) + N;
            CLpoles = roots(D);
          end

          purejordan = 1;
          include_pade = 1;
          include_prvw = 1;
          design_modalss = ...
            pzg_moda( 2, purejordan, include_pade, include_prvw,'', 1 );
          dsn.AA = design_modalss.a;
          dsn.BC = design_modalss.b * design_modalss.c;
          dsn.DD = design_modalss.d;
          if this_gain == 0
            design_CLpoles = eig( dsn.AA );
          else
            if abs( dsn.DD + 1/this_gain ) < 1e-14
              design_CLpoles = inf*ones(size(dsn.AA,1),1);
            else
              design_CLpoles = eig( dsn.AA-dsn.BC/(dsn.DD+1/this_gain) );
            end
          end
        else
          this_gain = 1 / cplx_ol_mag;
          ax_ud = get( rl_ax_h,'userdata');
          if ~isempty(ax_ud) && isstruct(ax_ud) ...
            && isfield( ax_ud,'AA') && isfield( ax_ud,'BC') ...
            && isfield( ax_ud,'DD')
            AA = ax_ud.AA;
            BC = ax_ud.BC;
            DD = ax_ud.DD;
          else
            modalss = pzg_moda( 1, 1, 1, 0,'', 1 );
            AA = modalss.a;
            BC = modalss.b * modalss.c;
            DD = modalss.d;
          end

          if ~isempty(AA)
            if this_gain == 0
              CLpoles = PLocs;
            else
              CLpoles = eig( AA-BC/(DD+1/this_gain) );
            end
          else
            Z = PZG(1).ZeroLocs;
            P = PZG(1).PoleLocs;
            if PZG(1).PureDelay > 0
              this_gain = this_gain * PZG(1).pade.K;
              Z = [ Z; PZG(1).pade.Z ];
              P = [ P; PZG(1).pade.P ];
            end
            N = this_gain * poly(Z);
            D = poly(P);
            % Close the loop.
            D(end-numel(N)+1:end) =  D(end-numel(N)+1:end) + N;
            CLpoles = roots(D);
          end
          % Check that the computed CLpoles satisfy angle requirements,
          % when gain exceeds 1e6.
          if this_gain > 1e6
            for k_p = 1:numel(CLpoles)
              this_CLpole_pt = all_gain;
              for k_olp = 1:numel(all_poles)
                if numel(all_zeros) >= k_olp
                  this_CLpole_pt = ...
                    this_CLpole_pt * ( CLpoles(k_p) - all_zeros(k_olp) );
                end
                this_CLpole_pt = ...
                  this_CLpole_pt / ( CLpoles(k_p) - all_poles(k_olp) );
              end
              this_pt_angle = angle(this_CLpole_pt)/pi*180;
              this_pt_angle = mod( abs(this_pt_angle), 360 );
              if abs( 180 - this_pt_angle ) > 45
                mouse_cl_vis = 'off';
              end
              if strcmp( mouse_cl_vis,'off')
                break
              end
            end
          end
          
          purejordan = 1;
          include_pade = 1;
          include_prvw = 1;
          design_modalss = ...
            pzg_moda( 1, purejordan, include_pade, include_prvw,'', 1 );
          dsn.AA = design_modalss.a;
          dsn.BC = design_modalss.b * design_modalss.c;
          dsn.DD = design_modalss.d;
          if this_gain == 0
            design_CLpoles = eig( dsn.AA );
          else
            if abs( dsn.DD + 1/this_gain ) < 1e-14
              design_CLpoles = inf*ones(size(dsn.AA,1),1);
            else
              design_CLpoles = eig( dsn.AA-dsn.BC/(dsn.DD+1/this_gain) );
            end
          end
        end
        
        if below_min_dist
          local_smallcirc_ptr( gcbf )            

          [ temp, cursor_ndx ] = min( abs( CurrPt - CLpoles ) ); %#ok<ASGLU>
          this_CLpole = CLpoles(cursor_ndx);
          if Domain == 'z'
            this_S_CLpole = log(this_CLpole)/PZG(2).Ts;
          else
            this_S_CLpole = this_CLpole;
          end

          if ( abs(this_S_CLpole) < 1e-14 ) ...
            ||( abs(real(this_S_CLpole)) < 1e-14 )
            this_CLpole_zeta = 0;
          else
            this_CLpole_zeta = ...
              -100*sign(real(this_S_CLpole)+eps) ...
                 *cos(atan(abs( imag(this_S_CLpole)/real(this_S_CLpole) )));
          end
          if Domain == 's'
            thisNatFrqHz = abs(this_CLpole)/2/pi;
          else
            thisNatFrqHz = abs( log(this_CLpole)/PZG(2).Ts )/2/pi;
          end
          DispStr = {['\zeta = ' num2str(this_CLpole_zeta,4) '%']; ...
                     ['{\it\omega_n}= ' num2str(thisNatFrqHz,4) ' Hz']};
          if imag(this_CLpole) > 0
            extra_line = ...
              {[ Domain '_o = ' num2str(real(this_CLpole),4) ...
                              ' + ' num2str(imag(this_CLpole),4)  'i']};
          elseif imag(this_CLpole) < 0
            extra_line = ...
              {[ Domain '_o = ' num2str(real(this_CLpole),4) ...
                           ' - ' num2str(abs(imag(this_CLpole)),4)  'i']};
          else
            extra_line = ...
              {[ Domain '_o = ' num2str(real(this_CLpole),4) ] };
          end
          DispStr = { extra_line{1}; ...
                      ['        ( ' DispStr{1} '     ' DispStr{2} ' )' ] };
          if Domain == 'z'
            all_poles = [ PZG(2).PoleLocs; zeros(PZG(2).PureDelay,1) ];
            cplx_ol_at_currpt = PZG(2).Gain;
            for k_olp = 1:numel(all_poles)
              if numel(all_zeros) >= k_olp
                cplx_ol_at_currpt = ...
                  cplx_ol_at_currpt * ( CurrPt - all_zeros(k_olp) );
              end
              cplx_ol_at_currpt = ...
                cplx_ol_at_currpt / ( CurrPt - all_poles(k_olp) );
            end
            % cplx_ol_at_currpt = ...
            %   PZG(2).Gain ...
            %   * exp( sum( log( CurrPt - PZG(2).ZeroLocs ) ) ...
            %         -sum( log( CurrPt - all_poles ) ) );
          else
            all_zeros = PZG(1).ZeroLocs;
            all_poles = PZG(1).PoleLocs;
            all_gain = PZG(1).Gain;
            if PZG(1).PureDelay > 0
              [ pade_N, pade_D ] = pade( PZG(1).PureDelay, 4 );
              all_zeros = [ all_zeros; roots(pade_N) ];
              all_poles = [ all_poles; roots(pade_D) ];
              if pade_N(1) ~= 1
                all_gain = all_gain * pade_N(1);
              end
            end
            cplx_ol_at_currpt = all_gain;
            for k_olp = 1:numel(all_poles)
              if numel(all_zeros) >= k_olp
                cplx_ol_at_currpt = ...
                  cplx_ol_at_currpt * ( CurrPt - all_zeros(k_olp) );
              end
              cplx_ol_at_currpt = ...
                cplx_ol_at_currpt / ( CurrPt - all_poles(k_olp) );
            end
            % cplx_ol_at_currpt = ...
            %   all_gain ...
            %   * exp( sum( log( CurrPt - all_zeros ) ) ...
            %         -sum( log( CurrPt - all_poles ) ) );
          end
          cplx_ol_mag = abs(cplx_ol_at_currpt); 
          extra_line = ...
            {['G_O_L(' Domain '_o) = -' num2str(cplx_ol_mag,4) ...
              ' =  -1 / ( ' num2str(1/cplx_ol_mag,4) ' )']};
          DispStr = [ DispStr; extra_line ];
          if abs(this_CLpole_zeta) < 3
            extra_line = ...
              {['Parameter K = ' num2str( 1/cplx_ol_mag, 4 ) ...
                '  (' num2str(20*log10(1/cplx_ol_mag),3) 'dB)']};
          else
            extra_line = ...
              {['Parameter K = ' num2str( 1/cplx_ol_mag, 4 )]};
          end
          show_paramK_effect = 1/cplx_ol_mag;
          DispStr = [ extra_line;{' '}; DispStr;{' '}];

          this_color = 1 - get( get(rl_ax_h,'parent'),'color');
          if numel(CLpoles) < 20
            marker_size = 8;
            line_width = 2.5;
          else
            marker_size = 8;
            line_width = 2.5;
          end
          if isempty(dg_h)
            hndl.dynamic_gain_marker = ...
              plot( real(CLpoles), imag(CLpoles), ...
                 'color', this_color, ...
                 'xdata', real(CLpoles), ...
                 'ydata', imag(CLpoles), ...
                 'linestyle','none', ...
                 'marker','s', ...
                 'linewidth', line_width, ...
                 'markersize', marker_size, ...
                 'visible', mouse_cl_vis, ...
                 'parent', rl_ax_h, ...
                 'tag','dynamic gain marker');
            setappdata( gcbf,'hndl', hndl );
          else
            set( dg_h,'visible','on', ...
                 'color', this_color, ...
                 'xdata', real(CLpoles), ...
                 'ydata', imag(CLpoles), ...
                 'linewidth', line_width, ...
                 'visible', mouse_cl_vis, ...
                 'markersize', marker_size );
          end
        else
          set( gcbf,'pointer','arrow');
          pzg_ptr
          set(dg_h,'visible','off');
        end
      elseif ( numel(PZG(dom_ndx).PoleLocs) < 1000 ) ...
            && strcmp( neg_loci_vis,'on') ...
            &&( ( abs(ang0) < 10 ) || ( abs(imag(thisPt)/y_scale) < 0.03 ) )
        % Compute the closed-loop poles at the given gain.
        if Domain == 'z'
          this_gain = -1 / cplx_ol_mag;
          modalss = pzg_moda( 2, 1, 1, 0,'', 1 );
          if ~isempty(modalss)
            CLpoles = ...
              tzero( modalss.a, modalss.b, ...
                     modalss.c, modalss.d+1/this_gain ); 
          else
            N = poly( PZG(2).ZeroLocs ) * this_gain;
            P = [ PZG(2).PoleLocs; zeros(PZG(2).PureDelay,1) ];
            D = poly(P);
            D(end-numel(N)+1:end) =  D(end-numel(N)+1:end) + N;
            CLpoles = roots(D);
          end

          purejordan = 1;
          include_pade = 1;
          include_prvw = 1;
          design_modalss = ...
            pzg_moda( 2, purejordan, include_pade, include_prvw,'', 1 );
          dsn.AA = design_modalss.a;
          dsn.BC = design_modalss.b * design_modalss.c;
          dsn.DD = design_modalss.d;
          if this_gain == 0
            design_CLpoles = eig( dsn.AA );
          else
            design_CLpoles = eig( dsn.AA-dsn.BC/(dsn.DD+1/this_gain) );
          end
        else
          this_gain = -1 / cplx_ol_mag;
          modalss = pzg_moda( 1, 1, 1, 0,'', 1 );
          if ~isempty(modalss)
            CLpoles = ...
              tzero( modalss.a, modalss.b, ...
                     modalss.c, modalss.d+1/this_gain ); 
          else
            Z = PZG(1).ZeroLocs;
            P = PZG(1).PoleLocs;
            if PZG(1).PureDelay > 0
              this_gain = this_gain * PZG(1).pade.K;
              Z = [ Z; PZG(1).pade.Z ];
              P = [ P; PZG(1).pade.P ];
            end
            N = this_gain * poly(Z);
            D = poly(P);
            % Close the loop.
            D(end-numel(N)+1:end) =  D(end-numel(N)+1:end) + N;
            CLpoles = roots(D);
          end

          purejordan = 1;
          include_pade = 1;
          include_prvw = 1;
          design_modalss = ...
            pzg_moda( 1, purejordan, include_pade, include_prvw,'', 1 );
          dsn.AA = design_modalss.a;
          dsn.BC = design_modalss.b * design_modalss.c;
          dsn.DD = design_modalss.d;
          if this_gain == 0
            design_CLpoles = eig( dsn.AA );
          else
            design_CLpoles = eig( dsn.AA-dsn.BC/(dsn.DD+1/this_gain) );
          end
        end
        [ pole_dist, min_pole_ndx ] = ...
          min( sqrt( ( real(thisPt-CLpoles)/max(1,x_scale) ).^2 ...
                    +( imag(thisPt-CLpoles)/max(1,y_scale) ).^2 ) );

        if ~isempty(CLpoles) ...
          && ( ( pole_dist < 0.07 ) || ( abs(ang180) < 10 ) ) ...
          &&( min(abs(real(thisPt-CLpoles(min_pole_ndx))))/x_scale < 0.04 ) ...
          &&( min(abs(imag(thisPt-CLpoles(min_pole_ndx))))/y_scale < 0.04 )

          local_smallcirc_ptr( gcbf )

          [ temp, cursor_ndx ] = min( abs( CurrPt - CLpoles ) ); %#ok<ASGLU>
          this_CLpole = CLpoles(cursor_ndx);
          if Domain == 'z'
            this_S_CLpole = log(this_CLpole)/PZG(2).Ts;
          else
            this_S_CLpole = this_CLpole;
          end

          this_CLpole_zeta = ...
            -100*sign(real(this_S_CLpole)+eps) ...
               *cos(atan(abs( imag(this_S_CLpole)/real(this_S_CLpole) )));
          if Domain == 's'
            thisNatFrqHz = abs(this_CLpole)/2/pi;
          else
            thisNatFrqHz = abs( log(this_CLpole)/PZG(2).Ts )/2/pi;
          end
          DispStr = {['\zeta = ' num2str(this_CLpole_zeta,4) '%']; ...
                     ['{\it\omega_n}= ' num2str(thisNatFrqHz,4) ' Hz']};
          if imag(this_CLpole) > 0
            extra_line = ...
              {[ Domain '_o = ' num2str(real(this_CLpole),4) ...
                              ' + ' num2str(imag(this_CLpole),4)  'i']};
          elseif imag(this_CLpole) < 0
            extra_line = ...
              {[ Domain '_o = ' num2str(real(this_CLpole),4) ...
                              ' - ' num2str(abs(imag(this_CLpole)),4)  'i']};
          else
            extra_line = ...
              {[ Domain '_o = ' num2str(real(this_CLpole),4) ]};
          end
          DispStr = { extra_line{1}; ...
                      ['        ( ' DispStr{1} '     ' DispStr{2} ' )' ] };
          if Domain == 'z'
            cplx_ol_at_currpt = ...
              PZG(2).Gain * prod( this_CLpole - PZG(2).ZeroLocs ) ...
                          / prod( this_CLpole - PZG(2).PoleLocs );
          else
            cplx_ol_at_currpt = ...
              PZG(1).Gain * prod( this_CLpole - PZG(1).ZeroLocs ) ...
                          / prod( this_CLpole - PZG(1).PoleLocs );
            if PZG(1).PureDelay > 0
              cplx_ol_at_currpt = cplx_ol_at_currpt ...
                * PZG(1).pade.K * prod( this_CLpole - PZG(1).pade.Z ) ...
                / prod( this_CLpole - PZG(1).pade.P );
            end
          end
          cplx_ol_mag = abs(cplx_ol_at_currpt); 
          extra_line = ...
            {['G_O_L(' Domain '_o) = + ' num2str(cplx_ol_mag,4) ...
              ' =  +1 / ( ' num2str(1/cplx_ol_mag,4) ' )']};
          DispStr = [ DispStr; extra_line ];

          % Determine visibility of negative root locus.
          if strcmp( neg_loci_vis,'on')
            extra_line = ...
              {['Parameter K = -' num2str( 1/cplx_ol_mag, 4 ) ]; ...
                '  (NEGATIVE root locus)'};
            show_paramK_effect = -1/cplx_ol_mag;
            DispStr = [ extra_line; DispStr;{' '}];
            if numel(CLpoles) < 20
              marker_size = 12;
              line_width = 3;
            else
              marker_size = 10;
              line_width = 2.5;
            end
            if isempty(dg_h)
              hndl.dynamic_gain_marker = ...
                plot( real(CLpoles), imag(CLpoles), ...
                   'color','r', ...
                   'xdata', real(CLpoles), ...
                   'ydata', imag(CLpoles), ...
                   'linestyle','none', ...
                   'marker','s', ...
                   'linewidth', line_width, ...
                   'markersize', marker_size, ...
                   'parent', rl_ax_h, ...
                   'tag','dynamic gain marker');
            else
              set( dg_h,'visible','on', ...
                   'color','r', ...
                   'xdata', real(CLpoles), ...
                   'ydata', imag(CLpoles) );
            end
          else
            set( gcbf,'pointer','arrow')
            pzg_ptr
          end
        else
          set(dg_h,'visible','off');
        end
      else
        set( gcbf,'pointer','arrow');
        pzg_ptr
        if ~isempty(dg_h)
          set(dg_h,'visible','off');
        end
      end
      
      if ( show_paramK_effect == 0 ) || isempty(CLpoles)
        local_disp_paramK_effect('delete');
      else
        local_disp_paramK_effect( show_paramK_effect, CLpoles, design_CLpoles );
      end
      
    else
      if imag(CurrPt) > 0
        extra_line = ...
          {[ Domain '_o = ' ...
             num2str(real(CurrPt),4) ' + ' num2str(imag(CurrPt),4) 'i']};
      elseif imag(CurrPt) < 0
        extra_line = ...
          {[ Domain '_o = ' ...
             num2str(real(CurrPt),4) ' - ' num2str(abs(imag(CurrPt)),4)  'i']};
      else
        extra_line = {[ Domain '_o = ' num2str(real(CurrPt),4) ]};
      end
      DispStr = { extra_line{1}; ...
                  ['      ' DispStr{1} '     ' DispStr{2} ] };
      local_disp_paramK_effect('delete');
    end
    
    textH = pzg_fndo( dom_ndx, hndl.ploth_ndx,'damping_natural_freq_text');
    if isempty(textH)
      textH = findobj( AxH,'type','text','tag','damping & natural freq text');
      PZG(dom_ndx).plot_h{hndl.ploth_ndx}.hndl.damping_natural_freq_text ...
        = textH;
    end
    
    if isempty( strfind( DispStr{1},'Parameter') )
      set( gcbf,'pointer','arrow')
      pzg_ptr
    else
      local_smallcirc_ptr(gcbf)
    end
    
    if isempty(textH)
      if size(DispStr,1) == 2
        textH = text( 0.98*XLim(1)+0.02*XLim(2), 0.93*YLim(1)+0.07*YLim(2), ...
                      DispStr, ...
                      'tag','damping & natural freq text', ...
                      'parent', AxH );
      elseif size(DispStr,1) == 3
        textH = text( 0.98*XLim(1)+0.02*XLim(2), 0.88*YLim(1)+0.12*YLim(2), ...
                      DispStr, ...
                      'tag','damping & natural freq text', ...
                      'parent', AxH );
      else
        textH = text( 0.98*XLim(1)+0.02*XLim(2), 0.80*YLim(1)+0.20*YLim(2), ...
                      DispStr, ...
                      'tag','damping & natural freq text', ...
                      'parent', AxH );
      end
      
      fig0_h = get( AxH,'parent');
      if ~isempty( strfind( get(fig0_h,'name'),'-Time P/Z Map G.U.I.') )
        temp_ud = get( fig0_h,'userdata');
        temp_ud(10,1) = textH;
        set( fig0_h,'userdata', temp_ud );
      end
    else
      if numel(textH) > 1
        delete(textH(2:end))
        textH = textH(1);
      end
      fig0_h = get( AxH,'parent');
      temp_ud = get( fig0_h,'userdata');
      if isempty(temp_ud) || all(~ishandle(temp_ud(:)))
        return
      end
      temp_ud(10,1) = textH;
      set( fig0_h,'userdata', temp_ud );
      set( textH,'string', DispStr,'visible','on')
      textP = get( textH,'position');
      if size(DispStr,1) == 2
        if ( textP(1) ~= (0.98*XLim(1)+0.02*XLim(2)) ) ...
          ||( textP(2) ~= (0.93*YLim(1)+0.07*YLim(2)) )
          set( textH,'position',[ 0.98*XLim(1)+0.02*XLim(2), ...
                                  0.93*YLim(1)+0.07*YLim(2), 0 ] )
        end
      elseif size(DispStr,1) == 3
        if ( textP(1) ~= (0.98*XLim(1)+0.02*XLim(2)) ) ...
          ||( textP(2) ~= (0.88*YLim(1)+0.12*YLim(2)) )
          set( textH,'position',[ 0.98*XLim(1)+0.02*XLim(2), ...
                                  0.88*YLim(1)+0.12*YLim(2), 0 ] )
        end
      else
        if ( textP(1) ~= (0.98*XLim(1)+0.02*XLim(2)) ) ...
          ||( textP(2) ~= (0.88*YLim(1)+0.12*YLim(2)) )
          set( textH,'position',[ 0.98*XLim(1)+0.02*XLim(2), ...
                                  0.80*YLim(1)+0.20*YLim(2), 0 ] )
        end
      end
    end
    if isequal( get(get(textH,'parent'),'color'), [1 1 1] )
      set( textH,'fontsize', 12,'fontweight','bold','color',[0 0 0])
    else
      set( textH,'fontsize', 12,'fontweight','bold','color',[1 1 1])
    end
    if numel(DispStr) >= 5
      % Change the fontsize of the first line
      str1 = DispStr{1};
      str1 = ['\fontsize{16}' str1 '\fontsize{12}'];
      DispStr{1} = str1;
      set( textH,'string', DispStr );      
      %set( textH,'fontsize', 16 )
      if ~isempty( strfind( DispStr{2},'NEGATIVE') )
        str2 = DispStr{2};
        str2 = ['\fontsize{14}' str2 '\fontsize{12}'];
        DispStr{2} = str2;
        set( textH,'string', DispStr,'color','r');
      end
    else
      set( textH,'fontsize', 12 )
    end
  else
    if isfield( hndl,'damping_natural_freq_text');
      textH = hndl.damping_natural_freq_text;
    else
      textH = findobj( AxH,'type','text','tag','damping & natural freq text');
    end
    if ~isempty(textH)
      textS = get(textH,'string');
      if ~isempty(textS)
        set(textH,'string','','visible','on')
      end
    end
    rloc_dg_h = findobj( AxH,'type','line','tag','dynamic gain marker');
    if ~isempty(rloc_dg_h)
      set( rloc_dg_h,'visible','off');
      set( gcbf,'pointer','arrow');
    end
    local_disp_paramK_effect('delete');
  end
  
case 'dB checkbox'
  % Open and closed loop Bode magnitude plots are affected.
  db_cb_val = get(GCBO,'value');
  db_cb_h = pzg_fndo( (1:2),[1;3],'BodeDBChkbox');
  set( db_cb_h,'value', db_cb_val );
  
  for kd = 1:2
    for kp = 1:2:3
      magax_h = pzg_fndo( kd, kp,'ax_h');
      if isempty(magax_h)
        continue
      end
      mag_ylabel_h = pzg_fndo( kd, kp,'ax_ylabel');
      unity_gain_h = pzg_fndo( kd, kp,'unity_gain_line');
      zero_gain_h = pzg_fndo( kd, kp,'zero_gain_line');
      if db_cb_val
        set( mag_ylabel_h,'string','Magnitude (dB)');
        if ~isempty(zero_gain_h)
          set( zero_gain_h,'visible','off')
        end
        if ~isempty(unity_gain_h)
          set( unity_gain_h,'ydata', zeros(size(get(unity_gain_h,'ydata'))) );
        end
      else
        set( mag_ylabel_h,'string','Magnitude (NOT in dB)');
        if ~isempty(zero_gain_h)
          set( zero_gain_h,'visible','on')
        end
        if ~isempty(unity_gain_h)
          set( unity_gain_h,'ydata', ones(size(get(unity_gain_h,'ydata'))));
        end
      end
    end
  end
  
  for dndx = 1:2
    for fndx = [1 3]
      if ~isempty( PZG(dndx).plot_h{fndx} ) ...
        && isfield( PZG(dndx).plot_h{fndx},'ax_h')
        LineH = ...
          [ PZG(dndx).plot_h{fndx}.hndl.Bode_Line; ...
            PZG(dndx).plot_h{fndx}.hndl.Bode_DT_negfreq_Line(:); ...
            PZG(dndx).plot_h{fndx}.hndl.TFE_Mag_line; ...
            PZG(dndx).plot_h{fndx}.hndl.TFE_Delta_Mag_line; ...
            PZG(dndx).plot_h{fndx}.hndl.Bode_selection_marker ];
        curr_tools = pzg_tools;
        if curr_tools(1)
          tool_h = PZG(dndx).plot_h{fndx}.hndl.Gain_Preview;
        elseif curr_tools(2)
          tool_h = PZG(dndx).plot_h{fndx}.hndl.LDLG_Preview;
        elseif curr_tools(3)
          tool_h = PZG(dndx).plot_h{fndx}.hndl.PID_Preview;          
        else
          tool_h = [];
        end
        for Lk = 1:numel(LineH)
          if isequal( 1, ishandle(LineH(Lk)) ) ...
            && strcmp( get(LineH(Lk),'type'),'line')
            ydata = get( LineH(Lk),'ydata');
            if db_cb_val
              set( LineH(Lk),'ydata',20*log10(ydata) );
            else
              set( LineH(Lk),'ydata',10.^(ydata/20) );
            end
          end
        end
        for Lk = 1:numel(tool_h)
          ydata = get( LineH(Lk),'ydata');
          if db_cb_val
            set( LineH(Lk),'ydata',20*log10(ydata) );
          else
            set( LineH(Lk),'ydata',10.^(ydata/20) );
          end
        end
        unitygain_h = PZG(dndx).plot_h{fndx}.hndl.unity_gain_line;
        set( unitygain_h,'visible','off');
        ax_h = PZG(dndx).plot_h{fndx}.ax_h;
        set( ax_h,'ylimmode','auto');
        y_lim = get( ax_h,'ylim');
        set( ax_h,'ylimmode','manual');
        set( unitygain_h,'visible','on');
        PZG(dndx).plot_h{fndx}.ylim = y_lim;
        PZG(dndx).plot_h{fndx}.hndl.ax_ylim = y_lim;
        this_hndl = getappdata( PZG(dndx).plot_h{fndx}.fig_h,'hndl');
        this_hndl.ax_ylim = y_lim;
        setappdata( PZG(dndx).plot_h{fndx}.fig_h,'hndl', this_hndl );
      end
    end
  end
  
case 'Hz checkbox'
  Hzcb_val = get(gcbo,'value');
  if Hzcb_val
    xlabel_str = 'Frequency (hertz)';
  else
    xlabel_str = 'Frequency (rad/s)';
  end
  
  for dndx = 1:2
    dsn_tools = pzg_tools(dndx);
    dsn_vis = 'off';
    if any(dsn_tools)
      if dsn_tools(1)
        dsnslider_h = findobj( PZG(dndx).Gain_fig,'style','slider');
      elseif dsn_tools(2)
        dsnslider_h = findobj( PZG(dndx).LDLG_fig,'style','slider');
      elseif dsn_tools(3)
        dsnslider_h = findobj( PZG(dndx).PID_fig,'style','slider');
      end
      if ~isempty(dsnslider_h)
        dsn_vis = get( dsnslider_h,'visible');
      end
    end
    
    for kndx = 1:5
      tempAx = pzg_fndo( dndx, kndx,'ax_h');
      if isempty(tempAx)
        continue
      end
      set( PZG(dndx).plot_h{kndx}.hndl.BodeHZChkbox,'value', Hzcb_val );
      PZG(dndx).plot_h{kndx}.Hz_cb = Hzcb_val;
      
      if kndx < 3
        min_freq = PZG(dndx).BodeFreqs(1);
        max_freq = PZG(dndx).BodeFreqs(end);
      else
        min_freq = PZG(dndx).CLBodeFreqs(1);
        max_freq = PZG(dndx).CLBodeFreqs(end);
      end
      tempXLim = get( tempAx,'xlim');
      if Hzcb_val
        new_xlim = tempXLim/2/pi;
        new_xlim(1) = max( new_xlim(1), min_freq/2/pi );
        new_xlim(2) = min( new_xlim(2), max_freq/2/pi );
      else
        new_xlim = tempXLim*2*pi;
        new_xlim(1) = max( new_xlim(1), min_freq );
        new_xlim(2) = min( new_xlim(2), max_freq );
      end
      set( tempAx,'xlim', new_xlim );
      set( PZG(dndx).plot_h{kndx}.hndl.ax_xlabel,'string', xlabel_str );
      PZG(dndx).plot_h{kndx}.xlim = new_xlim;
      PZG(dndx).plot_h{kndx}.hndl.ax_xlim = new_xlim;
      this_hndl = getappdata( PZG(dndx).plot_h{kndx}.fig_h,'hndl');
      this_hndl.ax_xlim = new_xlim;
      setappdata( PZG(dndx).plot_h{kndx}.fig_h,'hndl', this_hndl );
      
      tempLineH = pzg_fndo( dndx, kndx,'Bode_selection_marker');
      for Mk = 1:numel(tempLineH)
        tempX = get(tempLineH(Mk),'xdata');
        if ~isempty(tempX)
          if Hzcb_val
            tmpFrq = tempX/(2*pi);
          else
            tmpFrq = tempX*2*pi;
          end
          set( tempLineH(Mk),'xdata', tmpFrq );
          pzg_seltxt(dndx);
        end
      end

      if any(dsn_tools)
        if dsn_tools(1)
          dsnline_h = pzg_fndo( dndx, kndx,'Gain_Preview');
        elseif dsn_tools(2)
          dsnline_h = pzg_fndo( dndx, kndx,'LDLG_Preview');
        elseif dsn_tools(3)
          dsnline_h = pzg_fndo( dndx, kndx,'PID_Preview');
        end
        if Hzcb_val
          for k = 1:numel(dsnline_h)
            tempX = get( dsnline_h(k),'xdata');
            if isequal( numel(tempX), numel(PZG(dndx).BodeFreqs) )
              set( dsnline_h(k), ...
                  'xdata', PZG(dndx).BodeFreqs/(2*pi), ...
                  'visible', dsn_vis );
            elseif isequal( numel(tempX), numel(PZG(dndx).CLBodeFreqs) )
              set( dsnline_h(k), ...
                  'xdata', PZG(dndx).CLBodeFreqs/(2*pi), ...
                  'visible', dsn_vis );
            else
              set( dsnline_h(k),'xdata', tempX/(2*pi),'visible', dsn_vis );
            end
          end
        else
          for k = 1:numel(dsnline_h)
            tempX = get( dsnline_h(k),'xdata');
            if isequal( numel(tempX), numel(PZG(dndx).BodeFreqs) )
              set( dsnline_h(k), ...
                  'xdata', PZG(dndx).BodeFreqs, ...
                  'visible', dsn_vis );
            elseif isequal( numel(tempX), numel(PZG(dndx).CLBodeFreqs) )
              set( dsnline_h(k), ...
                  'xdata', PZG(dndx).CLBodeFreqs, ...
                  'visible', dsn_vis );
            else
              set( dsnline_h(k),'xdata', tempX*(2*pi),'visible', dsn_vis );
            end
          end
        end
      end
        
      tempLineH = ...
        [ pzg_fndo( dndx, kndx,'Bode_Line'); ...
          pzg_fndo( dndx, kndx,'Bode_DT_negfreq_Line') ];
      for Mk = 1:numel(tempLineH)
        if isequal( 1, ishandle(tempLineH(Mk)) ) ...
          && strcmp( get(tempLineH(Mk),'type'),'line')
          tempX = get( tempLineH(Mk),'xdata');
          if Hzcb_val
            set( tempLineH(Mk),'xdata', tempX/(2*pi) );
          else
            set( tempLineH(Mk),'xdata', tempX*(2*pi) );
          end
        end
      end
      
      if ( kndx ~= 2 ) && ( kndx ~= 4 )
        unity_gain_line_h = pzg_fndo( dndx, kndx,'unity_gain_line');
        if ( kndx == 5 ) || PZG(dndx).plot_h{kndx}.dB_cb
          unity_y = [0 0];  % unity is zero dB
        else
          unity_y = [1 1];  % unity is 1
        end
        set( unity_gain_line_h,'xdata', new_xlim,'ydata', unity_y );
      else
        phsline_h = pzg_fndo( dndx, kndx,'positive_180degree_line');
        set( phsline_h,'xdata', new_xlim,'ydata',[180 180]);
        phsline_h = pzg_fndo( dndx, kndx,'zero_degree_line');
        set( phsline_h,'xdata', new_xlim,'ydata',[0 0]);
        phsline_h = pzg_fndo( dndx, kndx,'negative_180degree_line');
        set( phsline_h,'xdata', new_xlim,'ydata',[-180 -180]);
      end
      
      TFE_LineH = ...
        [ pzg_fndo( dndx, kndx,'TFE Mag line'); ...
          pzg_fndo( dndx, kndx,'TFE_Delta_Mag_line'); ...
          pzg_fndo( dndx, kndx,'TFE Phs line'); ...
          pzg_fndo( dndx, kndx,'TFE_Delta_Phs_line') ];
      if isempty( PZG(dndx).TFEMag )
        for tfendx = 1:numel(TFE_LineH)
          set( TFE_LineH(tfendx),'xdata',[],'ydata',[],'visible','off');
        end
      else
        if Hzcb_val
          for tfendx = 1:numel(TFE_LineH)
            set( TFE_LineH(tfendx),'xdata', PZG(dndx).TFEFreqs/2/pi );
          end
        else
          for tfendx = 1:numel(TFE_LineH)
            set( TFE_LineH(tfendx),'xdata', PZG(dndx).TFEFreqs );
          end
        end
      end
    end
  end
  
  if ~isempty(PZG(1).FrqSelNdx) || ~isempty(PZG(2).FrqSelNdx)
    freqserv('refresh selected_freq');
  end
  
  pzg_seltxt(1)
  pzg_seltxt(2)

case 'Log checkbox'
  Log_cb_val = get( gcbo,'Value');
  if Log_cb_val
    scale_str = 'log';
  else
    scale_str = 'linear';
  end
  for dndx = 1:2
    for fndx = 1:5
      if ~isempty( PZG(dndx).plot_h{fndx} ) ...
        && isfield( PZG(dndx).plot_h{fndx},'hndl')
        set( PZG(dndx).plot_h{fndx}.hndl.BodeAxesLinLogChkbox, ...
            'value', Log_cb_val );
        set( PZG(dndx).plot_h{fndx}.ax_h,'xscale', scale_str );
        PZG(dndx).plot_h{fndx}.Log_cb = Log_cb_val;
      end
    end
  end
  
case 'unwrap checkbox'
  % Set all unwrap checkboxes equal to this one.
  unwrap_val = get( gcbo,'value');
  unwrap_cb_h = pzg_fndo( (1:2),[2;4],'UnwrapChkbox');
  set( unwrap_cb_h,'value', unwrap_val );
  if ~isempty( pzg_fndo( 1,[(1:10),12,14],'fig_h') )
    updatepl
  end
  if ~isempty( pzg_fndo( 2,[(1:9),11,13,14],'fig_h') )
    dupdatep
  end
  if unwrap_val == 1
    % Set all phase plot y-axes limit modes to "auto"
    for dndx = 1:2
      for pndx = [2 4]
        phsax_h = pzg_fndo( dndx, pndx,'ax');
        if isempty(phsax_h)
          continue
        end
        set( phsax_h,'ylimmode','auto');
        y_lim = get( phsax_h,'ylim');
        tfig_h = pzg_fndo( dndx, pndx,'fig_h');
        thndl = getappdata( tfig_h,'hndl');
        thndl.ax_ylim = y_lim;
        setappdata( tfig_h,'hndl', thndl );
        PZG(dndx).plot_h{pndx}.ylim = y_lim;
        PZG(dndx).plot_h{pndx}.hndl.ax_ylim = y_lim;
        set( phsax_h,'ylimmode','manual');
      end
    end
  end
end

return

function  local_smallcirc_ptr( GCBF )

zoom_hotspot = [6 6];
zoom_cdata = ...
  [ NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
    NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
    NaN NaN NaN NaN  2   2   2   2  NaN NaN NaN NaN NaN NaN NaN NaN
    NaN NaN NaN NaN  2   1   1   2  NaN NaN NaN NaN NaN NaN NaN NaN
    NaN NaN  2   2  NaN  1   1  NaN  2   2  NaN NaN NaN NaN NaN NaN
    NaN NaN  2   1   1  NaN NaN  1   1   2  NaN NaN NaN NaN NaN NaN
    NaN NaN  2   1   1  NaN NaN  1   1   2  NaN NaN NaN NaN NaN NaN
    NaN NaN  2   2  NaN  1   1  NaN  2   2  NaN NaN NaN NaN NaN NaN
    NaN NaN NaN NaN  2   1   1   2  NaN NaN NaN NaN NaN NaN NaN NaN
    NaN NaN NaN NaN  2   2   2   2  NaN NaN NaN NaN NaN NaN NaN NaN
    NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
    NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
    NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
    NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
    NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN
    NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN NaN  ];

set( GCBF, ...
    'pointershapecdata', zoom_cdata, ...
    'pointershapehotspot', zoom_hotspot, ...
    'pointer','custom');

return

function local_disp_paramK_effect( ReqStr, CLpoles, design_CLpoles )
  global PZG
  
  if nargin < 2
    CLpoles = [];
  end
  if nargin < 3
    design_CLpoles = [];
  end
  
  ln_styl = '-.';
  ln_widt = 1;
  
  if ischar(ReqStr) || isempty(gcbf) ...
    || ~isequal( 1, numel(ReqStr) ) ...
    || isequal( 0, ReqStr )
    pkeff_line_h = ...
      [ pzg_fndo( 1,[(1:10),12,14],'parameter_K_effect_line'); ...
        pzg_fndo( 2,[(1:9),11,13,14],'parameter_K_effect_line') ];
    if ~isempty(pkeff_line_h )
     set( pkeff_line_h,'visible','off');
    end
    pkeff_line_h = ...
      [ pzg_fndo( 1,[(1:10),12,14],'parameter_K_effect_prvw_line'); ...
        pzg_fndo( 2,[(1:9),11,13,14],'parameter_K_effect_prvw_line') ];
    if ~isempty(pkeff_line_h )
     set( pkeff_line_h,'visible','off');
    end
    
  elseif isreal(ReqStr)
    % Compute the open-loop and closed-loop FRF
    % with the specified additional gain, "Parameter K".
    unstable_CLpoles = 0;
    unstable_design_CLpoles = 0;
    if isempty( strfind( get( gcbf,'name'),'Discrete') )
      dom_ndx = 1;
      if any( real(CLpoles) > 1e-8 )
        unstable_CLpoles = 1;
      end
      if any( real(design_CLpoles) > 1e-8 )
        unstable_design_CLpoles = 1;
      end
    else
      dom_ndx = 2;
      if any( abs(CLpoles) > (1+1e-8) )
        unstable_CLpoles = 1;
      end
      if any( abs(design_CLpoles) > (1+1e-8) )
        unstable_design_CLpoles = 1;
      end
    end
    paramK = ReqStr;
    
    [ curr_tools, toolfig_h, preview_on ] = pzg_tools(dom_ndx); %#ok<ASGLU>
    Gain_prvw = curr_tools(1);
    LDLG_prvw = curr_tools(2);
    PID_prvw = curr_tools(3);
    if Gain_prvw
      design_txt = 'Gain_Preview';
    elseif LDLG_prvw
      design_txt = 'LDLG_Preview';
    elseif PID_prvw
      design_txt = 'PID_Preview';
    end
    %if preview_on
    %  prvw_vis = 'on';
    %else
    %  prvw_vis = 'off';
    %end

    if any(curr_tools)
      % Update the root-locus plot:  the design-CL locations
      RLploth = PZG(dom_ndx).plot_h{9+dom_ndx};
      if isfield(RLploth,'hndl')
        this_hndl = RLploth.hndl;
      else
        this_hndl = getappdata( RLploth.fig_h,'hndl');
      end
      if isfield( this_hndl,'parameter_K_effect_line')
        pK_line_h = this_hndl.parameter_K_effect_line;
      else
        pK_line_h = [];
      end
      if max(get(RLploth.ax_h,'color')) < 0.5
        marker_color = [0.8 0.8 0.8];
      else
        marker_color = [0.4 0.4 0.4];
      end
      if isequal( 1, ishandle(pK_line_h) )
        set( pK_line_h, ...
            'xdata', real(design_CLpoles), ...
            'ydata', imag(design_CLpoles), ...
            'linestyle','none', ...
            'linewidth', 3, ...
            'color', marker_color, ...
            'marker','s', ...
            'markersize', 8, ...
            'visible','on');
      else
        delete(pK_line_h)
        if ~isempty(design_CLpoles)
          pK_line_h = ...
            plot(real(design_CLpoles), imag(design_CLpoles), ...
              'color', marker_color, ...
              'linestyle','none', ...
              'marker','s', ...
              'markersize', 8, ...
              'linewidth', 3, ...
              'parent', RLploth.ax_h, ...
              'tag','parameter K effect line');
        else
          pK_line_h = ...
            plot( 0, 0, ...
              'color', marker_color, ...
              'linestyle','none', ...
              'marker','s', ...
              'markersize', 8, ...
              'linewidth', 3, ...
              'parent', RLploth.ax_h, ...
              'tag','parameter K effect line');
          set( pK_line_h,'xdata',[],'ydata',[]);
        end
        PZG(1).plot_h{9+dom_ndx}.hndl.parameter_K_effect_line = pK_line_h;
        PZG(2).plot_h{9+dom_ndx}.hndl.parameter_K_effect_line = pK_line_h;
      end
    else
      
    end
    
    % Update the Open-Loop FRF magnitude plot
    if ~isempty( PZG(dom_ndx).plot_h{1} ) ...
      && isfield( PZG(dom_ndx).plot_h{1},'ax_h') ...
      && isequal( 1, ishandle( PZG(dom_ndx).plot_h{1}.ax_h ) )
      bode_line_h = pzg_fndo( dom_ndx, 1,'Bode_Line');
      xdata = get( bode_line_h(1),'xdata');
      ydata = get( bode_line_h(1),'ydata');
      if PZG(dom_ndx).plot_h{1}.dB_cb
        ydata = ydata + 20*log10( abs(paramK) );
      else
        ydata = ydata * abs(paramK);
      end
      if isfield( PZG(dom_ndx).plot_h{1},'hndl')
        this_hndl = PZG(dom_ndx).plot_h{1}.hndl;
      else
        this_hndl = [];
      end
      if isfield( this_hndl,'parameter_K_effect_line')
        pK_line_h = this_hndl.parameter_K_effect_line;
      else
        pK_line_h = [];
      end
      if isempty(pK_line_h) || ~isequal( 1, ishandle(pK_line_h) )
        pK_line_h = ...
          plot( xdata, ydata, ...
            'linestyle',ln_styl, ...
            'linewidth', ln_widt, ...
            'color', [1 0 0], ...
            'parent', PZG(dom_ndx).plot_h{1}.ax_h, ...
            'tag','parameter K effect line');
        PZG(dom_ndx).plot_h{1}.hndl.parameter_K_effect_line = pK_line_h;
      else
        set( pK_line_h, ...
          'xdata', xdata, ...
          'ydata', ydata, ...
          'linestyle',ln_styl, ...
          'linewidth', ln_widt, ...
          'color', [1 0 0], ...
          'visible','on');
      end
      
      pK_line_h = pzg_fndo( dom_ndx, 1,'parameter_K_effect_prvw_line');
      if any( curr_tools ) && preview_on
        bode_line_h = pzg_fndo( dom_ndx, 1, design_txt );
        if isempty(bode_line_h)
          if ~isempty(pK_line_h)
            set( pK_line_h,'visible','off');
          end
        else
          if curr_tools(1)
            xdata = get( bode_line_h(1),'xdata');
            ydata = get( bode_line_h(1),'ydata');
          else
            xdata = get( bode_line_h(2),'xdata');
            ydata = get( bode_line_h(2),'ydata');
          end
          if PZG(dom_ndx).plot_h{1}.dB_cb
            ydata = ydata + 20*log10( abs(paramK) );
          else
            ydata = ydata * abs(paramK);
          end
          if isequal( 1, ishandle(pK_line_h) )
            set( pK_line_h, ...
                'xdata', xdata, ...
                'ydata', ydata, ...
                'linestyle',ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [1 0 1], ...
                'visible','on');
          else
            delete(pK_line_h)
            pK_line_h = ...
              plot( xdata, ydata, ...
                 'linestyle',ln_styl, ...
                 'linewidth', ln_widt, ...
                 'color', [1 0 1], ...
                 'parent', PZG(dom_ndx).plot_h{1}.ax_h, ...
                 'tag','parameter K effect prvw line');
            PZG(dom_ndx).plot_h{1}.hndl.parameter_K_effect_prvw_line =pK_line_h;
          end
        end
      else
        if ~isempty(pK_line_h)
          set( pK_line_h,'visible','off');
        end
      end
    end
    
    % Update the Open-Loop FRF phase plot
    if ~isempty( PZG(dom_ndx).plot_h{2} ) ...
      && isfield( PZG(dom_ndx).plot_h{2},'ax_h')
      bode_line_h = pzg_fndo( dom_ndx, 2,'Bode_Line');
      xdata = get( bode_line_h(1),'xdata');
      ydata = get( bode_line_h(1),'ydata');
      if paramK < 0
        ydata = ydata - 180;
        if ~PZG(dom_ndx).plot_h{2}.unwrap_cb
          ydata = angle( exp( 1i*ydata/180*pi ) )/pi*180;
        end
      end
      if isfield( PZG(dom_ndx).plot_h{2},'hndl')
        this_hndl = PZG(dom_ndx).plot_h{2}.hndl;
      else
        this_hndl = [];
      end
      if isfield( this_hndl,'parameter_K_effect_line')
        pK_line_h = this_hndl.parameter_K_effect_line;
      else
        pK_line_h = [];
      end
      if isempty(pK_line_h) || ~isequal( 1, ishandle(pK_line_h) )
        delete(pK_line_h)
        pK_line_h = ...
          plot( xdata, ydata, ...
             'linestyle',ln_styl, ...
             'linewidth', ln_widt, ...
             'color', [1 0 0], ...
             'parent', PZG(dom_ndx).plot_h{2}.ax_h, ...
             'tag','parameter K effect line');
        PZG(dom_ndx).plot_h{2}.hndl.parameter_K_effect_line = pK_line_h;
      else
        set( pK_line_h, ...
            'xdata', xdata, ...
            'ydata', ydata, ...
            'linestyle',ln_styl, ...
            'linewidth', ln_widt, ...
            'color', [1 0 0], ...
            'visible','on');
      end
      
      pK_line_h = pzg_fndo( dom_ndx, 2,'parameter_K_effect_prvw_line');
      if any( curr_tools ) && ( paramK < 0 )
        bode_line_h = pzg_fndo( dom_ndx, 2, design_txt );
        if isempty(bode_line_h)
          if ~isempty(pK_line_h)
            set( pK_line_h,'visible','off');
          end
        else
          if curr_tools(1)
            xdata = get( bode_line_h(1),'xdata');
            ydata = get( bode_line_h(1),'ydata');
          else
            xdata = get( bode_line_h(2),'xdata');
            ydata = get( bode_line_h(2),'ydata');
          end
          ydata = ydata - 180;
          if ~PZG(dom_ndx).plot_h{2}.unwrap_cb
            ydata = angle( exp( 1i*ydata/180*pi ) )/pi*180;
          end
          if isempty(pK_line_h) || ~isequal( 1, ishandle(pK_line_h) )
            delete(pK_line_h)
            pK_line_h = ...
              plot( xdata, ydata, ...
                 'linestyle', ln_styl, ...
                 'linewidth', ln_widt, ...
                 'color', [1 0 1], ...
                 'parent', PZG(dom_ndx).plot_h{2}.ax_h, ...
                 'tag','parameter K effect prvw line');
            PZG(dom_ndx).plot_h{2}.hndl.parameter_K_effect_prvw_line =pK_line_h;
          else
            set( pK_line_h, ...
                'xdata', xdata, ...
                'ydata', ydata, ...
                'linestyle', ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [1 0 1], ...
                'visible','on');
          end
        end
      else
        if ~isempty(pK_line_h)
          set( pK_line_h,'visible','off');
        end
      end
    end
      
    if ~isempty( pzg_fndo( dom_ndx,(3:5),'fig_h') )
      olfrf_data = paramK * PZG(dom_ndx).cntr_data.bode2nyq_pts;
      sens_data = 1 ./ (1+olfrf_data);
      clfrf_data = olfrf_data .* sens_data;
      if any( curr_tools ) && preview_on
        design_olfrf_data = olfrf_data;
        design_olfrf_freqs = PZG(dom_ndx).cntr_data.bode2nyq_freqs;
        if Gain_prvw
          design_olfrf_data = PZG(dom_ndx).puregain * design_olfrf_data;
        elseif LDLG_prvw
          dZ = PZG(dom_ndx).LeadLag{6};
          dP = PZG(dom_ndx).LeadLag{5};
          dK = PZG(dom_ndx).LeadLag{4};
          if ~isempty(dZ) || isreal(dZ) ...
            || ~isinf(dZ) || ~isnan(dZ) || ( dZ <= 0 ) ...
            || ~isempty(dP) || isreal(dP) ...
            || ~isinf(dP) || ~isnan(dP) || ( dP <= 0 ) ...
            || ~isempty(dK) || isreal(dK) ...
            || ~isinf(dK) || ~isnan(dK) || ( dK > 0 )
            design_olfrf_data = dK * design_olfrf_data;
            if dom_ndx == 1
              design_olfrf_data = ...
                design_olfrf_data ...
                .*( 1i*design_olfrf_freqs - dZ ) ...
                ./( 1i*design_olfrf_freqs - dP );
            else
              uc_pts = exp( 1i*design_olfrf_freqs*PZG(2).Ts );
              design_olfrf_data = ...
                design_olfrf_data .*( uc_pts - dZ ) ./( uc_pts - dP );
            end
          end
        else
          dZ = [ PZG(dom_ndx).PID{5}; PZG(dom_ndx).PID{6} ];
          dP = [ 0; PZG(dom_ndx).PID{7}];
          dK = PZG(dom_ndx).PID{4};
          design_olfrf_data = dK * design_olfrf_data;
          if dom_ndx == 1
            design_olfrf_data = ...
              ( design_olfrf_data * abs(dP(2)) ) ...
              .*( 1i*design_olfrf_freqs - dZ(1) ) ...
              .*( 1i*design_olfrf_freqs - dZ(2) ) ...
              ./( ( 1i*design_olfrf_freqs - dP(2) ) ...
                 .*( 1i*design_olfrf_freqs ) );
          else
            uc_pts = exp( 1i*design_olfrf_freqs*PZG(2).Ts );
            design_olfrf_data = ...
              design_olfrf_data ...
              .*( uc_pts - dZ(1) ) .*( uc_pts - dZ(2) ) ...
              ./( ( uc_pts ) .* ( uc_pts - 1 ) );
          end
        end
        design_sens_data = 1 ./ (1+design_olfrf_data);
        design_clfrf_data = design_olfrf_data .* design_sens_data;
      end
    end
    
    % Update the Closed-Loop FRF magnitude plot
    if ~isempty( PZG(dom_ndx).plot_h{3} ) ...
      && isfield( PZG(dom_ndx).plot_h{3},'ax_h')
      pK_line_h = pzg_fndo( dom_ndx, 3,'parameter_K_effect_line');
      if unstable_CLpoles
        if ~isempty(pK_line_h)
          set(pK_line_h,'visible','off')
        end
      else
        xdata = PZG(dom_ndx).cntr_data.bode2nyq_freqs;
        ydata = abs( clfrf_data );
        if PZG(dom_ndx).plot_h{3}.dB_cb
          ydata = 20*log10( ydata );
        end
        if PZG(dom_ndx).plot_h{3}.Hz_cb
          xdata = xdata/(2*pi);
        end
        if numel(xdata) == numel(ydata)
          if isempty(pK_line_h) || ~isequal( 1, ishandle(pK_line_h) )
            delete(pK_line_h)
            pK_line_h = ...
              plot( xdata, ydata, ...
                 'linestyle', ln_styl, ...
                 'linewidth', ln_widt, ...
                 'color', [1 0 0], ...
                 'parent', PZG(dom_ndx).plot_h{3}.ax_h, ...
                 'tag','parameter K effect line');
            PZG(dom_ndx).plot_h{3}.hndl.parameter_K_effect_line = pK_line_h;
          else
            set( pK_line_h, ...
                'xdata', xdata, ...
                'ydata', ydata, ...
                'linestyle', ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [1 0 0], ...
                'visible','on');
          end
        else
          if ~isempty(pK_line_h)
            set( pK_line_h,'visible','off');
          end
        end
      end
      
      pK_line_h = pzg_fndo( dom_ndx, 3,'parameter_K_effect_prvw_line');
      if any( curr_tools ) && preview_on
        if unstable_design_CLpoles
          if ~isempty(pK_line_h)
            set(pK_line_h,'visible','off')
          end
        else
          xdata = PZG(dom_ndx).cntr_data.bode2nyq_freqs;
          ydata = abs( design_clfrf_data );
          if PZG(dom_ndx).plot_h{3}.dB_cb
            ydata = 20*log10( ydata );
          end
          if PZG(dom_ndx).plot_h{3}.Hz_cb
            xdata = xdata/(2*pi);
          end
          if isempty(pK_line_h) || ~isequal( 1, ishandle(pK_line_h) )
            delete(pK_line_h)
            pK_line_h = ...
              plot( xdata, ydata, ...
                 'linestyle', ln_styl, ...
                 'linewidth', ln_widt, ...
                 'color', [1 0 1], ...
                 'parent', PZG(dom_ndx).plot_h{3}.ax_h, ...
                 'tag','parameter K effect prvw line');
            PZG(dom_ndx).plot_h{3}.hndl.parameter_K_effect_prvw_line = ...
              pK_line_h;
          else
            set( pK_line_h, ...
                'xdata', xdata, ...
                'ydata', ydata, ...
                'linestyle', ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [1 0 1], ...
                'visible','on');
          end
        end
      else
        if ~isempty(pK_line_h)
          set( pK_line_h,'visible','off');
        end
      end
    end
        
    % Update the Closed-Loop FRF phase plot
    if ~isempty( PZG(dom_ndx).plot_h{4} ) ...
      && isfield( PZG(dom_ndx).plot_h{4},'ax_h')
      pK_line_h = pzg_fndo( dom_ndx, 4,'parameter_K_effect_line');
      if unstable_CLpoles
        if ~isempty(pK_line_h)
          set(pK_line_h,'visible','off')
        end
      else
        xdata = PZG(dom_ndx).cntr_data.bode2nyq_freqs;
        if PZG(dom_ndx).plot_h{4}.Hz_cb
          xdata = xdata/(2*pi);
        end
        ydata = angle( clfrf_data );
        if PZG(dom_ndx).plot_h{4}.unwrap_cb
          ydata = unwrap(ydata);
        end
        ydata = 180/pi*ydata;
        if numel(xdata) == numel(ydata)
          if isequal( 1, ishandle(pK_line_h) ) ...
            && ( numel(xdata) == numel(ydata) )
            set( pK_line_h, ...
                'xdata', xdata, ...
                'ydata', ydata, ...
                'linestyle',ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [1 0 0], ...
                'visible','on');
          else
            delete(pK_line_h)
            pK_line_h = ...
              plot( xdata, ydata, ...
                 'linestyle',ln_styl, ...
                 'linewidth', ln_widt, ...
                 'color', [1 0 0], ...
                 'parent', PZG(dom_ndx).plot_h{4}.ax_h, ...
                 'tag','parameter K effect line');
            PZG(dom_ndx).plot_h{4}.hndl.parameter_K_effect_line = ...
              pK_line_h;
          end
        else
          if ~isempty(pK_line_h)
            set( pK_line_h,'visible','off');
          end
        end
      end
      
      pK_line_h = pzg_fndo( dom_ndx, 4,'parameter_K_effect_prvw_line');
      if any( curr_tools ) && preview_on
        if unstable_design_CLpoles
          if ~isempty(pK_line_h)
            set(pK_line_h,'visible','off')
          end
        else
          xdata = PZG(dom_ndx).cntr_data.bode2nyq_freqs;
          if PZG(dom_ndx).plot_h{4}.Hz_cb
            xdata = xdata/(2*pi);
          end
          ydata = angle( design_clfrf_data );
          if PZG(dom_ndx).plot_h{4}.unwrap_cb
            ydata = unwrap( ydata );
          end
          ydata = 180/pi*ydata;
          if isempty(pK_line_h) || ~isequal( 1, ishandle(pK_line_h) )
            delete(pK_line_h)
            pK_line_h = ...
              plot( xdata, ydata, ...
                 'linestyle', ln_styl, ...
                 'linewidth', ln_widt, ...
                 'color', [1 0 1], ...
                 'parent', PZG(dom_ndx).plot_h{4}.ax_h, ...
                 'tag','parameter K effect prvw line');
            PZG(dom_ndx).plot_h{4}.hndl.parameter_K_effect_prvw_line = ...
              pK_line_h;
          else
            set( pK_line_h, ...
                'xdata', xdata, ...
                'ydata', ydata, ...
                'linestyle', ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [1 0 1], ...
                'visible','on');
          end
        end
      else
        if ~isempty(pK_line_h)
          set( pK_line_h,'visible','off');
        end
      end
    end
    
    % Update the output sensitivity
    if ~isempty( PZG(dom_ndx).plot_h{5} ) ...
      && isfield( PZG(dom_ndx).plot_h{5},'ax_h')
      xdata = PZG(dom_ndx).cntr_data.bode2nyq_freqs;
      if PZG(dom_ndx).plot_h{5}.Hz_cb
        xdata = xdata/(2*pi);
      end
      % In sensitivity plot, y-axis data are always in "dB".
      ydata = 20*log10( abs(sens_data) );
      
      pK_line_h = pzg_fndo( dom_ndx, 5,'parameter_K_effect_line');
      if unstable_CLpoles
        if ~isempty(pK_line_h)
          set(pK_line_h,'visible','off')
        end
      else
        if numel(xdata) == numel(ydata)
          if isempty(pK_line_h) || ~isequal( 1, ishandle(pK_line_h) )
            delete(pK_line_h)
            pK_line_h = ...
              plot( xdata, ydata, ...
                'linestyle',ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [1 0 0], ...
                'parent', PZG(dom_ndx).plot_h{5}.ax_h, ...
                'tag','parameter K effect line');
            PZG(dom_ndx).plot_h{5}.hndl.parameter_K_effect_line = pK_line_h;
          else
            set( pK_line_h(1), ...
              'xdata', xdata, ...
              'ydata', ydata, ...
              'linestyle',ln_styl, ...
              'linewidth', ln_widt, ...
              'visible','on', ...
              'color', [1 0 0], ...
              'visible','on');
          end
        else
          if ~isempty(pK_line_h)
            set( pK_line_h,'visible','off');
          end
        end
      end
      
      pK_line_h = pzg_fndo( dom_ndx, 5,'parameter_K_effect_prvw_line');
      if any( curr_tools ) && preview_on
        if unstable_design_CLpoles
          if ~isempty(pK_line_h)
            set(pK_line_h,'visible','off')
          end
        else
          xdata = PZG(dom_ndx).cntr_data.bode2nyq_freqs;
          if PZG(dom_ndx).plot_h{5}.Hz_cb
            xdata = xdata/(2*pi);
          end
          ydata = 20*log10( abs(design_sens_data) );
          if isempty(pK_line_h) || ~isequal( 1, ishandle(pK_line_h) )
            pK_line_h = ...
              plot( xdata, ydata, ...
                 'linestyle',ln_styl, ...
                 'linewidth', ln_widt, ...
                 'color', [1 0 1], ...
                 'parent', PZG(dom_ndx).plot_h{5}.ax_h, ...
                 'tag','parameter K effect pvrw line');
            PZG(dom_ndx).plot_h{5}.hndl.parameter_K_effect_prvw_line = pK_line_h;
          else
            set( pK_line_h, ...
                'xdata', xdata, ...
                'ydata', ydata, ...
                'linestyle',ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [1 0 1], ...
                'visible','on');
          end
        end
      else
        if ~isempty(pK_line_h)
          set( pK_line_h,'visible','off');
        end
      end
    end

    % Update the Nichols chart
    if ~isempty( PZG(dom_ndx).plot_h{6} ) ...
      && isfield( PZG(dom_ndx).plot_h{6},'ax_h')
      nich_line_h = pzg_fndo( dom_ndx, 6,'nicholpl_mag_phase_line');
      conj_nich_line_h = ...
        pzg_fndo( dom_ndx, 6,'conjugate_nicholpl_mag_phase_line');
      xdata = get( nich_line_h(1),'xdata');
      ydata = get( nich_line_h(1),'ydata');
      if isempty(conj_nich_line_h)
        cnich_vis = 'off';
        cxdata = 0;
        cydata = 0;
      else
        cnich_vis = get( conj_nich_line_h,'visible');
        cxdata = get( conj_nich_line_h(1),'xdata');
        cydata = get( conj_nich_line_h(1),'ydata');
        ydata = ydata + 20*log10( abs(paramK) );
        cydata = cydata + 20*log10( abs(paramK) );
      end
      if paramK < 0
        xdata = xdata - 180;
        if ~isempty(cxdata)
          cxdata = cxdata + 180;
        end
      end
      pK_line_h = pzg_fndo( dom_ndx, 6,'parameter_K_effect_line');
      if isequal( 2, numel(pK_line_h) )
        set( pK_line_h(1), ...
            'xdata', xdata, ...
            'ydata', ydata, ...
            'linestyle',ln_styl, ...
            'linewidth', ln_widt, ...
            'visible','on', ...
            'color', [1 0 0] );
        set( pK_line_h(2), ...
            'xdata', cxdata, ...
            'ydata', cydata, ...
            'linestyle',ln_styl, ...
            'linewidth', ln_widt, ...
            'color', 1-get(PZG(dom_ndx).plot_h{6}.ax_h,'color'), ...
            'visible', cnich_vis );
      else
        delete(pK_line_h)
        pK_line_h = ...
          plot( xdata, ydata, ...
             'linestyle',ln_styl, ...
             'linewidth', ln_widt, ...
             'color', [1 0 0], ...
             'visible','on', ...
             'parent', PZG(dom_ndx).plot_h{6}.ax_h, ...
             'tag','parameter K effect line');
        pK_line_h(2) = ...
          plot( cxdata, cydata, ...
             'linestyle',ln_styl, ...
             'linewidth', ln_widt, ...
             'color', 1-get(PZG(dom_ndx).plot_h{6}.ax_h,'color'), ...
             'parent', PZG(dom_ndx).plot_h{6}.ax_h, ...
             'visible', cnich_vis , ...
             'tag','parameter K effect line');
        PZG(dom_ndx).plot_h{6}.hndl.parameter_K_effect_line = pK_line_h(:);
      end
      
      pK_line_h = pzg_fndo( dom_ndx, 6,'parameter_K_effect_prvw_line');
      if any( curr_tools ) && preview_on
        bode_line_h = pzg_fndo( dom_ndx, 6, design_txt );
        if isempty(bode_line_h)
          if ~isempty(pK_line_h)
            set( pK_line_h,'visible','off');
          end
        else
          xdata = get( bode_line_h(2),'xdata');
          ydata = get( bode_line_h(2),'ydata');
          ydata = ydata + 20*log10( abs(paramK) );
          if paramK < 0
            xdata = xdata - 180;
          end
          if isequal( 2, numel(pK_line_h) )
            set( pK_line_h(1), ...
                'xdata', xdata, ...
                'ydata', ydata, ...
                'linestyle', ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [1 0 1], ...
                'visible','on');
            set( pK_line_h(2), ...
                'xdata', -xdata, ...
                'ydata', ydata, ...
                'linestyle', ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [0.7 0.7 0.7], ...
                'visible', cnich_vis );
          else
            delete(pK_line_h)
            pK_line_h = ...
              plot( xdata, ydata, ...
                 'linestyle', ln_styl, ...
                 'linewidth', ln_widt, ...
                 'color', [1 0 1], ...
                 'parent', PZG(dom_ndx).plot_h{6}.ax_h, ...
                 'tag','parameter K effect prvw line');
            pK_line_h(2) = ...
              plot( -xdata, ydata, ...
                 'linestyle', ln_styl, ...
                 'linewidth', ln_widt, ...
                 'color', [0.7 0.7 0.7], ...
                 'visible', cnich_vis , ...
                 'parent', PZG(dom_ndx).plot_h{6}.ax_h, ...
                 'tag','parameter K effect prvw line');
            PZG(dom_ndx).plot_h{6}.hndl.parameter_K_effect_prvw_line = ...
              pK_line_h(:);
          end
        end
      else
        if ~isempty(pK_line_h)
          set( pK_line_h,'visible','off');
        end
      end
    end
    
    % Update the Nyquist plot
    if ~isempty( PZG(dom_ndx).plot_h{7} ) ...
      && isfield( PZG(dom_ndx).plot_h{7},'ax_h')
      nyqdata = paramK * PZG(dom_ndx).cntr_data.Nyquist_pts;
      if PZG(dom_ndx).plot_h{7}.hybrid_scaling_cb
        nyqdata = pzg_sclpt( nyqdata );
      end
      xdata = real(nyqdata(:));
      ydata = imag(nyqdata(:));
      pK_line_h = pzg_fndo( dom_ndx, 7,'parameter_K_effect_line');
      if numel(xdata) == numel(ydata)
        if isequal( 2, numel(pK_line_h) )
          set( pK_line_h(1), ...
              'xdata', xdata, ...
              'ydata', ydata, ...
              'linestyle', ln_styl, ...
              'linewidth', ln_widt, ...
              'color', [1 0 0], ...
              'visible','on');
          set( pK_line_h(2), ...
              'xdata', xdata, ...
              'ydata', -ydata, ...
              'linestyle', ln_styl, ...
              'linewidth', ln_widt, ...
              'color', 1-get(PZG(dom_ndx).plot_h{7}.ax_h,'color'), ...
              'visible','on');
        else
          delete(pK_line_h)
          pK_line_h = ...
            plot( xdata, ydata, ...
               'parent', PZG(dom_ndx).plot_h{7}.ax_h, ...
               'linestyle', ln_styl, ...
               'linewidth', ln_widt, ...
               'color', [1 0 0], ...
               'tag','parameter K effect line');
          pK_line_h(2) = ...
            plot( xdata, -ydata, ...
               'parent', PZG(dom_ndx).plot_h{7}.ax_h, ...
               'linestyle', ln_styl, ...
               'linewidth', ln_widt, ...
               'color', 1-get(PZG(dom_ndx).plot_h{7}.ax_h,'color'), ...
               'tag','parameter K effect line');
          PZG(dom_ndx).plot_h{7}.hndl.parameter_K_effect_line = pK_line_h(:);
        end
      else
        if ~isempty(pK_line_h)
          set( pK_line_h,'visible','off')
        end
      end
      
      pK_line_h = pzg_fndo( dom_ndx, 7,'parameter_K_effect_prvw_line');
      if any( curr_tools ) && preview_on
        bode_line_h = pzg_fndo( dom_ndx, 7, design_txt );
        if isempty(bode_line_h)
          if ~isempty(pK_line_h)
            set( pK_line_h,'visible','off')
          end
        else
          line_ud = get( bode_line_h(1),'userdata');
          nyqdata = paramK * line_ud.OLCplxBode;
          if PZG(dom_ndx).plot_h{7}.hybrid_scaling_cb
            nyqdata = pzg_sclpt( nyqdata );
          end
          xdata = real(nyqdata(:));
          ydata = imag(nyqdata(:));

          if isequal( 2, numel(pK_line_h) )
            set( pK_line_h(1), ...
                'xdata', xdata, ...
                'ydata', ydata, ...
                'linestyle', ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [1 0 1], ...
                'visible','on');
            set( pK_line_h(2), ...
                'xdata', xdata, ...
                'ydata', -ydata, ...
                'linestyle', ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [0.7 0.7 0.7], ...
                'visible','on');
          else
            delete(pK_line_h)
            pK_line_h = ...
              plot( xdata, ydata, ...
                 'linestyle', ln_styl, ...
                 'linewidth', ln_widt, ...
                 'color', [1 0 1], ...
                 'parent', PZG(dom_ndx).plot_h{7}.ax_h, ...
                 'tag','parameter K effect prvw line');
            pK_line_h(2) = ...
              plot( xdata, -ydata, ...
                 'linestyle', ln_styl, ...
                 'linewidth', ln_widt, ...
                 'color', [0.7 0.7 0.7], ...
                 'parent', PZG(dom_ndx).plot_h{7}.ax_h, ...
                 'tag','parameter K effect prvw line');
            PZG(dom_ndx).plot_h{7}.hndl.parameter_K_effect_prvw_line = ...
              pK_line_h(:);
          end
        end
      else
        if ~isempty(pK_line_h)
          set( pK_line_h,'visible','off')
        end
      end
    end
    
    % Update the Open-Loop time-response plot
    if ~isempty( PZG(dom_ndx).plot_h{8} ) ...
      && isfield( PZG(dom_ndx).plot_h{8},'ax_h')
      resp_line_h = pzg_fndo( dom_ndx, 8,'pzgui_resppl_resp_line');
      xdata = get( resp_line_h(1),'xdata');
      ydata = paramK*get( resp_line_h(1),'ydata');
      input_line_h = pzg_fndo( dom_ndx, 8,'pzgui_resppl_input_line');
      in_ydata = get( input_line_h,'ydata');
      err_ydata = in_ydata - ydata;
      pK_line_h = pzg_fndo( dom_ndx, 8,'parameter_K_effect_line');
      this_bgcolor = get( PZG(dom_ndx).plot_h{8}.ax_h,'color');
      if max( this_bgcolor ) < 0.5
        err_color = [0.5 0.9 0.9];
      else
        err_color = [0 0.6 0.6];
      end
      if get( pzg_fndo( dom_ndx, 8,'show_io_difference'),'value')
        resp_err_vis = 'on';
      else
        resp_err_vis = 'off';
      end
      if ~isequal( 2, numel(pK_line_h) ) ...
        || ~isequal( 2, sum(ishandle(pK_line_h)) )
        delete(pK_line_h)
        pK_line_h = ...
          plot( xdata, ydata, ...
            'linestyle', ln_styl, ...
            'linewidth', ln_widt, ...
            'color', [1 0 0], ...
            'parent', PZG(dom_ndx).plot_h{8}.ax_h, ...
            'tag','parameter K effect line');
        pK_line_h(2) = ...
          plot( xdata, err_ydata, ...
            'linestyle', ln_styl, ...
            'linewidth', ln_widt, ...
            'color', err_color, ...
            'parent', PZG(dom_ndx).plot_h{8}.ax_h, ...
            'visible', resp_err_vis, ...
            'tag','parameter K effect line');
        PZG(dom_ndx).plot_h{8}.hndl.parameter_K_effect_line = pK_line_h;
      else
        set( pK_line_h(1), ...
          'xdata', xdata, ...
          'ydata', ydata, ...
          'linestyle', ln_styl, ...
          'linewidth', ln_widt, ...
          'color', [1 0 0], ...
          'visible','on');
        set( pK_line_h(2), ...
          'xdata', xdata, ...
          'ydata', err_ydata, ...
          'linestyle', ln_styl, ...
          'linewidth', ln_widt, ...
          'color', err_color, ...
          'visible', resp_err_vis );
      end
      
      pK_line_h = pzg_fndo( dom_ndx, 8,'parameter_K_effect_prvw_line');
      if any( curr_tools ) && preview_on
        bode_line_h = pzg_fndo( dom_ndx, 8, design_txt );
        if isempty(bode_line_h)
          if ~isempty(pK_line_h)
            set( pK_line_h,'visible','off');
          end
        else
          xdata = get( bode_line_h(1),'xdata');
          ydata = paramK * get( bode_line_h(1),'ydata');
          err_ydata = in_ydata - ydata;
          this_bgcolor = get( PZG(dom_ndx).plot_h{8}.ax_h,'color');
          if max( this_bgcolor ) < 0.5
            err_color = [0.5 0.9 0.9];
          else
            err_color = [0 0.6 0.6];
          end
          if preview_on
            prvw_vis = 'on';
          else
            prvw_vis = 'off';
            resp_err_vis = 'off';
          end
          if isequal( 2, numel(pK_line_h) ) ...
            && isequal( 2, sum(ishandle(pK_line_h)) )
            set( pK_line_h(1), ...
              'xdata', xdata, ...
              'ydata', ydata, ...
              'linestyle', ln_styl, ...
              'linewidth', ln_widt, ...
              'color', [1 0 1], ...
              'visible', prvw_vis );
            set( pK_line_h(2), ...
              'xdata', xdata, ...
              'ydata', err_ydata, ...
              'linestyle', ln_styl, ...
              'linewidth', ln_widt, ...
              'color', err_color, ...
              'visible', resp_err_vis );
          else
            delete(pK_line_h)
            pK_line_h = ...
              plot( xdata, ydata, ...
                'linestyle', ln_styl, ...
                'linewidth', ln_widt, ...
                'color', [1 0 1], ...
                'parent', PZG(dom_ndx).plot_h{8}.ax_h, ...
                'tag','parameter K effect prvw line');
            pK_line_h(2) = ...
              plot( xdata, err_ydata, ...
                'linestyle', ln_styl, ...
                'linewidth', ln_widt, ...
                'color', err_color, ...
                'parent', PZG(dom_ndx).plot_h{8}.ax_h, ...
                'visible', resp_err_vis, ...
                'tag','parameter K effect prvw line');
            PZG(dom_ndx).plot_h{8}.hndl.parameter_K_effect_prvw_line =pK_line_h;
          end
        end
      elseif ~isempty(pK_line_h)
        set( pK_line_h,'visible','off');
      end
    end
    
    % Update the Closed-Loop time-response plot
    if ~isempty( PZG(dom_ndx).plot_h{9} ) ...
      && isfield( PZG(dom_ndx).plot_h{9},'ax_h')
      resp_line_h = pzg_fndo( dom_ndx, 9,'pzgui_resppl_resp_line');
      xdata = get( resp_line_h(1),'xdata');
      Ts = 0;
      if dom_ndx == 2
        Ts = PZG(2).Ts;
      end
      menu_h = pzg_fndo( dom_ndx, 9,'input_type_popupmenu');
      input_type = get( menu_h,'value');
      cosFreq = 0;
      if input_type > 4
        freq_h = pzg_fndo( dom_ndx, 9,'sinusoid_freq_hz_edit');
        cosFreq = 2*pi * str2double( get( freq_h,'string') );
      end
      
      [ input_zeros, input_poles, input_gain ] = ...
           pzg_inzpk( input_type, dom_ndx, cosFreq/2/pi );
      
      nr_dt_delay_poles = 0;
      
      incl_pade = 1;
      incl_prvw = 0;
      [ reses, poles, direct ] = ...
          pzg_rsppfe( ...
            dom_ndx, input_zeros, input_poles, input_gain, ...
            'closed loop', incl_prvw, incl_pade, paramK );
      
      [ xdata, ydata ] = ...
          pzg_pfesim( reses, poles, direct, ...
            xdata, Ts,'open loop', input_type, cosFreq, nr_dt_delay_poles );
      
      [ curr_tools, toolfig_h, tool_prvw_on ] = pzg_tools(dom_ndx); %#ok<ASGLU>
      if any( curr_tools ) && preview_on
        incl_prvw = 1;
        [ prvw_reses, prvw_poles, prvw_direct ] = ...
            pzg_rsppfe( ...
              dom_ndx, input_zeros, input_poles, input_gain, ...
              'closed loop', incl_prvw, incl_pade, paramK );
      [ prvw_xdata, prvw_ydata ] = ...
          pzg_pfesim( prvw_reses, prvw_poles, prvw_direct, ...
            xdata, Ts,'open loop', input_type, cosFreq, nr_dt_delay_poles );
      else
        prvw_xdata = [];
        prvw_ydata = [];
      end
         
      input_line_h = pzg_fndo( dom_ndx, 9,'pzgui_resppl_input_line');
      in_ydata = get( input_line_h,'ydata');
      err_ydata = in_ydata - ydata;
      this_bgcolor = get( PZG(dom_ndx).plot_h{9}.ax_h,'color');
      if max( this_bgcolor ) < 0.5
        err_color = [0 0.9 0.9];
      else
        err_color = [0 0.6 0.6];
      end
      if get( pzg_fndo( dom_ndx, 9,'show_io_difference'),'value')
        resp_err_vis = 'on';
      else
        resp_err_vis = 'off';
      end
      pK_line_h = pzg_fndo( dom_ndx, 9,'parameter_K_effect_line');
      if ~isequal( 2, numel(pK_line_h) ) ...
        || ~isequal( 2, sum(ishandle(pK_line_h)) )
        delete(pK_line_h)
        pK_line_h = ...
          plot( xdata, ydata, ...
             'linestyle', ln_styl, ...
             'linewidth', ln_widt, ...
             'color', [1 0 0], ...
             'parent', PZG(dom_ndx).plot_h{9}.ax_h, ...
             'tag','parameter K effect line');
        pK_line_h(2) = ...
          plot( xdata, err_ydata, ...
            'linestyle', ln_styl, ...
            'linewidth', ln_widt, ...
            'color', err_color, ...
            'parent', PZG(dom_ndx).plot_h{9}.ax_h, ...
            'visible', resp_err_vis, ...
            'tag','parameter K effect line');
        PZG(dom_ndx).plot_h{9}.hndl.parameter_K_effect_line = pK_line_h;
      else
        set( pK_line_h(1), ...
            'xdata', xdata, ...
            'ydata', ydata, ...
            'linestyle', ln_styl, ...
            'linewidth', ln_widt, ...
            'color', [1 0 0], ...
            'visible','on');
        set( pK_line_h(2), ...
          'xdata', xdata, ...
          'ydata', err_ydata, ...
          'linestyle', ln_styl, ...
          'linewidth', ln_widt, ...
          'color', err_color, ...
          'visible', resp_err_vis );
      end
      
      pK_line_h = pzg_fndo( dom_ndx, 9,'parameter_K_effect_prvw_line');
      if any( curr_tools ) && preview_on
        err_ydata = in_ydata - prvw_ydata;
        this_bgcolor = get( PZG(dom_ndx).plot_h{9}.ax_h,'color');
        if max( this_bgcolor ) < 0.5
          err_color = [0.2 0.8 0.8];
        else
          err_color = [0 0.6 0.6];
        end
        if preview_on
          prvw_vis = 'on';
        else
          prvw_vis = 'off';
          resp_err_vis = 'off';
        end
        if isequal( 2, numel(pK_line_h) ) ...
            && isequal( 2, sum(ishandle(pK_line_h)) )
          set( pK_line_h(1), ...
              'xdata', prvw_xdata, ...
              'ydata', prvw_ydata, ...
              'linestyle',ln_styl, ...
              'linewidth', ln_widt, ...
              'color', [0.8 0 0.8], ...
              'visible', prvw_vis );
          set( pK_line_h(2), ...
              'xdata', prvw_xdata, ...
              'ydata', err_ydata, ...
              'linestyle','--', ...
              'linewidth', ln_widt, ...
              'color', err_color, ...
              'visible', resp_err_vis );
        else
          delete(pK_line_h)
          pK_line_h = ...
            plot( prvw_xdata, prvw_ydata, ...
              'linestyle',ln_styl, ...
              'linewidth', ln_widt, ...
              'color', [0.8 0 0.8], ...
              'parent', PZG(dom_ndx).plot_h{9}.ax_h, ...
              'visible', prvw_vis, ...
              'tag','parameter K effect prvw line');
          pK_line_h(2) = ...
            plot( prvw_xdata, err_ydata, ...
              'linestyle','--', ...
              'linewidth', ln_widt, ...
              'color', err_color, ...
              'parent', PZG(dom_ndx).plot_h{9}.ax_h, ...
              'visible', resp_err_vis, ...
              'tag','parameter K effect prvw line');
          PZG(dom_ndx).plot_h{9}.hndl.parameter_K_effect_prvw_line = pK_line_h;
        end
      else
        if ~isempty(pK_line_h)
          set( pK_line_h,'visible','off')
        end
      end
    end
  end

return

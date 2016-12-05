function updtpzln( Domain )
% This function creates and services the FRF computations "vector lines"
% in PZGUI pole/zero maps when "show FRF computation" is ON.

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
evalin('base','global PZG')

if ~isfield( PZG,'pzg_show_frf_computation')
  PZG(1).pzg_show_frf_computation = 0;
  PZG(2).pzg_show_frf_computation = 0;
  return
end

showhide_h = pzg_fndo( (1:2),(1:14),'show_dontshow_frf_comp');
if ~isempty(showhide_h)
  if PZG(1).pzg_show_frf_computation
    set( showhide_h,'label','Don''t show FRF computation');
  else
    set( showhide_h,'label','Show FRF computation');
  end
end

PZ_mult = 0.99;

if strcmp( Domain,'s') ...
  ||( isequal( nargin, 1 ) && isequal( Domain, 1 ) )
  tempPL = pzg_fndo( 1, 12,'bode_comp_pole_lines');
  tempZL = pzg_fndo( 1, 12,'bode_comp_zero_lines');
  text_P = pzg_fndo( 1, 12,'bode_comp_pole_text');
  text_Z = pzg_fndo( 1, 12,'bode_comp_zero_text');
  text_F = pzg_fndo( 1, 12,'bode_comp_freq_text');
  select_h = pzg_fndo( 1, 12,'Bode_selection_marker');
  all_h = [ tempPL; tempZL; text_P; text_Z; text_F; select_h ];
  if ~PZG(1).pzg_show_frf_computation ...
    || isempty( pzg_fndo( 1, 12,'fig_h') ) ...
    || isempty(PZG(1).PoleLocs) ...
    || isempty(select_h)
    if ~isempty(all_h)
      set( all_h,'visible','off');
    end
    return
  else
  end
  % Positive frequencies only, for the S-plane computation.
  PZG(1).NegSelect = 0;
  if ~isequal( numel(text_P), 2*numel(PZG(1).PoleLocs) )
    delete(text_P)
    text_P = [];
  end
  if ~isequal( numel(text_Z), 2*numel(PZG(1).ZeroLocs) )
    delete(text_Z)
    text_Z = [];
  end
  if ~isempty(PZG(1).FrqSelNdx) ...
    && ( PZG(1).FrqSelNdx > 0 ) ...
    && ( PZG(1).FrqSelNdx <= numel(PZG(1).BodeFreqs) ) ...
    && ( PZG(1).cntr_data.contour_flag(PZG(1).FrqSelNdx) == 1 )
    if ~isequal( 1, PZG(1).pzg_show_frf_computation )
      if ~isempty(tempPL)
        set( tempPL,'visible','off')
      end
      if ~isempty(tempZL)
        set( tempZL,'visible','off')
      end
      if ~isempty(text_P)
        set( text_P,'visible','off')
      end
      if ~isempty(text_Z)
        set( text_P,'visible','off')
      end
      if ~isempty(text_F)
        set( text_F,'visible','off')
      end
    else
      FreqSelect_radsec = PZG(1).BodeFreqs(PZG(1).FrqSelNdx);
      y_select = get( select_h,'ydata');
      if isempty(FreqSelect_radsec)
        set( select_h,'xdata', [],'ydata', [],'visible','off')
      else
        if isempty(y_select) ...
          || ( abs( y_select - FreqSelect_radsec ) > 1e-9 )
          set( select_h,'xdata', 0,'ydata', FreqSelect_radsec )
        end
        set( select_h,'visible','on')
      end
      
      fig_h = PZG(1).plot_h{12}.fig_h;
      if isappdata( fig_h,'hndl');
        hndl = getappdata( fig_h,'hndl');
      else
        hndl = [];
      end
      ax_h = PZG(1).plot_h{12}.ax_h;

      if isempty( PZG(1).PoleLocs )
        set( [ tempPL; tempZL; text_P; text_Z ],'visible','off');
        set( [ tempPL; tempZL ],'xdata',[] ,'ydata', [] );
        set( [ text_P; text_Z ],'string','');
      else
        PLinesX = ones( 3, numel(PZG(1).PoleLocs) );
        PLinesY = PLinesX;
        PLinesX(1,:) = real( PZG(1).PoleLocs )';
        PLinesY(1,:) = imag( PZG(1).PoleLocs )';
        PLinesX(2,:) = 0*PLinesX(2,:);
        PLinesY(2,:) = FreqSelect_radsec;
        PLinesX(3,:) = NaN;
        PLinesY(3,:) = NaN;
        if ~isequal( numel(tempPL), 1 )
          delete(tempPL)
          hndl.bode_comp_pole_lines = ...
            plot( PLinesX(:), PLinesY(:), ...
              'color',[0 0.8 0], ...
              'linestyle','--', ...
              'linewidth', 1, ...
              'Tag','S plane bode comp pole lines', ...
              'parent', ax_h );
          setappdata( fig_h,'hndl', hndl );
          PZG(1).plot_h{12}.hndl.bode_comp_pole_lines = ...
            hndl.bode_comp_pole_lines;
          PZG(2).plot_h{12}.hndl.bode_comp_pole_lines = ...
            hndl.bode_comp_pole_lines;
        else
          set( tempPL, ...
            'xdata', PLinesX(:), ...
            'ydata', PLinesY(:), ...
            'color',[0 0.8 0], ...
            'linestyle','--', ...
            'linewidth', 1, ...
            'visible','on'); 
        end
        for k = 1:numel(PZG(1).PoleLocs)
          x_pos = PZ_mult*real(PZG(1).PoleLocs(k));
          y_pos = PZ_mult*imag(PZG(1).PoleLocs(k));
          p_angle = atan2( FreqSelect_radsec-imag(PZG(1).PoleLocs(k)), ...
                          -real(PZG(1).PoleLocs(k)) )/pi*180;
          app_vector = 1i*FreqSelect_radsec-PZG(1).PoleLocs(k);
          app_xlim = get(ax_h,'xlim');
          app_ylim = get(ax_h,'ylim') - FreqSelect_radsec;
          rot_angle = pzg_txan( app_vector, app_xlim, app_ylim, ax_h );
          if ~isequal( numel(text_P), 2*numel(PZG(1).PoleLocs) )
              text('parent', ax_h, ...
               'position',[ x_pos, y_pos ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', [num2str(p_angle,3) '^o'], ...
               'rotation', rot_angle, ...
               'tag','S plane bode comp pole text');
            x_pos = real( 0.45*1i*FreqSelect_radsec + 0.55*PZG(1).PoleLocs(k) );
            y_pos = imag( 0.45*1i*FreqSelect_radsec + 0.55*PZG(1).PoleLocs(k) );
            p_mag = abs( 1i*FreqSelect_radsec - PZG(1).PoleLocs(k) );

            text('parent', ax_h, ...
               'position',[ x_pos, y_pos ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', pzg_scifmt( p_mag, 3 ), ...
               'rotation', rot_angle, ...
               'tag','S plane bode comp pole text')
          else
            set( text_P(2*k-1), ...
               'position',[ x_pos, y_pos ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', [num2str(p_angle,3) '^o'], ...
               'rotation', rot_angle, ...
               'visible','on');
            x_pos = real( 0.45*1i*FreqSelect_radsec + 0.55*PZG(1).PoleLocs(k) );
            y_pos = imag( 0.45*1i*FreqSelect_radsec + 0.55*PZG(1).PoleLocs(k) );
            p_mag = abs( 1i*FreqSelect_radsec - PZG(1).PoleLocs(k) );
            set( text_P(2*k), ...
               'position',[ x_pos, y_pos ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', pzg_scifmt( p_mag, 3 ), ...
               'rotation', rot_angle, ...
               'visible','on')
          end
        end
        if ~isequal( numel(text_P), 2*numel(PZG(1).PoleLocs) )
          hndl.bode_comp_pole_text = ...
            findobj( ax_h,'tag','S plane bode comp pole text');
          setappdata( fig_h,'hndl', hndl );
        else
          hndl.bode_comp_pole_text = text_P;
        end
        PZG(1).plot_h{12}.hndl.bode_comp_pole_text = ...
          hndl.bode_comp_pole_text;
        PZG(2).plot_h{12}.hndl.bode_comp_pole_text = ...
          hndl.bode_comp_pole_text;
      end

      if isempty( PZG(1).ZeroLocs )
        set( [tempZL;text_Z],'visible','off');
        set( tempZL,'xdata',[] ,'ydata', [] );
        set( text_Z,'string','');
      else
        ZLinesX = ones( 3, numel(PZG(1).ZeroLocs) );
        ZLinesY = ZLinesX;
        ZLinesX(1,:) = real( PZG(1).ZeroLocs )';
        ZLinesY(1,:) = imag( PZG(1).ZeroLocs )';
        ZLinesX(2,:) = 0;
        ZLinesY(2,:) = FreqSelect_radsec;
        ZLinesX(3,:) = NaN;
        ZLinesY(3,:) = NaN;
        if ~isequal( numel(tempZL), 1 )
          delete(tempZL)
          hndl.bode_comp_zero_lines = ...
            plot( ZLinesX(:), ZLinesY(:), ...
                'color',[1 0 0], ...
                'linestyle','--', ...
                'linewidth', 1, ...
                'Tag','S plane bode comp zero lines', ...
                'parent', ax_h );
          setappdata( fig_h,'hndl', hndl );
          PZG(1).plot_h{12}.hndl.bode_comp_zero_lines = ...
            hndl.bode_comp_zero_lines;
          PZG(2).plot_h{12}.hndl.bode_comp_zero_lines = ...
            hndl.bode_comp_zero_lines;
        else
          set( tempZL, ...
               'xdata', ZLinesX(:), ...
               'ydata', ZLinesY(:), ...
               'color',[1 0 0], ...
               'linestyle','--', ...
               'linewidth', 1, ...
               'visible','on')
        end
        for k = 1:numel(PZG(1).ZeroLocs)
          x_pos = PZ_mult*real(PZG(1).ZeroLocs(k));
          y_pos = PZ_mult*imag(PZG(1).ZeroLocs(k));
          z_angle = atan2( FreqSelect_radsec-imag(PZG(1).ZeroLocs(k)), ...
                         -real(PZG(1).ZeroLocs(k)) )/pi*180;
          app_vector = 1i*FreqSelect_radsec-PZG(1).ZeroLocs(k);
          app_xlim = get(ax_h,'xlim');
          app_ylim = get(ax_h,'ylim') - FreqSelect_radsec;
          rot_angle = pzg_txan( app_vector, app_xlim, app_ylim, ax_h );
          if ~isequal( numel(text_Z), 2*numel(PZG(1).ZeroLocs) )
            text('parent', ax_h, ...
               'position',[ x_pos, y_pos ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', [num2str(z_angle,3) '^o'], ...
               'rotation', rot_angle, ...
               'tag','S plane bode comp zero text')
            x_pos = real( 0.45*1i*FreqSelect_radsec + 0.55*PZG(1).ZeroLocs(k) );
            y_pos = imag( 0.45*1i*FreqSelect_radsec + 0.55*PZG(1).ZeroLocs(k) );
            z_mag = abs( 1i*FreqSelect_radsec - PZG(1).ZeroLocs(k) );
            z_mag_str = num2str(z_mag,3);
            ndx_e0 = strfind(z_mag_str,'e+0');
            while ~isempty(ndx_e0)
              z_mag_str(ndx_e0(1)+2) = '';
              ndx_e0 = strfind(z_mag_str,'e+0');
            end
            text('parent', ax_h, ...
                 'position',[ x_pos, y_pos ], ...
                 'color', 1-(get(ax_h,'color')), ...
                 'fontweight','bold', ...
                 'fontsize', 12, ...
                 'string', z_mag_str, ...
                 'rotation', rot_angle, ...
                 'tag','S plane bode comp zero text')
          else
            set( text_Z(2*k-1), ...
               'position',[ x_pos, y_pos ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', [num2str(z_angle,3) '^o'], ...
               'rotation', rot_angle, ...
               'visible','on')
            x_pos = real( 0.45*1i*FreqSelect_radsec + 0.55*PZG(1).ZeroLocs(k) );
            y_pos = imag( 0.45*1i*FreqSelect_radsec + 0.55*PZG(1).ZeroLocs(k) );
            z_mag = abs( 1i*FreqSelect_radsec - PZG(1).ZeroLocs(k) );
            z_mag_str = num2str(z_mag,3);
            ndx_e0 = strfind(z_mag_str,'e+0');
            while ~isempty(ndx_e0)
              z_mag_str(ndx_e0(1)+2) = '';
              ndx_e0 = strfind(z_mag_str,'e+0');
            end
            set( text_Z(2*k), ...
               'position',[ x_pos, y_pos ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', z_mag_str, ...
               'rotation', rot_angle, ...
               'visible','on')
          end
        end
      end
      if ~isequal( numel(text_Z), 2*numel(PZG(1).ZeroLocs))
        hndl.bode_comp_zero_text = ...
          findobj( ax_h,'tag','S plane bode comp zero text');
        setappdata( fig_h,'hndl', hndl );
      else
        hndl.bode_comp_zero_text = text_Z;
      end
      PZG(1).plot_h{12}.hndl.bode_comp_zero_text = ...
        hndl.bode_comp_zero_text;
      PZG(2).plot_h{12}.hndl.bode_comp_zero_text = ...
        hndl.bode_comp_zero_text;
      
      % Display the selected frequency (omega)
      omega_color = [0 1 1];
      if max(get(ax_h,'color')) > 0.5
        omega_color = [0. 0.6 0.6];
      end
      
      base_str = pzg_scifmt(FreqSelect_radsec,3);
      unit_str = 'rad/s';
      if ( numel(base_str) > 2 ) && strcmp( base_str(end-1),' ')
        unit_str = [ base_str(end) unit_str ];
        base_str = base_str(1:end-2);
      end
      selfreq_str = { ['\omega=' base_str ]; unit_str };
      
      if ~isequal( numel(text_F), 1 )
        delete(text_F);
        hndl.bode_comp_freq_text = ...
          text('parent', ax_h, ...
            'position', ...
              [ 0+diff(app_xlim)/50, ...
                min( ...
                  max( FreqSelect_radsec, ...
                    PZG(1).plot_h{12}.ylim(1) ...
                    +0.05*diff(PZG(1).plot_h{12}.ylim) ), ...
                  PZG(1).plot_h{12}.ylim(2) ...
                    -0.05*diff(PZG(1).plot_h{12}.ylim) ) ], ...
            'string', selfreq_str, ...
            'fontweight','bold', ...
            'fontsize', 11, ...
            'color', omega_color, ...
            'tag','S plane bode comp freq text');
        PZG(1).plot_h{12}.hndl.bode_comp_freq_text = ...
          hndl.bode_comp_freq_text;
      else
        app_xlim = get(ax_h,'xlim');
        set( text_F, ...
          'position', ...
            [ 0+diff(app_xlim)/50, ...
              min( ...
                max( FreqSelect_radsec, ...
                  PZG(1).plot_h{12}.ylim(1) ...
                  +0.05*diff(PZG(1).plot_h{12}.ylim) ), ...
                PZG(1).plot_h{12}.ylim(2) ...
                  -0.05*diff(PZG(1).plot_h{12}.ylim) ) ], ...
          'string', selfreq_str, ...
          'fontweight','bold', ...
          'fontsize', 11, ...
          'color', omega_color, ...
          'visible','on');
      end
      if ( numel( PZG(1).PoleLocs ) < 4 ) ...
        &&( ( numel(PZG(1).ZeroLocs) < 3 ) ...
           || isreal( PZG(1).ZeroLocs ) )
        % Display the freq response computation.
        if isfield( PZG(1),'frcomp_fig') ...
          && ~isempty( PZG(1).frcomp_fig ) ...
          && isequal( 1, ishandle(PZG(1).frcomp_fig) )
          fr_disp
        end
      end
    end
  end
end

% Now, the Z-plane lines
if strcmp( Domain,'z') ...
  ||( isequal( nargin, 1 ) && isequal( Domain, 2 ) )
  tempPL = pzg_fndo( 2, 13,'bode_comp_pole_lines');
  tempZL = pzg_fndo( 2, 13,'bode_comp_zero_lines');
  text_P = pzg_fndo( 2, 13,'bode_comp_pole_text');
  text_Z = pzg_fndo( 2, 13,'bode_comp_zero_text');
  text_F = pzg_fndo( 2, 13,'bode_comp_freq_text');
  select_h = pzg_fndo( 2, 13,'Bode_selection_marker');
  all_h = [ tempPL; tempZL; text_P; text_Z; text_F; select_h ];
  if ~PZG(2).pzg_show_frf_computation || isempty(PZG(2).FrqSelNdx) ...
    || isempty( pzg_fndo( 2, 13,'fig_h') ) ...
    || isempty(PZG(2).PoleLocs) ...
    || isempty(select_h)
    if ~isempty(all_h)
      set( all_h,'visible','off');
    end
    return
  else
    if ~isempty(all_h)
      set( all_h,'visible','on');
    end
  end

  uc_select = get( select_h,'xdata') + 1i*get( select_h,'ydata');
  if imag(uc_select) >= 0
    PZG(2).NegSelect = 0;
  else
    PZG(2).NegSelect = 1;
  end
  if ~isequal( numel(text_P), 2*numel(PZG(2).PoleLocs) )
    delete(text_P)
    text_P = [];
  end
  if ~isequal( numel(text_Z), 2*numel(PZG(2).ZeroLocs) )
    delete(text_Z)
    text_Z = [];
  end
  if ~isempty(PZG(2).FrqSelNdx) ...
    && ( PZG(2).FrqSelNdx > 0 ) ...
    && ( PZG(2).FrqSelNdx <= numel(PZG(2).BodeFreqs) ) ...
    && ( PZG(2).cntr_data.contour_flag(PZG(2).FrqSelNdx) == 1 )
    % Determine the current selected frequency.
    FreqSelect_radsec = PZG(2).BodeFreqs(PZG(2).FrqSelNdx);
    neg_freq = PZG(2).NegSelect;
    if PZG(2).NegSelect || neg_freq
      FreqSelect_radsec = 2*pi/PZG(2).Ts - FreqSelect_radsec;
    end
    if ~isequal( 1, PZG(2).pzg_show_frf_computation )
      if ~isempty(tempPL)
        set( tempPL,'visible','off')
      end
      if ~isempty(tempZL)
        set( tempZL,'visible','off')
      end
      if ~isempty(text_P)
        set( text_P,'visible','off')
      end
      if ~isempty(text_P)
        set( text_Z,'visible','off')
      end
    else
      if PZG(2).NegSelect && ( FreqSelect_radsec < pi/PZG(2).Ts )
        FreqSelect_radsec = abs( 2*pi/PZG(2).Ts - abs(FreqSelect_radsec) );
      end
      PZG(2).FrqSelNdx = ...
        pzg_gle( PZG(2).BodeFreqs, abs(FreqSelect_radsec),'near');
      if isempty(FreqSelect_radsec)
        UCpt = exp(1i*pi/4);
        %FreqSelect_radsec = angle(UCpt)/PZG(2).Ts;
      else
        UCpt = exp(1i*FreqSelect_radsec*PZG(2).Ts);
      end

      fig_h = PZG(2).plot_h{13}.fig_h;
      if isappdata( fig_h,'hndl');
        hndl = getappdata( fig_h,'hndl');
      else
        hndl = [];
      end
      ax_h = PZG(2).plot_h{13}.ax_h;

      if ~isempty( PZG(2).PoleLocs ) && isequal( ishandle(ax_h), 1 )
        PLinesX = ones( 3, numel(PZG(2).PoleLocs) );
        PLinesY = PLinesX;
        PLinesX(1,:) = real( PZG(2).PoleLocs )';
        PLinesY(1,:) = imag( PZG(2).PoleLocs )';
        PLinesX(2,:) = real(UCpt);
        PLinesY(2,:) = imag(UCpt);
        PLinesX(3,:) = NaN;
        PLinesY(3,:) = NaN;
        if ~isequal( numel(tempPL), 1 )
          delete(tempPL)
          hndl.bode_comp_pole_lines = ...
            plot( PLinesX(:), PLinesY(:), ...
                'color',[0 0.8 0], ...
                'linestyle','--', ...
                'linewidth', 1, ...
                'parent', ax_h, ...
                'Tag','Z plane bode comp pole lines');
          setappdata( fig_h,'hndl', hndl );
          PZG(1).plot_h{13}.hndl.bode_comp_pole_lines = ...
            hndl.bode_comp_pole_lines;
          PZG(2).plot_h{13}.hndl.bode_comp_pole_lines = ...
            hndl.bode_comp_pole_lines;
        else
          set( tempPL, ...
              'xdata', PLinesX(:), ...
              'ydata', PLinesY(:), ...
              'color',[0 0.8 0], ...
              'linestyle','--', ...
              'linewidth', 1, ...
              'visible','on');
         end
        for k = 1:numel(PZG(2).PoleLocs)
          text_pos = PZ_mult*PZG(2).PoleLocs(k) + (1-PZ_mult)*UCpt;
          p_angle = ...
            atan2( imag(UCpt)-imag(PZG(2).PoleLocs(k)), ...
                   real(UCpt)-real(PZG(2).PoleLocs(k)) )/pi*180;
          app_vector = UCpt - PZG(2).PoleLocs(k);
          app_xlim = get(ax_h,'xlim') - real(UCpt);
          app_ylim = get(ax_h,'ylim') - imag(UCpt);
          rot_angle = pzg_txan( app_vector, app_xlim, app_ylim, ax_h );
          if ~isequal( numel(text_P), ...
                2*(numel(PZG(2).PoleLocs)+numel(PZG(2).ZeroLocs)) )
            delete(text_P)
            text_P = [];
            text('parent', ax_h, ...
               'position',[ real(text_pos), imag(text_pos) ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', [num2str(p_angle,3) '^o'], ...
               'rotation', rot_angle, ...
               'tag','Z plane bode comp pole text')
            x_pos = real( 0.45*UCpt + 0.55*PZG(2).PoleLocs(k) );
            y_pos = imag( 0.45*UCpt + 0.55*PZG(2).PoleLocs(k) );
            p_mag = abs( UCpt - PZG(2).PoleLocs(k) );
            text('parent', ax_h, ...
               'position',[ x_pos, y_pos ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', num2str(p_mag,3), ...
               'rotation', rot_angle, ...
               'tag','Z plane bode comp pole text')
          else
            set( text_P(2*k-1), ...
               'position',[ real(text_pos), imag(text_pos) ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', [num2str(p_angle,3) '^o'], ...
               'rotation', rot_angle, ...
               'visible','on')                  
            x_pos = real( 0.45*UCpt + 0.55*PZG(2).PoleLocs(k) );
            y_pos = imag( 0.45*UCpt + 0.55*PZG(2).PoleLocs(k) );
            p_mag = abs( UCpt - PZG(2).PoleLocs(k) );
            set( text_P(2*k), ...
               'position',[ x_pos, y_pos ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', num2str(p_mag,3), ...
               'rotation', rot_angle, ...
               'visible','on')
          end
        end
        if isempty(text_P)
          hndl.bode_comp_pole_text = ...
            findobj( ax_h,'tag','Z plane bode comp pole text');
          setappdata( fig_h,'hndl', hndl );
        else
          hndl.bode_comp_pole_text = text_P;
        end
        PZG(1).plot_h{13}.hndl.bode_comp_pole_text = ...
          hndl.bode_comp_pole_text;
        PZG(2).plot_h{13}.hndl.bode_comp_pole_text = ...
          hndl.bode_comp_pole_text;
      end

      if ~isempty( PZG(2).ZeroLocs ) && isequal( numel(ax_h), 1 )
        ZLinesX = ones( 3, numel(PZG(2).ZeroLocs) );
        ZLinesY = ZLinesX;
        ZLinesX(1,:) = real( PZG(2).ZeroLocs )';
        ZLinesY(1,:) = imag( PZG(2).ZeroLocs )';
        ZLinesX(2,:) = real(UCpt);
        ZLinesY(2,:) = imag(UCpt);
        ZLinesX(3,:) = NaN;
        ZLinesY(3,:) = NaN;
        if ~isequal( numel(tempZL), 1 )
          delete(tempZL)
          hndl.bode_comp_zero_lines = ...
            plot( ZLinesX(:), ZLinesY(:), ...
                'color',[1 0 0], ...
                'linestyle','--', ...
                'linewidth', 1, ...
                'parent', ax_h, ...
                'Tag','Z plane bode comp zero lines');
          setappdata( fig_h,'hndl', hndl );
          PZG(1).plot_h{13}.hndl.bode_comp_zero_lines = ...
            hndl.bode_comp_zero_lines;
          PZG(2).plot_h{13}.hndl.bode_comp_zero_lines = ...
            hndl.bode_comp_zero_lines;
        else
          set( tempZL, ...
             'xdata', ZLinesX(:), ...
             'ydata', ZLinesY(:), ...
             'color',[1 0 0], ...
             'linestyle','--', ...
             'linewidth', 1, ...
             'visible','on');
        end

        for k = 1:numel(PZG(2).ZeroLocs)
          text_pos = PZ_mult*PZG(2).ZeroLocs(k) + (1-PZ_mult)*UCpt;
          z_angle = ...
            atan2( imag(UCpt)-imag(PZG(2).ZeroLocs(k)), ...
                   real(UCpt)-real(PZG(2).ZeroLocs(k)) )/pi*180;
          app_vector = UCpt - PZG(2).ZeroLocs(k);
          app_xlim = get(ax_h,'xlim') - real(UCpt);
          app_ylim = get(ax_h,'ylim') - imag(UCpt);
          rot_angle = pzg_txan( app_vector, app_xlim, app_ylim, ax_h );
          if ~isequal( numel(text_Z), 2*numel(PZG(2).ZeroLocs) )
            text('parent', ax_h, ...
               'position',[ real(text_pos), imag(text_pos) ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', [num2str(z_angle,3) '^o'], ...
               'rotation', rot_angle, ...
               'tag','Z plane bode comp zero text');
            x_pos = real( 0.45*UCpt + 0.55*PZG(2).ZeroLocs(k) );
            y_pos = imag( 0.45*UCpt + 0.55*PZG(2).ZeroLocs(k) );
            z_mag = abs( UCpt - PZG(2).ZeroLocs(k) );
            text('parent', ax_h, ...
               'position',[ x_pos, y_pos ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', num2str(z_mag,3), ...
               'rotation', rot_angle, ...
               'tag','Z plane bode comp zero text')
          else
            set( text_Z(2*k-1), ...
               'position',[ real(text_pos), imag(text_pos) ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', [num2str(z_angle,3) '^o'], ...
               'rotation', rot_angle, ...
               'visible','on')
            x_pos = real( 0.45*UCpt + 0.55*PZG(2).ZeroLocs(k) );
            y_pos = imag( 0.45*UCpt + 0.55*PZG(2).ZeroLocs(k) );
            z_mag = abs( UCpt - PZG(2).ZeroLocs(k) );
            set( text_Z(2*k), ...
               'position',[ x_pos, y_pos ], ...
               'color', 1-(get(ax_h,'color')), ...
               'fontweight','bold', ...
               'fontsize', 12, ...
               'string', num2str(z_mag,3), ...
               'rotation', rot_angle, ...
               'visible','on')
          end
        end
        if isempty(text_Z)
          hndl.bode_comp_zero_text = ...
            findobj( ax_h,'tag','Z plane bode comp zero text');
          setappdata( fig_h,'hndl', hndl );
        else
          hndl.bode_comp_zero_text = text_Z;
        end
        PZG(1).plot_h{13}.hndl.bode_comp_zero_text = ...
          hndl.bode_comp_zero_text;
        PZG(2).plot_h{13}.hndl.bode_comp_zero_text = ...
          hndl.bode_comp_zero_text;
      end
      omega_color = [0 1 1];
      if max(get(ax_h,'color')) > 0.5
        omega_color = [0. 0.6 0.6];
      end
      
      app_xlim = get(ax_h,'xlim');
      app_ylim = get(ax_h,'ylim');
      FrqSelect_pt = UCpt;
      if real(UCpt) >= 0
        % First and fourth quadrants
        if imag(UCpt) >= 0.6
          FrqSelect_pt = ...
            real(FrqSelect_pt)+0.01*diff(app_xlim) ...
            +1i*(imag(FrqSelect_pt)+0.04*diff(app_ylim));
        elseif imag(UCpt) >= 0
          FrqSelect_pt = ...
            real(FrqSelect_pt)+0.015*diff(app_xlim) ...
            +1i*(imag(FrqSelect_pt)+0.06*diff(app_ylim));
        elseif imag(UCpt) > -0.4
          FrqSelect_pt = ...
            real(FrqSelect_pt)+0.015*diff(app_xlim) ...
            +1i*(imag(FrqSelect_pt)-0.02*diff(app_ylim));
        else
          FrqSelect_pt = ...
            real(FrqSelect_pt)+0.015*diff(app_xlim) ...
            +1i*(imag(FrqSelect_pt)-0.1*diff(app_ylim));
        end
      else
        % Second and third quadrants
        if imag(UCpt) >= 0
          FrqSelect_pt = ...
            real(FrqSelect_pt)-0.2*diff(app_xlim) ...
            +1i*(imag(FrqSelect_pt)+0.06*diff(app_ylim));
        else
          FrqSelect_pt = ...
            real(FrqSelect_pt)-0.2*diff(app_xlim) ...
            +1i*(imag(FrqSelect_pt)-0.06*diff(app_ylim));
        end
      end
      sel_str = pzg_efmt(FreqSelect_radsec,3);
      sel_str = deblank( sel_str );
      sel_str = [ '^'*ones(size(sel_str)); sel_str ];
      sel_str = ( sel_str(:) )';
      exp_str = {'  e^ ^{\itj}^ ^\omega^T';['=^ e^ ^{\itj}^ ^(' sel_str '^)^T']};
      if ~isequal( numel(text_F), 1 )
        delete(text_F);
        hndl.bode_comp_freq_text = ...
          text('parent', ax_h, ...
            'position',[ real(FrqSelect_pt), imag(FrqSelect_pt) ], ...
            'string', exp_str, ...
            'fontweight','bold', ...
            'fontsize', 13, ...
            'color', omega_color, ...
            'tag','Z plane bode comp freq text');
        PZG(2).plot_h{13}.hndl.bode_comp_freq_text = ...
          hndl.bode_comp_freq_text;
      else
        set( text_F, ...
          'position',[ real(FrqSelect_pt), imag(FrqSelect_pt) ], ...
          'string', exp_str, ...
          'fontweight','bold', ...
          'fontsize', 13, ...
          'color', omega_color, ...
          'visible','on');
      end
    end
  end
end
  
return
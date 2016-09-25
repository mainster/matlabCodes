function   Calls = pz_move( Domain )
% Services the mouse interrupts while a pole or zero
% is being moved in the main GUI pole/zero map.

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
global PZMoving
Calls = 0;
if isempty(PZG) && ~pzg_recovr
  return
end
evalin('base','global PZG')

if nargin < 1
  disp('Correct format is:')
  disp('            Calls = pz_move( Domain )')
  return
end
if ( numel(Domain) ~= 1 ) || ( ~ischar(Domain) )
  disp(' Input argument DOMAIN must be either ''s'' or ''z''.')
  return
end

if isempty(gcbf)
  if Domain == 'z'
    FigHndl = ...
      findobj(allchild(0), ...
        'type','figure', ...
        'Name',PZG(2).PZGUIname);
    M = 2;
  else
    FigHndl = ...
      findobj(allchild(0), ...
        'type','figure', ...
        'Name',PZG(1).PZGUIname);
    M = 1;
  end
else
  FigHndl = gcbf;
  if Domain == 'z'
    M = 2;
  else
    M = 1;
  end
end

AxHndl = get(FigHndl,'currentaxes');

temp0 = get(FigHndl,'UserData');
hndl = [];
if isappdata( FigHndl,'hndl')
  hndl = getappdata( FigHndl,'hndl');
end

if isempty( strfind( get(FigHndl,'SelectionType'),'ext') ) ...
  && isempty( strfind( get(FigHndl,'SelectionType'),'alt') ) ...
  && ~strcmpi( get(FigHndl,'pointer'),'hand') ...
  && ~strcmpi( get(FigHndl,'pointer'),'arrow')
  return
end

Calls = 1;
temp = get(AxHndl,'CurrentPoint');
CurrPt = temp(1,1)+1i*abs(temp(1,2));
if numel(PZG(M).Selection) > 1
  if PZG(M).Selection(1)==1
    if imag( PZG(M).ZeroLocs( PZG(M).Selection(2) ) ) == 0
      PZG(M).ZeroLocs( PZG(M).Selection(2) ) = real(CurrPt);
      PZG(M).recompute_frf = 1;
      % Update damping and natural frequency.
      curr_damping = 1;
      if M == 1
        curr_natl_freq = abs(real(CurrPt));
        % If guis are linked, set the other freqs empty
        if isfield( hndl,'LinkMethod') ...
          && isequal( 1, ishandle(hndl.LinkMethod) )
          link_h = hndl.LinkMethod;
        elseif isequal( 1, ishandle(temp0(15,2)) )
          link_h = temp0(15,2);
        else
          link_h = findobj(gcbf,'string','D-T Link by:');
        end
        if ~isempty(link_h) && get( link_h,'value')
          PZG(2).recompute_frf = 1;
        end
      else
        curr_natl_freq = abs( real( log(CurrPt)/PZG(M).Ts ) );
        % If guis are linked, set the other freqs empty
        if isfield( hndl,'LinkMethod') ...
          && isequal( 1, ishandle(hndl.LinkMethod) )
          link_h = hndl.LinkMethod;
        elseif isequal( 1, ishandle(temp0(15,2)) )
          link_h = temp0(15,2);
        else
          link_h = findobj(gcbf,'string','C-T Link by:');
        end
        if ~isempty(link_h) && get( link_h,'value')
          PZG(1).recompute_frf = 1;
        end
      end
    else
      if abs(imag(CurrPt)) ...
        < 1e-3*abs(imag( PZG(M).ZeroLocs( PZG(M).Selection(2) ) ))
        CurrPt = real(CurrPt) ...
          +1i*sign(imag(CurrPt)) ...
           *1e-3*abs(imag( PZG(M).ZeroLocs( PZG(M).Selection(2) ) ));
      end
      [temp, tempNdx] = ...
        sort( conj(PZG(M).ZeroLocs( PZG(M).Selection(2) )) ...
              == PZG(M).ZeroLocs );                             %#ok<ASGLU>
      PZG(M).ZeroLocs( tempNdx(end) ) = conj( CurrPt );
      PZG(M).ZeroLocs( PZG(M).Selection(2) ) = CurrPt;
      PZG(M).recompute_frf = 1;
      % Update damping and natural frequency.
      s_plane_pt = CurrPt;
      if M == 2
        s_plane_pt = log(CurrPt)/PZG(M).Ts;
        link_h = findobj(gcbf,'string','C-T Link by:');
        if ~isempty(link_h) && get( link_h,'value')
          PZG(1).recompute_frf = 1;
        end
      else
        link_h = findobj(gcbf,'string','D-T Link by:');
        if ~isempty(link_h) && get( link_h,'value')
          PZG(2).recompute_frf = 1;
        end
      end
      curr_damping = -cos( atan2( abs(imag(s_plane_pt)), real(s_plane_pt) ) );
      curr_natl_freq = abs( s_plane_pt );
    end
    SelectStr = cell(numel(PZG(M).ZeroLocs)+1,1);
    for Ck = 1:numel(PZG(M).ZeroLocs)
      this_zero = PZG(M).ZeroLocs(Ck);
      if M == 1
        if ( abs(real(this_zero)) < 1e-6 ) ...
          ||( abs(imag(this_zero)) < 1e-6 )
          if isreal(this_zero)
            SelectStr{Ck} = num2str(this_zero,10);
          else
            SelectStr{Ck} = num2str(this_zero,9);
          end
        else
          SelectStr{Ck} = num2str(this_zero,7);
        end
      else
        if ( abs( 1 - this_zero ) < 1e-4 ) ...
          ||( abs( -1 - this_zero ) < 1e-4 )
          if isreal(this_zero)
            SelectStr{Ck} = num2str(this_zero,10);
          else
            SelectStr{Ck} = num2str(this_zero,9);
          end
        else
          SelectStr{Ck} = num2str(this_zero,7);          
        end
      end
    end
    SelectStr{end} = 'ALL ZEROS';
    if numel( PZG(M).Selection ) > 1
      set(temp0(8,2),'Value',PZG(M).Selection(2),'String',SelectStr )
    end
    % Redraw the zero locations.
    set(temp0(3,1),'Xdata',real(PZG(M).ZeroLocs),'Ydata',imag(PZG(M).ZeroLocs) )
    % Redraw the frequency lines, if they are on.
    if isequal( Domain,'z')
      zline_h = pzg_fndo( 2, 13,'bode_comp_zero_lines');
    else
      zline_h = pzg_fndo( 1, 12,'bode_comp_zero_lines');
    end
    if ~isempty(zline_h) && ( numel(zline_h) <= numel(PZG(M).ZeroLocs) )
      zline_nr = 0;
      for k = 1:numel(zline_h)
        zline_xdata = get(zline_h(k),'xdata');
        zline_ydata = get(zline_h(k),'ydata');
        if numel(zline_xdata) > 1
          zline_nr = zline_nr + 1;
          zline_xdata(1) = real( PZG(M).ZeroLocs(zline_nr) );
          zline_ydata(1) = imag( PZG(M).ZeroLocs(zline_nr) );
          set( zline_h(k),'xdata', zline_xdata,'ydata', zline_ydata );
        end
      end
    end
    
    if abs(curr_damping) == 1
      s0_str = [ Domain '_o = ' num2str(real(CurrPt),4) ];
      if strcmp( Domain,'z')
        if abs(CurrPt) >= 1
          curr_damping = -1;
        end
      else
        if real(CurrPt) >= 0
          curr_damping = -1;
        end
      end
    else
      if imag(CurrPt) > 0
        s0_str = [ Domain '_o = ' num2str(real(CurrPt),4) ...
                    ' + ' num2str(imag(CurrPt),4)  'i'];
      elseif imag(CurrPt) < 0
        s0_str = [ Domain '_o = ' num2str(real(CurrPt),4) ...
                    ' - ' num2str(abs(imag(CurrPt)),4)  'i'];
      else
        s0_str = [ Domain '_o = ' num2str(real(CurrPt),4) ];
      end
    end
    text_str = { s0_str; ...
                ['     \zeta = ' num2str(curr_damping*100,6) '%     ' ...
                '{\it\omega_n}= ' num2str(curr_natl_freq/2/pi,5) ' Hz']};
    set(temp0(10,1),'string', text_str );
  elseif PZG(M).Selection(1)==2
    if imag( PZG(M).PoleLocs( PZG(M).Selection(2) ) ) == 0
      PZG(M).PoleLocs( PZG(M).Selection(2) ) = real(CurrPt);
      PZG(M).recompute_frf = 1;
      % Update damping and natural frequency.
      curr_damping = sign( real(CurrPt+eps) );
      if M == 1
        curr_natl_freq = abs(real(CurrPt));
      else
        curr_natl_freq = abs( real( log(CurrPt)/PZG(M).Ts ) );
      end
    else
      if abs(imag(CurrPt)) ...
        < 1e-3*abs(imag( PZG(M).PoleLocs( PZG(M).Selection(2) ) ))
        CurrPt = real(CurrPt) ...
          +1i*sign(imag(CurrPt)) ...
           *1e-3*abs(imag( PZG(M).PoleLocs( PZG(M).Selection(2) ) ));
      end
      [temp, tempNdx] = ...
        sort( conj(PZG(M).PoleLocs( PZG(M).Selection(2) )) ...
              == PZG(M).PoleLocs );                          %#ok<ASGLU>
      PZG(M).PoleLocs( tempNdx(end) ) = conj( CurrPt );
      PZG(M).PoleLocs( PZG(M).Selection(2) ) = CurrPt;
      PZG(M).recompute_frf = 1;
      if imag( PZG(M).PoleLocs( PZG(M).Selection(2) ) ) == 0
        disp('Changed from cplx to real poles')
      end
      % Update damping and natural frequency.
      s_plane_pt = CurrPt;
      if M == 2
        s_plane_pt = log(CurrPt)/PZG(M).Ts;
        link_h = findobj(gcbf,'string','C-T Link by:');
        if ~isempty(link_h) && get( link_h,'value')
          PZG(1).recompute_frf = 1;
        end
      else
        link_h = findobj(gcbf,'string','D-T Link by:');
        if ~isempty(link_h) && get( link_h,'value')
          PZG(2).recompute_frf = 1;
        end
        if size(temp0,1) > 92
          if strcmp( get( temp0(41,2),'visible'),'on')
            if imag(s_plane_pt) < 0
              s_plane_pt = ...
                real(s_plane_pt) ...
                + 1i*mod( imag(s_plane_pt), -2*pi/PZG(2).Ts );
              if imag(s_plane_pt) < -pi/PZG(2).Ts
                s_plane_pt = s_plane_pt + 1i*2*pi/PZG(2).Ts;
              end
            else
              s_plane_pt = ...
                real(s_plane_pt) ...
                + 1i*mod( imag(s_plane_pt), 2*pi/PZG(2).Ts );
              if imag(s_plane_pt) > pi/PZG(2).Ts
                s_plane_pt = s_plane_pt - 1i*2*pi/PZG(2).Ts;
              end
            end
          elseif strcmp( get( temp0(71,1),'visible'),'on')            
            wPlaneLoc = s_plane_pt;
            w_den = 2/PZG(1).Ts - wPlaneLoc;
            if abs(w_den) < 1e-8
              w_den = 1e-8;
            end
            z_from_w = ( 2/PZG(1).Ts + wPlaneLoc)/w_den;
            s_plane_pt = log(z_from_w)/PZG(1).Ts;
          end
        end
      end
      curr_damping = -cos( atan2( abs(imag(s_plane_pt)), real(s_plane_pt) ) );
      curr_natl_freq = abs( s_plane_pt );
    end
    SelectStr = cell(numel(PZG(M).PoleLocs)+1,1);
    for Ck = 1:numel(PZG(M).PoleLocs)
      this_pole = PZG(M).PoleLocs(Ck);
      if M == 1
        if ( abs(real(this_pole)) < 1e-6 ) ...
          ||( abs(imag(this_pole)) < 1e-6 )
          if isreal(this_pole)
            SelectStr{Ck} = num2str(this_pole,10);
          else
            SelectStr{Ck} = num2str(this_pole,9);
          end
        else
          SelectStr{Ck} = num2str(this_pole,7);
        end
      else
        if ( abs( 1 - this_pole ) < 1e-4 ) ...
          ||( abs( -1 - this_pole ) < 1e-4 )
          if isreal(this_pole)
            SelectStr{Ck} = num2str(this_pole,10);
          else
            SelectStr{Ck} = num2str(this_pole,9);
          end
        else
          SelectStr{Ck} = num2str(this_pole,7);          
        end
      end
    end
    SelectStr{end} = 'ALL POLES';
    set(temp0(7,2),'Value',PZG(M).Selection(2),'String',SelectStr )
    % Redraw the pole locations.
    set(temp0(2,1),'Xdata',real(PZG(M).PoleLocs),'Ydata',imag(PZG(M).PoleLocs) )
    % Redraw the frequency lines, if they are on.
    if isequal( Domain,'z')
      pline_h = pzg_fndo( 2, 13,'bode_comp_pole_lines');
    else
      pline_h = pzg_fndo( 1, 12,'bode_comp_pole_lines');
    end
    if ~isempty(pline_h) && ( numel(pline_h) >= numel(PZG(M).PoleLocs) )
      % Note that one of these lines is used for the imaginary-axis marker.
      pline_ndx = 1;
      for k = 1:numel(pline_h)
        pline_xdata = get(pline_h(k),'xdata');
        pline_ydata = get(pline_h(k),'ydata');
        if numel(pline_xdata) > 1
          pline_xdata(1) = real( PZG(M).PoleLocs(pline_ndx) );
          pline_ydata(1) = imag( PZG(M).PoleLocs(pline_ndx) );
          set( pline_h(pline_ndx),'xdata', pline_xdata,'ydata', pline_ydata );
          pline_ndx = pline_ndx + 1;
        end
      end
    end
    
    if abs(curr_damping) == 1
      s0_str = [ Domain '_o = ' num2str(real(CurrPt),4) ];
    else
      s0_str = [ Domain '_o = ' num2str(real(CurrPt),4) ...
                  ' + ' num2str(imag(CurrPt),4)  'i'];
    end
    text_str = { s0_str; ...
                ['     \zeta = ' num2str(curr_damping*100,6) '%     ' ...
                '{\it\omega_n}= ' num2str(curr_natl_freq/2/pi,5) ' Hz']};
    set(temp0(10,1),'string', text_str );
  end
  if PZG(M).pzg_show_frf_computation
    if M == 1
      updtpzln('s');
    else
      updtpzln('z');
    end
  end
  % If the Bode plot is open, compute the new FRF.
  if ~isempty(PZG(M).plot_h{1}) && isfield(PZG(M).plot_h{1},'fig_h')
    bodemag_h = PZG(M).plot_h{1}.fig_h;
  else
    bodemag_h = [];
  end
  if ~isempty(PZG(M).plot_h{2}) && isfield(PZG(M).plot_h{2},'fig_h')
    bodephs_h = PZG(M).plot_h{2}.fig_h;
  else
    bodephs_h = [];
  end
  if ~isempty(PZG(M).plot_h{3}) && isfield(PZG(M).plot_h{3},'fig_h')
    clmag_h = PZG(M).plot_h{3}.fig_h;
  else
    clmag_h = [];
  end
  if ~isempty(PZG(M).plot_h{4}) && isfield(PZG(M).plot_h{4},'fig_h')
    clphs_h = PZG(M).plot_h{4}.fig_h;
  else
    clphs_h = [];
  end
  if ~isempty(PZG(M).plot_h{6}) && isfield(PZG(M).plot_h{6},'fig_h')
    nich_h = PZG(M).plot_h{6}.fig_h;
  else
    nich_h = [];
  end
  if ~isempty(PZG(M).plot_h{7}) && isfield(PZG(M).plot_h{7},'fig_h')
    nyq_h = PZG(M).plot_h{7}.fig_h;
  else
    nyq_h = [];
  end
  if ~isempty(PZG(M).plot_h{8}) && isfield(PZG(M).plot_h{8},'fig_h')
    olresp_h = PZG(M).plot_h{8}.fig_h;
  else
    olresp_h = [];
  end
  if ~isempty(PZG(M).plot_h{9}) && isfield(PZG(M).plot_h{9},'fig_h')
    clresp_h = PZG(M).plot_h{9}.fig_h;
  else
    clresp_h = [];
  end
  if ~isempty(PZG(M).plot_h{9+M}) && isfield(PZG(M).plot_h{9+M},'fig_h')
    rlocus_h = PZG(M).plot_h{9+M}.fig_h;
  else
    rlocus_h = [];
  end
  if ~isempty(PZG(M).plot_h{5}) && isfield(PZG(M).plot_h{5},'fig_h')
    sens_h = PZG(M).plot_h{5}.fig_h;
  else
    sens_h = [];
  end
  if M == 1
    fix_h = pzg_fndo( 1, 12,'Fix_DC_checkbox');
    if isempty(fix_h)
      fix_h = findobj( PZG(1).plot_h{12}.fig_h,'tag','C-T Fix DC checkbox');
    end
    dc_freqpt = 0;
  else
    fix_h = pzg_fndo( 2, 13,'Fix_DC_checkbox');
    if isempty(fix_h)
      fix_h = findobj( PZG(1).plot_h{13}.fig_h,'tag','D-T Fix DC checkbox');
    end
    dc_freqpt = 1;
  end
  
  if ~isempty(bodemag_h) || ~isempty(bodemag_h) ...
    ||~isempty(clmag_h) || ~isempty(clphs_h) ...
    ||~isempty(nich_h) || ~isempty(nyq_h) ...
    ||~isempty(olresp_h) ||~isempty(clresp_h) ...
    || ~isempty(rlocus_h) || ~isempty(sens_h) ...
    || ( ~isempty(fix_h) && isequal( 1, get(fix_h(1),'value') ) )
    temp_color = 'r';
    temp_linewidth = 2;
    temp_linestyle = '--';
    if ~isempty(PZG(M).undo_info)
      this_frf = PZG(M).cntr_data.bode2nyq_pts(:);
      this_freq = PZG(M).cntr_data.bode2nyq_freqs(:);
      xtra_freq_pts = [];
      xtra_frf_pts = [];
      if M == 1
        freq_pts = 1i*this_freq;
      else
        freq_pts = exp( 1i*this_freq*PZG(2).Ts );
      end
      adjust = 0;
      if ~isempty(PZG(M).Selection) && ( PZG(M).Selection(1) == 1 )
        % Zero is being moved.
        PZG(1).recompute_frf = 1;
        old_zero = PZG(M).undo_info{end}.ZeroLocs(PZG(M).Selection(2));
        new_zero = PZG(M).ZeroLocs(PZG(M).Selection(2));
        if isreal(old_zero) && isreal(new_zero)
          if ( abs(dc_freqpt-old_zero) < 1e-12 ) ...
            ||( abs(dc_freqpt-new_zero) < 1e-12 )
            if M == 1
              dc_freqpt = dc_freqpt + 1i*pi/10;
            else
              dc_freqpt = exp( 1i*( angle(dc_freqpt)+pi/100 ) );
            end
          end
          mult_vec = ( freq_pts - new_zero ) ./ ( freq_pts - old_zero );
          if ~isempty(fix_h) && isequal( 1, get(fix_h,'value') )
            adjust = abs(dc_freqpt-old_zero)/abs(dc_freqpt-new_zero);
            if ( ( M == 1 ) ...
                &&( ( ( old_zero <= 0 ) && ( new_zero > 0 ) ) ...
                   ||( ( ( old_zero > 0 ) && ( new_zero <= 0 ) ) ) ) ) ...
              ||( ( M == 2 ) ...
                 &&( ( ( old_zero <= 1 ) && ( new_zero > 1 ) ) ...
                    ||( ( old_zero > 1 ) && ( new_zero <= 1 ) ) ) )
              adjust = -adjust;
            end
            mult_vec = adjust*mult_vec;
          end
        else
          mult_vec = ...
            ( freq_pts - new_zero ).*( freq_pts - conj(new_zero) ) ...
            ./( ( freq_pts - old_zero ).*( freq_pts - conj(old_zero) ) );
          if ~isempty(fix_h) && isequal( 1, get(fix_h,'value') )
            adjust = ( abs(dc_freqpt-old_zero)/abs(dc_freqpt-new_zero) )^2;
            mult_vec = adjust*mult_vec;
          end
        end
        
        if M == 1
          s_new_zero = new_zero;
        else
          s_new_zero = log(new_zero)/PZG(2).Ts;
        end
        if ( abs(imag(s_new_zero)) > 1e-6 ) ...
          &&( abs( imag(s_new_zero)/real(s_new_zero) ) > 10 ) %   < 10%-damped
          xtra_freq_pts = ...
            pzg_xtrfrq( M, s_new_zero, PZG(M).BodeFreqs([1,end]) );
          xtra_freq_pts = 1i*xtra_freq_pts;
          if M == 2
            xtra_freq_pts = exp( xtra_freq_pts*PZG(2).Ts );
          end
          
          undo_gain = PZG(M).undo_info{end}.Gain;
          if adjust == 0
            xtra_frf_pts = undo_gain * ones(size(xtra_freq_pts));
          else
            xtra_frf_pts = (adjust*undo_gain) * ones(size(xtra_freq_pts));
          end
          for kpp = 1:numel(PZG(M).PoleLocs)
            xtra_frf_pts = ...
              xtra_frf_pts ./ ( xtra_freq_pts - PZG(M).PoleLocs(kpp) );
            if numel(PZG(M).ZeroLocs) >= kpp
              xtra_frf_pts = ...
                xtra_frf_pts .* ( xtra_freq_pts - PZG(M).ZeroLocs(kpp) );
            end
          end
        end
        
      elseif ~isempty(PZG(M).Selection) && ( PZG(M).Selection(1) == 2 )
        % Pole is being moved.
        PZG(1).recompute_frf = 1;
        old_pole = PZG(M).undo_info{end}.PoleLocs(PZG(M).Selection(2));
        new_pole = PZG(M).PoleLocs(PZG(M).Selection(2));
        if isreal(old_pole) && isreal(new_pole)
          if ( abs(dc_freqpt-old_pole) < 1e-12 ) ...
            ||( abs(dc_freqpt-new_pole) < 1e-12 )
            if M == 1
              dc_freqpt = dc_freqpt + 1i*pi/10;
            else
              dc_freqpt = exp( 1i*( angle(dc_freqpt)+pi/100 ) );
            end
          end
          mult_vec = ( freq_pts - old_pole ) ./ ( freq_pts - new_pole );
          if ~isempty(fix_h) && isequal( 1, get(fix_h,'value') )
            adjust = abs(dc_freqpt-new_pole)/abs(dc_freqpt-old_pole);
            if ( ( M == 1 ) ...
                && ( ( ( old_pole <= 0 ) && ( new_pole > 0 ) ) ...
                    ||( ( old_pole > 0 ) && ( new_pole <= 0 ) ) ) ) ...
              ||( ( M == 2 ) ...
                 &&( ( ( old_pole <= 1 ) && ( new_pole > 1 ) ) ...
                    ||( ( old_pole > 1 ) && ( new_pole <= 1 ) ) ) )
              adjust = -adjust;
            end
            mult_vec = adjust*mult_vec;
          end
        else
          mult_vec = ...
            ( freq_pts - old_pole ).*( freq_pts - conj(old_pole) ) ...
            ./( ( freq_pts - new_pole ).*( freq_pts - conj(new_pole) ) );
          if ~isempty(fix_h) && isequal( 1, get(fix_h,'value') )
            adjust = ( abs(dc_freqpt-new_pole)/abs(dc_freqpt-old_pole) )^2;
            mult_vec = adjust*mult_vec;
          end
        end
        
        if M == 1
          s_new_pole = new_pole;
        else
          s_new_pole = log(new_pole)/PZG(2).Ts;
        end
        if ( abs(imag(s_new_pole)) > 1e-6 ) ...
          &&( abs(real(s_new_pole)) > 1e-9 ) ...
          &&( abs( imag(s_new_pole)/real(s_new_pole) ) > 10 ) %   < 10%-damped
          % Very lightly-damped location, compute additional FRF points.
          xtra_freq_pts = ...
            pzg_xtrfrq( M, s_new_pole, PZG(M).BodeFreqs([1,end]) );
          xtra_freq_pts = 1i*xtra_freq_pts;
          if M == 2
            xtra_freq_pts = exp( xtra_freq_pts*PZG(2).Ts );
          end
          
          undo_gain = PZG(M).undo_info{end}.Gain;
          if adjust == 0
            xtra_frf_pts = undo_gain * ones(size(xtra_freq_pts));
          else
            xtra_frf_pts = (adjust*undo_gain) * ones(size(xtra_freq_pts));
          end
          for kpp = 1:numel(PZG(M).PoleLocs)
            xtra_frf_pts = ...
              xtra_frf_pts ./ ( xtra_freq_pts - PZG(M).PoleLocs(kpp) );
            if numel(PZG(M).ZeroLocs) >= kpp
              xtra_frf_pts = ...
                xtra_frf_pts .* ( xtra_freq_pts - PZG(M).ZeroLocs(kpp) );
            end
          end
        end
      else
        return
      end
      if ~isequal( adjust, 0 )
        % Display the adjusted gain in the Gain window.
        undo_gain = PZG(M).undo_info{end}.Gain;
        new_gain = undo_gain * adjust;
        ud0 = get( gcbf,'userdata');
        set( ud0(1,2),'string', pzg_efmt( new_gain ) );
        PZG(M).Gain = new_gain;
      end
      this_frf = this_frf .* mult_vec;
      if ~isempty(xtra_freq_pts)
        if M == 1
          this_freq = [ this_freq; abs(xtra_freq_pts(:)) ];
        else
          this_freq = [ this_freq; angle(xtra_freq_pts(:))/PZG(2).Ts ];
        end
        this_frf = [ this_frf; xtra_frf_pts(:) ];
        [ this_freq, sortndx ] = sort( this_freq );
        this_frf = this_frf(sortndx);
      end
      
      % If the PID or lead-lag design tool is in "preview" mode,
      % then include the indicated filter.
      all_plot = 0;
      gain_prev_h = [];
      ldlg_prev_h = [];
      pid_prev_h = [];
      curr_tools = pzg_tools(M);
      if M == 1
        if curr_tools(1)
          gain_prev_h = pzg_fndo( 1,(1:14),'sGain_Preview');
          if ~isempty(gain_prev_h) ...
            && strcmp( get(gain_prev_h(1),'visible'),'off')
            gain_prev_h = [];
          end
        elseif curr_tools(2)
          ldlg_prev_h = pzg_fndo( 1,(1:14),'sLDLG_Preview');
          if ~isempty(ldlg_prev_h) ...
            && strcmp( get(ldlg_prev_h(1),'visible'),'off')
            ldlg_prev_h = [];
          end
        elseif curr_tools(3)
          pid_prev_h = pzg_fndo( 1,(1:14),'sPID_Preview');
          if ~isempty(pid_prev_h) ...
            && strcmp( get(pid_prev_h(1),'visible'),'off')
            pid_prev_h = [];
          end
        end
      else
        if curr_tools(1)
          gain_prev_h = pzg_fndo( 1,(1:14),'zGain_Preview');
          if ~isempty(gain_prev_h) ...
            && strcmp( get(gain_prev_h(1),'visible'),'off')
            gain_prev_h = [];
          end
        elseif curr_tools(2)
          ldlg_prev_h = pzg_fndo( 1,(1:14),'zLDLG_Preview');
          if ~isempty(ldlg_prev_h) ...
            && strcmp( get(ldlg_prev_h(1),'visible'),'off')
            ldlg_prev_h = [];
          end
        elseif curr_tools(3)
          pid_prev_h = pzg_fndo( 1,(1:14),'zPID_Preview');
          if ~isempty(pid_prev_h) ...
            && strcmp( get(pid_prev_h(1),'visible'),'off')
            pid_prev_h = [];
          end
        end
      end
      frf_wo_design = this_frf;
      design = [];
      if curr_tools(1) ...
        && ~isempty(gain_prev_h) && isfield( PZG(M),'puregain') ...
        && isnumeric(PZG(M).puregain) && ( numel(PZG(M).puregain) == 1 ) ...
        && ~isequal( PZG(M).puregain, 0 )
        design.k = PZG(M).puregain;
        design.p = [];
        design.z = [];
      elseif curr_tools(2) ...
        && ~isempty(ldlg_prev_h) && isfield( PZG(M),'LeadLag') ...
        && iscell(PZG(M).LeadLag) && ( numel(PZG(M).LeadLag) == 6 )
        all_plot = 1;
        design.k = PZG(M).LeadLag{4};
        design.p = PZG(M).LeadLag{5};
        design.z = PZG(M).LeadLag{6};
        this_frf = this_frf * design.k ...
          .* ( freq_pts - design.z ) ./ ( freq_pts - design.p );
      elseif curr_tools(3) ...
        && ~isempty(pid_prev_h) && isfield( PZG(M),'PID') ...
        && iscell(PZG(M).PID) && ( numel(PZG(M).PID) >= 7 )
        all_plot = 1;
        design.k = PZG(M).PID{4};
        design.z = [ PZG(M).PID{5};PZG(M).PID{6} ];
        if M == 1
          design.p = [ 0; PZG(M).PID{7} ];
        else
          design.p = [ 1; 0 ];
        end
        if M == 1
          this_frf = this_frf * design.k * sign(design.p(2)+eps) ...
            .* ( freq_pts - design.z(1) ) .* ( freq_pts - design.z(2) ) ...
            ./ ( freq_pts - design.p(1) ) ./ ( freq_pts/design.p(2) - 1 );
        else
          this_frf = this_frf * design.k ...
            .* ( freq_pts - design.z(1) ) .* ( freq_pts - design.z(2) ) ...
            ./ ( freq_pts - design.p(1) ) ./ ( freq_pts - design.p(2) );
        end
      end
      if all_plot
        design_frf = this_frf./frf_wo_design;
        design_frf_phs = 180/pi*angle(design_frf);
        design_frf_db = 20*log10(abs(design_frf));
      end
      if ~isempty(design)
        temp_color = 'm';
      end
      
      this_frf_dB = 20*log10(abs(this_frf));
      this_frf_rad = angle(this_frf);
      
      tfe_mag_error = [];
      tfe_phs_error = [];
      tfe_freqs = [];
      tfe_color = [ 0 0.8 0 ];
      if ( ~isempty(bodemag_h) || ~isempty(bodephs_h) ) ...
        && ~isempty( PZG(M).TFEMag ) ...
        && isequal( numel(PZG(M).TFEMag), numel(PZG(M).TFEPhs) ) ...
        && isequal( numel(PZG(M).TFEMag), numel(PZG(M).TFEFreqs) ) ...
        && ( numel(PZG(M).TFEMag) <= (numel(this_frf)+1) )
        tfe_freqs = PZG(M).BodeFreqs(1:numel(PZG(M).TFEFreqs));
        if isequal( PZG(M).TFEFreqs(:), tfe_freqs(:) )
          tfe_freqs = tfe_freqs(:);
          tfe_frf = 10.^( PZG(M).TFEMag(:)/20 ) ...
                     .* exp( 1i*PZG(M).TFEPhs(:)/180*pi );
          if numel(this_frf) == ( numel(tfe_frf) - 1 )
            tfe_freqs(end) = [];
            tfe_frf(end) = [];
          end
          tfe_mag_error = abs( tfe_frf - this_frf );
          tfe_phs_error = ( angle(this_frf) - angle(tfe_frf) )*(180/pi);
        else
          tfe_freqs = [];
        end
      end
        
      % Display the perturbed FRF in the bode plots.
      if ~isempty(bodemag_h)
        if isappdata( bodemag_h,'hndl')
          olbmag_hndl = getappdata( bodemag_h,'hndl');
        else
          olbmag_hndl = [];
        end
        if isfield( olbmag_hndl,'BodeHZChkbox')
          hz_h = olbmag_hndl.BodeHZChkbox;
        else
          hz_h = findobj( bodemag_h,'string','Hz');
        end
        if isfield( olbmag_hndl,'BodeDBChkbox')
          dB_h = olbmag_hndl.BodeDBChkbox;
        else
          dB_h = findobj( bodemag_h,'string','dB');
        end
        if get(hz_h,'value')
          plot_freq = this_freq * (1/2/pi);
        else
          plot_freq = this_freq;
        end
        if get(dB_h,'value')
          plot_mag = this_frf_dB;
        else
          plot_mag = abs(this_frf);
        end
        if isfield( olbmag_hndl,'ax')
          bodemag_ax_h = olbmag_hndl.ax;
        else
          bodemag_ax_h = PZG(M).plot_h{1}.ax_h;
        end
        set( bodemag_ax_h,'xlimmode','manual','ylimmode','manual');
        
        movepz_h = pzg_fndo( M, 1,'pzmove_temporary_line');
        movepz_tfe_h = findobj( movepz_h,'color', tfe_color );
        movepz_h = setdiff( movepz_h, movepz_tfe_h );
        if ( ~all_plot && ~isequal( numel(movepz_h), 1 ) ) ...
          ||( all_plot && ~isequal( numel(movepz_h), 2 ) )
          delete(movepz_h)
          if all_plot
            if get(dB_h,'value')
              mag_wo_des = plot_mag - design_frf_db;
            else
              mag_wo_des = abs(frf_wo_design);
            end
            movepz_h2 = ...
              plot( plot_freq, mag_wo_des, ...
                 'linewidth', temp_linewidth, ...
                 'color', [0.8 0 0], ...
                 'linestyle', temp_linestyle, ...
                 'parent', bodemag_ax_h, ...
                 'tag','pz-move temporary line');
          else
            movepz_h2 = [];
          end
          movepz_h = ...
            plot( plot_freq, plot_mag, ...
               'linewidth', temp_linewidth, ...
               'color', temp_color, ...
               'linestyle', temp_linestyle, ...
               'parent', bodemag_ax_h, ...
               'tag','pz-move temporary line');
          PZG(M).plot_h{1}.hndl.pzmove_temporary_line = [ movepz_h; movepz_h2 ];
        else
          if all_plot
            if get(dB_h,'value')
              mag_wo_des = plot_mag - design_frf_db;
            else
              mag_wo_des = abs(frf_wo_design);
            end
            set( movepz_h(2), ...
                'xdata', plot_freq, ...
                'ydata', mag_wo_des, ...
                'color', [0.8 0 0], ...
                'visible','on');
          end
          set( movepz_h(1), ...
              'xdata', plot_freq, ...
              'ydata', plot_mag, ...
              'color', temp_color, ...
              'visible','on');
        end
        if ~isempty( PZG(M).TFEMag ) ...
          && isequal( numel(PZG(M).TFEMag), numel(PZG(M).TFEPhs) ) ...
          && isequal( numel(PZG(M).TFEMag), numel(PZG(M).TFEFreqs) ) ...
          && ( numel(PZG(M).TFEFreqs) <= numel(PZG(M).BodeFreqs) )
          % Get visibility of TFE difference.
          tfediff_cb_h = ...
            findobj( bodemag_h,'style','checkbox','string','Show Diff');
          if strcmp( get( tfediff_cb_h,'visible'),'on') ...
            && isequal( get( tfediff_cb_h,'value'), 1 )
            tfediff_vis = 'on';
          else
            tfediff_vis = 'off';
          end
          if ~isempty( tfe_freqs )
            if get(dB_h,'value')
              tfe_mag_error = 20*log10(tfe_mag_error);
            end
            if get(hz_h,'value')
              plot_freqs = tfe_freqs * (1/2/pi);
            else
              plot_freqs = tfe_freqs;
            end
            if numel(movepz_tfe_h) > 1
              delete(movepz_tfe_h)
              movepz_tfe_h = [];
            end
            if isempty(movepz_tfe_h)
              movepz_h(end+1) = ...
                plot( plot_freqs, tfe_mag_error, ...
                  'linewidth', temp_linewidth, ...
                  'color', tfe_color, ...
                  'linestyle', temp_linestyle, ...
                  'visible', tfediff_vis, ...
                  'parent', bodemag_ax_h, ...
                  'tag','pz-move temporary line');
            else
              set( movepz_tfe_h, ...
                'xdata', plot_freqs, ...
                'ydata', tfe_mag_error, ...
                'visible', tfediff_vis );
            end
            movepz_h = [ movepz_h; movepz_tfe_h ];
            PZG(M).plot_h{1}.hndl.pzmove_temporary_line = movepz_h;
            olbmag_hndl.pzmove_temporary_line = movepz_h;
            setappdata( bodemag_h,'hndl', olbmag_hndl );
          end
        end
      end
      
      if ~isempty(bodephs_h)
        if isappdata( bodephs_h,'hndl')
          olbphs_hndl = getappdata( bodephs_h,'hndl');
        else
          olbphs_hndl = [];
        end
        if isfield( olbphs_hndl,'BodeHZChkbox')
          hz_h = olbphs_hndl.BodeHZChkbox;
        else
          hz_h = findobj( bodephs_h,'string','Hz');
        end
        if isfield( olbphs_hndl,'UnwrapChkbox')
          wrap_h = olbphs_hndl.UnwrapChkbox;
        else
          wrap_h = findobj( bodephs_h,'string','dB');
        end
        if get(hz_h,'value')
          plot_freq = this_freq * (1/2/pi);
        else
          plot_freq = this_freq;
        end
        if get(wrap_h,'value')
          this_frf_angle = ...
            pzg_unwrap( this_freq, this_frf_rad*180/pi, Domain,'open');
        else
          this_frf_angle = 180/pi*this_frf_rad;
        end
        if isfield( olbphs_hndl,'ax')
          bodephs_ax_h = olbphs_hndl.ax;
        else
          bodephs_ax_h = PZG(M).plot_h{2}.ax_h;
        end
        set( bodephs_ax_h,'xlimmode','manual','ylimmode','manual');
        movepz_h = pzg_fndo( M, 2,'pzmove_temporary_line');
        movepz_tfe_h = findobj( movepz_h,'color', tfe_color );
        movepz_h = setdiff( movepz_h, movepz_tfe_h );
        
        if ( ~all_plot && ~isequal( numel(movepz_h), 1 ) ) ...
          ||( all_plot && ~isequal( numel(movepz_h), 2 ) )
          delete(movepz_h)
          if all_plot
            movepz_h2 = ...
              plot( plot_freq, this_frf_angle-design_frf_phs, ...
                 'linewidth', temp_linewidth, ...
                 'color', [0.8 0 0], ...
                 'linestyle', temp_linestyle, ...
                 'parent', bodephs_ax_h, ...
                 'tag','pz-move temporary line');
          else
            movepz_h2 = [];
          end
          movepz_h = ...
            plot( plot_freq, this_frf_angle, ...
               'linewidth', temp_linewidth, ...
               'color', temp_color, ...
               'linestyle', temp_linestyle, ...
               'parent', bodephs_ax_h, ...
               'tag','pz-move temporary line');
          movepz_h = [ movepz_h; movepz_h2 ];
        else
          if all_plot
            set( movepz_h(2), ...
                'xdata', plot_freq, ...
                'ydata', this_frf_angle-design_frf_phs, ...
                'color', [0.8 0 0], ...
                'visible','on');
          end
          set( movepz_h(1), ...
              'xdata', plot_freq, ...
              'ydata', this_frf_angle, ...
              'color', temp_color, ...
              'visible','on');
        end
        if ~isempty( PZG(M).TFEMag ) ...
          && isequal( numel(PZG(M).TFEMag), numel(PZG(M).TFEPhs) ) ...
          && isequal( numel(PZG(M).TFEMag), numel(PZG(M).TFEFreqs) ) ...
          && ( numel(PZG(M).TFEFreqs) <= numel(PZG(M).BodeFreqs) )
          % Get visibility of TFE difference.
          tfediff_cb_h = ...
            findobj( bodephs_h,'style','checkbox','string','Show Diff');
          if strcmp( get( tfediff_cb_h,'visible'),'on') ...
            && isequal( get( tfediff_cb_h,'value'), 1 )
            tfediff_vis = 'on';
          else
            tfediff_vis = 'off';
          end
          if ~isempty( tfe_freqs )
            if get(hz_h,'value')
              plot_freqs = tfe_freqs * (1/2/pi);
            else
              plot_freqs = tfe_freqs;
            end
            if numel(movepz_tfe_h) > 1
              delete(movepz_tfe_h)
              movepz_tfe_h = [];
            end
            if isempty(movepz_tfe_h)
              plot( plot_freqs, tfe_phs_error, ...
                'linewidth', temp_linewidth, ...
                'color', tfe_color, ...
                'linestyle', temp_linestyle, ...
                'visible', tfediff_vis, ...
                'parent', bodephs_ax_h, ...
                'tag','pz-move temporary line');
            else
              set( movepz_tfe_h, ...
                'xdata', plot_freqs, ...
                'ydata', tfe_phs_error, ...
                'visible', tfediff_vis );
            end
            movepz_h = [ movepz_h; movepz_tfe_h ];
          end
        end
        PZG(M).plot_h{2}.hndl.pzmove_temporary_line = movepz_h;
        olbphs_hndl.pzmove_temporary_line = movepz_h;
        setappdata( bodephs_h,'hndl', olbphs_hndl );
      end
      
      if ~isempty(clmag_h) || ~isempty(clphs_h)
        cl_frf = this_frf ./( 1 + this_frf );
        if all_plot
          cl_frf_wo_des = frf_wo_design ./ ( 1 + frf_wo_design );
          cl_frf_wo_des_mag = 20*log10(abs(cl_frf_wo_des));
          cl_frf_wo_des_phs = (180/pi)*angle(cl_frf_wo_des);
        end
        if ~isempty(clmag_h)
          if isappdata( clmag_h,'hndl')
            clbmag_hndl = getappdata( clmag_h,'hndl');
          else
            clbmag_hndl = [];
          end
          if isfield( clbmag_hndl,'BodeHZChkbox')
            hz_h = clbmag_hndl.BodeHZChkbox;
          else
            hz_h = findobj( clmag_h,'string','Hz');
          end
          if isfield( clbmag_hndl,'BodeDBChkbox')
            dB_h = clbmag_hndl.BodeDBChkbox;
          else
            dB_h = findobj( clmag_h,'string','dB');
          end
          if get(hz_h,'value')
            plot_freq = this_freq * (1/2/pi);
          else
            plot_freq = this_freq;
          end
          if get(dB_h,'value')
            plot_mag = 20*log10( abs(cl_frf) );
          else
            plot_mag = abs(cl_frf);
            if all_plot
              cl_frf_wo_des_mag = abs(cl_frf_wo_des);
            end
          end
          if isfield( clbmag_hndl,'ax')
            clmag_ax_h = clbmag_hndl.ax;
          else
            clmag_ax_h = PZG(M).plot_h{3}.ax_h;
          end
          set( clmag_ax_h,'xlimmode','manual','ylimmode','manual');
          movepz_h = pzg_fndo( M, 3,'pzmove_temporary_line');
          if ( ~all_plot && ~isequal( numel(movepz_h), 1 ) ) ...
            ||( all_plot && ~isequal( numel(movepz_h), 2 ) )
            delete(movepz_h)
            if all_plot
              movepz_h2 = ...
                plot( plot_freq, cl_frf_wo_des_mag, ...
                  'linewidth', temp_linewidth, ...
                  'color',[0.8 0 0], ...
                  'linestyle', temp_linestyle, ...
                  'parent', clmag_ax_h, ...
                  'tag','pz-move temporary line');
            else
              movepz_h2 = [];
            end
            movepz_h = ...
              plot( plot_freq, plot_mag, ...
                'linewidth', temp_linewidth, ...
                'color', temp_color, ...
                'linestyle', temp_linestyle, ...
                'parent', clmag_ax_h, ...
                'tag','pz-move temporary line');
            movepz_h = [ movepz_h; movepz_h2 ];
            PZG(M).plot_h{3}.hndl.pzmove_temporary_line = movepz_h;
            clbmag_hndl.pzmove_temporary_line = movepz_h;
            setappdata( clmag_h,'hndl', clbmag_hndl );
          else
            if all_plot
              set( movepz_h(2), ...
                'xdata', plot_freq, ...
                'ydata', cl_frf_wo_des_mag, ...
                'color', [0.8 0 0], ...
                'visible','on');
            end
            set( movepz_h(1), ...
              'xdata', plot_freq, ...
              'ydata', plot_mag, ...
              'color', temp_color, ...
              'visible','on');
          end
        end
        if ~isempty(clphs_h)
          if isappdata( clphs_h,'hndl')
            clbphs_hndl = getappdata( clphs_h,'hndl');
          else
            clbphs_hndl = [];
          end
          hz_h = findobj( clphs_h,'string','Hz');
          if get(hz_h,'value')
            plot_freq = this_freq * (1/2/pi);
          else
            plot_freq = this_freq;
          end
          wrap_h = findobj( clphs_h,'string','unwrap');
          if get(wrap_h,'value')
            this_frf_angle = ...
              pzg_unwrap( this_freq, angle(cl_frf)*180/pi, Domain,'closed');
            if all_plot
              cl_frf_wo_des_phs = ...
                pzg_unwrap( this_freq, ...
                            angle(cl_frf_wo_des)*180/pi, Domain,'closed');
            end
          else
            this_frf_angle = (180/pi)*angle(cl_frf);
          end
          clphs_ax_h = findobj( clphs_h,'tag','pzg bode plot axes');
          set( clphs_ax_h,'xlimmode','manual','ylimmode','manual');
          movepz_h = pzg_fndo( M, 4,'pzmove_temporary_line');
          movepz_h2 = [];
          if ( ~all_plot && ~isequal( numel(movepz_h), 1 ) ) ...
            ||( all_plot && ~isequal( numel(movepz_h), 2 ) )
            delete(movepz_h)
            if all_plot
              movepz_h2 = ...
                plot( plot_freq, cl_frf_wo_des_phs, ...
                   'linewidth', temp_linewidth, ...
                   'color',[0.8 0 0], ...
                   'linestyle', temp_linestyle, ...
                   'parent', clphs_ax_h, ...
                   'tag','pz-move temporary line');
            end
            movepz_h = ...
              plot( plot_freq, this_frf_angle, ...
                 'linewidth', temp_linewidth, ...
                 'color', temp_color, ...
                 'linestyle', temp_linestyle, ...
                 'parent', clphs_ax_h, ...
                 'tag','pz-move temporary line');
            movepz_h = [ movepz_h; movepz_h2 ];
          else
            if all_plot
              set( movepz_h(2), ...
                  'xdata', plot_freq, ...
                  'ydata', cl_frf_wo_des_phs, ...
                  'color',[0.8 0 0], ...
                  'visible','on');
            end
            set( movepz_h(1), ...
                'xdata', plot_freq, ...
                'ydata', this_frf_angle, ...
                'color', temp_color, ...
                'visible','on');
          end
          movepz_h = [ movepz_h; movepz_h2 ];
          PZG(M).plot_h{4}.hndl.pzmove_temporary_line = movepz_h;
          clbphs_hndl.pzmove_temporary_line = movepz_h;
          setappdata( clphs_h,'hndl', clbphs_hndl );
        end
      end
      
      if ~isempty(rlocus_h) && ( numel(PZG(M).PoleLocs) <= 20 )
        if isappdata( rlocus_h,'hndl')
          rloc_hndl = getappdata( rlocus_h,'hndl');
        else
          rloc_hndl = [];
        end
        if isfield( rloc_hndl,'ax')
          rl_ax_h = rloc_hndl.ax;
        else
          rl_ax_h = PZG(M).plot_h{9+M}.ax_h;
        end        
        set( rl_ax_h,'xlimmode','manual','ylimmode','manual');

        % For more than 20 poles, it takes too much computation time
        % to "track" real-time changes in pole/zero locations effectively.
        rloc_color = [0.8 0 0];
        ugcross_color = [0 0.8 0.8];
        % Rapid computation of root locus.        
        rl_ud = get(rl_ax_h,'userdata');
        GAINS = rl_ud.GAINS;
        newzeros = PZG(M).ZeroLocs;
        newpoles = PZG(M).PoleLocs;
        newgain = PZG(M).Gain;
        % Include PID or LeadLag design, if currently being previewed.
        allplot = 0;
        if ~isempty(ldlg_prev_h) && iscell(PZG(M).LeadLag) ...
          && ( numel(PZG(M).LeadLag) == 6 ) ...
          && ~isempty(PZG(M).LeadLag{4}) ...
          && ~isempty(PZG(M).LeadLag{5}) ...
          && ~isempty(PZG(M).LeadLag{6}) ...
          && isreal(PZG(M).LeadLag{4}) ...
          && isreal(PZG(M).LeadLag{5}) ...
          && isreal(PZG(M).LeadLag{6}) ...
          && ~isnan(PZG(M).LeadLag{4}) ...
          && ~isnan(PZG(M).LeadLag{5}) ...
          && ~isnan(PZG(M).LeadLag{6}) ...
          && ~isinf(PZG(M).LeadLag{4}) ...
          && ~isinf(PZG(M).LeadLag{5}) ...
          && ~isinf(PZG(M).LeadLag{6}) ...
          && (PZG(M).LeadLag{4} > 0 ) ...
          && (PZG(M).LeadLag{5} <= 0 ) ...
          && (PZG(M).LeadLag{6} <= 0 )
          allplot = 1;
          allzeros = [ newzeros(:); PZG(M).LeadLag{6} ];
          allpoles = [ newpoles(:); PZG(M).LeadLag{5} ];
          allgain = newgain * PZG(M).LeadLag{4};
        elseif ~isempty(pid_prev_h) && ( numel(PZG(M).PID) >= 7 ) ...
          && ~isnan(PZG(M).PID{1} ) ...
          && ~isnan(PZG(M).PID{2} ) ...
          && ~isnan(PZG(M).PID{3} ) ...
          && ~isnan(PZG(M).PID{4} ) ...
          && ~isnan(PZG(M).PID{5} ) ...
          && ~isnan(PZG(M).PID{6} ) ...
          && ~isnan(PZG(M).PID{7} ) ...
          && ~isinf(PZG(M).PID{1} ) ...
          && ~isinf(PZG(M).PID{2} ) ...
          && ~isinf(PZG(M).PID{3} ) ...
          && ~isinf(PZG(M).PID{4} ) ...
          && ~isinf(PZG(M).PID{5} ) ...
          && ~isinf(PZG(M).PID{6} ) ...
          && ~isinf(PZG(M).PID{7} )
          allplot = 1;
          allzeros = [ newzeros(:); PZG(M).PID{5}; PZG(M).PID{6} ];
          allgain = newgain * PZG(M).PID{4};
          if M == 1
            allpoles = [ newpoles(:); 0; PZG(M).PID{7} ];
            allgain = allgain * abs(PZG(M).PID{7});
          else
            allpoles = [ newpoles(:); 1; 0 ];
          end
        end
        
        if M == 1
          if ( PZG(1).PureDelay > 0 ) ...
            && isequal( numel(PZG(1).pade.Z), 4 ) ...
            && isequal( numel(PZG(1).pade.P), 4 )
            newzeros = [ newzeros(:); PZG(1).pade.Z ];
            newpoles = [ newpoles(:); PZG(1).pade.P ];
            if allplot
              allzeros = [ allzeros(:); PZG(1).pade.Z ];
              allpoles = [ allpoles(:); PZG(1).pade.P ];
            end
          end
          modalss = pzg_moda( [], newzeros, newpoles, newgain );
          if allplot
            allmdlss = pzg_moda( [], allzeros, allpoles, allgain );
          end
        else
          if ( PZG(2).PureDelay > 0 ) ...
            && isequal( round(PZG(2).PureDelay), PZG(2).PureDelay )
            newpoles = [ newpoles; zeros( PZG(2).PureDelay, 1 ) ];
            if allplot
              allpoles = [ allpoles; zeros( PZG(2).PureDelay, 1 ) ];
            end
          end
          modalss = pzg_moda( [], newzeros, newpoles, newgain, PZG(2).Ts );
          if allplot
            allmdlss = pzg_moda( [], allzeros, allpoles, allgain, PZG(2).Ts );
          end
        end
        AA = modalss.a;
        BC = modalss.b*modalss.c;
        DD = modalss.d;
        Loci = zeros(size(modalss.a,1),numel(GAINS));
        if allplot
          allAA = allmdlss.a;
          allBC = allmdlss.b*allmdlss.c;
          allDD = allmdlss.d;
          allLoci = zeros(size(allmdlss.a,1),numel(GAINS));
        end
        if GAINS(1) == 0
          Loci(:,1) = eig(AA);
          for kg = 2:numel(GAINS)
            if (DD+1/GAINS(kg)) ~= 0
              Loci(:,kg) = eig( AA-BC/(DD+1/GAINS(kg)) );
            else
              Loci(:,kg) = inf;
            end
          end
          if allplot
            allLoci(:,1) = eig(allAA);
            for kg = 2:numel(GAINS)
              if (allDD+1/GAINS(kg)) ~= 0
                allLoci(:,kg) = eig( allAA-allBC/(allDD+1/GAINS(kg)) );
              else
                allLoci(:,kg) = inf;
              end
            end
          end
        else
          for kg = 1:numel(GAINS)
            if (DD+1/GAINS(kg)) ~= 0
              Loci(:,kg) = eig( AA-BC/(DD+1/GAINS(kg)) );
            else
              Loci(:,kg) = inf;
            end
          end
          if allplot
            for kg = 1:numel(GAINS)
              if (allDD+1/GAINS(kg)) ~= 0
                allLoci(:,kg) = eig( allAA-allBC/(allDD+1/GAINS(kg)) );
              else
                allLoci(:,kg) = inf;
              end
            end
          end
        end
        unitygain_clpoles = eig( AA-BC/(DD+1) );
        Loci = Loci(:);
        rlocpz_h = pzg_fndo( M, 9+M,'pzmove_temporary_line');        
        if ( ~allplot && isequal( numel(rlocpz_h), 3 ) ) ...
          ||( allplot && isequal( numel(rlocpz_h), 5 ) )
          if allplot
            set( rlocpz_h(5), ...
                'xdata', real(allLoci), ...
                'ydata', imag(allLoci), ...
                'color', [0.7 0.7 0.7], ...
                'marker','.', ...
                'linewidth', temp_linewidth, ...
                'linestyle','none', ...
                'visible','on');
            unitygain_allclpoles = eig( allAA-allBC/(allDD+1) );
            set( rlocpz_h(4), ...
                'xdata', real(unitygain_allclpoles), ...
                'ydata', imag(unitygain_allclpoles), ...
                'linewidth', temp_linewidth, ...
                'color',ugcross_color, ...
                'linestyle','none', ...
                'marker','s', ...
                'markersize', 10, ...
                'visible','on');
          end
          set( rlocpz_h(3), ...
              'xdata', real(Loci), ...
              'ydata', imag(Loci), ...
              'color', rloc_color, ...
              'visible','on' );
          if ~isempty(PZG(M).Selection) && ( PZG(M).Selection(1) == 1 )
            % Zero is being moved.
            set( rlocpz_h(2), ...
                'xdata', real(PZG(M).ZeroLocs), ...
                'ydata', imag(PZG(M).ZeroLocs), ...
                'color', [0.8 0 0], ...
                'marker','o', ...
                'markersize', 8, ...
                'linewidth', 3, ...
                'linestyle','none', ...
                'visible','on');
          else
            % Pole is being moved.
            set( rlocpz_h(2), ...
                'xdata', real(PZG(M).PoleLocs), ...
                'ydata', imag(PZG(M).PoleLocs), ...
                'color', [0 0.8 0], ...
                'marker','x', ...
                'markersize', 8, ...
                'linewidth', 3, ...
                'linestyle','none', ...
                'visible','on');
          end
          set( rlocpz_h(1), ...
              'xdata', real(unitygain_clpoles), ...
              'ydata', imag(unitygain_clpoles), ...
              'color',ugcross_color, ...
              'linestyle','none', ...
              'marker','s', ...
              'markersize', 10, ...
              'visible','on');
        else
          delete(rlocpz_h)
          h5 = [];
          h4 = [];
          if allplot
            h5 = plot( real(allLoci), imag(allLoci), ...
                 'linewidth', temp_linewidth, ...
                 'color', [0.7 0.7 0.7], ...
                 'linestyle','none', ...
                 'marker','.', ...
                 'parent', rl_ax_h, ...
                 'tag','pz-move temporary line');
            unitygain_allclpoles = eig( allAA-allBC/(allDD+1) );
            h4 = plot( real(unitygain_allclpoles), ...
                       imag(unitygain_allclpoles), ...
                      'linewidth', temp_linewidth, ...
                      'color', 1-get(rl_ax_h,'color'), ...
                      'linestyle','none', ...
                      'marker','s', ...
                      'markersize', 10, ...
                      'parent', rl_ax_h, ...
                      'tag','pz-move temporary line');
          end
          h3 = plot( real(Loci), imag(Loci), ...
                    'linewidth', temp_linewidth, ...
                    'color', rloc_color, ...
                    'linestyle','none', ...
                    'marker','.', ...
                    'parent', rl_ax_h, ...
                    'tag','pz-move temporary line');
          if ~isempty(PZG(M).Selection) && ( PZG(M).Selection(1) == 1 )
            % Zero is being moved.
            h2 = plot( real(PZG(M).ZeroLocs), imag(PZG(M).ZeroLocs), ...
                 'linewidth', temp_linewidth, ...
                 'color',[0.8 0 0], ...
                 'linestyle','none', ...
                 'linewidth', 3, ...
                 'marker','o', ...
                 'markersize', 8, ...
                 'parent', rl_ax_h, ...
                 'tag','pz-move temporary line');
          else
            % Pole is being moved.
            h2 = plot( real(PZG(M).PoleLocs), imag(PZG(M).PoleLocs), ...
                 'linewidth', temp_linewidth, ...
                 'color',[0 0.8 0], ...
                 'linestyle','none', ...
                 'linewidth', 3, ...
                 'marker','x', ...
                 'markersize', 8, ...
                 'parent', rl_ax_h, ...
                 'tag','pz-move temporary line');
          end
          h1 = plot( real(unitygain_clpoles), imag(unitygain_clpoles), ...
               'linewidth', temp_linewidth, ...
               'color',ugcross_color, ...
               'linestyle','none', ...
               'marker','s', ...
               'markersize', 10, ...
               'parent', rl_ax_h, ...
               'tag','pz-move temporary line');
          rlocpz_h = [ h1; h2; h3; h4; h5 ];
          rloc_hndl.pzmove_temporary_line = rlocpz_h;
          setappdata( rlocus_h,'hndl', rloc_hndl );
          PZG(1).plot_h{9+M}.hndl.pzmove_temporary_line = rlocpz_h;
          PZG(2).plot_h{9+M}.hndl.pzmove_temporary_line = rlocpz_h;
        end
      end
      
      if ~isempty(sens_h)
        if isappdata( sens_h,'hndl')
          sens_hndl = getappdata( sens_h,'hndl');
        else
          sens_hndl = [];
        end
        if isfield( sens_hndl,'ax')
          sens_ax_h = sens_hndl.ax;
        else
          sens_ax_h = PZG(M).plot_h{5}.ax_h;
        end        
        set( sens_ax_h,'xlimmode','manual','ylimmode','manual');

        sens_frf = 1 ./( 1 + this_frf );
        if all_plot
          sens_frf_wo_des_db = 20*log10(abs( 1 ./ ( 1 + frf_wo_design ) ) );
        end
        hz_h = findobj( sens_h,'string','Hz');
        if get(hz_h,'value')
          plot_freq = this_freq * (1/2/pi);
        else
          plot_freq = this_freq;
        end
        plot_mag = 20*log10( abs(sens_frf) );  % Plot is only in dB, no choice.
        sens_ax_h = findobj( sens_h,'tag','pzg bode plot axes');
        set( sens_ax_h,'xlimmode','manual','ylimmode','manual');
        
        movepz_h = pzg_fndo( M, 5,'pzmove_temporary_line');
        movepz_h2 = [];
        if ( ~all_plot && ~isequal( numel(movepz_h), 1 ) ) ...
          ||( all_plot && ~isequal( numel(movepz_h), 2 ) )
          delete(movepz_h)
          if all_plot
            movepz_h2 = ...
              plot( plot_freq, sens_frf_wo_des_db, ...
                 'linewidth', temp_linewidth, ...
                 'color',[0.8 0 0], ...
                 'linestyle', temp_linestyle, ...
                 'parent', sens_ax_h, ...
                 'tag','pz-move temporary line');
          end
          movepz_h = ...
            plot( plot_freq, plot_mag, ...
               'linewidth', temp_linewidth, ...
               'color', temp_color, ...
               'linestyle', temp_linestyle, ...
               'parent', sens_ax_h, ...
               'tag','pz-move temporary line');
          movepz_h = [ movepz_h; movepz_h2 ];
          sens_hndl.pzmove_temporary_line = movepz_h;
          setappdata( sens_h,'hndl', sens_hndl );
          PZG(M).plot_h{5}.hndl.pzmove_temporary_line = movepz_h;
        else
          if all_plot
            set( movepz_h(2), ...
                'xdata', plot_freq, ...
                'ydata', sens_frf_wo_des_db, ...
                'color',[0.8 0 0], ...
                'visible','on');
          end
          set( movepz_h(1), ...
              'xdata', plot_freq, ...
              'ydata', plot_mag, ...
              'color', temp_color, ...
              'visible','on');
        end
      end
      
      if ~isempty(nich_h)
        if isappdata( nich_h,'hndl')
          nich_hndl = getappdata( nich_h,'hndl');
        else
          nich_hndl = [];
        end
        if isfield( nich_hndl,'ax')
          nich_ax_h = nich_hndl.ax;
        else
          nich_ax_h = PZG(M).plot_h{6}.ax_h;
        end        
        set( nich_ax_h,'xlimmode','manual','ylimmode','manual');

        movepz_h = pzg_fndo( M, 6,'pzmove_temporary_line');        
        unwrp_phs = ...
          pzg_unwrap( this_freq, this_frf_rad*180/pi, Domain,'open');
        nyqcb_h = findobj( nich_h,'tag','show nyq mapping checkbox');
        nr_temp_plots = 1;
        if all_plot
          nr_temp_plots = 2;
        end
        if get( nyqcb_h,'value')
          nr_temp_plots = 2*nr_temp_plots;
        end
        if ~isequal( numel(movepz_h), nr_temp_plots )
          delete(movepz_h)
          hx = [];
          if all_plot
            hx = plot( unwrp_phs-design_frf_phs, this_frf_dB-design_frf_db, ...
                 'linewidth', temp_linewidth, ...
                 'color',[0.8 0 0], ...
                 'linestyle', temp_linestyle, ...
                 'parent', nich_ax_h, ...
                 'tag','pz-move temporary line');
            if get( nyqcb_h,'value')
              h3 = plot( design_frf_phs-unwrp_phs, this_frf_dB-design_frf_db, ...
                   'linewidth', temp_linewidth, ...
                   'color', 1-get(nich_ax_h,'color'), ...
                   'linestyle', temp_linestyle, ...
                   'parent', nich_ax_h, ...
                   'tag','pz-move temporary line');
              hx = [ h3; hx ];
            end
          end
          if get( nyqcb_h,'value')
            h2 = plot( -unwrp_phs, this_frf_dB, ...
                 'linewidth', temp_linewidth, ...
                 'color', [0.7 0.7 0.7], ...
                 'linestyle', temp_linestyle, ...
                 'parent', nich_ax_h, ...
                 'tag','pz-move temporary line');
          else
            h2 = [];
          end
          h1 = plot( unwrp_phs, this_frf_dB, ...
               'linewidth', temp_linewidth, ...
               'color', temp_color, ...
               'linestyle', temp_linestyle, ...
               'parent', nich_ax_h, ...
               'tag','pz-move temporary line');
          movepz_h = [ h1; h2; hx ];
        else
          if all_plot
            set( movepz_h(nr_temp_plots), ...
                'xdata', unwrp_phs-design_frf_phs, ...
                'ydata', this_frf_dB-design_frf_db, ...
                'color',[0.8 0 0], ...
                'visible','on');
            if get( nyqcb_h,'value')
              set( movepz_h(nr_temp_plots-1), ...
                  'xdata', design_frf_phs-unwrp_phs, ...
                  'ydata', this_frf_dB-design_frf_db, ...
                  'color', 1-get(nich_ax_h,'color'), ...
                  'visible','on');
            end
          end
          if get( nyqcb_h,'value')
            set( movepz_h(2), ...
                'xdata', -unwrp_phs, ...
                'ydata', this_frf_dB, ...
                'color', [0.7 0.7 0.7], ...
                'visible','on');
          end
          set( movepz_h(1), ...
              'xdata', unwrp_phs, ...
              'ydata', this_frf_dB, ...
              'color', temp_color, ...
              'visible','on');
        end
        nich_hndl.pzmove_temporary_line = movepz_h;
        setappdata( nich_h,'hndl', nich_hndl );
        PZG(M).plot_h{6}.hndl.pzmove_temporary_line = movepz_h;
      end
      
      if ~isempty(nyq_h)
        if isappdata( nyq_h,'hndl')
          nyq_hndl = getappdata( nyq_h,'hndl');
        else
          nyq_hndl = [];
        end
        if isfield( nyq_hndl,'ax')
          nyq_ax_h = nyq_hndl.ax;
        else
          nyq_ax_h = PZG(M).plot_h{7}.ax_h;
        end        
        set( nyq_ax_h,'xlimmode','manual','ylimmode','manual');

        hyb_h = pzg_fndo( M, 7,'rescale_checkbox');
        if get( hyb_h,'value')
          nyq_frf = pzg_sclpt( this_frf );
        else
          nyq_frf = this_frf;
        end
        if all_plot
          if get( hyb_h,'value')
            cplxdata_wo_des_mag = abs(frf_wo_design);
            cplxdata_wo_des_phs = angle(frf_wo_design);
            gt1_ndx = find( cplxdata_wo_des_mag > 1 );
            if ~isempty(gt1_ndx)
              cplxdata_wo_des_mag(gt1_ndx) = ...
                1 + log10(cplxdata_wo_des_mag(gt1_ndx));
            end
            lt1_ndx = find( cplxdata_wo_des_mag < 1 );
            if ~isempty(lt1_ndx)
              min_log10_abs_contour_mapping = ...
                 log10( min( cplxdata_wo_des_mag(lt1_ndx) ) );
              cplxdata_wo_des_mag(lt1_ndx) = ...
                1./( 1 + abs( 10/min_log10_abs_contour_mapping ...
                             *log10(cplxdata_wo_des_mag(lt1_ndx))) );
            end
            nyq_frf_wo_des = ...
              cplxdata_wo_des_mag .* exp( 1i*cplxdata_wo_des_phs );
          else
            nyq_frf_wo_des = frf_wo_design;
          end
        end
        
        movepz_h = pzg_fndo( M, 7,'pzmove_temporary_line');        
        if ( ~all_plot && ~isequal( numel(movepz_h), 2 ) ) ...
          ||( all_plot && ~isequal( numel(movepz_h), 4 ) )
          hx = [];
          if all_plot
            hx = plot( real(nyq_frf_wo_des), imag(nyq_frf_wo_des), ...
                 'linewidth', temp_linewidth, ...
                 'color', [0.8 0 0], ...
                 'linestyle', temp_linestyle, ...
                 'parent', nyq_ax_h, ...
                 'tag','pz-move temporary line');
            h3 = plot( real(nyq_frf_wo_des), -imag(nyq_frf_wo_des), ...
                 'linewidth', temp_linewidth, ...
                 'color', 1-get(nyq_ax_h,'color'), ...
                 'linestyle', temp_linestyle, ...
                 'parent', nyq_ax_h, ...
                 'tag','pz-move temporary line');
            hx = [ h3; hx ];
          end
          h2 = plot( real(nyq_frf), imag(nyq_frf), ...
               'linewidth', temp_linewidth, ...
               'color', [0.7 0 0.7], ...
               'linestyle', temp_linestyle, ...
               'parent', nyq_ax_h, ...
               'tag','pz-move temporary line');
          h1 = plot( real(nyq_frf), -imag(nyq_frf), ...
               'linewidth', temp_linewidth, ...
               'color', [0.7 0.7 0.7], ...
               'linestyle', temp_linestyle, ...
               'parent', nyq_ax_h, ...
               'tag','pz-move temporary line');
          movepz_h = [ h1; h2; hx ];
        else
          if all_plot
            set( movepz_h(4), ...
                'xdata', real(nyq_frf_wo_des), ...
                'ydata', imag(nyq_frf_wo_des), ...
                'color', [0.8 0 0], ...
                'visible','on');
            set( movepz_h(3), ...
                'xdata', real(nyq_frf_wo_des), ...
                'ydata', -imag(nyq_frf_wo_des), ...
                'color', 1-get(nyq_ax_h,'color'), ...
                'visible','on');
          end
          set( movepz_h(2), ...
              'xdata', real(nyq_frf), ...
              'ydata', imag(nyq_frf), ...
              'color', [0.7 0 0.7], ...
              'visible','on');
          set( movepz_h(1), ...
              'xdata', real(nyq_frf), ...
              'ydata', -imag(nyq_frf), ...
              'color', [0.7 0.7 0.7], ...
              'visible','on');
        end
        nyq_hndl.pzmove_temporary_line = movepz_h;
        setappdata( nyq_h,'hndl', nyq_hndl );
        PZG(M).plot_h{7}.hndl.pzmove_temporary_line = movepz_h;
      end
      
      if ~isempty(olresp_h)
        if isappdata( olresp_h,'hndl')
          olresp_hndl = getappdata( olresp_h,'hndl');
        else
          olresp_hndl = [];
        end
        if isfield( olresp_hndl,'ax')
          olresp_ax_h = olresp_hndl.ax;
        else
          olresp_ax_h = PZG(M).plot_h{8}.ax_h;
        end        
        set( olresp_ax_h,'xlimmode','manual','ylimmode','manual');
        % Determine the input transfer function.
        menu_h = findobj( olresp_h,'tag','input-type popupmenu');
        SigType = get(menu_h,'value');
        cosfreq_hz = 0;
        switch SigType
            case {1,2,3,4}
              [ inzero, inpole, ingain ] = pzg_inzpk( SigType, M );
          case 5
            cosfreq_h = ...
              findobj( olresp_h, ...
                      'style','edit',...
                      'tag','visible for periodic only');
            cosfreq_hz = str2double( get(cosfreq_h,'string') );
            [ inzero, inpole, ingain ] = pzg_inzpk( SigType, M, cosfreq_hz );
          otherwise
        end
        % Get the time-vector.
        line_h = pzg_fndo( M, 8,'pzgui_resppl_resp_line');
        timevec = get(line_h(1),'xdata');
        if M == 1
          Ts = 0;
        else
          Ts = PZG(2).Ts;
        end
        nr_dt_delay_poles = 0;
        if M == 1
          if isempty(design)
            [ resp_res, resp_poles, resp_direct ] = ...
                 pzg_rsppfe( M, inzero, inpole, ingain,'open loop', 0, 1 );
          else
            [ resp_res, resp_poles, resp_direct ] = ...
                 pzg_rsppfe( M, inzero, inpole, ingain,'open loop', 1, 1 );
            [ respwo_res, respwo_poles, respwo_direct ] = ...
                 pzg_rsppfe( M, inzero, inpole, ingain,'open loop', 0, 1 );
          end
        else
          PPP = [ inpole; PZG(2).PoleLocs ];
          ZZZ = [ inzero; PZG(2).ZeroLocs ];
          KKK = ingain * PZG(2).Gain;
          % Delete any canceling poles and zeros.
          for kzzz = numel(ZZZ):-1:1
            cancel_ndx = find( abs( PPP - ZZZ(kzzz) ) < 1e-10 );
            if ~isempty(cancel_ndx)
              ZZZ(kzzz) = [];
              PPP(cancel_ndx(1)) = [];
            end
          end
          if ~isempty(design)
            ZZZwo = ZZZ;
            PPPwo = PPP;
            KKKwo = KKK;
            ZZZ = [ ZZZ(:); design.z(:) ];
            PPP = [ PPP(:); design.p(:) ];
            KKK = KKK * design.k;
          end
          nr_dt_delay_poles = PZG(2).PureDelay;
          zeroPPP_ndx = find( abs(PPP) < 1e-10 );
          if ( numel(zeroPPP_ndx) > 0 ) && ( numel(PPP) > (1+numel(ZZZ)) )
            while ( numel(PPP) > numel(ZZZ) ) && ~isempty(zeroPPP_ndx)
              PPP(zeroPPP_ndx(1)) = [];
              nr_dt_delay_poles = nr_dt_delay_poles + 1;
              zeroPPP_ndx = find( abs(PPP) < 1e-10 );
            end
            % Delete any canceling zeros.
            zeroZZZ_ndx = find( abs(ZZZ) < 1e-10 );
            for kzzz = numel(zeroZZZ_ndx):-1:1
              if numel(zeroPPP_ndx) > 0
                ZZZ(zeroZZZ_ndx(kzzz)) = [];
                zeroZZZ_ndx(kzzz) = [];
                PPP(zeroPPP_ndx(end)) = [];
                zeroPPP_ndx(end) = [];
              end
            end
          end
          zeroPPP_ndx = find( abs(PPP) < 1e-10 );
          while ( numel(PPP) > (1+numel(ZZZ)) ) && ( numel(zeroPPP_ndx) > 0 )
            nr_dt_delay_poles = nr_dt_delay_poles + 1;
            PPP(zeroPPP_ndx(end)) = [];
            zeroPPP_ndx(end) = [];
          end
          if isempty(PPP)
            resp_res = [];
            resp_poles = [];
            resp_direct = KKK;
          else
            [ resp_res, resp_poles, resp_direct ] = pzg_res( ZZZ, PPP, KKK );
          end
          
          if all_plot
            nr_dt_delay_poles = PZG(2).PureDelay;
            zeroPPP_ndx = find( abs(PPPwo) < 1e-10 );
            if ( numel(zeroPPP_ndx) > 0 ) && ( numel(PPPwo) > (1+numel(ZZZwo)) )
              while ( numel(PPPwo) > numel(ZZZwo) ) && ~isempty(zeroPPP_ndx)
                PPPwo(zeroPPP_ndx(1)) = [];
                nr_dt_delay_poles = nr_dt_delay_poles + 1;
                zeroPPP_ndx = find( abs(PPPwo) < 1e-10 );
              end
              % Delete any canceling zeros.
              zeroZZZ_ndx = find( abs(ZZZwo) < 1e-10 );
              for kzzz = numel(zeroZZZ_ndx):-1:1
                if numel(zeroPPP_ndx) > 0
                  ZZZwo(zeroZZZ_ndx(kzzz)) = [];
                  zeroZZZ_ndx(kzzz) = [];
                  PPPwo(zeroPPP_ndx(end)) = [];
                  zeroPPP_ndx(end) = [];
                end
              end
            end
            zeroPPP_ndx = find( abs(PPPwo) < 1e-10 );
            while ( numel(PPPwo) > (1+numel(ZZZwo)) ) && ( numel(zeroPPP_ndx) > 0 )
              nr_dt_delay_poles = nr_dt_delay_poles + 1;
              PPPwo(zeroPPP_ndx(end)) = [];
              zeroPPP_ndx(end) = [];
            end
            if isempty(PPPwo)
              respwo_res = [];
              respwo_poles = [];
              respwo_direct = KKKwo;
            else
              [ respwo_res, respwo_poles, respwo_direct ] = ...
                  pzg_res( ZZZwo, PPPwo, KKKwo );
            end
          end
        end
        if all( resp_res == 0 )
          disp('all zero residues (1)')
        end
        [timevec, y, y_natfrc ] = ...
            pzg_pfesim( resp_res, resp_poles, resp_direct, ...
                        timevec, Ts,'open loop', SigType, ...
                        2*pi*cosfreq_hz, nr_dt_delay_poles );
        
        if all_plot
          [ timevec, y_wo ] = ...
              pzg_pfesim( respwo_res, respwo_poles, respwo_direct, ...
                          timevec, Ts,'open loop', SigType, ...
                          2*pi*cosfreq_hz, nr_dt_delay_poles );
        end
        
        forc_ndx = [];
        natl_ndx = [];
        if ~isempty(y_natfrc)
          nnegimag_poles = resp_poles( imag(resp_poles) >= 0 );
          if ~isempty(inpole)
            forc_ndx = find( nnegimag_poles == inpole(1) );
          end
          switch SigType
            case 1
              forc_ndx = [];
            case {2,5}
              forc_ndx = forc_ndx(1);
            case 3
              forc_ndx = forc_ndx(1:2);
            case 4
              forc_ndx = forc_ndx(1:3);
            otherwise
          end
          natl_ndx = setdiff( (1:size(y_natfrc,1))', forc_ndx(:) );
        end
        % Plot the temporary output.
        if all_plot
          forc_color = [0.8 0 0.8];
          natl_color = [0.7 0 0.7];
        else
          forc_color = [0 0.8 0.8];
          natl_color = [0.7 0.7 0.7];
        end
        
        movepz_h = pzg_fndo( M, 8,'pzmove_temporary_line');
        natl_cb_h = pzg_fndo( M, 8,'natl_h_checkbox'); 
        movepz_natl_h = pzg_fndo( M, 8,'pzmove_temporary_natl_line');
        forc_cb_h = pzg_fndo( M, 8,'forc_h_checkbox');
        movepz_forc_h = pzg_fndo( M, 8,'pzmove_temporary_forc_line');
        
        y_natfrc = y_natfrc.';
        
        if ~isempty(forc_ndx)
          t_forc = [ timevec(:)*ones(1,numel(forc_ndx)); ...
                     NaN*ones(1,numel(forc_ndx)) ];
          y_forc = [ y_natfrc(:,forc_ndx); ...
                     NaN*ones(1,numel(forc_ndx)) ];
          if ~isequal( numel(movepz_forc_h), 1 ) ...
            || ~isequal( 1, sum(ishandle(movepz_forc_h)) )
            delete(movepz_forc_h)
            movepz_forc_h = ...
              plot( t_forc(:), y_forc(:), ...
                'linewidth', 2, ...
                'color', forc_color, ...
                'linestyle',':', ...
                'parent', olresp_ax_h, ...
                'tag','pz-move temporary forc line');
            PZG(M).plot_h{8}.hndl.pzmove_temporary_forc_line = movepz_forc_h;
          else
              set( movepz_forc_h, ...
                'xdata', t_forc(:), ...
                'ydata', y_forc(:) );
          end
          if get(forc_cb_h,'value')
            set( movepz_forc_h,'visible','on');
          else
            set( movepz_forc_h,'visible','off');
          end
        elseif isequal( numel(movepz_forc_h), 1 ) ...
            && isequal( 1, sum(ishandle(movepz_forc_h)) )
          set( movepz_forc_h,'xdata',[],'ydata',[],'visible','off')
        end

        if ~isempty(natl_ndx)
          t_natl = [ timevec(:)*ones(1,numel(natl_ndx)); ...
                     NaN*ones(1,numel(natl_ndx)) ];
          y_natl = [ y_natfrc(:,natl_ndx); ...
                     NaN*ones(1,numel(natl_ndx)) ];
          if ~isequal( numel(movepz_natl_h), 1 ) ...
            || ~isequal( sum(ishandle(movepz_natl_h)), 1 )
            delete(movepz_natl_h)
            movepz_natl_h = ...
              plot( t_natl(:), y_natl(:), ...
                'linewidth', 2, ...
                'color', natl_color, ...
                'linestyle',':', ...
                'parent', olresp_ax_h, ...
                'tag','pz-move temporary natl line');
            PZG(M).plot_h{8}.hndl.pzmove_temporary_natl_line = movepz_natl_h;
          else
            set( movepz_natl_h, ...
              'xdata', t_natl(:), ...
              'ydata', y_natl(:) );
          end
          if get(natl_cb_h,'value')
            set( movepz_natl_h,'visible','on');
          else
            set( movepz_natl_h,'visible','off');
          end
        elseif isequal( numel(movepz_natl_h), 1 ) ...
            && isequal( 1, sum(ishandle(movepz_natl_h)) )
          set( movepz_natl_h,'xdata',[],'ydata',[],'visible','off')
        end
        
        if ( ~all_plot && ~isequal( numel(movepz_h), 1 ) ) ...
          ||( all_plot && ~isequal( numel(movepz_h), 2 ) )

          if isempty(movepz_h)
            movepz_h = ...
              plot( timevec, real(y), ...
                 'linewidth', temp_linewidth, ...
                 'color', temp_color, ...
                 'linestyle', temp_linestyle, ...
                 'parent', olresp_ax_h, ...
                 'tag','pz-move temporary line');
            PZG(M).plot_h{8}.hndl.pzmove_temporary_line = movepz_h;
          else
            set( movepz_h(1), ...
                'xdata', timevec, ...
                'ydata', real(y), ...
                'color', temp_color, ...
                'visible','on');
          end
          if all_plot
            if numel(movepz_h) == 1
              movepz_h = [ movepz_h; movepz_h ];
              movepz_h(2) = ...
                plot( timevec, real(y_wo), ...
                   'linewidth', temp_linewidth, ...
                   'color',[0.8 0 0], ...
                   'linestyle', temp_linestyle, ...
                   'parent', olresp_ax_h, ...
                   'tag','pz-move temporary line');
              PZG(M).plot_h{8}.hndl.pzmove_temporary_line = movepz_h;
            else
              if numel(movepz_h) > 2
                delete(movepz_h(3:end))
                movepz_h(3:end) = [];
              end
              set( movepz_h(2), ...
                  'xdata', timevec, ...
                  'ydata', real(y_wo), ...
                  'color',[0.8 0 0], ...
                  'visible','on')
            end
          end
        else
          set( movepz_h(1),'xdata', timevec,'ydata', real(y),'visible','on');
          if all_plot
            set( movepz_h(2), ...
                'xdata', timevec,'ydata', real(y_wo),'visible','on');
          end
        end
        olresp_hndl.pzmove_temporary_line = movepz_h;
        setappdata( olresp_h,'hndl', olresp_hndl );
        PZG(M).plot_h{8}.hndl.pzmove_temporary_line = movepz_h;
      end
      
      if ~isempty(clresp_h)
        if isappdata( clresp_h,'hndl')
          clresp_hndl = getappdata( clresp_h,'hndl');
        else
          clresp_hndl = [];
        end
        if isfield( clresp_hndl,'ax')
          clresp_ax_h = clresp_hndl.ax;
        else
          clresp_ax_h = PZG(M).plot_h{8}.ax_h;
        end        
        set( clresp_ax_h,'xlimmode','manual','ylimmode','manual');
        % Determine the input transfer function.
        menu_h = findobj( clresp_h,'tag','input-type popupmenu');
        SigType = get(menu_h,'value');
        cosfreq_hz = 0;
        switch SigType
            case {1,2,3,4}
              [ inzero, inpole, ingain ] = pzg_inzpk( SigType, M );
          case 5
            cosfreq_h = ...
              findobj( clresp_h, ...
                      'style','edit',...
                      'tag','visible for periodic only');
            cosfreq_hz = str2double( get(cosfreq_h,'string') );
            [ inzero, inpole, ingain ] = pzg_inzpk( SigType, M, cosfreq_hz );
          otherwise
        end
        delta_olgain = 1;
        % Get the time-vector.
        line_h = pzg_fndo( M, 9,'pzgui_resppl_resp_line', ...
                          'pzgui resppl resp line','line');
        timevec = get(line_h(1),'xdata');
        if M == 1
          Ts = 0;
        else
          Ts = PZG(2).Ts;
        end
        if isempty(design)
          [ resp_res, resp_poles, resp_direct ] = ...
               pzg_rsppfe( M, inzero, inpole, ingain, ...
                           'closed loop', 0, 1, delta_olgain );
        else
          [ resp_res, resp_poles, resp_direct ] = ...
               pzg_rsppfe( M, inzero, inpole, ingain, ...
                           'closed loop', 1, 1, delta_olgain );
          [ respwo_res, respwo_poles, respwo_direct ] = ...
               pzg_rsppfe( M, inzero, inpole, ingain, ...
                           'closed loop', 0, 1, delta_olgain );
        end
        
        if all( resp_res == 0 )
          disp('all zero residues (2)')
        end
        [ timevec, y, y_natfrc ] = ...
            pzg_pfesim( resp_res, resp_poles, resp_direct, ...
                        timevec, Ts,'closed loop', SigType, 2*pi*cosfreq_hz );
        if all_plot
          [ timevec, y_wo ] = ...
              pzg_pfesim( respwo_res, respwo_poles, respwo_direct, ...
                          timevec, Ts,'closed loop', SigType, 2*pi*cosfreq_hz );
        end
        
        forc_ndx = [];
        natl_ndx = [];
        if ~isempty(y_natfrc)
          nnegimag_poles = resp_poles( imag(resp_poles) >= 0 );
          if ~isempty(inpole)
            forc_ndx = find( nnegimag_poles == inpole(1) );
          end
          switch SigType
            case 1
              forc_ndx = [];
            case {2,5}
              forc_ndx = forc_ndx(1);
            case 3
              forc_ndx = forc_ndx(1:2);
            case 4
              forc_ndx = forc_ndx(1:3);
            otherwise
          end
          natl_ndx = setdiff( (1:size(y_natfrc,1))', forc_ndx(:) );
        end
        % Plot the temporary output.
        if all_plot
          forc_color = [0.8 0 0.8];
          natl_color = [0.7 0 0.7];
        else
          forc_color = [0 0.8 0.8];
          natl_color = [0.7 0.7 0.7];
        end
        
        y_natfrc = y_natfrc.';
        
        movepz_h = pzg_fndo( M, 9,'pzmove_temporary_line');
        natl_cb_h = pzg_fndo( M, 9,'natl_h_checkbox'); 
        movepz_natl_h = pzg_fndo( M, 9,'pzmove_temporary_natl_line');
        forc_cb_h = pzg_fndo( M, 9,'forc_h_checkbox');
        movepz_forc_h = pzg_fndo( M, 9,'pzmove_temporary_forc_line');
        
        if ~isempty(forc_ndx)
          t_forc = [ timevec(:)*ones(1,numel(forc_ndx)); ...
                     NaN*ones(1,numel(forc_ndx)) ];
          y_forc = [ y_natfrc(:,forc_ndx); ...
                     NaN*ones(1,numel(forc_ndx)) ];
          if ~isequal( numel(movepz_forc_h), 1 ) ...
            || ~isequal( 1, sum(ishandle(movepz_forc_h)) )
            delete(movepz_forc_h)
            movepz_forc_h = ...
              plot( t_forc(:), y_forc(:), ...
                 'linewidth', 2, ...
                 'color', forc_color, ...
                 'linestyle',':', ...
                 'parent', clresp_ax_h, ...
                 'tag','pz-move temporary forc line');
            PZG(M).plot_h{9}.hndl.pzmove_temporary_forc_line = movepz_forc_h;
          else
            set( movepz_forc_h, ...
              'xdata', t_forc(:), ...
              'ydata', y_forc(:) );
          end
          if get(forc_cb_h,'value')
            set( movepz_forc_h,'visible','on');
          else
            set( movepz_forc_h,'visible','off');
          end
        elseif isequal( numel(movepz_forc_h), 1 ) ...
            && isequal( 1, sum(ishandle(movepz_forc_h)) )
          set( movepz_forc_h,'xdata',[],'ydata',[],'visible','off');
        end
        
        if ~isempty(natl_ndx)
          t_natl = [ timevec(:)*ones(1,numel(natl_ndx)); ...
                     NaN*ones(1,numel(natl_ndx)) ];
          y_natl = [ y_natfrc(:,natl_ndx); ...
                     NaN*ones(1,numel(natl_ndx)) ];
          if ~isequal( numel(movepz_natl_h), 1 ) ...
            ||~isequal( sum(ishandle(movepz_natl_h)), 1 )
            delete(movepz_natl_h)
            movepz_natl_h = ...
              plot( t_natl(:), y_natl(:), ...
                'linewidth', 2, ...
                'color', natl_color, ...
                'linestyle',':', ...
                'parent', clresp_ax_h, ...
                'tag','pz-move temporary natl line');
            PZG(M).plot_h{9}.hndl.pzmove_temporary_natl_line = movepz_natl_h;
          else
            set( movepz_natl_h, ...
              'xdata', t_natl(:), ...
              'ydata', y_natl(:) );
          end
          if get(natl_cb_h,'value')
            set( movepz_natl_h,'visible','on');
          else
            set( movepz_natl_h,'visible','off');
          end
        elseif isequal( numel(movepz_natl_h), 1 ) ...
            && isequal( 1, sum(ishandle(movepz_natl_h)) )
          set( movepz_natl_h,'xdata',[],'ydata',[],'visible','off');
        end
        
        if ( ~all_plot && ~isequal( numel(movepz_h), 1 ) ) ...
          ||( all_plot && ~isequal( numel(movepz_h), 2 ) )
          delete(movepz_h)
          movepz_h = [];
          if isempty(movepz_h)
            movepz_h = ...
              plot( timevec, real(y), ...
                 'linewidth', temp_linewidth, ...
                 'color', temp_color, ...
                 'linestyle', temp_linestyle, ...
                 'parent', clresp_ax_h, ...
                 'tag','pz-move temporary line');
            PZG(M).plot_h{9}.hndl.pzmove_temporary_line = movepz_h;
          else
            set( movepz_h(1), ...
                'xdata', timevec, ...
                'ydata', real(y), ...
                'color', temp_color, ...
                'visible','on');
          end
          if all_plot
            if numel(movepz_h) == 1
              movepz_h = [ movepz_h; movepz_h ];
              movepz_h(2) = ...
                plot( timevec, real(y_wo), ...
                   'linewidth', temp_linewidth, ...
                   'color',[0.8 0 0], ...
                   'linestyle', temp_linestyle, ...
                   'parent', clresp_ax_h, ...
                   'tag','pz-move temporary line');
              PZG(M).plot_h{9}.hndl.pzmove_temporary_line = movepz_h;
            else
              if numel(movepz_h) > 2
                delete(movepz_h(3:end))
                movepz_h(3:end) = [];
              end
              set( movepz_h(2), ...
                  'xdata', timevec, ...
                  'ydata', real(y_wo), ...
                  'color',[0.8 0 0], ...
                  'visible','on')
            end
          end
        else
          set( movepz_h(1),'xdata', timevec,'ydata', real(y),'visible','on');
          if all_plot
            set( movepz_h(2), ...
                'xdata', timevec,'ydata', real(y_wo),'visible','on');
          end
        end
        clresp_hndl.pzmove_temporary_line = movepz_h;
        setappdata( clresp_h,'hndl', clresp_hndl );
        PZG(M).plot_h{9}.hndl.pzmove_temporary_line = movepz_h;
      end
    end
  end
end

if isequal( PZMoving, 0 )
  local_update_pid_ldlg(M)
  pzg_unre;
end

if isempty(PZG(M).BodeFreqs) && isequal( PZMoving, 0 )
  gui_h = findobj( allchild(0),'name', PZG(M).PZGUIname );
  if M == 1
    if PZG(1).recompute_frf
      PZG(1).recompute_frf = 0;
      pzg_cntr(1);
      pzg_bodex(1);
    end
    pzgui
    updatepl
    if ~isempty(gui_h)
      link_h = findobj( gui_h,'string','D-T Link by:');
      if isequal( get( link_h,'value'), 1 )
        PZG(2).recompute_frf = 0;
        pzg_cntr(2);
        pzg_bodex(2);
        dpzgui
        dupdatep
      end
    end
  else
    if PZG(2).recompute_frf
      PZG(2).recompute_frf = 0;
      pzg_cntr(2);
      pzg_bodex(2);
    end
    dpzgui
    dupdatep
    if ~isempty(gui_h)
      link_h = findobj( gui_h,'string','C-T Link by:');
      if isequal( get( link_h,'value'), 1 )
        PZG(1).recompute_frf = 0;
        pzg_cntr(1);
        pzg_bodex(1);
        pzgui
        updatepl
      end
    end
  end
end

return

function local_update_pid_ldlg(M)
  
  curr_tools = pzg_tools(M);
  if ~sum(curr_tools)
    return
  end
  if M == 1
    if curr_tools(1)
      gainfilt('s-Domain Pure Gain Design GUI');
    elseif curr_tools(2)
      ldlgfilt('s-Domain Lead Lag Design GUI');
    elseif curr_tools(3)
      ldlgfilt('s-Domain PID Design GUI');
    end
  else
    if curr_tools(1)
      gainfilt('z-Domain Pure Gain Design GUI');
    elseif curr_tools(2)
      ldlgfilt('z-Domain Lead Lag Design GUI');
    elseif curr_tools(3)
      ldlgfilt('z-Domain PID Design GUI');
    end
  end
return

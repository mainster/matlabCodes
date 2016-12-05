function   resppl(N,D,Gain,PlotName,PlotTitle,Domain,Ts,Position)
% Creates and services the PZGUI time-response plots.

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

gco0 = gco;
if isempty(gco0)
  gco0 = -1;
end

wb_h = [ findobj( allchild(0),'tag', 's resppl progress waitbar'); ...
         findobj( allchild(0),'tag', 'z resppl progress waitbar') ];
for k = numel(wb_h):-1:1
  %pause(0.1)
  if strcmp( get(wb_h(k),'visible'),'off')
    delete(wb_h(k))
    wb_h(k) = [];
  end
end
if ~isempty(wb_h)
  %disp(...
  % ['resppl:  ' ...
  %  'Apparently, RESP computation already underway ("waitbar" exists)'])
  return
end
wb_h = -1;

% Validate input arguments.
if ( nargin == 1 ) && ischar( N )
  local_service_cbstr( N )
  return
end

if ( nargin < 4 ) || ( nargin > 8 )
  disp('Correct format is:');
  disp('     resspl( Num, Den, Gain, PlotName ... ');
  disp('           <,PlotTitle> <,Domain> <,Ts> <,Position> )');
  return
end

if ( ~ischar(PlotName) ) || ( min(size(PlotName))~=1 )
  disp('Fourth input argument, PLOTNAME must be a simple string.');
  return
end
if nargin < 8
  Position = [];
end
if sum( ( ( size(Position) ~= [1 4] ) | ischar(Position) ) ...
       &( size(Position) ~= [0 0] )) > 0
  disp('8-th input arg, POSITION must be a 1-by-4 numerical array.');
  return
end
if nargin < 7
  Ts = 1;
end
if ( max(size(Ts)) ~= 1 ) || ( ischar(Ts) )
  disp('7-th input arg, TS must be a scalar.');
  return
end
if nargin < 6
  Domain = 's';
end
if ( ~ischar(Domain) ) || ( max(size(Domain) ~= 1 ) )
  disp(['6-th input argument,' ... 
         ' DOMAIN must be either ''s'' or ''z''.']);
  return
end
if nargin < 5
  PlotTitle = '';
end

if ( ~ischar(PlotTitle) ) || ( min(size(PlotTitle) > 1 ) )
  disp('Fifth input argument, PLOTTITLE must be a simple string.');
  return
end
if ( min(size(Gain))~=1 ) || ( max(size(Gain))~=1 )
  disp('Third input argument, GAIN must be a scalar.')
  return
end

if strcmp(Domain,'s')
  PZGndx = 1;
else
  PZGndx = 2;
end

if ~isempty( strfind( lower(PlotName),'closed') )
  architec = 'closed loop';
  PoleLocs = PZG(PZGndx).CLPoleLocs;
  ZeroLocs = PZG(PZGndx).CLZeroLocs;
else
  architec = 'open loop';
  PoleLocs = PZG(PZGndx).PoleLocs;
  ZeroLocs = PZG(PZGndx).ZeroLocs;
end


if isempty(PoleLocs) ...
   ||( ( Domain=='s') && ( max(real(PoleLocs)) >= 0 ) ) ...
   ||( ( Domain=='z') && ( max(abs(PoleLocs)) >= 1 ) )
  textVis = 'off';
else
  textVis = 'on';
end

FigHndl = findobj(allchild(0),'Name',PlotName);
if numel(FigHndl) > 1
  delete(FigHndl)
  FigHndl = [];
end

hndl = [];
if ~isempty(FigHndl)
  if isappdata(FigHndl,'hndl')
    hndl = getappdata( FigHndl,'hndl');
  end
  if ~isempty(Ts)
    set( get( get(FigHndl,'CurrentAxes'),'Xlabel'),'UserData',Ts );
  end
  temp0 = get( FigHndl,'UserData');
  TitlHndl = get(temp0(1,1),'Title');
  YLablHndl = get(temp0(1,1),'YLabel');
  if min(size(temp0)) > 0
    set(temp0(2,1),'UserData',Gain*N);
    set(temp0(4,1),'UserData',D);
    if ~isempty(PlotTitle)
      set(temp0(10,1),'UserData',PlotTitle);
    else
      if PZGndx == 1
        title_str = 'C-T ';
      else
        title_str = 'D-T ';
      end
      if isequal( hndl.ploth_ndx, 8 )
        title_str = [ title_str 'Open-Loop '];
      else
        title_str = [ title_str 'Closed-Loop '];
      end
      switch get( hndl.input_type_popupmenu,'value')
        case 1
          PlotTitle = [ title_str 'Unit-Impulse Response'];
        case 2
          PlotTitle = [ title_str 'Unit-Step Response'];
        case 3
          PlotTitle = [ title_str 'Unit-Ramp Response'];
        case 4
          if PZGndx == 1
            PlotTitle = [ title_str 'Unit-Parabola ' char(189) ' (t^2) Response'];
          else
            PlotTitle = ...
              [ title_str 'Unit-Parabola ' char(189) ' (kT)^2 Response'];
          end
        case 5
          PlotTitle = [ title_str 'Unit-Cosine Response'];
        otherwise
          PlotTitle = [ title_str 'Response'];
      end
      set( TitlHndl,'string', PlotTitle )
      set( temp0(10,1),'UserData', PlotTitle );
      if isequal( size(Position),[1 4])
        if max(Position) > 1
          ScrSize = get(0,'screensize');
          Position([1;3]) = Position([1;3])/ScrSize(3);
          Position([2;4]) = Position([2;4])/ScrSize(4);
        end
        set( FigHndl,'units','normalized','Position', Position );
      end
    end
  end
end

for k = numel(PoleLocs):-1:1
  sameloc_ndx = find( abs( PoleLocs(k) - ZeroLocs ) < 1e-12 );
  if ~isempty(sameloc_ndx)
    PoleLocs(k) = [];
    ZeroLocs(sameloc_ndx) = [];
  end
end
CoprimePoles = PoleLocs;

if ~isempty(CoprimePoles)
  if Domain == 'z'
    integ_ndxs = find( abs(CoprimePoles-1) < 1e-7 );
    stable_ndxs = find( abs(CoprimePoles) < (1-1e-7) );
    unstable_ndxs = find( abs(CoprimePoles) > (1+1e-7) );
    if ~isempty(integ_ndxs)
      DC_Gain = inf; 
    else
      if strcmp(architec,'closed loop')
        if ~isempty(PZG(2).PoleLocs) ...
          && any( PZG(2).PoleLocs == 1 )
          logDCgain = 0;
        elseif isequal( numel(PoleLocs), numel(ZeroLocs) )
          logDCgain = log( PZG(2).Gain/( 1 + PZG(2).Gain ) );
        else
          logDCgain = log( PZG(2).Gain );
        end
      else
        logDCgain = log( PZG(2).Gain);
      end
      if ~strcmp(architec,'closed loop') ...
        || isempty(PZG(2).PoleLocs) ...
        || ~any( PZG(2).PoleLocs == 1 )
        for k = 1:numel(CoprimePoles)
          if isempty( intersect(k,integ_ndxs) )
            logDCgain = logDCgain - log(1-CoprimePoles(k));
          end
          if numel(ZeroLocs) >= k
            logDCgain = logDCgain + log(1-ZeroLocs(k));
          end
        end
      end
      DC_Gain = real( exp( logDCgain ) );
    end
    
    TimeConstant = 200 * PZG(2).Ts;
    if ~isempty(stable_ndxs)
      maxRealPart = max( real( log(CoprimePoles(stable_ndxs)) ) )/PZG(2).Ts;
      s_poles = log(CoprimePoles(stable_ndxs))/PZG(2).Ts;
      domreal_rep = ...
        numel( find( abs( real(s_poles) - maxRealPart ) ...
                     < abs(maxRealPart)*1e-3 ) );
      TimeConstant = ( 1 / abs(maxRealPart) ) * max(1,domreal_rep/1.9);
    elseif ~isempty(unstable_ndxs)
      minRealPart = ...
        min( real( log(CoprimePoles(unstable_ndxs) ) ) )/PZG(2).Ts;
      TimeConstant = 1 / abs(minRealPart);
    end
    if ~isempty( PZG(2).ZeroLocs )
      s_zeros = log(PZG(2).ZeroLocs)/PZG(2).Ts;
      slowest_realpart = min( abs( real( s_zeros) ) );
      if slowest_realpart < 1e-10
        TimeConstant = 3*TimeConstant;
      else
        zeroeffect = 1/slowest_realpart;
        if zeroeffect > 2*TimeConstant
          TimeConstant = 2*TimeConstant;
        elseif zeroeffect > 0.8*TimeConstant
          TimeConstant = 1.5*TimeConstant;
        end    
      end
    end
  else
    % S-plane.
    integ_ndxs = find( abs(CoprimePoles) < 1e-8 );
    stable_ndxs = find( real(CoprimePoles) < -1e-8 );
    unstable_ndxs = find( real(CoprimePoles) > 1e-8 );
    if ~isempty(integ_ndxs)
      DC_Gain = inf;
    else
      if strcmp(architec,'closed loop')
        if ~isempty(PZG(1).PoleLocs) ...
          && any( PZG(1).PoleLocs == 0 )
          logDCgain = 0;
        elseif isequal( numel(PoleLocs), numel(ZeroLocs) )
          logDCgain = log( PZG(1).Gain/( 1 + PZG(1).Gain ) );
        else
          logDCgain = log( PZG(1).Gain );
        end
      else
        logDCgain = log( PZG(1).Gain );
      end
      if ~strcmp(architec,'closed loop') ...
        || isempty(PZG(1).PoleLocs) ...
        || ~any( PZG(1).PoleLocs == 0 )
        for k = 1:numel(CoprimePoles)
          if isempty( intersect(k,integ_ndxs) )
            logDCgain = logDCgain - log(-CoprimePoles(k));
          end
          if numel(ZeroLocs) >= k
            logDCgain = logDCgain + log(-ZeroLocs(k));
          end
        end
      end
      DC_Gain = real( exp( logDCgain ) );
    end
    
    TimeConstant = 200 * PZG(2).Ts;
    if ~isempty(stable_ndxs)
      maxRealPart = max( real( CoprimePoles(stable_ndxs)) );
      domreal_rep = ...
        numel( find( real(CoprimePoles(stable_ndxs)) == maxRealPart ) );
      TimeConstant = ( 1 / abs(maxRealPart) ) * max(1,domreal_rep/1.9);
    elseif ~isempty(unstable_ndxs)
      minRealPart = ...
        min( real( CoprimePoles(unstable_ndxs) ) );
      TimeConstant = 1 / abs(minRealPart);
    end
    if ~isempty( PZG(1).ZeroLocs )
      s_zeros = PZG(1).ZeroLocs;
      slowest_realpart = min( abs( real( s_zeros) ) );
      if slowest_realpart < 1e-10
        TimeConstant = 3*TimeConstant;
      else
        zeroeffect = 1/slowest_realpart;
        if zeroeffect > 2*TimeConstant
          TimeConstant = 2*TimeConstant;
        elseif zeroeffect > 0.8*TimeConstant
          TimeConstant = 1.5*TimeConstant;
        end    
      end
    end
  end
else
  DC_Gain = Gain;
  TimeConstant = 1;
end

CoprimeN = poly( ZeroLocs );
CoprimeD = poly( PoleLocs );

PlotLimit = 1e6;
natl_resp = [];
forc_resp = [];

% Default number of time-response samples.
def_nr_sim_samples = 5e4;
max_allowable_samples = PlotLimit;
if strcmpi( Domain,'s')
  PZGndx = 1;
else
  PZGndx = 2;
end
SigType = 2;
if TimeConstant > 0
  default_sim_time = 7*TimeConstant;
else
  default_sim_time = 100*PZG(2).Ts;
end
if PZGndx == 2
  default_sim_time = ...
    max( default_sim_time, (90+PZG(2).PureDelay)*PZG(2).Ts );
end
if ~isempty(FigHndl)
  temp0 = get( FigHndl,'userdata');
  if isnumeric(temp0) && ( size(temp0,1) > 6 ) && isequal( 2, size(temp0,2) )
    SigType = get( temp0(1,2),'value');
    default_sim_time = str2double( get( temp0(2,2),'string') );
  end
  if strcmpi('z', Domain )
    default_sim_time = max( default_sim_time, 10*PZG(2).Ts );
  end
else
  temp0 = [];
end

switch SigType
  case 1
    % Unit impulse
    input_zeros = [];
    if strcmpi( Domain,'s')
      input_poles = [];
    else
      input_poles = [];
    end
    input_gain = 1;
  case 2
    % Unit step:  1/s
    if strcmpi( Domain,'s')
      input_zeros = [];
      input_poles = 0;
      input_gain = 1;
    else
      % Note absence of zero at the origin:  divide-by-(z).
      input_zeros = 0;
      input_poles = 1;
      input_gain = 1;
    end
  case 3
    % Ordinary ramp:
    if strcmpi( Domain,'s')
      % t * unit-step ==> 1/s^2
      input_zeros = [];
      input_poles = [ 0; 0 ];
      input_gain = 1;
    else
      % Note absence of zero at the origin:  divide-by-(z).
      input_zeros = 0;
      input_poles = [ 1; 1 ];
      input_gain = PZG(2).Ts;
    end
  case 4
    % Ordinary parabola:
    if strcmpi( Domain,'s')
      %  t^2 * unit-step ==> 2/s^3
      input_zeros = [];
      input_poles = [ 0; 0; 0 ];
      input_gain = 1;
    else
      % Note absence of zero at the origin:  divide-by-(z).
      %  t^2 * unit-step ==> 2*Z-equiv of t^2/2
      input_zeros = [ 0; -1 ];
      input_poles = [ 1; 1; 1 ];
      input_gain = ( PZG(2).Ts^2/2 );
    end
  case 5
    % Unit COSINE function
    freq_hz = str2num( get( temp0(8,2),'string') ); %#ok<ST2NM>
    if isempty(freq_hz) || ~isreal(freq_hz) ...
      || ( freq_hz == 0 ) || isinf(freq_hz) || isnan(freq_hz)
      freq_hz = get( temp0(8,2),'userdata');
      if ~isequal( numel(freq_hz), 1 ) || ~isreal(freq_hz)
        freq_hz = 1;
      end
    end
    
    % Turn on the correct set of UI controls
    ss_h = PZG(hndl.dom_ndx).plot_h{hndl.ploth_ndx} ...
           .hndl.pzgui_resppl_steadystate_only_checkbox;
    set( hndl.visible_for_sinusoid_only,'visible','on','enable','on')
    set( hndl.visible_for_periodic_only,'visible','on','enable','on')
    if get(ss_h,'value')
      
      
    else
      
      
    end
         
    if strcmpi( Domain,'z')
      if freq_hz >= 0
        freq_hz = mod( freq_hz, 1/PZG(2).Ts );
        if freq_hz == 0
          freq_hz = 0.5/PZG(2).Ts;
        end
      else
        freq_hz = mod( freq_hz, -1/PZG(2).Ts );
        if freq_hz == 0
          freq_hz = 0.5/PZG(2).Ts;
        end
      end
      if abs(freq_hz) > 0.5/PZG(2).Ts
        freq_hz = 1/PZG(2).Ts - abs(freq_hz);
      end
      freq_hz = abs(freq_hz);
    else
      freq_hz = abs(freq_hz);
    end
    
    if isequal( gcbo, temp0(1,2) ) ...
      && ( get( temp0(1,2),'value') > 4 ) && isequal( freq_hz, 1 )
      % If frequency equals the default (1 Hz), use selected freq.
      if strcmpi( Domain,'s') 
        sel_ndx = PZG(1).FrqSelNdx;
        if isequal( numel(sel_ndx), 1 ) && isreal(sel_ndx) ...
          && ( round(sel_ndx) == sel_ndx ) && ( sel_ndx > 0 ) ...
          && ( sel_ndx <= numel(PZG(1).BodeFreqs) )
          freq_hz = PZG(1).BodeFreqs(sel_ndx)/2/pi;
        end
      elseif strcmpi( Domain,'z') && ~isempty( PZG(2).FrqSelNdx )
        sel_ndx = PZG(2).FrqSelNdx;
        if isequal( numel(sel_ndx), 1 ) && isreal(sel_ndx) ...
          && ( round(sel_ndx) == sel_ndx ) && ( sel_ndx > 0 ) ...
          && ( sel_ndx <= numel(PZG(2).BodeFreqs) )
          freq_hz = PZG(2).BodeFreqs(sel_ndx)/2/pi;
        end
      end
    end
    
    inputFreq = freq_hz;
    def_ndig = 5;
    ndig = def_ndig;      
    if abs(inputFreq) < 0.1
      ndig = max( def_ndig, abs( floor(log10(abs(inputFreq))) ) );
    elseif strcmpi( Domain,'z')
      freq_mod_nyq = abs( abs(mod(abs(inputFreq),0.5/PZG(2).Ts)) - 0.5/PZG(2).Ts );
      if freq_mod_nyq < 0.1
        ndig = max( def_ndig, ...
                    ( abs( floor(log10(abs(freq_mod_nyq))) ) ...
                     +max( 0, floor(log10(0.5/PZG(2).Ts)) ) ) );
      end
    end
    if strcmpi( Domain,'z') && ( inputFreq > 0.5/PZG(2).Ts )
      selfreq_str = pzg_efmt( inputFreq - 1/PZG(2).Ts, ndig );
    else
      selfreq_str = pzg_efmt( inputFreq, ndig );
    end
    set( temp0(8,2),'string', selfreq_str,'userdata', inputFreq );
    if isempty(inputFreq)
      return
    end
    inputFreq = min( 0.999*0.5/PZG(2).Ts, inputFreq );
    jwaxis_pt = 1i * inputFreq * 2*pi;
    uc_pt = exp( jwaxis_pt * PZG(2).Ts );
    if strcmpi( Domain,'s')
      input_zeros = 0;
      input_poles = [ jwaxis_pt; -jwaxis_pt ];
      input_gain = 1;
    else
      ang0 = angle(uc_pt);
      input_zeros = [ 0; cos(ang0) ];
      input_poles = [ uc_pt; conj(uc_pt) ];
      input_gain = 1;
    end
  otherwise
    input_zeros = [];
    input_poles = [];
    input_gain = 1;
end

if isfield( hndl,'natl_h_checkbox')
  natlcb_h = hndl.natl_h_checkbox;
else
  natlcb_h = findobj( FigHndl,'tag','natl_h checkbox');
end
vis_state = 'off';
if isempty(natlcb_h)
else
  if get( natlcb_h,'value')
    vis_state = 'on';
  end
end

if isfield( hndl,'dom_ndx') && isfield( hndl,'ploth_ndx')
  simtime_h = ...
    pzg_fndo( hndl.dom_ndx, hndl.ploth_ndx,'pzgui_resppl_max_tme_edit');
  simtimelabel_h = ...
    pzg_fndo( hndl.dom_ndx, hndl.ploth_ndx,'pzgui_resppl_max_tme_label');
else
  simtime_h = findobj( FigHndl,'tag','pzgui resppl max tme edit');
  simtimelabel_h = findobj( FigHndl,'tag','pzgui resppl max tme label');
end
ss_h = findobj( FigHndl,'string','stdy-state');
if ( strcmpi( Domain,'s') ...
     &&( any( PZG(1).cntr_data.ld_pole_rep > 1 ) ...
        ||any( PZG(1).cntr_data.ld_poles ~= 0 ) ...
        ||any( real(CoprimePoles) > 1e-12 ) ) ) ...
  ||( strcmpi( Domain,'z') ...
     &&( any( PZG(2).cntr_data.ld_pole_rep > 1 ) ...
        ||any( PZG(2).cntr_data.ld_poles ~= 1 ) ...
        ||any( abs(CoprimePoles) > (1+1e-12) ) ) )
  % System has poles on or beyond stability boundary
  % (excepting the case of a single integrator).
  % There will not be any steady-state for sinusoid inputs.
  % Disable the "steady-state" checkbox.
  set( [simtime_h;simtimelabel_h],'enable','on','visible','on')
  if SigType > 4
    set( ss_h,'enable','off','visible','on')
  else
    set( ss_h,'enable','off','visible','off')
  end
else
  if SigType > 4
    % There will be a steady-state for sinusoid inputs.
    set( ss_h,'enable','on','visible','on')
    if get( ss_h,'value')
      set( simtime_h,'enable','off','visible','on')
    else
      set( simtime_h,'enable','on','visible','on')
    end
    set( simtimelabel_h,'visible','on')
  else
    set( ss_h,'enable','off','visible','off')
    set( simtime_h,'enable','on','visible','on')
    set( simtimelabel_h,'visible','on')
  end
end
if ( SigType > 4 ) && get(ss_h,'value')
  stdy_state_only = 1;
else
  stdy_state_only = 0;
end

if strcmpi( architec,'open loop') || strcmp( Domain,'z')
  % In open-loop, or in the z-domain, the delay is included separately.
  incl_pade = 0;
else
  % In closed-loop, delay must be included at the outset.
  incl_pade = 1;
end
incl_prvw = [];
if ( PZGndx == 1 ) || ~isempty( strfind( architec,'closed') )
  [ resp_res, resp_poles, resp_direct ] = ...
      pzg_rsppfe( ...
        PZGndx, input_zeros, input_poles, input_gain, ...
        architec, incl_prvw, incl_pade );
  PPP = resp_poles;
  nr_delay_poles = 0;
else
  PPP = [ input_poles; PZG(2).PoleLocs ];
  ZZZ = [ input_zeros; PZG(2).ZeroLocs ];
  KKK = input_gain * PZG(2).Gain;
  canceled_input_poles = [];
  % Delete any canceling zeros.
  for kz = numel(ZZZ):-1:1
    cancel_ndx = find( abs( PPP - ZZZ(kz) ) < 1e-10 );
    if ~isempty(cancel_ndx)
      if any( input_poles == PPP(cancel_ndx(1)) )
        canceled_input_poles = ...
          [ canceled_input_poles; PPP(cancel_ndx(1)) ]; %#ok<AGROW>
      end
      ZZZ(kz) = [];
      PPP(cancel_ndx(1)) = [];
    end
  end
  nr_delay_poles = PZG(2).PureDelay;
  zeroPPP_ndx = find( abs(PPP) < 1e-10 );
  if numel(zeroPPP_ndx) > 0
    while ( numel(PPP) > numel(ZZZ) ) && ~isempty(zeroPPP_ndx)
      PPP(zeroPPP_ndx(1)) = [];
      nr_delay_poles = nr_delay_poles + 1;
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
  while ( numel(PPP) > numel(ZZZ) ) && ( numel(zeroPPP_ndx) > 0 )
    nr_delay_poles = nr_delay_poles + 1;
    PPP(zeroPPP_ndx(end)) = [];
    zeroPPP_ndx(end) = [];
  end
  if isempty(PPP)
    resp_res = [];
    resp_poles = [];
    resp_direct = KKK;
  else
    [ resp_res, resp_poles, resp_direct ] = pzg_res( ZZZ, PPP, KKK );
    if ~isempty(canceled_input_poles)
      resp_res = [ zeros(size(canceled_input_poles)); resp_res ];
      resp_poles = [ canceled_input_poles; resp_poles ];
    end
  end
end

% Make sure the input poles are at the beginning of the list of poles.
% orig_input_poles = input_poles;
inpole_ndx = zeros(size(input_poles));
ndx1 = 1;
for k = 1:numel(input_poles)
  match_ndx = find( resp_poles == input_poles(k) );
  if numel(match_ndx) == 1
    inpole_ndx(ndx1) = match_ndx;
    ndx1 = ndx1 + 1;
  else
    inpole_ndx(ndx1:ndx1+numel(match_ndx)-1) = match_ndx;
    ndx1 = ndx1 + numel(match_ndx);
  end
end
inpole_ndx = unique(inpole_ndx);
inpole_ndx = inpole_ndx( inpole_ndx ~= 0 );
noninpole_ndx = setdiff( (1:numel(resp_poles))', inpole_ndx );
resp_poles = [ resp_poles(inpole_ndx); resp_poles(noninpole_ndx) ];
resp_res = [ resp_res(inpole_ndx); resp_res(noninpole_ndx) ];

use_pfe_sim = 0;
if ( SigType < 6 ) ...
  && isequal( numel(resp_res), numel(resp_poles) )
  % Use residues to compute the time-response.
  use_pfe_sim = 1;
  if isempty(default_sim_time) || isequal( 0, default_sim_time )
    % Determine the settling time.
    unstable_timeconst = 0;
    stable_timeconst = 0;
    cycle_time = 0;
    integ_time = 0;
    if PZGndx == 1
      splane_poles = resp_poles;
    else
      splane_poles = log(resp_poles)/PZG(2).Ts;
    end
    if any( real(splane_poles) > 1e-8 )
      % There's at least one unstable pole.
      unstabl_ndx = find( real(splane_poles) > 1e-8 );
      unstable_timeconst = 1/min( real(splane_poles(unstabl_ndx)) ); %#ok<FNDSB>
    end
    if any( real(splane_poles) < -1e-8 )
      stabl_ndx = find( real(splane_poles) < -1e-8 );
      stable_timeconst = -1/max( real(splane_poles(stabl_ndx)) );    %#ok<FNDSB>
    end
    if any( imag(splane_poles) >= 1e-6 )
      cplx_ndx = find( imag(splane_poles) >= 1e-6 );
      cycle_time = 1/( min(imag(splane_poles(cplx_ndx))) / (2*pi) ); %#ok<FNDSB>
    end
    if any( ( abs(imag(splane_poles)) < 1e-6 ) ...
           &( abs(real(splane_poles)) < 1e-8 ) )
      % These are integrator-like poles
      integ_time = 1;
    end
    sim_time = ...
      1.8*max( [ 2*cycle_time; 5*stable_timeconst; unstable_timeconst ] );
    if numel(resp_poles) > 500
      sim_time = sim_time/300;
    elseif numel(resp_poles) > 150
      sim_time = sim_time/100;
    elseif numel(resp_poles) > 30
      sim_time = sim_time/10;
    end
    if unstable_timeconst > 0
      sim_time = min( unstable_timeconst/100, sim_time );
    end
    if sim_time > 100
      sim_time = 10^floor( log10(sim_time) );
    elseif sim_time > 10
      sim_time = 10*floor( sim_time/10 );
    elseif sim_time > 1
      sim_time = floor(sim_time);
    elseif sim_time > 0.1
      sim_time = floor(10*sim_time)/10;
    end
    if isequal( 0, sim_time )
      sim_time = max( 4, integ_time );
    end
  else
    sim_time = default_sim_time;
  end
  
  if ~isempty(temp0)
    if stdy_state_only
      % Simulate only in vicinity of steady-state.
      sim_time = 4*TimeConstant;
      set( temp0(2,2),'visible','on','enable','off')
    else
      set( temp0(2,2),'visible','on','enable','on')
    end
  end
  
  % Compute the columns of "pfe_out",
  % the inverse-Laplace of the various terms in the PFE versus time.
  if strcmpi( Domain,'s')
    if strcmpi( architec,'open loop')
      wb_h = waitbar( 0.01,{'Computing O.L. Continuous-Time Response ...'}, ...
                      'name','C-T Response Computation Progress', ...
                      'tag',[ Domain ' resppl progress waitbar'] );
    else
      wb_h = waitbar( 0.01,{'Computing C.L. Continuous-Time Response ...'}, ...
                      'name','C-T Response Computation Progress', ...
                      'tag',[ Domain ' resppl progress waitbar'] );
    end
  else
    if strcmpi( architec,'open loop')
      wb_h = waitbar( 0.01,{'Computing O.L. Discrete-Time Response ...'}, ...
                      'name','D-T Response Computation Progress', ...
                      'tag',[ Domain ' resppl progress waitbar'] );
    else
      wb_h = waitbar( 0.01,{'Computing C.L. Discrete-Time Response ...'}, ...
                      'name','D-T Response Computation Progress', ...
                      'tag',[ Domain ' resppl progress waitbar'] );
    end
  end
  
  % Limit the number of separate natural-response lines in the plot.
  max_nr_natl_resp_lines = 32; % This corresponds to ~59 pole flex struc model.
  
  
  if SigType > 4
    phase_360_sign = '-';
    if isequal( Domain,'z')
      aliased_Freq = mod( abs(inputFreq), 1/PZG(2).Ts );
      if aliased_Freq > 0.5/PZG(2).Ts
        aliased_Freq = 1/PZG(2).Ts - aliased_Freq;
        phase_360_sign = '+';
      end
      t_one_cycle = abs(1/aliased_Freq);
    else
      t_one_cycle = 1/inputFreq;
      aliased_Freq = inputFreq;
    end
    if aliased_Freq < 0
      inputFreq = aliased_Freq;
    end
  end
  
  if PZGndx == 1
    %new_res = resp_res;
    %new_poles = resp_poles;
    new_direct = resp_direct;
    max_freq = max(imag(resp_poles)) / 2/pi;
    if max_freq ~= 0
      max_freq = max(abs(resp_poles)) / 2/pi;
    end
    if max_freq > 0
      max_ts = 1/(10*max_freq);
    else
      max_ts = min( 1, PZG(2).Ts );
    end
    if stdy_state_only
      % Get input sinusoid frequency.
      inputPeriod = 1/abs(aliased_Freq);
      start_nr_periods = floor( sim_time / inputPeriod );
      if start_nr_periods > 0
        start_time = ( start_nr_periods + 0.2 )*inputPeriod;
      else
        start_time = 0;
      end
      end_time = start_time + 4*inputPeriod;
      
      sim_ts = min( (end_time-start_time)/def_nr_sim_samples, max_ts );
      nr_samples = ...
        1 + min( max_allowable_samples-1, ceil((end_time-start_time)/sim_ts) );
      t_vec = start_time + (0:nr_samples-1)' * sim_ts;

    else
      sim_ts = min( sim_time/def_nr_sim_samples, max_ts );
      nr_samples = ...
        1 + min( max_allowable_samples-1, ceil( sim_time/sim_ts ) );
      t_vec = (0:nr_samples-1)' * sim_ts;
    end
    
    if t_vec(1) == 0
      log_t_vec = [ -Inf; log( t_vec(2:end) ) ];
    else
      log_t_vec = log( t_vec );
    end
  
    if ( sum( imag(resp_poles) >= 0 ) - numel(input_poles) ) ...
        <= max_nr_natl_resp_lines
      pfe_out = zeros( nr_samples, numel(resp_poles) );
    else
      pfe_out = zeros( nr_samples, 1+numel(input_poles) );
    end
    prev_pole = inf;
    rep_nr = 1;
    for k = 1:numel(resp_poles)
      pp = resp_poles(k);
      if imag(pp) < 0
        continue
      end
      if abs( pp - prev_pole ) < 1e-12
        rep_nr = rep_nr + 1;
      else
        rep_nr = 1;
        prev_pole = pp;
      end
      if ~isequal( resp_res(k), 0 )
        col_ndx = min( k, size(pfe_out,2) );
        this_term = resp_res(k) * exp( pp * t_vec );
        if rep_nr > 1
          multiplier = exp( (rep_nr-1)*log_t_vec )/factorial(rep_nr-1);
          this_term = this_term .* multiplier;
        end
        if imag(pp) == 0
          pfe_out(:,col_ndx) = pfe_out(:,col_ndx) + this_term;
        else
          pfe_out(:,col_ndx) = pfe_out(:,col_ndx) + 2*real(this_term);
        end
      end
      if ishandle(wb_h)
        waitbar( 0.95*k/numel(resp_poles), wb_h )
      end
    end
    if numel(resp_poles) == 0
      % pfe_out = SigIn;
    end
  else
    % Discrete-time
    sim_ts = PZG(2).Ts;
    if stdy_state_only
      % Get input sinusoid frequency.
      if abs(inputFreq) < 0.5/PZG(2).Ts
        inputPeriod = 1/abs(inputFreq);
        periodFreq = inputFreq;
      else
        periodFreq = 1/PZG(2).Ts - inputFreq;
        inputPeriod = 1/abs( periodFreq );
      end
      start_nr_periods = floor( sim_time / inputPeriod );
      if start_nr_periods > 0
        start_N = floor( ( start_nr_periods + 0.2 )*inputPeriod / sim_ts );
      else
        start_N = 0;
      end
      % If frequency is above quarter-Nyquist, include extra periods.
      if abs(periodFreq) < 0.20/PZG(2).Ts
        end_N = start_N + 4*ceil( inputPeriod/ sim_ts );
      elseif abs(periodFreq) < 0.32/PZG(2).Ts
        end_N = start_N + 8*ceil( inputPeriod/ sim_ts );
      elseif abs(periodFreq) < 0.41/PZG(2).Ts
        end_N = start_N + 12*ceil( inputPeriod/ sim_ts );
      elseif abs(periodFreq) < 0.47/PZG(2).Ts
        end_N = start_N + 16*ceil( inputPeriod/ sim_ts );
      else
        end_N = start_N + 24*ceil( inputPeriod/ sim_ts );
      end
      nr_samples = min( max_allowable_samples, ...
                        ceil( (end_N-start_N) ) );
      N_vec = start_N + (0:nr_samples-1)';
    else
      nr_samples = min( max_allowable_samples, ceil( sim_time/sim_ts )+1 );
      N_vec = (0:nr_samples-1)';
    end
    t_vec = N_vec * sim_ts;
    switch SigType
      case 1
        SigIn = zeros(size(t_vec));
        if PZGndx == 2
          SigIn(1) = 1;
        end
      case 2
        SigIn = ones(size(t_vec));
      case 3
        SigIn = t_vec;
      case 4
        SigIn = 0.5*t_vec.^2;
      case 5
        SigIn = cos( inputFreq*2*pi * t_vec );
        if strcmpi( Domain,'z') ...
          &&( ( inputFreq < 0 ) || ( inputFreq > 0.5/PZG(2).Ts ) )
          SigIn = -SigIn;
        end
    end
      
    if ( sum( imag(resp_poles) >= 0 ) - numel(input_poles) ) ...
        <= max_nr_natl_resp_lines
      pfe_out = zeros( nr_samples, numel(resp_poles) );
    else
      pfe_out = zeros( nr_samples, 1+numel(input_poles) );
    end
    prev_pole = inf;
    rep_nr = 1;
    
    % Adjust the D-T residues so that the computation is similar to the C-T
    % computation, namely, just exponentials and a direct term that might be
    % zero.
    if ~isempty(PZG(2).PoleLocs) ...
      && ~isempty(resp_poles) ...
      && numel(PZG(2).PoleLocs) > numel(PZG(2).ZeroLocs)
      resp_direct = 0;
    end
    new_res = resp_res;
    new_poles = resp_poles; %#ok<NASGU>
    new_direct = resp_direct;
      
    if ~isempty(PZG(2).PoleLocs) ...
      && ~isempty(resp_poles) ...
      && numel(PZG(2).PoleLocs) > numel(PZG(2).ZeroLocs)
      new_direct = 0;
    end
    resp_res = new_res;
    
    for k = 1:numel(resp_poles)
      pp = resp_poles(k);
      if imag(pp) < 0
        continue
      end
      if abs( pp - prev_pole )/max(1,abs(pp)) < 1e-12
        rep_nr = rep_nr + 1;
      else
        rep_nr = 1;
        prev_pole = pp;
      end
      this_term = zeros(size(N_vec));
      if ~isequal( resp_res(k), 0 )
        col_ndx = min( k, size(pfe_out,2) );
        if abs(pp) > 1e-10
          this_term(2:end) = resp_res(k) * exp( log(pp) * N_vec(1:end-1) );
          this_term(1) = 0;
        else
          this_term = zeros(size(N_vec));
          this_term(rep_nr+1) = resp_res(k);
        end
        if ( rep_nr > 1 ) && ( abs(pp) > 1e-10 )
          multiplier = ones(size(t_vec));
          for k_repnr = 2:rep_nr
            multiplier = multiplier .* ( N_vec - N_vec(k_repnr) );
          end
          if rep_nr > 2
            multiplier = multiplier / factorial(rep_nr-1);
          end
          this_term = this_term .* multiplier;
        end
        if abs(imag(pp)) < 1e-10
          % For a real-valued pole, just add in this term.
          pfe_out(:,col_ndx) = pfe_out(:,col_ndx) + real(this_term);
        else
          % Add together complex-conjugate part, if pole is not real-valued.
          pfe_out(:,col_ndx) = pfe_out(:,col_ndx) + 2*real( this_term );
        end
      end
      
      if ishandle(wb_h)
        waitbar( 0.95*k/numel(resp_poles), wb_h )
      end
    end
    if isempty(resp_poles)
      pfe_out = zeros(size(SigIn));
    end
    if ( nr_delay_poles > 0 ) && ( numel(PPP) == numel(ZZZ) )
      pfe_out(1,1) = PZG(2).Gain;
      new_direct = 0;
    end
  end

  direct_out = zeros(size(t_vec));
  if ~isempty( strfind( architec,'open') )
    % For open-loop, a direct term results in a pulse out.
    if ~isempty(new_direct) && ~isequal( new_direct, 0 ) ...
      && ( nr_delay_poles == 0 )
      % For open-loop, direct term results in a pulse out.
      direct_out(1) = real(new_direct);
    end
    if isequal( numel(PPP), numel(input_poles) ) ...
      &&( nr_delay_poles == 0 )
      % The system is a direct feedthrough, with gain KKK.
      direct_out = zeros(size(direct_out));
      direct_out(1) = real(new_direct);
      
    elseif ( ( PZGndx == 1 ) && ( PZG(1).PureDelay > 0 ) ) ...
      ||( PZGndx == 2 )
      % For open-loop, apply pure delay, if it exceeds zero
      % (closed-loop model includes 4th-order Pade approx of delay).
      if strcmpi( Domain,'s')
        nr_delay_samples = round( PZG(PZGndx).PureDelay/sim_ts );
      else
        nr_delay_samples = nr_delay_poles;
      end
      if nr_delay_samples == 0
        direct_out(1) = real(new_direct);
      else
        if new_direct == 0
          pfe_out(nr_delay_samples+1:end,:) = ...
            pfe_out(1:end-nr_delay_samples,:);
          pfe_out(1:nr_delay_samples,:) = 0;
          direct_out(1) = 0;
        elseif isempty(resp_poles)
          pfe_out(1:nr_delay_samples,:) = 0;
          direct_out(1) = 0;
          direct_out(nr_delay_samples+1) = real(new_direct);
        else
          pfe_out(nr_delay_samples+1:end,:) = ...
            pfe_out(1:end-nr_delay_samples,:);
          pfe_out(1:nr_delay_samples,:) = 0;
          direct_out(1:nr_delay_samples) = 0;
          direct_out(nr_delay_samples+1) = real(new_direct);
        end
      end
      if stdy_state_only && ( t_vec(1) > 0 )
        t_vec(1:nr_delay_samples) = [];
        pfe_out(1:nr_delay_samples,:) = [];
        direct_out(1:nr_delay_samples,:) = [];
      end
    else
      
    end
  else
    % For closed-loop, all delay poles are included in the PFE.
    direct_out(1) = new_direct;
  end
else
  pfe_out = [];
end

if isempty(pfe_out)
  use_pfe_sim = 0;
else
  pfe_total_resp = real( sum( pfe_out, 2 ) ) + direct_out;
  if ~isempty(default_sim_time) ...
    && ( abs(default_sim_time-5*TimeConstant)/5/TimeConstant < 1e-12 ) ...
    && ( default_sim_time > 0 ) && ( SigType == 2 )
    % Cut back the simulation time, if it's too long.
    final_sim_value = pfe_total_resp(end);
    ndxs = find( ( pfe_total_resp > final_sim_value*(1+exp(-8)) ) ...
                |( pfe_total_resp < final_sim_value/(1+exp(-8)) ) );
    if max(ndxs) < 0.8*numel(pfe_total_resp)
      last_ndx = max(ndxs);
      default_sim_time = t_vec(last_ndx);
      TimeConstant = t_vec( ceil(last_ndx/8) );
      t_vec = t_vec(1:last_ndx);
      direct_out = direct_out(1:last_ndx);
      pfe_total_resp = pfe_total_resp(1:last_ndx);
      pfe_out = pfe_out(1:last_ndx,:);
    end
  elseif SigType == 2
    % Compute better estimate of the time constant.
    final_sim_value = pfe_total_resp(end);
    ndxs = ...
      find( ( pfe_total_resp > final_sim_value*(1+exp(-8)) ) ...
           |( pfe_total_resp < final_sim_value/(1+exp(-8)) ) ); %#ok<MXFND>
    last_ndx = max(ndxs);
    if last_ndx < 0.8*numel(t_vec)
      TimeConstant = t_vec( ceil(last_ndx/8) );
    end
  end
  pfe_t_vec = t_vec;
  if ( size(pfe_out,2) > numel(input_poles) )
    sys_poles = resp_poles( 1+numel(input_poles):end );
    if sum( imag(resp_poles) >= 0 ) <= size(pfe_out,2)
      pfe_natl_resp = pfe_out(:,1+numel(input_poles):end);
      % Combine responses of complex-conjugate pole-pairs.
      for kp = numel(sys_poles): -1: 2
        if ~isreal( sys_poles(kp) ) && ~isreal( sys_poles(kp-1) ) ...
          && ( abs( sys_poles(kp)-conj(sys_poles(kp-1)) ) < 1e-14 )
          pfe_natl_resp(:,kp-1) = real( sum( pfe_natl_resp(:,kp-1:kp), 2 ) );
          pfe_natl_resp(:,kp) = [];
        end
      end
    else
      % There are too many system poles, so all the natural response
      %  terms were combined into a single column (the last column.
      pfe_natl_resp = ...
        real( sum( pfe_out(:,1+numel(input_poles):end), 2 ) );
    end
  else
    % There are no poles in the system, itself.
    pfe_natl_resp = zeros( size(pfe_out,1), 1 );
    sys_poles = [];
    TimeConstant = 1;
  end
  if numel(input_poles) > 0
    pfe_forc_resp = pfe_out(:,1:sum(imag(input_poles)>=0));
    if ~isreal(input_poles(1))
      pfe_forc_resp = real( sum( pfe_forc_resp, 2 ) );
    end
    pfe_forc_resp(:,1) = pfe_forc_resp(:,1) + direct_out;
  else
    %pfe_forc_resp = zeros( size(pfe_out,1), 1 );
    pfe_forc_resp = direct_out;
  end
end

if use_pfe_sim
  switch SigType
    case 1
      SigIn = zeros(size(pfe_t_vec));
      if PZGndx == 2
        SigIn(1) = 1;
      end
    case 2
      SigIn = ones(size(pfe_t_vec));
    case 3
      SigIn = pfe_t_vec;
    case 4
      SigIn = 0.5*pfe_t_vec.^2;
    case 5
      SigIn = cos( inputFreq*2*pi * pfe_t_vec );
      if strcmpi( Domain,'z') ...
        &&( ( inputFreq < 0 ) || ( inputFreq > 0.5/PZG(2).Ts ) )
        SigIn = -SigIn;
      end
  end
  SigLength = numel(SigIn);
  deltaT = sim_ts;
  Time = pfe_t_vec;
  Ydata = pfe_total_resp;
  natl_resp = pfe_natl_resp;
  forc_resp = pfe_forc_resp;
  dom_zeta = 1;
  if ~isempty(sys_poles)
    if PZGndx == 2
      splane_sys_poles = log(sys_poles)/PZG(2).Ts;
    else
      splane_sys_poles = sys_poles;
    end
    if ( max(real(splane_sys_poles)) < 0 ) ...
      && ( max(imag(splane_sys_poles)) > 0 )
      cplx_s_sys_poles = splane_sys_poles( imag(splane_sys_poles) > 0 );
      [ max_real, dompole_ndx ] = max(real( cplx_s_sys_poles )); %#ok<ASGLU>
      dominant_pole = cplx_s_sys_poles(dompole_ndx);
      dom_zeta = -real(dominant_pole)/abs(dominant_pole);
    end
  end
  textVis = 'off';
  tempVis = 'off';
  PerfType = 1;
  PerfLo = 0;
  PerfHi = Time(end);
  if ~isempty(temp0)
    PerfType = get(temp0(4,2),'Value');
    PerfLo = str2double( get(temp0(5,2),'String'));
    PerfHi = str2double( get(temp0(6,2),'String'));
    if PerfHi > Time(end)
      PerfHi = Time(end);
      set( temp0(6,2),'string', num2str( PerfHi ) );
    end
    if PerfLo >= PerfHi
      PerfLo = 0;
      set( temp0(5,2),'string','0');
    end
  end
elseif isempty(PZG(PZGndx).PoleLocs) && isequal( SigType, 1 )
  sim_ts = default_sim_time/def_nr_sim_samples;
  deltaT = sim_ts;
  pfe_t_vec = (0:sim_ts:default_sim_time)';
  pfe_forc_resp = zeros(size(pfe_t_vec));
  pfe_natl_resp = zeros(size(pfe_t_vec));
  direct_out = zeros(size(pfe_t_vec));
  direct_out(1) = resp_direct;
  pfe_total_resp = pfe_forc_resp + pfe_natl_resp + direct_out;
  Time = pfe_t_vec;
  SigIn = zeros(size(pfe_t_vec));
  SigIn(1) = 1;
  SigLength = numel(SigIn);
  Ydata = pfe_total_resp;
  PerfLo = 0;
  PerfHi = 0;
  PerfType = 0;
  natl_resp = pfe_natl_resp;
  forc_resp = pfe_forc_resp;
  
else
  disp('Using less robust simulation, based on transfer function.')
  dom_zeta = 0;
  if isempty(temp0)
    if ( numel(CoprimeD) <= 1 )
      if ( Domain == 'z')
        deltaT = PZG(2).Ts;
        Time = [0:deltaT:1e4*deltaT]'; %#ok<NBRAK>
        Ydata = Gain * ones(size(Time));
        if PZG(2).PureDelay > 0
          Ydata(1:PZG(2).PureDelay) = 0;
        end
      else
        deltaT = 1e-4;
        Time = [ 0:deltaT:1 ]'; %#ok<NBRAK>
        if PZG(1).PureDelay > 0
          if PZG(1).PureDelay <= 0.0001
            deltaT = PZG(1).PureDelay;
          else
            nr_divs = 1+ceil( PZG(1).PureDelay/0.0001 );
            deltaT = PZG(1).PureDelay / nr_divs;
          end
          Time = [ 0:deltaT:1e5*deltaT ]'; %#ok<NBRAK>
        end
        Ydata = Gain * ones(size(Time));
      end
    else
      if ( Domain == 'z')
        these_poles = roots(CoprimeD);
        non_uc_pole_ndxs = find( abs( 1 - abs(these_poles) ) > 2000*eps );
        if numel(non_uc_pole_ndxs) == numel(these_poles)
          non_uc_poles = these_poles(non_uc_pole_ndxs);
          [ dominant_mag, dom_ndx ] = max( abs(non_uc_poles) ); %#ok<ASGLU>
          dominant_pole = log( non_uc_poles(dom_ndx) ); % s-plane
          dom_zeta = -real(dominant_pole)/abs(dominant_pole);
          % Determine 2*Tsettle.
          max_n = 9*ceil( abs(1/log(max(abs(non_uc_poles)))) );
          max_n = min( max_n, PlotLimit/2+1 );
          max_t = Ts*max_n;
          if dom_zeta < 0
            max_t = max_t/3;
          elseif dom_zeta < 0.2
            max_t = 1.3*max_t;
          end
          multiplier = 10^floor(log10(max_t));
          max_t = ceil( max_t/multiplier )*multiplier;
          max_n = ceil( max_t / Ts );
          Ydata = dstep(Gain*CoprimeN,CoprimeD,max_n);
        else
          Ydata = dstep(Gain*CoprimeN,CoprimeD);
        end
        if numel(Ydata) > PlotLimit
          Ydata = Ydata(1:PlotLimit);
        end
        deltaT = Ts;
        Time = Ts*(0:numel(Ydata)-1)';
        [ natl_resp, forc_resp ] = ...
            local_natl_forc_resp( ...
               Gain, CoprimeN, CoprimeD, Time,'z','step', PlotName );
      else
        these_poles = roots(CoprimeD);
        nonimag_pole_ndxs = find( real(these_poles) ~= 0 );
        % Base delta-T on the highest natural frequency.
        if ~isempty(nonimag_pole_ndxs)
          max_delta_t = 0.01 / max(abs(these_poles(nonimag_pole_ndxs)));
        else
          % All the poles are integrators.
          max_delta_t = 1e-3;
        end
        if numel(nonimag_pole_ndxs) == numel(these_poles)
          % None of the poles are integrators.
          nonimag_poles = these_poles(nonimag_pole_ndxs);
          [ dominant_real_part, dom_ndx ] = max( real(nonimag_poles) );
          dominant_pole = nonimag_poles(dom_ndx);
          dom_zeta = -real(dominant_pole)/abs(dominant_pole);
          % Determine 2*Tsettle.
          dom_zeta = max( 1e-4, sign(dom_zeta+eps)*max( abs(dom_zeta) ) );
          max_t = 9/abs(dominant_real_part);
          if dom_zeta < 0
            max_t = max_t/3;
          elseif dom_zeta < 0.2
            max_t = 1.3*max_t;
          end
          multiplier = 10^floor(log10(max_t));
          max_t = ceil( max_t/multiplier )*multiplier;
          max_t = min( max_t, max_delta_t/2*PlotLimit );
          Time = (0:max_delta_t:max_t);
          if numel(Time) > PlotLimit
            Time = Time(1:PlotLimit);
          end
          Ydata = step( Gain*CoprimeN, CoprimeD, Time);
        else
          Time = (0:max_delta_t:1e5*max_delta_t);
          Ydata = step( Gain*CoprimeN, CoprimeD, Time);
        end
        % "Right-size" the delta-T.
        if numel(Ydata) < ( PlotLimit/400 );
          deltaT = ( Time(2)-Time(1) )/40;
        elseif numel(Ydata) < ( PlotLimit/40 );
          deltaT = ( Time(2)-Time(1) )/4;
        else
          deltaT = Time(2)-Time(1);
        end
        if PZG(1).PureDelay > 0
          if deltaT >= PZG(1).PureDelay
            deltaT = PZG(1).PureDelay;
          else
            d_deltaT = 1+ceil( PZG(1).PureDelay / deltaT );
            deltaT = PZG(1).PureDelay / d_deltaT;
          end
        end
        Time = ( 0: deltaT: Time(end));
        if numel(Time) > PlotLimit
          Time = Time(1:PlotLimit);
        end
        if Time(end) > 50
          end_time = 25*floor(Time(end)/25);
          end_ndx = pzg_gle( Time, end_time,'<=');
          Time = Time(1:end_ndx);
        elseif Time(end) > 10
          end_time = 5*floor(Time(end)/5);
          end_ndx = pzg_gle( Time, end_time,'<=');
          Time = Time(1:end_ndx);
        end
        Ydata = step(Gain*CoprimeN,CoprimeD,Time);
        [ natl_resp, forc_resp ] = ...
            local_natl_forc_resp( ...
               Gain, CoprimeN, CoprimeD, Time,'s','step', PlotName );
      end
    end
    if numel(Time) > PlotLimit
      Time = Time(1:PlotLimit);
      Ydata = Ydata(1:PlotLimit);
    end
    SigType = 2;
    SigLength = numel(Time);
    SigIn = ones(size(Ydata));
    PerfLo = 0;
    PerfHi = Time(end);
    tempVis = 'Off';
    textVis = 'Off';
  else
    if ~isempty(temp0)
      Time = get(temp0(2,1),'Xdata');
    else
      if Domain == 'z'
        Time = [0:Ts:1e4*Ts]'; %#ok<NBRAK>
      else
        Time = [0:0.0001:1]'; %#ok<NBRAK>
      end
    end

    if Domain == 'z'
      deltaT = Ts;
    else
      deltaT = Time(2)-Time(1);
      if PZG(1).PureDelay > 0
        if deltaT >= PZG(1).PureDelay
          deltaT = PZG(1).PureDelay;
        else
          d_deltaT = 1+ceil( PZG(1).PureDelay / deltaT );
          deltaT = PZG(1).PureDelay / d_deltaT;
        end
      end
      Ts = deltaT;
    end
    if gco0 == temp0(2,2)
      tempNum = str2num(get(gco0,'String')); %#ok<ST2NM>
      if isempty(tempNum)
        tempNum = Time(end);
      %else
      %  tempNum = ...
      %     min( PlotLimit*deltaT, max(10*deltaT, tempNum) );
      end
      set( gco0,'String',num2str(tempNum));
      if str2num( get( temp0(6,2),'String' ) ) > tempNum %#ok<ST2NM>
        set( temp0(6,2),'String',num2str(tempNum));
      end

    elseif gco0 == temp0(5,2)
      tempNum = str2num(get(gco0,'String')); %#ok<ST2NM>
      tempNum0 = str2num(get(temp0(6,2),'String')); %#ok<ST2NM>
      if isempty(tempNum)
        tempNum = 0;
      else
        tempNum = max(0,tempNum);
        if tempNum > tempNum0
          set(temp0(6,2),'String',num2str(tempNum));
        end
      end
      set( gco0,'String',num2str(tempNum));

      elseif gco0 == temp0(6,2)  
      tempNum = str2num(get(gco0,'String')); %#ok<ST2NM>
      tempNum0 = str2num(get(temp0(5,2),'String')); %#ok<ST2NM>
      if isempty(tempNum)
        tempNum = Time(end);
      else
        tempNum = max(0,tempNum);
        if tempNum < tempNum0
          set(temp0(5,2),'String',num2str(tempNum));
        end
      end
      set( gco0,'String',num2str(tempNum));
    elseif gco0 == temp0(8,2)
      tempNum = str2num(get(gco0,'String')); %#ok<ST2NM>
      if isempty(tempNum)
        inputFreq = get(gco0,'UserData');
      else
        inputFreq = tempNum;
      end
      set( gco0,'String',num2str(inputFreq) );
      set( gco0,'UserData',inputFreq );
    end

    if Domain == 'z'
      Ydata = dstep( Gain*CoprimeN, CoprimeD );
      Time = Ts*(0:numel(Ydata)-1)';
    else
      [ Ydata, temp, Time ] = step(Gain*CoprimeN,CoprimeD); %#ok<ASGLU>
      deltaT = ( Time(2)-Time(1) )/40;
      if ~isempty(CoprimePoles)
        deltaT = min( deltaT, 0.1/max(abs(CoprimePoles)) );
      end
      if ceil(Time(end)/deltaT) > (PlotLimit/4)
        deltaT = deltaT*10;
        %Time = (0:deltaT:PlotLimit/4*deltaT)';
      end

      % If delta-T is too small to reach the max sim time 
      % in the total # samples allowed, change delta-T.
      if ishandle( temp0(2,2) )
        maxsimtime = str2double( get(temp0(2,2),'string') );
        if ~isempty(maxsimtime) && ( maxsimtime > 0 )
          numsamples = maxsimtime / deltaT + 1;
          if numsamples > PlotLimit
            deltaT = maxsimtime / PlotLimit;
          end
        end
      end

      if PZG(1).PureDelay > 0
        if deltaT >= PZG(1).PureDelay
          deltaT = PZG(1).PureDelay;
        else
          d_deltaT = 1+ceil( PZG(1).PureDelay / deltaT );
          deltaT = PZG(1).PureDelay / d_deltaT;
        end
      end
    end

    SigType = get(temp0(1,2),'Value');
    edmaxtime = str2double( get(temp0(2,2),'String')); 
    SigLength = max( 10, ceil(edmaxtime/Ts)+1 );
    PerfType = get(temp0(4,2),'Value');
    PerfLo = str2double( get(temp0(5,2),'String'));
    PerfHi = str2double( get(temp0(6,2),'String'));
    if PerfHi > Time(end)
      PerfHi = Time(end);
      set( temp0(6,2),'string', num2str( PerfHi ) );
    end
    if PerfLo >= PerfHi
      PerfLo = 0;
      set( temp0(5,2),'string','0');
    end

    if SigType >= 5
      tempFreq = str2num( get( temp0(8,2),'String' ) ); %#ok<ST2NM>
      if isempty(tempFreq)
        inputFreq = get( temp0(8,2),'UserData' );
      else
        inputFreq = tempFreq;
      end
      if Domain == 'z'
        deltaT = Ts;
      else
        deltaT = min( deltaT, 1/abs(inputFreq)/40 );
        if PZG(1).PureDelay > 0
          if deltaT >= PZG(1).PureDelay
            deltaT = PZG(1).PureDelay;
          else
            d_deltaT = 1+ceil( PZG(1).PureDelay / deltaT );
            deltaT = PZG(1).PureDelay / d_deltaT;
          end
        end
      end
    end

    Time = (0:deltaT:min( PlotLimit*deltaT, max(deltaT*SigLength,PerfHi) ) )';

    tempVis = 'Off';
    if Domain == 'z'
      if SigType == 1
        Ydata = ...
          dimpulse( Gain*CoprimeN, CoprimeD, ...
                    round(min(PlotLimit, 1+max(SigLength,PerfHi)/Ts)));
        SigIn = zeros(size(Ydata));
        SigIn(1) = 1;
        textVis = 'Off';
        [ natl_resp, forc_resp ] = ...
            local_natl_forc_resp( ...
               Gain, CoprimeN, CoprimeD, Time,'z','impulse', PlotName );
        
      elseif SigType == 2
        Ydata = ...
            dstep(Gain*CoprimeN,CoprimeD, ...
            round(min(PlotLimit, 1+max(SigLength,PerfHi)/Ts)));
        SigIn = ones(size(Ydata));
        textVis = 'off';
        [ natl_resp, forc_resp ] = ...
            local_natl_forc_resp( ...
               Gain, CoprimeN, CoprimeD, Time,'z','step', PlotName );
      elseif SigType == 3
        SigIn = ( 0:Ts: ...
                  min(PlotLimit*Ts,Ts+max(SigLength,PerfHi)) )';
        Ydata = dlsim(Gain*CoprimeN,CoprimeD,SigIn);
        textVis = 'off';
        [ natl_resp, forc_resp ] = ...
            local_natl_forc_resp( ...
               Gain, CoprimeN, CoprimeD, Time,'z','ramp', PlotName );
      elseif SigType == 4
        SigIn = ...
          (1/2)*( ( 0:Ts: ...
              min(PlotLimit*Ts,Ts+max(SigLength,PerfHi)))').^2;
        Ydata = dlsim(Gain*CoprimeN,CoprimeD,SigIn);
        textVis = 'off';
        [ natl_resp, forc_resp ] = ...
            local_natl_forc_resp( ...
               Gain, CoprimeN, CoprimeD, Time,'z','parabola', PlotName );
      elseif ( SigType == 5 ) || ( SigType == 6 )
        set( temp0(8,2),'String', pzg_efmt(inputFreq,3) );
        SigIn = ...
          cos( 2*pi*inputFreq ...
              *(0:Ts: ...
                 min(PlotLimit*Ts,Ts+max(SigLength,PerfHi)))' );
        textVis = 'on';
        tempVis = 'on';
        if ( SigType == 6 )
          SigIn = sign(SigIn+eps);
          textVis = 'off';
        else
          [ natl_resp, forc_resp ] = ...
              local_natl_forc_resp( ...
                 Gain, CoprimeN, CoprimeD, Time,'z','sinusoid', PlotName, ...
                 2*pi*inputFreq );
        end
        Ydata = dlsim(Gain*CoprimeN,CoprimeD,SigIn);
      elseif SigType == 7
        set( temp0(8,2),'String', pzg_efmt(inputFreq,3) );
        SigIn = sawtooth(2*pi*inputFreq*Time,0.5);
        textVis = 'off';
        Ydata = dlsim(Gain*CoprimeN,CoprimeD,SigIn);
      end
    else
      if SigType == 1
        Ydata = impulse(Gain*CoprimeN,CoprimeD,Time);
        SigIn = zeros(size(Ydata));
        textVis = 'off';
        [ natl_resp, forc_resp ] = ...
            local_natl_forc_resp( ...
               Gain, CoprimeN, CoprimeD, Time,'s','impulse', PlotName );
      elseif SigType == 2
        Ydata = step(Gain*CoprimeN,CoprimeD,Time);
        SigIn = ones(size(Ydata));
        textVis = 'off';
        [ natl_resp, forc_resp ] = ...
            local_natl_forc_resp( ...
               Gain, CoprimeN, CoprimeD, Time,'s','step', PlotName );
      elseif SigType == 3
        SigIn = Time;
        Ydata = lsim(Gain*CoprimeN,CoprimeD,SigIn,Time);
        textVis = 'off';
        [ natl_resp, forc_resp ] = ...
            local_natl_forc_resp( ...
               Gain, CoprimeN, CoprimeD, Time,'s','ramp', PlotName );
      elseif SigType == 4
        SigIn = (1/2)*Time.^2;
        Ydata = lsim(Gain*CoprimeN,CoprimeD,SigIn,Time);
        textVis = 'off';
        [ natl_resp, forc_resp ] = ...
            local_natl_forc_resp( ...
               Gain, CoprimeN, CoprimeD, Time,'s','parabola', PlotName );
      elseif ( SigType == 5 ) || ( SigType == 6 )
        set( temp0(8,2),'String', pzg_efmt(inputFreq,3) );
        SigIn = cos(2*pi*inputFreq*Time);
        textVis = 'on';
        tempVis = 'on';
        if SigType == 6
          % Turn the sinusoid into a square-wave.
          SigIn = sign(SigIn+eps);
          textVis = 'off';
        else
          [ natl_resp, forc_resp ] = ...
              local_natl_forc_resp( ...
                 Gain, CoprimeN, CoprimeD, Time,'s', ...
                 'sinusoid', PlotName, 2*pi*inputFreq );
        end
        Ydata = lsim(Gain*CoprimeN,CoprimeD,SigIn,Time);
      elseif SigType == 7
        set( temp0(8,2),'String', pzg_efmt(inputFreq,3) );
        SigIn = sawtooth(2*pi*inputFreq*Time,0.5);
        textVis = 'off';
        Ydata = lsim(Gain*CoprimeN,CoprimeD,SigIn,Time);
      end
    end
  end
  Time = Time(:);
end
Ydata = real(Ydata(:));

if numel(Time) > PlotLimit
  Time = Time(1:PlotLimit);
end
if numel(Ydata) > PlotLimit
  Ydata = Ydata(1:PlotLimit);
end
if numel(SigIn) > PlotLimit
  SigIn = SigIn(1:PlotLimit);
end

if (SigType == 2 ) ...
  &&( ( dom_zeta > 0 ) || ~isempty(temp0) ) ...
  && ~isempty(TimeConstant) && ~isempty(deltaT) && ~isempty(DC_Gain) ...
  && ( numel(Ydata) > (3*TimeConstant/deltaT) )

  SettleRange = 0.02;

  if DC_Gain >= 0
    init_zeros = sum( cumsum(abs(Ydata)) == 0 );
    temp = cumsum( Ydata(2:end) < 0.99*DC_Gain );
    if ~isempty(temp)
      temp = ( temp == (1:numel(temp))' );
    else
      temp = 1;
    end
    CrsOvr = init_zeros + 1 + max(1, sum(temp));
    [temp,tempNdx] = max(Ydata(CrsOvr:end)); %#ok<ASGLU>
    OSNdx = tempNdx + CrsOvr - 1;
    [temp,tempNdx] = min(Ydata(CrsOvr+1:end)); %#ok<ASGLU>
    USNdx = tempNdx + CrsOvr;

    [temp,tempNdx] = sort( Ydata(2:end) > 0.1*DC_Gain );
    tempNdx = tempNdx + 1;
    temp = min( numel(tempNdx), sum( temp == 0 )+1 );
    RiseStartNdx = min( tempNdx(temp:end) );
    [temp,tempNdx] = sort( Ydata(2:end) > 0.9*DC_Gain );
    tempNdx = tempNdx + 1;
    temp = min( numel(tempNdx), sum( temp == 0 )+1 );
    RiseEndNdx = min( tempNdx(temp:end) );
    RiseTime = deltaT * ( RiseEndNdx - RiseStartNdx );

  else
    temp = cumsum( Ydata > 0.99*DC_Gain );
    temp = temp == (1:numel(temp))';
    CrsOvr = max( 1, sum(temp) );
    [temp,tempNdx] = min(Ydata(CrsOvr:end)); %#ok<ASGLU>
    OSNdx = tempNdx + CrsOvr - 1;
    [temp,tempNdx] = max(Ydata(CrsOvr+1:end)); %#ok<ASGLU>
    USNdx = tempNdx + CrsOvr;

    [temp,tempNdx] = sort( Ydata(2:end) < 0.1*DC_Gain );
    tempNdx = tempNdx + 1;
    temp = min( numel(tempNdx), sum( temp == 0 )+1 );
    RiseStartNdx = min( tempNdx(temp:end) );
    [temp,tempNdx] = sort( Ydata(2:end) < 0.9*DC_Gain );
    tempNdx = tempNdx + 1;
    temp = min( numel(tempNdx), sum( temp == 0 )+1 );
    RiseEndNdx = min( tempNdx(temp:end) );
    RiseTime = deltaT * ( RiseEndNdx - RiseStartNdx + 1 );
  end
      
  if DC_Gain ~= 0
    OS = ( Ydata(OSNdx) - DC_Gain )/DC_Gain * 100;
    if OS < 0
      OS = [];
    end
  else
    OS = inf;
  end
  if OS < 0.2
    OS = [];
    OSNdx = [];
  end
  if DC_Gain ~= 0
    US = abs( ( Ydata(USNdx) - DC_Gain )/DC_Gain )*100;
  else
    US = inf;
  end
  if isempty(USNdx) || ( US < 0.2 ) || ( (USNdx-1) == CrsOvr )
    US = [];
    USNdx = [];
  end
  if DC_Gain ~= 0
    tempNdx = find( abs( Ydata - DC_Gain ) ...
                   >= abs( SettleRange*DC_Gain ) );
  else
    tempNdx = find( abs( Ydata ) >= abs( SettleRange ) );
  end
  if isempty(tempNdx)
    tempNdx = 1; %#ok<NASGU>
    SettleNdx = 1;
  else
    SettleNdx = tempNdx(end) + 1;
  end
  if SettleNdx <= numel(Ydata)*0.95
    SettleTime = max(1,(SettleNdx-1)) * deltaT;
  else
    RiseStartNdx = 1;
    RiseEndNdx = 1;
    OSNdx = [];
    USNdx = [];
    SettleNdx = [];
    RiseTime = [];
    OS = [];
    US = [];
    SettleTime = [];
  end
else
  RiseStartNdx = 1;
  RiseEndNdx = 1;
  OSNdx = [];
  USNdx = [];
  SettleNdx = [];
  RiseTime = [];
  OS = [];
  US = [];
  SettleTime = [];
end

if isempty(CoprimePoles)
  SettleNdx = [];
end

if Domain == 'z'
  dom_ndx = 2;
else
  dom_ndx = 1;
end

if ~isempty( strfind( lower(PlotTitle),'open') )
  olcl_fig_ndx = 8;
  pzgerr_str = ' open-loop ';
  delstr_cb_fn = 'OLresp_checkbox';
else
  olcl_fig_ndx = 9;
  pzgerr_str = ' closed-loop ';
  delstr_cb_fn = 'CLresp_checkbox';
end

if isempty(temp0)
  wbdf_str = 'resppl(''resppl wbdf'');';
  del_str = ...
    ['global PZG,' ...
    'try,' ...
       'temp_domndx=' num2str(dom_ndx) ';' ...
       'temp_plothndx=' num2str(olcl_fig_ndx) ';' ...
       'temp_cbh=pzg_fndo(temp_domndx,' num2str(11+dom_ndx) ',' ...
          '''' delstr_cb_fn ''');' ...
       'if~isempty(temp_cbh),' ...
         'set(temp_cbh,''value'',0);' ...
       'end,' ...
       'PZG(temp_domndx).plot_h{temp_plothndx}=[];' ...
     'end,' ...
     'pzg_bkup,' ...
     'clear temp_domndx temp_plothndx temp_cbh;'];
    
  NewFig = ...
    figure( ...
      'windowbuttondownfcn', wbdf_str, ...
      'menubar','figure', ...
      'numbertitle','off', ...
      'handlevisibility','callback', ...
      'dockcontrols','off', ...
      'visible','off', ...
      'integerhandle','off', ...
      'tag','PZGUI plot', ...
      'windowbuttonmotionfcn', ...
        ['if pzg_disab,return,end,' ...
         'try,' ...
           mfilename '(''mouse motion'');' ...
         'catch,pzg_err(''mouse motion' pzgerr_str 'response plot'');' ...
         'end']);
  FigHndl = NewFig;
  if sum( size(Position) == [1 4] ) > 0
    if max(Position) > 1
      ScrSize = get(0,'screensize');
      Position([1;3]) = Position([1;3])/ScrSize(3);
      Position([2;4]) = Position([2;4])/ScrSize(4);
    end
    set( NewFig, ...
        'units','normalized', ...
        'Position', Position, ...
        'Name', PlotName, ...
        'Interruptible','On', ...
        'Color','k', ...
        'deletefcn', del_str );
  else
    set( NewFig, ...
        'units','normalized', ...
        'Name', PlotName, ...
        'Interruptible','On', ...
        'Color','k', ...
        'deletefcn', del_str );
  end
  
  % Put a "Color Options" menu item in the figure's menubar.
  opt_menu_h = ...
    uimenu('parent', NewFig, ...
           'label', 'PZGUI OPTIONS', ...
           'tag','pzgui_options_menu');
  pzg_menu( opt_menu_h, Domain );
  
  hndl = getappdata( NewFig,'hndl');
  
  hndl.plot_name = get( NewFig,'name');
  hndl.dom_ndx = dom_ndx;
  if isempty( strfind( lower(hndl.plot_name),'closed') )
    hndl.ploth_ndx = 8;
  else
    hndl.ploth_ndx = 9;
  end
  
  NewAx = axes('parent',NewFig, ...
               'nextplot','add', ...
               'xgrid','on', ...
               'ygrid','on', ...
               'tag','pzg time-domain plot axes');
  hndl.ax = NewAx;
  hndl.ax_title = get( NewAx,'title');
  hndl.ax_xlabel = get( NewAx,'xlabel');
  hndl.ax_ylabel = get( NewAx,'ylabel');
  temp0 = zeros([14 2]);
  
  if Domain == 'z'
    LnWd = 0.5;
    input_linestyle = '-';
    markerval = 'o';
    natl_markerval = 'o';
    if numel(PZG(2).PoleLocs) > 50
      natl_markerval = 'none';
    end
    inputmarkersizeval = 2;
    markersizeval = 2;
  else
    LnWd = 1.5;
    input_linestyle = '--';
    markerval = 'none';
    natl_markerval = 'none';
    inputmarkersizeval = 2;
    markersizeval = 2;
  end
  
  hndl.pzgui_resppl_xaxis_hilite = ...
    plot([Time(1);Time(end)],[0;0], ...
         'color', 1-get(NewAx,'color'), ...
         'linewidth', 1, ...
         'tag','X-axis highlight');
  
  temp0(4,1) = ...
    plot( Time, SigIn, ... ...
      'color',[0 0.8 0], ...
      'linestyle', input_linestyle, ...
      'LineWidth', LnWd, ...
      'marker', markerval, ...
      'markersize', inputmarkersizeval, ...
      'markerfacecolor',[0 0.8 0], ...
      'markeredgecolor',[0 0.8 0], ...
      'parent', NewAx, ...
      'tag','pzgui resppl input line');
  hndl.pzgui_resppl_input_line = temp0(4,1);

  temp0(2,1) = ...
    plot( Time, Ydata, ...
         'color','r', ...
         'linestyle','-', ...
         'LineWidth', LnWd, ...
         'marker', markerval, ...
         'MarkerSize', markersizeval, ...
         'markerfacecolor','r', ...
         'markeredgecolor','r', ...
         'parent', NewAx, ...
         'tag','pzgui resppl resp line');
  hndl.pzgui_resppl_resp_line = temp0(2,1);
  
  set( NewAx,'xlim',[Time(1);Time(end)]);
  set( temp0(2,1),'UserData',Gain*N );
  temp0(1,1) = NewAx;
  set( NewAx,'Color','k','XColor','w','YColor','w','UserData',Domain);
  ScrSize = get(0,'ScreenSize');
  if ScrSize(3) > 1024
    set( NewAx, ...
        'Position',[0.12 0.19 0.66 0.71], ...
        'Interruptible','On', ...
        'FontSize',10 );
  else
    set( NewAx, ...
        'Position',[0.12 0.19 0.66 0.71], ...
        'Interruptible','On', ...
        'FontSize',8 );
  end
  temp0(6,1) = ...
    plot( Time, SigIn-Ydata, ...
      'color',[0 0.7 0.7], ...
      'linestyle','-', ...
      'LineWidth', LnWd, ...
      'marker', markerval, ...
      'markersize', markersizeval, ...
      'markerfacecolor',[0 0.7 0.7], ...
      'markeredgecolor',[0 0.7 0.7], ...
      'Visible','off', ...
      'tag','pzgui resppl error line');
  set( temp0(6,1),'UserData', D );
  hndl.pzgui_resppl_error_line = temp0(6,1);
  if SigType == 1
    set( hndl.pzgui_resppl_error_line, ...
        'xdata',[],'ydata',[],'visible','off');
  end
  
  natl_h = pzg_fndo( dom_ndx, olcl_fig_ndx,'pzgui_natl_resp_line');
  resp_ndx = min( numel(natl_resp), numel(Time) );
  forc_h = pzg_fndo( dom_ndx, olcl_fig_ndx,'pzgui_forc_resp_line');
  
  if ~isempty(natl_resp) && ~isempty(forc_resp)
    t_natl = [ Time(1:resp_ndx)*ones(1,size(natl_resp,2)); ...
               NaN*ones(1,size(natl_resp,2)) ];
    y_natl = [ real(natl_resp(1:resp_ndx,:)); ...
               NaN*ones(1,size(natl_resp,2)) ];
    if ~isequal( 1, numel(natl_h) ) || ~isequal( 1, sum(ishandle(natl_h)) )
      delete(natl_h(ishandle(natl_h)))
      natl_h = ...
        plot( t_natl(:), y_natl(:), ...
          'linestyle','-', ...
          'color',[0.7 0.7, 0], ...
          'LineWidth', 1.5, ...
          'marker', natl_markerval, ...
          'markersize', markersizeval/2, ...
          'markerfacecolor',[0.7 0.7, 0], ...
          'parent', NewAx, ...
          'Visible','off', ...
          'tag','pzgui natl_resp line');
      hndl.pzgui_natl_resp_line = natl_h;
    else
      set( natl_h, ...
          'xdata', t_natl(:), ...
          'ydata', y_natl(:), ...
          'visible','off')
    end
    t_forc = [ Time(1:resp_ndx)*ones(1,size(forc_resp,2)); ...
               NaN*ones(1,size(forc_resp,2)) ];
    y_forc = [ real(forc_resp(1:resp_ndx,:)); ...
               NaN*ones(1,size(forc_resp,2)) ];
    if  ~isequal( 1, numel(forc_h) ) || ~isequal( 1, sum(ishandle(forc_h)) )
      delete(forc_h(ishandle(forc_h)))
      forc_h = ...
        plot( t_forc(:), y_forc(:), ...
           'linestyle','-.', ...
           'color',[0 0.75 0.75], ...
           'LineWidth', 1.5, ...
           'marker', markerval, ...
           'markersize', markersizeval/2, ...
           'parent', NewAx, ...
           'Visible','off', ...
           'tag','pzgui forc_resp line');
      hndl.pzgui_forc_resp_line = forc_h;
    else
      set( forc_h, ...
          'xdata', t_forc(:), ...
          'ydata', y_forc(:), ...
          'color',[0 0.75 0.75], ...
          'visible','off')
    end
  end
  
  % Setup for the step response parameter display
  StepHndls = zeros([18 1]);
  if isempty(RiseStartNdx)
    temp = plot([0 0],[0 0],'y:','parent',NewAx, ...
                'tag','pzgui resppl rise-time start vert line');
  else
    temp = plot([ Time(RiseStartNdx) Time(RiseStartNdx) ], ...
                [ 0 Ydata(RiseStartNdx) ],'y:', ...
                'parent', NewAx, ...
                'tag','pzgui resppl rise-time start vert line');
  end
  StepHndls(1) = temp;
  if isempty(RiseEndNdx)
    temp = plot([0 0],[0 0],'y:','parent',NewAx, ...
                'tag','pzgui resppl rise-time end vert line');
  else
    temp = plot([ Time(RiseEndNdx) Time(RiseEndNdx) ], ...
                [ 0 Ydata(RiseEndNdx) ],'y:','parent',NewAx, ...
                'tag','pzgui resppl rise-time end vert line');
  end
  StepHndls(2) = temp;
  if isempty(RiseStartNdx) || isempty(RiseEndNdx)
    temp = plot([0 0],[0 0],'y','parent',NewAx, ...
                'tag','pzgui resppl rise-time ydata highlight');
  else
    temp = plot( Time(RiseStartNdx:RiseEndNdx), ...
                 Ydata(RiseStartNdx:RiseEndNdx),'y','parent',NewAx, ...
                'tag','pzgui resppl rise-time ydata highlight');
  end
  set(temp,'LineWidth',2);
  StepHndls(16) = temp;
  
  [ tr_ypos, os_ypos, tp_ypos, us_ypos, ts_ypos, ss_ypos ] = ...
     local_get_text_ypos( Ydata, OSNdx, USNdx );
  tempA = round( (RiseEndNdx + RiseStartNdx)/2 );
  if isempty(RiseTime)
    temp = text( Time(tempA), max( tr_ypos, Ydata(RiseStartNdx) ), ...
                ' ', ...
                'Color',[1 1 0], ...
                'parent', NewAx, ...
                'fontweight','bold', ...
                'fontsize', 12 );
  else
    if ( RiseTime <= 0 ) || isnan(RiseTime) || isinf(RiseTime)
      RTtext = '';
    else
      RTtext = ['T_r_i_s_e = ' num2str(RiseTime,4)];
    end
    temp = text( Time(tempA)+0.03*Time(end), 0.10*DC_Gain, RTtext, ...
                'Color',[1 1 0], ...
                'parent', NewAx, ...
                'fontsize', 10, ...
                'fontweight','bold');
  end
  StepHndls(3) = temp;
  if isempty(OSNdx)
    tempA = plot([0 0],[0 0],'g:','parent',NewAx, ...
                 'tag','pzgui resppl overshoot vert line');
    tempB = plot([0 0],[0 0],'g:','parent',NewAx, ...
                 'tag','pzgui resppl overshoot horiz line');
  else
    tempA = plot([ Time(OSNdx) Time(OSNdx) ], ...
                 [ 0 Ydata(OSNdx) ],'g:','parent', NewAx, ...
                 'tag','pzgui resppl overshoot vert line');
    tempB = plot([ 0 Time(OSNdx) ], ...
                 [ Ydata(OSNdx) Ydata(OSNdx) ],'g:','parent',NewAx, ...
                 'tag','pzgui resppl overshoot horiz line');
  end
  StepHndls(4) = tempA;
  StepHndls(5) = tempB;
  if isempty(OS) || isempty(OSNdx)
    temp = text( Time(1), Ydata(1), ...
                ' ', ...
                'Color',[1 0 0], ...
                'parent', NewAx, ...
                'fontweight','bold', ...
                'fontsize', 10 );
  else
    if isinf(OS) || isnan(OS)
      OStext = '';
    else
      OStext = ['O.S.= ' num2str(OS,4) '%' ];
    end
    temp = text( Time(OSNdx)+0.03*Time(end), os_ypos, OStext, ...
                'Color',[1 0 0], ...
                'parent', NewAx, ...
                'fontweight','bold', ...
                'fontsize', 10 );
  end
  StepHndls(6) = temp;
  
  % Peak time.
  if isempty(OS) || isempty(OSNdx)
    temp = text( Time(1), Ydata(1), ...
                ' ', ...
                'Color',[1 0 0], ...
                'parent', NewAx, ...
                'fontweight','bold', ...
                'fontsize', 10 );
  else
    temp = text( Time(OSNdx)+0.03*Time(end), tp_ypos, ...
                ['T_p_e_a_k = ' num2str(Time(OSNdx),4)], ...
                'Color',[1 0 0], ...
                'parent', NewAx, ...
                'fontsize', 10, ...
                'fontweight','bold', ...
                'fontsize', 10 );
  end
  StepHndls(17) = temp;
  
  if isempty(USNdx)
    tempA = plot([0 0],[0 0],'m:','parent',NewAx, ...
                 'tag','pzgui resppl undershoot vert line');
    tempB = plot([0 0],[0 0],'m:','parent',NewAx, ...
                 'tag','pzgui resppl undershoot horiz line');
  else
    tempA = plot([ Time(USNdx) Time(USNdx) ], ...
                 [ 0 Ydata(USNdx) ],'m:','parent',NewAx, ...
                 'tag','pzgui resppl undershoot vert line');
    tempB = plot([ 0 Time(USNdx) ], ...
                 [ Ydata(USNdx) Ydata(USNdx) ],'m:','parent',NewAx, ...
                 'tag','pzgui resppl undershoot horiz line');
  end
  StepHndls(7) = tempA;
  StepHndls(8) = tempB;
  if isempty(US) || isempty(USNdx)
    temp = text( Time(1), Ydata(1), ...
                ' ', ...
                'Color',[1 0 1], ...
                'parent', NewAx, ...
                'fontweight','bold', ...
                'fontsize', 10 );
  else
    if isinf(US) || isnan(US)
      UStext = '';
    else
      UStext = ['U.S.= ' num2str(US,4) '%' ];
    end
    temp = text( Time(USNdx)+0.03*Time(end), us_ypos, UStext, ...
                'Color',[1 0 1], ...
                'parent', NewAx, ...
                'fontsize', 10, ...
                'fontweight','bold');
  end
  StepHndls(9) = temp;
  if isempty(SettleNdx)
    tempA = plot([0 0],[0 0],'c:','parent',NewAx, ...
                 'tag','pzgui resppl ss vert line');
    tempB = plot([0 0],[0 0],'c:','parent',NewAx, ...
                 'tag','pzgui resppl ss++ horiz line');
    tempC = plot([0 0],[0 0],'c:','parent',NewAx, ...
                 'tag','pzgui resppl ss-- horiz line');
  else
    tempA = plot([ Time(SettleNdx) Time(SettleNdx) ], ...
                 [ 0 Ydata(SettleNdx) ],'c:','parent',NewAx, ...
                 'tag','pzgui resppl ss vert line');
    if DC_Gain ~= 0
      temp = (1+SettleRange) * DC_Gain;
    else
      temp = SettleRange;
    end
    tempB = plot([ 0 Time(end) ],[ temp temp ],'c:','parent',NewAx, ...
                 'tag','pzgui resppl ss++ horiz  line');
    if DC_Gain ~= 0
      temp = (1-SettleRange) * DC_Gain;
    else
      temp = -SettleRange;
    end
    tempC = plot([ 0 Time(end) ],[ temp temp ],'c:','parent',NewAx, ...
                 'tag','pzgui resppl ss-- horiz  line');
  end
  StepHndls(10:12) = [tempA;tempB;tempC];
  if isempty(SettleTime) || isempty(SettleNdx)
    temp = text( Time(1), Ydata(1), ...
                ' ', ...
                'Color',[0 1 1], ...
                'parent', NewAx, ...
                'fontweight','bold', ...
                'fontsize', 10 );
  else
    ts_str_xpos = max( Time(SettleNdx)+0.03*Time(end), 0.62*Time(end));
    temp = text( ts_str_xpos, ts_ypos, ...
                ['T_s_e_t_t_l_e= ' num2str(Time(SettleNdx),5) ], ...
                'Color',[0 1 1], ...
                'parent', NewAx, ...
                'fontsize', 10, ...
                'fontweight','bold');
  end
  StepHndls(13) = temp;
  if isempty(DC_Gain)
    tempA = plot([0 0],[0 0],'r:','parent',NewAx, ...
                 'tag','pzgui resppl ss horiz line');
  else
    tempA = plot([ 0 Time(end) ], ...
                 [ DC_Gain DC_Gain ],'r:','parent',NewAx, ...
                 'tag','pzgui resppl ss horiz line');
  end
  % If the system is unstable, make the ss-horiz line not visible.
  if ( strcmp( Domain,'z') && any( abs(PoleLocs) > 1 ) ) ...
    ||( strcmp( Domain,'s') && any( real(PoleLocs) > 0 ) )
    set( tempA,'visible','off')
  else
    set( tempA,'visible','on')
  end
  
  if isempty(SettleNdx)
    tempB = ...
      text( Time(1), Ydata(1), ...
        ' ', ...
        'Color',[1 1 1], ...
        'parent', NewAx, ...
        'fontweight','bold', ...
        'fontsize', 10 );
  else
    tempB = ...
      text( max(Time(SettleNdx)+0.03*Time(end), ...
        0.62*Time(end)), ss_ypos, ...
        ['S.S.= ' num2str(DC_Gain)], ...
        'Color',[1 1 1], ...
        'parent', NewAx, ...
        'fontsize', 10, ...
        'fontweight','bold');
  end
  StepHndls(14:15) = [ tempA; tempB ];
  temp0(14,1) = StepHndls(1);
  set(StepHndls(1),'UserData',StepHndls);

  TitlHndl = get(NewAx,'Title');
  if PZGndx == 1
    plottitle_str = 'C-T ';
  else
    plottitle_str = 'D-T ';
  end
  if isempty( strfind( architec,'losed') )
    plottitle_str = [ plottitle_str 'Open-Loop Unit-Step Response'];
  else
    plottitle_str = [ plottitle_str 'Closed-Loop Unit-Step Response'];
  end
  set( TitlHndl,'string', plottitle_str,'Color',[1 1 1] );
  temp0(10,1) = TitlHndl;
  set(temp0(10,1),'UserData',PlotTitle)
  XLablHndl = get(NewAx,'xlabel');
  set( XLablHndl,'string','Time, seconds');
  set( XLablHndl,'userdata',Ts );
  YLablHndl = get(NewAx,'ylabel');
  set( YLablHndl,'string','Step Input (dashed) & Response (solid)');
  
  uicontrol(NewFig,'Style','text', ...
      'String','Input', ...
      'Units','normalized', ...
      'Position',[0.82 0.890 0.15 0.05], ...
      'tooltipstring','select input-type for the simulation', ...
      'HorizontalAlignment','Center', ...
      'BackgroundColor',[0 0 0], ...
      'ForegroundColor',[1 1 1] );
  SelectStr = {'impulse';'step';'ramp';'parabola';'cosine'};
  temp0(1,2) = uicontrol(NewFig,'Style','popupmenu', ...
      'String',SelectStr, ...
      'Value',2, ...
      'Units','normalized', ...
      'Position',[0.82 0.855 0.175 0.043], ...
      'BackgroundColor',[0.7 0.9 0.8], ...
      'ForegroundColor',[0 0 0], ...
      'tooltipstring','select input-type for the simulation', ...
      'tag','input-type popupmenu', ...
      'Callback', ...
           ['global PZG,' ...
            'pzg_onoff(0);' ...
            'try,' ...
              'if isequal(get(gcbo,''value''),get(gcbo,''userdata'')),' ...
                'pzg_onoff(1);' ...
                'return,' ...
              'end,' ...
              'temp_gcovalue=get(gcbo,''value'');' ...
              'set(gcbo,''userdata'',temp_gcovalue);' ...
              'temp_gcf0=gcbf;' ...
              'temp_gca0=get(temp_gcf0,''currentaxes'');' ...
              'temp0=get(temp_gcf0,''UserData'');' ...
              'resppl(get(temp0(2,1),''UserData''),' ...
                     'get(temp0(4,1),''UserData''),1,' ...
                     'get(temp_gcf0,''Name''),'''',' ...
                     'get(temp_gca0,''UserData''),' ...
                     'get(get(temp_gca0,''xlabel''),''userdata'') );' ...
              'temp_ui_h=findobj(gcbf,''tag'',''visible for step only'');' ...
              'if temp_gcovalue==2,' ...
                'set(temp_ui_h,''visible'',''on'');' ...
              'else,' ...
                'set(temp_ui_h,''visible'',''off'');' ...
              'end,' ...
              'temp_ui_h=findobj(gcbf,''tag'',''visible for sinusoid only'');' ...
              'if temp_gcovalue==5,' ...
                'set(temp_ui_h,''visible'',''on'');' ...
              'else,' ...
                'set(temp_ui_h,''visible'',''off'');' ...
              'end,' ...
              'temp_ui_h=findobj(gcbf,''tag'',''visible for periodic only'');' ...
              'temp_ss_h=findobj(gcbf,''string'',''stdy-state'');' ...
              'temp_simtime_h=' ...
                 'findobj(gcbf,''tag'',''pzgui resppl max tme edit'');' ...
              'temp_show_e_h=findobj(gcbf,''tag'',''show_io_difference'');' ...
              'if temp_gcovalue>4,' ...
                'set(temp_ui_h,''visible'',''on'');' ...
                'if get(temp_ss_h,''value'')' ...
                  '&&strcmp(get(temp_ss_h,''enable''),''on''),' ...
                  'set(temp_simtime_h,''enable'',''off'');' ...
                'else,' ...
                  'set(temp_simtime_h,''enable'',''on'');' ...
                'end,' ...
              'else,' ...
                'set(temp_ui_h,''visible'',''off'');' ...
                'set(temp_simtime_h,''enable'',''on'');' ...
              'end,' ...
              'if temp_gcovalue==1,' ...
                'set(temp_show_e_h,''visible'',''off'');' ...
              'else,' ...
                'set(temp_show_e_h,''visible'',''on'');' ...
              'end,' ...
              'pzg_errvis(gcbf);' ...
              ['pzg_updtfilt(' num2str(dom_ndx) ');'] ...
            'catch,pzg_err(''input-type popupmenu''),end,' ...
            'pzg_onoff(1);' ...
            'clear temp0 temp_gca0 temp_gcf0 temp_ui_h temp_show_e_h,' ...
            'clear temp_simtime_h temp_ss_h temp_gcovalue,' ...
            'clear temp_prvwon temp_tools temp_toolfigh'] );
  hndl.input_type_popupmenu = temp0(1,2);

  temp0(7,2) = uicontrol(NewFig,'Style','text', ...
      'Units','normalized', ...
      'Position',[0.82 0.780 0.175 0.05], ...
      'String','Freq (Hz)', ...
      'fontsize', 10, ...
      'fontweight','bold', ...
      'HorizontalAlignment','Center', ...
      'BackgroundColor',[0 0 0], ...
      'ForegroundColor',[1 1 1], ...
      'tag','visible for periodic only', ...
      'tooltipstring','enter the frequency, in hertz', ...
      'Visible',tempVis );
  initFreq = 1;
  if isequal( Domain,'s')
    M = 1;
  else
    M = 2;
  end
  if ( numel(PZG(M).FrqSelNdx) == 1 ) ...
    &&( PZG(M).FrqSelNdx > 0 ) ...
    &&( PZG(M).FrqSelNdx <= numel(PZG(M).BodeFreqs) )
    initFreq = PZG(M).BodeFreqs(PZG(M).FrqSelNdx)/2/pi;
  end
  temp0(8,2) = uicontrol(NewFig,'Style','edit', ...
      'Units','normalized', ...
      'Position',[0.82 0.727 0.17 0.053], ...
      'String', pzg_efmt(initFreq,3), ...
      'fontsize', 10, ...
      'fontweight','bold', ...
      'HorizontalAlignment','Center', ...
      'BackgroundColor',[.9 .9 1], ...
      'ForegroundColor',[0 0 0], ...
      'UserData', initFreq, ...
      'Visible', tempVis, ...
      'tag','visible for periodic only', ...
      'tooltipstring','enter the frequency, in hertz', ...
      'Callback', ...
       ['pzg_onoff(0);' ...
        'try,' ...
          'temp0=get(gcbf,''UserData'');' ...
          'resppl(get(temp0(2,1),''UserData''),' ...
             'get(temp0(4,1),''UserData''),1,' ...
             'get(gcbf,''Name''),'''',' ...
             'get(get(gcbf,''currentaxes''),''UserData''),' ...
             'get(get(get(gcbf,''currentaxes''),''xlabel''),''userdata''));' ...
          'tempfs=freqserv(gcbf,1);pzg_ptr;' ...
        'catch,pzg_err(''time resp freq text-entry'');end,' ...
        'pzg_onoff(1);' ...
        'clear tempfs temp0'] );
  hndl.sinusoid_freq_hz_edit = temp0(8,2);

  if Domain == 's'
    bdy_pt = 1i*2*pi*str2num( get(temp0(8,2),'String') ); %#ok<ST2NM>
    olGain = PZG(1).Gain;
  else
    bdy_pt = exp( 1i*2*pi*str2num( get(temp0(8,2),'String') )*Ts ); %#ok<ST2NM>
    olGain = PZG(2).Gain;
  end
  [ ssMag, ssPhs ] = ...
      local_get_stdystate( bdy_pt, ZeroLocs, PoleLocs, olGain, architec ); 
  
  temp0(11,2) = uicontrol(NewFig,'Style','text', ...
      'String','ssMag', ...
      'Units','normalized', ...
      'Position',[0.805 0.665 0.095 0.05], ...
      'HorizontalAlignment','Left', ...
      'BackgroundColor',[0 0 0], ...
      'ForegroundColor',[1 1 1], ...
      'tooltipstring','forced response steady-state magnitude', ...
      'tag','visible for sinusoid only', ...
      'Visible',tempVis );
  temp0(12,2) = uicontrol(NewFig,'Style','text', ...
      'String', pzg_efmt(ssMag,4), ...
      'Units','normalized', ...
      'Position',[0.905 0.665 0.09 0.05], ...
      'HorizontalAlignment','Left', ...
      'BackgroundColor',[0 0 0], ...
      'ForegroundColor',[1 1 1], ...
      'tooltipstring','forced response steady-state magnitude', ...
      'tag','visible for sinusoid only', ...
      'Visible',textVis );
  hndl.forced_response_steadystate_magnitude = temp0(12,2);

  temp0(13,2) = uicontrol(NewFig,'Style','text', ...
      'String','ssPhs', ...
      'Units','normalized', ...
      'Position',[0.805 0.615 0.095 0.05], ...
      'HorizontalAlignment','Left', ...
      'BackgroundColor',[0 0 0], ...
      'ForegroundColor',[1 1 1], ...
      'tooltipstring','forced response steady-state phase', ...
      'tag','visible for sinusoid only', ...
      'Visible',tempVis );  
  temp0(14,2) = uicontrol(NewFig,'Style','text', ...
      'String', pzg_efmt(ssPhs,4), ...
      'Units','normalized', ...
      'Position',[0.905 0.615 0.09 0.05], ...
      'HorizontalAlignment','Left', ...
      'BackgroundColor',[0 0 0], ...
      'ForegroundColor',[1 1 1], ...
      'tooltipstring','forced response steady-state phase', ...
      'tag','visible for sinusoid only', ...
      'Visible',textVis );
  hndl.forced_response_steadystate_phase = temp0(14,2);

  hndl.pzgui_resppl_max_tme_label = ...
    uicontrol(NewFig,'Style','text', ...
      'String','Max Time', ...
      'Units','normalized', ...
      'Position',[0.82 0.555 0.175 0.05], ...
      'HorizontalAlignment','Center', ...
      'BackgroundColor',[0 0 0], ...
      'ForegroundColor',[1 1 1], ...
      'tag','pzgui resppl max tme label', ...
      'tooltipstring','enter the total simulation time');  
  temp0(2,2) = uicontrol(NewFig,'Style','edit', ...
      'String',num2str(Time(end)), ...
      'Units','normalized', ...
      'Position',[0.85 0.51 0.12 0.045], ...
      'HorizontalAlignment','Center', ...
      'BackgroundColor',[.9 .9 1], ...
      'ForegroundColor',[0 0 0], ...
      'tag','pzgui resppl max tme edit', ...
      'tooltipstring','enter the total simulation time', ...
      'Callback', ...
        ['pzg_onoff(0);' ...
         'try,' ...
         'temp0=get(gcbf,''UserData'');' ...
         'resppl(get(temp0(2,1),''UserData''),' ...
                'get(temp0(4,1),''UserData''),1,' ...
                'get(gcbf,''Name''),'''',' ...
                'get(gca,''UserData''),' ...
                'get(get(gca,''xlabel''),''userdata''));' ...
         'resppl(''resppl wbdf reset''),' ...
         'catch,pzg_err(''Simulation Time text-entry'');end,' ...
         'drawnow,' ...
         'pzg_onoff(1);' ...
         'clear temp0 tempMAXcbo'] );
  hndl.pzgui_resppl_max_tme_edit = temp0(2,2);
 
  hndl.pzgui_resppl_steadystate_only_checkbox = ...
    uicontrol(NewFig,'style','checkbox', ...
      'string','stdy-state', ...
      'units','normalized', ...
      'position',[0.805 0.45 0.19 0.045], ...
      'backgroundcolor', get(NewFig,'color'), ...
      'foregroundcolor', 1-get(NewFig,'color'), ...
      'tag','visible for sinusoid only', ...
      'visible','off', ...
      'tooltipstring','simulate only at time of steady-state', ...
      'Callback', ...
        ['pzg_onoff(0);' ...
         'try,' ...
           'temp_simtime_h=' ...
              'findobj(gcbf,''tag'',''pzgui resppl max tme edit'');' ...
           'if get(gcbo,''value''),' ...
             'set(temp_simtime_h,''enable'',''off''),' ...
           'else,' ...
             'set(temp_simtime_h,''enable'',''on''),' ...
           'end,' ...
           'tempSSO_0=get(gcbf,''UserData'');' ...
           'resppl(get(tempSSO_0(2,1),''UserData''),' ...
                  'get(tempSSO_0(4,1),''UserData''),1,' ...
                  'get(gcbf,''Name''),'''',' ...
                  'get(gca,''UserData''),' ...
                  'get(get(gca,''xlabel''),''userdata''));' ...
         'catch,' ...
           'pzg_err(''steady-state only checkbox'');' ...
         'end,' ...
         'drawnow,' ...
         'pzg_onoff(1);' ...
         'clear tempSSO_0 tempSSOcbo temp_simtime_h'] );
       
  hndl.visible_for_sinusoid_only = ...
    findobj( NewFig,'tag','visible for sinusoid only');
  hndl.visible_for_periodic_only = ...
    findobj( NewFig,'tag','visible for periodic only');

  uicontrol(NewFig,'Style','text', ...
      'String','Perform''ce', ...
      'Units','normalized', ...
      'Position',[0.82 0.415 0.175 0.05], ...
      'tooltipstring','computed step-response performance', ...
      'tag','visible for step only', ...
      'HorizontalAlignment','Center', ...
      'BackgroundColor',[0 0 0], ...
      'ForegroundColor',[1 1 1] );  
  temp0(3,2) = uicontrol(NewFig,'Style','text', ...
      'String',num2str(deltaT*sum(abs(SigIn-Ydata))), ...
      'Units','normalized', ...
      'Position',[0.82 0.370 0.175 0.05], ...
      'tooltipstring','computed step-response performance', ...
      'tag','visible for step only', ...
      'HorizontalAlignment','Center', ...
      'BackgroundColor',[.75 .75 .75], ...
      'ForegroundColor',[0 0 0] );  
  uicontrol(NewFig,'Style','text','String','Perf Meas', ...
      'Units','normalized', ...
      'Position',[0.82 0.300 0.175 0.05], ...
      'tooltipstring','select which performance measure', ...
      'tag','visible for step only', ...
      'HorizontalAlignment','Center', ...
      'BackgroundColor',[0 0 0], ...
      'ForegroundColor',[1 1 1] );  
  SelectStr = {'IAE';'ITAE';'ISE';'ITSE'};
  temp0(4,2) = uicontrol(NewFig,'Style','popupmenu', ...
      'String',SelectStr, ...
      'Value',1, ...
      'Units','normalized', ...
      'Position',[0.82 0.275 0.175 0.030], ...
      'BackgroundColor',[.7 .7 .9], ...
      'ForegroundColor',[0 0 0], ...
      'tooltipstring','select which performance measure', ...
      'tag','visible for step only', ...
      'Callback', ...
        ['pzg_onoff(0);' ...
         'try,' ...
           'temp0=get(gcbf,''UserData'');' ...
           'resppl(get(temp0(2,1),''UserData''),' ...
                  'get(temp0(4,1),''UserData''),1,' ...
                  'get(gcbf,''Name''),'''',' ...
                  'get(gca,''UserData''),' ...
                  'get(get(gca,''xlabel''),''userdata''));' ...
         'catch,' ...
           'pzg_err(''performance measure popupmenu'');' ...
         'end,' ...
         'drawnow,' ...
         'pzg_onoff(1);' ...
         'clear temp0'] );
 
  uicontrol(NewFig,'Style','text', ...
      'String','Perf Range', ...
      'Units','normalized', ...
      'Position',[0.81 0.175 0.175 0.05], ...
      'tooltipstring','enter performance time-range', ...
      'tag','visible for step only', ...
      'HorizontalAlignment','Center', ...
      'BackgroundColor',[0 0 0], ...
      'ForegroundColor',[1 1 1] );  
  uicontrol(NewFig,'Style','text', ...
      'String','Start', ...
      'Units','normalized', ...
      'Position',[0.81 0.132 0.08 0.05], ...
      'tooltipstring','start of performance time-range', ...
      'tag','visible for step only', ...
      'HorizontalAlignment','Left', ...
      'BackgroundColor',[0 0 0], ...
      'ForegroundColor',[1 1 1] );  
  temp0(5,2) = uicontrol(NewFig,'Style','edit', ...
      'String','0', ...
      'Units','normalized', ...
      'Position',[0.81 0.090 0.06 0.05], ...
      'HorizontalAlignment','Center', ...
      'BackgroundColor',[.7 .7 .9], ...
      'ForegroundColor',[0 0 0], ...
      'tooltipstring','start of performance time-range', ...
      'tag','visible for step only', ...
      'Callback', ...
        ['pzg_onoff(0);' ...
         'try,' ...
           'temp0=get(gcbf,''UserData'');' ...
           'resppl(get(temp0(2,1),''UserData''),' ...
                  'get(temp0(4,1),''UserData''),1,' ...
                  'get(gcbf,''Name''),'''',' ...
                  'get(gca,''UserData''),' ...
                  'get(get(gca,''xlabel''),''userdata''));' ...
         'catch,' ...
           'pzg_err(''start of performance edit'');' ...
         'end,' ...
         'drawnow,' ...
         'pzg_onoff(1);' ...
         'clear temp0'] );
  uicontrol(NewFig,'Style','text','String','End', ...
      'Units','normalized', ...
      'Position',[0.89 0.132 0.105 0.05], ...
      'tooltipstring','end of performance time-range', ...
      'tag','visible for step only', ...
      'HorizontalAlignment','Right', ...
      'BackgroundColor',[0 0 0], ...
      'ForegroundColor',[1 1 1] );  
  temp0(6,2) = uicontrol(NewFig,'Style','edit', ...
      'String',num2str(PerfHi), ...
      'Units','normalized', ...
      'Position',[0.88 0.090 0.115 0.05], ...
      'HorizontalAlignment','Center', ...
      'BackgroundColor',[.7 .7 .9], ...
      'ForegroundColor',[0 0 0], ...
      'tooltipstring','end of performance time-range', ...
      'tag','visible for step only', ...
      'Callback', ...
         ['pzg_onoff(0);' ...
          'try,' ...
            'temp0=get(gcbf,''UserData'');' ...
            'resppl(get(temp0(2,1),''UserData''),' ...
                   'get(temp0(4,1),''UserData''),1,' ...
                   'get(gcbf,''Name''),'''',' ...
                   'get(gca,''UserData''),' ...
                   'get(get(gca,''xlabel''),''userdata''));' ...
          'catch,' ...
            'pzg_err(''end of performance edit'');' ...
          'end,' ...
          'drawnow,' ...
          'pzg_onoff(1);' ...
          'clear temp0'] );
  hndl.visible_for_step_only = findobj( NewFig,'tag','visible for step only');
  
  temp0(9,2) = uicontrol(NewFig,'Style','checkbox', ...
      'Value',0, ...
      'String','Show [Input-Output]', ...
      'Units','normalized', ...
      'Position',[0.67 0.015 0.325 0.04], ...
      'BackgroundColor',[0.7 0.8 0.9], ...
      'ForegroundColor',[0 0 0], ...
      'tooltipstring','show difference between input and output', ...
      'tag','show_io_difference', ...
      'Callback', ...
           ['global PZG,' ...
            'temp_hndl=getappdata(gcbf,''hndl'');' ...
            'temp_dndx=temp_hndl.dom_ndx;' ...
            'temp_pndx=temp_hndl.ploth_ndx;' ...
            '[temp1,temp2,temp_prvw_on]=pzg_tools(temp_dndx);' ...
            'clear temp1 temp2,' ...
            'temp_errline_h=' ...
              'pzg_fndo(temp_dndx,temp_pndx,''pzgui_resppl_error_line'');' ...
            'temp_filtprv_h=' ...
               'pzg_fndo(temp_dndx,temp_pndx,''Gain_Preview'');' ...
            'if(numel(temp_filtprv_h)==2)&&temp_prvw_on,' ...
              'temp_errline_h=[temp_errline_h(:);temp_filtprv_h(2)];' ...
            'end,' ...
            'temp_filtprv_h=' ...
               'pzg_fndo(temp_dndx,temp_pndx,''LDLG_Preview'');' ...
            'if(numel(temp_filtprv_h)==2)&&temp_prvw_on,' ...
              'temp_errline_h=[temp_errline_h(:);temp_filtprv_h(2)];' ...
            'end,' ...
            'temp_filtprv_h=' ...
               'pzg_fndo(temp_dndx,temp_pndx,''PID_Preview'');' ...
            'if(numel(temp_filtprv_h)==2)&&temp_prvw_on,' ...
              'temp_errline_h=[temp_errline_h(:);temp_filtprv_h(2)];' ...
            'end,' ...
            'if get(gco,''Value'')==1;' ...
              'set(temp_errline_h,''Visible'',''on'');' ...
            'else;' ...
              'set(temp_errline_h,''Visible'',''off'');' ...
            'end;' ...
            'temp_rp_xlim=get(temp_hndl.ax,''xlim'');' ...
            'temp_rp_ylim=get(temp_hndl.ax,''ylim'');' ...
            'temp_hndl.ax_xlim=temp_rp_xlim;' ...
            'temp_hndl.ax_ylim=temp_rp_ylim;' ...
            'PZG(temp_hndl.dom_ndx).plot_h{temp_hndl.ploth_ndx}' ...
              '.xlim=temp_rp_xlim;' ...
            'PZG(temp_hndl.dom_ndx).plot_h{temp_hndl.ploth_ndx}' ...
              '.ylim=temp_rp_ylim;' ...
            'PZG(temp_hndl.dom_ndx).plot_h{temp_hndl.ploth_ndx}' ...
              '.hndl.ax_xlim=temp_rp_xlim;' ...
            'PZG(temp_hndl.dom_ndx).plot_h{temp_hndl.ploth_ndx}' ...
              '.hndl.ax_ylim=temp_rp_ylim;' ...
            'clear temp_hndl temp_rp_xlim temp_rp_ylim,' ...
            'clear temp_pndx temp_prvw_on temp_filtprv_h,' ...
            'clear temp_dndx temp_paramK_h temp_errline_h'] );
  hndl.show_io_difference = temp0(9,2);
  
  hndl.natl_h_checkbox = ...
    uicontrol(NewFig,'Style','checkbox', ...
      'Value',0, ...
      'String','natural', ...
      'Units','normalized', ...
      'Position',[0.01 0.005 0.20 0.04], ...
      'BackgroundColor',[0.7 0.8 0.9], ...
      'ForegroundColor',[0 0 0], ...
      'tag','natl_h checkbox', ...
      'tooltipstring','show the natural-response components', ...
      'Callback', ...
         ['global PZG,' ...
          'temp_hndl=getappdata(gcbf,''hndl'');' ...
          'temp_h=pzg_fndo(temp_hndl.dom_ndx,' ...
             'temp_hndl.ploth_ndx,''pzgui_natl_resp_line'');' ...
          'if~isempty(temp_h)&&(get(gcbo,''Value'')==1),' ...
            'set(temp_h,''Visible'',''on'');' ...
          'elseif~isempty(temp_h);' ...
            'set(temp_h,''Visible'',''off'');' ...
          'end,' ...
          'temp_rp_xlim=get(temp_hndl.ax,''xlim'');' ...
          'temp_rp_ylim=get(temp_hndl.ax,''ylim'');' ...
          'temp_hndl.ax_xlim=temp_rp_xlim;' ...
          'temp_hndl.ax_ylim=temp_rp_ylim;' ...
          'PZG(temp_hndl.dom_ndx).plot_h{temp_hndl.ploth_ndx}' ...
            '.xlim=temp_rp_xlim;' ...
          'PZG(temp_hndl.dom_ndx).plot_h{temp_hndl.ploth_ndx}' ...
            '.ylim=temp_rp_ylim;' ...
          'PZG(temp_hndl.dom_ndx).plot_h{temp_hndl.ploth_ndx}' ...
            '.hndl.ax_xlim=temp_rp_xlim;' ...
          'PZG(temp_hndl.dom_ndx).plot_h{temp_hndl.ploth_ndx}' ...
            '.hndl.ax_ylim=temp_rp_ylim;' ...
          'clear temp_h temp_hndl temp_rp_xlim temp_rp_ylim temp_msgbox_h'] );
  hndl.forc_h_checkbox = ...
    uicontrol(NewFig,'Style','checkbox', ...
      'Value',0, ...
      'String','forced', ...
      'Units','normalized', ...
      'Position',[0.21 0.005 0.20 0.04], ...
      'BackgroundColor',[0.7 0.8 0.9], ...
      'ForegroundColor',[0 0 0], ...
      'tooltipstring','show the forced-response components', ...
      'tag','forc_h checkbox', ...
      'Callback', ...
         ['global PZG,' ...
          'temp_hndl=getappdata(gcbf,''hndl'');' ...
          'temp_h=pzg_fndo(temp_hndl.dom_ndx,' ...
             'temp_hndl.ploth_ndx,''pzgui_forc_resp_line'');' ...
          'temp_h2=findobj(gcbf,''tag'',''pzgui phasemarkers'');' ...
          'if~isempty(temp_h)&&get(gcbo,''Value'')==1;' ...
            'set(temp_h,''visible'',''on'');' ...
            'if~isempty(temp_h2),' ...
              'set(temp_h2,''visible'',''on'');' ...
            'end,' ...
          'elseif~isempty(temp_h);' ...
            'set(temp_h,''visible'',''off'');' ...
            'if~isempty(temp_h2),' ...
              'temp_h2_ud=get(temp_h2(1),''userdata'');' ...
              'if isequal(''default off'',temp_h2_ud),' ...
                'set(temp_h2,''visible'',''off'');' ...
              'end,' ...
            'end,' ...
          'end;' ...
          'temp_rp_xlim=get(temp_hndl.ax,''xlim'');' ...
          'temp_rp_ylim=get(temp_hndl.ax,''ylim'');' ...
          'temp_hndl.ax_xlim=temp_rp_xlim;' ...
          'temp_hndl.ax_ylim=temp_rp_ylim;' ...
          'PZG(temp_hndl.dom_ndx).plot_h{temp_hndl.ploth_ndx}' ...
            '.xlim=temp_rp_xlim;' ...
          'PZG(temp_hndl.dom_ndx).plot_h{temp_hndl.ploth_ndx}' ...
            '.ylim=temp_rp_ylim;' ...
          'PZG(temp_hndl.dom_ndx).plot_h{temp_hndl.ploth_ndx}' ...
            '.hndl.ax_xlim=temp_rp_xlim;' ...
          'PZG(temp_hndl.dom_ndx).plot_h{temp_hndl.ploth_ndx}' ...
            '.hndl.ax_ylim=temp_rp_ylim;' ...
          'clear temp_h temp_hndl temp_rp_xlim temp_rp_ylim,' ...
          'clear temp_h2 temp_h2_ud'] );

  set(NewFig,'UserData',temp0);
  
  % Adjust the background color.
  figopts('apply_default_color', NewFig )
  
  set( NewFig,'visible','on')
  
  % Update the plot_h field.
  NewFig_name = get(NewFig,'name');
  
  if strcmp( NewFig_name, PZG(PZGndx).OLTimeRespName )
    ploth_ndx = 8;
  else
    ploth_ndx = 9;
  end
  x_lim = get( NewAx,'xlim');
  y_lim = get( NewAx,'ylim');
  hndl.ax_xlim = x_lim;
  hndl.ax_ylim = y_lim;
  setappdata( NewFig,'hndl', hndl );
  pzg_cphndl( NewFig, PZGndx, ploth_ndx )

  [ curr_tools, toolfig_h, preview_on ] = pzg_tools(dom_ndx);
  if ~isempty(toolfig_h) && any(curr_tools) && preview_on
    if curr_tools(1)
      gainfilt( get( toolfig_h,'name') );
    elseif curr_tools(2)
      ldlgfilt( get( toolfig_h,'name') );
    else
      pidfilt( get( toolfig_h,'name') );
    end
  end
  set( NewAx,'ylimmode','auto');
  
  x_lim = get( NewAx,'xlim');
  y_lim = get( NewAx,'ylim');
  if ( y_lim(1) >= -0.10 ) || ( y_lim(2) <= 1.1 )
    y_lim = [ min( -0.1, y_lim(1) ), max( 1.1, y_lim(2) ) ];
    set( NewAx,'ylim', y_lim );
  end
  hndl.ax_xlim = x_lim;
  hndl.ax_ylim = y_lim;
  setappdata( NewFig,'hndl', hndl );
  pzg_cphndl( NewFig, PZGndx, ploth_ndx )
  
else
  % Figure already exists.
  StepHndls = get(temp0(14,1),'UserData');
  if ~isempty(gco0) ...
    &&(gco0 ~= temp0(4,2)) && (gco0 ~= temp0(5,2)) ...
    &&(gco0 ~= temp0(6,2))
    set( StepHndls(1:17),'Visible','Off' );

    if Domain == 'z'
      MaxPlotEl = min( numel(Time),ceil(SigLength)+1);
    else
      MaxPlotEl = max( 1, sum(Time<=SigLength) );
    end
    MaxPlotEl = min(MaxPlotEl,numel(Time));
    MaxPlotEl = min(MaxPlotEl,numel(Ydata));
    set(temp0(2,1), ...
        'Xdata',Time(1:MaxPlotEl), ...
        'Ydata',Ydata(1:MaxPlotEl));
    if SigType == 1
      set(temp0(4,1), ...
          'Xdata',Time(1:MaxPlotEl), ...
          'Ydata',SigIn(1:MaxPlotEl), ...
          'linewidth', 1 );
    else
      set(temp0(4,1), ...
          'Xdata',Time(1:MaxPlotEl), ...
          'Ydata',SigIn(1:MaxPlotEl), ...
          'linewidth', 2 );
    end
    set(temp0(6,1), ...
        'Xdata',Time(1:MaxPlotEl), ...
        'Ydata',SigIn(1:MaxPlotEl)-Ydata(1:MaxPlotEl));
    
    % Adjust the x-axis highlight line length.
    xaxis_hilite_h = ...
      pzg_fndo( hndl.dom_ndx, hndl.ploth_ndx,'pzgui_resppl_xaxis_hilite');
    if ~isempty(xaxis_hilite_h)
      set( xaxis_hilite_h,'xdata', [Time(1);Time(end)],'ydata', [0 0] )
    end

    if SigType == 2
      [ tr_ypos, os_ypos, tp_ypos, us_ypos, ts_ypos, ss_ypos ] = ...
          local_get_text_ypos( Ydata, OSNdx, USNdx );
      if ~isempty(RiseStartNdx) && ~isempty(RiseEndNdx) ...
         &&~isempty(RiseTime)
        set(StepHndls(1), ...
            'Xdata', [ Time(RiseStartNdx)  Time(RiseStartNdx) ], ...
            'Ydata', [ 0 Ydata(RiseStartNdx) ], ...
            'Visible','On' );
        set(StepHndls(2), ...
            'Xdata', [ Time(RiseEndNdx)  Time(RiseEndNdx) ], ...
            'Ydata', [ 0 Ydata(RiseEndNdx) ], ...
            'Visible','On' );
        set(StepHndls(16), ...
            'Xdata',Time(RiseStartNdx:RiseEndNdx), ...
            'Ydata',Ydata(RiseStartNdx:RiseEndNdx), ...
            'Visible','On' );
        tempA = round( (RiseStartNdx+RiseEndNdx)/2 );
        if ( RiseTime <= 0 ) || isnan(RiseTime) || isinf(RiseTime)
          RTtext = '';
        else
          RTtext = ['T_r_i_s_e = ' num2str(RiseTime,4)];
        end
        set(StepHndls(3), ...
            'Position',[ Time(tempA)+0.03*Time(end)  tr_ypos  0 ], ...
            'String', RTtext, ...
            'Visible','On');
      end
      if ~isempty(OSNdx) && ~isempty(OS)
        set(StepHndls(4), ...
            'Xdata', [ Time(OSNdx) Time(OSNdx) ], ...
            'Ydata', [ 0 Ydata(OSNdx) ], ...
            'Visible','On');
        set(StepHndls(5), ...
            'Xdata', [ 0 Time(OSNdx) ], ...
            'Ydata', [ Ydata(OSNdx) Ydata(OSNdx) ], ...
            'Visible','On');
        if isinf(OS) || isnan(OS)
          OStext = '';
        else
          OStext = ['O.S.= ' num2str(OS,4) '%' ];
        end
        set(StepHndls(6), ...
            'Position',[ Time(OSNdx)+0.03*Time(end) os_ypos 0 ], ...
            'String', OStext, ...
            'Visible','On');
        set(StepHndls(17), ...
            'Position',[ Time(OSNdx)+0.03*Time(end) tp_ypos 0 ], ...
            'String', ['T_p_e_a_k = ' num2str(Time(OSNdx),4) ], ...
            'Visible','On');
      end
      if ~isempty(USNdx) && ~isempty(US)
        set(StepHndls(7), ...
            'Xdata', [ Time(USNdx) Time(USNdx) ], ...
            'Ydata', [ 0 Ydata(USNdx) ], ...
            'Visible','On' );
        set(StepHndls(8), ...
            'Xdata', [ 0 Time(USNdx) ], ...
            'Ydata', [ Ydata(USNdx) Ydata(USNdx) ], ...
            'Visible','On' );
        if isinf(US) || isnan(US)
          UStext = '';
        else
          UStext = ['U.S.= ' num2str(US,4) '%' ];
        end
        set(StepHndls(9), ...
            'Position', [Time(USNdx)+0.03*Time(end) us_ypos 0], ...
            'String', UStext, ...
            'Visible','On' );
      end
      if ~isempty(SettleNdx) && ~isempty(SettleTime)
        ts_str_xpos = max( Time(SettleNdx)+0.03*Time(end), 0.62*Time(end));
        set(StepHndls(10), ...
            'Xdata', [ Time(SettleNdx) Time(SettleNdx) ], ...
            'Ydata', [ 0 Ydata(SettleNdx) ], ...
            'Visible','On' );
        if DC_Gain ~= 0
          temp = (1+SettleRange) * DC_Gain;
        else
          temp = SettleRange;
        end
        set(StepHndls(11), ...
            'Xdata', [ 0 Time(end) ], ...
            'Ydata', [ temp temp ], ...
            'Visible','On' );
        if DC_Gain ~= 0
          temp = (1-SettleRange) * DC_Gain;
        else
          temp = -SettleRange;
        end
        set(StepHndls(12), ...
            'Xdata', [ 0 Time(end) ], ...
            'Ydata', [ temp temp ], ...
            'Visible','On' );
        set(StepHndls(13), ...
            'Position', ...
              [ ts_str_xpos ts_ypos 0 ], ...
            'String', ['T_s_e_t_t_l_e= ' num2str(SettleTime,5)], ...
            'Visible','On' );
      end
      if ~isempty(DC_Gain)
        set(StepHndls(14), ...
            'Xdata', [ 0 Time(end) ], ...
            'Ydata', [ DC_Gain DC_Gain ], ...
            'Visible','On' );

        if ~isempty(SettleNdx)
          ts_str_xpos = max( Time(SettleNdx)+0.03*Time(end), 0.62*Time(end) );
          set(StepHndls(15), ...
             'Position', [ts_str_xpos ss_ypos 0], ...
             'String', ['S.S.= ' num2str(DC_Gain) ], ...
             'Visible','On' );
        end
      end
      % If the system is unstable, make the ss-horiz line not visible.
      tempA = findobj( temp0(1,1),'tag','pzgui resppl ss horiz line');  
      if ( strcmp( Domain,'z') && any( abs(PoleLocs) > 1 ) ) ...
        ||( strcmp( Domain,'s') && any( real(PoleLocs) > 0 ) )
        set( tempA,'visible','off')
      else
        set( tempA,'visible','on')
      end
    end
    
    if isfield(hndl,'pzgui_phasemarkers')
      phasemarkers_h = hndl.pzgui_phasemarkers;
    else
      phasemarkers_h = ...
        [ findobj( temp0(1,1),'type','line','tag','pzgui phasemarkers'); ...
          findobj( temp0(1,1),'type','text','tag','pzgui phasemarkers') ];
    end
    if ~isempty(phasemarkers_h)
      set(phasemarkers_h,'visible','off')
    end
    
    if ( SigType == 5 )
      
      show_ss_data = 0;
      if isempty(CoprimePoles) ...
         ||( strcmpi('s',Domain) ...
            && ( max( real(CoprimePoles) ) < -1e-12 ) ) ...
         ||( strcmpi('z',Domain) ...
            && ( max( abs(CoprimePoles) ) < (1-1e-12) ) ) ...
         ||( strcmpi('s',Domain) ...
            && ( sum( CoprimePoles == 0 ) == 1 ) ...
            && ( max( real(CoprimePoles) ) <= -1e-12 ) ) ...
         ||( strcmpi('z',Domain) ...
            && ( sum( abs(CoprimePoles-1) < -1e-5 ) == 1 ) ...
            && ( max( abs(CoprimePoles) ) < (1-1e-5) ) )
        show_ss_data = 1;
      elseif stdy_state_only
        show_ss_data = 1;
      end
      % Create the phase markers for sinusoidal response.
      % Determine the peaks after the settling time.
      % Time, SigIn, Ydata
      if isempty(TimeConstant)
        TimeConstant = t_one_cycle;
      end
      SettleTime = 4*TimeConstant;
      
      if ( Time(end) > ( SettleTime + 2*t_one_cycle ) ) ...
        ||( stdy_state_only && ( Time(end) > 4*TimeConstant ) )
        
        if stdy_state_only
          SigIn_cycle_start = ...
            ( ceil( 4*TimeConstant / t_one_cycle ) - 0.25 )*t_one_cycle;
          if SigIn_cycle_start < ( Time(1)+0.5*t_one_cycle )
            SigIn_cycle_start = SigIn_cycle_start + t_one_cycle;
          end
        else
          SigIn_cycle_start = ...
            t_one_cycle*( ceil( SettleTime / t_one_cycle ) - 0.25 );
        end
        
        if Domain == 's'
          bdy_pt = 1i*2*pi*str2num( get(temp0(8,2),'String') ); %#ok<ST2NM>
          olGain = PZG(1).Gain;
        else
          bdy_pt = ...
            exp( 1i*2*pi*str2num( get(temp0(8,2),'String') )*Ts ); %#ok<ST2NM>
          olGain = PZG(2).Gain;
        end
        [ ssMag, ssPhs ] = ...
            local_get_stdystate( bdy_pt, ZeroLocs, PoleLocs, olGain, architec ); 
        
        
        if aliased_Freq == inputFreq
          Ydata_cycle_start = SigIn_cycle_start - (ssPhs/360)*t_one_cycle;
        else
          Ydata_cycle_start = SigIn_cycle_start + (ssPhs/360)*t_one_cycle;
        end
        
        signal_top = max(1,ssMag);
        ax_color = get(temp0(1,1),'color');
        if isequal(ax_color,[0 0 0])
          phase_color = [1 1 1];
        else
          phase_color = [0 0 0];
        end
        
        if numel(phasemarkers_h) ~= 9
          delete(phasemarkers_h)
          phasemarkers_h = ...
            plot( [ SigIn_cycle_start; SigIn_cycle_start ], ...
                  [ 0; 1.48*signal_top ], ...
                  'color', phase_color, ...
                  'linewidth', 2, ...
                  'parent', temp0(1,1), ...
                  'tag','pzgui phasemarkers');
          phasemarkers_h(2) = ...
            plot( [ SigIn_cycle_start+t_one_cycle; ...
                     SigIn_cycle_start+t_one_cycle ], ...
                  [ 0; 1.48*signal_top ], ...
                  'color', phase_color, ...
                  'linewidth', 2, ...
                  'parent', temp0(1,1), ...
                  'tag','pzgui phasemarkers');
          phasemarkers_h(3) = ...
            plot( [ Ydata_cycle_start; Ydata_cycle_start ], ...
                  [ 0; 1.48*signal_top ], ...
                  'color', phase_color, ...
                  'linewidth', 2, ...
                  'linestyle','--', ...
                  'parent', temp0(1,1), ...
                  'tag','pzgui phasemarkers');
          phasemarkers_h(4) = ...
            plot( sort([ SigIn_cycle_start; Ydata_cycle_start ]), ...
                  1.45*[ signal_top; signal_top ], ...
                  'color', phase_color, ...
                  'linewidth', 2, ...
                  'linestyle','--', ...
                  'parent', temp0(1,1), ...
                  'tag','pzgui phasemarkers');
          phasemarkers_h(5) = ...
            plot( [ SigIn_cycle_start; ...
                    SigIn_cycle_start+t_one_cycle ], ...
                  1.25*[ signal_top; signal_top ], ...
                  'color', phase_color, ...
                  'linewidth', 2, ...
                  'parent', temp0(1,1), ...
                  'tag','pzgui phasemarkers');
          if stdy_state_only
            ss_hilite_start = Time( ceil(numel(Time)/4) );
          else
            ss_hilite_start = ...
              max( Time(1), 0.7*min(SettleTime,SigIn_cycle_start) );
          end
          phasemarkers_h(6) = ...
            plot( [ ss_hilite_start; Time(end) ], ...
                  [ ssMag; ssMag ], ...
                  'color',[0 1 1], ...
                  'linewidth', 2, ...
                  'linestyle','--', ...
                  'parent', temp0(1,1), ...
                  'tag','pzgui phasemarkers');
          phasemarkers_h(7) = ...
            text( max(SigIn_cycle_start,Ydata_cycle_start)+0.05*t_one_cycle, ...
                  1.38*signal_top, ...
                  [ phase_360_sign '360^o'], ...
                  'color', phase_color, ...
                  'fontweight','bold', ...
                  'fontsize', 11, ...
                  'interpreter','tex', ...
                  'parent', temp0(1,1), ...
                  'tag','pzgui phasemarkers');
          phase_text = [ num2str(ssPhs,5) '^o'];
          if ssPhs > 0
            phase_text = ['+' phase_text];
          end
          phasemarkers_h(8) = ...
            text( min(SigIn_cycle_start,Ydata_cycle_start), ...
                  1.58*signal_top, ...
                  phase_text, ...
                  'color', phase_color, ...
                  'fontname','fixedwidth', ...
                  'fontweight','bold', ...
                  'fontsize', 12, ...
                  'interpreter','tex', ...
                  'parent', temp0(1,1), ...
                  'tag','pzgui phasemarkers');
          phasemarkers_h(9) = ...
            text( max(SigIn_cycle_start,Ydata_cycle_start)+1.05*t_one_cycle, ...
                  max(1.12*ssMag, ssMag+0.1), ...
                  [ num2str(ssMag,5) ' (' num2str(20*log10(ssMag),4) ' dB)'], ...
                  'color', [0 0.7 0.7], ...
                  'fontname','fixedwidth', ...
                  'fontweight','bold', ...
                  'fontsize', 12, ...
                  'interpreter','tex', ...
                  'parent', temp0(1,1), ...
                  'tag','pzgui phasemarkers');
          PZG(dom_ndx).plot_h{olcl_fig_ndx}.hndl.pzgui_phasemarkers = ...
            phasemarkers_h;
        else
          set( phasemarkers_h(1), ...
              'xdata', [ SigIn_cycle_start; SigIn_cycle_start ], ...
              'ydata', [ 0; 1.48*signal_top ], ...
              'color', phase_color, ...
              'linewidth', 2 );
          set( phasemarkers_h(2), ...
              'xdata', [ SigIn_cycle_start+t_one_cycle; ...
                         SigIn_cycle_start+t_one_cycle ], ...
              'ydata', [ 0; 1.48*signal_top ], ...
              'color', phase_color, ...
              'linewidth', 2 );
          set( phasemarkers_h(3), ...
              'xdata', [ Ydata_cycle_start; Ydata_cycle_start ], ...
              'ydata', [ 0; 1.48*signal_top ], ...
              'color', phase_color, ...
              'linewidth', 2, ...
              'linestyle','--');
          set( phasemarkers_h(4), ...
              'xdata', sort([ SigIn_cycle_start; Ydata_cycle_start ]), ...
              'ydata', 1.45*[ signal_top; signal_top ], ...
              'color', phase_color, ...
              'linewidth', 2, ...
              'linestyle','--');
          set( phasemarkers_h(5), ...
              'xdata', [ SigIn_cycle_start; ...
                         SigIn_cycle_start+t_one_cycle ], ...
              'ydata', 1.25*[ signal_top; signal_top ], ...
              'color', phase_color, ...
              'linewidth', 2);
          if stdy_state_only
            ss_hilite_start = Time( ceil(numel(Time)/4) );
          else
            ss_hilite_start = ...
              max( Time(1), 0.7*min(SettleTime,SigIn_cycle_start) );
          end
          set( phasemarkers_h(6), ...
              'xdata', [ ss_hilite_start; Time(end) ], ...
              'ydata', [ ssMag; ssMag ], ...
              'color',[0 1 1], ...
              'linewidth', 2, ...
              'linestyle','--');
          set( phasemarkers_h(7), ...
              'position', ...
                [ max(SigIn_cycle_start,Ydata_cycle_start)+0.05*t_one_cycle, ...
                  1.38*signal_top 0 ], ...
              'string', [ phase_360_sign '360^o'], ...
              'color', phase_color, ...
              'fontweight','bold', ...
              'fontsize', 11, ...
              'interpreter','tex');
          phase_text = [ num2str(ssPhs,5) '^o'];
          if ssPhs > 0
            phase_text = ['+' phase_text];
          end
          set( phasemarkers_h(8), ...
              'position', ...
                [ min(SigIn_cycle_start,Ydata_cycle_start), ...
                  1.58*signal_top 0 ], ...
              'string', phase_text, ...
              'color', phase_color, ...
              'fontname','fixedwidth', ...
              'fontweight','bold', ...
              'fontsize', 12, ...
              'interpreter','tex');
          set( phasemarkers_h(9), ...
              'position', ...
                [ max(SigIn_cycle_start,Ydata_cycle_start)+1.05*t_one_cycle, ...
                  max(1.12*ssMag, ssMag+0.1) 0 ], ...
              'string', ...
                [ num2str(ssMag,5) ' (' num2str(20*log10(ssMag),4) ' dB)'], ...
              'color', [0 1 1], ...
              'fontname','fixedwidth', ...
              'fontweight','bold', ...
              'fontsize', 12, ...
              'interpreter','tex');        
        end
        if stdy_state_only
          xlimmode = get( temp0(1,1),'xlimmode');
          if ~strcmp( xlimmode,'auto')
            set( temp0(1,1),'xlim',[ Time(1), Time(end)])
          end
        end
        
        if ~show_ss_data
          set(phasemarkers_h,'visible','off','userdata','default off')
        else
          set(phasemarkers_h,'visible','on','userdata','default on')
        end
      end
    end
    if SigType ~= 5
      set( phasemarkers_h,'visible','off')
    end
    
    if SigType >= 5
      set( temp0(7:8,2),'Visible', vis_state );
      set( temp0(11:14,2),'Visible', vis_state );
    else
      set( temp0(7:8,2),'Visible','Off');
      set( temp0(11:14,2),'Visible','Off');
    end
    if SigType == 1
      set(YLablHndl,'String','Impulse Input (green), Output (red)');
    elseif SigType == 2
      set(YLablHndl,'String','Step Input (green), Output (red)');
    elseif SigType == 3
      set(YLablHndl,'String','Ramp Input (green), Output (red)');
      set(YLablHndl,'String','Ramp Input (dashed) and Response (solid)');
    elseif SigType == 4
      set(YLablHndl,'String','Parabolic Input (green), Output (red)');
    elseif SigType == 5
      set(YLablHndl,'String','Cosine Input (green), Output (red)');
    end
    if stdy_state_only
      set( temp0(1,1),'YLimMode','auto','Interruptible','On' );
      ylim = get( temp0(1,1),'YLim');
      ylim(1) = min( -1.06*ssMag, -1.06 );
      ylim(2) = max( 1.7*ssMag, 1.7 );
      set( temp0(1,1),'YLim', ylim );
    elseif isempty(gcbo) ...
      ||( ~strcmp( get(gcbo,'type'),'figure') ...
         && isempty( strfind( get(gcbo,'callback'),'Set TS') ) )
      set( temp0(1,1), ...
          'XLimMode','auto','YLimMode','auto','Interruptible','On' );
      resppl('resppl wbdf reset');
    end
  end
  
  if SigType ~= 2
    set( StepHndls(1:16),'Visible','Off' );
  end

  if Domain == 'z'
    PerfLoSmp = max(1,1+floor(PerfLo/Ts));
    PerfHiSmp = min(numel(Ydata)-1,ceil(PerfHi/Ts));
    Error = SigIn - Ydata;
    Error = 0.5 * ( Error(1:end-1) + Error(2:end) );
    if PerfType == 1
      Perf = Ts*sum(abs(Error(PerfLoSmp:PerfHiSmp)));
    elseif PerfType == 2
      Perf = Ts*sum( Time(PerfLoSmp:PerfHiSmp) ...
             .* abs(Error(PerfLoSmp:PerfHiSmp)) );
    elseif PerfType == 3
      Perf = Ts*sum( (Error(PerfLoSmp:PerfHiSmp)).^2 );
    elseif PerfType == 4
      Perf = Ts*sum( Time(PerfLoSmp:PerfHiSmp) ...
            .* ( (Error(PerfLoSmp:PerfHiSmp)).^2 ) );
    else
      Perf = 0;
    end
  else
    PerfHiSmp = min(1+ceil(PerfHi/deltaT),numel(Ydata)-1);
    PerfLoSmp = max(floor(PerfLo/deltaT),1);
    Error = SigIn - Ydata;
    Error = 0.5 * ( Error(1:end-1) + Error(2:end) );
    if PerfType == 1
      Perf = deltaT*sum(abs(Error(PerfLoSmp:PerfHiSmp)));
    elseif PerfType == 2
      Perf = deltaT*sum( Time(PerfLoSmp:PerfHiSmp) ...
            .* abs(Error(PerfLoSmp:PerfHiSmp)) );
    elseif PerfType == 3
      Perf = deltaT*sum( (Error(PerfLoSmp:PerfHiSmp)).^2 );
    elseif PerfType == 4
      Perf = deltaT*sum( Time(PerfLoSmp:PerfHiSmp) ...
            .* ( (Error(PerfLoSmp:PerfHiSmp)).^2 ) );
    else
      Perf = 0;
    end
  end
  set(temp0(3,2),'String',num2str(Perf));

  if Domain == 's'
    bdy_pt = 1i*2*pi*str2num( get(temp0(8,2),'String') ); %#ok<ST2NM>
    olGain = PZG(1).Gain;
  else
    bdy_pt = ...
      exp( 1i*2*pi*str2num( get(temp0(8,2),'String') )*Ts ); %#ok<ST2NM>
    olGain = PZG(2).Gain;
  end
  [ ssMag, ssPhs ] = ...
      local_get_stdystate( bdy_pt, ZeroLocs, PoleLocs, olGain, architec ); 
  
  if isequal( SigType, 5 )
    set( hndl.visible_for_sinusoid_only,'Visible','on');
    set( hndl.visible_for_periodic_only,'Visible','on');
    set( temp0(12,2),'String',pzg_efmt(ssMag,4));
    set( temp0(14,2),'String',pzg_efmt(ssPhs,4));
  else
    set( hndl.visible_for_sinusoid_only,'Visible','off');
    set( hndl.visible_for_periodic_only,'Visible','off');
    set( temp0(12,2),'String',pzg_efmt(ssMag,4) );
    set( temp0(14,2),'String',pzg_efmt(ssPhs,4) );
  end
end

if stdy_state_only 
  set( temp0(12,2),'String',pzg_efmt(ssMag,4),'Visible','on');
  set( temp0(14,2),'String',pzg_efmt(ssPhs,4),'Visible','on');
end
if ~stdy_state_only && ( numel(Time) > 3 )
  curr_sim_time = str2double( get( temp0(2,2),'string') );
  if isempty(curr_sim_time) || ~isnumeric(curr_sim_time) ...
    || isinf(curr_sim_time) || isnan(curr_sim_time) ...
    || ( curr_sim_time <= 0 ) ...
    ||( (curr_sim_time-Time(end))/Time(end) > 1e-3 )
    set( temp0(2,2),'string', num2str(Time(end)),'visible','on')
  end
end

natl_h = pzg_fndo( dom_ndx, olcl_fig_ndx,'pzgui_natl_resp_line');
forc_h = pzg_fndo( dom_ndx, olcl_fig_ndx,'pzgui_forc_resp_line');

force_color = [0 0.75 0.75];
if PZGndx == 1
  markerval = 'none';
  
else
  markerval = '.';
end
markersizeval = 6;

if ~isempty(natl_resp) && ~isempty(forc_resp)
  resp_ndx = min( numel(natl_resp), numel(Time) );
  t_natl = Time(1:resp_ndx);
  t_natl = [ t_natl(:)*ones(1,size(natl_resp,2)); ...
             NaN*ones(1,size(natl_resp,2)) ];
  y_natl = [ natl_resp(1:resp_ndx,:); ...
             NaN*ones(1,size(natl_resp,2)) ];
  if ~isequal( numel(natl_h), 1 )
    delete(natl_h)
    natl_h = ...
      plot( t_natl(:), y_natl(:), ...
           'color', 1-get(temp0(1,1),'color'), ...
           'linestyle','-.', ...
           'LineWidth', 1.5, ...
           'marker', markerval, ...
           'markersize', markersizeval/2, ...
           'parent',temp0(1,1), ...
           'Visible','off', ...
           'tag','pzgui natl_resp line');
    hndl.pzgui_natl_resp_line = natl_h;
  else
    set( natl_h,'xdata', t_natl(:),'ydata', y_natl(:) );
  end
  t_forc = Time(1:resp_ndx);
  t_forc = [ t_forc(:)*ones(1,size(forc_resp,2)); ...
             NaN*ones(1,size(forc_resp,2)) ];
  y_forc = [ forc_resp(1:resp_ndx,:); ...
             NaN*ones(1,size(forc_resp,2)) ];
  if ~isequal( numel(forc_h), 1 )
    delete(forc_h)
    forc_h = ...
      plot( t_forc(:), y_forc(:), ...
           'color', force_color, ...
           'linestyle','-.', ...
           'LineWidth', 1.5, ...
           'marker', markerval, ...
           'markersize', markersizeval/2, ...
           'parent',temp0(1,1), ...
           'Visible','off', ...
           'tag','pzgui forc_resp line');
  else
    set( forc_h,'xdata', t_forc(:),'ydata', y_forc(:) );
  end
end
natl_chk_h = findobj( FigHndl,'tag','natl_h checkbox');
if get(natl_chk_h,'value')
  set( natl_h,'visible','on');
end
forc_chk_h = findobj( FigHndl,'tag','forc_h checkbox');
if get(forc_chk_h,'value')
  set( forc_h,'visible','on');
end
hndl.pzgui_natl_resp_line = natl_h;
hndl.pzgui_forc_resp_line = forc_h;

x_lim = get( temp0(1,1),'xlim');
x_lim(1) = max( 0, x_lim(1));
x_lim(2) = min( Time(end), x_lim(2) );
if diff(x_lim) <= 0
  x_lim = [ Time(1) Time(end)];
end
set( temp0(1,1),'xlim',x_lim );
hndl.ax_xlim = x_lim;

y_lim = get( temp0(1,1),'ylim');
hndl.ax_ylim = y_lim;

setappdata( FigHndl,'hndl', hndl );

if ~isempty( strfind( PlotName,'Open') )
  pzg_cphndl( FigHndl, dom_ndx, 8 );
else
  pzg_cphndl( FigHndl, dom_ndx, 9 );
end

if any( pzg_tools )
  pzg_prvw( dom_ndx );
end
pzg_updtfilt(dom_ndx);

if ishandle(wb_h)
  waitbar( 1, wb_h )
  drawnow
  delete(wb_h)
end

return

% LOCAL FUNCTIONS

function [ natl_resp, forc_resp ] = ...
            local_natl_forc_resp( ...
              Gain, CoprimeN, CoprimeD, Time, ...
              Domain, input_type, PlotName, sinefreq_radsec )

% Compute the natural response, in terms of decaying exponentials
% and decaying sinusoids, and the forced response.
%
% Returns forc_resp as a vector with size(Time)
% and natl_resp as a matrix of vectors containing the various
% decaying exponentials and decaying sinusoids of the natural response.
%
% Input argument 'input_type' must be one of the following:
%  {'impulse','step','ramp','parabola','sinusoid'}

global PZG

natl_resp = [];
forc_resp = [];
if ( nargin < 6 ) ...
  ||~ischar(input_type) || ~ischar(Domain) ...
  ||~ismember( input_type, ...
              {'impulse','step','ramp','parabola','sinusoid'}) ...
  ||~ismember( Domain,{'z','s'})
  return
end

% Compute the individual PFE-term responses.
closed_loop = 0;
switch Domain
  case 's'
    if ~isempty( strfind( PlotName,'Closed') )
      Zin = PZG(1).CLZeroLocs;
      Pin = PZG(1).CLPoleLocs;
      Kin = PZG(1).CLGain;
      closed_loop = 1;
    elseif ~isempty( strfind( PlotName,'Open') )
      Zin = PZG(1).ZeroLocs;
      Pin = PZG(1).PoleLocs;
      Kin = PZG(1).Gain;
    else
      Zin = [];
      Pin = [];
      Kin = [];
    end
    Pin_noninteg = Pin( Pin ~= 0 );
    use_local_residue = 1;
    if numel(unique(Pin_noninteg)) ~= numel(Pin_noninteg)
      use_local_residue = 0;
    end
    switch input_type
      case 'impulse'
        if isempty(Kin) || ~use_local_residue
          [R,P] = residue( Gain*CoprimeN, CoprimeD );
        else
          [R,P] = local_residue( Zin, Pin, Kin, Domain );
        end
      case 'step'
        if isempty(Kin) || ~use_local_residue
          [R,P] = residue( Gain*CoprimeN, poly([roots(CoprimeD); 0 ]) );
        else
          [R,P] = local_residue( Zin, [ Pin; 0 ], Kin, Domain );
        end
      case 'ramp'
        if isempty(Kin) || ~use_local_residue
          [R,P] = residue( Gain*CoprimeN, poly([roots(CoprimeD); 0; 0 ]) );
        else
          [R,P] = local_residue( Zin, [ Pin; 0; 0 ], Kin, Domain );
        end
      case 'parabola'
        % Introduce a factor of two, because input it t^2 (not 0.5*t^2).
        if isempty(Kin) || ~use_local_residue
          [R,P] = residue( Gain*CoprimeN, poly([roots(CoprimeD); 0; 0; 0 ]) );
        else
          [R,P] = local_residue( Zin, [ Pin; 0; 0; 0 ], Kin, Domain );
        end
      case 'sinusoid'
        if isempty(Kin) || ~use_local_residue
          % Assume a cosine function, putting a zero at s=0.
          % Recompute the gain, first element of Num to unity.
          while ( CoprimeN(1) == 0 ) && ( numel(CoprimeN) > 1 )
            CoprimeN(1) = [];
          end
          Gain = Gain*CoprimeN(1);
          CoprimeN = CoprimeN/CoprimeN(1);
          [R,P] = residue( Gain*poly([ roots(CoprimeN); 0 ]), ...
                           poly([ roots(CoprimeD); ...
                                  1i*sinefreq_radsec; ...
                                  -1i*sinefreq_radsec ]) );
        else
          [R,P] = ...
            local_residue( ...
              [ Zin; 0 ], ...
              [ Pin; 1i*sinefreq_radsec; -1i*sinefreq_radsec ], ...
              Kin, Domain );
        end
      otherwise
        return
    end
    pole_ndx = find( imag(P) >= 0 );
    all_resp = zeros( numel(Time), numel(pole_ndx) );
    for k = 1:numel(pole_ndx)
      rep_ndx = find( P(pole_ndx) == P(pole_ndx(k)) );
      rep_ndx = pole_ndx(rep_ndx); %#ok<FNDSB>
      den_order = find( pole_ndx(k) == rep_ndx );
      if isreal(P(pole_ndx(k)))
        all_resp(:,k) = ...
          impulse( real(R(pole_ndx(k))), ...
                   poly(P(rep_ndx(1:den_order))), Time );
      else
        NUM = R(pole_ndx(k)) * poly(conj(P(rep_ndx(1:den_order)))) ...
             +conj(R(pole_ndx(k))) * poly(P(rep_ndx(1:den_order)));
        DEN = poly([ P(rep_ndx(1:den_order)); ...
                     conj(P(rep_ndx(1:den_order))) ]);
        all_resp(:,k) = impulse( NUM, DEN, Time );
      end
    end
    integ_ndx = find( P(pole_ndx) == 0 );
    switch input_type
      case 'impulse'
        forc_resp = zeros(numel(Time),1);
        natl_resp = all_resp;
      case 'step'
        forc_resp = all_resp(:,integ_ndx(1));
        if numel(pole_ndx) > 1
          natl_ndx = setdiff( (1:numel(pole_ndx)), integ_ndx(1) );
          natl_resp = all_resp(:,natl_ndx);
        end
      case 'ramp'
        forc_resp = all_resp(:,integ_ndx(1:2));
        if numel(pole_ndx) > 1
          natl_ndx = setdiff( (1:numel(pole_ndx)), integ_ndx(1:2) );
          natl_resp = all_resp(:,natl_ndx);
        end
      case 'parabola'
        forc_resp = all_resp(:,integ_ndx(1:3));
        if numel(pole_ndx) > 1
          natl_ndx = setdiff( (1:numel(pole_ndx)), integ_ndx(1:3) );
          natl_resp = all_resp(:,natl_ndx);
        end
      case 'sinusoid'
        cos_ndx = ...
          find( abs( P(pole_ndx) - 1i*sinefreq_radsec ) < 1e-12 );
        forc_resp = all_resp(:,cos_ndx(1));
        if numel(pole_ndx) > 1
          natl_ndx = setdiff( (1:numel(pole_ndx)), cos_ndx(1) );
          natl_resp = all_resp(:,natl_ndx);
        end
      otherwise
    end
    
    if ( PZG(1).PureDelay ~= 0 ) && ~closed_loop
      [ temp, delay_index ] = ...
          min( abs( Time - PZG(1).PureDelay ) ); %#ok<ASGLU>
      if Time(delay_index) > (PZG(1).PureDelay-100*eps)
        delay_index = delay_index - 1;
      end
      if size(natl_resp,1) > delay_index
        natl_resp = ...
          [ zeros(delay_index,size(natl_resp,2)); ...
            natl_resp(1:end-delay_index,:) ];
      else
        natl_resp = zeros(numel(Time),size(natl_resp,2));
      end
      if size(forc_resp,1) > delay_index
        forc_resp = ...
          [ zeros(delay_index,size(forc_resp,2)); ...
            forc_resp(1:end-delay_index,:) ];
      else
        forc_resp = zeros(numel(Time),size(forc_resp,2));
      end
    end
    
  case 'z'
    % Recompute the gain, first element of Num to unity.
    Ts = PZG(2).Ts;
    while ( CoprimeN(1) == 0 ) && ( numel(CoprimeN) > 1 )
      CoprimeN(1) = [];
    end
    Gain = Gain*CoprimeN(1);
    CoprimeN = CoprimeN/CoprimeN(1);
    
    if ~isempty( strfind( PlotName,'Closed') )
      Zin = PZG(2).CLZeroLocs;
      Pin = PZG(2).CLPoleLocs;
      Kin = PZG(2).CLGain;
      closed_loop = 1;
    elseif ~isempty( strfind( PlotName,'Open') )
      Zin = PZG(2).ZeroLocs;
      Pin = PZG(2).PoleLocs;
      Kin = PZG(2).Gain;
    else
      Zin = [];
      Pin = [];
      Kin = [];
    end
    Pin_noninteg = Pin( Pin ~= 1 );
    use_local_residue = 1;
    if numel(unique(Pin_noninteg)) ~= numel(Pin_noninteg)
      use_local_residue = 0;
    end
    
    switch input_type
      case 'impulse'
        if isempty(Kin) || ~use_local_residue
          [R,P,K] = residue( Gain*CoprimeN, CoprimeD );
        else
          [R,P,K] = local_residue( Zin, Pin, Kin, Domain );
        end
      case 'step'
        if isempty(Kin) || ~use_local_residue
          [R,P,K] = ...
             residue( Gain*CoprimeN, ...
                      poly([roots(CoprimeD); 1 ]) );
          [ temp, closest_ndx ] = sort( abs( P - 1 ) ); %#ok<ASGLU>
          P(closest_ndx(1)) = 1;
        else
          [R,P,K] = local_residue( Zin, [Pin;1], Kin, Domain );
        end
      case 'ramp'
        if isempty(Kin) || ~use_local_residue
          [R,P,K] = ...
            residue( Ts/2*Gain*CoprimeN, ...
                     poly([roots(CoprimeD); 1; 1 ]) );
          [ temp, closest_ndx ] = sort( abs( P - 1 ) ); %#ok<ASGLU>
          P(closest_ndx(1:2)) = 1;
          R(closest_ndx(1:2)) = real(R(closest_ndx(1:2)));
        else
          [R,P,K] = local_residue( Zin, [Pin;1;1], Ts*Kin, Domain );
        end
      case 'parabola'
        if isempty(Kin) || ~use_local_residue
          % Introduce a factor of two, because input it t^2 (not 0.5*t^2).
          [R,P,K] = residue( Ts^2*Gain*4*poly([roots(CoprimeN);-1]), ...
                             poly([roots(CoprimeD);1;1;1]) );
          [ temp, closest_ndx ] = sort( abs( P - 1 ) ); %#ok<ASGLU>
          P(closest_ndx(1:3)) = 1;
          R(closest_ndx(1:3)) = real(R(closest_ndx(1:3)));
        else
          [R,P,K] = ...
            local_residue( [Zin;-1], [Pin;1;1;1], Ts^2*Kin, Domain );
        end
      case 'sinusoid'
        % Assume a cosine function, putting a zero at s=0.
        if isempty(Kin) || ~use_local_residue
          [R,P,K] = ...
            residue( Gain*poly([ roots(CoprimeN); ...
                                 cos(sinefreq_radsec*Ts) ]), ...
                     poly([ roots(CoprimeD); ...
                            exp(1i*sinefreq_radsec*Ts); ...
                            exp(-1i*sinefreq_radsec*Ts) ]) );
        else
          [R,P,K] = ...
            local_residue( ...
               [Zin; cos(sinefreq_radsec*Ts) ], ...
               [ Pin; ...
                 exp(1i*sinefreq_radsec*Ts); ...
                 exp(-1i*sinefreq_radsec*Ts)], Kin, Domain );
        end
      otherwise
        return
    end
    pole_ndx = find( imag(P) >= 0 );
    if isequal( input_type,'sinusoid')
      all_resp = zeros( numel(Time)+1, numel(pole_ndx) );
    else
      all_resp = zeros( numel(Time), numel(pole_ndx) );
    end
    for k = 1:numel(pole_ndx)
      rep_ndx = find( abs( P(pole_ndx) - P(pole_ndx(k)) ) < 1e-8 );
      rep_ndx = pole_ndx(rep_ndx); %#ok<FNDSB>
      den_order = find( pole_ndx(k) == rep_ndx );
      if isreal(P(pole_ndx(k)))
        if isequal( input_type,'impulse')
          all_resp(:,k) = ...
            dimpulse( real(R(pole_ndx(k))), ...
                      poly(P(rep_ndx(1:den_order))), numel(Time) );
        elseif isequal( input_type,'sinusoid')
          % Account for inherent delay, by extra time sample.
          all_resp(:,k) = ...
            dimpulse( real(R(pole_ndx(k))), ...
                      poly(P(rep_ndx(1:den_order))), numel(Time)+1 );
        else
          % Advance in time by one sample.
          all_resp(:,k) = ...
            dimpulse( [ real(R(pole_ndx(k))) 0 ], ...
                      poly(P(rep_ndx(1:den_order))), numel(Time) );
        end
      else
        NUM = R(pole_ndx(k)) * poly(conj(P(rep_ndx(1:den_order)))) ...
              +conj(R(pole_ndx(k))) * poly(P(rep_ndx(1:den_order)));
        DEN = poly([ P(rep_ndx(1:den_order)); ...
                     conj(P(rep_ndx(1:den_order))) ]);
        if isequal( input_type,'impulse')
          all_resp(:,k) = dimpulse( NUM, DEN, numel(Time) );
        elseif isequal( input_type,'sinusoid')
          % Account for inherent delay, by extra time sample.
          all_resp(:,k) = dimpulse( NUM, DEN, numel(Time)+1 );
        else
          % Put the "advance" zero into the numerator polynomial.
          all_resp(:,k) = dimpulse( [ NUM 0 ], DEN, numel(Time) );
        end
      end
    end
    if isequal( input_type,'sinusoid')
      % Delete the extra time-sample in sinusoid simulation.
      all_resp(1,:) = [];
    end
    
    integ_ndx = find( abs( P(pole_ndx) - 1 ) < 1e-8 );
    switch input_type
      case 'impulse'
        forc_resp = zeros(numel(Time),1);
        if ~isempty(K)
          forc_resp(1) = K;
        end
        natl_resp = all_resp;
      case 'step'
        forc_resp = all_resp(:,integ_ndx(1));
        if numel(pole_ndx) > 1
          natl_ndx = setdiff( (1:numel(pole_ndx)), integ_ndx(1) );
          natl_resp = all_resp(:,natl_ndx);
        end
      case 'ramp'
        forc_resp = all_resp(:,integ_ndx(1:2));
        if numel(pole_ndx) > 1
          natl_ndx = setdiff( (1:numel(pole_ndx)), integ_ndx(1:2) );
          natl_resp = all_resp(:,natl_ndx);
        end
      case 'parabola'
        forc_resp = all_resp(:,integ_ndx(1:3));
        if numel(pole_ndx) > 1
          natl_ndx = setdiff( (1:numel(pole_ndx)), integ_ndx );
          natl_resp = all_resp(:,natl_ndx);
        end
      case 'sinusoid'
        cos_ndx = [];
        dist = 1e-8;
        while isempty(cos_ndx)
          cos_ndx = ...
            find( abs( P(pole_ndx) - exp(1i*sinefreq_radsec*Ts) ) < 1e-8 );
          dist = 2*dist;
        end
        forc_resp = all_resp(:,cos_ndx(1));
        if numel(pole_ndx) > 1
          natl_ndx = setdiff( (1:numel(pole_ndx)), cos_ndx(1) );
          natl_resp = all_resp(:,natl_ndx);
        end
      otherwise
    end
    if ( PZG(2).PureDelay ~= 0 ) && ~closed_loop
      delay_index = PZG(2).PureDelay;
      if size(natl_resp,1) > delay_index
        natl_resp = ...
          [ zeros(delay_index,size(natl_resp,2)); ...
            natl_resp(1:end-delay_index,:) ];
      else
        natl_resp = zeros(numel(Time),size(natl_resp,2));
      end
      if size(forc_resp,1) > delay_index
        forc_resp = ...
          [ zeros(delay_index,size(forc_resp,2)); ...
            forc_resp(1:end-delay_index,:) ];
      else
        forc_resp = zeros(numel(Time),size(forc_resp,2));
      end
    end
    
  otherwise
end
  
return


function [ R, P, D ] = ...
             local_residue( Zin, Pin, Kin, Domain )

R = [];
P = [];
D = [];
if ~ischar(Domain) || ~ismember( Domain,{'z','s'}) 
  return
end

if isequal( Domain,'s')
  integP = 0;
  integDist = 1e-10;
else
  integP = 1;
  integDist = 1e-7;
end

integP_ndx = find( abs(Pin - integP) < integDist );

if numel(integP_ndx) < 2 
  % No repeated integrator pole.
  if numel(unique(Pin)) < numel(Pin)
    % Some other repeated pole, so use Matlab's residue function.
    [ R, P, D ] = residue( Kin*poly(Zin), poly(Pin) );
  else
    % Distinct poles, compute residues directly.
    P = Pin;
    R = Kin * ones(size(P));
    for k = 1:numel(R)
      for m = 1:numel(P)
        if numel(Zin) >= m
          R(k) = R(k) * ( P(k) - Zin(m) );
        end
        if k ~= m
          R(k) = R(k) / ( P(k) - Pin(m) );
        end
      end
    end
    if numel(Zin) == numel(Pin)
      D = Kin;
    end
  end
else
  % There is a repeated integrator pole.
  % Break up the ZPK into two parts.
  P = integP*ones(size(Pin));
  R = zeros(size(Pin));
  reps = numel(integP_ndx);
  nonintegP_ndx = setdiff( (1:numel(Pin)), integP_ndx );
  %H1P = Pin(integP_ndx);
  H2P = Pin(nonintegP_ndx);
  H2Z = [];
  if numel(Zin) <= reps
    H1num = Kin*poly(Zin);
  else
    % Re-order Zin starting with real zeros, 
    % followed by complex-pairs.
    realZ_ndx = find( imag(Zin) == 0 );
    pos_imag_ndx = find( imag(Zin) > 0 );
    Zin_new = Zin(realZ_ndx);                  %#ok<FNDSB>
    for k = 1:numel(pos_imag_ndx)
      Zin_new = [ Zin_new; ...
                  Zin(pos_imag_ndx(k)); ...
                  conj(Zin(pos_imag_ndx(k))) ]; %#ok<AGROW>
    end
    Zin = Zin_new;
    realZ_ndx = find( imag(Zin) == 0 );
    pos_imag_ndx = find( imag(Zin) > 0 );
    if numel(realZ_ndx) >= reps
      H1Z_ndx = realZ_ndx(1:reps);
    else
      H1Z_ndx = [];
      for k = 1:numel(pos_imag_ndx)
        if numel(H1Z_ndx) < (reps-1)
          H1Z_ndx = ...
            [ H1Z_ndx; pos_imag_ndx(k); pos_imag_ndx(k)+1 ]; %#ok<AGROW>
        end
      end
      for k = 1:numel(realZ_ndx)
        if numel(H1Z_ndx) < reps
          H1Z_ndx = [ H1Z_ndx; realZ_ndx(k) ]; %#ok<AGROW>
        end
      end
    end
    
    H1num = Kin*poly(Zin(H1Z_ndx));
    if numel(Zin) > numel(H1Z_ndx)
      H2Z = Zin( setdiff( (1:numel(Zin)), H1Z_ndx ) );
    end
  end
  
  d_H1num = zeros(reps,reps+1);
  d_H1num(1,end+1-numel(H1num):end) = H1num;
  mult = (reps:-1:0);
  for k = 2:reps
    derv = d_H1num(k-1,:) .* mult;
    sub_derv = derv(k-1:end-1);
    d_H1num(k,end+1-numel(sub_derv):end) = sub_derv;
  end
  
  if ( numel(unique(H2P)) < numel(H2P) )
    % There are other repeated poles, so use Matlab's residue function.
    %[ H2R, H2P, H2D ] = residue( poly(H2Z), poly(H2P) );
    [ H2R, H2P ] = residue( poly(H2Z), poly(H2P) );
  elseif ~isempty(H2P)
    %H2D = [];
    H2R = ones(size(H2P));
    for k = 1:numel(H2R)
      for m = 1:numel(H2P)
        if numel(H2Z) >= m
          H2R(k) = H2R(k) * ( H2P(k) - H2Z(m) );
        end
        if k ~= m
          H2R(k) = H2R(k) / ( H2P(k) - H2P(m) );
        end
      end
    end
    %if numel(H2Z) == numel(H2P)
    %  H2D = 1;
    %end
  else
    H2R = [];
  end
  
  P(nonintegP_ndx) = H2P;
  R(nonintegP_ndx) = H2R;
  % Include H1 in the non-integrator residue computations.
  for k = 1:numel(nonintegP_ndx)
    this_ndx = nonintegP_ndx(k);
    this_pole = P(this_ndx);
    this_pole_rep_ndx = find( P(nonintegP_ndx) == this_pole );
    if numel(this_pole_rep_ndx) == 1
      R(this_ndx) = ...
        R(this_ndx) * polyval( H1num, this_pole ) ...
                    /( this_pole - integP )^reps;
    else
      R = [];
      P = [];
      D = [];
      return
    end
  end
  
  % Compute values of the H2 PFE derivatives, evaluated at integ pole.
  if ~isempty(H2R)
    d_H2 = zeros( numel(H2R), reps );
    d_H2(:,1) = H2R ./ ( integP - H2P );
    for k = 2:reps
      d_H2(:,k) = -(k-1) * d_H2(:,k-1) ./( integP - H2P );
    end
  else
    d_H2 = [];
  end
  
  %integ_res = zeros(size(H1P));
  if ~isempty(d_H2)
    for k = 1:reps
      integ_nr = reps - k;  % c_1 associated with (reps-1)-derivative.
                            % c_r associated with zeroth-derivative.
      if integ_nr == 0
        R(integP_ndx(k)) = ...
          polyval( d_H1num(1,:), integP ) * sum( d_H2(:,1) );
      elseif integ_nr == 1
        R(integP_ndx(k)) = ...
          polyval( d_H1num(2,:), integP ) * sum( d_H2(:,1) ) ...
          + polyval( d_H1num(1,:), integP ) * sum( d_H2(:,2) );
      elseif integ_nr == 2
        R(integP_ndx(k)) = ...
          (1/2)*( polyval( d_H1num(3,:), integP ) * sum( d_H2(:,1) ) ...
                 + 2 * polyval( d_H1num(2,:), integP ) * sum( d_H2(:,2) ) ...
                 + polyval( d_H1num(1,:), integP ) * sum( d_H2(:,3) ) );
      elseif integ_nr == 3
        R(integP_ndx(k)) = ...
          (1/6)*( polyval( d_H1num(4,:), integP ) * sum( d_H2(:,1) ) ...
                 + 3 * polyval( d_H1num(3,:), integP ) * sum( d_H2(:,2) ) ...
                 + 3 * polyval( d_H1num(2,:), integP ) * sum( d_H2(:,3) ) ...
                 + polyval( d_H1num(1,:), integP ) * sum( d_H2(:,4) ) );
      elseif integ_nr == 4
        R(integP_ndx(k)) = ...
          (1/24)*( polyval( d_H1num(5,:), integP ) * sum( d_H2(:,1) ) ...
                  + 4 * polyval( d_H1num(4,:), integP ) * sum( d_H2(:,2) ) ...
                  + 6 * polyval( d_H1num(3,:), integP ) * sum( d_H2(:,3) ) ...
                  + 4 * polyval( d_H1num(2,:), integP ) * sum( d_H2(:,4) ) ...
                  + polyval( d_H1num(1,:), integP ) * sum( d_H2(:,5) ) );
      else
        R(integP_ndx(k)) = 0;
        coefs = poly( -ones(integ_nr,1) );
        for m = 1:numel(coefs)
          ndx = numel(coefs)+1 - m;
          R(integP_ndx(k)) = R(integP_ndx(k)) ...
            + coefs(m) ...
              * polyval( d_H1num(ndx,:), integP ) * sum( d_H2(:,m) );
        end
        R(integP_ndx(k)) = R(integP_ndx(k)) / factorial(integ_nr);
      end
      R(integP_ndx(k)) = real(R(integP_ndx(k)));
      P(integP_ndx(k)) = integP;
    end
  else
    % All poles are integrator poles.
    [ R, P, D ] = residue( Kin*poly(Zin), poly(Pin) );
  end
  
  if numel(Pin) == numel(Zin)
    D = Kin;
  end
end

return

function [ ssMag, ssPhs ] = ...
              local_get_stdystate( ...
                 bdy_pt, ZeroLocs, PoleLocs, olGain, architec )
  
  ssMag = [];    %#ok<NASGU>
  ssPhs = [];
  
  if strcmpi( architec,'closed loop') ...
    && isequal( numel(ZeroLocs), numel(PoleLocs) )
    Gain = olGain / ( 1 + olGain );
  else
    Gain = olGain;
  end
  
  nr_bdyptZ = sum( abs(ZeroLocs-bdy_pt) < 1e-12 );
  nr_bdyptP = sum( abs(PoleLocs-bdy_pt) < 1e-12 );
  if ( nr_bdyptZ > 0 ) || ( nr_bdyptP > 0 )
    if nr_bdyptZ > nr_bdyptP
      ssMag = 0;
      return
    elseif nr_bdyptZ < nr_bdyptP
      % Find the residue of the first-order bdyptP term in the PFE.
      [ bdypt_reses, bdypt_poles ] = ...
          pzg_res( ZeroLocs, ...
                   [ PoleLocs(:); bdy_pt; conj(bdy_pt) ], Gain );
      bdypt_ndxs = find( abs( bdypt_poles - bdy_pt ) < 1e-14 );
      this_res = bdypt_reses( bdypt_ndxs(1) );
      ssMag = 2 * abs(this_res);
      ssPhs = 180/pi*angle(this_res);
      return
    else
      ZeroLocs( abs(ZeroLocs-bdy_pt) < 1e-12 ) = [];
      PoleLocs( abs(PoleLocs-bdy_pt) < 1e-12 ) = [];
    end
  end
  log_resp = log(Gain);
  for k = 1:numel(PoleLocs)
    log_resp = log_resp - log( bdy_pt - PoleLocs(k) );
    if numel(ZeroLocs) >= k
      log_resp = log_resp + log( bdy_pt - ZeroLocs(k) );
    end
  end
  ssResp = exp( log_resp );
  
  ssMag = abs(ssResp);
  ssPhs = 180*angle(ssResp)/pi;

return

function local_service_cbstr( cb_str )
  global PZG
  
  gcbf_name = get( gcbf,'name');
  if isempty( strfind( gcbf_name,'iscrete') )
    dom_ndx = 1;
  else
    dom_ndx = 2;
  end
  if isempty( strfind( gcbf_name,'losed') )
    fig_h_ndx = 8;
  else
    fig_h_ndx = 9;
  end
  SigType = ...
    get( PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.input_type_popupmenu,'value');
  
  temp0 = get( gcbf,'userdata');
  
  % Max time text is not valid for steady-state view.
  
  ss_h = PZG(dom_ndx).plot_h{fig_h_ndx}.hndl ...
         .pzgui_resppl_steadystate_only_checkbox;
  if ~isempty(ss_h) && strcmp('on',get(ss_h,'visible') ) ...
    && strcmp('on',get(ss_h,'enable') )
    line_h = PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.pzgui_resppl_resp_line;
    xdata = get( line_h,'xdata');
    temp_mintime = xdata(1);
    temp_maxtime = xdata(end);
  else
    temp_mintime = 0;
    temp_maxtime = str2double( get(temp0(2,2),'string'));
  end
  switch cb_str
    case 'mouse motion'
      pzg_ptr;
      invis_line_h = ...
        [ pzg_fndo((1:2),[3,4,6],'Nichols_CL_track_line'); ...
          pzg_fndo((1:2),[3,4,6],'Nichols_CL_track_text'); ...
          pzg_fndo((1:2),(1:14),'mm_mark_h'); ...
          pzg_fndo((1:2),(1:14),'mm_line_h'); ...
          pzg_fndo((1:2),(1:14),'mm_freq_h'); ...
          pzg_fndo((1:2),(1:14),'mm_mag_h'); ...
          pzg_fndo((1:2),(1:14),'mm_phs_h'); ...
          pzg_fndo((1:2),(1:14),'dynamic_gain_marker'); ...
          pzg_fndo((1:2),(1:14),'damping_natural_freq_text'); ...
          pzg_fndo((1:2),(1:14),'parameter_K_effect_line') ];
      if ~isempty(invis_line_h)
        set( invis_line_h(ishandle(invis_line_h)),'visible','off');
      end
      CurrPt = get( temp0(1,1),'currentpoint');
      CurrPt = CurrPt(1,1:2);
      x_lim = PZG(dom_ndx).plot_h{fig_h_ndx}.xlim;
      y_lim = PZG(dom_ndx).plot_h{fig_h_ndx}.ylim;
      input_cursor_h = pzg_fndo( dom_ndx, fig_h_ndx,'input_cursor');
      resp_cursor_h = pzg_fndo( dom_ndx, fig_h_ndx,'resp_cursor');
      error_cursor_h = pzg_fndo( dom_ndx, fig_h_ndx,'error_cursor');
      if ( CurrPt(1) < x_lim(1) ) || ( CurrPt(1) > x_lim(2) ) ...
        ||( CurrPt(2) < y_lim(1) ) || ( CurrPt(2) > y_lim(2) )
        if ~isempty( input_cursor_h )
          set( input_cursor_h,'visible','off');
        end
        if ~isempty( resp_cursor_h )
          set( resp_cursor_h,'visible','off');
        end
        if ~isempty( error_cursor_h )
          set( error_cursor_h,'visible','off');
        end
        return
      end
      x_pt = CurrPt(1);
      y_pt = CurrPt(2);
      input_line_h = ...
        PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.pzgui_resppl_input_line;
      input_ydata = get( input_line_h,'ydata');
      resp_line_h = PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.pzgui_resppl_resp_line;
      resp_ydata = get( resp_line_h,'ydata');
      err_line_h = PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.pzgui_resppl_error_line;
      if isempty(err_line_h) || strcmp('off', get( err_line_h,'visible') )
        error_vis = 'off';
      else
        error_vis = 'on';
      end
      
      x_data = get( resp_line_h,'xdata');
      [ temp, x_ndx ] = min( abs( x_data - x_pt ) ); %#ok<ASGLU>
      x_val = x_data(x_ndx);
      input_y_val = input_ydata(x_ndx);
      resp_y_val = resp_ydata(x_ndx);
      max_val = max( abs(input_y_val), abs(resp_y_val) );
      if max_val == 0
        error_y_val = 0;
      elseif abs(input_y_val-resp_y_val) < 1e-14*max_val
        error_y_val = 0;
      else
        error_y_val = input_y_val - resp_y_val;
      end
      
      if x_val < x_lim(1)+0.5*diff(x_lim)
        str_xpos = min( x_val+0.02*diff(x_lim), x_lim(2)-0.3*diff(x_lim) );
      else
        str_xpos = max( x_val-0.5*diff(x_lim), x_lim(1)+0.03*diff(x_lim) );
      end
      if strcmpi( error_vis,'on')
        if y_pt > y_lim(1)+0.5*diff(y_lim)
          respstr_ypos = ...
            max( [ resp_y_val;input_y_val;error_y_val;y_pt] ) + 0.1*diff(y_lim);
          respstr_ypos = ...
            min( respstr_ypos, y_lim(2)-0.1*diff(y_lim) );
        else
          respstr_ypos = ...
            min( [ resp_y_val;input_y_val;error_y_val;y_pt] ) - 0.1*diff(y_lim);
          respstr_ypos = ...
            max( respstr_ypos, y_lim(1)+0.02*diff(y_lim) );
        end
        if ( min( [input_y_val;resp_y_val;error_y_val] ) ...
             > x_lim(1)+0.3*diff(x_lim) ) ...
          && ( y_pt < min( [input_y_val;resp_y_val;error_y_val] ) ) ...
          && ( respstr_ypos+0.15 > min( [input_y_val;resp_y_val;error_y_val] ) )
          respstr_ypos = ...
            min( y_pt-0.20*diff(y_lim), y_lim(1)+0.03*diff(y_lim) );
        end
      else
        if y_pt > y_lim(1)+0.5*diff(y_lim)
          respstr_ypos = ...
            max( [ resp_y_val;input_y_val;y_pt] ) + 0.1*diff(y_lim);
          respstr_ypos = ...
            min( respstr_ypos, y_lim(2)-0.1*diff(y_lim) );
        else
          respstr_ypos = ...
            min( [ resp_y_val;input_y_val;y_pt] ) - 0.1*diff(y_lim);
          respstr_ypos = ...
            max( respstr_ypos, y_lim(1)+0.02*diff(y_lim) );
        end
        if ( min( [input_y_val;resp_y_val;error_y_val] ) ...
             > x_lim(1)+0.3*diff(x_lim) ) ...
          && ( y_pt < min( [input_y_val;resp_y_val;error_y_val] ) ) ...
          && ( respstr_ypos+0.15 > min( [input_y_val;resp_y_val;error_y_val] ) )
          respstr_ypos = ...
            min( y_pt-0.20*diff(y_lim), y_lim(1)+0.03*diff(y_lim) );
        end
      end
      input_type = ...
        get( PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.input_type_popupmenu,'value');
      bg_color = get( PZG(dom_ndx).plot_h{fig_h_ndx}.ax_h,'color');
      if max(bg_color) < 0.5
        time_color = '{0.9 0.9 0.9}';
      else
        time_color = '{0.1 0.1 0.1}';
      end
      
      if input_type > 1
        if error_y_val == 0
          resp_str = ...
            { ['\color[rgb]' time_color 't= ' pzg_efmt( x_val, 4 ) ]; ...
              ['\color[rgb]{0 0.7 0}x= ' pzg_efmt( input_y_val, 4 ) ]; ...
              ['\color[rgb]{1 0 0}y= ' pzg_efmt( resp_y_val, 4 ) ]; ...
              '\color[rgb]{0 0.7 0.7}x-y= 0' };
        else
          resp_str = ...
            { ['\color[rgb]' time_color 't= ' pzg_efmt( x_val, 4 ) ]; ...
              ['\color[rgb]{0 0.7 0}x= ' pzg_efmt( input_y_val, 4 ) ]; ...
              ['\color[rgb]{1 0 0}y= ' pzg_efmt( resp_y_val, 4 ) ]; ...
              ['\color[rgb]{0 0.7 0.7}x-y= ' pzg_efmt( error_y_val, 4 )] };
        end
        if ( input_type ==3 ) || ( input_type == 4 )
          respstr_ypos = y_lim(2) - 0.2*diff(y_lim);
          str_xpos = x_lim(1);
        end
        if isempty(input_cursor_h) || ~isequal( 1, numel(input_cursor_h) )
          delete(input_cursor_h)
          input_cursor_h = ...
            plot( str_xpos, resp_y_val, ...
              'color',[0 0.8 0], ...
              'linestyle','none', ...
              'linewidth', 2, ...
              'marker','+', ...
              'markersize', 16, ...
              'parent', PZG(dom_ndx).plot_h{fig_h_ndx}.ax_h, ...
              'tag','resppl input line cursor');
          PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.input_cursor = input_cursor_h;
        else
          set( input_cursor_h(1), ...
            'xdata', x_val, ...
            'ydata', input_y_val, ...
            'visible','on')
        end        
      else
        if ~isempty(input_cursor_h)
          set( input_cursor_h,'visible','off')
        end
        if isequal( input_type, 1 )
          if dom_ndx == 1
            resp_str = ...
              {['\color[rgb]' time_color 'y = L^-^1(H) = h']; ...
               ['\color[rgb]' time_color 't= ' pzg_efmt( x_val, 4 ) ]; ...
               ['\color[rgb]{1 0 0}h= ' pzg_efmt( resp_y_val, 4 ) ] };
          else
            resp_str = ...
              {['\color[rgb]' time_color 'y = Z^-^1(H) = h']; ...
               ['\color[rgb]' time_color 'kT= ' pzg_efmt( x_val, 4 ) ]; ...
               ['\color[rgb]{1 0 0}h= ' pzg_efmt( resp_y_val, 4 ) ] };
          end
        else
          resp_str = ...
            { ['\color[rgb]' time_color 't= ' pzg_efmt( x_val, 4 ) ]; ...
              ['\color[rgb]{1 0 0}y= ' pzg_efmt( resp_y_val, 4 ) ]; ...
              ['\color[rgb]{0 0.7 0.7}x-y= ' pzg_efmt( error_y_val, 4 )] };
        end
      end
      if ( respstr_ypos < resp_y_val ) && isequal( input_type, 1 )
        if resp_y_val < y_lim(1)+0.2*diff(y_lim)
          respstr_ypos = y_lim(1) + 0.4*diff(y_lim);
        end
      end
      if isempty(resp_cursor_h) || ~isequal( 2, numel(resp_cursor_h) )
        delete(resp_cursor_h)
        resp_cursor_h = ...
          plot( x_val, resp_y_val, ...
            'color',[1 0 0], ...
            'linestyle','none', ...
            'linewidth', 2, ...
            'marker','+', ...
            'markersize', 16, ...
            'parent', PZG(dom_ndx).plot_h{fig_h_ndx}.ax_h, ...
            'tag','resppl resp line cursor');
        resp_cursor_h(end+1) = ...
          text( str_xpos+0.04*diff(x_lim), respstr_ypos, resp_str, ...
            'fontsize', 10, ...
            'fontweight','bold', ...
            'backgroundcolor', ...
              get(PZG(dom_ndx).plot_h{fig_h_ndx}.fig_h,'color'), ...
            'parent', PZG(dom_ndx).plot_h{fig_h_ndx}.ax_h, ...
            'tag','resppl resp line cursor');
        PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.resp_cursor = resp_cursor_h;
      else
        set( resp_cursor_h(1), ...
          'xdata', x_val, ...
          'ydata', resp_y_val, ...
          'visible','on')
        set( resp_cursor_h(2), ...
            'position',[ str_xpos+0.04*diff(x_lim), respstr_ypos, 0 ], ...
            'string', resp_str, ...
            'backgroundcolor', ...
              get(PZG(dom_ndx).plot_h{fig_h_ndx}.fig_h,'color'), ...
            'visible','on')
      end
      
      if isempty(error_cursor_h) || ~isequal( 1, numel(error_cursor_h) )
        error_cursor_h = ...
          plot( x_val, input_y_val-resp_y_val, ...
            'color',[0 0.7 0.7], ...
            'linestyle','none', ...
            'linewidth', 2, ...
            'marker','+', ...
            'markersize', 16, ...
            'parent', PZG(dom_ndx).plot_h{fig_h_ndx}.ax_h, ...
            'visible', error_vis, ...
            'tag','resppl error line cursor');
        PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.error_cursor = error_cursor_h;
      else
        set( error_cursor_h, ...
          'xdata', x_val, ...
          'ydata', input_y_val-resp_y_val, ...
          'visible', error_vis )
      end
        
      
    case 'resppl wbdf'
      CurrPt = get( temp0(1,1),'currentpoint');
      CurrPt = CurrPt(1,1:2);
      if strcmpi( get(gcbf,'selectiontype'),'normal')
        temp_xlim = get( temp0(1,1),'xlim');
        temp_ylim = get( temp0(1,1),'ylim');
        finalRect = rbbox;      %#ok<NASGU>
        FinalPt = get( temp0(1,1),'currentpoint');
        FinalPt = FinalPt(1,1:2);
        if ( abs(FinalPt(1)-CurrPt(1)) < diff(temp_xlim)/100 ) ...
          &&( abs(FinalPt(2)-CurrPt(2)) < diff(temp_ylim)/100 )
          if ( CurrPt(1) < temp_xlim(1) ) ...
            ||( CurrPt(1) > temp_xlim(2) ) ...
            ||( CurrPt(2) < temp_ylim(1) ) ...
            ||( CurrPt(2) > temp_ylim(2) )
            pzg_ptr
            return
          end
          % Zoom in around the current point.
          temp_xlim(1) = max( 0, CurrPt(1) - 0.33*diff(temp_xlim) );
          temp_xlim(2) = ...
            min( temp_maxtime, CurrPt(1) + 0.33*diff(temp_xlim) );
          temp_ylim(1) = CurrPt(2) - 0.33*diff(temp_ylim);
          temp_ylim(2) = CurrPt(2) + 0.33*diff(temp_ylim);
          if ( numel(temp_xlim) == 2 ) ...
            && ( numel(temp_ylim) == 2 ) ...
            && ~any(isnan(temp_xlim)) ...
            && ~any(isnan(temp_ylim)) ...
            && ~any(isinf(temp_xlim)) ...
            && ~any(isinf(temp_ylim)) ...
            &&( temp_xlim(2) > temp_xlim(1) ) ...
            &&( temp_ylim(2) > temp_ylim(1) )
            set( temp0(1,1),'xlim', temp_xlim,'ylim', temp_ylim );
            PZG(dom_ndx).plot_h{fig_h_ndx}.xlim = temp_xlim;
            PZG(dom_ndx).plot_h{fig_h_ndx}.ylim = temp_ylim;
            PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_xlim = temp_xlim;
            PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_ylim = temp_ylim;
            if isappdata(gcbf,'hndl')
              temp_hndl = getappdata(gcbf,'hndl');
              temp_hndl.ax_xlim = temp_xlim;
              temp_hndl.ax_ylim = temp_ylim;
              setappdata(gcbf,'hndl', temp_hndl );
            end
          end
          pzg_ptr;
          return
        else
          % User has dragged a zoom box.
          box_xlim = sort( [ CurrPt(1) FinalPt(1) ] );
          box_xlim(1) = max( box_xlim(1), temp_mintime );
          box_xlim(2) = min( box_xlim(2), temp_maxtime );
          box_ylim = sort( [ CurrPt(2) FinalPt(2) ] );
          % FinalPt(1) = max( 0, min( FinalPt(1), temp_maxtime ) );
          % temp_xlim = get( temp0(1,1),'xlim');
          % new_xlim = sort( [CurrPt(1) FinalPt(1)] );
          % if diff(new_xlim) == 0
          %   new_xlim = new_xlim + [-1 1]*max( 1e-15, diff(temp_xlim)/100 );
          % end
          % new_ylim = sort( [CurrPt(2) FinalPt(2)] );
          % if diff(new_ylim) == 0
          %   new_ylim = new_ylim + [-1 1]*diff(temp_ylim)/100;
          % end
          new_xlim = box_xlim;
          new_ylim = box_ylim;
          if all( ~isnan(new_xlim) ) && all( ~isnan(new_ylim) ) ...
            && ( diff(new_xlim) > 1e-8 ) && ( diff(new_ylim) > 1e-8 )
            set( temp0(1,1),'xlim', new_xlim,'ylim', new_ylim );
            PZG(dom_ndx).plot_h{fig_h_ndx}.xlim = new_xlim;
            PZG(dom_ndx).plot_h{fig_h_ndx}.ylim = new_ylim;
            PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_xlim = new_xlim;
            PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_ylim = new_ylim;
            if isappdata(gcbf,'hndl')
              temp_hndl = getappdata(gcbf,'hndl');
              temp_hndl.ax_xlim = new_xlim;
              temp_hndl.ax_ylim = new_ylim;
              setappdata(gcbf,'hndl', temp_hndl );
            end
          end
          pzg_ptr;
          return
        end

      elseif strcmpi( get(gcbf,'selectiontype'),'alt')
        % Zoom out.
        temp_xlim = get(temp0(1,1),'xlim');
        temp_ylim = get(temp0(1,1),'ylim');
        if ( CurrPt(1) < temp_xlim(1) ) ...
          ||( CurrPt(1) > temp_xlim(2) ) ...
          ||( CurrPt(2) < temp_ylim(1) ) ...
          ||( CurrPt(2) > temp_ylim(2) )
          pzg_ptr
          return
        end
        temp_xlim(1) = max( 0, CurrPt(1) - 0.75*diff(temp_xlim) );
        temp_xlim(2) = ...
          min( temp_maxtime, CurrPt(1) + 0.75*diff(temp_xlim) );
        set( temp0(1,1),'xlim', temp_xlim );
        if ~strcmpi( get(temp0(1,1),'ylimmode'),'auto')
          temp_ylim(1) = CurrPt(2) - 0.75*diff(temp_ylim);
          temp_ylim(2) = CurrPt(2) + 0.75*diff(temp_ylim);
          set( temp0(1,1),'ylim', temp_ylim );
        end
        PZG(dom_ndx).plot_h{fig_h_ndx}.xlim = temp_xlim;
        PZG(dom_ndx).plot_h{fig_h_ndx}.ylim = temp_ylim;
        PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_xlim = temp_xlim;
        PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_ylim = temp_ylim;
        if isappdata(gcbf,'hndl')
          temp_hndl = getappdata(gcbf,'hndl');
          temp_hndl.ax_xlim = temp_xlim;
          temp_hndl.ax_ylim = temp_ylim;
          setappdata(gcbf,'hndl', temp_hndl );
        end
        pzg_ptr;
        return
        
      elseif strcmp( get(gcbf,'selectiontype'),'open')
        temp_xlim = get(temp0(1,1),'xlim');
        temp_ylim = get(temp0(1,1),'ylim');
        if ( CurrPt(1) < temp_xlim(1) ) ...
          ||( CurrPt(1) > temp_xlim(2) ) ...
          ||( CurrPt(2) < temp_ylim(1) ) ...
          ||( CurrPt(2) > temp_ylim(2) )
          pzg_ptr
          return
        end
        % If steady-state is selected, only zoom out to that part.
        ss_h = ...
         pzg_fndo( dom_ndx, fig_h_ndx,'pzgui_resppl_steadystate_only_checkbox');
        if isempty(ss_h)
          ss_h = findobj( gcbf,'string','stdy-state');
        end
        inputmenu_h = pzg_fndo( dom_ndx, fig_h_ndx,'input_type_popupmenu');
        if isempty(inputmenu_h)
          inputmenu_h = findobj( gcbf,'tag','input-type popupmenu');
        end
        if ~isempty(ss_h) ...
          && isequal( 1, get(ss_h,'value') ) ...
          && isequal( 5, get(inputmenu_h,'value') )
          line_h = pzg_fndo( dom_ndx, fig_h_ndx,'pzgui_resppl_resp_line');
          if isempty(line_h)
            line_h = findobj( temp0(1,1),'type','line', ...
                             'tag','pzgui resppl resp line');
          end
          if ~isempty(line_h)
            x_data = get( line_h(1),'xdata');
            y_data = get( line_h(1),'ydata');
            temp_xlim = [x_data(1), x_data(end)];
            temp_ylim = [1.05*min(-1,min(y_data)), 1.7*max(1,max(y_data))];
            if ( SigType == 2 ) && ( temp_ylim(2) < 1.1 )
              temp_ylim(2) = 1.1;
              set( temp0(1,1),'ylim', temp_ylim );
            end
            if ( temp_ylim(2) > 0 )
              temp_ylim(1) = min( temp_ylim(1), -temp_ylim(2)/20 );
            end
            set( temp0(1,1),'xlim', temp_xlim,'ylim', temp_ylim );
          else
            set( temp0(1,1),'xlim',[0 temp_maxtime ],'ylimmode','auto');
            temp_xlim = [0 temp_maxtime ];
            temp_ylim = get( temp0(1,1),'ylim');
          end
          PZG(dom_ndx).plot_h{fig_h_ndx}.xlim = temp_xlim;
          PZG(dom_ndx).plot_h{fig_h_ndx}.ylim = temp_ylim;
          PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_xlim = temp_xlim;
          PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_ylim = temp_ylim;
          if isappdata(gcbf,'hndl')
            temp_hndl = getappdata(gcbf,'hndl');
            temp_hndl.ax_xlim = temp_xlim;
            temp_hndl.ax_ylim = temp_ylim;
            setappdata(gcbf,'hndl', temp_hndl );
          end
        else
          temp_xlim = [0 temp_maxtime ];
          set( temp0(1,1),'xlim', temp_xlim,'ylimmode','auto');
          temp_ylim = get(temp0(1,1),'ylim');
          if ( SigType == 2 ) && ( temp_ylim(2) < 1.1 )
            temp_ylim(2) = 1.1;
            set( temp0(1,1),'ylim', temp_ylim );
          end
          if temp_ylim(2) > 0 
            temp_ylim(1) = min( temp_ylim(1), -temp_ylim(2)/20 );
            set( temp0(1,1),'ylim', temp_ylim );
          end
          PZG(dom_ndx).plot_h{fig_h_ndx}.xlim = temp_xlim;
          PZG(dom_ndx).plot_h{fig_h_ndx}.ylim = temp_ylim;
          PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_xlim = temp_xlim;
          PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_ylim = temp_ylim;
          if isappdata(gcbf,'hndl')
            temp_hndl = getappdata(gcbf,'hndl');
            temp_hndl.ax_xlim = temp_xlim;
            temp_hndl.ax_ylim = temp_ylim;
            setappdata(gcbf,'hndl', temp_hndl );
          end
        end
        pzg_ptr;
        return
      end
      
      temp_xlim = get(temp0(1,1),'xlim');
      temp_lineh = PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.pzgui_resppl_resp_line;
      if isempty(temp_lineh)
        temp_lineh = ...
          findobj( temp0(1,1),'type','line','tag','pzgui resppl resp line');
      end
      if ~isempty(temp_lineh)
        temp_xdata = get( temp_lineh(1),'xdata');
        temp_xlim = [ max(temp_xdata(1), temp_xlim(1)), ...
                      min(temp_xdata(end), temp_xlim(2)) ];
        set( temp0(1,1),'xlim', temp_xlim );
        temp_ylim = get( temp0(1,1),'ylim');
        PZG(dom_ndx).plot_h{fig_h_ndx}.xlim = temp_xlim;
        PZG(dom_ndx).plot_h{fig_h_ndx}.ylim = temp_ylim;
        PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_xlim = temp_xlim;
        PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_ylim = temp_ylim;
        if isappdata(gcbf,'hndl')
          temp_hndl = getappdata(gcbf,'hndl');
          temp_hndl.ax_xlim = temp_xlim;
          temp_hndl.ax_ylim = temp_ylim;
          setappdata(gcbf,'hndl', temp_hndl );
        end
      end
      pzg_ptr;
      
    case 'resppl wbdf reset'
      temp_lineh = findobj( temp0(1,1),'tag','pzgui resppl resp line');
      if ~isempty(temp_lineh)
        x_data = get(temp_lineh(1),'xdata');
        set( temp0(1,1),'ylimmode','auto','xlim',[x_data(1),x_data(end)]);
      else
        set( temp0(1,1),'xlimmode','auto','ylimmode','auto');
      end
      temp_xlim = get( temp0(1,1),'xlim');
      temp_ylim = get( temp0(1,1),'ylim');
      PZG(dom_ndx).plot_h{fig_h_ndx}.xlim = temp_xlim;
      PZG(dom_ndx).plot_h{fig_h_ndx}.ylim = temp_ylim;
      PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_xlim = temp_xlim;
      PZG(dom_ndx).plot_h{fig_h_ndx}.hndl.ax_ylim = temp_ylim;
      if isappdata(gcbf,'hndl')
        temp_hndl = getappdata(gcbf,'hndl');
        temp_hndl.ax_xlim = temp_xlim;
        temp_hndl.ax_ylim = temp_ylim;
        setappdata(gcbf,'hndl', temp_hndl );
      end
    otherwise
  end  
return

function [ tr_ypos, os_ypos, tp_ypos, us_ypos, ts_ypos, ss_ypos ] = ...
            local_get_text_ypos( Ydata, OSNdx, USNdx )
  tr_ypos = [];
  os_ypos = [];
  tp_ypos = [];
  us_ypos = [];
  ts_ypos = [];
  ss_ypos = [];
  
  if nargin < 3
    return
  end
  full_range = max(Ydata) - min(Ydata);
  ss_value = Ydata(end);
  
  % Rise-time text y-position:
  tr_ypos = max( 0.15, 0.45*ss_value );
  
  % Overshoot text y-positions:
  if isempty(OSNdx)
    peak_value = max(Ydata);
  else
    peak_value = Ydata(OSNdx);
    if peak_value > 1.6
      os_ypos = max( 0.95*peak_value, 1.10*ss_value );
    elseif peak_value > 1
      os_ypos = max( peak_value, 1.10*ss_value );
    elseif peak_value < 0.9
      os_ypos = peak_value + 0.5*(1-peak_value);
    else
      os_ypos = 1.01;
    end
    os_ypos = max( os_ypos, 0.8 );
    if os_ypos > 1
      tp_ypos = os_ypos - max( 0.12, 0.12*full_range );
    else
      tp_ypos = os_ypos - 0.12;
    end
  end
  
  % Undershoot text y-positions:
  if ~isempty(USNdx)
    undershoot_value = Ydata(USNdx);
    if undershoot_value > 0.12
      us_ypos = 0.9*undershoot_value;
    elseif undershoot_value > 0
      us_ypos = 0.01;
    else
      us_ypos = 1.1*undershoot_value;
    end
  end
  
  % Settling-time and steady-state text positions:
  if peak_value > 1.6
    ts_ypos = max(1,ss_value) + 0.3*(peak_value-1);
    ss_ypos = max(1,ss_value) + 0.15*(peak_value-1);
  else
    ts_ypos = 0.4*ss_value;
    if ss_value < 0.35
      ts_ypos = 0.46;
    end
    ss_ypos = ts_ypos - 0.12*max( max(1,ss_value), full_range );
  end
  
  if ts_ypos < ss_value
    tr_ypos = max( tr_ypos, ts_ypos+0.1 );
  end
  
  if ~isempty(us_ypos) && ( abs(tr_ypos-us_ypos) < 0.12*full_range )
    tr_ypos = us_ypos + 0.12*full_range;
  end
  
return





function  FigHndl = sensplot( BodeFreqs, CLBodeMag, CLBodePhs, ...
                              PlotName, FrqSelNdx, PlotTitle, ...
                              Position, BtnDwnFn, Domain )
% Creates and services the PZGUI output-sensitivity plots.

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

% Check that the input arguments are valid:
if ( nargin < 4 ) || ( nargin > 9 )
  disp('SENSPLOT:  Incorrect call format.');
  return
end

if nargin < 9
  Domain = 's';
end
if ~strcmp( Domain,'s') && ~strcmp( Domain,'z')
  disp('9-th input argument, DOMAIN must be either ''z'' or ''s''.');
  return
end

if nargin < 8
  BtnDwnFn = ...
    ['try,tempfs=freqserv(gcbf,1);pzg_ptr;' ...
     'catch,pzg_err(''button down'');' ...
     'end,clear tempfs;'];
end
if ( ~ischar(BtnDwnFn) ) || ( min(size(BtnDwnFn) > 1 ) )
  disp('8-th input argument, BTNDWNFN must be a simple string.');
  return
end

if nargin < 7
  Position = [];
end
if sum( ( ( size(Position) ~= [1 4] ) | ischar(Position) ) ...
       &( size(Position) ~= [0 0] ) ) > 0
  disp('7-th input arg, POSITION must be a 1-by-4 numerical array.');
  return
end

if nargin < 6
  PlotTitle = '';
end
if ( ~ischar(PlotTitle) ) || ( min(size(PlotTitle) > 1 ) )
  disp('Sixth input argument, PLOTTITLE must be a simple string.');
  return
end
  
if nargin < 5
  FrqSelNdx = [];
end
if numel(FrqSelNdx) > 1
  disp('Fifth input argument, FRQSELNDX must be a scalar.')
  return
end
if numel(FrqSelNdx) == 1
  if ( FrqSelNdx > 0 ) && ( FrqSelNdx <= numel(BodeFreqs) )
    tempNdx = FrqSelNdx;
    tempVis = 'on';
  else
    tempNdx = 1;
    tempVis = 'off';
  end
else
  tempNdx = 1;
  tempVis = 'off';
end

if ( ~ischar(PlotName) ) 
  disp('Fourth input argument, PLOTNAME must be a simple string.');
  return
end
if ( min(size(PlotName))~=1 )
  disp('Fourth input argument, PLOTNAME cannot be an empty string.');
  return
end
if nargin < 9
  if isempty( strfind( lower(PlotName),'discrete') )
    dom_ndx = 1;
  else
    dom_ndx = 2;
  end
elseif strcmpi( Domain,'s')
  dom_ndx = 1;
else
  dom_ndx = 2;
end
if ~PZG(dom_ndx).pzg_show_frf_computation
  tempVis = 'off';
end

if isempty(BodeFreqs) && isempty(CLBodeMag) && isempty(CLBodePhs)
  % Determine if the closed-loop is unstable.
  if ~isempty(PZG(dom_ndx).CLPoleLocs) ...
    &&( ( ( dom_ndx == 1 ) ...
         && any( real(PZG(1).CLPoleLocs) >= 0 ) ) ...
       ||( ( dom_ndx == 2 ) ...
         && any( abs(PZG(2).CLPoleLocs) >= 1 ) ) )
    % Closed-loop is unstable.
    errdlg_h = ...
      errordlg( ...
        {'The closed-loop system is unstable,'; ...
         'so any output sensitivity plot is meaningless.'; ...
         ' ';'    Click "OK" to continue ...';' '}, ...
        'UNSTABLE Closed-Loop system.','modal');
    uiwait(errdlg_h)
    return
  end
end

if ischar(BodeFreqs) || ischar(CLBodeMag) || ischar(CLBodePhs)
  disp('Bode plot data cannot be string data.');
  return
end
if ( numel(BodeFreqs) ~= numel(CLBodeMag) ) ...
  || ( numel(BodeFreqs) ~= numel(CLBodePhs) )
  disp('SENSPLOT.M Error:');
  disp('   Arguments BODEFREQS, BODEMAG, and BODEPHS ');
  disp('   must all be the same length.');
  return
end
if ( min(size(BodeFreqs)) > 1 ) ...
  || ( min(size(CLBodeMag)) > 1 ) ...
  || ( min(size(CLBodePhs)) > 1 )
  disp('SENSPLOT.M Error:');
  disp('   Arguments BODEFREQS, CLBODEMAG, and CLBODEPHS ');
  disp('   must column or row vectors.');
  return
end

% ----------------------------------------------------------------------

HZchk = pzg_ishzx;
if HZchk
  FreqDiv = 2*pi;
else
  FreqDiv = 1;
end

LogScaling = pzg_islogx;

CplxCLBode = 10.^(CLBodeMag/20) .* exp(1i*pi/180*CLBodePhs);
SensDB = 20*log10( abs( 1 - CplxCLBode ) );
if numel(SensDB) > 2
  LogSens = ( SensDB(1:end-1)+SensDB(2:end) )/2 * (log(10)/20);
else
  LogSens = [];
end

if ( BodeFreqs(1) > 0 ) && ( numel(BodeFreqs) > 1 )
  XLimit = [ BodeFreqs(1) BodeFreqs(end) ]/FreqDiv;
elseif numel(BodeFreqs) > 1
  XLimit = [ BodeFreqs(2) BodeFreqs(end) ]/FreqDiv;
else
  if strcmp( Domain,'s')
    XLimit = [ PZG(1).BodeFreqs(2) PZG(1).BodeFreqs(end) ]/FreqDiv;
  else
    XLimit = [ PZG(2).BodeFreqs(2) PZG(2).BodeFreqs(end) ]/FreqDiv;
  end
end
if numel( SensDB ) > 1
  YLimit = [ min( SensDB ) max( SensDB ) ];
else
  YLimit = [ -20 20 ];
end

if dom_ndx == 2
  negfreq_ndxs = ...
    find( ...
      ( ( BodeFreqs > pi/PZG(2).Ts ) ...
       &( BodeFreqs < 2*pi/PZG(2).Ts ) ) ...
      |( ( BodeFreqs > 3*pi/PZG(2).Ts ) ...
       &( BodeFreqs < 4*pi/PZG(2).Ts ) ) );
else
  negfreq_ndxs = [];
end

FigHndl = [];
cand_figs = pzg_fndo( (1:2), 5,'fig_h');
if ~isempty(cand_figs)
  FigHndl = findobj( cand_figs,'Name', PlotName );
end
if isempty(FigHndl)
  FigHndl = findobj( allchild(0),'Name', PlotName );
end

temp0 = [];
if ~isempty(FigHndl)
  if isappdata( FigHndl,'hndl')
    hndl = getappdata( FigHndl,'hndl');
  else
    hndl = [];
  end
  temp0 = get( FigHndl,'UserData');
  
  if isfield( hndl,'ax') ...
    && isfield( hndl,'ax_xlim') ...
    && isfield( hndl,'ax_ylim')
    XLimit = hndl.ax_xlim;
    YLimit = hndl.ax_ylim;
  else
    if numel(SensDB) < 2
      tempG = get( FigHndl,'CurrentAxes');
      if ~isempty(tempG)
        XLimit = get( tempG,'XLim');
        YLimit = get( tempG,'YLim');
      end
    end
  end
end

exist_xlim = [];

is_new_figure = 0;
if isempty(temp0)
  % Sensitivity plot doesn't exist yet, so create it.
  temp0 = zeros([10 2]);
  del_str = ...
    ['global PZG,' ...
     'try,' ...
       'temp_senscb=' ...
         'pzg_fndo(' num2str(dom_ndx) ',' num2str(11+dom_ndx) ',' ...
                   '''Sensitivity_checkbox'');' ...
       'if ~isempty(temp_senscb),' ...
         'set(temp_senscb,''value'',0);' ...
       'end,' ...
       'PZG(' num2str(dom_ndx) ').plot_h{5}=[];' ...
     'end,' ...
     'pzg_bkup,' ...
     'clear temp_senscb;'];
          
  FigHndl = ...
    figure('menubar','figure', ...
       'numbertitle','off', ...
       'integerhandle','off', ...
       'handlevisibility','callback', ...
       'dockcontrols','off', ...
       'tag','PZGUI plot', ...
       'visible','off', ...
       'windowbuttonmotionfcn', ...
         ['try,' ...
          'if pzg_disab,return,end,' ...
          'tempfs=freqserv(gcbf);pzg_ptr;' ...
          'catch,pzg_err(''mouse motion sens'');' ...
          'end,clear tempfs;'], ...
       'WindowButtonDownFcn', BtnDwnFn, ...
       'deletefcn', del_str );
  is_new_figure = 1;

  % Put a "Color Options" menu item in the figure's menubar.
  opt_menu_h = ...
    uimenu('parent', FigHndl, ...
           'label', 'PZGUI OPTIONS', ...
           'tag','pzgui_options_menu');
  pzg_menu( opt_menu_h, Domain );
  hndl = getappdata( FigHndl,'hndl');
  
  hndl.plot_name = get( FigHndl,'name');
  hndl.dom_ndx = dom_ndx;
  hndl.ploth_ndx = 5;
  
  gca0 = axes('parent',FigHndl, ...
              'ygrid','on', ...
              'xgrid','on', ...
              'nextplot','add', ...
              'tag','pzg sensitivity plot axes');
  temp0(1,1) = gca0;
  hndl.ax = gca0;
  hndl.ax_title = get(gca0,'title');
  hndl.ax_xlabel = get(gca0,'xlabel');
  hndl.ax_ylabel = get(gca0,'ylabel');
  temp0(6,1) = hndl.ax_xlabel;

  if isempty(Position)
    set( FigHndl, ...
        'units','normalized', ...
        'Name', PlotName, ...
        'Color','k', ...
        'Interruptible','On');
  else
    if max(Position) > 1
      ScrSize = get(0,'screensize');
      Position([1;3]) = Position([1;3])/ScrSize(3);
      Position([2;4]) = Position([2;4])/ScrSize(4);
    end
  set( FigHndl, ...
        'units','normalized', ...
        'position', Position, ...
        'name',PlotName, ...
        'color','k', ...
        'interruptible','On');
  end
 
  tempH = pzg_fndo( dom_ndx, 5,'BodeHZChkbox');
  if isempty(tempH)
    temp0(8,1) = uicontrol(FigHndl,'Style','checkbox', ...
      'Value', HZchk, ...
      'String','Hz', ...
      'Units','normalized', ...
      'Position',[0.005 0.005 0.100 0.050], ...
      'HorizontalAlignment','Left', ...
      'BackgroundColor', get(FigHndl,'color'), ...
      'ForegroundColor', 1-get(FigHndl,'color'), ...
      'UserData',BodeFreqs, ...
      'Tag','BodeHZChkbox', ...
      'tooltipstring','x-axis in hertz, instead of rad/second', ...
      'Visible','On', ...
      'Callback', ...
        ['try,pzgcalbk(gcbo,''Hz checkbox'');' ...
         'catch,pzg_err(''Hz checkbox'');' ...
         'end']);    
    if HZchk
      set( hndl.ax_xlabel,'string','Frequency (hertz)')
    else
      set( hndl.ax_xlabel,'string','Frequency (rad/s)')
    end
  else
    temp0(8,1) = tempH(1);
  end
  hndl.BodeHZChkbox = temp0(8,1);

  tempH = pzg_fndo( dom_ndx, 5,'BodeAxesLinLogChkbox');
  if isempty(tempH)
    hndl.BodeAxesLinLogChkbox = ...
      uicontrol(FigHndl,'Style','checkbox', ...
        'Value', LogScaling, ...
        'String','Log', ...
        'Units','normalized', ...
        'Position',[0.115 0.005 0.120 0.050], ...
        'HorizontalAlignment','Right', ...
        'BackgroundColor',get(FigHndl,'color'), ...
        'ForegroundColor', 1-get(FigHndl,'color'), ...
        'Tag','BodeAxesLinLogChkbox', ...
        'tooltipstring','x-axis log-scaled, instead of linear', ...
        'Visible','On', ...
        'Callback', ...
          ['try,pzgcalbk(gcbo,''Log checkbox'');' ...
           'catch,pzg_err(''Log checkbox'');' ...
           'end']);
  else
    hndl.BodeAxesLinLogChkbox = tempH;
  end
  
  % Sensitivity plot is ALWAYS in dB.
  temp0(2,2) = ...
    plot( BodeFreqs([1,end])/FreqDiv, [0 0], ...
         'color',[0 0.7 0.7], ...
         'linestyle','--', ...
         'LineWidth', 0.5, ...
         'Tag','unity gain line', ...
         'parent', gca0 );
  hndl.unity_gain_line = temp0(2,2);
  
  set( gca0,'Color','k','XColor','w','YColor','w','Tag','pzg bode plot axes')
  ScrSize = get(0,'ScreenSize');
  YLimit = sort(YLimit);
  if diff(YLimit) < 1e-4
    YLimit = [ YLimit(1)-6e-5, YLimit(2)+6e-5 ];
  end
  if ScrSize(3) > 1024
    set(gca0, ...
      'Interruptible','On', ...
      'FontSize', 10, ...
      'XLim', XLimit,'YLim', YLimit, ...
      'Position',[0.20 0.13 0.755 0.795] )
  else
    set(gca0, ...
      'Interruptible','On', ...
      'FontSize', 8, ...
      'XLim', XLimit,'YLim', YLimit, ...
      'Position',[0.20 0.13 0.755 0.795] )
  end
  
  temp0(4,1) = ...
    plot( BodeFreqs/FreqDiv, SensDB, ...
      'color','r', ...
      'linestyle','-', ...
      'linewidth', 3, ...
      'marker','none', ...
      'markersize', 4, ...
      'parent', gca0, ...
      'tag','Bode Line');
  hndl.Bode_Line = temp0(4,1);
  if numel(SensDB) < 2
    set(temp0(4,1),'Visible','off');
  end
  
  if ( dom_ndx == 2 ) 
    if ( numel(SensDB) > 2 )
      jumpndx = find( diff(negfreq_ndxs) > 1 );
      negplot_freqs = ...
        [ BodeFreqs(negfreq_ndxs(1):negfreq_ndxs(jumpndx)), ...
          BodeFreqs(negfreq_ndxs(jumpndx)), ...
          BodeFreqs(negfreq_ndxs(jumpndx+1):negfreq_ndxs(end)) ];
      negplot_SensDB = ...
        [ SensDB(negfreq_ndxs(1):negfreq_ndxs(jumpndx)),...
          NaN, ...
          SensDB(negfreq_ndxs(jumpndx+1):negfreq_ndxs(end)) ];
      temp0(5,1) = ...
        plot( negplot_freqs/FreqDiv, negplot_SensDB, ...
          'color', 1-get(gca0,'color'), ...
          'linestyle','--', ...
          'linewidth', 2, ...
          'marker','none', ...
          'markersize', 6, ...
          'parent', gca0, ...
          'Tag','Bode DT negfreq Line');
    else
      temp0(5,1) = ...
        plot( 1, 0, ...
          'color', 1-get(gca0,'color'), ...
          'linestyle','--', ...
          'linewidth', 2, ...
          'marker','none', ...
          'markersize', 6, ...
          'parent', gca0, ...
          'visible','off', ...
          'Tag','Bode DT negfreq Line');
    end
    hndl.Bode_DT_negfreq_Line = temp0(5,1);
  else
    hndl.Bode_DT_negfreq_Line = [];
  end
  
  if ( numel(SensDB) < 2 ) && ( dom_ndx == 2 ) ...
    &&( temp0(5,1) > 0 ) && isequal( 1, ishandle(temp0(5,1)) )
    set( temp0(5,1),'Visible','off');
  end

  % ---------------------------------------------
   % Plot the highlighted frequency, if there is one.
  temp0(3,1) = ...
    plot( BodeFreqs(tempNdx)/FreqDiv, SensDB(tempNdx),'co', ...
            'MarkerSize',8, 'LineWidth',3.0, ...
            'tag','Bode selection marker', ...
            'Visible', tempVis,'parent', gca0 );
  hndl.Bode_selection_marker = temp0(3,1);
  
  set( hndl.ax_ylabel,'string','Sensitivity (dB)');
  
  
  set(FigHndl,'UserData',temp0);
  
  % Adjust the background color.
  figopts('apply_default_color', FigHndl )
  
  % If any other bode plots already exist, set xlimit to same range.
  ax_h = pzg_fndo( dom_ndx,(1:4),'ax');
  if isempty(ax_h)
    if dom_ndx == 1
      ax_h = pzg_fndo( 2,(1:5),'ax');
    else
      ax_h = pzg_fndo( 1,(1:5),'ax');
    end
  end
  if ~isempty(ax_h)
    set( gca0,'xlim', get(ax_h(1),'xlim'),'ylimmode','auto');
  else
    set( gca0,'xlim', XLimit,'ylimmode','auto');
  end
  hndl.ax_xlim = get( gca0,'xlim');
  XLimit = hndl.ax_xlim;
  hndl.ax_ylim = get( gca0,'ylim');
  setappdata( FigHndl,'hndl', hndl );
  pzg_cphndl( FigHndl, dom_ndx, 5 );
  
  freqserv('refresh_plot_h', FigHndl );
  
  set( FigHndl,'visible','on')
  
  pzg_prvw( dom_ndx );

else
  % Sensitivity plot already exists.
  
  if numel(SensDB) > 1
    %set( temp0(2,1), ...
    %    'Xdata', BodeFreqs/FreqDiv, ...
    %    'Ydata', SensDB, ...
    %    'Visible','on' );
    set( temp0(4,1), ...
        'Xdata', BodeFreqs/FreqDiv, ...
        'Ydata', SensDB, ...
        'Visible','on' );
    if ( dom_ndx == 2 ) ...
      &&( temp0(5,1) > 0 ) && isequal( 1, ishandle(temp0(5,1)) )
      jumpndx = find( diff(negfreq_ndxs) > 1 );
      negplot_freqs = ...
        [ BodeFreqs(negfreq_ndxs(1):negfreq_ndxs(jumpndx-1)), ...
          BodeFreqs(negfreq_ndxs(jumpndx)), ...
          BodeFreqs(negfreq_ndxs(jumpndx):negfreq_ndxs(end)) ];
      negplot_SensDB = ...
        [ SensDB(negfreq_ndxs(1):negfreq_ndxs(jumpndx-1)), ...
          NaN, ...
          SensDB(negfreq_ndxs(jumpndx):negfreq_ndxs(end)) ];
      set( temp0(5,1), ...
          'xdata', negplot_freqs/FreqDiv, ...
          'ydata', negplot_SensDB, ...
          'color', 1-get( FigHndl,'color'), ...
          'visible','on');
    end
  else
    %set( temp0(2,1),'Xdata', 0,'Ydata', 0,'Visible','off' );
    set( temp0(4,1),'Xdata', 0,'Ydata', 0,'Visible','off' );
    if isequal( ishandle( temp0(5,1) ), 1 ) && ( temp0(5,1) > 0 )
      set( temp0(5,1),'xdata', 0,'ydata', 0,'visible','off');
    end
  end
  set(temp0(3,1),'Xdata', BodeFreqs(tempNdx)/FreqDiv, ...
                 'Ydata', SensDB(tempNdx), ...
                 'Visible', tempVis );
  XLimit = get( temp0(1,1),'xlim');
  YLimit = get( temp0(1,1),'ylim');
end

pzg_seltxt(dom_ndx)

if strcmpi( Domain,'s') 
  if any( real(PZG(1).CLPoleLocs) > 0 )
    set( get(temp0(1,1),'title'),'string', ...
        'Continuous-Time Closed-Loop System is UNSTABLE', ...
        'color','r')
    set(temp0(3:4,1),'visible','off')
  else
    set( get(temp0(1,1),'title'),'string', ...
        'Continuous-Time Closed-Loop Output Sensitivity', ...
        'color', 1-get(temp0(1,1),'color') )
  end
else
  if any( abs(PZG(2).CLPoleLocs) > 1 )
    set( get(temp0(1,1),'title'),'string', ...
        'Discrete-Time Closed-Loop System is UNSTABLE', ...
        'color','r')
    for k = 2:4
      if ~isempty(temp0(k,1)) && ~isequal( 0, temp0(k,1) )
        set(temp0(k,1),'visible','off')
      end
    end
  else
    set( get(temp0(1,1),'title'),'string', ...
        'Discrete-Time Closed-Loop Output Sensitivity', ...
        'color', 1-get(temp0(1,1),'color') )
  end
end

YLimit = sort(YLimit);
if diff(YLimit) < 1e-4
  YLimit = [ YLimit(1)-6e-5, YLimit(2)+6e-5 ];
end

if LogScaling
  set( temp0(1,1),'xscale','log','XLim', XLimit,'YLim', YLimit )
else
  set( temp0(1,1),'xscale','linear','XLim', XLimit,'YLim', YLimit )
end

bodesens_label_h = pzg_fndo( dom_ndx, 5,'Bode_Sens_label');
bodesens_text_h = pzg_fndo( dom_ndx, 5,'Bode_Sens_text');
if ( numel(CplxCLBode) > 1 ) ...
  &&( ( numel(PZG(dom_ndx).PoleLocs)-numel(PZG(dom_ndx).ZeroLocs) > 1 ) ...
     ||( ( dom_ndx == 2 ) ...
        &&( numel(PZG(dom_ndx).PoleLocs)-numel(PZG(dom_ndx).ZeroLocs) > 0 ) ) )
  if strcmp( Domain,'s')
    BodeSens_delW = diff( PZG(1).BodeFreqs );
  else
    BodeSens_delW = diff( PZG(2).BodeFreqs );
  end
  BodeSensComp = sum( BodeSens_delW(:) .* LogSens(:) )/pi;
  if dom_ndx == 2
    BodeSensComp = BodeSensComp/4;
  end
  BodeSensComp = round(BodeSensComp*100)/100;
  if BodeSensComp == 0
    bodesens_str = '= 0';
  else
    bodesens_str = [ '=' num2str(BodeSensComp,3) ' pi']; 
  end
  
  if isempty(bodesens_label_h)
    hndl.bodesens_label_h = ...
      uicontrol( FigHndl,'style','text', ...
        'units','normalized', ...
        'position',[ 0.001 0.80 0.14 0.199 ], ...
        'string',{'approx';'Bode';'sens';'integral'}, ...
        'fontsize', 8, ...
        'fontweight','bold', ...
        'backgroundcolor', get(FigHndl,'color'), ...
        'foregroundcolor', [0 0.7 0.7], ...
        'tag','Bode Sens label', ...
        'tooltipstring', ...
          'Bode log-sensitivity integral, approximated');
  else
    hndl.bodesens_label_h = bodesens_label_h;
    set( bodesens_label_h,'visible','on')
  end
  if isempty(bodesens_text_h)
    hndl.Bode_Sens_text = ...
      uicontrol( FigHndl,'style','text', ...
        'units','normalized', ...
        'position',[ 0.001 0.76 0.16 0.049 ], ...
        'string', bodesens_str, ...
        'fontsize', 10, ...
        'fontweight','bold', ...
        'backgroundcolor', get(FigHndl,'color'), ...
        'foregroundcolor',[0 0.7 0.7], ...
        'tag','Bode Sens text', ...
        'tooltipstring', ...
          'Bode log-sensitivity integral, approximated');
  else
    hndl.Bode_Sens_text = bodesens_text_h;
    set( bodesens_text_h,'string', bodesens_str,'visible','on')
  end
else
  if ~isempty(bodesens_label_h)
    set( bodesens_label_h,'visible','off')
  end
  if ~isempty(bodesens_text_h)
    set( bodesens_text_h,'visible','off')
  end
end

if numel(exist_xlim) == 2
  set( gca0,'xlim', exist_xlim,'ylimmode','auto');
end
  
set(FigHndl,'userdata',temp0);
hndl.ax_xlim = get( hndl.ax,'xlim');
hndl.ax_ylim = get( hndl.ax,'ylim');
setappdata( FigHndl,'hndl', hndl );
pzg_cphndl( FigHndl, dom_ndx, 5 );

set( FigHndl,'doublebuffer','on');

if is_new_figure
  pzg_updtfilt(dom_ndx);
end

return



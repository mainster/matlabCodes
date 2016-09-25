function pzg_box( src, button_up )
% This function implements and services the "draw box" feature in PZGUI.

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
global pzg_drawbox
if isempty(PZG) && ~pzg_recovr
  clear global pzg_drawbox
  return
end
evalin('base','global PZG')

if ( nargin == 2 ) && ~isequal( button_up, 0 )
  % Function is being called at release of mouse button.
  if isstruct(pzg_drawbox) ...
    && isfield( pzg_drawbox,'button_down') ...
    && pzg_drawbox.button_down
    gcbf_hndl = getappdata( gcbf,'hndl');
    drawbox_h = gcbf_hndl.draw_box_checkbox;
    if get( drawbox_h,'value')
      pzg_drawbox.corner2 = get( gcbf_hndl.ax,'currentpoint');
      pzg_box
    end
  end
  pzg_drawbox.button_down = 0;
  pzg_drawbox.corner1 = [];
  pzg_drawbox.corner2 = [];
  return
end

if isequal( nargin, 1 ) && strcmp( src,'redraw box')
  success = local_redraw_boxes;
  if ~isequal( success, 0 )
    return
  end
end

if isempty(PZG)
  return
end
ctPZG_figh = pzg_fndo( 1, 12,'fig_h');
dtPZG_figh = pzg_fndo( 2, 13,'fig_h');
if ~isstruct(pzg_drawbox) ...
  ||~isfield( pzg_drawbox,'button_down') ...
  ||~pzg_drawbox.button_down ...
  ||~isfield( pzg_drawbox,'corner1') ...
  ||~isfield( pzg_drawbox,'corner2') ...
  ||isempty(pzg_drawbox.corner1) ...
  ||isempty(pzg_drawbox.corner2)
  return
end
Corner1 = pzg_drawbox.corner1;
Corner2 = pzg_drawbox.corner2;

gcf0 = gcbf;
if isempty(gcf0)
  return
end
if ~isempty( strfind( get(gcbf,'name'),'Continuous') )
  Domain = 's';
  dom_ndx = 1;
elseif ~isempty( strfind( get(gcbf,'name'),'Discrete') )
  Domain = 'z';
  dom_ndx = 2;
else
  return
end

minSX = min(Corner1(1,1),Corner2(1,1));
maxSX = max(Corner1(1,1),Corner2(1,1));
minSY = min(Corner1(1,2),Corner2(1,2));
maxSY = max(Corner1(1,2),Corner2(1,2));
if minSY ~= maxSY
  sVy = (minSY:(maxSY-minSY)/300:maxSY)';
else
  sVy = minSY*ones([301 1]);
end
sLVx = minSX*ones(size(sVy));
sRVx = maxSX*ones(size(sVy));
if minSX ~= maxSX
  sHx = (minSX:(maxSX-minSX)/300:maxSX)';
else
  sHx = minSX*ones([301 1]);
end
if numel(sHx) < numel(sVy)
  sHx(end+1) = sHx(end);
elseif numel(sHx) > numel(sVy)
  sVy(end+1) = sVy(end);
end
sBHy = minSY*ones(size(sHx));
sTHy = maxSY*ones(size(sHx));
try
  tempX = [sLVx sRVx sHx sHx sHx sHx];
catch   %#ok<CTCH>
  return
end
tempY = [sVy sVy sBHy sTHy sVy flipud(sVy)];

box_ud = [];
box_ud.box_x = tempX;
box_ud.box_y = tempY;
box_ud.box_domain = Domain;

if strcmp( PZG(dom_ndx).DefaultBackgroundColor,'k')
  ColorOrder = [ 1 0.8 0.4; 1 0 1; 0.4 0.8 1; 1 0 0; 0 1 0; 1 1 1];
else
  ColorOrder = [ 1 0.8 0.4; 1 0 1; 0.4 0.8 1; 1 0 0; 0 1 0; 0 0 0];
end

if isappdata( gcf0,'hndl')
  hndl = getappdata( gcf0,'hndl');
else
  hndl = [];
end
if dom_ndx == 1
  pzgbox_h = pzg_fndo( 1, 12,'pzgbox');
else
  pzgbox_h = pzg_fndo( 2, 13,'pzgbox');
end
if ~isequal( numel(pzgbox_h), 6 )
  delete(pzgbox_h)
  if isfield( hndl,'ax') && isequal( 1, ishandle(hndl.ax) )
    ax_h = hndl.ax;
  else
    ax_h = get( gcf0,'currentaxes');
  end
  initColorOrder = get( ax_h,'colororder');
  set( ax_h,'colororder', ColorOrder );
  pzgbox_h = ...
    plot( tempX, tempY, ...
         'LineStyle','-', ...
         'LineWidth',2, ...
         'tag','pzg_box', ...
         'parent', ax_h, ...
         'userdata', box_ud );
  set( ax_h,'colororder', initColorOrder );
  temp0 = get( gcf0,'userdata');
  if size(temp0,2) == 2
    temp0(11:16,1) = pzgbox_h;
    set( gcf0,'userdata', temp0 );
  end
  hndl = getappdata( gcf0,'hndl');
  if isfield(hndl,'ax')
    hndl.pzgbox = pzgbox_h;
    setappdata( gcf0,'hndl', hndl );
  end
  if dom_ndx == 1
    if isfield( PZG(1).plot_h{12},'hndl')
      PZG(1).plot_h{12}.hndl.pzgbox = pzgbox_h;
      PZG(2).plot_h{12}.hndl.pzgbox = pzgbox_h;
    end
  else
    if isfield( PZG(2).plot_h{13},'hndl')
      PZG(1).plot_h{13}.hndl.pzgbox = pzgbox_h;
      PZG(2).plot_h{13}.hndl.pzgbox = pzgbox_h;
    end
  end
else
  for Ck = 1:6
    set( pzgbox_h(Ck),...
        'xdata',tempX(:,Ck),...
        'ydata',tempY(:,Ck), ...
        'color', ColorOrder(Ck,:) , ...
        'userdata', box_ud );
    set( pzgbox_h(Ck),'visible','on')
  end
end

% Update the other p/z maps, including open root-locus plots.
if strcmpi( Domain,'s')
  % Check for root locus plot
  ctRL_figh = pzg_fndo( 1, 10,'fig_h');
  if ~isempty(ctRL_figh)
    ctRL_pzgbox_h = pzg_fndo( 1, 10,'pzgbox');
    if ~isequal( 6, numel(ctRL_pzgbox_h) )
      delete(ctRL_pzgbox_h)
      ctRL_axh = pzg_fndo( 1, 10,'ax_h');
      initColorOrder = get( ctRL_axh,'colororder');
      set( ctRL_axh,'colororder', ColorOrder );
      ctRL_pzgbox_h = ...
        plot( tempX, tempY, ...
           'LineStyle','-', ...
           'LineWidth', 2, ...
           'tag','pzg_box', ...
           'parent', ctRL_axh, ...
           'userdata', box_ud );
      set( ctRL_axh,'colororder', initColorOrder );
      ctRL_tempUD = get( ctRL_figh,'UserData');
      if size(ctRL_tempUD,2) == 2
        ctRL_tempUD(1:6,2) = ctRL_pzgbox_h;
        set( ctRL_figh,'userdata', ctRL_tempUD );
      end
      ctRL_hndl = getappdata( ctRL_figh,'hndl');
      if isfield( ctRL_hndl,'ax')
        ctRL_hndl.pzgbox = ctRL_pzgbox_h;
        setappdata( ctRL_figh,'hndl', ctRL_hndl );
      end
      PZG(1).plot_h{10}.hndl.pzgbox = ctRL_pzgbox_h;
      PZG(2).plot_h{10}.hndl.pzgbox = ctRL_pzgbox_h;
    else
      for kline = 1:6
        set( ctRL_pzgbox_h(kline), ...
          'xdata', tempX(:,kline),'ydata', tempY(:,kline), ...
          'userdata', box_ud, ...
          'color', ColorOrder(kline,:), ...
          'userdata', box_ud );
        set( ctRL_pzgbox_h(kline),'visible','on');
      end
    end
  end
  
  link_method = get( PZG(1).plot_h{12}.hndl.LinkMethod,'value');
  if isequal( link_method, 3 )
    % Compute the bilinear transformation.
    temp = 2 - (tempX+1i*tempY)*PZG(1).Ts;
    if sum(abs(temp)<eps)>0
      Ndx = flipud(sort(temp==0)); %#ok<FLPST>
      for Ck = 1:numel(Ndx)
        if Ndx(Ck)>1
          temp(Ndx(Ck)) = temp(Ndx(Ck-1))/10;
        else
          temp(1) = temp(2)/10;
        end
      end
    end
    tempZ = (2+(tempX+1i*tempY)*PZG(1).Ts)./temp;
  else
    % Compute the e^Ts transformation
    tempZ = exp((tempX+1i*tempY)*PZG(1).Ts);
  end
  
  tempX = real(tempZ);
  tempY = imag(tempZ);
  if ~isempty(dtPZG_figh)
    dtPZG_pzgbox_h = pzg_fndo( 2, 13,'pzgbox');
    if ~isequal( 6, numel(dtPZG_pzgbox_h) )
      delete(dtPZG_pzgbox_h)
      dtPZG_axh = pzg_fndo( 2, 13,'ax_h');
      initColorOrder = get( dtPZG_axh,'colororder');
      set( dtPZG_axh,'colororder', ColorOrder );
      dtPZG_pzgbox_h = ...
        plot( tempX, tempY, ...
          'LineWidth', 2, ...
          'tag','pzg_box', ...
          'parent', dtPZG_axh, ...
          'userdata', box_ud );
      set( dtPZG_axh,'colororder', initColorOrder );
      dtPZG_tempUD = get( dtPZG_figh,'UserData');
      if size(dtPZG_tempUD,2) == 2
        dtPZG_tempUD(11:16,1) = dtPZG_pzgbox_h(:);
        set( dtPZG_figh,'UserData', dtPZG_tempUD );
      end
      dtPZG_hndl = getappdata( dtPZG_figh,'hndl');
      if isfield( dtPZG_hndl,'ax')
        dtPZG_hndl.pzgbox = dtPZG_pzgbox_h;
        setappdata( dtPZG_figh,'hndl', dtPZG_hndl );
      end
      PZG(1).plot_h{13}.hndl.pzgbox = dtPZG_pzgbox_h;
      PZG(2).plot_h{13}.hndl.pzgbox = dtPZG_pzgbox_h;
    else
      for Ck = 1:6
        set( dtPZG_pzgbox_h(Ck), ...
          'xdata',tempX(:,Ck), ...
          'ydata',tempY(:,Ck), ...
          'color', ColorOrder(Ck,:), ...
          'userdata', box_ud );
        set( dtPZG_pzgbox_h(Ck),'visible','on');
      end
    end
  end
  if isfield( PZG(2),'plot_h') ...
    && ( numel(PZG(2).plot_h) > 11 ) ...
    && isfield( PZG(2).plot_h{11},'fig_h') ...
    && isequal( 1, ishandle(PZG(2).plot_h{11}.fig_h) )
    dtRL_figh = PZG(2).plot_h{11}.fig_h;
  else
    dtRL_figh = [];
  end
  if ~isempty(dtRL_figh)
    dtRL_pzgboxh = pzg_fndo( 2, 11,'pzgbox');
    if ~isequal( 6, numel(dtRL_pzgboxh) )
      delete(dtRL_pzgboxh)
      dtRL_axh = pzg_fndo( 2, 11,'ax_h');      
      initColorOrder = get( dtRL_axh,'colororder');
      set( dtRL_axh,'colororder', ColorOrder );
      dtRL_pzgboxh = ...
        plot( tempX, tempY, ...
          'LineStyle','-', ...
          'LineWidth', 2, ...
          'tag','pzg_box', ...
          'parent', dtRL_axh, ...
          'userdata', box_ud );
      set( dtRL_axh,'colororder', initColorOrder );
      RLdt_temp0 = get( dtRL_figh,'UserData');
      if size(RLdt_temp0,2) == 2
        RLdt_temp0(1:6,2) = dtRL_pzgboxh(:);
        set( dtRL_figh,'UserData', RLdt_temp0 );
      end
      dtRL_hndl = getappdata( dtRL_figh,'hndl');
      if isfield( dtRL_hndl,'ax')
        dtRL_hndl.pzgbox = dtRL_pzgboxh;
        setappdata( dtRL_figh,'hndl', dtRL_hndl );
      end
      PZG(2).plot_h{11}.hndl.pzgbox = dtRL_pzgboxh;
      PZG(2).plot_h{11}.hndl.pzgbox = dtRL_pzgboxh;
    else
      for Ck = 1:6
        set( dtRL_pzgboxh(Ck), ...
          'xdata',tempX(:,Ck), ...
          'ydata',tempY(:,Ck), ...
          'color', ColorOrder(Ck,:), ...
          'userdata', box_ud );
        set( dtRL_pzgboxh(Ck),'visible','on');
      end
    end
  end
end
if strcmpi( Domain,'z')
  dtRL_figh = pzg_fndo( 2, 11,'fig_h');
  if ~isempty(dtRL_figh)
    dtRL_pzgboxh = pzg_fndo( 2, 11,'pzgbox');
    if ~isequal( 6, numel(dtRL_pzgboxh) )
      delete(dtRL_pzgboxh)
      dtRL_axh = pzg_fndo( 2, 11,'ax_h');
      initColorOrder = get( dtRL_axh,'colororder');
      set( dtRL_axh,'colororder', ColorOrder );
      dtRL_pzgboxh = ...
        plot( tempX, tempY, ...
             'LineStyle','-', ...
             'LineWidth', 2, ...
             'tag','pzg_box', ...
             'parent', dtRL_axh, ...
             'userdata', box_ud );
      set( dtRL_axh,'colororder', initColorOrder );
      RLdt_temp0 = get( dtRL_figh,'UserData');
      if size(RLdt_temp0,2) == 2
        RLdt_temp0(1:6,2) = dtRL_pzgboxh(:);
        set( dtRL_figh,'UserData', RLdt_temp0 );
      end
      dtRL_hndl = getappdata( dtRL_figh,'hndl');
      if isfield( dtRL_hndl,'ax')
        dtRL_hndl.pzgbox = dtRL_pzgboxh;
        setappdata( dtRL_figh,'hndl', dtRL_hndl )
      end
      PZG(2).plot_h{11}.hndl.pzgbox = dtRL_pzgboxh;
      PZG(2).plot_h{11}.hndl.pzgbox = dtRL_pzgboxh;
    else
      for Ck = 1:6
        set( dtRL_pzgboxh(Ck), ...
          'xdata',tempX(:,Ck), ...
          'ydata',tempY(:,Ck), ...
          'userdata', box_ud, ...
          'color', ColorOrder(Ck,:) );
        set( dtRL_pzgboxh(Ck),'visible','on');
      end
    end
  end
  
  link_method = get( PZG(2).plot_h{13}.hndl.LinkMethod,'value');
  if isequal( link_method, 3 )
    temp = PZG(2).Ts * ((tempX+1i*tempY)+1);
    if sum(abs(temp)<eps)>0
      Ndx = flipud(sort(temp==0)); %#ok<FLPST>
      for Ck = 1:numel(Ndx)
        if Ndx(Ck)>1
          temp(Ndx(Ck)) = ...
          temp(Ndx(Ck-1))/10;
        else
          temp(1) = temp(2)/10;
        end
      end
    end
    tempZ = (2*((tempX+1i*tempY)-1))./temp;
  else
    tempZ = log(tempX+1i*tempY)/PZG(2).Ts;
  end
  tempX = real(tempZ);
  tempY = imag(tempZ);
  
  if ~isempty(ctPZG_figh)
    ctPZG_pzgbox_h = pzg_fndo(  1, 12,'pzgbox');
    if ~isequal( numel(ctPZG_pzgbox_h), 6 )
      delete(ctPZG_pzgbox_h)
      ctPZG_axh = pzg_fndo( 1, 12,'ax_h');
      initColorOrder = get( ctPZG_axh,'colororder');
      set( ctPZG_axh,'colororder', ColorOrder );
      ctPZG_pzgbox_h = ...
        plot( tempX, tempY, ...
             'LineStyle','-', ...
             'LineWidth', 2, ...
             'tag','pzg_box', ...
             'parent', ctPZG_axh, ...
             'userdata', box_ud);
      set( ctPZG_axh,'colororder', initColorOrder );
      CTpzg_temp0 = get( ctPZG_figh,'UserData');
      if size(CTpzg_temp0,2) == 2
        CTpzg_temp0(11:16,1) = ctPZG_pzgbox_h(:);
        set( ctPZG_figh,'UserData', CTpzg_temp0 );
      end
      ctPZG_hndl = getappdata( ctPZG_figh,'hndl');
      if isfield( ctPZG_hndl,'ax')
        ctPZG_hndl.pzgbox = ctPZG_pzgbox_h;
        setappdata( ctPZG_figh,'hndl', ctPZG_hndl )
      end
      PZG(1).plot_h{12}.hndl.pzgbox = ctPZG_pzgbox_h;
      PZG(2).plot_h{12}.hndl.pzgbox = ctPZG_pzgbox_h;
    else
      for Ck = 1:6
        set(ctPZG_pzgbox_h(Ck), ...
          'XData',tempX(:,Ck), ...
          'YData',tempY(:,Ck), ...
          'color', ColorOrder(Ck,:), ...
          'userdata', box_ud );
        set(ctPZG_pzgbox_h(Ck),'Visible','On' );
      end
    end
  end
  
  RLct_fig_h = [];
  if isfield(PZG,'plot_h') ...
    && ( numel(PZG(1).plot_h) >= 10 ) ...
    && isfield(PZG(1).plot_h{10},'fig_h') ...
    && isequal( 1, ishandle(PZG(1).plot_h{10}.fig_h) )
    RLct_fig_h = PZG(1).plot_h{10}.fig_h;
  end
  if ~isempty(RLct_fig_h)
    ctRL_pzgbox_h = pzg_fndo( 1, 10,'pzgbox');
    if ~isequal( numel(ctRL_pzgbox_h), 6 )
      ctRL_axh = pzg_fndo( 1, 10,'ax_h');
      initColorOrder = get( ctRL_axh,'colororder');
      set( ctRL_axh,'colororder', ColorOrder )
      ctRL_pzgbox_h = ...
        plot( tempX, tempY, ...
          'LineStyle','-', ...
          'LineWidth', 2, ...
          'tag','pzg_box', ...
          'parent', ctRL_axh, ...
          'userdata', box_ud );
      set( ctRL_axh,'colororder', initColorOrder );
      RLct_temp0 = get( RLct_fig_h,'UserData');
      if size(RLct_temp0,2) == 2
        RLct_temp0(1:6,2) = ctRL_pzgbox_h;
        set( RLct_fig_h,'UserData', RLct_temp0);
      end
      ctRL_hndl = getappdata( RLct_fig_h,'hndl');
      if isfield( ctRL_hndl,'ax')
        ctRL_hndl.pzgbox = ctRL_pzgbox_h;
        setappdata( RLct_fig_h,'hndl', ctRL_hndl );
      end
      PZG(1).plot_h{10}.hndl.pzgbox = ctRL_pzgbox_h;
      PZG(2).plot_h{10}.hndl.pzgbox = ctRL_pzgbox_h;
    else
      for Ck = 1:6
        set(ctRL_pzgbox_h(Ck), ...
          'XData',tempX(:,Ck), ...
          'YData',tempY(:,Ck), ...
          'color', ColorOrder(Ck,:), ...
          'userdata', box_ud );
        set(ctRL_pzgbox_h(Ck),'visible','on');
      end
    end
  end
end

drawnow

return


function success = local_redraw_boxes
  global PZG
  success = 1;

  ctPZG_figh = pzg_fndo( 1, 12,'fig_h');
  dtPZG_figh = pzg_fndo( 2, 13,'fig_h');
  if isempty(ctPZG_figh) || isempty(dtPZG_figh)
    pzgbox_h = ...
      [ pzg_fndo( 1, [10,12],'pzgbox'); ...
        pzg_fndo( 2, [11,13],'pzgbox') ];
    if ~isempty(pzgbox_h)
      set( pzgbox_h,'visible','off')
    end
    success = 0;
    return
  end
    
  if strcmp( PZG(1).DefaultBackgroundColor,'k')
    ColorOrder = [ 1 0.8 0.4; 1 0 1; 0.4 0.8 1; 1 0 0; 0 1 0; 1 1 1];
  else
    ColorOrder = [ 1 0.8 0.4; 1 0 1; 0.4 0.8 1; 1 0 0; 0 1 0; 0 0 0];
  end
  mapping_type = get( PZG(1).plot_h{12}.hndl.LinkMethod,'value');
  
  pzgbox_h = pzg_fndo( 2, 13,'pzgbox');
  if isequal( numel(pzgbox_h), 6 ) && all( ishandle(pzgbox_h) )
    box_data = get( pzgbox_h(1),'userdata');
    if ~isempty(box_data) && isfield( box_data,'box_domain') ...
      && strcmp( box_data.box_domain,'s')
      % Recompute and redraw the mapping of the box from S to Z planes.
      splane_pts = box_data.box_x + 1i*box_data.box_y;
      if mapping_type < 3
        zplane_pts = exp( splane_pts * PZG(2).Ts );
      else
        zplane_pts = local_bilinear_tform( splane_pts );
      end
      for Ck = 1:6
        set( pzgbox_h(Ck), ...
            'xdata', real(zplane_pts(:,Ck)), ...
            'ydata', imag(zplane_pts(:,Ck)), ...
            'color', ColorOrder(Ck,:) );
        set( pzgbox_h(Ck),'visible','on');
      end
    end
  else
    success = 0;
  end
  
  dtRL_figh = pzg_fndo( 2, 11,'fig_h');
  if ~isempty(dtRL_figh)
    pzgbox_h = pzg_fndo( 2, 11,'pzgbox');
    if isequal( numel(pzgbox_h), 6 ) && all( ishandle(pzgbox_h) )
      box_data = get( pzgbox_h(1),'userdata');
      if ~isempty(box_data) && isfield( box_data,'box_domain') ...
        && strcmp( box_data.box_domain,'s')
        % Recompute and redraw the mapping of the box from S to Z planes.
        splane_pts = box_data.box_x + 1i*box_data.box_y;
        if mapping_type < 3
          zplane_pts = exp( splane_pts * PZG(2).Ts );
        else
          zplane_pts = local_bilinear_tform( splane_pts );
        end
        for Ck = 1:6
          set( pzgbox_h(Ck), ...
              'xdata', real(zplane_pts(:,Ck)), ...
              'ydata', imag(zplane_pts(:,Ck)), ...
              'color', ColorOrder(Ck,:) );
          set( pzgbox_h(Ck),'visible','on');
        end
      end
    else
      success = 0;
    end
  end
  
  pzgbox_h = pzg_fndo( 1, 12,'pzgbox');
  if isequal( numel(pzgbox_h), 6 ) && all( ishandle(pzgbox_h) ) ...
    && ( ~isnumeric(pzgbox_h) || all( pzgbox_h > 0 ) )
    box_data = get( pzgbox_h(1),'userdata');
    if ~isempty(box_data) && isfield( box_data,'box_domain') ...
      && strcmp( box_data.box_domain,'z')
      % Recompute and redraw the mapping of the box from Z to S planes.
      zplane_pts = box_data.box_x + 1i*box_data.box_y;
      if mapping_type < 3
        splane_pts = log( zplane_pts ) / PZG(2).Ts;
      else
        splane_pts = local_inv_bilinear_tform( zplane_pts );
      end
      for Ck = 1:6
        set( pzgbox_h(Ck), ...
            'xdata', real(splane_pts(:,Ck)), ...
            'ydata', imag(splane_pts(:,Ck)), ...
            'color', ColorOrder(Ck,:) );
        set( pzgbox_h(Ck),'visible','on');
      end
    end
  else
    success = 0;
  end
  
  ctRL_figh = pzg_fndo( 1, 10,'fig_h');
  if ~isempty(ctRL_figh)
    ctRL_hndl = getappdata( ctRL_figh,'hndl');
    pzgbox_h = pzg_fndo( 1, 10,'pzgbox');
    if isequal( numel(pzgbox_h), 6 ) && all( ishandle(pzgbox_h) ) ...
      && ( ~isnumeric(pzgbox_h) || all( pzgbox_h > 0 ) )
      box_data = get( pzgbox_h(1),'userdata');
      if ~isempty(box_data) && isfield( box_data,'box_domain') ...
        && strcmp( box_data.box_domain,'z')
        % Recompute and redraw the mapping of the box from Z to SZ planes.
        zplane_pts = box_data.box_x + 1i*box_data.box_y;
        if mapping_type < 3
          splane_pts = log( zplane_pts ) / PZG(2).Ts;
        else
          splane_pts = local_inv_bilinear_tform( zplane_pts );
        end
        for Ck = 1:6
          set( pzgbox_h(Ck), ...
              'xdata', real(splane_pts(:,Ck)), ...
              'ydata', imag(splane_pts(:,Ck)), ...
              'color', ColorOrder(Ck,:) );
          set( pzgbox_h(Ck),'visible','on');
        end
        ctRL_hndl.pzgbox = pzgbox_h;
        setappdata( ctRL_figh,'hndl', ctRL_hndl )
        RLct_tempUD(1:6,2) = pzgbox_h(:);
        set( ctRL_figh,'userdata', RLct_tempUD );
        PZG(1).plot_h{10}.hndl.pzgbox = pzgbox_h;
        PZG(2).plot_h{10}.hndl.pzgbox = pzgbox_h;
      end
    else
      success = 0;
    end
  end
  
return


function zplane_pts = local_bilinear_tform( splane_pts )
  % Compute the bilinear transformation.
  global PZG
  temp = 2 - splane_pts*PZG(2).Ts;
  if sum( abs(temp) < eps ) > 0
    Ndx = flipud( sort(temp==0) ); %#ok<FLPST>
    for Ck = 1:numel(Ndx)
      if Ndx(Ck) > 1
        temp(Ndx(Ck)) = temp(Ndx(Ck-1))/10;
      else
        temp(1) = temp(2)/10;
      end
    end
  end
  zplane_pts = ( 2+splane_pts*PZG(2).Ts ) ./ temp;
return


function splane_pts = local_inv_bilinear_tform( zplane_pts )
  % Compute the inverse-bilinear transformation.
  global PZG

  temp = PZG(2).Ts * ( zplane_pts + 1 );
  if sum( abs(temp) < eps ) > 0
    Ndx = flipud( sort(temp==0) ); %#ok<FLPST>
    for Ck = 1:numel(Ndx)
      if Ndx(Ck) > 1
        temp(Ndx(Ck)) = temp(Ndx(Ck-1))/10;
      else
        temp(1) = temp(2)/10;
      end
    end
  end
  splane_pts = 2*( zplane_pts - 1 ) ./ temp;
return



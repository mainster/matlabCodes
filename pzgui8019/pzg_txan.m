function text_angle = pzg_txan( the_point, xlim, ylim, ax_h )
%   text_angle = pzg_txan( cplx_point, xlim, ylim, ax_h );
%    where  "cplx_point" = xvalue + 1i*yvalue,
%           "xlim" is a 1x2 vector of x-axis limits (monotonically increasing),
%           "ylim" is a 1x2 vector of y-axis limits (monotonically increasing),
%      and  "ax_h" is a valid axes-handle.
% Computes the appropriate text angle, considering the plot scaling
% (determined by the specified "xlim" and "ylim"),
% and the pixel "extent" of the figure that contains the axes "ax_h",
% assuming that the text will be used to label a vector from the
% origin to the specified "cplx_point".
%  >> Works only for 2-D plots that have linear scaling in both axes.
%  >> Returns text_angle=0 if any argument is invalid.

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
  
  text_angle = 0;
  
  if ( nargin < 3 ) ...
    || ~isnumeric(the_point) || ( numel(the_point) > 2 ) ...
    || ~isreal(xlim) || ~isequal( 2, numel(xlim) ) || (xlim(2) <= xlim(1)) ...
    || ~isreal(ylim) || ~isequal( 2, numel(ylim) ) || (ylim(2) <= ylim(1))
    return
  end
  
  
  x_scale_factor = 1;
  if ( nargin >= 4 ) && isreal(ax_h) ...
    && isequal( numel(ax_h), 1 ) ...
    && isequal( 1, ishandle(ax_h) ) ...
    && strcmp( get(ax_h,'type'),'axes')
    fig_pos = get( get(ax_h,'parent'),'position');
    fig_extent = fig_pos .* get( 0,'screensize');
    ax_extent = get( ax_h,'position') .* fig_extent;
    x_scale_factor = ax_extent(3) / ax_extent(4);
  end
  
  if numel(the_point) == 2
    x = the_point(1);
    y = the_point(2);
  else
    x = real(the_point);
    y = imag(the_point);
  end
  tan_pt_angle = y / x;
  
  xmin = xlim(1);
  xmax = xlim(2);
  ymin = ylim(1);
  ymax = ylim(2);
  
  if ( x >= 0 ) && ( y >= 0 )
    % First quadrant
    delX = x - xmin;
    delY = delX * abs(tan_pt_angle);
    if ( y + delY ) > ymax
      delY = y - ymin;
      if ~isequal( tan_pt_angle, 0 )
        delX = delY / abs(tan_pt_angle);
      else
        delX = Inf;
      end
    end
    text_angle = atan2( delY/diff(ylim), ...
                        x_scale_factor*delX/diff(xlim) )/pi*180;
  elseif ( x < 0 ) && ( y >= 0 )
    % Second quadrant
    delX = xmax - x;
    delY = delX * abs(tan_pt_angle);
    if ( y + delY ) > ymax
      delY = y - ymin;
      if ~isequal( tan_pt_angle, 0 )
        delX = delY / abs(tan_pt_angle);
      else
        delX = Inf;
      end
    end
    text_angle = -atan2( delY/diff(ylim), ...
                         x_scale_factor*delX/diff(xlim) )/pi*180;
   elseif ( x < 0 ) && ( y < 0 )
    % Third quadrant
    delX = xmax - x;
    delY = delX * abs(tan_pt_angle);
    if ( y + delY ) > ymax
      delY = ymax - y;
      if ~isequal( tan_pt_angle, 0 )
        delX = delY / abs(tan_pt_angle);
      else
        delX = Inf;
      end
    end
    text_angle = atan2( delY/diff(ylim), ...
                        x_scale_factor*delX/diff(xlim) )/pi*180;
  elseif ( x >= 0 ) && ( y < 0 )
    % Fourth quadrant
    delX = x - xmin;
    delY = delX * abs(tan_pt_angle);
    if ( y + delY ) > ymax
      delY = ymax - y;
      if ~isequal( tan_pt_angle, 0 )
        delX = delY / abs(tan_pt_angle);
      else
        delX = Inf;
      end
    end
    text_angle = -atan2( delY/diff(ylim), ...
                         x_scale_factor*delX/diff(xlim) )/pi*180;
  end
  
  if text_angle > 90
    text_angle = text_angle - 180;
  elseif text_angle < -90
    text_angle = text_angle + 180;
  end

return

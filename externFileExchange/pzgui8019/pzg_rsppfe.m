function [ resp_res, resp_poles, resp_direct ] = ...
             pzg_rsppfe( ...
                  dom_ndx, input_zeros, input_poles, input_gain, ...
                  architec, incl_prvw, incl_pade, extra_ol_loop_gain )
% Finds the partial-fraction-expansion of the specified pzgui zpk-model
% together with the specified input, and in the specified architecture
% ('open-loop' or 'closed-loop').  Used by pzgui "resppl" (time-response 
% plot function).

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
resp_res = [];
resp_poles = [];
resp_direct = [];
if isempty(PZG) && ~pzg_recovr 
  return
end

if nargin < 4
  return
end
if nargin < 5
  architec = 'open loop';  % default
end
if nargin < 6
  incl_prvw = 0;
end
if nargin < 7
  incl_pade = 0;
end
if nargin < 8
  extra_ol_loop_gain = 1;
end

ZZ = PZG(dom_ndx).ZeroLocs(:);
PP = PZG(dom_ndx).PoleLocs(:);
KK = PZG(dom_ndx).Gain;

if incl_pade && ( dom_ndx == 1 ) && ( PZG(1).PureDelay > 0 ) ...
  && isfield( PZG(1),'pade') && isstruct(PZG(1).pade) ...
  && isfield( PZG(1).pade,'Z') && isfield( PZG(1).pade,'P')
  ZZ = [ ZZ; PZG(1).pade.Z(:) ];
  PP = [ PP; PZG(1).pade.P(:) ];
elseif incl_pade && ( dom_ndx == 2 ) && ( PZG(2).PureDelay > 0 )
  PP = [ PP; zeros( PZG(2).PureDelay, 1 ) ];
end

prvw_str = [];
if ~isempty(incl_prvw) && ~isequal( incl_prvw, 0 )
  if isequal( dom_ndx, 1 )
    dsnfig_h = ...
      [ findobj( allchild(0),'type','figure', ...
                'name','s-Domain Lead Lag Design GUI'); ...
        findobj( allchild(0),'type','figure', ...
                'name','s-Domain PID Design GUI'); ...
        findobj( allchild(0),'type','figure', ...
                'name','s-Domain Pure Gain Design GUI') ];
  else
    dsnfig_h = ...
      [ findobj( allchild(0),'type','figure', ...
                'name','z-Domain Lead Lag Design GUI'); ...
        findobj( allchild(0),'type','figure', ...
                'name','z-Domain PID Design GUI'); ...
        findobj( allchild(0),'type','figure', ...
                'name','z-Domain Pure Gain Design GUI') ];
  end
  if ~isempty(dsnfig_h)
    dsnfig_h = dsnfig_h(1);
    figname = get( dsnfig_h,'name');
    switch figname
      case 's-Domain Lead Lag Design GUI'
        prvw_str = 'sLDLG';
      case 'z-Domain Lead Lag Design GUI'
        prvw_str = 'zLDLG';
      case 's-Domain PID Design GUI'
        prvw_str = 'sPID';
      case 'z-Domain PID Design GUI'
        prvw_str = 'zPID';
      case 's-Domain Pure Gain Design GUI'
        prvw_str = 'sGain';
      case 'z-Domain Pure Gain Design GUI'
        prvw_str = 'zGain';
    end
  end
  if ~isempty(prvw_str) && ischar(prvw_str)
    figname = '';
    switch lower(prvw_str)
      case 'sldlg'
        figname = 's-Domain Lead Lag Design GUI';
      case 'zldlg'
        figname = 'z-Domain Lead Lag Design GUI';
      case 'spid'
        figname = 's-Domain PID Design GUI';
      case 'zpid'
        figname = 'z-Domain PID Design GUI';
      case 'sgain'
        figname = 's-Domain Pure Gain Design GUI';
      case 'zgain'
        figname = 'z-Domain Pure Gain Design GUI';
    end
    if ~isempty(figname)
      dsnfig_h = findobj( allchild(0),'name', figname );
      if ~isempty(dsnfig_h)
        % Get the pole, zero, and gain.
        if ~isempty( strfind( lower(prvw_str),'ldlg') )
          % LEAD-LAG
          zero_h = findobj( dsnfig_h,'tag','Zero');
          this_z = str2double( get(zero_h,'string') );
          pole_h = findobj( dsnfig_h,'tag','Pole');
          this_p = str2double( get(pole_h,'string') );
          gain_h = findobj( dsnfig_h,'tag','Gain');
          this_k = str2double( get(gain_h,'string') );
          if ~isempty(this_z) && ~isempty(this_p) && ~isempty(this_k) ...
            && ~isnan(this_z) && ~isnan(this_p) && ~isnan(this_k) ...
            && ~isinf(this_z) && ~isinf(this_p) && ~isinf(this_k)
            if ~isempty(PP)
              [ mindist, minndx ] = min( abs( PP - this_z ) );
              if mindist < 1e-12
                PP(minndx) = [];
                this_z = [];
              end
            end
            ZZ = [ ZZ; this_z ];
            if ~isempty(ZZ)
              [ mindist, minndx ] = min( abs(ZZ-this_p) );
              if mindist < 1e-12
                ZZ(minndx) = [];
                this_p = [];
              end
            end
            PP = [ PP; this_p ];
            KK = KK * this_k;
          end
        elseif ~isempty( strfind( lower(prvw_str),'gain') )
          H_Gain = findobj( dsnfig_h,'type','uicontrol','tag','Gain');
          this_k = str2double( get(H_Gain,'string') );
          if ~isempty(this_k)
            KK = KK * this_k;
          end
        else
          % PID
          zero1_h = findobj( dsnfig_h,'tag','Zero1');
          zero2_h = findobj( dsnfig_h,'tag','Zero2');
          these_z = [ str2double( get(zero1_h,'string') ); ...
                      str2double( get(zero2_h,'string') ) ];
          gain_h = findobj( dsnfig_h,'tag','Gain');
          this_k = str2double( get(gain_h,'string') );
          p2mult_h = findobj( dsnfig_h,'tag','pole2_multiplier');
          p2mult = str2double( get(p2mult_h,'string') );
          if ~isempty(these_z(1)) && ~isempty(these_z(2)) && ~isempty(this_k) ...
            && ~isnan(these_z(1)) && ~isnan(these_z(2)) && ~isnan(this_k) ...
            && ~isinf(these_z(1)) && ~isinf(these_z(2)) && ~isinf(this_k)
            if dom_ndx == 1
              these_p = [ 0; -p2mult*max(abs(these_z)) ];
              this_k = this_k * abs(these_p(2));
            else
              these_p = [ 1; 0 ];
            end
            for ktp = 2:-1:1
              if ~isempty(PP)
                [ mindist, minndx ] = min( abs( PP - these_z(ktp) ) );
                if mindist < 1e-12
                  PP(minndx) = [];
                  these_z(ktp) = [];
                end
              end
            end
            ZZ = [ ZZ; these_z ];
            for ktp = 2:-1:1
              if ~isempty(ZZ)
                [ mindist, minndx ] = min( abs( ZZ - these_p(ktp) ) );
                if mindist < 1e-12
                  ZZ(minndx) = [];
                  these_p(ktp) = [];
                end
              end
            end
            PP = [ PP; these_p ];
            KK = KK * this_k;
          end
        end
      end
    end
  end
end

% Remove canceling poles and zeros.
for k = numel(PP):-1:1
  if ~isempty(ZZ)
    cncl_ndx = find( abs( ZZ - PP(k) ) < 1e-12 );
    if ~isempty(cncl_ndx)
      PP(k) = [];
      ZZ(cncl_ndx(1)) = [];
    end
  end
end

if ( nargin > 7 ) && isnumeric( extra_ol_loop_gain ) ...
  && isequal( 1, numel(extra_ol_loop_gain) ) ...
  && ( abs(extra_ol_loop_gain) > 1e-9 )
  KK = KK * extra_ol_loop_gain;
end

% At this point, the open-loop ZPK is complete.
if ~isempty( strfind( architec,'closed') ) 
  if ~isempty(PP)
    modalss = pzg_moda( dom_ndx, 1, incl_pade, incl_prvw,'', 1 );
    % Close the loop.
    if isempty( modalss ) || isempty( modalss.a )
      % Could not determine a s-s model.
      olNUM = KK * poly( ZZ );
      olDEN = poly( PP );
      if numel(olDEN) > numel(olNUM)
        olNUM = [ zeros(1,numel(olDEN)-numel(olNUM)), olNUM ];
      end
      clDEN = olNUM + olDEN;
      PP = roots( clDEN / clDEN(1) );
    else
      % Closed-loop poles.
      % OLdcgain = dcgain(modalss);
      % if isinf(OLdcgain)
      %   CLdcgain = 1;
      % else
      %   CLdcgain = OLdcgain/(1+OLdcgain);
      % end
      if ( nargin > 7 ) && isnumeric( extra_ol_loop_gain ) ...
        && isequal( 1, numel(extra_ol_loop_gain) ) ...
        && ( abs(extra_ol_loop_gain) > 1e-9 )
        modalss.c = modalss.c * extra_ol_loop_gain;
        modalss.d = modalss.d * extra_ol_loop_gain;
      end
      if abs( modalss.d + 1 ) < 1e-14
        PP = inf( size(modalss.a,1), 1 );
      else
        PP = eig( modalss.a - modalss.b*modalss.c/(modalss.d+1) );
      end
    end
  end
  if numel(ZZ) == numel(PP)
    KK = KK /( 1 + KK );
  end
end

% Round off poles near zero, and (for D-T) poles near +/-1.
nearzero_p = find( abs(PP) <= 1e-12 );
if ~isempty(nearzero_p)
  PP(nearzero_p) = 0;
end
if dom_ndx == 2
  nearone_p = find( abs(PP-1) <= 1e-10 );
  if ~isempty(nearone_p)
    PP(nearone_p) = 1;
  end
  nearnegone_p = find( abs(PP+1) <= 1e-10 );
  if ~isempty(nearnegone_p)
    PP(nearnegone_p) = -1;
  end
end

% Sort poles and zeros by frequency.
if dom_ndx == 1
  [ temp, sortndx ] = sort( abs(ZZ) );     %#ok<ASGLU>
  ZZ = ZZ(sortndx);
  [ temp, sortndx ] = sort( abs(PP) );     %#ok<ASGLU>
  PP = PP(sortndx);
else
  [ temp, sortndx ] = sort( abs(ZZ-1) );   %#ok<ASGLU>
  ZZ = ZZ(sortndx);
  [ temp, sortndx ] = sort( abs(PP-1) );   %#ok<ASGLU>
  PP = PP(sortndx);
end

% if ~isempty( strfind( architec,'closed') )
%   PZG(dom_ndx).CLZeroLocs = ZZ;
%   PZG(dom_ndx).CLPoleLocs = PP;
%   PZG(dom_ndx).CLGain = KK;
% end

% INCLUDE THE INPUT FUNCTION ZPK:
% The input poles and zeros appear at the TOPS of their vectors.
ZZ = [ input_zeros(:); ZZ ];
PP = [ input_poles(:); PP ];
KK = KK * input_gain;

[ resp_res, resp_poles, resp_direct ] = pzg_res( ZZ, PP, KK );

%if ( dom_ndx == 2 ) && isequal( input_zeros, 0 ) && isequal( input_poles, 1 )
%  resp_direct = resp_direct / PZG(2).Ts;
%end

return

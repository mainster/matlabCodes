function [ input_zeros, input_poles, input_gain ] = ...
               pzg_inzpk( SigType, Domain, freq_hz )
% Returns zpk-model of input, based on which input-type is selected,
% and what frequency (if sinusoid is selected).

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
input_zeros = [];
input_poles = [];
input_gain = 1;
if isempty(PZG) && ~pzg_recovr 
  return
end

if ~nargin ...
  ||( ~isequal( SigType, 1 ) ...
     && ~isequal( SigType, 2 ) ...
     && ~isequal( SigType, 3 ) ...
     && ~isequal( SigType, 4 ) ...
     && ~isequal( SigType, 5 ) )
  disp(' pzg_inzpk:  Input arg #1 error -- unrecognized signal type.')
  return
end

if ( nargin < 2 ) ...
  ||( ~isequal( Domain,'s') && ~isequal( Domain,'z') ...
     && ~isequal( Domain, 1 ) &&  ~isequal( Domain, 2 ) )
  disp(' pzg_inzpk:  Input arg #2 error -- unrecognized domain.')
  return
end

if isequal( SigType, 5 ) ...
  &&( ( nargin < 3 ) || ~isreal(freq_hz) ...
     || ~isequal( 1, numel(freq_hz) ) || ( freq_hz <= 0 ) )
  disp(' pzg_inzpk:  Input arg #3 error -- sinusoid frequency.')
  return
end

if isequal( Domain, 1 )
  Domain = 's';
elseif isequal( Domain, 2 )
  Domain = 'z';
end

switch SigType
  case 1
    % Unit impulse
    if strcmpi( Domain,'s')
      input_zeros = [];
      input_poles = [];
      input_gain = 1;
    else
      input_zeros = [];
      input_poles = [];
      input_gain = 1;
    end
  case 2
    % Unit step
    if strcmpi( Domain,'s')
      input_zeros = [];
      input_poles = 0;
      input_gain = 1;
    else
      input_zeros = 0;
      input_poles = 1;
      input_gain = 1;
    end
  case 3
    % Unit ramp
    if strcmpi( Domain,'s')
      input_zeros = [];
      input_poles = [ 0; 0 ];
      input_gain = 1;
    else
      input_zeros = 0;
      input_poles = [ 1; 1 ];
      input_gain = PZG(2).Ts;
    end
  case 4
    % Unit parabola
    if strcmpi( Domain,'s')
      input_zeros = [];
      input_poles = [ 0; 0; 0 ];
      input_gain = 1;
    else
      input_zeros = [ 0; -1 ];
      input_poles = [ 1; 1; 1 ];
      input_gain = 2*( PZG(2).Ts^2/2 );
    end
  case 5
    % Unit COSINE function    
    if strcmpi( Domain,'z')
      freq_hz = mod( freq_hz, 1/PZG(2).Ts );
      if freq_hz > 0.5/PZG(2).Ts
        freq_hz = 1/PZG(2).Ts - freq_hz;
      end
    end
    jwaxis_pt = 1i * freq_hz * 2*pi;
    if strcmpi( Domain,'s')
      input_zeros = 0;
      input_poles = [ jwaxis_pt; -jwaxis_pt ];
      input_gain = 1;
    else
      uc_pt = exp( jwaxis_pt * PZG(2).Ts );
      input_zeros = [ 0; cos( angle(uc_pt) ) ];
      input_poles = [ uc_pt; conj(uc_pt) ];
      input_gain = 1;
    end
  otherwise
end

return

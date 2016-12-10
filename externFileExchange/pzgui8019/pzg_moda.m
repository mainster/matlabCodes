function modalss = ...
             pzg_moda( PZGndx, purejordan, include_pade, include_prvw, ...
                       c2d2c, quiet )
% Converts the specified zpk-model to modal-canonic form, 
% possibly with Jordan blocks (if required for repeated poles):
%       modalss = pzg_moda( [], ZZ, PP, KK, Ts );
% An empty first argument is necessary as a "switch" to indicate that
% the function should not use the existing pzgui model, but instead use 
% the ZZ/PP/KK model supplied as input arguments.  If Ts argument is not
% included, function will assume it is a continuous-time model (Ts = 0).

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
modalss = [];
if isempty(PZG) && ~pzg_recovr 
  return
end

if isequal( PZGndx, 1 ) || isequal( PZGndx, 2 )
  if ~isstruct(PZG) ...
    ||~isfield(PZG,'PoleLocs') ...
    ||~isfield(PZG,'ZeroLocs') ...
    ||~isfield(PZG,'Gain')
    errdlg_h = ...
      errordlg( ...
        {'Cannot find a valid PZGUI data structure.'; ...
         'Return argument will be empty.'; ...
         ' ';'    Click "OK" to continue.'}, ...
        [mfilename ' Error'],'modal');
    uiwait(errdlg_h)
    return
  end
end

if ( nargin < 6 ) || ~isequal( 1, numel(quiet) ) ...
  ||( ~isnumeric(quiet) && ~islogical(quiet) )
  quiet = 0;
else
  quiet = ~isequal(0,quiet);
end

all_res = [];
all_poles = [];
direct = [];
Ts = 0;
if ~nargin
  errdlg_h = ...
    errordlg( ...
      {'Not enough input arguments for this function.'; ...
       ' ';'    Click "OK" to continue.'}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
elseif ~isempty(PZGndx) && ~isequal( PZGndx, 1 ) && ~isequal( PZGndx, 2 )
  errdlg_h = ...
    errordlg( ...
      {'Input argument "PZGndx" must be either 1 or 2.'; ...
       ' ';'    Click "OK" to continue.'}, ...
      [mfilename ' Error'],'modal');
  uiwait(errdlg_h)
  return
elseif isempty(PZGndx) ...
  &&( ( nargin == 4 ) ...
     ||( ( nargin >= 5 ) && isreal(c2d2c) && ( c2d2c >= 0 ) ) )
  % PZGndx, purejordan, include_pade, include_prvw, c2d2c
  [ all_res, all_poles, direct ] = ...
       pzg_res( purejordan, include_pade, include_prvw, [], quiet );
  %purejordan = 1;
  %include_pade = 0;
  %include_prvw = 0;
  if nargin >= 5
    %PZGndx = 2;
    Ts = c2d2c;
    %c2d2c = '';
  else
    %PZGndx = 1;
  end
  purejordan = 1;
  include_pade = 0;
  include_prvw = 0;
  c2d2c = '';
  quiet = 1;
else
  if ( nargin < 2 ) || isempty(purejordan)
    purejordan = 0;
  else
    purejordan = ~isequal( 0, purejordan );
  end

  if ( nargin < 3 ) || isempty(include_pade)
    include_pade = 0;
  else
    include_pade = ~isequal( 0, include_pade );
  end

  if ( nargin < 4 ) || isempty(include_prvw)
    include_prvw = '';
  elseif ~ischar(include_prvw)
    if isequal(include_prvw, 0 )
      include_prvw = '';
    else
      [ curr_tools, dsnfig_h, preview_on ] = pzg_tools(PZGndx);
      if ~preview_on || isempty(dsnfig_h)
        include_prvw = '';
      else
        if PZGndx == 1
          if curr_tools(1)
            include_prvw = 'sGain';
          elseif curr_tools(2)
            include_prvw = 'sLDLG';
          elseif curr_tools(3)
            include_prvw = 'sPID';
          else
            include_prvw = '';
          end
        else
          if curr_tools(1)
            include_prvw = 'zGain';
          elseif curr_tools(2)
            include_prvw = 'zLDLG';
          elseif curr_tools(3)
            include_prvw = 'zPID';
          else
            include_prvw = '';
          end
        end
      end
    end
  end

  if ( nargin < 5 ) || isempty(c2d2c) || ~ischar(c2d2c)
    c2d2c = '';
  end

  if nargin < 6
    quiet = 0;
  else
    quiet = ~isequal( quiet, 0 );
  end
end

if isequal( PZGndx, 2 ) ...
  &&( strcmpi( c2d2c,'zoh') ...
     || strcmpi( c2d2c,'bilinear') ...
     || strcmpi( c2d2c,'tustin') )
  [ all_res, all_poles, direct ] = pzg_c2d( c2d2c );
  if ( numel(PZG(1).ZeroLocs) < numel(PZG(1).PoleLocs) )
    direct = 0;
  end
  
elseif isequal( PZGndx, 1 ) ...
  &&( strcmpi( c2d2c,'zoh') ...
     || strcmpi( c2d2c,'bilinear') ...
     || strcmpi( c2d2c,'tustin') )
  [ all_res, all_poles, direct ] = pzg_d2c( c2d2c );
  if ( numel(PZG(2).ZeroLocs) < numel(PZG(2).PoleLocs) )
    direct = 0;
  end
  
elseif isempty(all_res) && ~isempty(PZGndx)
  [ all_res, all_poles, direct ] = ...
      pzg_res( PZGndx, include_pade, include_prvw, [], quiet );
  if ( numel(PZG(PZGndx).ZeroLocs) < numel(PZG(PZGndx).PoleLocs) )
    direct = 0;
  end
end

if isempty(all_res) && isempty(all_poles) && isempty(direct)
  modalss = ss;
  if ~quiet
    errdlg_h = ...
      errordlg( ...
        {'Unable to obtain a state-space model of the system.'; ...
        ' '; ...
         'There might be so many repeated poles'; ...
         'that computation of the residues is ill-conditioned,'; ...
         'or there might be poles at z = -1.'; ...
         ' ';'    Click "OK" to continue.'}, ...
        [mfilename ' Error'],'modal');
    uiwait(errdlg_h)
  end
  return
end  

D = 0;
if ~isempty(direct)
  D = direct;
end

if isempty(all_poles)
  modalss = ss(D);
  return
else
  % Sort the poles by frequency, from lowest to highest.
  % First, sort out the real-valued poles.
  rp_ndxs = find( abs(imag(all_poles)) < 1e-14 );
  nrp_ndxs = setdiff( (1:numel(all_poles))', rp_ndxs );
  real_poles = all_poles(rp_ndxs);
  rp_res = all_res(rp_ndxs);
  for kc = numel(rp_res):-1:1
    if ( kc == numel(rp_res) ) ...
      ||( real_poles(kc) ~= real_poles(kc+1) )
      cancel_ndx = ...
        find( ( abs(rp_res) < 1e-14*max(abs(rp_res)) ) | ( rp_res == 0 ) );
      if any( cancel_ndx == kc )
        real_poles(kc) = [];
        rp_res(kc) = [];
      end
    end
  end  
  nonreal_poles = all_poles(nrp_ndxs);
  nrp_res = all_res(nrp_ndxs);
  for kc = numel(nrp_res):-1:1
    if ( kc == numel(nrp_res) ) ...
      ||( nonreal_poles(kc) ~= nonreal_poles(kc+1) )
      cancel_ndx = ...
        find( ( abs(nrp_res) < 1e-14*max(abs(nrp_res)) ) | ( nrp_res == 0 ) );
      if any( cancel_ndx == kc )
        nonreal_poles(kc) = [];
        nrp_res(kc) = [];
      end
    end
  end
  % Sort the poles by frequency.
  if PZGndx == 1
    [ sortjunk, sortndx ] = sort( real_poles ); %#ok<ASGLU>
    real_poles = real_poles(sortndx);
    rp_res = rp_res(sortndx);
    [ sortjunk, sortndx ] = sort( abs(imag(nonreal_poles)) ); %#ok<ASGLU>
    nonreal_poles = nonreal_poles(sortndx);
    nrp_res = nrp_res(sortndx);
  else
    [ sortjunk, sortndx ] = sort( -abs(1-real_poles) ); %#ok<ASGLU>
    real_poles = real_poles(sortndx);
    rp_res = rp_res(sortndx);
    [ sortjunk, sortndx ] = sort( abs(angle(nonreal_poles)) ); %#ok<ASGLU>
    nonreal_poles = nonreal_poles(sortndx);
    nrp_res = nrp_res(sortndx);
  end
  all_poles = [ nonreal_poles; real_poles ];
  all_res = [ nrp_res; rp_res ];
  
  if ~isequal( numel(all_poles), numel(unique(all_poles)) )
    A = diag(all_poles);
    B = all_res(:);
    C = ones(size(all_res(:)))';
    for k = 1:numel(all_res)
      if ~isequal( all_res(k), 0 ) ...
        && isequal( 1, sum( abs( all_poles - all_poles(k) ) < 1e-14 ) )
        B(k) = B(k) / sqrt( abs(all_res(k)) );
        C(k) = sqrt( abs(all_res(k)) );
      elseif isequal( all_res(k), 0 )
        B(k) = 0;
        C(k) = 0;
      end
    end
  else
    A = diag(all_poles);
    B = all_res;
    B( all_res ~= 0 ) = ...
      all_res( all_res ~= 0 ) ./ sqrt( abs(all_res( all_res ~= 0 )) );
    C = sqrt( abs(all_res(:)) )';
  end
  
  % Create Jordan blocks for repeated poles.
  for k = 2:size(A,1)
    if A(k,k) == A(k-1,k-1)
      if ( k < 3 ) || ( A(k,k) ~= A(k-2,k-2) )
        Ts_exp = 1;
      end
      A(k-1,k) = 1;
      % Handle discrete-time multiple-integrators (accumulators).
      if isequal( PZGndx, 2 ) && ~purejordan ...
        &&( abs( A(k,k) - 1 ) < 1e-10 )
        if ( k > 2 ) && ( A(k-2,k-1) ~= 0 )
          Ts_exp = Ts_exp * PZG(2).Ts;
        else
          Ts_exp = PZG(2).Ts;
        end
        A(k-1,k) = PZG(2).Ts;
        B(k) = B(k)/Ts_exp;
      end
      C(k) = 0;
    end
  end
  % Transform to a real-valued state-space model.
  if size(A,1) > 1
    block_ndxs = 1 + find( diag(A,1) ~= 0 );
  else
    block_ndxs = [];
  end
  nonblock_ndxs = (1:size(A,1));
  if ~isempty(block_ndxs)
    blocks = cell(size(block_ndxs));
    ndx = 1;
    blocks{1} = [ block_ndxs(1)-1; block_ndxs(1) ];
    for k = 2:numel(block_ndxs)
      if block_ndxs(k) == (1+block_ndxs(k-1))
        blocks{ndx} = [ blocks{ndx}; block_ndxs(k) ];
      else
        ndx = ndx+1;
        blocks{ndx} = [ block_ndxs(k)-1; block_ndxs(k) ];
      end
    end
    if ndx < numel(blocks)
      blocks(ndx+1:end) = [];
    end
    for k = 1:numel(blocks)
      nonblock_ndxs = setdiff( nonblock_ndxs, blocks{k} );
    end

    for k = 1:numel(blocks)
      start_ndx = blocks{k}(1);
      block_size = numel(blocks{k});
      if ~isreal( all_poles(start_ndx) ) ...
        &&( start_ndx > 1 ) ...
        &&( abs( all_poles(start_ndx)-conj(all_poles(start_ndx-1)) ) ...
            /max(1,abs(all_poles(start_ndx))) < 1e-13 )
        continue
      end
      block_eig = A(start_ndx,start_ndx);
      C(start_ndx) = 1;
      if ~isreal( block_eig ) && ( k < numel(blocks) )
        % Check that the next block is the complex-conjugate.
        next_block_size = numel(blocks{k+1});
        next_start_ndx = blocks{k+1}(1);
        next_block_eig = A(next_start_ndx,next_start_ndx);
        if ( abs( block_eig - conj(next_block_eig) ) < 1e-15 ) ...
          && isequal( block_size, next_block_size )
          T_sub = [ (1-1i)/2 (1+1i)/2; (1+1i)/2 (1-1i)/2 ];
          Tx = zeros(2*block_size);
          T_rowcol = zeros(2*block_size);
          for k_rc = 1:block_size
            Tx( 2*k_rc-1:2*k_rc, 2*k_rc-1:2*k_rc ) = T_sub;
            T_rowcol( 2*k_rc-1, k_rc ) = 1;
            T_rowcol( 2*k_rc, block_size+k_rc ) = 1;
          end
          Andxs = [ blocks{k}; blocks{k+1} ];
          A(Andxs,Andxs) = T_rowcol * A(Andxs,Andxs) * T_rowcol';
          A(Andxs,Andxs) = Tx' * A(Andxs,Andxs) * Tx;
          nz_ndxs = find( abs(A(:)) > 1e-12 );
          for ka = 1:numel(nz_ndxs)-1
            equiv_ndxs = find( abs( A(nz_ndxs(ka)) - A(nz_ndxs) ) < 1e-12 );
            if numel(equiv_ndxs) > 1
              A(nz_ndxs(equiv_ndxs)) = A(nz_ndxs(ka));
            end
          end
          % Scale B and C to equalize the block-norms.
          if isequal( sum( C(:,Andxs) == 1 ), 2 ) ...
            && isequal( sum( C(:,Andxs) == 0 ), numel(Andxs)-2 ) ...
            && ( numel(Andxs) > 2 )
              newC = flipud( B(Andxs,:) )';
              newB = fliplr( C(:,Andxs) )';
              B(Andxs,:) = newB;
              C(:,Andxs) = newC;
          end
          B(Andxs,:) = T_rowcol * B(Andxs,:);
          B(Andxs,:) = Tx' * B(Andxs,:);
          C(:,Andxs) = C(:,Andxs) * T_rowcol';
          C(:,Andxs) = C(:,Andxs) * Tx;
        end
      else
        Andxs = blocks{k};
        if ( numel(Andxs) > 1 ) ...
          && isequal( C(:,Andxs), [ 1, zeros(1,numel(Andxs)-1) ] )
          newC = flipud( B(Andxs,:) )';
          newB = fliplr( C(:,Andxs) )';
          B(Andxs,:) = newB;
          C(:,Andxs) = newC;
        end
      end
    end
  end
  
  % Make sure complex-conjugate pairs that are not in blocks
  % get transformed to real-valued submatrices.
  T2x2 = [ (1-1i)/2 (1+1i)/2; (1+1i)/2 (1-1i)/2 ];
  for k = 1:numel(nonblock_ndxs)-1
    ndx1 = nonblock_ndxs(k);
    ndx2 = nonblock_ndxs(k+1);
    if ( ndx2 == ( ndx1 + 1 ) ) ...
      &&~isreal( A(ndx1,ndx1) ) ...
      &&( abs( A(ndx1,ndx1) - conj(A(ndx2,ndx2)) ) < 1e-14 )
      A(ndx1:ndx2,ndx1:ndx2) = ...
          T2x2' * A(ndx1:ndx2,ndx1:ndx2) * T2x2;
      A(ndx1,ndx1) = A(ndx2,ndx2);
      A(ndx2,ndx1) = -A(ndx1,ndx2);
      B(ndx1:ndx2,:) = T2x2' * B(ndx1:ndx2,:);
      C(:,ndx1:ndx2) = C(:,ndx1:ndx2) * T2x2;
    end
  end
end

if isequal(numel(unique(all_poles)), numel(all_poles) )
  % Equalize norms of B and C
  normB = norm(B);
  normC = norm(C);
  if ~isequal( normB, 0 ) && ~isequal( normC, 0 )
    normBC = sqrt( normB * normC );
    B = B/normB*normBC;
    C = C/normC*normBC;
  end
end

if isequal( PZGndx, 1 ) || ( isempty(PZGndx) && ( Ts == 0 ) )
  modalss = ss( A, B, C, D );
  if ( PZG(1).PureDelay > 0 ) && ~include_pade
    modalss.InputDelay = PZG(1).PureDelay;
  end
else
  if isequal( PZGndx, 2 ) && ~isempty( PZG )
    Ts = PZG(2).Ts;
    modalss = ss( A, B, C, D, Ts );
    if ( PZG(2).PureDelay > 0 ) && ~include_pade
      modalss.InputDelay = PZG(2).PureDelay;
    end
  else
    modalss = ss( A, B, C, D, Ts );
  end
end

return

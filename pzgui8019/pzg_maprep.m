function [ hndl, mod_hndl ] = pzg_maprep( all_z_or_p, rep_type, hndl )
  mod_hndl = 0;
  if ( nargin < 3 ) ...
    || ~isnumeric(all_z_or_p) || ~ischar( rep_type ) ...
    ||( ~strcmp( rep_type,'pole') && ~strcmp( rep_type,'zero') ) ...
    || ~isstruct(hndl) ...
    || ~isfield( hndl,'ax')
    return
  end
  
  all_z_or_p = all_z_or_p(:);
  
  if ~isfield( hndl,[ rep_type '_repstr_h'])
    hndl.([ rep_type '_repstr_h']) = [];
  end
  these_str_h = hndl.([ rep_type '_repstr_h']);
  
  if isempty(all_z_or_p)
    delete(these_str_h)
    hndl.([ rep_type '_repstr_h']) = [];
    return
  end
  
  % Find the repeated poles (or zeros), and determine the number of repetitions.
  unq_z_or_p = [];
  nr_reps = [];
  for k1 = 1:numel(all_z_or_p)
    this_z_or_p = all_z_or_p(k1);
    if isempty(unq_z_or_p)
      unq_z_or_p = this_z_or_p;
      nr_reps = 1;
    else
      [ min_dist, min_dist_ndx ] = min( abs( this_z_or_p - unq_z_or_p ) );
      if min_dist > 1e-12
        unq_z_or_p(end+1) = this_z_or_p;       %#ok<AGROW>
        nr_reps(end+1) = 1;                                  %#ok<AGROW>
      else
        nr_reps(min_dist_ndx) = nr_reps(min_dist_ndx) + 1;   %#ok<AGROW>
      end
    end
  end
  rep_ndxs = find( nr_reps > 1 );
  reps = nr_reps(rep_ndxs)';
  rep_z_or_p = unq_z_or_p(rep_ndxs).';
  
  if ~isequal( numel(these_str_h), numel(rep_z_or_p) ) ...
    || ~isequal( numel(these_str_h), ishandle(rep_z_or_p) )
    delete(these_str_h)
    these_str_h = [];
    hndl.([ rep_type '_repstr_h']) = [];
    mod_hndl = 1;
  end
  
  bg_color = get( hndl.ax,'color');
  if sum(bg_color) == 0
    fg_color = [ 0.9 0.9 0.9 ];
  else
    fg_color = [ 0.1 0.1 0.1 ];
  end
  if isempty(these_str_h)
    % Create new text objects
    for k = 1:numel(rep_z_or_p)
      these_str_h(end+1) = ...
        text( real(rep_z_or_p(k)), imag(rep_z_or_p(k)), ...
          ['  (' num2str(reps(k)) ')'], ...
          'parent', hndl.ax, ...
          'backgroundcolor','none', ...
          'color', fg_color, ...
          'tag', [ rep_type '_repstr_h']);     %#ok<AGROW>
    end
  else
    for k = 1:numel(these_str_h)
      set( these_str_h(k), ...
          'string', ['  (' num2str(reps(k)) ')'], ...
          'position', [ real(rep_z_or_p(k)), imag(rep_z_or_p(k)), 0 ], ...
          'parent', hndl.ax, ...
          'backgroundcolor','none', ...
          'color', fg_color, ...
          'tag', [ rep_type '_repstr_h']);
    end
  end
  
  hndl.([ rep_type '_repstr_h']) = these_str_h;
  
return

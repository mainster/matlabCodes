function F = fourierS(fun,varargin)
%% Fourier function overload to evaluate simplify( fourier(..))
%fun=@(t,w,x) t*w*x;

%trans_var,eval_point
if nargin > 3
    error('Too much input arguments!')
end

func=char(fun);

if isa(fun,'function_handle')
    argBraket(1) = min(strfind(func,'('));
    argBraket(2) = min(strfind(func,')'));

%    evalin('caller',['assumptions([' strjoin(symvar(func)',' ') '])']);
%    FUN=( ['fun',  func(argBraket(1):argBraket(2))] );
    funNoArg = func(argBraket(2)+1:end);
end

%%
if nargin > 2
  % Check for the eval domain, w is default 
  cv2 = char(varargin{2});
  SW = find(strcmp(cv2,{'w','w0','f','f0','2*pi*f','2*pi*f0'}));
  
  switch SW
      case {3,4}

          fprintf([ 
            '\nThe default eval_point of builtin fourier(..) is the '...
            'angular frequency w_.'...
            '\nTo suppress this message, already input the substitution as '...
            'eval_point when calling this function.'...
            '\n-----------------------------------'...
            '\n%s will be substituted by 2*pi*%s'...
            '\n-----------------------------------\n\n'], cv2, cv2)
      otherwise
  end
    
  EVALINBASE = sprintf('simplify(fourier(%s,%s,%s),''steps'',150)',...
                        funNoArg,  char(varargin{1}), char(varargin{2}) );    
else
    if nargin > 1
        EVALINBASE = sprintf('simplify(fourier(%s,%s),''steps'',150)',...
                            funNoArg,  char(varargin{1}) );    
    else
        EVALINBASE = sprintf('simplify(fourier(%s),''steps'',150)',...
                            funNoArg );    
    end
end

fprintf('\neval in base:  %s', EVALINBASE)
fprintf('\n-------------\n')

if (nargin == 4) && strcmpi(varargin{3}, 'handle')
    FF = evalin('base', EVALINBASE);
    sv=symvar(FF);
    st='@(';
    for k=1:length(sv)
        st = [st char(sv(k))];
        if k<length(sv)
            st = [st ','];
        else
            st = [st ')'];
        end
    end
    
    st
else
    F = evalin('base', EVALINBASE);    
end

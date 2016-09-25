%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% classify2bit.m                                                         @@@MDB
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Klassifizierung der Abtastwerte von wave- Sequenzen in rel.
% min/max, rising, falling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [seqOut] = classify2bit(seqIn)

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%  Testsignal (in base erzeugen)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if 0
    ts = 10e-3;
    tt=[0:ts:1];
    f0=1;
    seqTest=sin(2*pi*f0*tt);
    
    seq1=classify2bit(seqTest);
    stem(seqTest); hold all; grid on;
    stem(seq1);
    hold off;
end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calc 1. order derivative by diff() or by convolution kernel [1,-1]
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % calc 2. order derivative:
    %   - diff(diff()) or 
    %   - convolution kernel [1,-2,1] or
    %   - finite difference approximation del2() of Laplace's 
    %     differential operator
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ds = diff(MxN(1,:)) / max(diff(MxN(1,:))); 
    % d2s = del2(MxN(1,:)) / max(del2(MxN(1,:)));   

%     ds = diff(MxN(1,:)) / size(MxN,2); 
%     d2s = del2(MxN(1,2:end)) / size(MxN,2);   
    deriv1 = conv(seqIn(1,1:end-2),[1, -1]) / size(seqIn,2); 
    deriv2 = conv(seqIn(1,2:end-2), [1, -2, 1]) / size(seqIn,2);   

    if 0
        fprintf('size MxN :\t%i\n', size(MxN));
        fprintf('size ds :\t%i\n', size(ds));
        fprintf('size Gds:\t%i\n', size(Gds));
        fprintf('size d2s:\t%i\n', size(d2s));
        fprintf('size G2s:\t%i\n', size(Gd2s));
    end
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Find zeros, create index vector (>0 ; <0)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    n=size(seqIn,2);
    zero{1}=find(seqIn(1,1:n-1).*seqIn(1,2:n)<0)';
    idx{1} = {  find( (seqIn(1,1:end-1)<0) & (deriv1>0) )',...
                find( (seqIn(1,1:end-1)<0) & (deriv1<0) )' };
%                find( (MxN(1,1:end-1)<0) & (ds<0) )' };

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Find zero crossing of second derivative
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    n=size(deriv1,2);
    zero{2}=find(deriv1(1,1:n-1).*deriv1(1,2:n)<0)';
    % idx{2}{1}([ für > 0])  //  idx{2}{2}([ für < 0]
    idx{2} = {  find( (deriv1(1,:)<0) & (deriv2(1:end)>0) )',...
                find( (deriv1(1,:)<0) & (deriv2(1:end)<0) )' };

    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % start classifying, output to sequenz seq
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %               | Code |
    % --------------+------+
    % Rising edge   |   1  |
    % Falling edge  |  -1  |
    % Rel. maximum  |   2  |
    % Rel. minimum  |  -2  |
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    slopes = (deriv1 > 0) -(deriv1 < 0);                
    seq = slopes;
    seq(zero{2}) = -2*deriv2(zero{2})./abs(deriv2(zero{2}));
    
    if cellfun(@isempty,(idx{1}))
        error('1st derivative has no zero crossings?!')
    end    
    if cellfun(@isempty,(idx{2}))
        error('2nd derivative has no zero crossings?!')
    end
   
    if nargout >= 0
        seqOut = seq;
    end

end
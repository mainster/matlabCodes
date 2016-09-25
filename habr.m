function varargout = habr (varargin)
%% [MINSUM C TR Y] = habr(MATRIX)     @@@MDB
% 
% Testimplementierung von "Ungarische Methode" ( Kuhn-Munkres-Algorithmus )
% Die Frequenzmethode nach Habr et al.
%
% MINSUM:           Minimale Summe 
% C:                Zeilenvektor mit Spaltenminima
% TR:               Indizes zu minima- Elementen in Y (Transversale von Y)
% Y:                Ausgangsmatrix 
%
% http://de.wikipedia.org/wiki/Ungarische_Methode

clear A Y
if isnumeric(varargin{1}) 
    A = varargin{1};
else
    error('No matrix')
end
%     A(end+1,1:end)=mean(A,1);
%     A(1:end,end+1)=mean(A,2);
% 
%     disp(A)

    % for z=1:4
    %     for s=1:4
    %         Y2(z,s)=A(z,s)-A(z,end)-A(end,s)+mean(A(:));
    %     end
    % end

    if ~(size(A,1) == size(A,2))
        error('not a square matrix')
    end
    if size(A,1) > 4
        Y=A-repmat(mean(A,2),1,5)-repmat(mean(A,1),5,1)+mean(A(:));
    else
        Y=A-repmat(mean(A,2),1,4)-repmat(mean(A,1),4,1)+mean(A(:));
    end
%    Y=A-repmat(mean(A,2),1,size(A,2))-repmat(mean(A,1),size(A,1),1)+mean(A(:));

    [C,idCol]=min(Y,[],1);
    [~,idRow]=min(Y,[],2);
    minsum = sum(C);

    if nargout >= 0
        varargout{1} = minsum;
    end
    if nargout >= 2
        varargout{2} = C;
    end
    if nargout >= 3
        varargout{3} = {idCol,idRow};
    end
    if nargout >= 4
        varargout{4} = Y;
    end
    return;
end
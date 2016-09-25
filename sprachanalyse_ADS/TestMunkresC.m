function TestMunkresC
%% Testen / Vergleichen der Ausgangsmatrizen von Matlab habr / munkres und
% dem Cpp Projekt

global assign cost 
global MINSUM C TR Y
ds = evalin('base','ds');
clc;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Assignment problem is represented by the COSTMAT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
COSTMAT = rand(15);

% generate C- conform array COSTARRAY of COSTMAT 
fprintf('\n\n%s\nTEST\n\n',ds)
COSTARRAY = [sprintf('#define ROWS %i \n#define COLS %i \nint r[ROWS*COLS] = {',...
                size(COSTMAT,1),size(COSTMAT,2)), mprintf(COSTMAT,'\t%2g,'), '};' ];
COSTARRAY = strrep(COSTARRAY, ',};', sprintf('\n\t};'));

%disp(COSTARRAY)
% Copy COSTARRAY into clipboard
clipboard('copy', COSTARRAY);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply habr algorithm (@@@MDB) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
[MINSUM, C, TR, Y] = habr(COSTMAT);
endHabr = toc;

assignHabr = zeros(length(TR{1,1}),length(TR{1,2}));
assIdx = [TR{1,2}, TR{1,1}'];

for nn=1:size(assIdx,1)
	assignHabr(assIdx(nn,1), assIdx(nn,2)) = 1;
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Apply munkres algorithm
% (http://csclab.murraystate.edu/bob.pilgrim/445/munkres.html)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;
[assign, cost]=munkres(COSTMAT);
endMunk = toc;

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot results
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('%s\n%s\nCOSTMAT (input matrix):\n',ds,ds)
mfprintf(COSTMAT, '\t%2g')

if max(size(COSTMAT)) < 20
    fprintf('%s\nY (habr):\n',ds)
    mfprintf(Y, ' %2g')
    fprintf('\nMINSUM (habr):\n%g\n',MINSUM)
    fprintf('\nTransversal (habr):\n')
    mfprintf([TR{1,2}, TR{1,1}'], '\t%2g')
    fprintf('%s\nAssign matrix (habr):\n',ds)
    mfprintf(assignHabr, '\t%2g')

    fprintf('%s\nAssign (munkres):\n',ds)
    mfprintf(assign, '\t%2g')
end

fprintf('%s\nAssign (munkres) - Assign matrix (habr):\n',ds)
mfprintf(assign - assignHabr, '\t%2g')
    
fprintf('%s\ncost (munkres):\n',ds)
mfprintf(cost, '\t%2g')

% define global variables in base workspace
evalin('base','global assign cost');
evalin('base','global MINSUM C TR Y');

end
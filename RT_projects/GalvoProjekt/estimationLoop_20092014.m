function [EST] = estimationLoop (varargin)
% ------------------------------------------------------------------------
% ----- Loop estimation 
% ------------------------------------------------------------------------
FILES = varargin{1};
sigName = varargin{2}; 

% defauls
intVect=[1 10e6];
pv=[[1 0];[1 1];[2 0]];


if nargin > 2
    intVect = varargin{3};
end

if nargin > 3
  	pv = varargin{3};
end


invokeNames = 0;


    for NN=1:1
    %     if invokeNames
    %         sigName=sprintf('auto:%i',NN);
    %     end

        cl=clock;
        timeAndDate=sprintf('Date: %i-%i-%i\tTime: %i:%i:%i', fliplr(cl(1:3)), round(cl(end-2:end)));
        clear G0;

        EST=struct;

        ds='---------------------------------------------------';
        disp(sprintf('\n\n%s\n\t Start frequency response - model estimation\n\t\t%s \n%s',...
            ds, timeAndDate, ds))
        disp(sprintf('%s\n%s\n', FILES{1},ds))

        DUMMY='DUMMY';
        for k=1:length(pv(:,1))
            disp(sprintf('%s\npz vector: [%i %i]\t\t(...)',ds , pv(k,:)))
            tt1=tic;
        %     sigNameField = strrep(sigName,'(','_');
        %     sigNameField = strrep(sigNameField,')','');
            if invokeNames
                [EST.(DUMMY){k,1} sigNameInv ErrorFlag] = idSpice( FILES{1}, sigName, intVect,...
                        pv(k,:), '0');
            else
                [EST.(DUMMY){k,1} sigNameInv ErrorFlag] = idSpice( FILES{1}, 'V(out_a)', intVect,...
                        pv(k,:), '0');
                sigNameInv = 'V(out_a)';
            end

            ttSpent = toc(tt1);
            disp(sprintf('Freq response estimation done!\nFits: *** %.3f%% ***\t\ttime spent: %.2fs',...
                        EST.(DUMMY){k,1}.Report.Fit.FitPercent, ttSpent))
            EST.(DUMMY){k,2}=sprintf('[%i %i]', pv(k,:));
            EST.(DUMMY){k,3}=sprintf('%.1f %.1e',intVect);
            EST.(DUMMY){k,4}=sprintf('%.2f%%',EST.(DUMMY){k,1}.Report.Fit.FitPercent);
            EST.(DUMMY){k,5}=sprintf(FILES{1});
            EST.(DUMMY){k,6}={ ['[' num2str(EST.(DUMMY){k}.num(1,:),'%.2e  ') ']'],...
                            ['[' num2str(EST.(DUMMY){k}.den(1,:),'%.2e  ') ']']};
            EST.(DUMMY){k,7}=sprintf(sigNameInv);
            EST.(DUMMY){k,8}=timeAndDate;
            EST.(DUMMY){:};
            if ErrorFlag ~= 0
                break
            end
        end

        if invokeNames
        %%%%%% copy and rename field DUMMY to the signal name returned by idSpice()
           [EST.(sigNameInv)] = EST.DUMMY
            EST = rmfield(EST, DUMMY);
        else
            [EST.(sigName)] = EST.DUMMY
            EST = rmfield(EST, DUMMY);
        end

        if ~exist('Gl','var')
            load('estimationLoop.m','-mat','Gl');
            disp('Gl loaded')
        end
        EST.(sigNameInv){:,end};

        Gl{end+1}=EST.(sigNameInv);

    end


end
function renameWaveFiles(PATH_TO_WAVES, NEWNAME)

if ischar(PATH_TO_WAVES)
    ls = struct2cell(dir(PATH_TO_WAVES));

    for k=1:length(NEWNAME)
        idx(k) = find(~cellfun(@isempty,strfind(ls(1,:),sprintf('_%i', k))));
    end

    for k=1:length(NEWNAME)
        copyfile(fullfile(PATH_TO_WAVES, ls{1,idx(k)}), fullfile(PATH_TO_WAVES, [NEWNAME{k}, '.wav']));
    end

    dir(PATH_TO_WAVES)
else
    assignin('base','outss',[1:5])
end

end
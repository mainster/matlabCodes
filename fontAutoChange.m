function fontAutoChange (handle)

fontListv=listfonts;

th = findall(handle,'type','text');

for k=1:length(fontListv)
    set(th,'FontName',fontListv{k});
    fprintf(['FontName: %s\t size: ' repmat('%i ',1,length(th)) '\n'],...
        fontListv{k},cell2mat(get(th,'FontSize')))
    drawnow;
    delayWait(1);
    
end
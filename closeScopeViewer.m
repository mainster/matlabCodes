function closeScopeViewer ()
    shh = get(0,'ShowHiddenHandles');
    set(0,'ShowHiddenHandles','On');
    hscope = findobj(0,'Type','Figure','Tag','SIMULINK_SIMSCOPE_FIGURE');
    close(hscope);
    hscope = findobj(0,'Type','Figure','Tag','spcui_scope_framework');
    close(hscope);
    set(0,'ShowHiddenHandles',shh);
end
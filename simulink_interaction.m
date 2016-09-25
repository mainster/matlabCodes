%%%%% Interaction to simulink models
%%
if 0
    saveas(get_param('GalvoModel_v3_detailed','Handle'),...
                     'topmodel.bmp');
    saveas(get_param('GalvoModel_v3_detailed','Handle'),...
                     'topmodel.pdf');
    saveas(get_param('GalvoModel_v3_detailed','Handle'),...
                     'topmodel.png');
    saveas(get_param('GalvoModel_v3_detailed','Handle'),...
                     'topmodel.tif');
                 
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Schriftgröße usw. ändern
%%
if 1
    clear open_bd ind del
    open_bd = find_system('type', 'block_diagram')
    
    ind = [ find(~cellfun(@isempty, strfind(lower(open_bd),'galvo')));...
            find(~cellfun(@isempty, strfind(lower(open_bd),'current')));...
            find(~cellfun(@isempty, strfind(lower(open_bd),'labview'))) ];
    
    open_bd(ind)
        
%    ind=find(~cellfun(@isempty, strfind(open_bd,'GalvoModel_v31_19082014')))
    if isempty(ind)
        disp('blockdiagrams not found')
        return
    end
    
    blocks = find_system(open_bd(ind),'Type','Block');
    lines = find_system(open_bd(ind),'FindAll', 'on', 'Type', 'line');  %, 'Name', 'w');
    sigO = get_param(lines, 'Object');
    sigStr = cellfun(@get, sigO)
    
	sigMat=cell2mat(sigO);
	
    for k=1:length(sigStr)
% falls schon (s) dran steht, gleich wegschneiden
		nam = strsplit( get(sigO{k},'Name'), '(s)' );
		nam = strtrim(nam{1});
% 		if ~(	strcmp(get(sigO{k},'Name'),'') ||...
% 				~isempty(strfind(get(sigO{k},'Name'),'(s)') )) 
		if ~(strcmp(get(sigO{k},'Name'),''))
			set(sigO{k},'Name',sprintf('%s',nam));
		end
		
        set(sigO{k},'Fontsize','10',...
					'FontWeight','bold',...
					'FontAngle','normal');
    end
    save_system(open_bd(ind));
    
    return
end
%%
if 0
    %%% Hintergrundfarbe bei subsytemen ohne subblöcke ändern
	open_bd = find_system('type', 'block_diagram');
    ind=find(~cellfun(@isempty, strfind(open_bd,'GalvoModel_v3_detailed')))
    if ~isempty(ind)
        blocks=find_system(open_bd(ind),'Type','Block');
        blocks=find_system(open_bd(ind),'Type','Block');
    else
        disp('blockdiagram not found')
        return
    end
    
    BlockTypes = get_param(blocks,'BlockType');
    indSub=find(~cellfun(@isempty, strfind(lower(BlockTypes), 'subsystem')))
    BlockObj = get_param(blocks(indSub), 'Object')

    BlockObj=cell2mat(BlockObj);     % in matrix umwandeln

    col={'[.8 .8 .8]','[.8 .8 .8]'}
    
    % cells mit den Blöcken der subsysteme listen und an isempty übergeben
    % Nur subsysteme ohne unterblöcke indexieren
    indSub1=find(cellfun(@isempty, get(BlockObj,'Blocks'))) 
    for k=1:length(indSub1)
        BlockBackCol{k,1} = BlockObj(k).BackgroundColor
        BlockObj(indSub1(k)).BackgroundColor=col{1}
    end
    
%    set_param(blocks(indSub1(1)), 'Object')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%% find annotations
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    hAnn=find_system(open_bd(ind),'FindAll', 'on','Type','Annotation')   
    set(hAnn(:),'BackgroundColor','gray')
    set(hAnn,'FontName','Arial')
    set(hAnn,'BackgroundColor', col{2} )
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    return
end
% -------------------------
%setWrap=@(x)set(x,'Fontsize','12','FontWeight','bold');

if 0
    sys1='GalvoModel_v3_blockumbau_noCC';
    %    sigH = find_system(sys1,'FindAll', 'on', 'Type', 'line');
    sigH = find_system('FindAll', 'on', 'Type', 'line');
    sigO = get_param(sigH(:), 'Object');

    for k=1:length(sigO)
        set(sigO{k},'Fontsize','12','FontWeight','bold')
    end
        save_system(sys1);
	return
end

if 0
    open_bd = find_system('type', 'block_diagram');
    ind=find(~cellfun(@isempty, strfind(open_bd,'blockumbau')))
    if ~isempty(ind)
        blp=find_system(open_bd(ind),'Type','Block');
        blp=find_system(open_bd(ind),'Type','Block');
    else
        disp('blockdiagram not found')
    %    open ('GalvoModel_v3_tfCCneu');
    end

    bt = get_param(blp,'BlockType')
    bs = get_param(blp,'Signals' )
    %    par = get_param(st(5),bt{5})
    return
end





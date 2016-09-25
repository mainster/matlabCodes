function gcef
   %% GCEF get path of current active file in matlab editor
   
   try
      % Matlab 7
      desktop = com.mathworks.mde.desk.MLDesktop.getInstance;
      jEditor = desktop.getGroupContainer('Editor').getTopLevelAncestor;
      % we get a com.mathworks.mde.desk.MLMultipleClientFrame object
   catch
      % Matlab 6
      % Unfortunately, we can't get the Editor handle from the Desktop handle in Matlab 6:
      %desktop = com.mathworks.ide.desktop.MLDesktop.getMLDesktop;
      
      % So here's the workaround for Matlab 6:
      openDocs = com.mathworks.ide.editor.EditorApplication.getOpenDocuments;  % a java.util.Vector
      firstDoc = openDocs.elementAt(0);  % a com.mathworks.ide.editor.EditorViewContainer object
      jEditor = firstDoc.getParent.getParent.getParent;
      % we get a com.mathworks.mwt.MWTabPanel or com.mathworks.ide.desktop.DTContainer object
   end
   

   
   % Alternative #1:
   edhandle = com.mathworks.mlservices.MLEditorServices;
   allEditorFilenames = char(edhandle.builtinGetOpenDocumentNames);
   
   % Alternative #2:
   openFiles = desktop.getWindowRegistry.getClosers.toArray.cell;
   allEditorFilenames = cellfun(@(c)c.getTitle.char,openFiles,'un',0);
   
end
function smartIndentDoc(varargin)
   %% SMARTINDENTDOC could be used to change/apply smart indention settings of script- and function documents
   
   if ~ischar(varargin{1})
      error('First argument must be a string that contains path/filename')
   else
      FILE = fullfile(which(varargin{1})); %, varargin{1})
   end
   
   % Check if file exists and has write permissions
   [a,b,~]=fileattrib(FILE);
   
   if ~a
      error('File %s does not exist')
   else
      if ~b.UserWrite
         error('No write permission for file %s')
      end
   end
   
   h = matlab.desktop.editor.openDocument(FILE);
   h.smartIndentContents;
   h.save;
   
   if nargin > 1 && strcmpi(varargin{2},'close')
      h.close;
   end
end
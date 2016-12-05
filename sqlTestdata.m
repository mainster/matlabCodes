function sqlTestdata (NNN, sqlDriver, varargin)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Erzeugen von testdaten SQL database - worktime - 09-02-2016
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clearvars('-except',INITIALVARS{:})
DRIVER = -1;

if strfind(sqlDriver, 'sqlite')
   DRIVER = 1;
else
   if strfind(sqlDriver, 'mysql')
      DRIVER = 2;
   else
      error('Unknown driver string, halt');
   end
end

lead = {
   'INSERT INTO "worktime" (dat, workerID, prjID, hours) VALUES (';
   'INSERT INTO worktime (dat, workerID, prjID, hours) VALUES (' 
   };

NN=NNN;

halbe = round(rand(1,NN))*0.5;
dat={zeros(NN,1)};

if nargin > 2
   if ischar(varargin{1})
      DB_NAME = varargin{1};
   else
      disp('Second parameter must be a string that holds the database file name!')
      return;
   end
else
   if nargin > 1
      if strfind(sqlDriver, 'sqlite')
         DB_NAME = 'delbasso_SQLITE.db';
      else
         DB_NAME = 'delbasso_MYSQL';
      end      
   end
end

%% src and target 
TEMPLATE = {'/home/mainster/CODES_local/qt_creator/worktimeManagerSubdirPrj/WorktimeManager/sqlite/delBasso_sqlite_template.sql';...
   '/home/mainster/CODES_local/qt_creator/worktimeManagerSubdirPrj/WorktimeManager/mysql/delBasso_mysql_template.sql'};
   
SQL_PATH={'/home/mainster/CODES_local/qt_creator/worktimeManagerSubdirPrj/WorktimeManager/sqlite';...
   '/home/mainster/CODES_local/qt_creator/worktimeManagerSubdirPrj/WorktimeManager/mysql'};

[PAT, NAME, EXT]= fileparts (TEMPLATE{DRIVER});
NAMER = [NAME strrep(strrep(char(datetime), ' ','_'),':','')];

TARG=[fullfile(PAT, NAMER), EXT];
copyfile(TEMPLATE{DRIVER}, TARG);
%%

fd = fopen(TARG,'at+');
day  = [1 30];
month= [1 12];
year = [2013 2016];
worker = [1 14];
prj = [1 18];
hrs = [0 10];

r = @(x) randi(x);
%%
for k=1:NN
%   dat{k,1} = sprintf('%s%3i, ''2015-%02i-%02i'', %2g, %2g, %3g);',...
%   dat{k,1} = sprintf('%s%3i, ''%02i/%02i/16'', %2g, %2g, %3g);',...
%   dat{k,1} = sprintf('%s%3i, ''%4i-%02i-%02i'', %2g, %2g, %3g);',...
   dat{k,1} = sprintf('%s''%4i-%02i-%02i'', %2g, %2g, %3g);',...
   lead{DRIVER}, r(year), r(month), r(day),... 
   r(worker),r(prj),r(hrs)+halbe(k));
   fprintf(fd, '%s\n', dat{k,1});
end

fclose(fd);
type(TARG)
%%

% cmdOld = ['[ -e $SQL/delbasso_MYSQL.db ] && mv $SQL/delbasso_MYSQL.db $SQL/olddb/delbasso_MYSQL_$(dateForFile).db;',...
%    'sqlite3 $SQL/delbasso_MYSQL.db < ', TARG];
cmd = {['[ -e ' SQL_PATH{DRIVER} '/' DB_NAME ' ] && mv ' SQL_PATH{DRIVER} '/' DB_NAME ' ' SQL_PATH{DRIVER} '/olddb/delbasso_SQLITE_$(dateForFile).db;',...
   'sqlite3 ' SQL_PATH{DRIVER} '/' DB_NAME ' < ', TARG];...
   ['mysql ' DB_NAME ' < ', TARG]};

disp(cmd{DRIVER})
[stat, cmdout]=system(cmd{DRIVER})
%%
disp (stat)
disp (cmdout)
disp (TARG)

if stat > 0
   system(['subl ' TARG]);
end

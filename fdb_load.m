function fdb = fdb_load(fdb)
if nargin==0
    fdb = fdb_init;
end

fdb_path = fileparts(which('fdb_init'));
db_path = [fdb_path,filesep,'Database'];

d = dir(db_path);
files = {d.name};
files = strcat(db_path,filesep,files(3:end));
files = files(~cellfun(@isempty,regexp(files,'.mat$')));

for i=1:length(files)
    tmp = load(files{i});
    close all
    if isfield(tmp.ar,'name')
        name = tmp.ar.name;
    else
        name = '';
    end    
    
    fdb = fdb_add_file(fdb,files{i},name);
end



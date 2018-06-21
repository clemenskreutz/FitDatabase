%  This function load all workspace in FitDatabase/Workspaces performs some
%  checks, updates, and save it again.

function fdb_Update_Workspaces

fdb_path = fileparts(which('fdb_init'));
db_path = [fdb_path,filesep,'Workspaces'];

d = dir(db_path);
files = {d.name};
files = strcat(db_path,filesep,files(3:end));
files = files(~cellfun(@isempty,regexp(files,'.mat$')));


for f=1:length(files)
    fprintf('%s ...\n',files{f});
    load(files{f},'fdb');
    
    % transpose if 1xN instead of Nx1
    fn = fieldnames(fdb.fits);
    for i=1:length(fn)
        if size(fdb.fits.(fn{i}),1)==1 && size(fdb.fits.(fn{i}),2)==fdb.info.N
            fdb.fits.(fn{i}) = fdb.fits.(fn{i})';
        end
    end
    
    fn = fieldnames(fdb.checksum);
    for i=1:length(fn)
        if size(fdb.checksum.(fn{i}),1)==1 && size(fdb.checksum.(fn{i}),2)==fdb.info.N
            fdb.checksum.(fn{i}) = fdb.checksum.(fn{i})';
        end
        
    end
    
    fn = fieldnames(fdb.files);
    for i=1:length(fn)
        if size(fdb.files.(fn{i}),1)==1 && size(fdb.files.(fn{i}),2)==fdb.info.N
            fdb.files.(fn{i}) = fdb.files.(fn{i})';
        end
    end
    
    if size(fdb.setups,1)==1 && size(fdb.setups,2)==fdb.info.N
        fdb.setups = fdb.setups';
    end
    if size(fdb.name,1)==1 && size(fdb.name,2)==fdb.info.N
        fdb.name = fdb.name';
    end
    if size(fdb.ID,1)==1 && size(fdb.ID,2)==fdb.info.N
        fdb.ID = fdb.ID';
    end
    
    save(files{f},'fdb');
end

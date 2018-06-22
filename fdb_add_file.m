% fdb = fdb_add_file(fdb,file,name)
% 
%   Try to add a fit sequence from a workspace
% 
%   file      workspace

function fdb = fdb_add_file(fdb,file,name)
if nargin~=3 || nargout~=1
    error('fdb = fdb_add_file(fdb,file,name)')
end

if exist(file,'file')
    %     arLoad(folders{f});
    try
        tmp = load(file);
    catch
        warning('Could not read file %s',file)
        return
    end
    
    if isfield(tmp,'ar') && isfield(tmp.ar,'ps') && isfield(tmp.ar,'ps_start') && isfield(tmp.ar,'chi2s')
        try
            ar = arUpdateCheckstr(tmp.ar,true);
        catch ERR
            tmp.ar
            rethrow(ERR)
        end
        
        clear tmp
        
        if isfield(ar,'chi2s') && ~isempty(ar.chi2s)
            % if it does not work, fdb should be un-altered:
            try
                fdb = fdb_add_core(fdb,ar,file,name);
                fdb.info.predictor_status = 0;
                fprintf(' ADDED.\n');
            catch ERR
                fprintf(' omitted (not a valid workspace).\n')
                rethrow(ERR)
            end
        else
            fprintf(' omitted (no LHS found).\n')
        end
    else
        fprintf(' omitted (no ar found).\n')
    end
else
    fprintf(' no ''workspace.mat''\n');
end


%% Adding a fit sequence to fdb
function fdb = fdb_add_core(fdb,ar,file,name)

ID = ['ID_',ar.checkstrs.total];
[~,ia] = intersect(fieldnames(fdb.ID),ID);
if isempty(ia) % append
    
    fdb.info.N = fdb.info.N+1;
    i = fdb.info.N;
    
    fdb.ID.(ID) = i; % ID_ has to be added to prevent numbers at the beginning of the fieldname

    
    fdb.checksum.data{i,1} = ar.checkstrs.data;
    
    fdb.checksum.fkt{i,1} = ar.checkstrs.fkt; % all checksum fields have to be structs
    
    if isfield(ar,'setup')
        fdb.setups{i,1} = ar.setup;
    else
        fdb.setups{i,1} = [];
    end
    
    tmp = load(['CheckSums',filesep,'para_',ar.checkstrs.para,'.mat']);
    newinfo.para = tmp.ar;
    
    tmp = load(['CheckSums',filesep,'fitting_',ar.checkstrs.fitting,'.mat']);
    newinfo.optim = tmp.ar.config.optim;
    newinfo.config =  rmfield(tmp.ar.config,'optim'); % config.optim is stored separately
            
    [fdb,newinfo] = fdb_Update_InfoFields(fdb,newinfo);
    
    fdb.checksum.config{i,1}  = newinfo.config;
    fdb.checksum.optim{i,1}   = newinfo.optim;
    fdb.checksum.para{i,1}    = newinfo.para;
    
    checksum = arAddToCheckSum(ar.info.cvodes_flags,[]);
    checkstr = dec2hex(typecast(checksum.digest,'uint8'))';    
    fdb.checksum.cvodes_flags{i,1} = checkstr(:)';

    checksum = arAddToCheckSum(ar.info.arsimucalc_flags,[]);
    checkstr = dec2hex(typecast(checksum.digest,'uint8'))';    
    fdb.checksum.arsimucalc_flags{i,1} = checkstr(:)';

    
    fdb.files.ar{i,1} = [fdb.info.fdb_path,ar.checkstrs.total,'.mat'];
    fdb.files.source{i,1} = file;
    fdb.files.fkt{i,1} = [fileparts(file),filesep,ar.fkt,'.',mexext];
    
    fdb.fits.chi2s{i,1} = ar.chi2s(:);
    fdb.fits.ps{i,1} = ar.ps;
    fdb.fits.ps_start{i,1} = ar.ps_start;
    
    fdb.name{i,1} = name;
    
    % copying should be the last step to prevent copying in case of errors:
    try
        copyfile(fdb.files.source{i,1},fdb.files.ar{i,1});
        save(fdb.files.ar{i,1},'name','-append');
    end
    
    if exist(fdb.files.fkt{i,1},'file')
        try
            copyfile(fdb.files.fkt{i,1},fdb.info.fdb_path);
        end
    end
    
else % append

    i = ia;

    fdb.fits.chi2s{i,1} = [fdb.fits.chi2s{i,1};ar.chi2s(:)];
    fdb.fits.ps{i,1} = [fdb.fits.ps{i,1};ar.ps];
    fdb.fits.ps_start{i,1} = [ar.ps_start;fdb.fits.ps_start{i,1}];
end



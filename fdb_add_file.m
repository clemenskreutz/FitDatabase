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
    tmp = load(file);
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

    
    fdb.checksum.data{i} = ar.checkstrs.data;
    
    fdb.checksum.fkt{i} = ar.checkstrs.fkt; % all checksum fields have to be structs
    
    if isfield(ar,'setup')
        fdb.setups{i} = ar.setup;
    else
        fdb.setups{i} = [];
    end
    
    tmp = load(['CheckSums',filesep,'para_',ar.checkstrs.para,'.mat']);
    newfdb.para = tmp.ar;
    
    tmp = load(['CheckSums',filesep,'fitting_',ar.checkstrs.fitting,'.mat']);
    newfdb.optim = tmp.ar.config.optim;
    newfdb.config =  rmfield(tmp.ar,'config'); % config.optim is stored separately
            
    [fdb,newfdb] = updateFields(fdb,newfdb);
    
    fdb.checksum.config{i}  = newfdb.config;
    fdb.checksum.optim{i}   = newfdb.optim;
    fdb.checksum.para{i}    = newfdb.para;
    
    checksum = arAddToCheckSum(ar.info.cvodes_flags,[]);
    checkstr = dec2hex(typecast(checksum.digest,'uint8'))';    
    fdb.checksum.cvodes_flags{i} = checkstr(:)';

    checksum = arAddToCheckSum(ar.info.arsimucalc_flags,[]);
    checkstr = dec2hex(typecast(checksum.digest,'uint8'))';    
    fdb.checksum.arsimucalc_flags{i} = checkstr(:)';

    
    fdb.files.ar{i} = [fdb.info.fdb_path,ar.checkstrs.total,'.mat'];
    fdb.files.source{i} = file;
    fdb.files.fkt{i} = [ar.fkt,'.',mexext];
    
    fdb.fits.chi2s{i} = ar.chi2s(:);
    fdb.fits.ps{i} = ar.ps;
    fdb.fits.ps_start{i} = ar.ps_start;
    
    fdb.name{i} = name;
    
    % copying should be the last step to prevent copying in case of errors:
    try
        copyfile(fdb.files.source{i},fdb.files.ar{i});
        save(fdb.files.ar{i},'name','-append');
    end
    
    if exist(fdb.files.fkt{i},'file')
        try
            copyfile(fdb.files.fkt{i},fdb.info.fdb_path);
        end
    end
    
else % append

    i = ia;

    fdb.fits.chi2s{i} = [fdb.fits.chi2s{i};ar.chi2s(:)];
    fdb.fits.ps{i} = [fdb.fits.ps{i};ar.ps];
    fdb.fits.ps_start{i} = [ar.ps_start;fdb.fits.ps_start{i}];
end


% This function updates the list of fieldnames in ar.info.fields and add
% missing fields to newfdb in case the new fit sequence has missing
% annotation
function [fdb,newfdb] = updateFields(fdb,newfdb)
F = fieldnames(newfdb);

for f=1:length(F)
    fn = fdb.info.fields.(F{f});
    fn2 = fieldnames(newfdb.(F{f}));
    new = setdiff(fn2,fn);
    missing = setdiff(fn,fn2);
    
    for i=1:length(missing)
        newfdb.(F{f}).(missing{i}) = 'NA';
    end
    for i=1:length(new)
        for j=1:fdb.info.N
            fdb.checksum.(F{f}){j}.(new{i}) = 'NA';
        end
        fdb.info.fields.(F{f}){end+1} = new{i};
    end
end


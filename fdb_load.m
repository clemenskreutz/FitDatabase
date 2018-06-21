% fdb = fdb_load            %   Loading from scratch
% fdb = fdb_load([],mode)
%
% fdb = fdb_load(fdb)       %   Adding to existing fdb
% fdb = fdb_load(fdb,mode)
%
%
% This function can be used to load fit-sequences, either
%   mode=0   [default] from workspaces
%   mode=1   from the arSTructs saved in folder FitDatabase

function fdb = fdb_load(fdb,mode)
if ~exist('fdb','var') || isempty(fdb)
    fdb = fdb_init;
end

if ~exist('mode','var') || isempty(mode)
    mode = 0;
end

fdb_path = fileparts(which('fdb_init'));
switch mode
    case 0 % Workspaces
        db_path = [fdb_path,filesep,'Workspaces'];
    case 1 % FitDatabase (ar structs)
        db_path = [fdb_path,filesep,'Database'];
    otherwise
        mode
        error('mode unknown.')
end


d = dir(db_path);
files = {d.name};
files = strcat(db_path,filesep,files(3:end));
files = files(~cellfun(@isempty,regexp(files,'.mat$')));

for i=1:length(files)
    fprintf('%3i: %s\n',i,files{i});
end

stop = false;
selected = [];
while ~stop
    
    in = input('Which files should be loaded? [0="all", <empty>="load selected now"]?\n','s');
    in = strtrim(lower(in));
    if isempty(in)
        stop = true;
    elseif strcmp(in,'0')
        selected = 1:length(files);
        stop = true;
    else
        selected = unique(union(selected,str2num(in)));
    end
end

for i=selected
    tmp = load(files{i});
    close all
    
    switch mode
        case 0
            if isfield(tmp,'fdb')
                if i==1
                    fdb = tmp.fdb;
                else
                    fprintf('Merging %s ...\n',files{i});
                    fdb = fdb_merge(fdb,tmp.fdb);
                end
            end
            
        case 1
            if isfield(tmp.ar,'name')
                name = tmp.ar.name;
            else
                name = '';
            end
            fdb = fdb_add_file(fdb,files{i},name);
    end
end



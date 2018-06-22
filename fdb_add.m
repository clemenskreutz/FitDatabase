% fdb = fdb_add(fdb)
% 
%   Recursively add all available fit sequences in the subfolders of the
%   working directory.
% 
% 
% fdb = fdb_add(fdb,folders)
% 
%   Adding fit sequences in folders
% 
%   folders     string 
%               or cell of foldernames

function fdb = fdb_add(fdb,folders)
if ~exist('fdb','var') || isempty(fdb)
    fdb = fdb_init;
end

if ~exist('folders','var') || isempty(folders)
    if exist('Results','dir')
    	[~, ~, folders] = fileChooser('./Results', [], -1);
        folders = strcat('Results',filesep,folders);
    else
        [~,folders] = list_files_recursive([],'folders'); 
    end
end

if ischar(folders)
    folders = {folders};
end

N0 = length(fdb.fits.chi2s);

for f=1:length(folders)   
    file = [folders{f},filesep,'workspace.mat'];
    [~,name] = fileparts(fileparts(fileparts(folders{f})));
    close all
    try
        fprintf('%s ...',file);
        fdb = fdb_add_file(fdb,file,name);
    catch ERR
        file
        rethrow(ERR)
    end
end

fprintf('\n ############ fdb_add: %i fits sequences added. ###########\n',length(fdb.fits.chi2s)-N0);



% fdb_print(fdb)
% fdb_print(fdb,1)
% 
% 
% fdb_print(fdb,2)
%   Shows non-default settings

function fdb_print(fdb,mode)
if ~exist('mode','var') || isempty(mode)
    mode = 1;
end

IDs = fieldnames(fdb.ID);
for i=1:fdb.info.N
    nname = max(cellfun(@length,unique(fdb.name)));
    npath = max(cellfun(@length,unique(fdb.files.source)));
    
    format{2} = 

    switch mode
        case 1
            format = ['%3i: %',num2str(nname),'s,  %6i fits, %6i converged  %',num2str(npath),'s %30s \n'];
            fprintf(format, i,...
                fdb.name{i},...
                length(fdb.fits.chi2s{i}),...
                sum(~isnan(fdb.fits.chi2s{i})),...
                fdb.files.source{i},...
                IDs{i});
        case 2
        otherwise 
            mode
            error('mode unknown')
    end
end


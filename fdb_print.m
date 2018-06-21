% fdb_print(fdb)
% 
% fdb_print(fdb,1)      
%   Shows IDs
%
%
% fdb_print(fdb,2)      [default]
%   Shows non-default settings

function fdb_print(fdb,mode)
if ~exist('fdb','var') || isempty(fdb)
    error('Call via  fdb_print(fdb,...)')
end
if ~exist('mode','var') || isempty(mode)
    mode = 2;
end

IDs = fieldnames(fdb.ID);
names = fdb.name;
npath = min(51,max(cellfun(@length,unique(fdb.files.source))));
nname = max(cellfun(@length,unique(names)));

if nname>30
    nname = 30;
    for i=1:fdb.info.N
        names{i} = str_abbrev(names{i},30,false);
    end
end

for i=1:fdb.info.N
    pathstr = fdb.files.source{i};
    pathstr = str_abbrev(pathstr,50,true);
    
    defstr = '';
    if isfield(fdb,'predictors') && isfield(fdb.predictors,'nonDefault')
        ind = find(~cellfun(@isempty,fdb.predictors.nonDefault(i,:)));
        for j=1:length(ind)
            defstr = sprintf('%s, %8s=%10s',defstr,str_abbrev(fdb.predictors.xnames{ind(j)},8,false), str_abbrev(fdb.predictors.nonDefault{i,ind(j)},10,false) );
        end
    end
    switch mode
        case 1
            format = ['%3i: %',num2str(nname),'s %6i fits %6i converged  %',num2str(npath),'s %30s\n'];
            fprintf(format, i,...
                names{i},...
                length(fdb.fits.chi2s{i}),...
                sum(~isnan(fdb.fits.chi2s{i})),...
                pathstr,...
                IDs{i});
        case 2
            format = ['%3i: %',num2str(nname),'s %6i fits %6i cnvgd  %',num2str(npath),'s %s \n'];
            fprintf(format, i,...
                names{i},...
                length(fdb.fits.chi2s{i}),...
                sum(~isnan(fdb.fits.chi2s{i})),...
                pathstr,...
                defstr);
        otherwise
            mode
            error('mode unknown')
    end
end


% If str is larger than maxlen, then it is cut and ... are added instead
%
%   back    true (abbrev at the end)
%           false (abbrev at the beginning)

function str = str_abbrev(str,maxlen,back)

if length(str)>maxlen
    if back
        str = [char(8230),str((end-(maxlen-3)):end)];
    else
        str = [str(1:(maxlen-3)),char(8230)];
    end
end

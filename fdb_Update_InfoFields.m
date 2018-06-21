% This function updates the list of fieldnames in ar.info.fields and add
% missing fields to newinfo in case the new fit sequence has missing
% annotation
% 
%   fdb.info.fields     contains existing fieldnames in ar.checksum
% 
%                       Example:
%                         fdb.info.fields
% 
%                         ans = 
% 
%                             config: {1x38 cell}
%                              optim: {1x51 cell}
%                               para: {'lb'  'mean'  'qFit'  'qLog10'  'std'  'type'  'ub'}
% 
% 
%  The newinfo can be concorporated into fdb via:
%     fdb.checksum.config{i,1}  = newinfo.config;
%     fdb.checksum.optim{i,1}   = newinfo.optim;
%     fdb.checksum.para{i,1}    = newinfo.para;


function [fdb,newinfo] = fdb_Update_InfoFields(fdb,newinfo)
F = fieldnames(newinfo);

for f=1:length(F)
    fn = fdb.info.fields.(F{f});
    fn2 = fieldnames(newinfo.(F{f}));
    
    new     = setdiff(fn2,fn)
    missing = setdiff(fn,fn2)
    
    for i=1:length(missing)
        newinfo.(F{f}).(missing{i}) = 'NA';
    end
    for i=1:length(new)
        for j=1:fdb.info.N
            fdb.checksum.(F{f}){j}.(new{i}) = 'NA';
        end
        fdb.info.fields.(F{f}){end+1} = new{i};
    end
end


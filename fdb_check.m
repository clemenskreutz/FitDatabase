% Consistency checks

function fdb_check(fdb)

F = fieldnames(fdb.info.fields);

ID = fieldnames(fdb.ID);

for f=1:length(F)
    fn = fdb.info.fields.(F{f});
    
    for i=1:length(fdb.checksum.(F{f}))
        notInChecksum = setdiff(fieldnames(fdb.checksum.(F{f}){i}),fn);        
        for ii=1:length(notInChecksum)
            fprintf('Field %s is not in %i''th fit sequence with ID %s\n',notInChecksum{ii},i,ID{i})
        end
        
        notInInfo = setdiff(fn,fieldnames(fdb.checksum.(F{f}){i}));
        for ii=1:length(notInInfo)
            fprintf('Field %s is not in the info but in the %i''th fit sequence with ID %s\n',notInInfo{ii},i,ID{i})
        end
    end
end

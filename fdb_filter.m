function fdb = fdb_filter(fdb,ind)

N = fdb.info.N;


fn = fieldnames(fdb);
for f=1:length(fn)
    if strcmp(fn{f},'ID')==1
        IDnew = struct;
        fnID = fieldnames(fdb.ID);
        for i=1:length(ind)
            IDnew.(fnID{ind(i)}) = i;
        end
        fdb.ID = IDnew;
        
    elseif isstruct(fdb.(fn{f}))
        fn2 = fieldnames(fdb.(fn{f}));
        for i=1:length(fn2)
            if size(fdb.(fn{f}).(fn2{i}),1)==N
                fdb.(fn{f}).(fn2{i}) = fdb.(fn{f}).(fn2{i})(ind,:);
            end
        end
    elseif size(fdb.(fn{f}),1)==N
        fdb.(fn{f}) = fdb.(fn{f})(ind,:);           
    end
end

fdb.info.N = length(ind);
fdb.info.predictor_status;
fdb = fdb_Update_InfoFields(fdb);


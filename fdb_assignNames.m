function fdb = fdb_assignNames(fdb)

indname = find(~cellfun(@isempty,fdb.name));
indnot = find(cellfun(@isempty,fdb.name));

for i=1:length(indnot)
%     i
    [~,ia] = intersect(fdb.checksum.fkt(indname),fdb.checksum.fkt(indnot(i)));
    [~,ib] = intersect(fdb.checksum.data(indname),fdb.checksum.data(indnot(i)));
%     [~,ic] = intersect(fdb.checksum.para(indname),fdb.checksum.para(indnot(i)));
    if ~isempty(ia)
        fdb.name{indnot(i)} = fdb.name{indname(ia(1))};
    elseif ~isempty(ib)
        fdb.name{indnot(i)} = fdb.name{indname(ib(1))};   
%     elseif ~isempty(ic)
%         fdb.name{indnot(i)} = fdb.name{indname(ic(1))};   
    end
end
indname2 = find(~cellfun(@isempty,fdb.name));
fprintf('%i names could be assigned.\n',length(indname2)-length(indname))


fdb.info.predictor_status = 0; % outdated


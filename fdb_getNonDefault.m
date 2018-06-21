function fdb = fdb_getNonDefault(fdb)

% update predictors, if necessary:
if ~fdb.info.predictor_status
    fdb = fdb_predictors(fdb);
end

names_lev = unique(fdb.predictors.model_names);

defall = fdb.predictors.all.default;
defall = struct2cell(defall);
nondef = cell(size(fdb.predictors.X));

for n=1:length(names_lev)
    ind = strmatch(names_lev{n},fdb.predictors.model_names,'exact');
    if length(ind)<4 || isempty(names_lev{n}) % if less than 4 model, take the most frequent over all models
        def = defall;
    else % if 4 or more fit sequences, take the most frequent for this model
        def = fdb.predictors.(names_lev{n}).default;
        def = struct2cell(def);
    end
    
    for i=1:length(ind)
        for j=1:size(fdb.predictors.X,2)
            if ~strcmp(fdb.predictors.X(i,j),def{j})
                nondef(ind(i),j) = fdb.predictors.X(ind(i),j);
            end
        end
    end
end

fdb.predictors.nonDefault = nondef;


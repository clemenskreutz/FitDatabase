% fdb = fdb_predictors(fdb)
% 
% This function generates a predictor matrix nID x nConfigFields

function fdb = fdb_predictors(fdb)

pred = struct;
pred.ynames = fdb.ID;
pred.model_names = fdb_replace_names(fdb.name)';

try
    
    for i=1:fdb.info.N
        iy = 0;
        
        iy = iy+1;
        pred.X{i,iy} = pred.model_names{i};
        if i==1
            pred.xnames{iy} = 'name';
        end
        
        iy = iy+1;
        pred.X{i,iy} = fdb.checksum.fkt{i};
        if i==1
            pred.xnames{iy} = 'fkt';
        end
        
        iy = iy+1;
        pred.X{i,iy} = fdb.checksum.data{i};
        if i==1
            pred.xnames{iy} = 'data';
        end
        
        for j=1:length(fdb.info.fields.config)
            iy = iy+1;
            field = fdb.info.fields.config{j};
            val = fdb.checksum.config{i}.(field);
            pred.X{i,iy} = val2pred(val);
            if i==1
                pred.xnames{iy} = ['config_',field];
            end
        end
        
        for j=1:length(fdb.info.fields.optim)
            iy = iy+1;
            field = fdb.info.fields.optim{j};
            val = fdb.checksum.optim{i}.(field);
            pred.X{i,iy} = val2pred(val);
            if i==1
                pred.xnames{iy} = ['optim_',field];
            end
        end
        
        for j=1:length(fdb.info.fields.para)
            iy = iy+1;
            field = fdb.info.fields.para{j};
            val = fdb.checksum.para{i}.(field);
            
            pred.X{i,iy} = val2pred(val);
            if i==1
                pred.xnames{iy} = ['para_',field];
            end
        end
    end   
     
catch ERR
    [i,iy]
    rethrow(ERR)
end

anz = NaN(1,size(pred.X,2));
for i=1:size(pred.X,2)
    anz(i) = length(unique(pred.X(:,i)));
end

pred.X = pred.X(:,anz>1);
pred.xnames = pred.xnames(anz>1);


fdb.predictors = pred;
fdb = fdb_levels(fdb);


function fdb = fdb_levels(fdb)
X = fdb.predictors.X;
xnames = fdb.predictors.xnames;
model_names = fdb.predictors.model_names;
model_lev = levels(model_names);

fdb.predictors.all = struct;
fdb.predictors.all.xlevels = cell(size(xnames));
fdb.predictors.all.replicates = cell(size(xnames));
fdb.predictors.all.default = struct;

for i=1:size(X,2)
    [l,anz] = levels(X(:,i));
    [~,rf] = sort(-anz);
    l = l(rf);
    anz = anz(rf);

    fdb.predictors.all.xlevels{i} = l;
    fdb.predictors.all.replicates{i} = anz;
    fdb.predictors.all.default.(xnames{i}) = l{1};
    
    for n=1:length(model_lev)
        [~,ind] = intersect(model_names,model_lev{n});

        [l,anz] = levels(X(ind,i));
        [~,rf] = sort(-anz);
        l = l(rf);
        anz = anz(rf);

        fdb.predictors.(model_lev{n}).xlevels{i} = l;
        fdb.predictors.(model_lev{n}).replicates{i} = anz;
        fdb.predictors.(model_lev{n}).default.(xnames{i}) = l{1};
    end
end

fdb.info.predictor_status = 1; % predictors now up-to-date




function predval = val2pred(val)
if isnan(val)
    predval = 'NaN';
elseif isempty(val)
    predval = 'NA';
elseif isnumeric(val)
    predval = sprintf('%d',val);
elseif islogical(val)
    predval = sprintf('%i',val);
elseif ischar(val)
    predval = val;
else
    predval = char(string(val));
end



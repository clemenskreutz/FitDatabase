% fdb = fdb_predictors(fdb)
% 
% This function generates a predictor matrix nID x nConfigFields

function fdb = fdb_predictors(fdb)

pred = struct;
pred.ynames = fdb.ID;

try
    
    for i=1:fdb.info.N
        iy = 0;
        
        iy = iy+1;
        pred.X{i,iy} = fdb.name{i};
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
            if isnan(val)
                pred.X{i,iy} = 'NaN';
            elseif isempty(val)
                pred.X{i,iy} = 'NA';
            else
                pred.X{i,iy} = char(string(val));
            end
            if i==1
                pred.xnames{iy} = ['config_',field];
            end
        end
        
        for j=1:length(fdb.info.fields.optim)
            iy = iy+1;
            field = fdb.info.fields.optim{j};
            val = fdb.checksum.optim{i}.(field);
            if isnan(val)
                pred.X{i,iy} = 'NaN';
            elseif isempty(val)
                pred.X{i,iy} = 'NA';
            else
                pred.X{i,iy} = char(string(val));
            end
            if i==1
                pred.xnames{iy} = ['optim_',field];
            end
        end
        
        for j=1:length(fdb.info.fields.para)
            iy = iy+1;
            field = fdb.info.fields.para{j};
            if isnan(val)
                pred.X{i,iy} = 'NaN';
            elseif isempty(val)
                pred.X{i,iy} = 'NA';
            else
                val = fdb.checksum.para{i}.(field);
            end
            pred.X{i,iy} = sprintf('%i ',val);
            if i==1
                pred.xnames{iy} = ['para_',field];
            end
        end
    end   
     
catch ERR
    [i,iy,j]
    rethrow(ERR)
end

anz = NaN(1,size(pred.X,2));
for i=1:size(pred.X,2)
    anz(i) = length(unique(pred.X(:,i)));
end

pred.X = pred.X(:,anz>1);
pred.xnames = pred.xnames(anz>1);


fdb.predictors = pred;

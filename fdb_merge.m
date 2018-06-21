    % fdb = fdb_merge(fdb,fdb2)
% 
%   Integrates fdb2 into fdb, i.e. merges the outcomes

function fdb = fdb_merge(fdb,fdb2)


%% Same IDs: Attach only to fdb.fits:
[~,isame1,isame2] = intersect(fieldnames(fdb.ID),fieldnames(fdb2.ID)); % new IDs
if ~isempty(isame1)
    disp('Some IDs overlap: the fit results are merged.');
end
for i=1:length(isame1)
    fnfit = fieldnames(fdb2.fits);
    for f=1:length(fnfit)
        fdb.fits.(fnfit{f}){isame1(i)} = [fdb.fits.(fnfit{f}){isame1(i)};fdb2.fits.(fnfit{f}){isame2(i)}];
    end
end

%% Remove the ones with same ID:
[~,inew] = setdiff(fieldnames(fdb2.ID),fieldnames(fdb.ID)); % new IDs
if isempty(inew)
    disp('No new IDs');
    return;
else
    fprintf('%i new fit sequences are attached.\n',length(inew));
    fdb2 = fdb_filter(fdb2,inew); % only keep new IDs in the 2nd fdb
end


%% fdb.info and fdb.checksum
fdb.info.predictor_status = 0;

N1 = fdb.info.N;
N2 = fdb2.info.N;
fdb.info.N = N1 + N2;

for i=1:N2
    newinfo.para  = fdb2.checksum.para{i,1};
    newinfo.config = fdb2.checksum.config{i,1};
    newinfo.optim = fdb2.checksum.optim{i,1};
    
    [fdb,newinfo] = fdb_Update_InfoFields(fdb,newinfo);
    
    fdb2.checksum.config{i,1}  = newinfo.config;
    fdb2.checksum.optim{i,1}   = newinfo.optim;
    fdb2.checksum.para{i,1}    = newinfo.para;
end

fn = fieldnames(fdb.checksum);
for f=1:length(fn)
    fdb.checksum.(fn{f}) = [fdb.checksum.(fn{f});fdb2.checksum.(fn{f})];
end


%% fdb.files
fn = fieldnames(fdb.files);
for f=1:length(fn)
    fdb.files.(fn{f}) = [fdb.files.(fn{f});fdb2.files.(fn{f})];
end

%% fdb.fits
fn = fieldnames(fdb.fits);
for f=1:length(fn)
    fdb.fits.(fn{f}) = [fdb.fits.(fn{f});fdb2.fits.(fn{f})];
end

%% fdb.name
fdb.name = [fdb.name;fdb2.name];

%% fdb.ID
fn = fieldnames(fdb2.ID);
for f=1:length(fn)
    fdb.ID.(fn{f}) = fdb2.ID.(fn{f}) + N1;
end

%% other fields
fdb.setups = [fdb.setups;fdb2.setups];






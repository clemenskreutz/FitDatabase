function fdp_print(fdb)

IDs = fieldnames(fdb.ID);
for i=1:fdb.info.N
    nname = max(cellfun(@length,unique(fdb.name)));
    npath = max(cellfun(@length,unique(fdb.files.source)));
    format = ['%3i: %',num2str(nname),'s,  %6i fits, %6i converged  %',num2str(npath),' %30s\n'];
    
    fprintf(format, i,fdb.name{i},length(fdb.fits.chi2s{i}),sum(~isnan(fdb.fits.chi2s{i})),IDs{i});
    
end


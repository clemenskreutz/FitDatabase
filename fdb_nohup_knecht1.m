%  This script can serve as a script for collecting Fits via command:
% 
%  nohup matlab -nosplash < fdb_nohup_knecht1.m > fdb_nohup_knecht1.out &

addpath('~/FitDatabase/')

addpath('~/d2d/arFramework3/')
arInit  % for having all functions from D2D

fdb = fdb_init;
fdb = fdb_add(fdb);

[~,folder]=fileparts(pwd);
save([folder,'_knecht1.mat'], 'fdb');
copyfile([folder,'_knecht1.mat'],'~/FitDatabase/Workspaces');



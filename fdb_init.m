function fdb = fdb_init

fdb = struct;

% This field wilIl contain some summary infos about the data in fdb
fdb.info = struct;
fdb.info.fields.config = cell(0);
fdb.info.fields.optim = cell(0);
fdb.info.fields.para = cell(0);

% path to the database files
fdb.info.fdb_path = [fileparts(which('fdb_init')),'/Database/'];

% number of fit sequences, also used as index to fill cells
fdb.info.N = 0;

% This struct will contain annotation of the checksums:
fdb.checksum = struct;
fdb.checksum.config = cell(0);
fdb.checksum.data = cell(0);
fdb.checksum.fkt = cell(0);
fdb.checksum.optim = cell(0);
fdb.checksum.para = cell(0);

% This struct will contain filenames
fdb.files = struct;
fdb.files.ar = cell(0);
fdb.files.source = cell(0);
fdb.files.fkt = cell(0);

% This struct will contain fit results:
fdb.fits = struct;
fdb.fits.chi2s = cell(0);
fdb.fits.ps = cell(0);
fdb.fits.ps_start = cell(0);

% This struct will contain the model names:
fdb.name = cell(0);

% Assignment from ID to Index;
fdb.ID = struct;

% storing setup commands:
fdb.setups = cell(0);


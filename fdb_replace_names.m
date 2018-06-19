function names = fdb_replace_names(names)


pat = {'Bachmann_MSB2011','Bachmann';
    'Becker_Science2010','Becker';
    'Beer_MolBiosyst2014','Beer';
    'Boehm_JProteomeRes2014','Boehm';
    'Bruno_Carotines_JExpBio2016','Bruno';
    'Oxygen_Metabolic_Rates_2016','Oxygen';
    'Raia_CancerResearch2011','Raia';
    'Reelin_PONE2017','Reelin';
    'Swameye_PNAS2003','Swameye';
    'Toensing_InfectiousDisease_BoardingSchool_2017','BordingSchool';
    'Toensing_InfectiousDisease_Zika_2017','Zika'};

for i=1:size(pat,1)
    names = strrep(names,pat{i,1},pat{i,2});
end

names = str2fieldname(names);
names = regexprep(names,'^f_','Model_');


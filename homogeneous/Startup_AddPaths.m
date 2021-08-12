function Startup_AddPaths()
home_path = [pwd filesep];

addpath([home_path '/Generators/']);
addpath([home_path '/Regressions/']);
addpath([home_path '/Results/']);

end
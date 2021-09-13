function Startup_AddPaths()
home_path = [pwd filesep];

addpath([home_path '/Generators/']);
addpath([home_path '/Regressions/']);
addpath([home_path '/Results/']);
addpath([home_path '/Predator_Prey_functions/']);

end
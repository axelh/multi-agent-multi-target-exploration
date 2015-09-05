%   Created by Axel Hackbarth, UC Berkeley VDL / TU-Harburg MuM
%% init
addpath(genpath('helper'));
addpath(genpath('tests'));

dbclif

close all
clear all
clear classes
clear all
clear classes

% dbstif  % comment for no error handling

%% simulation parameter definition
x = 10 % global scaling factor
nAgents = 3                         %#ok<NOPTS>
nTargets= 8                         %#ok<NOPTS>
% nAgents = 2                         %#ok<NOPTS>
% nTargets= 3                         %#ok<NOPTS>
% nAgents = 1                         %#ok<NOPTS>
% nTargets= 1                         %#ok<NOPTS>
EndTime = 20000         %#ok<NOPTS>  % in seconds
RegionSize = x*150*[1.6;1]  %#ok<NOPTS>  % in meters  
RegionCenter = x*[0;100] %#ok<NOPTS>
RegionGridStep = x*2*[1;1]  %#ok<NOPTS>  % in meters / gridstep
TimeStepDuration = 1   %#ok<NOPTS>  % in seconds / timestep


if false
nAgents = input('Enter num of agents: ')
nTargets= input('Enter num of targets: ')
end

%% simulation environment initialization
env = Environment();
this.Environment = env;
env.Region.Size = RegionSize;
env.Region.Center = RegionCenter;
env.Region.GridStep = RegionGridStep;
env.EndTime = EndTime;
env.TimeStepDuration = TimeStepDuration;
% env.Visualize = false;


multiregion = 0  %#ok<NOPTS>
        if multiregion
%% create a second low-res region with one agent
        r = env.addRegion;
        r.Bounds = env.Region.Bounds * 2;
        r.GridStep = env.Region.GridStep * 5;
        ro = env.addRegionEstimator;
            agent = env.addAgent('Region',env.Regions{2});
            agent.MaxVelocity = (3+1)*agent.MaxVelocity;
c = GlobalCostFunction('Environment',env,'Region',r);
        end

%% create agents with sensors
for i=1:nAgents
    agent = env.addAgent;
    agent.MaxVelocity = (i+2)*agent.MaxVelocity;
end
agent.AgentController.Visualize = true;

%% create targets
for i=1:nTargets
    target = env.addTarget;
    target.MaxVelocity = i/2*target.MaxVelocity;
end

%% simulation start
c = GlobalCostFunction('Environment',env);

CostFunctionParameterGUI;

% notify(env,'startSimulation');

classdef Recorder < handle
    %RECORDER Summary of this class goes here
    %   usage: r = Recorder(env.TargetEstimators{1},'moved','State');
    
    properties
        x
    end
    
    methods
        function this=Recorder(source,event,propertyname)
            if nargin==3
                addlistener(source,event,@(src,evt)this.add(src.(propertyname)));
            end
        end
        
        function add(this,value)
            this.x{end+1} = value;
        end
    end
end


%% copy into m file for an example code. has to be evaluated cell by cell 

% %%
% main
% %% stop simulation
% agent.Position = target.Position;
% % agent.Sensors{1}.VarianceMap = 10*agent.Sensors{1}.VarianceMap ;
% %% run simulation .... stop simulation
% r = Recorder(env.TargetEstimators{1},'moved','State');
% r2 = Recorder(env.TargetEstimators{1},'moved','Covariance');
% r3 = Recorder(env.Targets{1},'moved','State');
% %% run simulation ... stop simulation
% rst=cell2mat(r3.x);
% est=cell2mat(r.x);
% 
% std=[];
% for x=r2.x
%     std(:,end+1)=sqrt(diag(x{:}));
% end
% 
% %%
% est = est - rst;rst = rst * 0;
% %%
% i=4;
% t=1:length(est);
% figure(10)
% plot(t,rst(i,:),t,est(i,:),t,est(i,:)+std(i,:),t,est(i,:)-std(i,:))
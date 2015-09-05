disp('test')

%%
main
%%
agent.Position = target.Position;
% agent.Sensors{1}.VarianceMap = 10*agent.Sensors{1}.VarianceMap ;
%%
r = Recorder(env.TargetEstimators{1},'moved','State');
r2 = Recorder(env.TargetEstimators{1},'moved','Covariance');
r3 = Recorder(env.Targets{1},'moved','State');
%%
rst=cell2mat(r3.x);
est=cell2mat(r.x);

std=[];
for x=r2.x
    std(:,end+1)=sqrt(diag(x{:}));
end

%%
est = est - rst;rst = rst * 0;
%%
i=4;
t=1:length(est);
figure(10)
plot(t,rst(i,:),t,est(i,:),t,est(i,:)+std(i,:),t,est(i,:)-std(i,:))
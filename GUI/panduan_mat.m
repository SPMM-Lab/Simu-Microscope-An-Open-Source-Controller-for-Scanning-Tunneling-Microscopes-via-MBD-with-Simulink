%% 采样率!!!!!!!!!!!!!!!!!!!!!!!!!
sample_fre=10000;%采样频率

%% 用于选择点的范围 dataset
% BBB = data{4}.Values.Data(1:mm:end);
% tim=data{4}.Values.Time(1:mm:end);

%% 用于选择点的范围 struct结构体
data=importdata('fjgnr132.mat');
BBB=data{2}.Values.Data;
tim=data{2}.Values.Time;

%% 判断程序算力
ideal_points=(tim(end,1)-tim(1,1))*sample_fre;
disp(['Sampling frequency is ',num2str(sample_fre),' Hz.']);
disp(['Ideal point is ',num2str(ideal_points),'.']);
disp(['Real point is ',num2str(length(tim)),'.']);
if ideal_points-length(tim)>2
    loss_rate=(ideal_points-length(tim))/ideal_points*100; 
    
    disp(['loss rate is ',num2str(loss_rate),'%.']);
    error("Error!! Mission fail!!!!");
else
    disp("OK!! Mission complete!!!!");
end
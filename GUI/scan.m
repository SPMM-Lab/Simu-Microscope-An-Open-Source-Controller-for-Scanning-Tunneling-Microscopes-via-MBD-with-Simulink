%本代码仅用于扫描数据的二维、三维成像
%% 二维图
% clc;clear variables;close all;
addpath(fullfile(pwd, 'Data'));
mm=1;%数据成像间隔
% filename='rofg955617';

% hang = 40;

data_start=1;

% hh_tunnelcurrent=hh.data{6}.Values.Data(data_start:mm:end);%隧道电流

hh_time=logsout{2}.Values.Time(data_start:mm:end);%时间
hh_x=logsout{2}.Values.Data(data_start:mm:end);%x轴扫描信号（快轴）
hh_y=logsout{4}.Values.Data(data_start:mm:end);%y轴扫描信号（慢轴）
hh_pi=logsout{6}.Values.Data(data_start:mm:end);%z轴pi形貌信号

%图像行数是自动识别的，不需要手动输入
lie = 256;%图像每行有多少个像素点，用于模仿gwyddion的加权平均算法一行只保留256个点


T_fast = 3; %三角波快轴扫描周期，单位为s秒

f_s = 10000;


% 手动输入需要提取的行数（上升段个数）
L_hang = 10;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% filenamefull=filename+".mat";
% hh=load(filenamefull);%扫描数据
data_start=1;

% hh_tunnelcurrent=hh.data{6}.Values.Data(data_start:mm:end);%隧道电流
% 
% hh_time=hh.data{1}.Values.Time(data_start:mm:end);%时间
% hh_x=hh.data{1}.Values.Data(data_start:mm:end);%x轴扫描信号（快轴）
% hh_y=hh.data{2}.Values.Data(data_start:mm:end);%y轴扫描信号（慢轴）
% hh_pi=hh.data{4}.Values.Data(data_start:mm:end);%z轴pi形貌信号
figure(66)
plot(hh_pi, 'g', 'LineWidth', 2);




figure(1)
% 出图
plot(hh_time,hh_x, 'b', 'LineWidth', 2);hold on;grid on;
plot(hh_time,hh_y, 'k', 'LineWidth', 2);
hold on;grid on;
plot(hh_time,hh_pi, 'g', 'LineWidth', 2);


dcm = datacursormode(gcf);          % 获取 Data Cursor 模式对象
set(dcm, 'UpdateFcn', @myDataTip);  % 设置自定义回调函数
%% 三角波单向峰谷索引
peaks_x = find(diff(sign(diff(hh_x))) < 0) + 1;   % 找峰值点索引
valleys_x = find(diff(sign(diff(hh_x))) > 0) + 1; % 找谷底点索引
% C_x = {};  %提取x轴上升段
% C_y= {};  %提取y轴对应x轴上升段
% C_z={};  %提取z轴对应x轴上升段
% for i = 1:min(length(peaks_x), length(valleys_x))
%     if valleys_x(i) < peaks_x(i)
%         C_x{end+1} = struct( ...
%             'time', hh_time(valleys_x(i):peaks_x(i)), ...
%             'scanx', hh_x(valleys_x(i):peaks_x(i)) ...
%             );
%         C_y{end+1} = struct( ...
%             'time', hh_time(valleys_x(i):peaks_x(i)), ...
%             'scanx', hh_y(valleys_x(i):peaks_x(i)) ...
%             );
%          C_z{end+1} = struct( ...
%             'time', hh_time(valleys_x(i):peaks_x(i)), ...
%             'scanx', hh_pi(valleys_x(i):peaks_x(i)) ...
%             );
%     end
% end
% % 绘图验证
% figure;
% plot(hh_time, hh_x, '--b', 'LineWidth', 2); hold on;grid on;
% plot(hh_time, hh_y, '--k', 'LineWidth', 2); hold on;grid on;
% plot(hh_time, hh_pi, '--g', 'LineWidth', 2); hold on;grid on;
% for i = 1:length(C_x)
%     plot(C_x{i}.time, C_x{i}.scanx, 'r', 'LineWidth', 2);hold on;%x轴扫描信号
%     plot(C_y{i}.time, C_y{i}.scanx, 'k', 'LineWidth', 2);%y轴扫描信号
%     plot(C_z{i}.time, C_z{i}.scanx, 'b', 'LineWidth', 2);%z轴形貌信号
% end
% xlabel('time'); ylabel('scan');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%以上数据只关心自动得到三角波第一个起始点，后续

% 只使用第一个谷值索引作为起始参考点
first_idx = valleys_x(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%如果想自定义从第几个三角波周期开始成像，可以从plot原始点的图12查起始是第几个点，手动输入
% first_peak_idx = ;
figure(12)

plot(hh_x, 'b', 'LineWidth', 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

points_per_rise = (T_fast/2)*f_s;%一个上升段会有多少个点

% 或者可以直接指定：L_hang = 40;

% 初始化存储数组
C_x = cell(1, L_hang);  % 提取x轴上升段
C_y = cell(1, L_hang);  % 提取y轴对应x轴上升段
C_z = cell(1, L_hang);  % 提取z轴对应x轴上升段

% 提取每个上升段的数据
for i = 1:L_hang
    % 计算当前上升段的起始索引
    start_idx = first_idx + (i-1) * T_fast * f_s;
    
   
    
    % 提取当前上升段的数据
    idx_range = start_idx:(start_idx + points_per_rise - 1);
    
    C_x{i} = struct( ...
        'time', hh_time(idx_range), ...
        'scanx', hh_x(idx_range) ...
        );
    
    C_y{i} = struct( ...
        'time', hh_time(idx_range), ...
        'scanx', hh_y(idx_range) ...
        );
    
    C_z{i} = struct( ...
        'time', hh_time(idx_range), ...
        'scanx', hh_pi(idx_range) ...
        );
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%










%% 三维成像


%% 三维成像
%% 三维成像 - 加权平均方法
%% 三维成像 - 加权平均方法（修正版）
num_lines = length(C_z);  % 扫描线数量
points_per_line = length(C_z{1}.scanx);  % 每条线的原始点数

% 创建结果矩阵
Z_matrix = zeros(num_lines, lie);
X_matrix = zeros(num_lines, lie);
Y_matrix = zeros(num_lines, lie);

% 计算每个像素对应的原始数据范围
% 将原始点数等分为lie个区间
bin_edges = round(linspace(1, points_per_line+1, lie+1));

for i = 1:num_lines
    % 获取当前扫描线的原始数据
    z_line = C_z{i}.scanx;  % 形貌信号% 去除数据包中的时间信息
    x_line = C_x{i}.scanx;  % x坐标
    y_line = C_y{i}.scanx;  % y坐标
    
    for j = 1:lie
        % 确定当前像素对应的原始数据索引范围
        start_idx = bin_edges(j);
        end_idx = bin_edges(j+1) - 1;
        
        % 确保索引有效
        start_idx = max(1, min(start_idx, points_per_line));
        end_idx = max(1, min(end_idx, points_per_line));
        
        if start_idx <= end_idx
            % 获取该范围内的所有数据点
            indices = start_idx:end_idx;
            
            if length(indices) > 0
                % 提取该范围内的数据
                z_values = z_line(indices);
                x_values = x_line(indices);
                y_values = y_line(indices);
                
                if length(indices) == 1
                    % 如果只有一个点，直接使用该点
                    Z_matrix(i, j) = z_values;
                    X_matrix(i, j) = x_values;
                    Y_matrix(i, j) = y_values;
                else
                    % 计算加权平均值
                    % 使用高斯权重：中间点权重高，边缘点权重低
                    center = mean(indices);
                    width = (end_idx - start_idx + 1) / 2;
                    
                    % 计算高斯权重
                    if width > 0
                        weights = exp(-((indices - center) / width).^2);
                        weights = weights / sum(weights);  % 归一化
                        
                        % 计算加权平均
                        Z_matrix(i, j) = sum(z_values .* weights(:));
                        X_matrix(i, j) = sum(x_values .* weights(:));
                        Y_matrix(i, j) = sum(y_values .* weights(:));
                    else
                        % 如果宽度为0，使用简单平均
                        Z_matrix(i, j) = mean(z_values);
                        X_matrix(i, j) = mean(x_values);
                        Y_matrix(i, j) = mean(y_values);
                    end
                end
            else
                % 如果该像素没有数据点，设置为NaN
                Z_matrix(i, j) = NaN;
                X_matrix(i, j) = NaN;
                Y_matrix(i, j) = NaN;
            end
        else
            % 如果索引范围无效，设置为NaN
            Z_matrix(i, j) = NaN;
            X_matrix(i, j) = NaN;
            Y_matrix(i, j) = NaN;
        end
    end
end






% 三维成像-平面模式
figure;
surf(X_matrix*8, Y_matrix*8, (Z_matrix-min(Z_matrix(:)))*30*22/1e3, 'EdgeColor', 'none');
%80微米对应120V，所以扫描器0.66V/μm，扫描器自带12倍放大，所以0.66V/μm * 12倍 = 8V/μm

view(2);  % 俯视图
colormap('parula');
c=colorbar;
ylabel(c, 'z/um');
xlabel('x/um');ylabel('y/um');zlabel('z/um');
% xlim([0,60]);
% ylim([0,60]);
set(gcf,'Position',[50 50 400 300]);
set(gca,'FontName','Times New Roman','FontSize',11);
% %print(gcf,'-dtiff','-r600','C:\Users\liush\Desktop\损v0');
% 三维成像-三维模式
figure;
surf(X_matrix*8, Y_matrix*8, Z_matrix*1.5*30*22/1e3, 'EdgeColor', 'none');
% view(2);  % 俯视图
% colormap('parula');
% c=colorbar;
% ylabel(c, 'z/um');
% xlim([0 64]);
xlabel('x/um');ylabel('y/um');zlabel('z/um');
% view([0 0]);    % 从 y 轴正方向看
set(gcf,'Position',[450 450 400 300]);
set(gca,'FontName','Times New Roman','FontSize',11);
% %print(gcf,'-dtiff','-r600','C:\Users\liush\Desktop\损v0');

%% 倾斜矫正
[M, N] = size(Z_matrix);
% 求解最小二乘平面 Z = aX + bY + c；
A = [X_matrix(:), Y_matrix(:), ones(M*N, 1)];%构建线性最小二乘 (LS, Least Squares) 拟合方程的矩阵
coeff = A \ Z_matrix(:);      %得到LS方程系数 [a; b; c]
% 得到拟合平面
plane = reshape(A*coeff, size(Z_matrix));
% 校正
Z_corrected = Z_matrix - plane;
figure;
surf(X_matrix*8, Y_matrix*8, (Z_corrected-min(Z_corrected(:)))*1.5*30*22/1e3, 'EdgeColor', 'none');
%1.5为同相比例放大器倍数，
% 30为电压放大器倍数，22为压电堆叠的位移/电压关系单位nm，
% 1e3将nm转化为um
% xlim([0 64]);
xlabel('x/um');ylabel('y/um');zlabel('z/um');
view([0 0]);    % 从 y 轴正方向看
% xlim([0 64]);
set(gcf,'Position',[50 50 400 300]);
set(gca,'FontName','Times New Roman','FontSize',11);
% %print(gcf,'-dtiff','-r600','C:\Users\liush\Desktop\损v0');
hold on;
% % figure%绘制最小二乘平面
% surf(X_matrix*8, Y_matrix*8, plane*1.5*30*22/1e3, 'EdgeColor', 'none');

%% 切片
figure
y_index=2;%行索引(y轴切片 )
plot(X_matrix(y_index,:),Z_matrix(y_index,:));%原始数据
hold on;grid on;
plot(X_matrix(y_index,:),Z_corrected(y_index,:)-min(Z_corrected(:)));%倾斜校正后数据
legend('Original Data','Tilt-Corrected Data');
xlabel('x/um');ylabel('z/um');
set(gcf,'Position',[50 50 400 300]);
set(gca,'FontName','Times New Roman','FontSize',11);


%% 数据导出至Gwyddion
% data = [X_matrix(:)*8, Y_matrix(:)*8, (Z_corrected(:)-min(Z_corrected(:)))*1.5*30*22/1e3];
data = [X_matrix(:)*8, Y_matrix(:)*8, -( Z_matrix(:)*30*22/1e3) ];%将X变成一列
subdir = 'data';   % 工作目录下的 data 文件夹
% filename2 = "scan_data_" + filename + ".txt";
filename2 = ['scan_data_' filename '.txt'];
writematrix(data, filename2, 'Delimiter', 'tab');
% writematrix(Z_matrix, 'scan_z_data.txt', 'Delimiter', 'tab');

figure
X_matrix_k = X_matrix(:);
Y_matrix_k=Y_matrix(:);
Z_matrix_k=Z_matrix(:)*30*22/1e3;
plot3(X_matrix_k,Y_matrix_k,Z_matrix_k,'o','MarkerSize',1.5);%普通plot是点和点之间的连线，必须换成独立的点不连线。
% plot3(X_matrix_k,Y_matrix_k,Z_matrix_k);%普通plot是点和点之间的连线，必须换成独立的点不连线。
xlabel('x fast');
ylabel('y slow');
T_s=1/10000;



figure
y_index=2;%行索引(y轴切片 )
plot(X_matrix(y_index,:),Z_matrix(y_index,:));%原始数据
hold on;grid on;
plot(X_matrix(y_index,:),Z_corrected(y_index,:)-min(Z_corrected(:)));%倾斜校正后数据
legend('Original Data','Tilt-Corrected Data');
xlabel('x/um');ylabel('z/um');
set(gcf,'Position',[50 50 400 300]);
set(gca,'FontName','Times New Roman','FontSize',11);



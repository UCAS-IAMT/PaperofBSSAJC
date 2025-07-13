close all
clear
clc

% 二阶系统相图动画绘制
clear; clc; close all;

% 系统参数设置
A1 = 0.2;
A2 = 0.3;
A3 = 30;
A4 = 0.01;
B = 15;
K = 22;
uh=0;


% 初始状态 % y0 = [z1,z2,z3,gama]
num_init = 6;
% 初始值设置 (在相平面中创建网格)
[x0, v0, z30, gamma0] = ndgrid([linspace(-8, -4, num_init/2),linspace(2, 8, num_init/2)], linspace(-8, 8, num_init), linspace(-8, 8, num_init), linspace(-8, 8, num_init));
% initial_conditions = [linspace(-1, 1, 6).', linspace(-1, 1, 6).', linspace(-2, 2, 6).', linspace(-5, 5, 6).'];
initial_conditions = [x0(:), v0(:), z30(:), gamma0(:)];

% 时间设置
tspan = linspace(0, 8, 200);  % 20秒内500个时间点
% 预存储轨迹
trajectories = cell(size(initial_conditions, 1), 1);
d_trajectories = cell(size(initial_conditions, 1), 1);
d_trajectories_init = zeros(size(initial_conditions));
% 求解所有轨迹
for i = 1:size(initial_conditions, 1)
    [~, Y] = ode45(@(t, Y) odefcn_animation(t,Y,A1,A2,A3,A4,B,K,uh), tspan, initial_conditions(i, :));
    trajectories{i} = Y;  % 存储整个轨迹
    d_trajectories{i} = [diff(Y)./(tspan(2)-tspan(1));zeros(1,4)];  % 存储整个轨迹
    d_trajectories_init(i,:) = d_trajectories{i}(1,:);
end

%% 创建动画 z1_dz1
figure('Color', 'white', 'Position', [100, 100, 1000, 800]);
ax = gca;
hold on;
box on;
grid on;

% 设置坐标轴
% 设置坐标轴范围
buffer = 0.1;
lim_val_y = 18;
lim_val_x = 10;
xlim([-lim_val_x, lim_val_x]);
ylim([-lim_val_y, lim_val_y]);
xlabel('$z_1$', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$\dot{z}_1$', 'Interpreter', 'latex', 'FontSize', 16);
% title(sprintf('二阶系统相图 $\\zeta = %.1f$, $\\omega_n = %.1f$', zeta, wn), ...
%       'Interpreter', 'latex', 'FontSize', 16);

% 创建轨迹对象
h_lines = gobjects(size(trajectories));
% colors = jet(length(h_lines));  % 不同颜色
colors = prism(length(h_lines));  % 不同颜色

% inx_color = 1:length(h_lines);
% inx_color_shff =inx_color(randperm(length(inx_color)));
for i = 1:length(h_lines)
    h_lines(i) = animatedline('Color', colors(i, :), ...
                              'LineWidth', 1.5, ...
                              'MaximumNumPoints', 1000);  % 限制显示点数
end

% 添加初始点标记
h_start = scatter(initial_conditions(:,1), d_trajectories_init(:,1), ...
                  30, 'k', 'filled', 'Marker', 'o');

% 固定点标记 (原点)
h_end = scatter(0, 0, 100, 'r', 'filled', 'Marker', 'o');

% 图例
legend([h_start, h_end], {'Initial Points', 'Original Point'}, ...
       'Location', 'northeast',FontSize=12);

% 动画参数
animation_speed = 0.001;  % 加速因子
n_frames = length(tspan);

% 录制动画 (可选)
vidObj = VideoWriter('phase_portrait_z1_dz1_v1.mp4', 'MPEG-4');
vidObj.FrameRate = 60;
open(vidObj);
num_z = 1;% z1_dz1相图
% 主动画循环
inx_color = 1:length(h_lines);
inx_color_shff =inx_color(randperm(length(inx_color)));
for k = 1:1:n_frames
    for i = 1:length(trajectories)
        % 获取当前点之前的所有点
        x_data = trajectories{inx_color_shff(i)}(1:k, num_z);
        y_data = d_trajectories{inx_color_shff(i)}(1:k, num_z);
        
        % 更新轨迹线
        clearpoints(h_lines(i));
        addpoints(h_lines(i), x_data, y_data);
    end
    
    % 更新标题显示时间
    title(ax, sprintf('Time = %.1f s', tspan(k)), ...
          'Interpreter', 'latex', 'FontSize', 16);
    
    drawnow;
    
    % 捕获帧 (用于保存视频)
    frame = getframe(gcf);
    writeVideo(vidObj, frame);
    
    % 控制播放速度
    pause(0.1 * animation_speed); 
end
pause(3)
% 关闭视频录制
close(vidObj);





%% 创建动画 z2_dz2
figure('Color', 'white', 'Position', [100, 100, 1000, 800]);
ax = gca;
hold on;
box on;
grid on;

% 设置坐标轴
% 设置坐标轴范围
buffer = 0.1;
lim_val_y = 10;
lim_val_x = 10;
xlim([-lim_val_x, lim_val_x]);
ylim([-lim_val_y, lim_val_y]);
xlabel('$z_2$', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$\dot{z}_2$', 'Interpreter', 'latex', 'FontSize', 16);
% title(sprintf('二阶系统相图 $\\zeta = %.1f$, $\\omega_n = %.1f$', zeta, wn), ...
%       'Interpreter', 'latex', 'FontSize', 16);

% 创建轨迹对象
h_lines = gobjects(size(trajectories));
% colors = jet(length(h_lines));  % 不同颜色
colors = prism(length(h_lines));  % 不同颜色

% inx_color = 1:length(h_lines);
% inx_color_shff =inx_color(randperm(length(inx_color)));
for i = 1:length(h_lines)
    h_lines(i) = animatedline('Color', colors(i, :), ...
                              'LineWidth', 1.5, ...
                              'MaximumNumPoints', 1000);  % 限制显示点数
end

% 添加初始点标记
h_start = scatter(initial_conditions(:,2), d_trajectories_init(:,2), ...
                  30, 'k', 'filled', 'Marker', 'o');

% 固定点标记 (原点)
h_end = scatter(0, 0, 100, 'r', 'filled', 'Marker', 'o');

% 图例
legend([h_start, h_end], {'Initial Points', 'Original Point'}, ...
       'Location', 'northeast',FontSize=12);

% 动画参数
animation_speed = 0.001;  % 加速因子
n_frames = length(tspan);

% 录制动画 (可选)
vidObj = VideoWriter('phase_portrait_z2_dz2_v1.mp4', 'MPEG-4');
vidObj.FrameRate = 60;
open(vidObj);
pause(3)
num_z = 2;% z1_dz1相图
% 主动画循环
inx_color = 1:length(h_lines);
inx_color_shff =inx_color(randperm(length(inx_color)));
for k = 1:10:n_frames
    for i = 1:length(trajectories)
        % 获取当前点之前的所有点
        x_data = trajectories{inx_color_shff(i)}(1:k, num_z);
        y_data = d_trajectories{inx_color_shff(i)}(1:k, num_z);
        
        % 更新轨迹线
        clearpoints(h_lines(i));
        addpoints(h_lines(i), x_data, y_data);
    end
    
    % 更新标题显示时间
    title(ax, sprintf('Time = %.1f s', tspan(k)), ...
          'Interpreter', 'latex', 'FontSize', 16);
    
    drawnow;
    
    % 捕获帧 (用于保存视频)
    frame = getframe(gcf);
    writeVideo(vidObj, frame);
    
    % 控制播放速度
    pause(0.1 * animation_speed); 
end
pause(3)

% 关闭视频录制
close(vidObj);


%% 创建动画 z3_dz3
figure('Color', 'white', 'Position', [100, 100, 1000, 800]);
ax = gca;
hold on;
box on;
grid on;

% 设置坐标轴
% 设置坐标轴范围
buffer = 0.1;
lim_val_y = 151;
lim_val_x = 10;
xlim([-lim_val_x, lim_val_x]);
ylim([-lim_val_y, lim_val_y]);
xlabel('$z_3$', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$\dot{z}_3$', 'Interpreter', 'latex', 'FontSize', 16);
% title(sprintf('二阶系统相图 $\\zeta = %.1f$, $\\omega_n = %.1f$', zeta, wn), ...
%       'Interpreter', 'latex', 'FontSize', 16);

% 创建轨迹对象
h_lines = gobjects(size(trajectories));
% colors = jet(length(h_lines));  % 不同颜色
colors = prism(length(h_lines));  % 不同颜色

% inx_color = 1:length(h_lines);
% inx_color_shff =inx_color(randperm(length(inx_color)));
for i = 1:length(h_lines)
    h_lines(i) = animatedline('Color', colors(i, :), ...
                              'LineWidth', 1.5, ...
                              'MaximumNumPoints', 1000);  % 限制显示点数
end

% 添加初始点标记
h_start = scatter(initial_conditions(:,3), d_trajectories_init(:,3), ...
                  30, 'k', 'filled', 'Marker', 'o');

% 固定点标记 (原点)
h_end = scatter(0, 0, 100, 'r', 'filled', 'Marker', 'o');

% 图例
legend([h_start, h_end], {'Initial Points', 'Original Point'}, ...
       'Location', 'northeast',FontSize=12);

% 动画参数
animation_speed = 0.001;  % 加速因子
n_frames = length(tspan);

% 录制动画 (可选)
vidObj = VideoWriter('phase_portrait_z3_dz3_v1.mp4', 'MPEG-4');
vidObj.FrameRate = 60;
open(vidObj);
pause(3)
num_z = 3;% z1_dz1相图
% 主动画循环
inx_color = 1:length(h_lines);
inx_color_shff =inx_color(randperm(length(inx_color)));
for k = 1:10:n_frames
    for i = 1:length(trajectories)
        % 获取当前点之前的所有点
        x_data = trajectories{inx_color_shff(i)}(1:k, num_z);
        y_data = d_trajectories{inx_color_shff(i)}(1:k, num_z);
        
        % 更新轨迹线
        clearpoints(h_lines(i));
        addpoints(h_lines(i), x_data, y_data);
    end
    
    % 更新标题显示时间
    title(ax, sprintf('Time = %.1f s', tspan(k)), ...
          'Interpreter', 'latex', 'FontSize', 16);
    
    drawnow;
    
    % 捕获帧 (用于保存视频)
    frame = getframe(gcf);
    writeVideo(vidObj, frame);
    
    % 控制播放速度
    pause(0.1 * animation_speed); 
end
pause(3)

% 关闭视频录制
close(vidObj);





%% 创建动画 z1_z2_z3
figure('Color', 'white', 'Position', [100, 100, 1000, 800]);
ax = gca;
hold on;
box on;
grid on;

% 设置坐标轴
% 设置坐标轴范围
buffer = 0.1;
lim_val_y = 10;
lim_val_x = 10;
lim_val_z = 20;

xlim([-lim_val_x, lim_val_x]);
ylim([-lim_val_y, lim_val_y]);
zlim([-lim_val_z, lim_val_z]);

xlabel('$z_1$', 'Interpreter', 'latex', 'FontSize', 16);
ylabel('$z_2$', 'Interpreter', 'latex', 'FontSize', 16);
zlabel('$z_3$', 'Interpreter', 'latex', 'FontSize', 16);

% title(sprintf('二阶系统相图 $\\zeta = %.1f$, $\\omega_n = %.1f$', zeta, wn), ...
%       'Interpreter', 'latex', 'FontSize', 16);

% 创建轨迹对象
h_lines = gobjects(size(trajectories));
colors = jet(length(h_lines));  % 不同颜色
% colors = prism(length(h_lines));  % 不同颜色

% inx_color = 1:length(h_lines);
% inx_color_shff =inx_color(randperm(length(inx_color)));
inx_color_shff_1 = find(initial_conditions(:,1)<0);
inx_color_shff_2 = find(initial_conditions(:,2)<0);
inx_color_shff_3 = find(0<initial_conditions(:,3));
inx_color_shff_4 = find(0<initial_conditions(:,1));
inx_color_shff_5 = find(0<initial_conditions(:,2));
inx_color_shff_6 = find(initial_conditions(:,3)<0);
temp1=intersect(intersect(inx_color_shff_1,inx_color_shff_2),inx_color_shff_1);
temp2=intersect(intersect(inx_color_shff_4,inx_color_shff_5),inx_color_shff_6);

inx_color = 1:length(h_lines);
% inx_color_shff = [temp1;temp2];%inx_color(randperm(length(inx_color)));
inx_color_shff =inx_color;
for i = 1:length(inx_color_shff)
    h_lines(i) = animatedline('Color', colors(inx_color_shff(i), :), ...
                              'LineWidth', 1.5, ...
                              'MaximumNumPoints', 1000);  % 限制显示点数
end

% 添加初始点标记
h_start = scatter3(initial_conditions(inx_color_shff,1), initial_conditions(inx_color_shff,2), initial_conditions(inx_color_shff,3),...
                  30, 'k', 'filled', 'Marker', 'o');

% 固定点标记 (原点)
h_end = scatter3(0, 0, 0, 100, 'r', 'filled', 'Marker', 'o');

% 图例
legend([h_start, h_end], {'Initial Points', 'Original Point'}, ...
       'Location', 'northeast',FontSize=12);

% 动画参数
animation_speed = 0.001;  % 加速因子
n_frames = length(tspan);
view([9.415289256198317,30.153865030674865]);
% 录制动画 (可选)
vidObj = VideoWriter('phase_portrait_z3_dz3_v1.mp4', 'MPEG-4');
vidObj.FrameRate = 60;
open(vidObj);
pause(3)
num_z = 3;% z1_dz1相图
% 主动画循环

for k = 1:5:n_frames
    for i = 1:length(inx_color_shff)
        % 获取当前点之前的所有点
        x_data = trajectories{inx_color_shff(i)}(1:k, 1);
        y_data = trajectories{inx_color_shff(i)}(1:k, 2);
        z_data = trajectories{inx_color_shff(i)}(1:k, 3);

        % 更新轨迹线
        clearpoints(h_lines(i));
        addpoints(h_lines(i), x_data, y_data, z_data);
    end
    
    % 更新标题显示时间
    title(ax, sprintf('Time = %.1f s', tspan(k)), ...
          'Interpreter', 'latex', 'FontSize', 16);
    
    drawnow;
    
    % 捕获帧 (用于保存视频)
    frame = getframe(gcf);
    writeVideo(vidObj, frame);
    
    % 控制播放速度
    pause(0.1 * animation_speed); 
end
pause(3)

% 关闭视频录制
close(vidObj);



























function timerPIEZO(app)
	 modelName = 'PID666';

      set_param([modelName '/K666'], 'Gain', num2str(1));%关闭逼近PI

      disp('approach_on！！！');
      pause(8);  % 100ms 延迟

      %获取隧道电流值      
      rto = get_param('PID666/rrrfff','RuntimeObject');
      value_tunnel = rto.OutputPort(1).Data;
      
      disp(value_tunnel)

    
  if value_tunnel < 0.3

    %关闭逼近PI
    set_param([modelName '/K666'], 'Gain', num2str(0));%关闭逼近PI

    pause(5);  % 100ms 延迟
    
    set_param('AMI_2_2_2/begin666', 'Gain', '1');
    disp('Gain = 1');
    
    % 2. 短暂延迟（如果需要观察效果）
    pause(0.1);  % 100ms 延迟
    
    % 3. 再设为 0
    set_param('AMI_2_2_2/begin666', 'Gain', '0');
    disp('Gain = 0');
    
    % 4. 让按钮弹起
    app.motor666Button.Value = false;

  else
    %关闭逼近PI
    set_param([modelName '/K666'], 'Gain', num2str(0));%关闭逼近PI

  end


end

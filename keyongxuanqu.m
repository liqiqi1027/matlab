clc
clear all

%%%%%%%%%%%%%%%%%%%%%%%%导入数据%%%%%%%%%%%%%%%%%%%%%%%

fid1 = fopen('E:\pythoncode\shujutoushe\data\dataair.txt','r');
reference_scan = textscan (fid1,'%f %f','headerlines',0);
ref_time= reference_scan{:,1};
ref_amp= reference_scan{:,2};
fclose(fid1);

fid2 = fopen('E:\pythoncode\shujutoushe\data\dataref_P1_01.txt','r');
sample_scan = textscan(fid2,'%f %f','headerlines',0);
sam_time = sample_scan{:,1};
sam_amp = sample_scan{:,2};
fclose(fid2);

%%%%%%%%%%%%%%%%%%%频域横轴刻画准备工作%%%%%%%%%%%%%%%%%

data_x=sam_time.*10^12;  %时间以ps为单位
[m,t] = size(sam_amp);%给下面经fft取一半的对称长度
timestep = mean(diff(data_x));%diff函数计算相邻差值
F=1/timestep;  %总F横轴长度
frequency = [0:m-1]'/m*F; %频域的横坐标刻画

x1=[0:1:m];
new_refamp=zeros(m,1);   %建立同等长度的零矩阵
new_samamp=zeros(m,1);

%%%%%%%%%%%%%%%%%%%%作图选区域%%%%%%%%%%%%%%%%%%%%%%%%

graph_one = figure(1);   %选取reference图像区域
    plot(data_x,ref_amp);  
    title('reference in time domain')
    xlabel('Time (ps)');
    ylabel('Amplitude (a.u)');
    hold on
    h=imrect;          %运行完这句后，可以在图中框出需要的区域
    pos1= getPosition(h); %待区域决定后，运行这句就会返回区域的位置和大小
    row_left1=round(pos1(1)/timestep);   %根据pos计算行左起点
    row_right1=round((pos1(1)+pos1(3))/timestep);  %根据pos计算行右结束点

    for i=row_left1:row_right1
    new_refamp(i,1)=ref_amp(i,1);
    end

graph_two = figure(2);   %选取sample图像区域
    plot(data_x,sam_amp);
    title('sample in time domain')
    xlabel('Time (ps)');
    ylabel('Amplitude (a.u)');
    hold on
    h=imrect;          %运行完这句后，可以在图中框出需要的区域
    pos2= getPosition(h); %待区域决定后，运行这句就会返回区域的位置和大小
    row_left2=round(pos2(1)/timestep);   %根据pos计算行左起点
    row_right2=round((pos2(1)+pos2(3))/timestep);  %根据pos计算行右结束点
    for i=row_left2:row_right2
    new_samamp(i,1)=sam_amp(i,1);
    end

%%%%%%%%%%%%%%%%%%对于已选取的数据进行FFT等后续处理%%%%%%%%%%%%%%%%%%%

sam_fft= fft(new_samamp); % Fast fourier transform of the sample
sam_absolute = abs(sam_fft);
ref_fft = fft(new_refamp); % Fast fourier transform of the reference
ref_absolute=abs(ref_fft);

graph_three = figure(3); 
    semilogy(frequency(1:m/2),ref_absolute(1:m/2),'r','linewidth',2);%axis([0 5 0.0001 10000])
    hold on
    semilogy(frequency(1:m/2),sam_absolute(1:m/2),'g','linewidth',2);
    grid on
    legend('reference','sample');
    xlabel('Frequency (THz)');
    ylabel('Spectral amplitude (a.u)');

%%%%%%%%%%%%%%%%%%%透射公式所要参数准备%%%%%%%%%%%%%%%%%%%%%%%

c = 3E8;% Speed of light 
d = input('请输入样品的厚度d（um）：');% Thickness of the sample um 
transmission = sam_fft./ref_fft;
transmission_absolute=abs(transmission);
transmission_phase= -unwrap(angle(transmission)); % Unwrap the transmission angle for phase
normal_phase = transmission_phase; %计算出模角
omega = 2*pi*frequency*1*10^12; %2Πf
n = 1+(c*normal_phase./(d*10^(-6)*omega));  %计算折射率
absorption_coefficient=(2/(d*10^(-4)))*log((4*n)./((1+n).*(1+n).*transmission_absolute));%计算吸收系数

graph_four = figure(4); 
    subplot(2,1,1);     %相位谱
    plot(frequency(1:m),normal_phase(1:m),'b','linewidth',2);
    grid on
    legend('origin');
    title('Phase in frequency domain');
    xlabel('Frequency (THz)');
    ylabel('Phase (rad)');
    
    subplot(2,1,2);     %透射率谱
    plot(frequency(1:m/2),transmission_absolute(1:m/2),'r','linewidth',1);
    grid on
    title('Transmission coefficient (%)');
    xlabel('Frequency (THz)');
    ylabel('Transmission (%)');

graph_five = figure(5);
    subplot(2,1,1);     %折射率谱
    plot(frequency(1:m/2),n(1:m/2),'r','linewidth',2);
    grid on
    title('Refractive index of  ');
    xlabel('Frequency (THz)');
    ylabel('refractive index (n)');
    axis([0 3,-inf,inf]);%设置横轴显示范围
    
    subplot(2,1,2);   %吸收系数谱
    plot(frequency(1:m),absorption_coefficient,'b','linewidth',2);
    grid on
    title('Absorption coefficient of');
    xlabel('Frequency (THz)');
    ylabel('Absorption coefficient (α)');
    axis([0.6 3,-inf,inf]); %设置横轴显示范围
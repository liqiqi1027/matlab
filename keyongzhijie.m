%clc
%clear all;

%%%%��������%%%%
fid1 = fopen('G:\medcine\20191022\air.txt','r');
reference_scan = textscan (fid1,'%f %f','headerlines',0);
ref_time= reference_scan{:,1};
ref_amp= reference_scan{:,2};
fclose(fid1);

fid2 = fopen('G:\medcine\20191022\G-1-0.txt','r');
sample_scan = textscan(fid2,'%f %f','headerlines',0);
sam_time = sample_scan{:,1};
sam_amp= sample_scan{:,2};
fclose(fid2);
%L=length(ref_time);

% for i=1:L
%     sam_time = sam1_time;
%     sam_amp = sam1_amp;
%     i=+1;
% end


%%%%FFT׼������%%%%%
data_x=sam_time.*10^12;  %ʱ����psΪ��λ
[m,t] = size(sam_amp);%�����澭fftȡһ��ĶԳƳ���
timestep = mean(diff(data_x));%diff�����������ڲ�ֵ
F=1/timestep;  %��F���᳤��
frequency = [0:m-1]'/m*F; %Ƶ��ĺ�����̻�

sam_fft = fft(sam_amp); % Fast fourier transform of the sample
sam_absolute = abs(sam_fft);
ref_fft= fft(ref_amp); % Fast fourier transform of the reference
ref_absolute=abs(ref_fft);

%%%%Ͷ�乫ʽ��Ҫ����׼��%%%%%
c = 3E8;% Speed of light 
d = input('��������Ʒ�ĺ��d��um����');% Thickness of the sample um
transmission= sam_fft./ref_fft;
transmission_absolute =abs(transmission);
transmission_phase= -unwrap(angle(transmission)); % Unwrap the transmission angle for phase
normal_phase= transmission_phase; %�����ģ��
omega = 2*pi*frequency*1*10^12; %2��f
refractive_index=(c*normal_phase./(d*10^(-6)*omega))+1;  %����������
absorption_coefficient=(2/(d*10^(-4)))*log((4*refractive_index)./((1+refractive_index).*(1+refractive_index).*transmission_absolute));%��������ϵ��
%absorption_coefficient=-(2/(d*10^(-4)))*log((1+n).*(1+n).*transmission_absolute./(4.*n));
%%%%%%��ͼ%%%%%%%

graph_one = figure(4);
    subplot(2,1,1);
    plot(data_x,ref_amp,'r','linewidth',2);
    hold on;
    plot(data_x,sam_amp,'g','linewidth',2);
    grid on
    legend('reference','sample');
    xlabel('Time (ps)');
    ylabel('Amplitude (a.u)');
    
    subplot(2,1,2);
    plot(frequency(1:m/2),ref_absolute(1:m/2),'r','linewidth',2);%axis([0 5 0.0001 10000])
    hold on
    plot(frequency(1:m/2),sam_absolute(1:m/2),'g','linewidth',2);
    grid on
    legend('reference','sample');
    xlim([0,5]);
    xlabel('Frequency (THz)');
    ylabel('Spectral amplitude (a.u)');


graph_two = figure(5);
    subplot(2,1,1);
    plot(frequency(1:m),normal_phase(1:m),'b','linewidth',2);
    grid on
    legend('origin');
    title('Phase in frequency domain');
    xlabel('Frequency (THz)');
    ylabel('Phase (rad)');
    
    subplot(2,1,2);
    plot(frequency(1:m/2),transmission_absolute(1:m/2),'r','linewidth',1);
    grid on
    title('Transmission coefficient (%)');
    xlabel('Frequency (THz)');
    ylabel('Transmission (%)');

graph_three = figure(6);
    subplot(2,1,1);
    plot(frequency(1:m),refractive_index(1:m),'B','linewidth',2);
    grid on
    title('Refractive index of  ');
    xlabel('Frequency (THz)');
    ylabel('refractive index (n)');
    xlim([0.25,3]);%���ú�����ʾ��Χ
    
    subplot(2,1,2)
    plot(frequency(1:m),absorption_coefficient,'b','linewidth',2);
    grid on
    title('Absorption coefficient of');
    xlabel('Frequency (THz)');
    ylabel('Absorption coefficient (��)');
    xlim([0,3]);  %���ú�����ʾ��Χ

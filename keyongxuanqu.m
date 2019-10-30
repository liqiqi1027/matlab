clc
clear all

%%%%%%%%%%%%%%%%%%%%%%%%��������%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%Ƶ�����̻�׼������%%%%%%%%%%%%%%%%%

data_x=sam_time.*10^12;  %ʱ����psΪ��λ
[m,t] = size(sam_amp);%�����澭fftȡһ��ĶԳƳ���
timestep = mean(diff(data_x));%diff�����������ڲ�ֵ
F=1/timestep;  %��F���᳤��
frequency = [0:m-1]'/m*F; %Ƶ��ĺ�����̻�

x1=[0:1:m];
new_refamp=zeros(m,1);   %����ͬ�ȳ��ȵ������
new_samamp=zeros(m,1);

%%%%%%%%%%%%%%%%%%%%��ͼѡ����%%%%%%%%%%%%%%%%%%%%%%%%

graph_one = figure(1);   %ѡȡreferenceͼ������
    plot(data_x,ref_amp);  
    title('reference in time domain')
    xlabel('Time (ps)');
    ylabel('Amplitude (a.u)');
    hold on
    h=imrect;          %���������󣬿�����ͼ�п����Ҫ������
    pos1= getPosition(h); %������������������ͻ᷵�������λ�úʹ�С
    row_left1=round(pos1(1)/timestep);   %����pos�����������
    row_right1=round((pos1(1)+pos1(3))/timestep);  %����pos�������ҽ�����

    for i=row_left1:row_right1
    new_refamp(i,1)=ref_amp(i,1);
    end

graph_two = figure(2);   %ѡȡsampleͼ������
    plot(data_x,sam_amp);
    title('sample in time domain')
    xlabel('Time (ps)');
    ylabel('Amplitude (a.u)');
    hold on
    h=imrect;          %���������󣬿�����ͼ�п����Ҫ������
    pos2= getPosition(h); %������������������ͻ᷵�������λ�úʹ�С
    row_left2=round(pos2(1)/timestep);   %����pos�����������
    row_right2=round((pos2(1)+pos2(3))/timestep);  %����pos�������ҽ�����
    for i=row_left2:row_right2
    new_samamp(i,1)=sam_amp(i,1);
    end

%%%%%%%%%%%%%%%%%%������ѡȡ�����ݽ���FFT�Ⱥ�������%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%%͸�乫ʽ��Ҫ����׼��%%%%%%%%%%%%%%%%%%%%%%%

c = 3E8;% Speed of light 
d = input('��������Ʒ�ĺ��d��um����');% Thickness of the sample um 
transmission = sam_fft./ref_fft;
transmission_absolute=abs(transmission);
transmission_phase= -unwrap(angle(transmission)); % Unwrap the transmission angle for phase
normal_phase = transmission_phase; %�����ģ��
omega = 2*pi*frequency*1*10^12; %2��f
n = 1+(c*normal_phase./(d*10^(-6)*omega));  %����������
absorption_coefficient=(2/(d*10^(-4)))*log((4*n)./((1+n).*(1+n).*transmission_absolute));%��������ϵ��

graph_four = figure(4); 
    subplot(2,1,1);     %��λ��
    plot(frequency(1:m),normal_phase(1:m),'b','linewidth',2);
    grid on
    legend('origin');
    title('Phase in frequency domain');
    xlabel('Frequency (THz)');
    ylabel('Phase (rad)');
    
    subplot(2,1,2);     %͸������
    plot(frequency(1:m/2),transmission_absolute(1:m/2),'r','linewidth',1);
    grid on
    title('Transmission coefficient (%)');
    xlabel('Frequency (THz)');
    ylabel('Transmission (%)');

graph_five = figure(5);
    subplot(2,1,1);     %��������
    plot(frequency(1:m/2),n(1:m/2),'r','linewidth',2);
    grid on
    title('Refractive index of  ');
    xlabel('Frequency (THz)');
    ylabel('refractive index (n)');
    axis([0 3,-inf,inf]);%���ú�����ʾ��Χ
    
    subplot(2,1,2);   %����ϵ����
    plot(frequency(1:m),absorption_coefficient,'b','linewidth',2);
    grid on
    title('Absorption coefficient of');
    xlabel('Frequency (THz)');
    ylabel('Absorption coefficient (��)');
    axis([0.6 3,-inf,inf]); %���ú�����ʾ��Χ
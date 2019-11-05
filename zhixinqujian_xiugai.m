%�������ҩ����������
ABS1=[absorption_coefficient absorption_coefficient1 absorption_coefficient2 ];%�����¾���
for i=1:701
average_abs1(i,1)=(sum(ABS1(i,:)))./3; %ÿ�е����������������ƽ��ֵ
end
plot(frequency(1:m),average_abs1,'k','linewidth',2);
hold on;
% plot(frequency(1:m),absorption_coefficient,'--g','linewidth',1);
% hold on;
% plot(frequency(1:m),absorption_coefficient1,'--b','linewidth',1);
% hold on;
% plot(frequency(1:m),absorption_coefficient2,'--m','linewidth',1);
% hold on;
grid on
title('Absorption coefficient of');
xlabel('Frequency (THz)');
ylabel('Absorption coefficient (��)');
xlim([0.1,1]);  
V1=var(ABS1,1,2);%����ĸ�巽�� 1��ĸ�巽�� 2�����м���
for i=1:701
shangxian1(i,1)=average_abs1(i,1)+1.15.*sqrt(V1(i,1));%  ����������㹫ʽ��ƽ��ֵx+-��Z��/2*sigama��
xiaxian1(i,1)=average_abs1(i,1)-1.15.*sqrt(V1(i,1));% ��������75%��Ӧ1.15��95%
end

plot(frequency,shangxian1,'r','linewidth',2);
hold on
plot(frequency,xiaxian1,'r','linewidth',2);


%�������ҩ����������
ABS2=[absorption_coefficient3 absorption_coefficient4 absorption_coefficient5 ];%�����¾���
for i=1:701
average_abs2(i,1)=(sum(ABS2(i,:)))./3; %ÿ�е����������������ƽ��ֵ
end
plot(frequency(1:m),average_abs2,'k','linewidth',2);
hold on;
% plot(frequency(1:m),absorption_coefficient,'--g','linewidth',1);
% hold on;
% plot(frequency(1:m),absorption_coefficient1,'--b','linewidth',1);
% hold on;
% plot(frequency(1:m),absorption_coefficient2,'--m','linewidth',1);
% hold on;
legend('AVERAGE2','Y00','Y20','Y30');
grid on
title('Absorption coefficient of');
xlabel('Frequency (THz)');
ylabel('Absorption coefficient (��)');
xlim([0.1,1]);  
V2=var(ABS2,1,2);%����ĸ�巽�� 1��ĸ�巽�� 2�����м���
for i=1:701
shangxian2(i,1)=average_abs2(i,1)+1.15.*sqrt(V2(i,1));%  ����������㹫ʽ��ƽ��ֵx+-��Z��/2*sigama��
xiaxian2(i,1)=average_abs2(i,1)-1.15.*sqrt(V2(i,1));% ��������75%��Ӧ1.15��95%:1.96
end

plot(frequency,shangxian2,'--r','linewidth',2);
hold on
plot(frequency,xiaxian2,'--r','linewidth',2);
legend('AVERAGE1','S1','X1','averange2','s2','x2');



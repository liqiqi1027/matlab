%计算国产药的置信区间
ABS1=[absorption_coefficient absorption_coefficient1 absorption_coefficient2 ];%构成新矩阵
for i=1:701
average_abs1(i,1)=(sum(ABS1(i,:)))./3; %每行的所有数据求和再求平均值
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
ylabel('Absorption coefficient (α)');
xlim([0.1,1]);  

for i=1:701
sigama1(i,1)=sqrt(sum((ABS1(i,:)-average_abs1(i,1)).^2)/3); %计算标准差
shangxian1(i,1)=average_abs1(i,1)+1.15.*sigama1(i,1)./sqrt(3);%  置信区间计算公式：平均值x+-（Zα/2*sigama/根号n）
xiaxian1(i,1)=average_abs1(i,1)-1.15.*sigama1(i,1)./sqrt(3);% 置信区间75%对应1.15；95%
end

plot(frequency,shangxian1,'r','linewidth',2);
hold on
plot(frequency,xiaxian1,'r','linewidth',2);


%计算进口药的置信区间
ABS2=[absorption_coefficient3 absorption_coefficient4 absorption_coefficient5 ];%构成新矩阵
for i=1:701
average_abs2(i,1)=(sum(ABS2(i,:)))./3; %每行的所有数据求和再求平均值
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
ylabel('Absorption coefficient (α)');
xlim([0.1,1]);  

for i=1:701
sigama2(i,1)=sqrt(sum((ABS2(i,:)-average_abs2(i,1)).^2)/3); %计算标准差
shangxian2(i,1)=average_abs2(i,1)+1.15.*sigama2(i,1)./sqrt(3);%  置信区间计算公式：平均值x+-（Zα/2*sigama/根号n）
xiaxian2(i,1)=average_abs2(i,1)-1.15.*sigama2(i,1)./sqrt(3);% 置信区间75%对应1.15；95%
end

plot(frequency,shangxian2,'--r','linewidth',2);
hold on
plot(frequency,xiaxian2,'--r','linewidth',2);
legend('AVERAGE1','S1','X1','averange2','s2','x2');



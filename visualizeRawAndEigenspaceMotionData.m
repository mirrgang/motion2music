close all;
raw = csvread(fullfile('/home/melanie/WORKSPACE/motion2music2017/motion_phone/','AladdinSane_#8_acc.csv'));
pre_processed = load('motion_data_pre_processed/AladdinSane_#8_.mat');
eigenspace = load('motion_data_in_eigenspace/AladdinSane_#8_.mat');
durationInSeconds = 20;
N = size(raw,1);
x_unit = durationInSeconds/N;
xticks = 0:x_unit:durationInSeconds-x_unit;

durationInSecondsCut = 15;
Npre = size(pre_processed.data(:,1),1);
x_unit = durationInSecondsCut/Npre;
xticksPre = 5:x_unit:durationInSeconds-x_unit;

figure
subplot(3,1,1)
hold on
plot(xticks, raw(:,1), 'k-');
r1 = plot(xticks, raw(:,2), '.-');
r2 = plot(xticks, raw(:,3), ':');
legend('x','y','z');
xlabel('time in s');
ylabel('m/s²');
ylim([-40 40]);
xlim([0 20])
set(r1, 'color', [0.6 0.6 0.6]);
set(r2, 'color', [0.2 0.2 0.2]);
title('original accelerometer data')
hold off
subplot(3,1,2)
hold on
plot(xticksPre, pre_processed.data(:,1), 'k-');
p1 = plot(xticksPre, pre_processed.data(:,2), '.-');
p2 = plot(xticksPre, pre_processed.data(:,3), ':');
legend('x','y','z');
xlabel('time in s');
ylabel('m/s²');
ylim([-40 40]);
xlim([0 20])
set(p1, 'color', [0.6 0.6 0.6]);
set(p2, 'color', [0.2 0.2 0.2]);
title('pre-processed accelerometer data')
subplot(3,1,3)
hold on
plot(xticksPre, eigenspace.data(:,1), 'k-');
e1 = plot(xticksPre, eigenspace.data(:,2), '.-');
e2 = plot(xticksPre, eigenspace.data(:,3), ':');
legend('PC1', 'PC2', 'PC3');
xlabel('time in s');
ylabel('m/s²');
ylim([-40 40]);
xlim([0 20])
set(e1, 'color', [0.6 0.6 0.6]);
set(e2, 'color', [0.2 0.2 0.2]);
title('pre-processed accelerometer data in eigenspace')

%###############################################
%#### FEATURES FROM EIGENSPACE #################
n_segments = 15
FS = size(eigenspace.data,1)/durationInSecondsCut;


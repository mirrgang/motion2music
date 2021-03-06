function [features] = extract_motion_features( x_pca, FS, duration, n_segments )
%EXTRACT_FEATURES extracts spectral and temporal features from signal x
%according to size, tempo, smoothness and regularity.

%Synopsis:
% FEATURES= extract_features( x, FS, duration, n_segments )
%
%Arguments:
% x_pca -       motion sensor data with sample points in the rows and dimensions
%               or PCs in the columns
% FS-           sampling rate
% duration -    duration of signal in seconds
% n_segments -  number of segments to average amplitude over  
%
%Returns:
% FEATURES     - features extracted from motion signal


interval = floor(size(x_pca,1)/n_segments);%interval in which to determine max distance from min to max peak
features = [];
%COMPUTE VOLUME over all dimensions
DT = delaunayTriangulation(x_pca);%triangulates data points
[K,volume] = convexHull(DT);%computes volume of triangulated body spanned by the motion data points

%for each of the three dimensions, either PCs or raw signals
freq_hz = zeros(3,1);
freq_mag = zeros(3,1);
max_freq_rel = zeros(3,1);
sidewards_upwards_ratio = 1;

for i=1:1:3    
    %********* SPECTRAL FEATURES ******************************
    %COMPUTE SPECTRUM
    close all;
    N = length(x_pca(:,i));
    X = fft(x_pca(:,i));%apply the fast fourier transform
    X1 = fft(x_pca(:,1));
    X2 = fft(x_pca(:,2));
    X3 = fft(x_pca(:,3));
    X_mag1 = abs(X1);
    X_mag2 = abs(X2);
    X_mag3 = abs(X3);
    
    X_mag = abs(X);%magnitude of frequency values
    freqs = FS*(0:(N/2))/N;
%     freqs = FS/2*linspace(0,1,N/2+1);%corresponding frequencies
    
    [peaks,locs] = findpeaks(X_mag(1:N/2+1));
    [peaks1,locs1] = findpeaks(X_mag1(1:N/2+1));
    [peaks2,locs2] = findpeaks(X_mag2(1:N/2+1));
    [peaks3,locs3] = findpeaks(X_mag3(1:N/2+1));
   
    %MAX FREQUENCY + MAGNITUDE
    [max_freq_mag1, max_1] = max(X_mag1(1:end));
    [max_freq_mag2, max_2] = max(X_mag2(1:end));
    [max_freq_mag3, max_3] = max(X_mag3(1:end));
    magnitudes = [max_freq_mag1, max_freq_mag2, max_freq_mag3];
    [max_magnitude, idx] = max(magnitudes);
    
    
    [max_freq_mag, max_i] = max(X_mag(1:end));    
    max_freq = freqs(max_i);
    freq_hz(i) = max_freq;
    freq_mag(i) = max_freq_mag;
    
    %median of peaks
    sorted_peaks = sort(peaks, 'descend');
    median_peaks = median(sorted_peaks);
    max_freq_rel(i) = max_freq_mag/median_peaks; %max magnitude w.r.t. median of all peak magnitudes
    
    delta = duration/length(x_pca(:,i));
    time_sec = 5:delta:duration+5-delta;
    
    
    figure;   
    subplot(4,1,1);
    hold on;
    plot(time_sec,x_pca(:,1),'k-');
    t1 = plot(time_sec,x_pca(:,2),'.-');
    t2 = plot(time_sec,x_pca(:,3),':');
    set(t1, 'color', [0.6 0.6 0.6]);
    set(t2, 'color', [0.2 0.2 0.2]);
    legend('PC1', 'PC2', 'PC3');
    ylabel('m/s^{2}');
    xlabel('time in s');
    ylim([-40 40]);
    title('motion data in eigenspace');
    
    subplot(4,1,2);
    hold on;
    plot(freqs,(X_mag1(1:N/2+1)),'k-');
    p1 = plot(freqs,(X_mag2(1:N/2+1)),'.-');
    p2 = plot(freqs,(X_mag3(1:N/2+1)),':');
    set(p1, 'color', [0.6 0.6 0.6]);
    set(p2, 'color', [0.2 0.2 0.2]);
    %plot(freqs(1,locs(:,1)),peaks, 'xb');
    %plot(freqs(1,locs1), peaks1,'*b');
   	%plot(freqs(1,locs2), peaks2,'*r');
   	%plot(freqs(1,locs3), peaks3,'*g');
    
    if max_freq_mag1==max_magnitude
        %max_point = [freqs(1,max_1), max_magnitude]; 
        plot(freqs(1,max_1), max_magnitude,'*k');
    elseif max_freq_mag2==max_magnitude
        %max_point = [freqs(1,max_2), max_magnitude]; 
        n1 = plot(freqs(1,max_2), max_magnitude,'*');
        set(n1, 'color', [0.6 0.6 0.6]);
    else
        %max_point = [freqs(1,max_3), max_magnitude]; 
        n2 = plot(freqs(1,max_3), max_magnitude,'*');    
        set(n2, 'color', [0.2 0.2 0.2]);
    end
    legend('PC1', 'PC2', 'PC3', 'most dominant frequency');
    %legend('PC1', 'peaks PC1');
    xlabel('Frequency (Hz)');
    ylabel('|X|');
    title('frequency magnitudes');
%     
%     
%     
%     
%     %********** TEMPORAL FEATURES ************************** 
    [crossings, midlevel] = midcross(x_pca(:,i), FS, 'Tolerance', 45);
   % statelevels(x(:,i));
%     [crossings1, midlevel1] = midcross(x_raw(:,1), FS, 'MidPct',80);
%     [crossings2, midlevel2] = midcross(x_raw(:,1), FS, 'StateLevels', [-3 3],'MidPct',5);
    %[crossings3, midlevel3] = midcross(x_raw(:,1), FS, 'Tolerance', 45);
  %  crossings2 = midcross(x(:,2), FS);
%    crossings3 = midcross(x(:,3), FS);
    
    
    [rise_time,LTr, UTr] = risetime(x_pca(:,i), FS);
    [fall_time,LTf, UTf] = falltime(x_pca(:,i), FS);
    
    
    peak_to_peak = zeros(n_segments,1);
    min_s = zeros(n_segments,2);
    max_s = zeros(n_segments,2);
    beginning=1;
    
    subplot(4,1,3);
    hold on;
    plot(time_sec,x_pca(:,i), ':');
    for j=1:n_segments    
        if j~=n_segments
            peak_to_peak(j,1) = peak2peak(x_pca(beginning:beginning+interval-1,i));
            [min_s(j,2),min_s(j,1)] = min(x_pca(beginning:beginning+interval-1,i));
            [max_s(j,2),max_s(j,1)] = max(x_pca(beginning:beginning+interval-1,i));
            min_s(j,1) = min_s(j,1)+interval*(j-1);
            max_s(j,1) = max_s(j,1)+interval*(j-1);
        else 
            peak_to_peak(j,1) = peak2peak(x_pca(beginning:end,i));
            [min_s(j,2),min_s(j,1)] = min(x_pca(beginning:end,i));
            [max_s(j,2),max_s(j,1)] = max(x_pca(beginning:end,i));
            min_s(j,1) = min_s(j,1)+interval*(j-1);
            max_s(j,1) = max_s(j,1)+interval*(j-1);
        end
        beginning = beginning + interval;
        plot([time_sec(min_s(j,1)) time_sec(max_s(j,1))], [min_s(j,2) max_s(j,2)],'k');
        plot([time_sec(max_s(j,1)) time_sec(max_s(j,1))], [min_s(j,2) max_s(j,2)],'.-');
    end
    
    
    %plot(time_sec,x(:,2),':r');
    %plot(time_sec,x(:,3),':g');    
    ylim([-40 40]);
    ylabel('m/s^{2}');
    xlabel('time in s');
    legend(strcat('PC1'), strcat('rise and fall PC1'),strcat('peak amplitude PC1'));
    title('rise and fall times, and peak amplitude');
    
    subplot(4,1,4);
    hold on;
    %plot(crossings1, ones(length(crossings1),1)*midlevel1,'*b');
    %plot(crossings2, ones(length(crossings2),1)*midlevel2,'*r');
    plot(crossings+5, ones(length(crossings),1)*midlevel,'*k');
%     plot(crossings2, zeros(length(crossings2),1),'*r');
%     plot(crossings3, zeros(length(crossings3),1),'*g');
    plot(time_sec,x_pca(:,i), ':k');
   % plot(time_sec,x(:,2),'r');
   % plot(time_sec,x(:,3),'g');    
    ylim([-40 40]);
    ylabel(strcat('m/', 's^2'));
    xlabel('time in s');
    legend('midcrosses PC1','PC1');
    title('distance between midrosses (*)');
    
    %compute distance between midcrosses
    distance_midcrosses = abs(crossings(1:end-1)-crossings(2:end));
    median_dist_midcrosses = median(distance_midcrosses);
    std_dist_midcrosses = std(distance_midcrosses);
%     figure;
%     hist(distance_midcrosses);%check distribution of features
    skewness_dist_midcrosses = skewness(distance_midcrosses);
    if isnan(median_dist_midcrosses)
        %when there is no crossing, median is set to -1 (THINK about alternative)
        median_dist_midcrosses = -1;
    end
    
    if isnan(std_dist_midcrosses)
        std_dist_midcrosses = 0;
    end
    
    if isnan(skewness_dist_midcrosses)
        %when no or too few crossings for distribution, the skewness is set
        %to 0 because NAN cannot be handled by regression model
        skewness_dist_midcrosses = 0;
    end

if ~isempty(rise_time)
    %hist(rise_time);%check distribution of features
    rise_std = std(rise_time,1,1);
    rise_skewness = skewness(rise_time);
    rise_median = median(rise_time,1);
else
    rise_std = 0;
    rise_skewness = 0;
    rise_median = 0;
end

if ~isempty(fall_time)
    %hist(fall_time);%check distribution of features
    fall_std = std(fall_time,1,1);
    fall_skewness = skewness(fall_time);
    fall_median = median(fall_time,1);
else
    fall_std = 0;
    fall_skewness = 0;
    fall_median = 0;
end

if ~isempty(peak_to_peak)
    %hist(peak_to_peak);%check distribution of features
    peak_std = std(peak_to_peak,1,1);
    peak_skewness = skewness(peak_to_peak,1,1);
    peak_median = median(peak_to_peak,1);
    if i==1
        sidewards_upwards_ratio = peak_median;
    elseif i==2
        sidewards_upwards_ratio = sidewards_upwards_ratio/peak_median -1;    
    end
else
    peak_std = 0;
    peak_skewness = 0;
    peak_median = 0;
end
    if isnan(peak_skewness)
        peak_skewness = 0;
    end
    if isnan(fall_skewness)
        fall_skewness = 0;
    end
    if isnan(rise_skewness)
        rise_skewness = 0;
    end
    features = [features median_dist_midcrosses std_dist_midcrosses rise_median rise_std fall_median fall_std peak_median peak_std];
end
%8*3 features = 24 features + 5 features over all
[max_freq_mag, ind] = max(freq_mag);
max_freq_hz = freq_hz(ind);
max_freq_rel = max_freq_rel(ind);
% = 29
features = [max_freq_hz max_freq_mag max_freq_rel volume features sidewards_upwards_ratio];
end




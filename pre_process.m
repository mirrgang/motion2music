function [x_processed] = pre_process( x, duration, requested_duration, off_set, N_requested )
%PRE_PROCESS pre-processes signal x, i.e. it cuts-off the off-set from x's 
%beginning and end to achieve the requested duration.
% In the second step the signal is sampled down according to N_requested.

%Synopsis:
% X_Processed = pre_process( x, FS, duration, n_segments )
%
%Arguments:
% x -           motion sensor data with sample points in the rows and dimensions
%               or PCs in the columns
% duration -    duration of signal in seconds
% off_set -  	time in seconds to be cut at the beginning of motion signals
% N_requested - requested number of sample points
%
%Returns:
% X_Processed     - processed motion signals with standard duration and
%                   sampling rate


N = size(x,1);

%get FS
FS = N/duration;
cut_off_beg_N = round(off_set*FS);
% cut_off_end_s = duration-off_set-requested_duration;
% cut_off_end_N = cut_off_end_s*FS;
cut_off_end_N = N-cut_off_beg_N-N_requested
if cut_off_end_N < 0
    cut_off_end_N = 0;
end
%cut off beginning when people are just about to get into the flow
cut_signal = x(cut_off_beg_N:end-cut_off_end_N, :);

%##### adjust sample rate ######################
r = round(size(cut_signal,1)/N_requested); % scaling factor
x_x = decimate(cut_signal(:,1),r);
x_y = decimate(cut_signal(:,2),r);
x_z = decimate(cut_signal(:,3),r);
x_processed = [x_x x_y x_z]; 
end


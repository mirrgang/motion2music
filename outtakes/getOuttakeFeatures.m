function [outtake_data] = getOuttakeFeatures()
fid = fopen('outtakes.csv');
A = textscan(fid, '%s%f%f', 'Delimiter', ',');
fclose(fid);
outtake_data = [A{2} A{3}]
end


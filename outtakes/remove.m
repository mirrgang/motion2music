function [ B ] = remove( values_to_be_removed, A )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
B = A;
for j=1:1:length(values_to_be_removed)
    value_to_be_removed = values_to_be_removed(j);
    B = B(B~=value_to_be_removed);
end
end


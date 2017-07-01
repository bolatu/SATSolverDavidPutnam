function [ output ] = ApplyRule( input, sel_column, sel_value)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

output = zeros(size(input));
zero_counter = 0;
index = 0;

for k=1:size(input,3)
    for i=1:size(input,1)
        for j=1:size(input,2)
            if input(i,j,k) == 0
                zero_counter = zero_counter + 1;
            elseif input(i,j,k) == 1 || input(i,j,k) == -1
                index = j;
            end
        end
        % checking if this is a unit clause
        if size(input,2) == zero_counter+1 && index == sel_column
            if (sel_value == 1 && input(i,sel_column,k) == -1) || (sel_value == -1 && input(i,sel_column,k) == 1)
                % make whole column -2 because sel_value for unit clause is 0
                output(i,:,k) = -2;
            elseif (sel_value == -1 && input(i,sel_column,k) == -1) || (sel_value == 1 && input(i,sel_column,k) == 1)
                output(i,j,k) = 0;
            end
        elseif zero_counter >= 0 && zero_counter < size(input,2)
            if (sel_value == -1 && input(i,sel_column,k) == -1) || (sel_value == 1 && input(i,sel_column,k) == 1)
                % make whole column zero
                output(i,:,k) = 0;
            elseif (sel_value == 1 && input(i,sel_column,k) == -1) || (sel_value == -1 && input(i,sel_column,k) == 1)
                % make unit clause zero only
                output(i,:,k) = input(i,:,k);
                output(i,sel_column,k) = 0;
            else
                output(i,:,k) = input(i,:,k);
            end
        end
        zero_counter = 0;
        index = 0;
    end
end

end


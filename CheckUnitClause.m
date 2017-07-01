function [ output_args ] = CheckUnitClause( input_args )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
% output_arg = [ a b ]
% column a is index of the row where unit clause is located
% column b is value of the unit clause
counter = 0;
index = 0;
value = 0;
unit_clause = zeros(size(input_args,1),2,size(input_args,3));
for k = 1:size(input_args,3)
    for i=1:size(input_args,1)
        for j=1:size(input_args,2)
            if input_args(i,j,k) == 0
                counter = counter + 1;
            elseif input_args(i,j,k) == 1 || input_args(i,j,k) == -1
                index = j;
                value = input_args(i,j,k);
            end
        end
        if size(input_args,2) == counter+1
            unit_clause(i,1,k) = index;
            unit_clause(i,2,k) = value;
        end
        counter = 0;
        index = 0;
    end
end

output_args = unit_clause;
end




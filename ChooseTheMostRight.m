function [ sel_column, sel_val ] = ChooseTheMostRight( clauses )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

sel_column = -2;
sel_val = -2;

bf = false;
for i=size(clauses,3):-1:1
    for j=size(clauses,2):-1:1
        for k=size(clauses,1):-1:1
            if clauses(k,j,i) ~= 0
                sel_column = j;
                sel_val = clauses(k,j,i);
                bf = true;
                break
            end
        end
        if bf
            break
        end
    end
    if bf
        break
    end
end

end


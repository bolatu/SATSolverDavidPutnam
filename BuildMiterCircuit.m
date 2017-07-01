function [ clauses ] = BuildMiterCircuit( no_connections1, netlist1, inputs1, outputs1, no_connections2, netlist2, inputs2, outputs2 )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% same inputs goes to same row
combo_input = [];
for i=1:size(inputs1)
   for j=1:size(inputs2) 
    if strcmp(inputs1{i,1}, inputs2{j,1})
        numeric_data1 = str2num(inputs1{i,2});
        numeric_data2 = str2num(inputs2{j,2})+no_connections1;
        if ~isempty(numeric_data1) && ~isempty(numeric_data1)
            combo_input = [combo_input; [numeric_data1 numeric_data2]];
        end
    end
   end
end


% same outputss goes to same row
combo_output = [];
for i=1:size(outputs1)
   for j=1:size(outputs2) 
    if strcmp(outputs1{i,1}, outputs2{j,1})
        numeric_data1 = str2num(outputs1{i,2});
        numeric_data2 = str2num(outputs2{j,2})+no_connections1;
        if ~isempty(numeric_data1) && ~isempty(numeric_data1)
            combo_output = [combo_output; [numeric_data1 numeric_data2]];
        end
    end
   end
end

clauses = zeros(4, ...
    no_connections1+no_connections2+size(outputs1,1), ...
    size(netlist1,1)+size(netlist2,1)+size(inputs1,1)+size(outputs1,1) + 1);


% connecting inputs together with this format
% (a v ~b)(~a v b)
for i=1:size(combo_input,1)
        clauses(1, combo_input(i,1), i) = 1;
        clauses(1, combo_input(i,2), i) = -1;
        clauses(2, combo_input(i,1), i) = -1;
        clauses(2, combo_input(i,2), i) = 1;
end


% converting string cell to numeric number for netlist1
row_connections = [];
for i = 1:size(netlist1,1)
    for j = 2:size(netlist1,2)
        numeric_data = str2num(netlist1{i,j});
        if ~isempty(numeric_data)
            row_connections = [row_connections; numeric_data];
        end
    end
    
    % creating a clause for the current row
    if strcmp('inv', netlist1{i,1})
        clauses(1, row_connections(1), i+size(inputs1,1)) = 1;
        clauses(1, row_connections(2), i+size(inputs1,1)) = 1;
        clauses(2, row_connections(1), i+size(inputs1,1)) = -1;
        clauses(2, row_connections(2), i+size(inputs1,1)) = -1;
    elseif strcmp('or', netlist1{i,1})
        clauses(1, row_connections(1), i+size(inputs1,1)) = -1;
        clauses(1, row_connections(3), i+size(inputs1,1)) = 1;
        clauses(2, row_connections(2), i+size(inputs1,1)) = -1;
        clauses(2, row_connections(3), i+size(inputs1,1)) = 1;
        clauses(3, row_connections(1), i+size(inputs1,1)) = 1;
        clauses(3, row_connections(2), i+size(inputs1,1)) = 1;
        clauses(3, row_connections(3), i+size(inputs1,1)) = -1;
    elseif strcmp('and', netlist1{i,1})
        clauses(1, row_connections(1), i+size(inputs1,1)) = 1;
        clauses(1, row_connections(3), i+size(inputs1,1)) = -1;
        clauses(2, row_connections(2), i+size(inputs1,1)) = 1;
        clauses(2, row_connections(3), i+size(inputs1,1)) = -1;
        clauses(3, row_connections(1), i+size(inputs1,1)) = -1;
        clauses(3, row_connections(2), i+size(inputs1,1)) = -1;
        clauses(3, row_connections(3), i+size(inputs1,1)) = 1;
    elseif strcmp('xor', netlist1{i,1})
        clauses(1, row_connections(1), i+size(inputs1,1)) = 1;
        clauses(1, row_connections(2), i+size(inputs1,1)) = 1;
        clauses(1, row_connections(3), i+size(inputs1,1)) = -1;
        clauses(2, row_connections(1), i+size(inputs1,1)) = -1;
        clauses(2, row_connections(2), i+size(inputs1,1)) = -1;
        clauses(2, row_connections(3), i+size(inputs1,1)) = -1;
        clauses(3, row_connections(1), i+size(inputs1,1)) = -1;
        clauses(3, row_connections(2), i+size(inputs1,1)) = 1;
        clauses(3, row_connections(3), i+size(inputs1,1)) = 1;
        clauses(4, row_connections(1), i+size(inputs1,1)) = 1;
        clauses(4, row_connections(2), i+size(inputs1,1)) = -1;
        clauses(4, row_connections(3), i+size(inputs1,1)) = 1;
    else
        disp('unknown gate type')
    end
    
    row_connections = [];
    
end


% converting string cell to numeric number for netlist2
for i = 1:size(netlist2,1)
    for j = 2:size(netlist2,2)
        numeric_data = str2num(netlist2{i,j});
        if ~isempty(numeric_data)
            row_connections = [row_connections; numeric_data+no_connections1];
        end
    end
    
    % creating a clause for the current row
    if strcmp('inv', netlist2{i,1})
        clauses(1, row_connections(1), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(1, row_connections(2), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(2, row_connections(1), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(2, row_connections(2), i+size(inputs1,1)+size(netlist1,1)) = -1;
    elseif strcmp('or', netlist2{i,1})
        clauses(1, row_connections(1), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(1, row_connections(3), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(2, row_connections(2), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(2, row_connections(3), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(3, row_connections(1), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(3, row_connections(2), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(3, row_connections(3), i+size(inputs1,1)+size(netlist1,1)) = -1;
    elseif strcmp('and', netlist2{i,1})
        clauses(1, row_connections(1), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(1, row_connections(3), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(2, row_connections(2), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(2, row_connections(3), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(3, row_connections(1), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(3, row_connections(2), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(3, row_connections(3), i+size(inputs1,1)+size(netlist1,1)) = 1;
    elseif strcmp('xor', netlist2{i,1})
        clauses(1, row_connections(1), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(1, row_connections(2), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(1, row_connections(3), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(2, row_connections(1), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(2, row_connections(2), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(2, row_connections(3), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(3, row_connections(1), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(3, row_connections(2), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(3, row_connections(3), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(4, row_connections(1), i+size(inputs1,1)+size(netlist1,1)) = 1;
        clauses(4, row_connections(2), i+size(inputs1,1)+size(netlist1,1)) = -1;
        clauses(4, row_connections(3), i+size(inputs1,1)+size(netlist1,1)) = 1;
    else
        disp('unknown gate type')
    end
    
    row_connections = [];
    
end


% xors for the output pins
for i=1:size(combo_output,1)
        clauses(1, combo_output(i,1), i+size(inputs1,1)+size(netlist1,1)+size(netlist2,1)) = 1;
        clauses(1, combo_output(i,2), i+size(inputs1,1)+size(netlist1,1)+size(netlist2,1)) = 1;
        clauses(1, i+no_connections1+no_connections2, i+size(inputs1,1)+size(netlist1,1)+size(netlist2,1)) = -1;
        clauses(2, combo_output(i,1), i+size(inputs1,1)+size(netlist1,1)+size(netlist2,1)) = -1;
        clauses(2, combo_output(i,2), i+size(inputs1,1)+size(netlist1,1)+size(netlist2,1)) = -1;
        clauses(2, i+no_connections1+no_connections2, i+size(inputs1,1)+size(netlist1,1)+size(netlist2,1)) = -1;
        clauses(3, combo_output(i,1), i+size(inputs1,1)+size(netlist1,1)+size(netlist2,1)) = -1;
        clauses(3, combo_output(i,2), i+size(inputs1,1)+size(netlist1,1)+size(netlist2,1)) = 1;
        clauses(3, i+no_connections1+no_connections2, i+size(inputs1,1)+size(netlist1,1)+size(netlist2,1)) = 1;
        clauses(4, combo_output(i,1), i+size(inputs1,1)+size(netlist1,1)+size(netlist2,1)) = 1;
        clauses(4, combo_output(i,2), i+size(inputs1,1)+size(netlist1,1)+size(netlist2,1)) = -1;
        clauses(4, i+no_connections1+no_connections2, i+size(inputs1,1)+size(netlist1,1)+size(netlist2,1)) = 1;
end

% all xors' output is connected in this form as one clause
% since if one of them is 1, the clause is cancelled 
% (a v b v c v ...)
for i=1:size(outputs1,1)
    clauses(1, i+no_connections1+no_connections2,size(netlist1,1)+size(netlist2,1)+size(inputs1,1)+size(outputs1,1) + 1) = 1;
end

end


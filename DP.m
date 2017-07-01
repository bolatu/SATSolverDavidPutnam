clear
close all
clc

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Before reading netlist files, they are converted to .cvs file for the
% convenience, then reading has been operated over those files.
% In this files, all those netlist has been read. To try all the 
% combinations, you simply comment/uncomment the CSVReadWithString lines
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Data Structure Format for the clauses has been mapped following:
% %% NOT Gate
% (a ∨ c)(~a ∨ ~c)
% clause1 = ...
%       a b c d e f g h i
%     [ 1 0 1 0 0 0 0 0 0; ...
%      -1 0 -1 0 0 0 0 0 0];
% clauses(1:size(clause1,1),1:size(clause1,2), 1) = clause1;
% %% xor
% %(c ∨ e ∨ ~h)(~c ∨ ~e ∨ ~h)(~c ∨ e ∨ h)(c ∨ ~e ∨ h)
% clause6 = ...
%       a b c d e f g h i
%     [ 0 0 1 0 1 0 0 -1 0; ...
%       0 0 -1 0 -1 0 0 -1 0; ...
%       0 0 -1 0 1 0 0 1 0;  ...
%       0 0 1 0 -1 0 0 -1 0];
% clauses(1:size(clause6,1),1:size(clause6,2), 6) = clause6;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SAT Results of the David-Putnam Algorithm:
% SAT_Result.isSucceed == 0 then no solution possible so
% SAT_Result.counter_example = 0
% SAT_Result.isSucceed == 1 then there is a solution so
% SAT_Result.counter_example = possible tree
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



[SAT_Result.no_connections1, SAT_Result.header1, SAT_Result.netlist1, SAT_Result.inputs1, SAT_Result.outputs1] = ... 
    CSVReadWithString('netlists/adder4.csv')
[SAT_Result.no_connections2, SAT_Result.header2, SAT_Result.netlist2, SAT_Result.inputs2, SAT_Result.outputs2] = ... 
    CSVReadWithString('netlists/adder4_rc_wrong.csv')
% [SAT_Result.no_connections2, SAT_Result.header2, SAT_Result.netlist2, SAT_Result.inputs2, SAT_Result.outputs2] = ... 
%     CSVReadWithString('netlists/adder4_rc.csv')


% [SAT_Result.no_connections1, SAT_Result.header1, SAT_Result.netlist1, SAT_Result.inputs1, SAT_Result.outputs1] = ... 
%     CSVReadWithString('netlists/xor2.csv')
% [SAT_Result.no_connections2, SAT_Result.header2, SAT_Result.netlist2, SAT_Result.inputs2, SAT_Result.outputs2] = ... 
%     CSVReadWithString('netlists/xor2_nand_wrong.csv')
% % [SAT_Result.no_connections2, SAT_Result.header2, SAT_Result.netlist2, SAT_Result.inputs2, SAT_Result.outputs2] = ... 
% %     CSVReadWithString('netlists/xor2_nand.csv')



[SAT_Result.total_clauses] = BuildMiterCircuit( ... 
    SAT_Result.no_connections1, SAT_Result.netlist1, SAT_Result.inputs1, SAT_Result.outputs1, ...
    SAT_Result.no_connections2, SAT_Result.netlist2, SAT_Result.inputs2, SAT_Result.outputs2 );

SAT_Result.total_no_clauses = size(SAT_Result.total_clauses,3);
SAT_Result.total_no_connections = size(SAT_Result.total_clauses,2);


SAT_Result.counter_example = [];
isSucceed = false;
isUCSafe = true;
isCNF0Safe = true;
isCNF1safe = true;

[sel_column, sel_val] = ChooseTheMostRight(SAT_Result.total_clauses);
% starting with 1 always because we wanna see if any xor output being 1
SAT_Result.total_clauses = ApplyRule(SAT_Result.total_clauses, sel_column, 1);

% start the search
[ temp_counter_example, SAT_Result.isSucceed ] = RecursiveFunction(...
    SAT_Result.total_clauses, sel_column, -1, ...
    SAT_Result.counter_example, isSucceed, isUCSafe, isCNF0Safe, isCNF1safe);
% end of search

if SAT_Result.isSucceed
    % replacing -1s with 0s for the representation
    temp_counter_example(temp_counter_example==-1)=0;    
    SAT_Result.counter_example = temp_counter_example;
    disp('===============')
    disp('a solution found')
    disp('counter example:') 
    SAT_Result.counter_example
else
    disp('===============')
    disp('no solution found')
    SAT_Result.counter_example = 0;
end


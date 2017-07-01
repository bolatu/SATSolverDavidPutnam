function [ tree, isSucceed ] = RecursiveFunction( clauses, sel_column, sel_val, tree, isSucceed, isUCSafe, isCNF0Safe, isCNF1safe )

if isSucceed
    return
end

% are clauses empty?
if any(any(any(clauses,2),1),3) == 0
    isSucceed = true;
    disp('beginning: isSucceed')
    disp('end of recursion')
    return
end

uc_index = CheckUnitClause(clauses);


if any(uc_index(:,1,:)) == 0
    %% no unit clause exist so cnf0 and cnf1
    cnf0 = clauses;
    cnf1 = clauses;
    
    % choosing the most right variable here since this is not a unit clause!
    [sel_column, sel_val] = ChooseTheMostRight(clauses);
    
    % is cnf0 safe?
    if isCNF0Safe == true
        disp('===============')
        cnf0 = ApplyRule(cnf0, sel_column, -1);
        if  sum(find(cnf0==-2))~=0
            disp('cnf0: not good')
            disp('===============')
            isCNF0Safe = false;
            return
        else
            disp('cnf0: good')
            isCNF0Safe = true;
            tree = [tree; [sel_column -1]]
            disp('===============')
            [ tree, isSucceed ] = RecursiveFunction(cnf0, sel_column, sel_val, tree, isSucceed, isUCSafe, isCNF0Safe, isCNF1safe);
        end
    else
        return
    end
    
    if isSucceed
        return
    end
    
    % is cnf1 safe?
    if isCNF1safe == true
        disp('===============')
        % since we are in the cnf1, that means cnf0 is failed and we are 
        % backtracking so delete the previous tree from cnf0
        backtrack_tree = find(tree==sel_column);
        if isempty(backtrack_tree)
             disp('bt_path is empty')
        elseif backtrack_tree == 1
            tree = [];
        else
            tree = tree(1:backtrack_tree-1,:);
        end
        
        cnf1 = ApplyRule(cnf1, sel_column, 1);
        if  sum(find(cnf1==-2))~=0
            disp('cnf1: not good')
            disp('===============')
            isCNF1safe = false;
            return
        else
            sCNF1safe = true;
            tree = [tree; [sel_column 1]]
            disp('cnf1: good')
            disp('===============')
            
            [ tree, isSucceed ] = RecursiveFunction(cnf1, sel_column, sel_val, tree, isSucceed, isUCSafe, isCNF0Safe, isCNF1safe);
            disp('===============')
            disp('cnf: backtracking')
            disp('===============')
            
        end
    else
        return
    end
    
    
    
else
    %% unit clause exist
    
    % sometimes, more than one clause have the same unit clause variable 
    % so create sorted unit clause matrix
    sorted_uc_index=[];
    for k=1:size(uc_index,3)
        a=any(uc_index(:,:,k),2);
        for i=1:size(uc_index,1)
            if a(i) ~= 0
                sorted_uc_index = [sorted_uc_index; [uc_index(i,1,k) uc_index(i,2,k)]];
                [x,y] = find(uc_index(:,1,:)==uc_index(i,1,k));
                for p=1:size(x)
                    uc_index(x(p),:,y(p)) = 0;
                end
            end
        end
    end
    sorted_uc_index( ~any(sorted_uc_index,2), : ) = [];  %delete zero rows
    
    
    % now apply the unit clause rule
    for i=1:size(sorted_uc_index,1)
        sel_column = sorted_uc_index(i,1);
        sel_val = sorted_uc_index(i,2);
        
        tree = [tree; [sel_column sel_val]]
        clauses = ApplyRule(clauses, sel_column, sel_val);
        
        % are clauses safe?
        if  sum(find(clauses==-2))~=0
            % deleting last variable on the tree
            % because it is failed and i'm backtracking
            tree = tree(1:end-1,:);
            isUCSafe = false;
            disp('unit clause: -2 found')
            disp('===============')
            return
        end
    end
    disp('unit clause: good')
    disp('===============')
    isUCSafe = true;
    
    if sel_column == -2 && sel_val == -2
        % if i'm at this point and all clauses are empty
        % there is a solution
        disp('unit clause: isSucceed')
        isSucceed = true;
        return
    else
        [sel_column, sel_val] = ChooseTheMostRight(clauses);
        [ tree, isSucceed ] = RecursiveFunction(clauses, sel_column, sel_val, tree, isSucceed, isUCSafe, isCNF0Safe, isCNF1safe);
        disp('===============')
        disp('unit clause: backtracking')
        disp('===============')
        return
    end
end

% isSucceed = true;

end

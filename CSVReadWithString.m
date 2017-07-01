function [ no_connections, header, netlist, inputs, outputs ] = CSVReadWithString( filename )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
delimiter = ',';
startRow = 1;

%% Read columns of data as strings:
% For more information, see the TEXTSCAN documentation.
formatSpec = '%s%s%s%s%s%s%s%s%s%s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end

index=0
for i=1:size(raw,1)
    if strcmp(raw{i,1},'') == 1
        index = i;
    end
end

%% input
header = raw(1:index-1,:);
netlist = raw(index+1:end,1:4);

a =  cellfun('isempty',header);
s_count = 0;
for i=1:size(a(2,:),2)
    if ~a(2,i)
        s_count = s_count + 1;
    end
end

inputs = cell(s_count,1);
for i = 1:s_count
        inputs{i,1} = header{2,i};
end


%% output
s_count = 0;
for i=1:size(a(3,:),2)
    if ~a(3,i)
        s_count = s_count + 1;
    end
end

outputs = cell(s_count,1);
for i = 1:s_count
        outputs{i,1} = header{3,i};
end

%% netlist
for j=1:size(inputs,1)
    for i=4:size(header,1) % header column length
        if strcmp(inputs{j,1}, header{i,2})
            inputs{j,2} = header{i,1};
        end
    end
end

for j=1:size(outputs,1)
    for i=4:size(header,1) % header column length
        if strcmp(outputs{j,1}, header{i,2})
            outputs{j,2} = header{i,1};
        end
    end
end

no_connections = str2num(header{1,1});


end


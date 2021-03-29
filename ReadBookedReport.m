function newTable = ReadBookedReport()
%ReadBookedReport reads .CSV files downloaded from Booked, outputs table
%   Assumes .CSV file from booked generated with options:
%   Select: Time
%   Aggregate By: Resource
%   Range: Any
%   Filter By: Any
%   When asked to choose files, they need to be in date (month) order

%Turn off warning that happens but can be ignored
warning('off','MATLAB:table:RowsAddedExistingVars');

t = datetime(2020,3,18):calmonths(1):datetime(2021,2,18);
mon=month(t,'name');
files=uipickfiles();
opts=detectImportOptions(files{1});
opts.VariableTypes{2}='char';
for i=1:length(files)
    T=readtable(files{i},opts);
    T.Hours=str2double(extractBetween(T.Total,'(','h)'));
    if i==1
        newTable=table(T.Resource,T.Hours);
        newTable.Properties.VariableNames{'Var1'}='Resource';
        newTable.Properties.VariableNames{'Var2'}=mon{i};
        newTable.Properties.RowNames=newTable{:,1};
    else
        [m,n]=size(T);
        if not(m==0 || n==0)
            %Check if T has row names that are different from newTable
            %If yes, save to variable and add to newTable
            a=setdiff(T.Resource,newTable.Resource);
            if ~isempty(a)
                for k=1:length(a)
                    newTable.Resource(end+1)=a(k);
                    %ignore warning and fill empty column values with 0
                    newTable(end,2:end)={0};
                    newTable.Properties.RowNames=newTable{:,1};
                end
            end
            T.Properties.RowNames=T{:,1};
            %preallocate
            newTable(:,end+1)={0};
            for j=1:height(newTable)
                rowName=newTable.Properties.RowNames{j};
                if sum(ismember(T.Properties.RowNames,rowName))
                   newTable(rowName,end)=num2cell(T{rowName,'Hours'});
                end
            end
        else
            newTable(:,end+1)={0};
        end
        newTable.Properties.VariableNames(newTable.Properties.VariableNames{end})=mon(i);
    end 
end
newTable=removevars(newTable,{'Resource'});
newTable(:,end+1)=num2cell(sum(newTable{:,:}')');
newTable.Properties.VariableNames{end}='Total Hours';

%Turn all warnings back on
warning('on','all');
end
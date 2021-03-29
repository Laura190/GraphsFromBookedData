function [microscopeUsers,numUsers] = BookedUsers(reportFile)
%BookedUsers Summaries unique users. Some manual editing required
% microscopeUsers must be edited manually to remove some duplicated that
% have been spelled/formatted different or included experiment details.
% After editing manually, rerun the last three lines of code.
%   reportFile: Name of csv file exported from Booked with Resource, Title and User
T=readtable(reportFiles);
A=T.Title;
B=T.Users;
for i=1:length(T.Users)
    if (ismissing(B(i),{' '}))
        B(i)=A(i);
    end
end

T2=table(T.Resource,B);
microscopeUsers=unique(T2);

[u, ~, uidx] = unique(microscopeUsers.Var1);
counts = accumarray(uidx,1);
numUsers=table(u,counts);
        
end


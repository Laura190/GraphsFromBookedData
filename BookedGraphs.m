function [] = BookedGraphs(figName)
%BookedGraphs plots bar graphs from Booked reports
%   Detailed explanation goes here
UsageHours=ReadBookedReport();
UsageHours=sortrows(UsageHours,'RowNames');
figure;
bar(categorical(UsageHours.Properties.RowNames),UsageHours{:,'Total Hours'});
xlabel('Microscope');
ylabel('Time (Hours)');
matlab2tikz(strcat(figName,'_TotalHours.tex'))

n=round(height(UsageHours)/4)*2;
C=categorical(UsageHours.Properties.VariableNames(1:end-1));
figure;
for i=1:n
    subplot(8,2,i)
    U=UsageHours{i,1:end-1};
    bar(U);
    ylabel('Time (Hours)');
    xticklabels(C);
    title(UsageHours.Properties.RowNames{i})
end
matlab2tikz(strcat(figName,'_Micros1.tex'))

figure;
for i=n+1:height(UsageHours)
    subplot(8,2,i-n)
    U=UsageHours{i,1:end-1};
    bar(U);
    ylabel('Time (Hours)');
    xticklabels(C);
    title(UsageHours.Properties.RowNames{i})
end
matlab2tikz(strcat(figName,'_Micros2.tex'))


end


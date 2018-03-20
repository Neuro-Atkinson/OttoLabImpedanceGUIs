
wrk_vars=who;

%Natural Order Sort
filenum=length(wrk_vars);
order=zeros(filenum,2);
order(1:filenum,1)=1:1:filenum;
for i = 1:filenum
    %convert char cell to string
    str1_split=strsplit(wrk_vars{i,1},'Day');
    str2_split=strsplit(str1_split{1,2},'_');
    number=str2double(str2_split{1,1});
    order(i,2)=number;
end

corrected_order=sortrows(order,2);

%Get animal name
str1_split=strsplit(wrk_vars{1,1},'_');

for i = 1:filenum
   %Store data for ascending days.
   eval_command=sprintf('%s{1,i}=%s',str1_split{1,2},wrk_vars{corrected_order(i,1),1});
   eval(eval_command)
   %Store day value
   eval_command=sprintf('%s{2,i}=corrected_order(i,2);',str1_split{1,2});
   eval(eval_command);
   %Store filename for data
   eval_command=sprintf('%s{3,i}=wrk_vars{corrected_order(i,1),1};',str1_split{1,2});
   eval(eval_command);
end

merged_filename=sprintf('%s_FRA_Days%dto%d_Channels1to21',str1_split{1,2},corrected_order(1,2),corrected_order(end,2));
eval_command=sprintf('%s=%s',merged_filename,str1_split{1,2});
eval(eval_command);
save(merged_filename,merged_filename);
clear

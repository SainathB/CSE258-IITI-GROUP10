function [T,TMax,TMin,l_intf,TS]=make_experimental_file(T,TM,Tm,FE,TS,filename,path);
   % FE stands for first extrema

TMax=get_selected_data(TM);
TMin=get_selected_data(Tm);
FE=get_selected_data(FE);
l_intf=FE(1);
l_intf=l_intf-0.01;

save=pwd;
cd (path)
warning off all
xlswrite(filename,T,'T');
xlswrite(filename,TMax,'TMax');
xlswrite(filename,TMin,'TMin');
xlswrite(filename,l_intf,'l_intf');
xlswrite(filename,TS,'TS');

cd (save)


function [B]=get_selected_data(A)
a={A.Position};
% n=length(A.Position)
n=numel(a);
for i=1:n
    
    B(i,1)=a{i}(1);
    B(i,2)=a{i}(2);
end
    


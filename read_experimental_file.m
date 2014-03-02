function [T,TMax,TMin,l_intf,TS]=read_experimental_file(filename,path);
save=pwd;
cd (path)

T=xlsread(filename,'T');
TMax=xlsread(filename,'TMax');
TMin=xlsread(filename,'TMin');
%l_intf=xlsread(filename,'l_intf');
TS=xlsread(filename,'TS');
cd (save)
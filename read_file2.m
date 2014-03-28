function [lambda,T,T_Max,T_Min]=read_file2(filename,path )
%function to read data from the xls file and generate the envelope curves
name=[path,'\',filename];
format longg;
lambda=xlsread(name,'A:A');
T=xlsread(name,'B:B');
T=T/100;
plot(lambda,T,'d');
disp('select the value of min and max wavelength from the plot, both the values should be peak values');
[x_range y_range]=ginput(2);
m=0;
valid_lambda=[];
valid_T=[];
for h=1:size(lambda)
    if lambda(h)>=x_range(1)&&lambda(h)<=x_range(2)
        m=m+1;
        valid_lambda(m)=lambda(h);
        valid_T(m)=T(h);
    end
end
pp=interp1(lambda,T,'linear','pp');
sp_values=ppval(pp,linspace(189,1099,100000));
valid_T1=smooth(valid_lambda,valid_T,7,'sgolay',5);
[up down]=envelope(valid_lambda,valid_T1,'spline');
plot(linspace(189,1099,100000),sp_values,'b',valid_lambda,up,'g',valid_lambda,down,'r',valid_lambda,valid_T1,'c');
end


function [ lambda,T,T_Max,T_Min ] = read_file(filename,path )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
name=[path,'\',filename];
format longg;
lambda=xlsread(name,'A:A');
T=xlsread(name,'B:B');
T=T/100;
%disp(lambda);
%disp(T);
pp=interp1(lambda,T,'spline','pp');
sp_values=ppval(pp,linspace(189,1099,100000));
p_der=fnder(pp,1);
p_der2=fnder(p_der,1);
T_prime=ppval(p_der,lambda);
T_prime2=ppval(p_der2,lambda);
inf_pts=rootspline(p_der2);
T_at_inf=ppval(pp,inf_pts);
der_roots=rootspline(p_der);
val_at_der=ppval(pp,der_roots);
tan_pts=[];
for i=1:(size(inf_pts)-1)
    tan_pts(i)=(inf_pts(i)+inf_pts(i+1))/2;
end
val_at_tp=ppval(pp,tan_pts);
k=0;
l=0;
T1=[];
T2=[];
for j=1:size(der_roots)
    if rem(j,2)==0
        k=k+1;
        T1(k)=der_roots(j);
    else
        l=l+1;
        T2(l)=der_roots(j);
    end
end
val_at_T1=ppval(pp,T1);
val_at_T2=ppval(pp,T2);
pp_max=interp1(T1,val_at_T1,'cubic','pp');
pp_min=interp1(T2,val_at_T2,'cubic','pp');
max_values=ppval(pp_max,lambda);
min_values=ppval(pp_min,lambda);
for p=1:20
    
for g=1:size(T1)
    
end
end
plot(linspace(189,1099,100000),sp_values,inf_pts,T_at_inf,'x',tan_pts,val_at_tp,'o',der_roots,val_at_der,'*',...
    lambda,max_values,'k-',lambda,min_values,'m-');
end



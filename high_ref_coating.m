function [widths R_final R_Max]= high_ref_coating(lambda,R_req,n1,alpha1,TS,n2,alpha2)
%the function takes in lambda for which high reflectance coating is needed
%R_req is the minimum reflectance that is required
%n1 and alpha1 are the ref index and absorption coeff for material 1
%n2 and alpha2 are the ref index and absorption coeff for material 2
%TS is the substrate transmission required to calculate the substrate ref
%index s
%the function return widths which is a vector containing thickness of the
%layers
%R_final is the matrix containing final reflectivity corr to each lambda
%R_Max is the maximum reflectivity which can be achieved for the given
%lambda
n1=sortrows(n1,1);
n2=sortrows(n2,1);
alpha1=sortrows(alpha1,1);
alpha2=sortrows(alpha2,1);
TS=[TS(:,1) TS(:,2)/100];
TS=sortrows(TS,1);
N1=interp1(n1(:,1),n1(:,2),lambda,'parabola');
A1=interp1(alpha1(:,1),alpha1(:,2),lambda,'linear','extrap');
N2=interp1(n2(:,1),n2(:,2),lambda,'parabola');
A2=interp1(alpha2(:,1),alpha2(:,2),lambda,'linear','extrap');
Ts=interp1(TS(:,1),TS(:,2),lambda,'linear','extrap');
s=(1/Ts)+((1/Ts^2)-1)^0.5;
widths(1)=lambda/(4*N1);
n_store(1)=N1;
alpha_store(1)=A1;
c=1;
Rf(c)=calc_reflectivity(widths,n_store,alpha_store,s);
i=1;
while Rf(c)<R_req
    i=i+1;
    widths(i)=lambda/(4*N2);
    n_store(i)=N2;
    alpha_store(i)=A2;
    i=i+1;
    widths(i)=lambda/(4*N1);
    n_store(i)=N1;
    alpha_store(i)=A1;
    c=c+1;
    Rf(c)=calc_reflectivity(widths,n_store,alpha_store,s);
    if Rf(c)<=Rf(c-1)
        widths(i)=[];
        widths(i-1)=[];
        n_store(i)=[];
        n_store(i-1)=[];
        alpha_store(i)=[];
        alpha_store(i-1)=[];
        Rf(c)=[];
        break;
    end
end
R_Max=Rf(end);
if n1(end,1)<n2(end,1)
    n_max=n1(end,1);
else
    n_max=n2(end,1);
end
if n1(1,1)<n2(1,1)
    n_min=n2(1,1);
else
    n_min=n1(1,1);
end
R_final=[];
X=linspace(n_min,n_max,300);
Y=[];
layers=numel(widths);
for i=1:numel(X)
    N1_temp=interp1(n1(:,1),n1(:,2),X(i),'parabola');
A1_temp=interp1(alpha1(:,1),alpha1(:,2),X(i),'linear','extrap');
N2_temp=interp1(n2(:,1),n2(:,2),X(i),'parabola');
A2_temp=interp1(alpha2(:,1),alpha2(:,2),X(i),'linear','extrap');
Ts_temp=interp1(TS(:,1),TS(:,2),X(i),'linear','extrap');
s_temp=(1/Ts_temp)+((1/Ts_temp^2)-1)^0.5;
n_store_temp=[];
alpha_store_temp=[];
for g=1:layers
    if rem(g,2)==0
        n_store_temp(g)=N2_temp;
        alpha_store_temp(g)=A2_temp;
    else
        n_store_temp(g)=N1_temp;
        alpha_store_temp(g)=A1_temp;
    end
end
    Y(i)=calc_reflectivity(widths,n_store_temp,alpha_store_temp,s_temp);
end
X=X';
Y=Y';
R_final=[X Y];
end


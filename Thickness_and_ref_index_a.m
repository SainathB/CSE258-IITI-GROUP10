function[d,B]=Thickness_and_ref_index_a(TS, TMax,TMin,l_intf,l_th)
%Input=> TS is the transmission spectrum for Bare Substrate
%        TMax is the matrix giving the data points of maxima
%        TMin is the matrix giving the data points of minima
%In all cases, wavelength is to be given in nm unit ant transmittance in
%fraction(not in percentage)
%        l_th is the threshold wavelength above which extrema are to be considered for the
%        calculation of ref. index
%Output=> d is the thickness in nm
%         CR is the coeff of ref index of equation n(lambda)=CR(1)+CR(2)/lambda^2]

if l_intf>l_th
    error('l_intf can not be greater than l_th')
end


Lambda_TMax=TMax(:,1);
i=find(Lambda_TMax>l_intf);
TMax=[TMax(i,1) TMax(i,2)];


Lambda_TMin=TMin(:,1);
j=find(Lambda_TMin>l_intf);
TMin=[TMin(j,1) TMin(j,2)];


if numel(TMax(:,1))<2  |  numel(TMin(:,1))<2
    error('Number of extrema in the weakly absorbing region is insufficient to apply the method.')
end

[d,B]=Thickness_and_ref_index1(TS, TMax,TMin,l_th);

if d~[];

% selection of extrema's in the strongly absorbing interference range
all_extrema=[TMax(:,1);TMin(:,1)];
remaining_extrema=all_extrema(find(all_extrema>l_intf & all_extrema<l_th) );
remaining_extrema=sort(remaining_extrema,'descend');
no_r_e=numel(remaining_extrema);

% ...................................................................

% add the remaining extrema's to B
no_row_B=numel(B(:,1));
m1=B( no_row_B ,3);
for add_pt=1:no_r_e
    l=remaining_extrema(add_pt);
    B(no_row_B+add_pt,1)=l;
m=m1+add_pt*0.5;
    B(no_row_B+add_pt,2)=(m*l)/(2*d);
    B(no_row_B+add_pt,3)=m;
end

end
%.............................................................
function [d,B]=Thickness_and_ref_index1(TS, TMax,TMin,l_th)
array=[TMax(:,1);TMin(:,1)]; % append all the extrema wavelengths 
array=array(find(array>l_th));
array=sort(array,'descend');
array=[0;array];
CR(2)=-1;
i=-1;
while CR(2)<0 & numel(array)>2
i=i+1;
if i==0
    Lambda_excluded=[];
else
    Lambda_excluded(i)=array(1);  % because in first run only a virtual extrema was excluded
end

 array(1)=[];
[d,m1,B]=Thickness_and_order_No(TS,TMax,TMin,array);

 % add the excluded points to B

nmax=numel(Lambda_excluded);
 B=[zeros(nmax,3);B];
for n=nmax:-1:1
   
    l=Lambda_excluded(n);
    B(n,1)=l;
    m=m1-(nmax-n+1)*0.5;
    B(n,2)=(m*l)/(2*d);
    B(n,3)=m;
end

CR=fit_ref_index(B(:,1),B(:,2));
end
if CR(2)<0
    d=[];
    B=[];
    end

function [d,m1,B]=Thickness_and_order_No(TS,TMax,TMin,array)

% plotting lambda/2 vs n/lambda curve for all extrema
kmax=numel(array);
Lby2=(0:1:(kmax-1))/2;
clear A
for k=1:kmax
    l=array(k);
   
    A(k,1)=l;
    
Ts=interp1(TS(:,1),TS(:,2),l,'linear','extrap');
TM=interp1(TMax(:,1),TMax(:,2), l,'parabola');
Tm=interp1(TMin(:,1),TMin(:,2), l,'parabola');

s=(1/Ts)+((1/Ts^2)-1)^0.5;
N=-(2*s*(TM-Tm)/(TM*Tm))+0.5*(s^2+1);
if N<s
    N=s; % exceptional see the next expression for n
end
n=[N+(N^2-s^2)^0.5]^0.5;

A(k,2)=n/l;
A(k,3)=Lby2(k);
end

subplot(2,2,1)
%plot(A(:,2),A(:,3),'.');xlabel('n/lambda at extrema');ylabel('l/2')

% calculation of the order No. of first extrema
calculated_m1=-interp1(A(:,2),A(:,3),0,'linear','extrap');

if ismember(array(1),TMax(:,1))
    estimated_m1=floor(calculated_m1)+0.5;

else
estimated_m1=round(calculated_m1);
end

    I=0;
for m1=[estimated_m1-1,estimated_m1,estimated_m1+1]

I=I+1;    
stored_m1(I)=m1;
         for k=1:kmax    
             slope=(A(k,3)+m1)/(A(k,2-0));
             d(k)=0.5*slope;
         end

d_avg=mean(d);
stored_d_avg(I)=d_avg;
sigma=std(d);
stored_sigma(I)=sigma;
end


I_selected=find(stored_sigma==min(stored_sigma));
d=stored_d_avg(I_selected);
m1=stored_m1(I_selected);% (selecting d and m1 corresponding to lowest dispersion)
x=linspace(0,max(A(:,2)),10);
y=@(x)2*d*x-m1;
z=[x' y(x)'];
hold on
%plot(x,y(x),'r')
interval=-10:0.5:10;
set(gca,'Ytick',interval);

% Refining the value of ref indices with the obtained values of thickness
% and order NO.

clear B
for k=1:kmax
    
    l=array(k);
    B(k,1)=l;
    
    m=m1+((k-1)/2);
n=(m*l)/(2*d);
    B(k,2)=n;
    B(k,3)=m;
end
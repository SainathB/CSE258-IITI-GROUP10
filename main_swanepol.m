function [d, R,K,ALPHA,CR,B,A]=main_swanepol(TS,T, TMax,TMin,l_intf,l_min,l_max,dl,indicator);
% ensure that the input transmittance are in percentage
if max(T(:,2))<1.2 | max (TS(:,2))<1.2 % means the input is in fraction
    error('give transmittance in percentage')
end
% transform transmission percentage to transmission fraction
TS=[TS(:,1) TS(:,2)/100];
T=[T(:,1) T(:,2)/100];
TMax=[TMax(:,1) TMax(:,2)/100];
TMin=[TMin(:,1) TMin(:,2)/100];

% To handle wrong and erotic data
if min(TS(:,1))>min(T(:,1)) | max(TS(:,1))< max(T(:,1))
warning('substrate transmission spectrum is unavailable through out the range of sample transmission spectrum. Substrate transmission spectrum might have been extrapolated');
end 
% to handle -ve value of transmission
TS(find(TS(:,2)<=0),:)=[];
T(find(T(:,2)<=0),:)=[];
TMax(find(TMax(:,2)<=0),:)=[];
TMin(find(TMin(:,2)<=0),:)=[];

%decide all l_th
x=sort([TMax(:,1);TMin(:,1)]);
extrema=x(find(x>l_intf));
l_th_store(1)=l_intf;
for i=1:numel(extrema)-2
lth=mean([extrema(i) extrema(i+1)]);
l_th_store(i+1)=lth;
end

%...........................
index=0;
for j=1:numel(l_th_store)
l_th=l_th_store(j);
if indicator ==1
    
[d,B]=Thickness_and_ref_index(TS, TMax,TMin,l_intf,l_th);
elseif indicator == -1
    
[d,B]=Thickness_and_ref_index_a(TS, TMax,TMin,l_intf,l_th);
end
    d1=d;    % to see all calculated d and B values
B1=B;
if B~[];
    index=index+1;
CR=fit_ref_index(B(:,1),B(:,2));
if indicator == 1
[A]=absorption_coeff(TS,TMax,TMin,d,CR,l_intf);
elseif indicator == -1
       
    [A]=absorption_coeff_a(TS,TMax,TMin,d,CR,l_intf);
       
end
        chi_sq=comparison(T,TS,d,CR,[A(:,1) A(:,2)],l_intf,l_min,l_max,dl);
store_chi_sq(index)=chi_sq;
store{index}={d CR A B chi_sq};

end

end


if index==0
 
   error('Data is not fitable');
   
% give command for stopping further command run
else
index_min=find(store_chi_sq==min(store_chi_sq));
d=store{index_min}{1};
CR=store{index_min}{2};
A=store{index_min}{3};
B=store{index_min}{4};
chi_sq=store{index_min}{5}
end


l=l_min:dl:l_max;
n=@(l)(CR(1)+CR(2)*l.^(-2));
R=[l' n(l)'];
subplot(2,2,2)

plot(B(:,1),B(:,2),'*');hold on;plot(l,n(l),'r'); xlabel('wavelength in nm');ylabel('ref index')

alpha=@(l)interp1(A(:,1),A(:,2),l,'linear','extrap');
k=@(l)interp1(A(:,1),A(:,3),l,'linear','extrap');
%To plot the absorption curve.................

Lambda=l_min:dl:l_max;

p=numel(Lambda);

for p=1:p
 l=Lambda(p);
Alpha(p)=alpha(l);
K(p)=k(l);
end
K(find(K<0))=0;
Alpha(find(Alpha<0))=0;

subplot(2,2,3)

plot(A(:,1),A(:,2),'*');xlabel('Wavelength in nm');ylabel('absorption coeff, alpha in nm^-1');hold on; plot(Lambda,Alpha,'r')

%plot(A(:,1),A(:,3),'*');xlabel('Wavelength in nm');ylabel('attenuation coeff, k');hold on; plot(Lambda,K,'r');
K=[Lambda' K'];
ALPHA=[Lambda' Alpha'];

comparison(T,TS,d,CR,[A(:,1) A(:,2)],l_intf,l_min,l_max,dl);

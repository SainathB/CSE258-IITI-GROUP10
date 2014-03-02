function [A]=absorption_coeff(TS,TMax,TMin,d,CR,l_intf)
%Input=> TS is the transmission spectrum for Bare Substrate
%        TMax is the matrix giving the data points of maxima
%        TMin is the matrix giving the data points of minima
%         d is the thickness calculated from 'Thickness_and_ref_index' program
%         CR is the coeff of ref index of equation 
%         n(lambda)=CR(1)+CR(2)/lambda^2 calculated from 'Thickness_and_ref_index' program

%Output=> CA is the coeff of absorption coeff, alpha of equation 
%         alpha(lambda)=exp(CA(1)+CA(2)/lambda)
%         lambda in nm and alpha in nm^-1. k is unitless.



array=[TMax(:,1);TMin(:,1)];
array=sort(array,'descend');
imax=numel(array);
for i=1:imax
    
    l=array(i);
    A(i,1)=l;
    Ts=interp1(TS(:,1),TS(:,2),l,'linear','extrap');

s=(1/Ts)+((1/Ts^2)-1)^0.5;
n=CR(1)+CR(2)*l.^(-2);
if ismember(l,TMax(:,1))
    TM=TMax(find(TMax(:,1)==l),2);
EM=((8*n^2*s)/TM)+(n^2-1)*(n^2-s^2);

x=[EM-[EM^2-(n^2-1)^3*(n^2-s^4)]^0.5]/[(n-1)^3*(n-s^2)];
elseif ismember(l,TMin(:,1))

    Tm=TMin(find(TMin(:,1)==l),2);

    Em=((8*n^2*s)/Tm)-(n^2-1)*(n^2-s^2);



x=[Em-[Em^2-(n^2-1)^3*(n^2-s^4)]^0.5]./[(n-1)^3*(n-s^2)];
end

alpha=-(1/d)*log(x);  % alpha is the absorption coeff

A(i,2)=alpha;
k=alpha*l/(4*pi);     % k is the attenuation coeff
A(i,3)=k;

end

i_culprit=find(A(:,2)<0); %which corresponds to Ts<TM
i_culprit=sort(i_culprit,'descend');
for j=1:numel(i_culprit)
    I=i_culprit(j);
l_culprit=A(I,1);
if l_culprit<l_intf
 A(I,:)=[];
 else
A(I,2)=0;
A(I,3)=0;
end
end

A=repeat_ellimination(A);

% To eliminate the the repeating data points
function [A]=repeat_ellimination(A)
jmax=numel(A(:,1));
c=0;
for j=1:jmax
        r=find(A(:,1)==A(j,1));
    if length(r)>=1
     R=r(2:numel(r)); %the row to be canceled
   c=[c;R];
    end
end

c(find(c(:)==0))=[];
A(c,:)=[];

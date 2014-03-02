function [Eg,W,B]=indirect_band_gap(A,p1,p2)
%Input=>  CA is the coeff of absorption coeff, alpha of equation 
%         alpha(lambda)=exp(CA(1)+CA(2)/lambda)
%         lambda in nm and alpha in nm^-1.

%        E1 is the energy above which data points are to be considered as
%        the linear section of h_nu vs alpha_h_nu asymptotic curve

%Output=>  Eg is direct band gap energy in ev


 h=6.626*10^-34;
c=3*10^8;
imax=numel(A(:,1));

for i=1:imax
    l=A(i,1);
    alpha=A(i,2);

l=l*10^-9;          % to convert wavelength in meter 
alpha=alpha*10^9; % to convert alpha in m^-1 from nm^-1

h_nu=(h*c/l)*0.625*10^19; % to convert energy in ev from Joule
B(i,1)=h_nu;

alpha_h_nu=(alpha*h_nu)^(1/2);     % in the unit of ev^(1/2)*m^-(1/2)
B(i,2)=alpha_h_nu;
end

plot(B(:,1),B(:,2))
xlabel('h\nu in ev')
ylabel('(\alpha h\nu)^(1/2) in ev^2*m^-(1/2)')

B=repeat_ellimination(B);
j=find(B(:,1)>=p1 & B(:,1)<=p2);
A=[B(j,1) B(j,2)];

X=A(:,1);
Y=A(:,2);
[C,y]=fit_straightline(X,Y);
hold on
Eg=-C(1)/C(2);
clear x
%x=Eg:0.01:max(B(:,1));
x=Eg:0.01:p2;
y=@(x)interp1(y(:,1),y(:,2),x,'linear','extrap');

plot(x,y(x),'r')
W=[x' y(x)'];




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
    
function [C,y]=fit_straightline(X,Y);
ndp=length(X);
for k=1:ndp     %ndp is the no of data points
D(k,1)=1;
D(k,2)=X(k);
end

C=(inv(D'*D))*D'*Y;

x=X;
y=@(x)(C(1)+C(2)*x);
y=[x y(x)];
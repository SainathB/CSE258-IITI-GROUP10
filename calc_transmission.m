function Tr=calc_transmission(n,alpha,k,TS,d)
%function calculates transmission for given values of ref index=n,
%absorption coeff=alpha,attenuation coeff=k,substrate
%transmission=TS,thickness of thin film=d
s=[];      %array to store value of subs ref index
[e f]=size(n);
Tr=[];    %array to store calculated transmission values 
for i=1:e
    Ts=interp1(TS(:,1),TS(:,2),n(i,1),'linear','extrap');
    s(e)=(1/Ts)+((1/Ts^2)-1)^0.5;
    x=exp(-1*alpha(i,2)*d);
    phi=4*pi*n(i,2)*d/n(i,1);
    clear A;
    A=16*s(i)*(n(i,2)^2+k(i,2)^2);
    clear B;
    B=((n(i,2)+1)^2+k(i,2)^2)*((n(i,2)+1)*(n(i,2)+s(i)^2)+k(i,2)^2);
    clear C;
    C=((n(i,2)^2-1+k(i,2)^2)*(n(i,2)^2-s(i)^2+k(i,2)^2)-(2*k(i,2)^2)*(s(i)^2+1)*2*cos(phi)-k*(2*(n(i,2)^2-s(i)^2+k(i,2)^2)+(s(i)^2+1)*(n(i,2)^2-1)+k(i,2)^2)*2*sin(phi);
    clear D;
    D=((n(i,2)-1)^2+k(i,2)^2)*((n(i,2)-1)*(n(i,2)-(s(i)^2))+k(i,2)^2);
    Tr(i,1)=n(i,1);
    Tr(i,2)=(A*x)/(B-C*x+D*(x^2));
end
end


function [chi_sq]=comparison(T,TS,d,CR,A,l_intf,l_min,l_max,dl)
%Input=> T is the transmission spectrum for the thin film
 %       TS is the transmission spectrum for Bare Substrate
%         d is the thickness calculated from 'Thickness_and_ref_index' program
%         CR is the coeff of ref index of equation 
%         n(lambda)=CR(1)+CR(2)/lambda^2 calculated from 'Thickness_and_ref_index' program
%         B is a 3 column matrix giving wavelength, absorption coeff, 
%         attenuation coeff in it's 1st, 2nd and 3rd column respectively


%........................


T_f=@(l) interp1(T(:,1),T(:,2),l,'linear','extrap');
lmin=l_intf;
lmax=max(A(:,1));

array1=linspace(lmin,lmax,100);
for i=1:100
    l=array1(i);
  Ts=interp1(TS(:,1),TS(:,2),l,'linear','extrap');
  s=(1/Ts)+((1/Ts^2)-1)^0.5;
 n=CR(1)+CR(2)*l.^(-2);
 
    alpha=interp1(A(:,1),A(:,2),l,'linear','extrap');
  
    A1=16*n^2*s;
    B=(n+1)^3*(n+s^2);
    C=2*(n^2-1)*(n^2-s^2);
    D=(n-1)^3*(n-s^2);
    phi=(4*pi*n*d)/l;
    x=exp(-alpha*d);
    
    T1=(A1*x)/(B-C*x*cos(phi)+D*x^2);

    chi_sq_pp=(T1-T_f(l))^2;
chi_sq_p(i)=chi_sq_pp;
end
chi_sq_p;
chi_sq=sum(chi_sq_p);
%......................................................................

array=l_min:dl:l_max;

for i=1:numel(array)
    l=array(i);
    F(i,1)=l;
  Ts=interp1(TS(:,1),TS(:,2),l,'linear','extrap');
  s=(1/Ts)+((1/Ts^2)-1)^0.5;
 n=CR(1)+CR(2)*l.^(-2);
 
    alpha=interp1(A(:,1),A(:,2),l,'linear','extrap');
  
    A1=16*n^2*s;
    B=(n+1)^3*(n+s^2);
    C=2*(n^2-1)*(n^2-s^2);
    D=(n-1)^3*(n-s^2);
    phi=(4*pi*n*d)/l;
    x=exp(-alpha*d);
    
    T1=(A1*x)/(B-C*x*cos(phi)+D*x^2);
    F(i,2)=T1;
   F(i,3)=alpha;
% F(i,4)=s;
    
end



subplot(2,2,4)
plot(T(:,1),T(:,2).*100,'b') ; hold on; plot(F(:,1),F(:,2).*100,'r'); plot(TS(:,1),TS(:,2).*100,'k') ;xlabel('Wavelength(nm)');ylabel('Transmittance');  % plotting the experimental spectrum and the spectrum obtained from model
hold off


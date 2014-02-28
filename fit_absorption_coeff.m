function [CA]=fit_absorption_coeff(X,Y)


Y=log(Y);
ndp=length(X);
for k=1:ndp     %ndp is the no of data points
D(k,1)=1;
D(k,2)=(X(k)).^(-1);
end

CA=(inv(D'*D))*D'*Y;


function [CR,R]=fit_ref_index(X,Y);
ndp=length(X);
for k=1:ndp     %ndp is the no of data points
D(k,1)=1;
D(k,2)=(X(k)).^(-2);
end

CR=(inv(D'*D))*D'*Y;

l=X;
n=@(l)(CR(1)+CR(2)*l.^(-2));
R=[l n(l)];
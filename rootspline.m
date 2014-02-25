function zo = rootspline(pp)

% rootspline find roots of a spline
%
% xo = rootspline(pp) returns the unique roots of the piecewise polynomial
% contained in pp. Typically, pp was constructed using the functions
% interp1, pchip, spline, or the spline utility mkpp.
%
% rootspline uses the roots function, so the input must not contain NaN or
% Inf.
%
% EXAMPLES:
%
% % choose source data:
% % ----------------- 1 -----------------
% x = -2:2;
% y = [ 4 1 0 -1 -4 ];
% % ----------------- 2 -----------------
% x = [-2,-1,1,2];
% y = [ 4 1 1 4];
% % ----------------- 3 -----------------
% x = unique(rand(21,1)*20-10);
% y = rand(size(x))-0.5;
% % -------------------------------------
% 
% % calculate spline
% pp = spline(x,y);
% xo = rootspline(pp);
% % plot
% xx = linspace(min(x),max(x),50*numel(x));
% figure
% plot(xx,ppval(pp,xx))
% hold on, grid on
% plot(x,y,'k*')
% plot(xo,0*xo,'ro')
% legend({'spline','source data','roots'},'location','best')
% xlabel('x'), ylabel('y'), title('rootspline example') 
%
% Compare examples 1), 2) and note the roundoff susceptibility!
% 
%
% See also
% roots, spline, interp1, pchip, mkpp

x = pp.breaks(:);
y = [pp.coefs(:,end);ppval(pp,x(end))];


% preallocate
zo = zeros(pp.pieces,1);
% initialize roots counter
cnt = 0;
% step through all pieces of the spline and find roots
for idx = 1:pp.pieces
    r = rootsbnd(pp.coefs(idx,:),pp.breaks([idx,idx+1]));
    zo(cnt+1:cnt+numel(r)) = r;
    cnt = cnt + numel(r);
end
zo(cnt+1:end) = [];

% get unique roots (zo is already sorted)
if numel(zo)>1
    zo = zo([true;diff(zo)~=0]);
end

end

function r = rootsbnd(p,bnd)

% rootsbnd find roots of a polynomial piece inside an interval
%
% r = rootsbnd(p,bnd) returns the roots of the polynomial represented by
% the coefficient vector p (e.g. p = pp.coefs, pp produced by spline)
% inside the interval bnd = [x1,x2].

r = roots(p);
% sort out non-real and outlying roots
idc = imag(r)==0;
idc = idc & (r>=0 & r<=diff(bnd));
r = r(idc);
% sort multiple roots
if numel(r)>1
    r = sort(r);
end
% shift to interval
r = r + bnd(1);

end
function [x,nw,np,nt] = osccalc(x,y,nocomp,iter,tol)
%OSCCALC Calculates orthogonal signal correction (OSC).
% Inputs are the centered and scaled matrix of predictor variables (x) and
%  predicted variable(s) (y), scaled as desired, and the number of OSC
%  components to calculate (nocomp). Optional inputs are the maximum number
%  of iterations used in attempting to maximize the variance captured by
%  orthogonal component (iter) {default = 0}, and the tolerance on percent
%  of x variance to consider in formation of the final w vector (tol)
%  {default = 99.9}.
%
% Outputs are the OSC corrected x matrix (nx) and the weights (nw),
%  loads (np) and scores(nt) that were used in making the correction. Once
%  the calibration is done, new (scaled) x data can be corrected through
%  the oscapp function or by 
%    newx = x - x*nw*inv(np'*nw)*np';
%
%I/O: [nx,nw,np,nt] = osccalc(x,y,nocomp,iter,tol);
%I/O: osccalc demo
%
%See also: CALTRANSFER, CROSSVAL, GLSW, OSCAPP, STDDEMO

%Copyright Eigenvector Research, Inc. 1998-2016
%Licensee shall not re-compile, translate or convert "M-files" contained
% in PLS_Toolbox for use with any software other than MATLAB®, without
% written permission from Eigenvector Research, Inc.
%Barry M. Wise, January 23, 1998
%Modified BMW March 1999
%JMS 4/9/02 -removed rank test, created sub function SOMESIMPLS
%  to handle PLS model (gets only enough LVs to give "tol".)
%JMS 4/03 -modifed help

if nargin == 0; x = 'io'; end
varargin{1} = x;
if ischar(varargin{1});
  options = [];
  if nargout==0; clear x; evriio(mfilename,varargin{1},options); else; x = evriio(mfilename,varargin{1},options); end
  return; 
end

[m,n] = size(x);

if size(y,1)~=m
  error('y must have the same number of rows as x')
end

nw = zeros(n,nocomp);
np = zeros(n,nocomp);
nt = zeros(m,nocomp);
if nargin < 4 | isempty(iter)
  iter = 0;
end
if nargin < 5 | isempty(tol)
  tol = 99.9;
end

xorig = x;
x = zscore(x);

for i = 1:nocomp
  % Calculate the first score vector
  [u,s,v] = svds(x,1);
  p = v(:,1);
  p = p*sign(sum(p));
  told = u(:,1)*s(1);
  dif = 1;
  k = 0;
  while dif > 1e-12
    k = k+1;
    % Calculate scores from loads
    t = x*p/(p'*p);
    % Othogonalize t to y
    tnew = t - y*pinv(y'*y)*y'*t;
    % Compute a new loading
    pnew = x'*tnew/(tnew'*tnew);
    % Check for convergence
    dif = norm(tnew-told)/norm(tnew);
    % Assign pnew to p
    told = tnew;
    p = pnew; 
    if k > iter
      dif = 0;
    end
  end
  % Build PLS model relating x to t
  % Include components as specified by tol on x variance
  w = somesimpls(x,tnew,tol);        %jms 4/02
  w = w/norm(w);
  % Calculate new scores vector
  t = x*w;
  % Othogonalize t to y
  t = t - y*pinv(y'*y)*y'*t;
  % Compute new p
  p = x'*t/(t'*t);
  % Remove orthogonal signal from x
  x = x - t*p';
  np(:,i) = p;
  nw(:,i) = w;
  nt(:,i) = t;
end

x = xorig - xorig*nw*inv(np'*nw)*np';

%---------------------------------------------------
function [reg,i] = somesimpls(x,y,tol)
%return SIMPLS weights which correspond to a total variance of "tol"
%I/O: [weights,i] = sim(x,y,tol)

s      = x'*y;
totvar = sum(sum(x.^2));
total  = 0;
i      = 0;

while total < tol
  
  i  = i+1;

  rr = s;           %weights from covar.
  tt = x*rr;
  normtt = norm(tt);
  tt = tt/normtt;
  rr = rr/normtt;
  pp = (tt'*x)';
  
  qq = y'*tt;
  uu = y*qq;
  vv = pp;
  if i > 1
    vv = vv - basis*(basis'*pp);
    uu = uu - loads{1,1}*(loads{1,1}'*uu);
  end
  vv = vv/norm(vv);
  s  = s - vv*(vv'*s);
   
  total = total + (pp'*pp)/totvar*100;
  
  wts(:,i)        = rr;           % x-block weights
  loads{1,1}(:,i) = tt;           % x-block scores
  loads{2,2}(:,i) = qq;           % y-block loadings
  basis(:,i)      = vv;           % basis of x-loadings
  
end

if i > 1
  reg = sum((wts*diag(loads{2,2}))');
else
  reg = (wts*loads{2,2})';
end
reg = reg';

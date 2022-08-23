function newx = oscapp(x,nw,np,nofact);
%OSCAPP Applies OSC model to new data.
%  Inputs are the new data matrix (x), weights from the
%  OSC model (nw), and loadings from the OSC (np).
%  Optional input (nofact) can be used to restrict the
%  correction to a smaller of factors  han originally calculated.
%  The output is is the corrected data matrix (newx).
%
%  Note: input data (x) must be centered and scaled like the
%  original data!
%
%I/O: newx = oscapp(x,nw,np,nofact);
%I/O: oscapp demo
%
%See also: CALTRANSFER, CROSSVAL, OSCCALC

%Copyright Eigenvector Research, Inc. 2000-2016
%Licensee shall not re-compile, translate or convert "M-files" contained
% in PLS_Toolbox for use with any software other than MATLAB®, without
% written permission from Eigenvector Research, Inc.
%BMW 11/2000

if nargin == 0; x = 'io'; end
varargin{1} = x;
if ischar(varargin{1});
  options = [];
  if nargout==0; evriio(mfilename,varargin{1},options); else; newx = evriio(mfilename,varargin{1},options); end
  return; 
end

[mx,nx] = size(x);
[mnw,nnw] = size(nw);
[mnp,nnp] = size(np);
if nargin < 4
  nofact = nnw;
end
if nx ~= mnw | nx ~= mnp
  error('Size of weights (nw) and/or loadings (np) not consistant with data (x)')
end
if nnw ~= nnp
  error('Loadings (np) and weights (nw) not for the same number of factors')
end
if nofact > nnw | nofact > nnp 
  error('Number of factors requested > number originally calculated')
end 
if nofact < nnw
  nw = nw(:,1:nofact);
  np = np(:,1:nofact);
end
newx = x - x*nw*inv(np'*nw)*np';

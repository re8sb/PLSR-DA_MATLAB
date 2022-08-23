function [X_filt,X_ortho] =  OPLS(X,Y,tol)
%% Apply orthogonal projection onto latent structure before PLSR
% Adapted from Paul Anderson's lab
% https://github.com/Anderson-Lab/OPLS/blob/master/matlab/opls.m
% And the 2001 Trygg & Wold paper, Orthogonal projections to latent
% structures (O-PLS)

w_ortho = [];
t_ortho = [];
p_ortho = [];

X_filt = X; %for the first iteration, we start with the raw input X data

%Set an arbitrary value of y_variance to begin the loop
ratio = 100;

for i = 1:length(X)
while ratio > tol
    %Find orthogonalized PLS components, and filter X data accordingly
    %depending on number of orthogonal components
    %calculate weights
    w = (Y(:,1)'*X_filt/(Y(:,1)'*Y(:,1)))'; %1
    %normalize weights
    w = w/norm(w); %2
    %calculate new scores vector, t
    t = X_filt*w/(w'*w); %3
    c = (t'*Y(:,1)/(t'*t))'; %4
    u = Y(:,1)*c/(c'*c); %5
    p = (t'*X_filt/(t'*t))'; %6

    w_ortho(:,i) = p - (w'*p/(w'*w))*w; %7
    w_ortho(:,i) = w_ortho(:,i)/norm(w_ortho(:,i)); %8
    t_ortho(:,i) = X_filt*w_ortho(:,i)/(w_ortho(:,i)'*w_ortho(:,i)); %9
    p_ortho(:,i) = (t_ortho(:,i)'*X_filt/(t_ortho(:,i)'*t_ortho(:,i)))'; %10
    E_opls = X_filt - t_ortho(:,i)*p_ortho(:,i)'; %11, E_opls are filtered data
    
    X_filt = E_opls; %now, X has been filtered
    
    %this determines how many opls components to use (Trygg & Wold)
    ratio = norm(p-[(w'*p)/(w'*w)]*w)/norm(p);
    
    if tol > ratio
        return
    end
end
end
return
%This loop will iterate over orthogonal components, until an X_ortho
%matrix is obtained that produces a model with y_variance < tol (input)
% for i=1:ncomp
%    
%     %Find orthogonalized PLS components, and filter X data accordingly
%     %depending on number of orthogonal components
%     %calculate weights
%     w = (Y(:,1)'*X_filt/(Y(:,1)'*Y(:,1)))'; %1
%     %normalize weights
%     w = w/norm(w); %2
%     %calculate new scores vector, t
%     t = X_filt*w/(w'*w); %3
%     c = (t'*Y(:,1)/(t'*t))'; %4
%     u = Y(:,1)*c/(c'*c); %5
%     p = (t'*X_filt/(t'*t))'; %6
% 
%     %**12, save parameters to matrices T_ortho, P_ortho, and W_ortho**
%     w_ortho(:,i) = p - (w'*p/(w'*w))*w; %7
%     w_ortho(:,i) = w_ortho(:,i)/norm(w_ortho(:,i)); %8
%     t_ortho(:,i) = X_filt*w_ortho(:,i)/(w_ortho(:,i)'*w_ortho(:,i)); %9
%     p_ortho(:,i) = (t_ortho(:,i)'*X_filt/(t_ortho(:,i)'*t_ortho(:,i)))'; %10
%     E_opls = X_filt - t_ortho(:,i)*p_ortho(:,i)'; %11, E_opls are filtered data
%     
%     X_filt = E_opls; %now, X has been filtered
% 
% end
%     
% X_ortho = t_ortho*p_ortho'; %13
%to analyze systematic orthogonal variation, run a PCA on X_ortho:
%t_pca_ortho = PCA loadings; p_pca_ortho = PCA scores; E_pca_ortho = PCA
%variances
% [t_pca_ortho, p_pca_ortho, E_pca_ortho] = pca(X_ortho); %14

%this step is optional: you could remove all orthogonal variation from X,
%or alternatively, you could remove only principal orthogonal components
%estimated by PCA. This corresponds to adding E_pca_ortho back into E_opls,
%which is X
% X_ortho = t_pca_ortho*p_pca_ortho' + E_pca_ortho;

%then there are a few steps that deal with orthogonalization of future
%model predictions


end


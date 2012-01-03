function [fv,grad] = regCreg(beta,theta,X,Lambda)
% objective function for circular regression. Note that Lambda is a
% quadratic penalty which can either be a scalar or a (smoothing) matrix

u = X * beta;
lx = 2*atan(u); % link function
dlx = 2./(1+u.^2); % derivative of link function
S = mean(sin(theta - lx));
C = mean(cos(theta - lx));

mu = angle(1i*S+C);
DG = X' * (dlx .* sin(theta - mu - lx));

fv = -sum(cos(theta-mu-lx)) + beta' * Lambda * beta;
grad = 2 * Lambda * beta - DG;
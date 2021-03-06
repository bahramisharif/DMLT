classdef enet < dml.method
%ENET native implementation of elastic net algorithm.
%
%   DESCRIPTION
%   Elastic net linear and logistic regression
%
%   REFERENCE
%   Regularization paths for generalized linear models via coordinate descent 
%   by Friedman et al.
%
%   EXAMPLE
%   X = rand(10,20); Y = [1 1 1 1 1 2 2 2 2 2]';
%   m = dml.enet
%   m = m.train(X,Y);
%   Z = m.test(X);
%
%   DEVELOPER
%   Marcel van Gerven (m.vangerven@donders.ru.nl)

  properties
    
   weights % regression weights (offset last)
   
   family = 'gaussian' % gaussian, binomial, or multinomial
   
   L1 % lasso penalty
   L2 = 1e-6 % nfeatures x nfeatures ridge penalty    
      
   maxiter = 1e4; % maximum number of iterations for native elastic net
   tolerance = 1e-4; % tolerance in the error for native elastic net
      
   conv % plot of the convergence of the parameters sum(abs(beta-betaold));
   
  end
  
  methods
    
    function obj = enet(varargin)

      obj = obj@dml.method(varargin{:});

    end
    
    function obj = train(obj,X,Y)
        
      % handle multiple datasets
      if iscell(X)
        obj = dml.ndata('method',obj);
        obj = obj.train(X,Y);
        return;
      end
        
      if isempty(obj.L1), error('unspecified L1 parameter'); end
      
      % transform scalar L2 to matrix
      if isscalar(obj.L2), obj.L2 = obj.L2*eye(size(X,2)); end
      
      % options for elastic net
      opt = [];
      opt.offset = 1;
      opt.maxiter = obj.maxiter;
      opt.tol = obj.tolerance;
      
      switch obj.family
        
        case 'gaussian'
          
          if obj.L1 == 0 % unregularized or ridge regression
            
            l2 = obj.L2; l2(end+1,end+1) = 0;
            X = [X ones(size(X,1),1)];
            R = chol(X'*X + l2);
            obj.weights = R\(R'\(X'*Y));
            
          else % elastic net linear regression
            
            if obj.restart || isempty(obj.weights)
              [beta,beta0,c] = elasticlin(X',Y',obj.L1,obj.L2,opt);
              obj.conv = c;
            else
              % run model starting at the previous weights
              [beta,beta0,c] = elasticlin(X',Y',obj.L1,obj.L2,opt,obj.weights(1:(end-1))',obj.weights(end));
              obj.conv = c;
            end
            obj.weights = [beta; beta0]';
            
          end
          
        case 'binomial'
          
          if obj.restart || isempty(obj.weights)
            [beta,beta0,c] = elasticlog(X',Y' - min(Y),obj.L1,obj.L2,opt);
            obj.conv = c;
          else
            % run model starting at the previous weights
            [beta,beta0,c] = elasticlog(X',Y' - min(Y),obj.L1,obj.L2,opt,obj.weights(1:(end-1))',obj.weights(end));
            obj.conv = c;
          end
          obj.weights = [beta; beta0]';
          
          
        otherwise
          
          error('unrecognized type');
          
      end
      
    end
    
    function Y = test(obj,X)

      switch obj.family
        
        case 'gaussian'
          
            Y = [X ones(size(X,1),1)] * obj.weights';
          
        case 'binomial'
          
          Y = (1./(1+ exp([X ones(size(X,1),1)] * obj.weights')));
          Y = [Y 1-Y];
          
        otherwise
          error('unrecognized kind');
      
      end
      
    end

    function m = model(obj)
    % returns 
    %
    % m.weights regression coefficients
    
      m.weights = obj.weights(1:(end-1))';
      m.bias = obj.weights(end);
      
    end
  
  end
  
  methods(Static=true)
    
    function p = lambdapath(X,Y,family,nsteps,lmin)
    
      if nargin < 4, nsteps = 50; end
      if nargin < 5, lmin = 1e-4; end
      
      switch family
        case 'gaussian'
          lmax = max(abs(X' * (Y - mean(Y)))) / size(X,1); % subtract offset
        case 'binomial'
          lmax = max(abs(X' * (Y-1.5)));
        otherwise
          error('unrecognized type');
      end
      p = exp(linspace(log(lmax),log(lmin*lmax),nsteps));
      
    end
    
  end
  
end

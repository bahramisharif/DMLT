classdef standardizer < dml.method
% STANDARDIZER class
% 
%   DESCRIPTION
%   Takes zscores such that data has mean 0 and standard deviation 1
%  
%   EXAMPLE
%   X = rand(10,3);
%   m = dml.standardizer;
%   m = m.train(X);
%   Z = m.test(X);

% Copyright (c) 2008, Marcel van Gerven

  properties
    
    mu    % mean
    sigma % standard deviation

  end
  
  methods
    
    function obj = standardizer(varargin)
      
      obj = obj@dml.method(varargin{:});
      
    end
    
    function obj = train(obj,X,Y)
      
      % handle multiple datasets
      if iscell(X)
        obj = dml.ndata('method',obj);
        obj = obj.train(X);
        return;
      end
      
      if obj.verbose, fprintf('standardizing data\n'); end
           
      obj.mu = nanmean(X);
      obj.sigma = nanstd(X);
      obj.sigma(obj.sigma==0) = 1; % bug fix
      
    end
    
    
    function Y = test(obj,X)
      
      Y = bsxfun(@minus,X,obj.mu);
      Y = bsxfun(@rdivide,Y,obj.sigma);
      
    end
    
    function X = invert(obj,Y)
    % INVERT inverts the standardization
    
      X = bsxfun(@times,Y,obj.sigma);
      X = bsxfun(@plus,X,obj.mu);
      
    end
    
    
  end
  
end

classdef csp < dml.method
%CSP Common spatial pattern algorithm
%
%   DESCRIPTION
%   Extracts and applies CSP filters.
%
%   EXAMPLE:
%   X = rand(10,500); Y = [1 1 1 1 1 2 2 2 2 2]';
%   m = dml.csp('indim',[5 100],'tdim',1)
%   m = m.train(X,Y);
%   Z = m.test(X);

% Copyright (c) 2011, Marcel van Gerven, Jason Farquhar

  properties
  
    W % CSP spatial filter
  
    NC =1 % number of  components (for each class)    
    
    tdim % target dimension

    indim % input dimensions
    
    std = dml.standardizer % standardizer
    
  end

  methods
      
    function obj = csp(varargin)
      
      obj = obj@dml.method(varargin{:});
      
    end
      
    function obj = train(obj,X,Y)

      assert(max(Y)==2);

      % standardize data
      obj.std = obj.std.train(X,Y);
      X = obj.std.test(X);
      
      Y1 = find(Y==1);
      Y2 = find(Y==2);

      S1 = zeros(obj.indim(obj.tdim));
      for i=1:numel(Y1)
        x = reshape(squeeze(X(Y1(i),:)),obj.indim);
        if obj.tdim==2, x = x'; end
        S1 = S1 + x * x';
      end
      
      S2 = zeros(obj.indim(obj.tdim));
      for i=1:numel(Y2)
        x = reshape(squeeze(X(Y2(i),:)),obj.indim);
        if obj.tdim==2, x = x'; end
        S2 = S2 + x * x';
      end
      
      [obj.W,D] = eig(S1-S2,S1+S2);
           
    end
  
    function Y = test(obj,X)
      
      p1 = 1:(numel(obj.indim)+1);
      p1(obj.tdim+1) = -p1(obj.tdim+1);
      p2 = [(obj.tdim+1) -(obj.tdim+1)];
      c = size(obj.W,2);
      Y = tprod(reshape(X,[size(X,1) obj.indim]),p1,obj.W(:,[1:obj.NC (c-obj.NC+1):c])',p2);
      Y = Y(:,:);
      
    end
    
  end
  
end

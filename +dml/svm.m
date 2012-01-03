classdef svm < dml.method
% SVM support vector machine.
%
% DESCRIPTION
% Linear support vector machine classifier
%
%   EXAMPLE
%   X = rand(10,20); Y = [1 1 1 1 1 2 2 2 2 2]';
%   m = dml.svm
%   m = m.train(X,Y);
%   Z = m.test(X);

% Copyright (c) 2011, Marcel van Gerven, Jason Farquhar

  properties
    
    X % training data
    
    primal % weights in primal form

    dual % weights in dual form
    
    C % regularization parameter
    
    Ktrain % precomputed kernel for training data
    Ktest  % precomputed kernel for test data
    
  end
  
  methods
    
    function obj = svm(varargin)

      obj = obj@dml.method(varargin{:});

    end
    
    function obj = train(obj,X,Y)
   
      % handle multiple datasets
      if iscell(X)
        obj = dml.ndata('method',obj);
        obj = obj.train(X,Y);
        return;
      end
      
      if obj.restart || isempty(obj.dual)
        
        obj.Ktrain = compKernel(X,X,'linear');
        
        if isempty(obj.C)
          obj.C = .1*(mean(diag(obj.Ktrain))-mean(obj.Ktrain(:)));
        end
        
        obj.X = X;
        
        obj.Ktest = [];
        
        obj.dual = l2svm_cg(obj.Ktrain,2*(Y-1)-1,obj.C,'verb',-1);
        
      else
        
        % facilitate warm restarts
        obj.dual = l2svm_cg(obj.Ktrain,2*(Y-1)-1,obj.C,'verb',-1); %,'alphab',obj.dual);
        
      end
      
      obj.primal = 0;
      for j=1:size(X,1), obj.primal = obj.primal + obj.dual(j)*X(j,:); end
      
    end
    
    function Y = test(obj,X)
      
      if isempty(obj.Ktest)
        obj.Ktest = compKernel(X,obj.X,'linear');
      end
      
      probs = obj.Ktest * obj.dual(1:end-1) + obj.dual(end);
      
      % post is just the sign and does not have a probabilistic interpretation
      Y = zeros(numel(probs),2);
      Y(:,1) = (probs < 0);
      Y(:,2) = (probs > 0);
      
    end

    function m = model(obj)
    % returns
    %
    % m.primal primal form SVM parameters
    
      m.primal = obj.primal;
      
    end
  
  end
 
  
end

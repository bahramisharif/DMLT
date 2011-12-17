classdef permutation
  % PERMUTATION permutation testing class
  %
  %   DESCRIPTION
  %   Performs a permutation test on a dataset given a particular
  %   crossvalidator object, a test statistic and a multivariate analysis.
  
  % Copyright (c) 2011, Marcel van Gerven
  
  properties
    
    cv % crossvalidator object
    
    nperm = 100 % number of permutations
    
    outcome % outcome of the test statistic
    
    verbose = false; % whether or not to generate diagnostic output
    
  end
  
  methods
    
    function obj = permutation(varargin)
      
      % parse options
      for i=1:2:length(varargin)
        if ismember(varargin{i},fieldnames(obj))
          obj.(varargin{i}) = varargin{i+1};
        else
          error('unrecognized fieldname %s',varargin{i});
        end
      end
      
      if isempty(obj.cv), error('specify cross-validator'); end
      
    end
    
    function obj = train(obj,X,Y)

      if iscell(Y)
        ndata = length(Y);
      else
        ndata = 1;
      end

      obj.outcome = zeros(1,obj.nperm+1);
      for i=1:obj.nperm
        
        % ensure random permutation
        RandStream.setDefaultStream(RandStream('mt19937ar','seed',sum(100*clock)));
        
        % create permuted data
        if ndata == 1
          Z = Y(randperm(size(Y,1)),:);
        else
          Z = cell(size(Y));
          for c=1:ndata
            Z{c} = Y{c}(randperm(size(Y,1)),:);
          end
        end
        
        if obj.verbose
          fprintf('testing permutation %d of %d: ',i,obj.nperm);
        end
        
        tmp = obj.cv.train(X,Z);
        obj.outcome(i) = tmp.statistic;
        if obj.verbose
          fprintf('%.2f\n',obj.outcome(i));
        end
        
      end
      obj.cv = obj.cv.train(X,Y);
      obj.outcome(end) = obj.cv.statistic;
      if obj.verbose
        fprintf('actual outcome: %.2f\n',obj.outcome(end));
      end
    end
    
    function p = statistic(obj)
      % return permutation test statistic
      
      T = 0:1e-4:1;
      
      cdf = zeros(1,numel(T));
      for t=1:numel(T)
        cdf(t) = mean(obj.outcome(1:(end-1)) <= T(t));
      end
      
      % find last value that is smaller than a
      idx = find(obj.outcome(end) > T,1,'last');
      
      % report its associated p-value
      p = 1 - cdf(idx);
            
    end
    
  end
  
end
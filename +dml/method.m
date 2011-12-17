classdef method
% METHOD abstract class for multivariate methods
%
%   DESCRIPTION
%   The method class should not be called directly but forms the basis for 
%   all classes in the methods package

% Copyright (c) 2011, Marcel van Gerven


  properties
  
    verbose = false; % whether or not to generate diagnostic output
    
    % when false, starts at the previously learned parameters 
    % needed for online learning and grid search
    restart = true; 
    
  end
  
  methods
    
    function obj = method(varargin)
      
      % parse options
      for i=1:2:length(varargin)
        if ismember(varargin{i},fieldnames(obj))
          obj.(varargin{i}) = varargin{i+1};
        else
          error(sprintf('unrecognized fieldname %s',varargin{i}));
        end
      end
      
    end
    
    function m = model(obj)
      % this method does not return a model
      
      m = [];

    end
    
  end
  
  methods (Abstract)
      obj = train(obj,X,Y)
      Y = test(obj,X)
   end
  
end

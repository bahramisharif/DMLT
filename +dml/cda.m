classdef cda < dml.method
% CDA complex discriminant analysis.
%
%   DESCRIPTION
%
%   REFERENCE
%
%   EXAMPLE

% multiple tapers are handled independently; we just estimate them
% separately and sum the logliks; we should facilitate incorporation into
% one method; easiest is to allow cell array for X
%
% multiple frequencies: we must facilitate
% joint estimation since we then facilitate phase coupling etc

% Copyright (c) 2010, Marcel van Gerven

  properties
    
   
    
  end
  
  methods
    
    function obj = cda(varargin)

      obj = obj@dml.method(varargin{:});

    end
    
    function obj = train(obj,X,Y)
      % input is an nsamples by nvariables matrix when the variables
      % consist of spatial locations x frequencies complex values (real+imag) 
      % in some random order
      
      % we will do the calculations using the concatenation [real(estfourier),imag(estfourier)].
      % the result of this computation will be identical to the calculations that use the concatenation
      % [estfourier,conj(estfourier)]. This is because [estfourier,conj(estfourier)] is obtained from
      % [real(estfourier),imag(estfourier)] by taking the linear
      % transform [real(estfourier),imag(estfourier)]*T
      Xc = cat(2,real(X),imag(X));
      
      
     
      
      
    end
    
    function Y = test(obj,X)

      
      
    end

    function L = loglik(obj,X,Y)
      
      
      X * obj.w - 0.5 * (obj.mu{1} + obj.mu{2})' * obj.w;
      
    end
    
    function m = model(obj)
      % returns
      %
      
      
    end

  end
  
end

function net = f12net_c()

lr = [.1 2] ;

opts.useBnorm = true ;

net.layers = {} ;
net.layers{end+1} = struct('type', 'conv', ...
    'weights', {{0.01*randn(3,3,3,16, 'single'), zeros(1, 16, 'single')}}, ...
    'stride', 1, ...
    'learningRate', lr, ...
    'pad', 2) ;
net.layers{end+1} = struct('type', 'pool', ...
    'method', 'max', ...
    'pool', [3 3], ...
    'stride', 2, ...
    'pad', 0) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'conv', ...
    'weights', {{0.05*randn(6,6,16,128, 'single'), zeros(1, 128, 'single')}}, ...
    'stride', 1, ...
    'learningRate', lr, ...
    'pad', 0) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'dropout',  'rate', 0.5) ;
net.layers{end+1} = struct('type', 'conv', ...
    'weights', {{0.05*randn(1,1,128,45, 'single'), zeros(1, 45, 'single')}}, ...
    'stride', 1, ...
    'learningRate', .1*lr, ...
    'pad', 0) ;
net.layers{end+1} = struct('type', 'relu') ;
net.layers{end+1} = struct('type', 'softmaxloss') ;

% optionally switch to batch normalization
if opts.useBnorm
  net = insertBnorm(net, 1) ;
  net = insertBnorm(net, 5) ;
  net = insertBnorm(net, 9) ;
end

% --------------------------------------------------------------------
function net = insertBnorm(net, l)
% --------------------------------------------------------------------
assert(isfield(net.layers{l}, 'weights'));
ndim = size(net.layers{l}.weights{1}, 4);
layer = struct('type', 'bnorm', ...
               'weights', {{ones(ndim, 1, 'single'), zeros(ndim, 1, 'single')}}, ...
               'learningRate', [1 1], ...
               'weightDecay', [0 0]) ;
net.layers{l}.biases = [] ;
net.layers = horzcat(net.layers(1:l), layer, net.layers(l+1:end)) ;

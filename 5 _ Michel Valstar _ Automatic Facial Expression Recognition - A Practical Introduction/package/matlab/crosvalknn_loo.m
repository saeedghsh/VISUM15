function [p, c] = crosvalknn_loo(x, y, k, P)
%IN:  x: features
%     y: labels 
%     k: number of nearest-neigbhours to use in kNN voting
%     P: number of principal components to retain
%OUT: p: class predictions
%     c: classification rate

    n = size(y,1);
    p = zeros(size(y));
    
    if ~exist('P', 'var')
        P = 5;
    end
    
    % -- Apply PCA to reduce dimensionality
    [U, mu, ~] = pca(x');  % - Piotr's toolbox uses inverse definition of r/c
    Xk = pcaApply(x', U, mu, P);
    Xk = Xk';
    
    % -- Start cross validation!
    for i = 1:n
        I = setdiff(1:n, i);
        X1 = Xk(I, :);
        Y1 = y(I);
        X2 = Xk(i, :);
        idx = knnsearch(X1,X2,'dist','cityblock','k',k);
        p(i) = sign(mean(Y1(idx)));    
    end

    p(p==0) = -1;   % - Matlab says sign(0) == 0
    c = sum(p == y)/n;  % - Classification rate

end
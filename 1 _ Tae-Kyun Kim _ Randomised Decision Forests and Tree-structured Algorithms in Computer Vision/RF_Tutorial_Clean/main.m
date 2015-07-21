% Simple Random Forest Toolbox for Matlab
% by Mang Shao and Tae-Kyun Kim on June 20, 2014.

% This is a demo script for demonstration of Random Forest.
% The codes are made for educational purpose only.
% Some parts are inspired from Karpathy's RF Toolbox

% Under BSD Licence

% Initialisation
init;

% Set random forest parameters
param.num = 20;     % Number of trees
param.depth = 8;    % Tree depth
param.splitNum = 2; % Number of trails in split function
param.split = 'IG'; % Currently support 'information gain' only
showSVM = 0;        % Set 1 to show SVM results

% Select dataset
[data_train, data_test] = getData('Toy_Spiral'); % {'Toy_Gaussian', 'Toy_Spiral', 'Toy_Circle', 'Caltech'}

% Train Random Forest
trees = growTrees(data_train,param);

% Test Random Forest
leaf_assign = testTrees_fast(data_test,trees);

for T = 1:length(trees)
    p_rf(:,:,T) = trees(1).prob(leaf_assign(:,T),:);
end

% average the results from all trees
p_rf = squeeze(sum(p_rf,3))/length(trees); % Regression
[~,c] = max(p_rf'); % Regression to Classification
accuracy_rf = sum(c==data_test(:,end)')/length(c); % Classification accuracy (for Caltech dataset)

% Train SVM
% For more information about parameter setting: http://www.csie.ntu.edu.tw/~cjlin/libsvm/

% libsvm - kernel selection
%   t:
% 	0 -- linear: u'*v
% 	1 -- polynomial: (gamma*u'*v + coef0)^degree
% 	2 -- radial basis function: exp(-gamma*|u-v|^2)
% 	3 -- sigmoid: tanh(gamma*u'*v + coef0)

if showSVM
    disp('Training SVM...');
    
    if size(data_train,2) <= 3
        model_svm = svmtrain(data_train(:,end),data_train(:,1:end-1),'-t 2 -b 1 -c 10'); % For toy data
    else
        model_svm = svmtrain(data_train(:,end),data_train(:,1:end-1),'-s 4 -t 2 -b 1 -c 10'); % For Caltech
    end
    
    % Test SVM
    disp('Testing SVM...');
    [p_svm, accuracy_svm, p_svm_prob] = svmpredict(data_test(:,end), data_test(:,1:end-1), model_svm, '-b 1');
    accuracy_svm = accuracy_svm(1)/100;
else
    p_svm_prob = [];
end

% Visualise (if applicable)
visualise(data_train,p_rf,p_svm_prob,showSVM);
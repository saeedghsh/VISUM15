
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Face detection by Adaboost algorithm.
% (C) 2014, Written by Tae-Kyun Kim
% <a href="http://www.iis.ee.ic.ac.uk/icvl/">Personal Webpage</a>


% Compile C files
setup;

%% Data generation

% Q1: Data generation
% Store face and non-face data in ImgData.Pos and ImgData.Neg respectively. 
load ImgData_tr; ImgData = ImgData_tr; clear ImgData_tr;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Adaboost leanring
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DataProcess; % prepare training data in the format
WeakLearnerList; % build the list of weak learners

options.max_rules = 20; % number of weak-classifiers
options.learner = 'trainweak_fast';

fprintf('AdaBoost learning\n');

% Learn Adaboost classifier

% // AdaBoost algorithm with Haar features//
model = AdaBoost_Haar(data,imgs,X,cl,options);


save model_adaboost model;


%% Testing (Classification)
load model_adaboost; % load the learnt boosting classifier
load ImgData_te; ImgData = ImgData_te; clear ImgData_te; % load the testing data


% Evaluate your model on the provided test data set
%     - recognition accuracy
%     - draw roc curve


DataProcess; % prepare test data

[y dfec] = feval(model.fun, imgs, X, model);
length(find(data.y==y))/length(data.y)

% roc curve, this requires Statistical Pattern Recognition Toolbox
% or write your own code to draw ROC curve
[FP,FN] = roc(dfec,data.y); 
figure(1); 
xlabel('false positives'); 
ylabel('false negatives');
hold on; plot(FP,FN,'color','r');
% **********************************



%% Testing (Face Detection)

% (creating the response map for a selected test image)
% this code performs "scanning window" using your model
% outputs the response map

detect_face;
% **********************************
clear all; %remove all the old variables in the workspace
close all;

if exist('spambase.data', 'file') == 2
    file = fullfile('spambase.data');%replace spambase with name of the file here
    tmp = csvread(file);
    
    rng(0);
    tmp = tmp(randperm(size(tmp, 1)),:);
    
    trainingSize = uint32((2/3)*size(tmp,1));
    testingSize = size(tmp,1) - trainingSize;
    
    trainingData = tmp(1:trainingSize,1:end-1);
    
    %standardising the data matrix
    m = mean(trainingData(:,1:end));
    s = std(trainingData(:,1:end));

    trainingData(:,1:end)  = trainingData(:,1:end) - repmat(m,size(trainingData,1),1);
    trainingData(:,1:end) = trainingData(:,1:end)./repmat(s,size(trainingData,1),1);
        
    trainingData  = [ones(size(trainingData,1),1) trainingData];
    trainingLabels = tmp(1:trainingSize,end);
    
    testingData = tmp(trainingSize+1:end,1:end-1);
    
    testingData(:,1:end)  = testingData(:,1:end) - repmat(m,size(testingData,1),1);
    testingData(:,1:end) = testingData(:,1:end)./repmat(s,size(testingData,1),1);
    
    testingData  = [ones(size(testingData,1),1) testingData]; % 
    testingLabels = tmp(trainingSize+1:end,end);
    
    eps = 10^(-3);
    delta = 1.0;
    eta = 0.50;
    thetas = randi([-1,1], size(trainingData, 2), 1);
    while delta > eps
        reg = (eta/double(trainingSize)).*(trainingData')*(trainingLabels - (1./(1.+(exp(-1.*(trainingData * thetas))))));
        initial = ((trainingLabels).*log(1./(1.+exp((-1).*(trainingData * thetas))))) + ((1.-trainingLabels).*log(1.-(1./(1.+(exp(-1.*(trainingData * thetas))))))); 
        inital_x = sum(initial((~isinf(initial) & ~isnan(initial))));
        thetas = thetas + reg;
        final = ((trainingLabels).*log(1./(1.+exp(-1.*(trainingData * thetas))))) + ((1.-trainingLabels).*log(1.-(1./(1.+(exp(-1.*(trainingData * thetas)))))));
        final_x = sum(final((~isinf(final) & ~isnan(final))));
        delta = final_x - inital_x;
    end
    
    Predictions = 1./(1.+exp(-1.*(testingData * thetas)));
    
    for i=1:size(Predictions,1)
        if Predictions(i, 1) > 0.50
            Predictions(i,1) = 1;
        else
            Predictions(i,1) = 0;
        end
    end
    
    FP = 0;
    TP = 0;
    FN = 0;
    TN = 0;
    for i=1:size(Predictions,1)
        if (Predictions(i,1) == 1) && (testingLabels(i,1) == 1)
            TP = TP + 1;
        elseif (Predictions(i,1) == 1) && (testingLabels(i,1) == 0)
            FP = FP + 1;
        elseif (Predictions(i,1) == 0) && (testingLabels(i,1) == 1)
            FN = FN + 1; 
        elseif (Predictions(i,1) == 0) && (testingLabels(i,1) == 0)
            TN = TN + 1;        
        end
    end
    
    Accuracy = (TN+TP)/(size(testingData,1));
    fprintf("Accuracy: %d\n", (Accuracy*100));
    Precision = (TP)/(TP+FP);
    fprintf("Precision: %d\n", (Precision*100));
    Recall = (TP)/(TP+FN);
    fprintf("Recall: %d\n", (Recall*100));
    FMeasure = (2*Precision*Recall) / (Precision + Recall);
    fprintf("FMeasure: %d\n", (FMeasure*100));else
    error('file spambase.data not exits');
end
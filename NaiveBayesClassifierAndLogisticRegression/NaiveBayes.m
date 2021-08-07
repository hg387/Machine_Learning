clear all; %remove all the old variables in the workspace
close all;

if exist('spambase.data', 'file') == 2
    file = fullfile('spambase.data');%replace spambase with name of the file here
    tmp = csvread(file);
    
    rng(2);
    tmp = tmp(randperm(size(tmp, 1)),:);
    
    trainingSize = uint32((2/3)*size(tmp,1));
    testingSize = size(tmp,1) - trainingSize;
    
    trainingData = tmp(1:trainingSize,1:end-1);
    
    %standardising the data matrix
    m = mean(trainingData(:,1:end));
    s = std(trainingData(:,1:end));

    trainingData(:,1:end)  = trainingData(:,1:end) - repmat(m,size(trainingData,1),1);
    trainingData(:,1:end) = trainingData(:,1:end)./repmat(s,size(trainingData,1),1);
        
    %trainingData  = [ones(size(trainingData,1),1) trainingData];
    trainingLabels = tmp(1:trainingSize,end);
    
    testingData = tmp(trainingSize+1:end,1:end-1);
    
    testingData(:,1:end)  = testingData(:,1:end) - repmat(m,size(testingData,1),1);
    testingData(:,1:end) = testingData(:,1:end)./repmat(s,size(testingData,1),1);
    
    %testingData  = [ones(size(testingData,1),1) testingData]; % 
    testingLabels = tmp(trainingSize+1:end,end);
    
    dist = tmp(1:trainingSize, :);
    lastColumn = dist(:, end);
    spamData = trainingData(lastColumn == 1, :);
    nonSpamData = trainingData(lastColumn == 0, :);
    
    Pspam = size(spamData,1)/size(trainingData,1);
    Pnonspam = size(nonSpamData,1)/size(trainingData,1);
    
    meanSpam = mean(spamData);
    meanNonSpam = mean(nonSpamData);
    
    stdSpam = std(spamData);
    stdNonSpam = std(nonSpamData);
    
    
    
    
    Predictions = zeros(size(testingData,1),1);
    
    for i=1:size(testingData, 1)
        P1 = log(Pspam);
        P2 = log(Pnonspam);
        sumP1 = (((testingData(i,:) - meanSpam).^2)./(2.*((stdSpam).^2)));
        P1 = P1 - sum(sumP1((~isinf(sumP1) & ~isnan(sumP1)))) - sum(stdSpam((~isinf(stdSpam) & ~isnan(stdSpam))));
        sumP2 = (((testingData(i,:) - meanNonSpam).^2)./(2.*((stdNonSpam).^2)));
        P2 = P2 - sum(sumP2((~isinf(sumP1) & ~isnan(sumP2)))) - sum(stdNonSpam((~isinf(stdNonSpam) & ~isnan(stdNonSpam))));
        
        if (P1 > P2)
            Predictions(i,1) = 1;
        elseif (P1 < P2)
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
    fprintf("FMeasure: %d\n", (FMeasure*100));
else
    error('file spambase.data not exits');
end
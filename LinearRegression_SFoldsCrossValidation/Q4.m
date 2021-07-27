clear all; %remove all the old variables in the workspace
close all;

RMSEs = calculateSFolds(44); % replace 44 with any number less than no. of rows of data
m = mean(RMSEs);
s = std(RMSEs);

function RMSEs=calculateSFolds(S)
    RMSEs = zeros(20,1);
    for i=0:19
        if exist('x06Simple.csv', 'file') == 2
            file = fullfile('x06Simple.csv');%replace x06Simple.csv with name of the file here
            fullTable = importdata(file);
            
            rng(i);
            tmp = fullTable.data;
            tmp = tmp(randperm(size(tmp, 1)),:); % shuffling the data
            
            data = tmp(1:end,2:end);
        else
            error('file x06Simple.csv not exits');
        end
        
        if S > size(data, 1)
            error('Invalid size entered, S should be less than equal to number of rows in data');
        end
        
        folds = uint8(size(data,1)/S);
        if (size(data, 1) - (S*folds)) ~= 0
            S  = S + 1; % if last fold is less than the S value
        end
        
        Sfolds = zeros(folds,(size(data(:,2:end),2)+1),S);
        Slabels = zeros(folds,1,S);
        
        count  = 1;
        for j=1:S
            
            if ((size(data, 1) - S*folds) < 0) && (j == S) 
                lefts = size(data, 1) - count;
                Sfolds(1:lefts,:,j) = [ones(size(data(count:end,:)),1) data(count:end,2:end)]; 
                Slabels(1:lefts,:,j) = data(count:end,1); 
                continue;
            end
            
            Sfolds(:,:,j) = [ones(size(data(count:(folds*j),:),1),1) data(count:(folds*j),2:end)]; 
            Slabels(:,:,j) = data(count:(folds*j),1); 
            count = (folds*j) + 1;
        end
        
        SE = 0.0;
        N = 0;
        for k=1:S
            
            traininglabels = [];
            trainingdata = [];
            
            for j=1:S
              if k==j
                  testingdata = Sfolds(:,:,k);
                  testinglabels = Slabels(:,:,k);
                  N = N + size(testinglabels,1);
                  continue;
              end
              trainingdata = cat(1,trainingdata, Sfolds(:,:,j));
              traininglabels = cat(1,traininglabels, Slabels(:,:,j));
            end
            
            thetas = (inv(trainingdata' * trainingdata));
            thetas = thetas * (trainingdata');
            thetas = thetas * traininglabels;
            
            newY = testingdata * thetas;
            SE = SE + sum((testinglabels - newY).^2);
        end
        
        RMSE = (double (SE)/ double (N))^(1/2);
        RMSEs((i+1),1) = RMSE;
        clearvars -except i RMSEs S ;
    end
end
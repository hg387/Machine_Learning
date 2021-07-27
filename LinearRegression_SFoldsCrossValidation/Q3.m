clear all; %remove all the old variables in the workspace
close all;

if exist('x06Simple.csv', 'file') == 2
    file = fullfile('x06Simple.csv');%replace x06Simple.csv with name of the file here
    fullTable = importdata(file);
    
    rng(0);
    tmp = fullTable.data;
    tmp = tmp(randperm(size(tmp, 1)),:); % shuffling the data
    
    X = tmp(1:end,3:end);
    Y = tmp(1:end,2);
else
    error('file x06Simple.csv not exits');
end


data  = [ones(size(X,1),1) X];

trainingsize = uint8((2*size(data,1))/3); 
testingsize = size(data,1) - trainingsize;

trainingdata = data(1:trainingsize,:);
testingdata = data((trainingsize+1):end,:);

thetas = (inv(trainingdata' * trainingdata));
thetas = thetas * (trainingdata');
thetas = thetas * Y(1:trainingsize,:);

newY = testingdata * thetas;

RMSE = (sum((newY - Y((trainingsize+1):end,:)).^2));
RMSE = double (RMSE) / double (testingsize);
RMSE = RMSE ^ (1/2);
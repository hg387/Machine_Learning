clear all; %remove all the old variables in the workspace
close all;

%if database already exists
if exist('database.mat', 'file') == 2
    load('database.mat')
else
    files = dir(fullfile('yalefaces','*subject*'));%replace yalefaces with name of the dir here
    if isempty(files)
        error('dir yalefaces not exits or empty');
    end
    
    data = zeros(154,1600);%preallocating data matrix


    for i=1:length(files)
        tmp=imread(fullfile('yalefaces',files(i).name));%read files
        file=imresize(tmp, [40, 40]);%compress them to 40 by 40
        final = reshape(file, [1, 1600]);%flatten them to 1 by 1600
        data(i,:) = final;%concatenate to data matrix
    end

    save('database.mat','data');%saving the data matrix in file
    clearvars -except data
end

%standardising the data matrix
m = mean(data);
s = std(data);

data  = data - repmat(m,size(data,1),1);
data = data./repmat(s,size(data,1),1);

[U, Sig, V] = svd(data);%calculating eigenvectors
final = data * (V(:,1:2));%selected only 2 eigenvectors

figure;plot(final(:,1), -final(:,2), 'o');%rotated to match axes
xlabel('PC1'); ylabel('PC2');
print('-dpng', 'plot.png');
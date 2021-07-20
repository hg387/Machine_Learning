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

%added eigen decomposition to show V = W and C is covariance 
C = cov(data);
%C = data' * data;
[W, lambda] = eig(C);
W = W(:,end:-1:1);

[U, Sig, V] = svd(cov(data));
%V = flip(V,2);
video = VideoWriter('eigenFaces.avi');%create video file
%video.FrameRate = 10;
open(video);

tmp=imread(fullfile('yalefaces','subject02.centerlight'));%read subject02.centerlight
file=imresize(tmp, [40, 40]);%compress them to 40 by 40
tmp = reshape(file, [1, 1600]);%flatten them to 1 by 1600
tmp = double(tmp);%convert int to double
tmp  = tmp - repmat(m,size(tmp,1),1);%standardising image
tmp = tmp./repmat(s,size(tmp,1),1);

for k=1:length(V)
    final = tmp * (V(:,1:k));%projecting image on k PC axes
    refinal = final * (V(:,1:k)');%reconstrcuting 
    
    %removing standardisation
    refinal = refinal.*repmat(s,size(refinal,1),1);
    refinal  = refinal + repmat(m,size(refinal,1),1);
    
    %making 40 by 40 image
    file = reshape(refinal, [40, 40]);
    image = uint8(file);
    position = [1 1];
    value = k;
    RGB = insertText(image,position,value,'FontSize',6);
    
    writeVideo(video,RGB);
end

close(video);
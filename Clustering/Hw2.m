clear all; %remove all the old variables in the workspace
close all;

if exist('diabetes.csv', 'file') == 2
    file = fullfile('diabetes.csv');%replace diabetes.csv with name of the file here
    fullTable = csvread(file);
    Y = fullTable(:,1);
    X = fullTable(:,2:end);
else
    error('file diabetes.csv not exits');
end

%standardising the data matrix
m = mean(X);
s = std(X);

X  = X - repmat(m,size(X,1),1);
X = X./repmat(s,size(X,1),1);
myKMeans(X, Y, 6);

function f = myKMeans(X, Y, k)
    if size(X,2) < 3
        name = ['K_',num2str(k),'F_',num2str(size(X,2))];
    end
    name = ['K_',num2str(k),'_F_all'];
    video = VideoWriter(name);%create video file
    video.FrameRate = 5;
    open(video);
    
    if (size(X,2) > 3)
        [~,~,V] = svd((cov(X)));
        X = X * (V(:,1:3));
    end
    rng(0);
    refs = randi([1, size(X,1)],1,k);
    
    inital = zeros(size(refs,2),size(X,2));%preallocating inital matrix
    for i=1:size(refs,2)
        inital(i,:) = X(refs(:,i),:);
        %X(refs(:,i),:) = [];
    end
    
    f = zeros(size(X,1),1);
   	newInitals = zeros(size(X,1),size(X,2), k);
    purityWeights = zeros(2,2,k);
    for index=1:k
        purityWeights(:,1,index) = [-1;1];
    end
    count = 1;
    while count > 0
        for i=1:size(X,1)
            minValue = [realmax('double'),0.0];
            for j=1:size(refs,2)
                distance = norm(inital(j,:) - X(i,:),2);
                if (min(minValue(1,1),distance) == distance) && (distance ~= 0)
                    minValue(1,1) = distance;
                    minValue(1,2) = j;
                end
            end
            f(i,1) = minValue(1,2);
            newInitals(i,:,minValue(1,2)) = X(i,:);
            if purityWeights(1,1,minValue(1,2)) == Y(i,1)
                purityWeights(1,2,minValue(1,2)) = purityWeights(1,2,minValue(1,2)) + 1;
            elseif purityWeights(2,1,minValue(1,2)) == Y(i,1)
                purityWeights(2,2,minValue(1,2)) = purityWeights(2,2,minValue(1,2)) + 1;
            end
        end
        puritynum =0;
        purityden = 0;
        for t=1:k
            puritynum = puritynum + max(purityWeights(:,2,t));
            purityden = purityden + (sum(purityWeights(:,2,t)));
        end
        purityAverage = puritynum / purityden;
        
        meanArray = mean(newInitals);
        puritysum = 0.0;
        for q=1:size(inital,1)
            puritysum = puritysum + norm(meanArray(:,:,q)-inital(q,:),1);
        end
        
        colorso = {'ro','go','bo','yo','co','ko','mo'};
        colorsx = {'rx','gx','bx','yx','cx','kx','mx'};
        if (size(X,2) > 2)
            fig = figure(count);
            for m=1:k
                scatter3(inital(m,1),inital(m,2),inital(m,3),colorso{m},'LineWidth',5)
                hold on
                scatter3(newInitals(1:end,1,m),newInitals(1:end,2,m),newInitals(1:end,3,m),colorsx{m})
            end
            hold off;
            title(['Iteration ', num2str(count), 'Purity = ', num2str(purityAverage)]);
            set(fig, 'Visible','off');
            writeVideo(video,getframe(gcf));
            %drawnow;
        else
            fig = figure(count);
            for m=1:k
                plot(inital(m,1),inital(m,2),colorso{m},'LineWidth',5)
                hold on
                plot(newInitals(1:end,1,m),newInitals(1:end,2,m),colorsx{m})
            end
            hold off;
            title(['Iteration ', num2str(count), 'Purity = ', num2str(purityAverage)]);
            set(fig, 'Visible','off');
            writeVideo(video,getframe(gcf));
            %drawnow;
        end
        
        if (puritysum < (2^(-23)))
            break
        else
            newInitals = zeros(size(X,1),size(X,2), k);
            for mn=1:k
                inital(mn,:) = meanArray(:,:,mn);
            end
            count  = count + 1;
        end
        
        
    end
    close(video);
end


clear all; %remove all the old variables in the workspace
close all;

x1 = 0;
x1values = [];
x1values(1,1) = 0;
x2 = 0;
x2values = [];
x2values(1,1) = 0;
J = (x1 + x2 -2)^2;
eta = 0.1;
count = 1;
counts = [];
counts(1,1) = 1;
Jvalues = [];
Jvalues(1,1) = J; 

while J > (2^-23)
    for i=1:2
        count = count + 1;
        
        if i==1
            x1 = x1 - (2*eta*(x1 + x2 -2));
            x1values(count,1) = x1;
            x2values(count,1) = x2;
        else
            x2 = x2 - (2*eta*(x1 + x2 -2));
            x1values(count,1) = x1;
            x2values(count,1) = x2;
        end
        
        J = (x1 + x2 -2)^2;
        Jvalues(count,1) = J;
        counts(count,1) = count;
    end
end

figure(1);
subplot(3,1,1);
scatter(counts,Jvalues,10,'filled');
xlabel('Iteration number');
ylabel('J');
title('Plot iteration vs J');

%figure(2);
subplot(3,1,2);
scatter(counts,x1values,10, 'filled');
xlabel('Iteration number');
ylabel('x1');
title('Plot iteration vs x1');

%figure(3);
subplot(3,1,3);
scatter(counts,x2values,10, 'filled');
xlabel('Iteration number');
ylabel('x2');
title('Plot iteration vs x2');

savefig('Q2.fig');
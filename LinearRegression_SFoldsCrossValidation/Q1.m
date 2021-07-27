clear all; %remove all the old variables in the workspace
close all;
matrix = [1,2,3,4;5,6,7,8;0,7,7,1];

n = uint8 (1/4);

%now = randperm(11);
t = [ones(size(matrix,1),1)  matrix];
now = matrix(randperm(size(matrix,1)), :);

[x1, x2] = meshgrid(-2:0.1:2, -2:0.1:2);
J = (x1 + x2 - 2).^2;
%idx = islocalmin(J);

surf(x1, x2, J);
ix = find(imregionalmin(J));
hold on
plot3(x1(ix), x2(ix), J(ix),'r*','MarkerSize',24);
xlabel('x1');
ylabel('x2');
zlabel('J');
title('Minimas are marked by red *');

x1mins = x1(ix);
x2mins = x2(ix);
Jmins = J(ix);
%[x_opt,y_opt]=find(J==min(J(:)));
savefig('Q1.fig');
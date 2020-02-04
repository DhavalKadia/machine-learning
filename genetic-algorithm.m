%HMK2 Kadia D

clearvars
rng('shuffle')  

x=[
    0.1, 0.1, -1;
    0.1, 0.9, -1;
    0.9, 0.1, -1;
    0.9, 0.9, -1];   %Input

ye=[0.1,
    0.9,
    0.9,
    0.1];    %Expected output

popsize = 200;
limit = 100000;
climit = 50;
pc = .95;        % Crossover Probability
pm = .05;        % Mutation Probability
flag = 0;

initpop = rand(3, 3, popsize) * 20 - 10;
populationX = zeros(3, 3, limit);
childX = zeros(3, 3, climit);

for i = 1:popsize
    populationX(:, :, i) = initpop(:, :, i);
end

fitness = evaluatepop(x, populationX, ye, popsize);
fitordered = getbestsol(fitness, popsize);
popsize = popsize + 1;

fprintf(1,'\nProgram has started. Please wait...\n')

while popsize < limit - 5 && cost(x, populationX, fitordered(1), ye) > 0.001 
        
    for k = 1:climit
        childX(:,:,k) = populationX(:,:,fitordered(k));
    end       
    
    if rand() > pc
        childX = crossover(childX, climit, fitordered, populationX);
        flag = 1;
    end
    
    if rand() > pm          
        childX = mutate(childX, climit);
        flag = 1;
    end
     
    if flag == 1
        add = climit;
        
        for k = 0:add-1
            populationX(:, :, popsize + k) = childX(:,:,k+1);
        end
     
        fitness = evaluatepop(x, populationX, ye, popsize+add-1);
        fitordered = getbestsol(fitness, popsize+add-1);
     
        popsize = popsize + add;
    end
        
    if mod(popsize - 1, 50) == 0
        climit = climit + 10;
    end
    
    flag = 0;
end

w = populationX(:, :, fitordered(1));

% Display output

plot (x(1,1), x(1,2), 'o', 'MarkerFaceColor', 'r')
hold on
plot (x(2,1), x(2,2), 'o', 'MarkerFaceColor', 'g')
hold on
plot (x(3,1), x(3,2), 'o', 'MarkerFaceColor', 'g')
hold on
plot (x(4,1), x(4,2), 'o', 'MarkerFaceColor', 'r')
hold on

y=zeros(1,4);    
z=[
    0, 0, -1;
    0, 0, -1;
    0, 0, -1;
    0, 0, -1]; 
   
for j=1:4 
    k=w(1,:)*(x(j,:))';
    z(j,1)=sigmf(k,[1 0]);
    k=w(2,:)*(x(j,:))';
    z(j,2)=sigmf(k,[1 0]);
    k=w(3,:)*z(j,:)';
    y(j)=sigmf(k,[1 0]);     
end

fprintf(1,'\nY :');
disp(y)
fprintf(1,'W :\n');
disp(w)
    
m=-10:0.1:10;           
n=(w(1,3)-w(1,1)*m)/w(1,2);
plot(m,n,'g')                 
n=(w(2,3)-w(2,1)*m)/w(2,2);
plot(m,n,'r')
            
xlim([-5 5])
ylim([-5 5])
title('XOR Gate')
xlabel('X1')
ylabel('X2')
daspect([1 1])   
  
% User Defined Functions

function c = cost(x, w, i, ye)
    y=zeros(1,4);    
    z=[
    0, 0, -1;
    0, 0, -1;
    0, 0, -1;
    0, 0, -1];     

    c = 0; 
    for j=1:4
        k=w(1,:,i)*(x(j,:))';
        z(j,1)=sigmf(k,[1 0]);
        k=w(2,:,i)*(x(j,:))';
        z(j,2)=sigmf(k,[1 0]);
        k=w(3,:,i)*z(j,:)';
        y(j)=sigmf(k,[1 0]);        
        c = c + (ye(j) - y(j))^2;
    end
end

function fitordered = getbestsol(fitness, popsize)    
    [temp,fitordered] = sort(fitness,'ascend'); 
end

function fitness = evaluatepop(x, polulation, ye, popsize)
    fitness = zeros(1, popsize);
    
    pop = polulation;
    
    for i = 1:popsize
        fitness(i) = cost(x, pop, i, ye);
    end
end
    
function child = crossover(childX, climit, fitordered, populationX)
    child = childX;
    
    for x = 1:climit
        location = randperm(9, 9);
        location = location - 1;
    
        for i = 1:9
            locy = floor((location(i)) / 3);
            locx = mod(location(i), 3);        
            locx = locx + 1;
            locy = locy + 1;             
            child(locx, locy, x) = populationX(locx, locy, fitordered(i));
        end
    end        
end

function child = mutate(childX, climit)
    child = childX;
    
    for t = 1:6             %6 places to mutate
        for x = 1:climit
            row = randi(3);
            col = randi(3);
            rw = rand()*4 - 2;   
            child(col, row, x) = child(col, row, x) + rw;   
        end
    end
end
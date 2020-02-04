%HMK2
%Dhaval Dilip Kadia [101622808]

clearvars
rng('shuffle')  %each time a different seed is given to random generator based on time

x=[
    0.1, 0.1, -1;
    0.1, 0.9, -1;
    0.9, 0.1, -1;
    0.9, 0.9, -1];   %Input

disp(x)

ye=[0.1,
    0.9,
    0.9,
    0.1];    %Expected output
disp(ye)

w=rand(2,3)*0.4-0.2;
w2=rand(1,3)*0.4-0.2;

fprintf(1, 'PROGRAM STARTED');

sol = [w; w2];
old_cost = cost(x, w, w2, ye);

T = 1.0;
T_min = 0.00001;

alpha = 0.97;

while T > T_min   
    i = 1;    
    while i <= 1000 % rw = rand()*.02 - .01;       
        %fprintf(1,'\nSOL:\n'); %Print Weights
        %disp(sol);        
        new_sol = neighbour(sol);
        w = [new_sol(1,1:3); new_sol(2,1:3)];
        w2 = new_sol(3,1:3);                
        new_cost = cost(x, w, w2, ye);        
        ap = a_prob(old_cost, new_cost, T);        
        if ap > rand()
           sol = new_sol;
           old_cost = new_cost;           
        end        
        i = i + 1;
    end    
    T = T * alpha;    
end

% Final Ws and Ys

fprintf(1,'\nPROGRAM FINISHED\n W:\n')
disp(w)
disp(w2)

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
   

    for j=1:4   %Calculate z1 which comes from the present weight
        k=w(1,:)*(x(j,:))';
        z(j,1)=sigmf(k,[1 0]);
    end
        
    for j=1:4   %Calculate z2 which comes from the present weight
        k=w(2,:)*(x(j,:))';
        z(j,2)=sigmf(k,[1 0]);        
    end
       
    for j=1:4   %Calculate y which comes from the present weight
        k=w2*z(j,:)';
        y(j)=sigmf(k,[1 0]);
    end 

    fprintf(1,'\nY :\n');
    disp(y)
    
    fprintf(1,'\nZ :\n');
    disp(z)
    
            m=-10:0.1:10;          
            n=(w(1,3)-w(1,1)*m)/w(1,2);
            plot(m,n,'g')
            
            n=(w(2,3)-w(2,1)*m)/w(2,2);
            plot(m,n,'r')
              
            n=(w2(3)-w2(1)*m)/w2(2);
            %plot(m,n,'b')
            
            xlim([-5 5])
            ylim([-5 5])
            title('XOR Gate')
            xlabel('X1')
            ylabel('X2')
            daspect([1 1])
            
            
% User Defined Functions
function ap = a_prob(old_cost, new_cost, T)
ap = exp((old_cost - new_cost)/T);
end

function c = cost(x, w, w2, ye)

    y=zeros(1,4);
    
    z=[
    0, 0, -1;
    0, 0, -1;
    0, 0, -1;
    0, 0, -1]; 
    
  %  fprintf(1, 'Inside Cost Function');

    for j=1:4   %Calculate z1 which comes from the present weight
        k=w(1,:)*(x(j,:))';
        z(j,1)=sigmf(k,[1 0]);
    end
        
    for j=1:4   %Calculate z2 which comes from the present weight
        k=w(2,:)*(x(j,:))';
        z(j,2)=sigmf(k,[1 0]);       
    end    
       
    for j=1:4   %Calculate y which comes from the present weight
        k=w2*z(j,:)';
        y(j)=sigmf(k,[1 0]);
    end 
    
    c = 0;    
    for j=1:4
        c = c + (ye(j) - y(j))^2;
    end
end


function sol = neighbour(solI)

    sol = solI;

    r = rand() * 10 + 1;
    r = int8(r);
    rw = rand()*.02 - .01;
    %rw = rand(1) - 0.5;
    
    if r == 1
        sol(1) = sol(1) + rw;
    end
    if r == 2
        sol(4) = sol(4) + rw;
    end
    if r == 3
        sol(7) = sol(7) + rw;
    end
    if r == 4
        sol(2) = sol(2) + rw;
    end
    if r == 5
        sol(5) = sol(5) + rw;
    end
    if r == 6
        sol(8) = sol(8) + rw;
    end
    if r == 7
        sol(3) = sol(3) + rw;
    end
    if r == 8
        sol(6) = sol(6) + rw;
    end
    if r == 9
        sol(9) = sol(9) + rw;
    end
    
end
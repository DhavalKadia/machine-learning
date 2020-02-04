%HW _1_CPS581 Q1, Dhaval Kadia [101622808]

clearvars
rng('shuffle')  %each time a different seed is given to random generator based on time

w=rand(1,3)*4-2;    %Give weight random value between [-2,2]
if w(2)==0  %w(2) cannot be zero
    w(2)=w(2)+0.1;
end

x=[
    -1,-1, 1;
    -2, 1, 1;
     2,-2, 1;
     1, 1, 1];   %Input
disp(x)

ye=[-1,
    -1,
     1,
     1];    %Expected output
disp(ye)

y=zeros(1,4);    %Initialize y
disp (y)

count=0;    %Counter of jumping out of the main loop
learningrate=0.02;    %Parameter (Speed controller)

plot (x(1,1), x(1,2), 'o', 'MarkerFaceColor', 'r')
hold on
plot (x(2,1), x(2,2), 'o', 'MarkerFaceColor', 'r')
hold on
plot (x(3,1), x(3,2), 'd', 'MarkerFaceColor', 'g')
hold on
plot (x(4,1), x(4,2), 'd', 'MarkerFaceColor', 'g')
hold on

for i=1:10000     %Loop maximum to 10000 times
    if count==4    %Exit of the main loop
        break;
    end
    
    count=0;    %Reset the counter
    for j=1:4   %Calculate y which comes from the present weight
        k=w*(x(j,1:3))';
        disp (x(j,1:3))
        if k>0
            y(j)=1;
        else
            y(j)=-1;
        end 
    end
    
    for g=1:4   %Compare y with the expected output
        if y(g)==ye(g)
            count=count+1;
            continue;
        else
            % m=-3:0.1:3;     %Draw the misclassification graph
            if w(2)==0  %w(2) cannot be zero
                w(2)=1;
            end
            m=-3:0.1:3;           
            n=(-w(3)-w(1)*m)/w(2);
            plot(m,n,'g')
            axis([-3 3 -3 3])
            hold on
            pause(0.1);     %Pause between each graphic output
            
            w=w+learningrate*x(g,1:3)*ye(g);      %Update new weight value
            break;
        end
    end
end

% m=-3:0.1:3;     %Final graphic output
if w(2)==0  %w(2) cannot be zero
        w(2)=1;
 end
m=-3:0.1:3;
n=(-w(3)-w(1)*m)/w(2);
plot(m,n,'b')
axis([-3 3 -3 3])
hold on
disp (w)
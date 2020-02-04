%HW _1_CPS581 Q2, Dhaval Kadia [101622808]

clearvars
rng('shuffle')  %each time a different seed is given to random generator based on time

w=rand(1,4)*4-3;    %Give weight random value between [-3,3]
if w(3)==0  %w(3) cannot be zero
    w(3)=w(3)+0.1;
end

x=[
-1	-1	-1  1
-2	-2	-1  1
-1	-3	-2  1
-1	-1	-2  1
 1	 1	 1  1
 2	 2	 1  1
 1	 3	 2  1
 1	 1	 2  1];   %Input
disp(x)

ye=[
-1
-1
-1
-1
 1
 1
 1
 ];    %Expected output
disp(ye)

y=zeros(1,8);    %Initialize y
disp (y)

count=0;    %Counter of jumping out of the main loop
learningrate=0.02;    %Parameter (Speed controller)

scatter3(x(1,1), x(1,2), x(1,3), 100, 'r', 'filled')
hold on
scatter3(x(2,1), x(2,2), x(2,3), 100, 'r', 'filled')
hold on
scatter3(x(3,1), x(3,2), x(3,3), 100, 'r', 'filled')
hold on
scatter3(x(4,1), x(4,2), x(4,3), 100, 'r', 'filled')
hold on
scatter3(x(5,1), x(5,2), x(5,3), 100, 'b', 'filled')
hold on
scatter3(x(6,1), x(6,2), x(6,3), 100, 'b', 'filled')
hold on
scatter3(x(7,1), x(7,2), x(7,3), 100, 'b', 'filled')
hold on
scatter3(x(8,1), x(8,2), x(8,3), 100, 'b', 'filled')
hold on

for i=1:10000     %Loop maximum to 10000 times
    if count==8    %Exit of the main loop
        break;
    end
    
    count=0;    %Reset the counter
    for j=1:8   %Calculate y which comes from the present weight
        k=w*(x(j,1:4))';
        disp(k)
        if k>0
            y(j)=1;
        else
            y(j)=-1;
        end 
    end
    
    for g=1:8   %Compare y with the expected output
        if y(g)==ye(g)
            count=count+1;
            continue;
        else
            if w(3)==0  %w(3) cannot be zero
                w(3)=1;
            end
            
            [m,n]=ndgrid(-5:5,-5:5);
            o = (-w(1)*m - w(2)*n - w(4))/w(3);
            s = surf(m, n, o,'FaceAlpha',0.08);          
            s.EdgeColor = 'none';
            s.FaceColor = 'c';
            zlim([-5 5])
            daspect([1 1 1])
            
            hold on
            pause(0.1);     %Pause between each graphic output
            
            w=w+learningrate*x(g,1:4)*ye(g);      %Update new weight value
            disp(w)
            break;
        end
    end
end

if w(3)==0  %w(3) cannot be zero
   w(3)=1;
end
 
[m,n]=ndgrid(-5:5,-5:5);
o = (-w(1)*m - w(2)*n - w(4))/w(3);
f = surf(m, n, o,'FaceAlpha',0.2);          
f.EdgeColor = 'none';
f.FaceColor = 'b';
zlim([-5 5])
daspect([1 1 1])
xlabel(
disp(w)
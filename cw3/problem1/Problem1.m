clear all;close all;clc;
f = imread('Fig1108(a)(mapleleaf).tif'); %read the original image


%if Necessary apply these binarization to a coloured image, to obtain a binarized one
%h = fspecial('gaussian',25,15); 
%g = imfilter(f,h,'replicate');
%f = imbinarize(g,0.5);
F=f;

[rows, cols] = size(f);
c = 1;
flag = ones(rows,cols);   % Create our flag matrice with the same size as the original picture
%flag = zeros(rows,cols); %Antother way

while c~=0      
    c=0;     % Counter set to know if the flagged matrix is empty or not

    %---STEP 1---
    for x = 2 : rows-1   
        for y = 2 : cols-1 % For each inner pixel
            Tp=0;            %Reset T(p)   
            P(1) = f(x-1,y);   %creation of our vector following the 8-neighborhood notation
            P(2) = f(x-1,y+1);
            P(3) = f(x,y+1);
            P(4) = f(x+1,y+1);
            P(5) = f(x+1,y);
            P(6) = f(x+1,y-1);
            P(7) = f(x,y-1);
            P(8) = f(x-1,y-1);
            NP = sum(P);       %Calculate the number of neighbors, and N(p)
            if f(x,y)==1 && NP<=6 && NP >=2  %We focus only on flagged point that fulfill 1st condition
                for i=1:7
                   if P(i)==0 && P(i+1)==1
                       Tp=Tp+1;         %Calculate T(p)
                   end
                end
                if P(8)==0 && P(1) ==1
                   Tp=Tp+1;
                end
                Pa = P(1)*P(3)*P(5);        %We calculate our last conditions
                Pb = P(3)*P(5)*P(7);
                if Tp ==1 && Pa ==0 && Pb ==0 %We verify if the flagged point fulfill all left conditions
                       flag(x,y) = 0;         %If so we flag the point
                       c=1;                   %We say that the Flag matrix is not empty
                       %flag(x,y) = 1;
                end
            end        
        end
    end

    %---DELETION----
    f=f.*flag;   % After generation of the flag Matrix, we delete all the points flagged
    %f=f-flag;
    %flag = zeros(rows,cols);
    
    %---STEP 2---
    for x = 2 : rows-1
        for y = 2 : cols-1 % For each inner pixel
            Tp=0;               %Reset T(p)
            P(1) = f(x-1,y);    %creation of our vector following the 8-neighborhood notation
            P(2) = f(x-1,y+1);
            P(3) = f(x,y+1);
            P(4) = f(x+1,y+1);
            P(5) = f(x+1,y);
            P(6) = f(x+1,y-1);
            P(7) = f(x,y-1);
            P(8) = f(x-1,y-1);
            NP = sum(P);       %Same as Step1     
            if f(x,y)==1 && NP<=6 && NP >=2 %Same as Step1  
                for i=1:7
                   if P(i)==0 && P(i+1)==1  %Same as Step1  
                       Tp=Tp+1;
                   end
                end
                if P(8)==0 && P(1) ==1 %Same as Step1  
                   Tp=Tp+1;
                end
                Pa = P(1)*P(3)*P(7);  %Calculate the 2 new condition for the 2nd Step
                Pb = P(1)*P(5)*P(7);
                if Tp ==1 && Pa ==0 && Pb ==0  %We verify if the flagged point fulfill all left conditions
                      flag(x,y) = 0;  %If so we flag the point
                      c=1;                   %We say that the Flag matrix is not empty
                      %flag(x,y) =1;               
                end 
            end        
        end
    end

    %---DELETION----
    f=f.*flag;
    %f=f-flag;
    %flag = zeros(rows,cols);
end

figure,
subplot(1,2,1)
imshow(F),title("Original Image"),impixelinfo
subplot(1,2,2)
imshow(f),title("skeletonized image"),impixelinfo

            


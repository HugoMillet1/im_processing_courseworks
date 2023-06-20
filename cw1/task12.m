
close all; clear all; clc;

%% Task 1
I1 = im2double(imread('images\einstein.jpg')); % original image
imresult = nonlinearfilter(I1); % Filter function
%% Task 2
I2 = im2double(imread('images\low_light\samsung_galaxy.jpg'));
[rows, cols] = size(I2(:,:,1)); % size of original image
T2 = zeros(rows, cols);
for i = 1:rows
    for j = 1:cols
        T2(i,j)= max(I2(i,j,1:3)); % Keeping the max value between R, G and B, for each pixel
    end
end
U = nonlinearfilter(T2); % Applying filter from task1

epsilon = 0.1;

E = I2;
for i = 1:rows
    for j = 1:cols
        E(i,j,:) = E(i,j,:)/(U(i, j)+epsilon); % Dividing original image by U+eps
    end
end
figure, imshow(E), impixelinfo;
%% Non-linear filter function
function imOut = nonlinearfilter(im)
    [rows, cols] = size(im); % size of original image
    In = im;
    InPlusOne = zeros(rows, cols);
    
    N = 20; % number of iterations
    k = 150; % positive integer in wij formula 
    
    for n = 1 : N % iterations
    
      for x = 2 : rows-1
        for y = 2 : cols-1 % for each inner pixel
          % Initialization / reset of sum terms
          sumwij = 0;
          sumpixwij = 0;
          for i = -1 : 1  
            for j = -1 : 1
             % Construction of sum terms
             wij = exp(-k*abs(In(x,y)-In(x+i,y+j))); % wij coefficient formula
    
             sumwij = sumwij + wij;
             sumpixwij = sumpixwij + wij*In(x+i,y+j);
            end 
          end
          InPlusOne(x, y) = sumpixwij/sumwij; % Pixel of the new iteration
        end
      end
    
      In = InPlusOne; % new iteration
    end
    imOut = InPlusOne;
    figure, imshow([im,imOut]), impixelinfo;
end
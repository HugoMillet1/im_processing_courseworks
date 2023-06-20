
clear all
close all

%
I = imread('leaf.tif');
figure, imshow(I);
title("Original Image");
pause;

I_deformed = imread('leaf_deformed.png');


I_noised = imnoise(single(I), 'salt & pepper');
figure, imshow(I_noised);
title("Noised Image");
pause;
%
%% Put below in commentary if image already in black and white
%I = 1-im2double(I);
%h = fspecial('gaussian',25,15);
%I = imfilter(I,h,'replicate');
%bw_param = 1.7;
%I = im2bw(I,bw_param*graythresh(I));
%figure, imshow(I_deformed);
%title("Black and White version of the image");
%pause;

% Comparison for deformed image
%I_deformed = 1-im2double(I_deformed);
%h = fspecial('gaussian',25,15);
%I_deformed = imfilter(I_deformed,h,'replicate');
bw_param = 0.5;
I_deformed = im2bw(I_deformed,bw_param*graythresh(I_deformed));
figure, imshow(I_deformed);
title("Deformed, BW version of the image");
pause;
%%
%
% Find a starting point on the boundary
[rows cols] = find(I~=0);

contour = bwtraceboundary(I, [rows(1), cols(1)], 'N');
contour_deformed = bwtraceboundary(I_deformed, [rows(1), cols(1)], 'N'); % starting from the same point
contour_noised = bwtraceboundary(I, [rows(1), cols(1)], 'N');
% Subsample the boundary points so we have exactly 128, and put them into a
% complex number format (x + jy)
sampleFactor = length(contour)/128;
dist = 1;
for i=1:128
    c(i) = contour(round(dist),2) + j*contour(round(dist),1);
    c_def(i) = contour_deformed(round(dist),2) + j*contour_deformed(round(dist),1);
    c_noi(i) = contour_noised(round(dist),2) + j*contour_noised(round(dist),1);
    dist = dist + sampleFactor;
end

C = fft(c);
C_def = fft(c_def);
C_noi = fft(c_noi);
% Chop out some of the smaller coefficients (less than umax)
% umax = 32;
umax = 13; 
Capprox = C;
Capprox_def = C_def;
Capprox_noi = C_noi;
for u=1:128
    if u > umax & u < 128-umax
        Capprox(u) = 0;
        Capprox_def(u) = 0;
        Capprox_noi(u) = 0;
    end
end

% Take inverse fft
cApprox = ifft(Capprox);
cApprox_def = ifft(Capprox_def);
cApprox_noi = ifft(Capprox_noi);


% Show original boundary and approximated boundary
figure, imshow(imcomplement(bwperim(I)));
hold on, plot(cApprox,'r');
title("Contour and Fourier descriptors, original image");

% Show original boundary and approximated boundary for deformed image
figure, imshow(imcomplement(bwperim(I_deformed)));
hold on, plot(cApprox_def,'r');
title("Contour and Fourier descriptors, deformed image");

% Show original boundary and approximated boundary for noised image
figure, imshow(imcomplement(bwperim(I_noised)));
hold on, plot(cApprox_noi,'r');
title("Contour and Fourier descriptors, deformed image");


% Show boundary comparison, original/deformed
figure, plot(cApprox,'r');
hold on, plot(cApprox_def,'g');
title("Comparison FD orignal/deformed image");

% Show boundary comparison, original/noised
figure, plot(cApprox,'r');
hold on, plot(cApprox_noi,'b');
title("Comparison FD orignal/noised image");


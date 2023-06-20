clear all; close all; clc;

% original corrupted image
im=im2double(imread('images/task_3_im.png'));
% fourier transform
imf = fftshift(fft2(im));

figure,
subplot(2,2,1),imshow(im),title('corrupted image');
subplot(2,2,2),fftshow(imf,'log'), impixelinfo, title('its Fourier transfrom');

% Applying filters to the locations of each cross (4 cross so 4 filters)
for i = 125:135
    for j = 145:175
        imf(j,i) = 0;
    end
end

for i = 375:395
    for j = 90:110
        imf(j,i) = 0;
    end
end

for i = 120:140
    for j = 400:420
        imf(j,i) = 0;
    end
end

for i = 380:390
    for j = 340:380
        imf(j,i) = 0;
    end
end
subplot(2,2,4),fftshow(imf,'log'), impixelinfo, title('Fourier transfrom with removed freq');

% cleaned image with inverse fourier transform
imclean = ifft2(imf);
subplot(2,2,3),fftshow(imclean,'log'), impixelinfo, title('Cleaned image');
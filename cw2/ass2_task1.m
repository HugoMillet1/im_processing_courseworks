close all; clear; clc;

% Part 1 : Construction of the blurred image
im_original = imread('images/einstein.jpg'); % original image
%im_original = rgb2gray(im_original); % converted in grayscale

%motion_kernel = double(imread('images/testkernel.png')); % h
motion_kernel = fspecial('gaussian', [15 15], 5); % Gaussian blur
motion_kernel = motion_kernel./sum(motion_kernel(:)); % h

blur = imfilter(im_original,motion_kernel,'conv','circular');

noise_mean = 0;
noise_var = 0.00001; % 10^{-5}

blur_and_noise = imnoise(blur,'gaussian',noise_mean,noise_var); % g

% Part 2 : Deblurring process
blur_and_noise_fft = psf2otf(blur_and_noise); % G (Fourier transform of blurred image)
motion_kernel_fft = psf2otf(motion_kernel, size(blur_and_noise)); % H (Fourier transform of blur filter)
motion_kernel_fft_conj = conj(motion_kernel_fft); % Hc Apply the conjugate to H
motion_kernel_fft_norm = abs(motion_kernel_fft); % |H| Keep the norm of H

restored_image_fft = (motion_kernel_fft_conj./(motion_kernel_fft_norm.^2+0.0005)).*blur_and_noise_fft; % Hc/(|H|^2+K)*G (Wiener filter formula)
restored_image = otf2psf(restored_image_fft); % Get back into normal domain
restored_image = real(restored_image);
%restored_image = restored_image-min(restored_image)/(max(restored_image)-min(restored_image))*255;
figure, imshow([im_original, blur_and_noise, restored_image]);

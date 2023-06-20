close all; clear; clc;

%h = double(imread('images/testkernel.png')); % motion blur
h = fspecial('gaussian', [15 15], 5); % Gaussian blur
h = h./sum(h(:));

blur = @(im) imfilter(im,h,'conv','circular');


% Gaussian noise
noise_mean = 0;
noise_var = 0.00001; % 10^{-5}

f = im2double(imread('images/barbara_face.png'));
g = imfilter(f,h,'conv','circular'); % blur
g = imnoise(g,'gaussian',noise_mean,noise_var); % adding noise

H = psf2otf(h,size(g));

psnr0 = psnr(f,g);
psnrRL = [psnr0];
psnrLw = [psnr0];
psnrISRA = [psnr0];

% Wiener deblurring
W = deconvwnr(g,h,0.0005);
figure,imshow([f,g,W]);title('original, blurred and noisy, Wiener deblur');

RL = g;
Lw = g;
ISRA = g;
G = fft2(g);
maxiter = 1000; 
for i = 1:maxiter
 %
 % Richardson-Lucy iterations: RL = RL.*[h(-x)*(g./(RL*h(x)))]
 RL = RL.*ifft2(fft2(g./blur(RL)).*conj(H));
 psnr_RL = psnr(RL,f);
 psnrRL = [psnrRL; psnr_RL];
 %disp(RL(12,5));
 %
 % Landweber iterations: Lw = Lw + h(-x)*(Lw-Lw*h(x))
 Lw = Lw + ifft2(conj(H).*(fft2(g-blur(Lw))));
 psnr_Lw = psnr(Lw,f);
 psnrLw = [psnrLw; psnr_Lw];
 %disp(Lw(12,5));
 % ISRA iterations
 ISRA = ISRA.*ifft2(conj(H).*G)./ifft2(conj(H).*fft2(blur(ISRA)));
 psnr_ISRA = psnr(ISRA, f);
 psnrISRA = [psnrISRA; psnr_ISRA];
 %
 fprintf('i = %d   psnr_RL = %f   psnr_Lw = %f   psnr_ISRA = %f\n', i, psnr_RL, psnr_Lw, psnr_ISRA);
 %
end

psnrW = psnr(W,f)*ones(maxiter,1);

figure,imshow([Lw,RL,ISRA]);title('Landweber, Richardson-Lucy and ISRA');

figure();
semilogy(psnrW,'LineWidth',1.5,'Color',[0,0,1]),axis([1 maxiter 0 25]); 
hold
semilogy(psnrLw,'LineWidth',1.5,'Color',[0,1,0]),axis([1 maxiter 0 25]);
semilogy(psnrRL,'LineWidth',1.5,'Color',[1,0,0]),axis([1 maxiter 0 25]);
semilogy(psnrISRA,'LineWidth',1.5,'Color',[1,1,0]),axis([1 maxiter 0 25]);
legend('Wiener', 'Landweber','Richardson-Lucy', 'ISRA');


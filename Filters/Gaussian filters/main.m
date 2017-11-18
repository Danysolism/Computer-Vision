% Read image from directory image_dir 
image_dir = 'Images';
im2 = imread(fullfile(image_dir, 'image.jpg'));
im = rgb2gray(im2)
figure(1);
imshow(im);

% Get 1D kernel
sigma = 1;
kernel_size = 127; 
G = gauss(sigma, kernel_size);

% Apply 1D kernel
f_im = imfilter(im, G);
figure(2);
imshow(f_im); 

% Apply 2D kernel
sigma_x = 1;
sigma_y = 1;
kernel_size_2d = 5;
imOut = gaussConv(im,sigma_x,sigma_y,kernel_size_2d);
figure(3);
imshow(imOut);

% Apply matlab built-in function for 2D 
figure(4);
imshow(imfilter(im, fspecial('gaussian', [1, 1], 5)));

% Apply Gaussian derivative
figure(5);
sigma = 1
imshow(gaussDer(im, G ,sigma));


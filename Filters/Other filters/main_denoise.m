% Read image from directory image_dir 
image_dir = 'Images';
im_rgb = imread(fullfile(image_dir, 'image2.jpeg'));
im = rgb2gray(im_rgb);

% Apply box denoise filter
imOut = denoise(im, 'box', 3);
figure(2);
imshow(imOut);
imOut = denoise(im, 'box', 5);
figure(3);
imshow(imOut);
imOut = denoise(im, 'box', 7);
figure(4);
imshow(imOut);
imOut = denoise(im, 'box', 9);
figure(5);
imshow(imOut);


% Apply median denoise filter
imOut = denoise(im, 'median', 3);
figure(6);
imshow(imOut);
imOut = denoise(im, 'median', 5);
figure(7);
imshow(imOut);
imOut = denoise(im, 'median', 7);
figure(8);
imshow(imOut);

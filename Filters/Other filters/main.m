% Read image from directory image_dir 
image_dir = 'Images';
reference = imread(fullfile(image_dir, 'reference.png'));
input = imread(fullfile(image_dir, 'input.png'));

image1_rgb = imread(fullfile(image_dir, 'image.jpg'));
image1 = rgb2gray(image1_rgb);
image3 = imread(fullfile(image_dir, 'image3.jpeg'));
image4 = imread(fullfile(image_dir, 'image4.jpeg'));

% Apply histogram matching 
myHistMatching(input, reference);

% Apply gradient
compute_gradient(image3);

% Apply unsharp masking
sigma = 1;
kernel_size = 17;
k = 10;
imOut = unsharp(image4, sigma, kernel_size, k);
figure(8);
imshow(imOut);

% Apply Laplacian
LOG_type = 'method1';
imOut = compute_LoG(image1, LOG_type);
figure(9);
imshow(imOut, []); % brackets because values in imOut are very small


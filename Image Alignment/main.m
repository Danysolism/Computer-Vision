run('vlfeat-0.9.20/toolbox/vl_setup')
% 1. Image alignment
image1 = imread('boat1.pgm');
image2 = imread('boat2.pgm');
left = imread('left.jpg');
right = imread('right.jpg');

% Call both transformations (im1-im2, im2-im1)
print = 1; % To print the plot
[m_params, t_params] = ransac(image1, image2, print);
%[m2_params, t2_params] = ransac(image2,image1,print);

% Get transformations after performing RANSAC
%transformation(m_params,t_params, image1);
%transformation(m2_params, t2_params, image2);

% Call built in matlab function
A_1 = [m_params(1), m_params(2);
m_params(3), m_params(4);
t_params(1), t_params(2)];
%A_2 = [m2_params(1), m2_params(2);
%m2_params(3), m2_params(4);
%t2_params(1), t2_params(2);
T_1 = maketform('affine', A_1);
%T_2 = maketform('affine', A_2);

%B_1 = imtransform(image1, T_1);
%B_2 = imtransform(image2, T_2);

% figure(10);
% imshow(B_1);

% 2. Image stitching
stitching(left, right);

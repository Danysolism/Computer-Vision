% 1. Harris Corner detection 

print = 1; % show image for part 1 of assigments

% Values for toy
image_dir_toy = 'person_toy';
image_toy = imread(fullfile(image_dir_toy, '00000001.jpg'));
sigma_toy = 1.3; % param for gaussian kernel
kernel_size_toy = 3; % param for gaussian kernel
window_size_toy = 3;
t_toy = 220; % value can be up to 255
smooth_toy = 0.75;

% Values for pingpong
image_dir_pp = 'pingpong';
image_pp = imread(fullfile(image_dir_pp, '0000.jpeg'));
sigma_pp = 1.05; % param for gaussian kernel 1.05
kernel_size_pp = 3; % param for gaussian kernel
window_size_pp = 25;
t_pp = 200; % value can be up to 255   200
smooth_pp = 1;  % 1

% Call for both images. Comment in/out.
%[H, corners] = harris_corner(image_toy, sigma_toy, kernel_size_toy, window_size_toy, t_toy, smooth_toy, print);
%[H, corners] = harris_corner(image_pp, sigma_pp, kernel_size_pp, window_size_pp, t_pp, smooth_pp, print);

% 2. Lucas-Kanade method

sphere1 = imread('sphere1.ppm');
sphere2 = imread('sphere2.ppm');

synth1 = imread('synth1.pgm');
synth2 = imread('synth2.pgm');

interesting_points = []; % empty to run lucas_kanade for part2

%lucas_kanade(sphere1, sphere2, interesting_points);
%lucas_kanade(synth1, synth2, interesting_points);

% 3. Tracking algorithm

KLT(image_dir_toy, sigma_toy, kernel_size_toy, window_size_toy, t_toy, smooth_toy, '*.jpg');
%KLT(image_dir_pp, sigma_pp, kernel_size_pp, window_size_pp, t_pp, smooth_pp, '*.jpeg');

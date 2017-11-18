function [im_magnitude ,im_direction] = compute_gradient(image)
    
    % Get matrices for convolution
    matrix_x = [-1 0 1 ; -2 0 2; -1 0 1];
    matrix_y = [1 2 1; 0 0 0 ; -1 -2 -1] ;
    
    % Apply convolution of matrices with image
    G_x = conv2(double(image), double(matrix_x));
    figure(4);
    imshow(G_x);
    G_y = conv2(double(image), double(matrix_y));
    figure(5);
    imshow(G_y);
    
    % Get magnitude and direction
    im_magnitude = sqrt(G_x.^2 + G_y.^2);
    figure(6);
    imshow(im_magnitude);
    im_direction = atan2(G_y,G_x)*180/pi;
    figure(7);
    imshow(im_direction);
   
end
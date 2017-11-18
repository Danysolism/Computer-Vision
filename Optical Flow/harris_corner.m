function [H, corners] = harris_corner(image_rgb, sigma, kernel_size, window_size, t, smooth, print)
    
    %Check if images are in rgb, if so change them to gray
   
    if (size(image_rgb, 3) == 3)
        image = rgb2gray(image_rgb);
    else
        image = image_rgb;
    end
    
    % We found a lot of wall noise, so smooth the image to make it better.
    % The smooth performed later does not remove this noise. Better do it
    % now.
    
    image = imgaussfilt(image, smooth);
    
    % Get Gaussian derivatives
    %two 1D Gaussians
    g_x = fspecial('gaussian',[1 kernel_size],sigma);
    g_y = fspecial('gaussian',[kernel_size 1],sigma);
    dg_x = gradient(g_x);
    dg_y = gradient(g_y);
    
    % Get smoothed derivatives
    image_x = imfilter(double(image), double(dg_x));
    image_y = imfilter(double(image), double(dg_y));
    
    % Get A, B and C
    A = imfilter(double(image_x.^2), double(g_x));
    B = imfilter(double(image_x.*image_y), double(g_x));
    C = imfilter(double(image_y.^2), double(g_y));
    
    % Compute H 
    k = 0.04;
    H = (A.*C - B.^2) - k*(A + C).^2; 
    
    threshold = mean(mean((H))) + t;
                 
    % Calculate maxima for each point
    % First, pad with zeroes
    p = floor(window_size / 2);
    H_padded = padarray(H, [p, p]);
    %Create mask to avoid considering the image borders as corners
    bordermask = zeros(size(H_padded));
    radius = 3 + p;
    bordermask(radius+1:end-radius, radius+1:end-radius) = 1;
    H_padded = H_padded .* bordermask;
  
    corners = [];
    
    for x=p:size(H_padded, 1) - p*2
        for y=p:size(H_padded, 2) - p*2
        %Apply window centered in (x, y)
           maximum = true; % indicates whether H(x, y) is the greatest in the window
           x;
           y;
           for i=1:window_size
                for j=1:window_size
                    if H_padded(x+i-1,y+j-1) > H_padded(x, y)
                        maximum = false;
                    end
                end
           end
           % Get the rows and the cols for the corners
           if (maximum == true) && (H_padded(x, y) > threshold) 
                corners = [corners; [x-p y-p]];
                
           end 
        end
    end
    
    if print == 1
    % Plot: image with derivatives in x and y and image with corner dots
%         figure(1);
%         imshow(image_x);
%         figure(2);
%         imshow(image_y);
        figure(3);
        imshow(image_rgb);
        hold on
        plot(corners(:, 2), corners(:, 1), 'r*');
    end

end
function [V_x, V_y] = lucas_kanade(image1, image2, corners)

    % 1. Preprocessing images
    
    % Check if images are in rgb, if so change them to gray
    if(size(image1, 3) == 3)
        image1 = rgb2gray(image1);
    end
    if(size(image2, 3) == 3)
        image2=rgb2gray(image2);
    end
    
    image1 = imgaussfilt(image1, 0.5);
    image2 = imgaussfilt(image2, 0.5);

    % 2. Get derivatives first of all, otherwise it does not get good results
    
    % Kernel for derivatives [-1 1] * 0.25
    derivative_kernel = [-0.25 0.25; -0.25 0.25]; 
    
    % Derivatives first image
    dx1=imfilter(double(image1), derivative_kernel);
    dy1=imfilter(double(image1), derivative_kernel'); % transpose kernel
    dt1=imfilter(double(image1), double(fspecial('gaussian', 2, 1)));
    
    % Derivatives for the second image
    dx2=imfilter(double(image2), derivative_kernel);
    dy2=imfilter(double(image2), derivative_kernel');
    dt2=imfilter(double(image2), double(fspecial('gaussian', 2, 1)));
    
    % Calculate change between two images
    fx = (dx1 + dx2) / 2;
    fy = (dy1 + dy2) / 2;
    ft = dt2 - dt1; % a change over time is a change in intensity in the actual pixels, derivatives return 0 when there is no change

    
    % 3. Get velocities
    
    if size(corners,1) > 0 % Loop only over list of corners
        
        % Pad derivative matrices to be able to calculate corners at the borders (or close)
        window_size = 25;
        p = floor(window_size / 2);
        fx_padded = padarray(fx, [p, p], 'replicate');
        fy_padded = padarray(fy, [p, p], 'replicate');
        ft_padded = padarray(ft, [p, p], 'replicate');
        
        % Initialise velocity matrices, only the middle points will be updated
        V_x = zeros(1, size(corners, 1));
        V_y = zeros(1, size(corners, 1));
        
        for n = 1:size(corners, 1)
            center_x = corners(n, 1) + p;
            center_y = corners(n, 2) + p;
            
            fx_region = (fx_padded((center_x - p : center_x + p), (center_y - p : center_y + p)))';  
            fy_region = (fy_padded((center_x - p : center_x + p), (center_y - p : center_y + p)))';
            ft_region = (ft_padded((center_x - p : center_x + p), (center_y - p : center_y + p)))';

            % Get A and b for this region 
            A = [fx_region(:) fy_region(:)];
            b = -ft_region(:);

            % Solve for velocity V (returns Vx and Vy)
            V = pinv(A' * A) * A' * b;

            % Store the velocity only for the middle pixel (i, j) (coord without padding)
            V_x(n) = V(1); % u
            V_y(n) = V(2); % v
            
        end

    else % Loop over the CENTERS of each region determined by window_size

        % Pad derivative matrices to be able to calculate corners at the borders (or close)
        window_size = 15;
        p = floor(window_size / 2);
        fx_padded = padarray(fx, [p, p], 'replicate');
        fy_padded = padarray(fy, [p, p], 'replicate');
        ft_padded = padarray(ft, [p, p], 'replicate');
        
        centers_x = floor(size(image1, 1) / window_size);
        centers_y = floor(size(image1, 2) / window_size); 

        V_x = zeros(size(image1));
        V_y = zeros(size(image1));
        
        for i = 0:centers_x - 1

            % Upadate coordinate x for center
            center_x = 8 + (window_size * i) + p;

            for j = 0:centers_y - 1

                % Update coordinate y for center
                center_y = 8 + (window_size * j) + p;

                % Select region 
                fx_region = (fx_padded((center_x - p : center_x + p), (center_y - p : center_y + p)))';  
                fy_region = (fy_padded((center_x - p : center_x + p), (center_y - p : center_y + p)))';
                ft_region = (ft_padded((center_x - p : center_x + p), (center_y - p : center_y + p)))';

                % Get A and b for this region 
                A = [fx_region(:) fy_region(:)];
                b = -ft_region(:);

                % Solve for velocity V (returns Vx and Vy)
                V = pinv(A' * A) * A' * b;

                % Store the velocity only for the middle pixel (i, j)
                V_x(center_x - p, center_y - p) = V(1); % u
                V_y(center_x - p, center_y - p) = V(2); % v

            end
        end
        
        % Plot vectors
        figure(1);
        imshow(image2);
        hold on 
        quiver(V_x, V_y, 20);

    end
end
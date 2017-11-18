function [m_params,t_params] = ransac(image1, image2, print)

    % Parameters
    n = 15;
    p = 3;
    
    % Get set of matches between region descriptors in each image
    [matches, f1,f2] = matching_points(image1, image2);

    % 4. RANSAC
    
    max_inliers = 0;
    best_param = zeros(6,1); % Stores the final params
    
    x_matches = ceil(f1(1,matches(1,:)));
    y_matches = ceil(f1(2,matches(1,:)));

    % Repeat N times
    for i=1:n

        % Get P randomly patches
        indices = randperm(size(matches, 2),p);
        picked_matches = matches(:, indices);
        
        x1 = round(f1(1,picked_matches(1,:)));
        y1 = round(f1(2,picked_matches(1,:)));
        
        x2 = round(f2(1,picked_matches(2,:)));
        y2 = round(f2(2,picked_matches(2,:)));
        
        % Generate A, b and x
        for j=1:p
            
            a = [x1(j), y1(j), 0, 0, 1, 0; 0, 0, x1(j), y1(j), 0, 1];

            if j == 1
                A = a;
                b = [x2(j); y2(j)];
            else
                A = [A; a];
                b = [b;x2(j);y2(j)];
            end

        end
        
        % Get parameters [m1, m2, m3, m4, t1, t2]' in vector x
        x = pinv(A)*b;  
        m_params = [x(1) , x(2); x(3), x(4)];
        t_params = [x(5); x(6)];

        % Get the transformed of image 1 with the parameters x
        x_transf = zeros(size(matches, 2), 1);
        y_transf = zeros(size(matches, 2), 1);
        
        for m=1:size(matches,2)
            temp = m_params * [x_matches(m); y_matches(m)] + t_params;
            x_transf(m) = round(temp(1));
            y_transf(m) = round(temp(2));
        end
        

        % Calulate inliers (10 pixel radius)
        
        % Get pairs in image 2 for the matches
        im2_x = (ceil(f2(1, matches(2,:))))'; 
        im2_y = (ceil(f2(2, matches(2,:))))'; 
        
        % Use Euclidean distance 
        distance = sqrt(((im2_x - x_transf).^ 2) + ((im2_y - y_transf).^ 2));
        inliers = find(distance <= 10);
        
        % If x is the new best, save it 
        if max_inliers < length(inliers)
            max_inliers = length(inliers);
            best_param = x;
            if print == 1 % print the matches
                plot_matches(image1, image2, matches, f1, x_transf, y_transf);
            end
        end

    end
    
    % Return best parameters
    m_params = [best_param(1) , best_param(2); best_param(3), best_param(4)];
    t_params = [best_param(5); best_param(6)];

end
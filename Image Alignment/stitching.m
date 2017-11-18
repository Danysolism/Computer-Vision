function stitching(left, right)
    
    left = rgb2gray(left);
    right = rgb2gray(right);
    [m, t] = ransac(right, left, 0);
    
    % Apply transformation for right image
    A = [m(1), m(2); m(3), m(4);t(1), t(2)];
    T = maketform('affine', A);
    right_transformed = imtransform(right, T);

    % Find the the image size for the transformed image by corner positions
    
    [rows_right, columns_right] = size(right);

    % Find corners for image 1
    up_left = [1,1];
    up_right = [columns_right,1];
    down_left = [1,rows_right];
    down_right = [columns_right, rows_right];

    % Get the transfromed corners
    transf_up_left = round(m * up_left' + t);
    transf_up_right = round(m * up_right' + t);
    transf_down_left = round(m * down_left' + t);
    transf_down_right = round(m * down_right' + t);

    % Calculate size of transformed image
    rows = [transf_up_left(2), transf_up_right(2), transf_down_left(2), transf_down_right(2) ];
    columns = [transf_up_left(1), transf_up_right(1), transf_down_left(1), transf_down_right(1) ];

    min_row = min(rows); 
    max_row = max(rows);
    min_column = min(columns);
    max_column = max(columns);

    % Get estimated size
    st_rows = ceil(size(right_transformed, 1) + t(2)) + 1;
    st_cols = ceil(size(right_transformed, 2) + t(1)) + 1;
    
    % Initialise final stitched image
    stitched_image = zeros(st_rows, st_cols);
    
    % Put image 1 (left) in the stitched image
    stitched_image(1:size(left, 1),1:size(left, 2)) = left;
    
    % Put the transformed image in the stitched image
    for i=1:size(right_transformed,2) % columns
        for j=1:size(right_transformed,1) % rows
            % Get shifted coordinates to access the stitched image
            i_t = i + abs(min_column);
            j_t = j + abs(min_row);
            if right_transformed(j,i) > 0 % to avoid black pixel in the transformed 
                if stitched_image(j_t, i_t) == 0 % if black pixel put directly transformed value
                    stitched_image(j_t, i_t) = right_transformed(j, i);
                else % else calculate average between the stitched and the transformed (overlap)
                    stitched_image(j_t, i_t) = (stitched_image(j_t, i_t) + right_transformed(j,i)) / 2;
                end
            end
        end
    end
    
    % Show final image
    figure(6);
    imshow(stitched_image,[]);

end

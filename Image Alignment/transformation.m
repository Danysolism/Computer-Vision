function[transformed_image] = transformation(m, t, image)

    % Find the the image size for the transformed image by corner positions
    [rows_im,columns_im] = size(image);

    % Find corners
    up_left = [1,1];
    up_right = [columns_im,1];
    down_left = [1,rows_im];
    down_right = [column_ims, rows_im];

    % Get the transfromed corners
    transf_up_left = round(m * up_left' + t);
    transf_up_right =round(m * up_right' + t);
    transf_down_left = round(m * down_left' + t);
    transf_down_right = round(m * down_right' + t);

    % Calculate size of transformed image
    rows = [transf_up_left(2), transf_up_right(2), transf_down_left(2), transf_down_right(2)];
    columns = [transf_up_left(1), transf_up_right(1), transf_down_left(1), transf_down_right(1)];

    min_row = min(rows); 
    max_row = max(rows);
    min_column = min(columns);
    max_column = max(columns);

    % Initialise the transformed image
    transformed_image = zeros (max_row - min_row, max_column - min_column);

    % Calculate shift to fit the image in the initialised transformed image
    shift = [min_column - 1; min_row - 1];

    % Apply transformation in all pixels
    for i=1:size(image,2) % columns
        for j=1:size(image, 1) % rows
            % Shift the result to fit it
            new = round(m * [i;j] + t) - shift; % returns [x y] = [c r]
            if new(2) > 0 && new(1) > 0 % only transform coordintes inside the image
                transformed_image(new(2), new(1)) = image(j, i);
            end
        end
    end

    % Fill in black pixel with Nearest Neighbours. Go over the image in
    % windows and for every black pixel change its value to the median of
    % the window
    
    window_size = 5; % value that gives best result (also tried 3 and 7)
    pad = floor(window_size / 2); % pad image to be able to apply windows 
    image_padded = padarray(transformed_image, [pad, pad],'replicate');

    for i= 1:size(transformed_image,2) % columns
        for j= 1: size(transformed_image, 1) % rows
            if transformed_image(j,i) == 0 % pixel is black
                % Select region in padded 
                region = (image_padded((j:j + 2 * pad),(i:i + pad * 2)))';
                transformed_image(j,i) = median(median(region)); % get median of median vector
            end
        end
    end

    % Show the original and the transformed
    figure(3);
    subplot(1,2,1), imshow(image); axis image;
    subplot(1,2,2), imshow(transformed_image,[]); axis image;
    truesize
end

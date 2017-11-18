function imOut = denoise(image, kernel_type, kernel_size)
    pad = kernel_size - 1
    if strcmp(kernel_type, 'box')
        kernel = zeros(kernel_size);
        kernel(:) = 1/(kernel_size^2);
        imOut = imfilter(image, kernel);
    else
        % Add zeroes to image to be able to calculate for the pixels in first/last rows/cols
        padded_im = zeros(size(image) + pad);
        imOut = zeros(size(image));
        % Copy original matrix into padded matrix
        for i=1:size(image,1)
            for j=1:size(image,2)
                padded_im(i + 1, j + 1) = image(i,j);
            end
        end
        % Create array of neighbours to sort it and get median
        % Neighbours matrix is kernel_size x kernel_size
        for i=1:size(padded_im,1) - pad
            for j=1:size(padded_im,2) - pad
                neighbours = zeros(kernel_size^2, 1); % initialise neighbours
                pos = 1; % counter for position of array
                % Go through image in matrix-shape but store in the array
                for x = 1:kernel_size
                    for y=1:kernel_size
                        neighbours(pos) = padded_im(i+x-1,j+y-1);
                        pos = pos + 1;
                    end
                end
                % sort array
                median = sort(neighbours);
                % put median element in final image for that pixel
                imOut(i,j) = median(floor((length(neighbours) / 2)) + 1);
            end
        end
        % convert image back to uint8 (0-255 range)
        imOut = uint8(imOut);
    end
    
end
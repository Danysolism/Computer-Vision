function [matches, frame1, frame2] = matching_points(image1, image2)
   
    % 0. Preprocessing images

    % Check if images are in rgb, if so change them to gray
    if(size(image1, 3) == 3)
        image1 = single(rgb2gray(image1));
    else
        image1 = single(image1);
    end
    
    if(size(image2, 3) == 3)
        image2 = single(rgb2gray(image2));
    else
        image2 = single(image2);
    end

    % 1. Detect interest points in images
    [frame1, d1] = vl_sift(image1);
    [frame2, d2] = vl_sift(image2);

    % 2, 3. Get set of matches between region descriptors in each image
    [matches, ~] = vl_ubcmatch(d1, d2);
end
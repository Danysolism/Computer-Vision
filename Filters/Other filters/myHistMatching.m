function imOut = myHistMatching(input, reference)
    
    % Stores map for the histogram matching
    map = zeros(256,1,'uint8'); 
    
    % Compute histograms and cummulative distributions cdf for each image
    input_hist = imhist(input); 
    reference_hist = imhist(reference);
    input_cdf = cumsum(input_hist) / numel(input); 
    ref_cdf = cumsum(reference_hist) / numel(reference);

    % Calculate the map by subtracting values and getting the minimum abs value
    % from the vector 
    for i = 1 : 256
        [value,index] = min(abs(input_cdf(i) - ref_cdf));
        map(i) = index - 1; % get index in range 0 - 255
    end
    
    % Apply mapping to the input image
    imOut = map(double(input)+1); % Add 1 to get index in range 1 - 256
    
    % Plot figures
    subplot(121);
    imshow(input);
    title('Input image');
    subplot(122);
    imhist(input);
    pause;
    subplot(121);
    imshow(reference);
    title('Reference image');
    subplot(122);
    imhist(reference);
    pause;
    subplot(121);
    imshow(imOut);
    title('Transformed image');
    subplot(122);
    imhist(imOut);
    
end
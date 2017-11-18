function imOut = compute_LoG(image, LOG_type)
    
    if strcmp(LOG_type, 'method1')
        sigma = 1;
        kernel_size = 5;
        gauss_kernel = fspecial('gaussian', kernel_size, sigma);
        gauss_image = imfilter(double(image), double(gauss_kernel));
        laplacian_kernel = fspecial('laplacian');
        imOut = imfilter(double(gauss_image), double(laplacian_kernel));        
        
    elseif strcmp(LOG_type, 'method2') % directly applies the LoG filter
        log_kernel = fspecial('log', 3, 1); % kernel size = 3, sigma = 1
        imOut = imfilter(double(image), double(log_kernel));
        
    else % method3
        sigma_1 = 1.2;
        kernel_size = 5;
        gauss_kernel_1 = fspecial('gaussian', kernel_size, sigma_1);
        imOut_1 = imfilter(double(image), double(gauss_kernel_1));
        sigma_2 = 0.75;
        gauss_kernel_2 = fspecial('gaussian', kernel_size, sigma_2);
        imOut_2 = imfilter(double(image), double(gauss_kernel_2));
        imOut = imOut_1 - imOut_2;
    end

end

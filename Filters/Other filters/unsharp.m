function imOut = unsharp(image , sigma , kernel_size , k) 

    gauss_kernel = fspecial('gaussian', kernel_size, sigma);
    gauss_image = imfilter(image, gauss_kernel);
    
    high_passed = image - gauss_image;
    
    imOut = image + high_passed * k;

end
function imOut = gaussConv(image,sigma_x,sigma_y,kernel_size)

G_x = gauss(sigma_x, kernel_size);
G_y = gauss(sigma_y, kernel_size);
C = conv2(G_x, G_y);

imOut = imfilter(image, C);
end
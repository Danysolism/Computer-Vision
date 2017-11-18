function [imOut Gd] = gaussDer(image, G ,sigma)

Gd = zeros(size(G));

% Fill the kernel
for i=1:floor(size(G, 1)/2)
    Gd(floor(size(G, 1)/2) + 1 + i) = - (i / sigma^2) * G(floor(size(G, 1)/2) + 1 + i);
    Gd((floor(size(G, 1)/2) + 1 - i)) = - (-i / sigma^2) * G((floor(size(G, 1)/2) + 1 - i));
end

Gd = Gd./sum(Gd);
imOut = imfilter(image, Gd, 'symmetric');

end
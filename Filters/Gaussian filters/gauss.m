function [ G ] = gauss( sigma, kernel_size )

G = zeros(kernel_size, 1);

% Fill first value in the middle
G(floor(kernel_size/2) + 1) = (1/sigma*sqrt(2*pi));

% Fill the kernel
for i=1:floor(kernel_size/2)
    G(floor(kernel_size/2) + 1 + i) = (1/sigma*sqrt(2*pi))*exp(-i^2/2*sigma^2);
    G((floor(kernel_size/2) + 1 - i)) = (1/sigma*sqrt(2*pi))*exp(-(-i)^2/2*sigma^2);
end

% Normalise between 0 and 1

G = G./sum(G);

end


function plot_matches(image1, image2, matches, f1, x_transf, y_transf)
    
    % Plot a random subset of matches
    im1_x = round(f1(1,matches(1,:)));
    im1_y = round(f1(2,matches(1,:)));

    k = 50; %Number of matches to plot
    indices = randperm(size(im1_x,2),k);
    
    im1_x = im1_x(indices);
    im1_y = im1_y(indices);
    x_trf = x_transf(indices);
    y_trf = y_transf(indices);
    figure(2) ; clf ;
    imagesc(cat(2, image1, image2));
    colormap(gray);

    hold on ;
    x_trf = x_trf + size(image1,2);
    h = line([im1_x ; x_trf'], [im1_y ; y_trf']);
    set(h,'linewidth', 1, 'color', 'b');

    vl_plotframe([im1_x; im1_y]);
    vl_plotframe([x_trf' ; y_trf']);
    axis image off;
    vl_demo_print('sift_match_2', 1);
    
end